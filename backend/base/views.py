from rest_framework import viewsets, permissions
from rest_framework.response import Response
from rest_framework import status
from rest_framework.permissions import IsAuthenticated
from .models import Program, Appointment, FAQ, ExamScore, ExamResult, TestSession, TestCenter, TestRoom, Announcement
from .serializers import (
    ProgramSerializer, AppointmentSerializer, FAQSerializer, TestSessionSerializer, 
    TestCenterSerializer, TestRoomSerializer, AnnouncementSerializer, ExamScoreDetailSerializer
)
from rest_framework.decorators import action, api_view, permission_classes
import csv
import io
import json
from django.http import HttpResponse
from django.template.loader import get_template
from django.views.decorators.csrf import csrf_exempt
from xhtml2pdf import pisa
from io import BytesIO
from django.utils import timezone
from datetime import datetime, date
from django.db.models import Sum
from django.db.models import Q, Count
from django.contrib.auth.hashers import make_password
from django.db import transaction
import pandas as pd
import math
import random
import string
from .notification_utils import send_test_details_notification

class ProgramViewSet(viewsets.ModelViewSet):
    queryset = Program.objects.all()
    serializer_class = ProgramSerializer

    def list(self, request):
        queryset = self.get_queryset()
        serializer = self.get_serializer(queryset, many=True)
        # Return the data directly as an array
        return Response(serializer.data)

    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        if serializer.is_valid():
            self.perform_create(serializer)
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def update(self, request, *args, **kwargs):
        instance = self.get_object()
        serializer = self.get_serializer(instance, data=request.data, partial=True)
        if serializer.is_valid():
            self.perform_update(serializer)
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class AppointmentViewSet(viewsets.ModelViewSet):
    queryset = Appointment.objects.all()
    serializer_class = AppointmentSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        # If an admin user is performing the request, return all appointments
        if self.request.user.is_staff or self.request.user.is_superuser:
            return Appointment.objects.all()
        # Otherwise, only return appointments for the current authenticated user
        return Appointment.objects.filter(email=self.request.user.email)

    def list(self, request):
        queryset = self.get_queryset()
        serializer = self.get_serializer(queryset, many=True)
        return Response(serializer.data)

    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        if serializer.is_valid():
            try:
                program_id = serializer.validated_data.get('program').id
                program = Program.objects.get(id=program_id)
                
                # Check capacity
                capacity_limit = program.capacity_limit
                existing_appointments = Appointment.objects.filter(
                    program_id=program_id,
                    preferred_date=serializer.validated_data.get('preferred_date'),
                    time_slot=serializer.validated_data.get('time_slot'),
                    status__in=['pending', 'approved', 'rescheduled', 'waiting_for_test_details', 'waiting_for_submission', 'submitted']
                ).count()
                
                if existing_appointments >= capacity_limit:
                    return Response(
                        {"error": f"This date and time slot has reached its capacity limit of {capacity_limit}."},
                        status=status.HTTP_400_BAD_REQUEST
                    )
                
                # Auto-approve if the program has auto-approve enabled
                if program.auto_approve_appointments:
                    serializer.validated_data['status'] = 'waiting_for_submission'
                
                # Create the appointment
                self.perform_create(serializer)
                return Response(serializer.data, status=status.HTTP_201_CREATED)
                
            except Program.DoesNotExist:
                return Response(
                    {"error": "Program not found."},
                    status=status.HTTP_404_NOT_FOUND
                )
            except Exception as e:
                return Response(
                    {"error": f"An error occurred: {str(e)}"},
                    status=status.HTTP_500_INTERNAL_SERVER_ERROR
                )
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def update(self, request, *args, **kwargs):
        partial = kwargs.pop('partial', False)
        instance = self.get_object()
        
        # Store original status for comparison
        original_status = instance.status
        # Store original test_room for room capacity update
        original_test_room = instance.test_room
        
        serializer = self.get_serializer(instance, data=request.data, partial=partial)
        if serializer.is_valid():
            # Perform the update
            updated_instance = self.perform_update(serializer)
            
            # Check if status was changed to 'rescheduled'
            new_status = updated_instance.status
            room_updated = False
            response_data = serializer.data
            
            if original_status != 'rescheduled' and new_status == 'rescheduled' and original_test_room:
                try:
                    # Decrease room count as this room is now available
                    room = original_test_room
                    room.assigned_count = max(0, room.assigned_count - 1)
                    room.available_capacity = room.capacity - room.assigned_count
                    room.save()
                    print(f"Room capacity updated: {room.name}, assigned_count={room.assigned_count}, available_capacity={room.available_capacity}")
                    
                    # Add room update information to the response
                    response_data = dict(serializer.data)
                    response_data['room_updated'] = True
                    response_data['room_name'] = room.name
                    response_data['room_assigned_count'] = room.assigned_count
                    response_data['room_available_capacity'] = room.available_capacity
                    
                except Exception as e:
                    print(f"Error updating room capacity: {str(e)}")
            
            return Response(response_data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def perform_create(self, serializer):
        serializer.save(user=self.request.user, email=self.request.user.email)
        
    def perform_update(self, serializer):
        instance = serializer.save()
        return instance

    @action(detail=False, methods=['POST'])
    def import_scores(self, request):
        """
        Import scores from a CSV file with multiple test part columns
        """
        if 'file' not in request.FILES:
            return Response({'error': 'No file provided'}, status=400)
        
        csv_file = request.FILES['file']
        exam_type = request.data.get('examType', '')
        
        # Process the CSV file
        try:
            # Read the CSV file
            csv_text = csv_file.read().decode('utf-8')
            csv_reader = csv.reader(io.StringIO(csv_text))
            
            # Get header row to identify columns
            headers = next(csv_reader)
            headers = [h.lower().strip() for h in headers]
            
            # Find column indices
            col_indices = {
                'app_no': headers.index('app_no') if 'app_no' in headers else None,
                'name': headers.index('name') if 'name' in headers else None,
                'school': headers.index('school') if 'school' in headers else None,
                'date': headers.index('date') if 'date' in headers else None,
                'part1': headers.index('part1') if 'part1' in headers else None,
                'part2': headers.index('part2') if 'part2' in headers else None,
                'part3': headers.index('part3') if 'part3' in headers else None,
                'part4': headers.index('part4') if 'part4' in headers else None,
                'part5': headers.index('part5') if 'part5' in headers else None,
                'oapr': headers.index('oapr') if 'oapr' in headers else None,
            }
            
            # Ensure required columns exist
            if col_indices['name'] is None or col_indices['school'] is None:
                return Response({'error': 'CSV must include name and school columns'}, status=400)
            
            # Track results
            matched_count = 0
            unmatched_count = 0
            updated_count = 0
            created_count = 0
            
            for row in csv_reader:
                if len(row) < 2:
                    continue  # Skip rows without enough columns
                    
                name = row[col_indices['name']].strip() if col_indices['name'] is not None and col_indices['name'] < len(row) else ''
                school = row[col_indices['school']].strip() if col_indices['school'] is not None and col_indices['school'] < len(row) else ''
                app_no = row[col_indices['app_no']].strip() if col_indices['app_no'] is not None and col_indices['app_no'] < len(row) else ''
                
                # Extract all test part scores
                part1 = row[col_indices['part1']].strip() if col_indices['part1'] is not None and col_indices['part1'] < len(row) else ''
                part2 = row[col_indices['part2']].strip() if col_indices['part2'] is not None and col_indices['part2'] < len(row) else ''
                part3 = row[col_indices['part3']].strip() if col_indices['part3'] is not None and col_indices['part3'] < len(row) else ''
                part4 = row[col_indices['part4']].strip() if col_indices['part4'] is not None and col_indices['part4'] < len(row) else ''
                part5 = row[col_indices['part5']].strip() if col_indices['part5'] is not None and col_indices['part5'] < len(row) else ''
                oapr = row[col_indices['oapr']].strip() if col_indices['oapr'] is not None and col_indices['oapr'] < len(row) else ''
                
                # Parse date if present
                exam_date = None
                if col_indices['date'] is not None and col_indices['date'] < len(row):
                    date_str = row[col_indices['date']].strip()
                    try:
                        # Try different date formats
                        exam_date = datetime.strptime(date_str, '%Y-%m-%d').date()
                    except ValueError:
                        try:
                            exam_date = datetime.strptime(date_str, '%m/%d/%Y').date()
                        except ValueError:
                            pass
                
                # Try to find a matching appointment
                matching_appointments = Appointment.objects.filter(
                    full_name__iexact=name,
                    school_name__iexact=school,
                    status='submitted'  # Only match submitted appointments
                )
                
                if matching_appointments.exists():
                    # Update or create exam score for each match
                    for appointment in matching_appointments:
                        score_obj, created = ExamScore.objects.update_or_create(
                            appointment=appointment,
                            defaults={
                                'app_no': app_no,
                                'name': name,
                                'school': school,
                                'score': oapr,  # Use OAPR as main score
                                'part1': part1,
                                'part2': part2,
                                'part3': part3,
                                'part4': part4,
                                'part5': part5,
                                'oapr': oapr,
                                'exam_date': exam_date,
                                'exam_type': exam_type,
                                'imported_by': request.user
                            }
                        )
                        
                        if created:
                            matched_count += 1
                        else:
                            updated_count += 1
                else:
                    # Create unmatched score
                    ExamScore.objects.create(
                        appointment=None,
                        app_no=app_no,
                        name=name,
                        school=school,
                        score=oapr,  # Use OAPR as main score
                        part1=part1,
                        part2=part2,
                        part3=part3,
                        part4=part4,
                        part5=part5,
                        oapr=oapr,
                        exam_date=exam_date,
                        exam_type=exam_type,
                        imported_by=request.user
                    )
                    created_count += 1
                    unmatched_count += 1
            
            return Response({
                'success': True,
                'matched': matched_count,
                'updated': updated_count,
                'unmatched': unmatched_count,
                'created_count': created_count
            })
            
        except Exception as e:
            return Response({'error': str(e)}, status=400)

class FAQViewSet(viewsets.ModelViewSet):
    queryset = FAQ.objects.all().order_by('order', '-created_at')
    serializer_class = FAQSerializer
    permission_classes = [permissions.IsAdminUser]  # Only admin users can manage FAQs

    def get_permissions(self):
        if self.action == 'list':
            return [permissions.AllowAny()]  # Anyone can view FAQs
        return [permissions.IsAdminUser()]  # Only admin users can create/update/delete FAQs

sample_faqs = [
    {
        "question": "How do I schedule a counseling appointment?",
        "answer": "You can schedule a counseling appointment through our online portal. Simply log in to your account, click on 'Schedule Appointment', select your preferred counselor and available time slot, and confirm your booking. You'll receive a confirmation email with the details.",
        "category": "Appointments",
        "icon": "fas fa-calendar-alt",
        "order": 1,
        "is_active": True
    },
    {
        "question": "What mental health services are available for students?",
        "answer": "We offer a comprehensive range of mental health services including: individual counseling, group therapy sessions, crisis intervention, stress management workshops, and mental health awareness programs. All services are confidential and provided by licensed professionals.",
        "category": "Services",
        "icon": "fas fa-hand-holding-heart",
        "order": 2,
        "is_active": True
    },
    {
        "question": "Is the counseling service confidential?",
        "answer": "Yes, all counseling services are strictly confidential. Your privacy is protected by law and professional ethics. Information will only be shared in cases of immediate danger to yourself or others, or when required by law.",
        "category": "Privacy",
        "icon": "fas fa-user-shield",
        "order": 3,
        "is_active": True
    },
    {
        "question": "What should I do in case of a mental health emergency?",
        "answer": "For immediate mental health emergencies: 1) Call our 24/7 crisis hotline at 1-800-XXX-XXXX, 2) Visit the nearest emergency room, or 3) Contact campus security at XXX-XXXX. During office hours, you can also walk in to our counseling center for immediate assistance.",
        "category": "Emergency",
        "icon": "fas fa-exclamation-circle",
        "order": 4,
        "is_active": True
    },
    {
        "question": "How long are counseling sessions?",
        "answer": "Individual counseling sessions typically last 50 minutes. Group sessions may run longer, usually 90 minutes. The frequency of sessions will be determined based on your needs and in consultation with your counselor.",
        "category": "Services",
        "icon": "fas fa-clock",
        "order": 5,
        "is_active": True
    },
    {
        "question": "Do you offer online counseling services?",
        "answer": "Yes, we provide teletherapy services through our secure video conferencing platform. This option is available for students who prefer remote sessions or are unable to attend in-person appointments. The same confidentiality standards apply to online sessions.",
        "category": "Services",
        "icon": "fas fa-video",
        "order": 6,
        "is_active": True
    },
    {
        "question": "What is the cancellation policy?",
        "answer": "Please notify us at least 24 hours in advance if you need to cancel or reschedule your appointment. Repeated late cancellations or no-shows may affect your ability to schedule future appointments.",
        "category": "Appointments",
        "icon": "fas fa-calendar-times",
        "order": 7,
        "is_active": True
    },
    {
        "question": "Are there any fees for counseling services?",
        "answer": "Most counseling services are covered by your student health fees. Some specialized programs or extended services may have additional costs. Please check with our office or your insurance provider for specific coverage details.",
        "category": "General",
        "icon": "fas fa-dollar-sign",
        "order": 8,
        "is_active": True
    }
]

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def import_exam_results(request):
    """
    Import exam results from a CSV file
    """
    try:
        data = request.data
        exam_type = data.get('examType')
        results = data.get('results', [])
        
        # Delete existing results for this exam type if overwrite is true
        if data.get('overwrite', False):
            ExamResult.objects.filter(exam_type=exam_type).delete()        # Create new exam results
        created_count = 0
        exam_year = data.get('year')
        for result in results:
            # Convert the serial number to integer if possible
            try:
                serial_no = int(result.get('no'))
            except (ValueError, TypeError):
                serial_no = None
                
            ExamResult.objects.create(                serial_no=serial_no,
                app_no=result.get('appNo', ''),
                name=result.get('name', ''),
                school=result.get('school', ''),
                exam_type=exam_type,
                year=exam_year,
                imported_by=request.user
            )
            created_count += 1
            
        return Response({
            'success': True,
            'message': f'Successfully imported {created_count} records',
            'count': created_count
        }, status=status.HTTP_201_CREATED)
        
    except Exception as e:
        return Response({'error': str(e)}, status=status.HTTP_400_BAD_REQUEST)

@api_view(['GET'])
def get_exam_results(request):
    """
    Get exam results with optional filtering
    """
    exam_type = request.query_params.get('exam_type', None)
    exam_year = request.query_params.get('exam_year', None)
    
    queryset = ExamResult.objects.all()
    
    if exam_type:
        queryset = queryset.filter(exam_type=exam_type)
        
    if exam_year:
        queryset = queryset.filter(year=exam_year)
        
    results = queryset
    
    # Convert to list of dictionaries
    data = []
    for result in results:        data.append({
            'id': result.id,
            'no': result.serial_no if result.serial_no is not None else 0,
            'appNo': result.app_no,
            'name': result.name,
            'school': result.school,
            'examType': result.exam_type,
            'year': result.year,
            'importedDate': result.created_at.isoformat()
        })
    
    return Response(data)

@api_view(['POST'])
@csrf_exempt
def create_appointment(request):
    """
    Create a new appointment with application form data
    """
    if request.method == 'POST':
        try:
            data = request.data
            
            # Get the program instance
            program_id = data.get('program')
            try:
                program = Program.objects.get(id=program_id)
            except Program.DoesNotExist:
                return Response({'error': 'Program not found'}, status=404)
                
            # Check capacity
            capacity_limit = program.capacity_limit
            existing_appointments = Appointment.objects.filter(
                program_id=program_id,
                preferred_date=data.get('preferred_date'),
                time_slot=data.get('time_slot'),
                status__in=['pending', 'approved', 'rescheduled', 'waiting_for_test_details', 'waiting_for_submission', 'submitted']
            ).count()
            
            if existing_appointments >= capacity_limit:
                return Response({
                    "error": f"This date and time slot has reached its capacity limit of {capacity_limit}."
                }, status=400)
            
            # Create the appointment
            appointment = Appointment(
                program=program,
                full_name=data.get('full_name'),
                email=data.get('email'),
                contact_number=data.get('contact_number'),
                school_name=data.get('school_name'),
                college_level=data.get('college_level', ''),
                preferred_date=data.get('preferred_date'),
                time_slot=data.get('time_slot'),
                status='waiting_for_test_details',
                
                # Personal Info
                birth_month=data.get('birth_month'),
                birth_day=data.get('birth_day'),
                birth_year=data.get('birth_year'),
                gender=data.get('gender'),
                age=data.get('age'),
                home_address=data.get('home_address'),
                citizenship=data.get('citizenship'),
                
                # WMSUCET Experience
                is_first_time=data.get('is_first_time', True),
                times_taken=data.get('times_taken'),
                
                # Applicant Type
                applicant_type=data.get('applicant_type'),
                high_school_code=data.get('high_school_code'),
                
                # School Info
                school_graduation_date=data.get('school_graduation_date'),
                school_address=data.get('school_address'),
                college_course=data.get('college_course'),
                college_type=data.get('college_type'),
                
                # Link to user if authenticated
                user=request.user if request.user.is_authenticated else None
            )
            
            # Auto-approve if program has auto_approve_appointments enabled
            if program.auto_approve_appointments:
                appointment.status = 'waiting_for_submission'
                
            appointment.save()
            
            return Response({
                'id': appointment.id,
                'status': appointment.status,
                'message': 'Appointment created successfully'
            }, status=201)
            
        except Exception as e:
            return Response({'error': str(e)}, status=400)
            
    return Response({'error': 'Method not allowed'}, status=405)

@csrf_exempt
def generate_pdf(request):
    if request.method == 'POST':
        # Get form data from request
        form_data = json.loads(request.POST.get('form_data'))
        
        # Load your HTML template
        template = get_template('application_form_template.html')
        
        # Render template with context
        html = template.render({'form_data': form_data})
        
        # Create PDF
        result = BytesIO()
        pdf = pisa.pisaDocument(BytesIO(html.encode("UTF-8")), result)
        
        if not pdf.err:
            # Return PDF as downloadable attachment
            response = HttpResponse(result.getvalue(), content_type='application/pdf')
            response['Content-Disposition'] = 'attachment; filename="WMSU-CET-Application.pdf"'
            return response
        
        return HttpResponse("Error generating PDF", status=500)
    
    return HttpResponse("Method not allowed", status=405)

@api_view(['GET'])
def program_list(request):
    """
    List all active programs
    """
    programs = Program.objects.all()
    serializer = ProgramSerializer(programs, many=True)
    return Response(serializer.data)  # This should return an array of programs

class TestSessionViewSet(viewsets.ModelViewSet):
    queryset = TestSession.objects.all()
    serializer_class = TestSessionSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        # If an admin user is performing the request, return all test sessions
        if self.request.user.is_staff or self.request.user.is_superuser:
            return TestSession.objects.all()
        # Otherwise, return only active sessions
        return TestSession.objects.filter(status='SCHEDULED')

    def perform_create(self, serializer):
        serializer.save(created_by=self.request.user)
        
    def update(self, request, *args, **kwargs):
        partial = kwargs.pop('partial', False)
        instance = self.get_object()
        serializer = self.get_serializer(instance, data=request.data, partial=partial)
        
        if serializer.is_valid():
            # Check if status is being updated to COMPLETED
            is_status_completed = 'status' in serializer.validated_data and serializer.validated_data['status'] == 'COMPLETED'
            old_status_not_completed = instance.status != 'COMPLETED'
            
            # Save the updated instance
            self.perform_update(serializer)
            
            # If status changed to COMPLETED, reset room availability
            if is_status_completed and old_status_not_completed:
                self.reset_room_availability(instance)
                
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    def reset_room_availability(self, test_session):
        """Reset room availability for rooms assigned to this test session."""
        try:
            # Get all appointments for this test session
            appointments = Appointment.objects.filter(test_session=test_session)
            
            # Group appointments by room to count how many to remove from each room
            room_counts = {}
            for appointment in appointments:
                if appointment.test_room:
                    room_id = appointment.test_room.id
                    if room_id not in room_counts:
                        room_counts[room_id] = 0
                    room_counts[room_id] += 1
            
            # Update each room's availability
            for room_id, count in room_counts.items():
                try:
                    room = TestRoom.objects.get(id=room_id)
                    # Reset assigned count and recalculate available capacity
                    room.assigned_count = max(0, room.assigned_count - count)
                    room.available_capacity = room.capacity - room.assigned_count
                    room.save()
                    print(f"Reset availability for room {room.name}, removed {count} assignments")
                except TestRoom.DoesNotExist:
                    print(f"Room with ID {room_id} not found when resetting availability")
                except Exception as e:
                    print(f"Error updating room {room_id}: {str(e)}")
            
            print(f"Successfully reset room availability for test session {test_session.id}")
            return True
        except Exception as e:
            print(f"Error resetting room availability: {str(e)}")
            import traceback
            traceback.print_exc()
            return False

class TestCenterViewSet(viewsets.ModelViewSet):
    queryset = TestCenter.objects.all()
    serializer_class = TestCenterSerializer
    permission_classes = [IsAuthenticated]

    def perform_create(self, serializer):
        serializer.save()

    @action(detail=True, methods=['GET'])
    def rooms(self, request, pk=None):
        """Get all rooms for a specific test center"""
        test_center = self.get_object()
        rooms = TestRoom.objects.filter(test_center=test_center)
        serializer = TestRoomSerializer(rooms, many=True)
        return Response(serializer.data)

class TestRoomViewSet(viewsets.ModelViewSet):
    queryset = TestRoom.objects.all()
    serializer_class = TestRoomSerializer
    permission_classes = [IsAuthenticated]

    def perform_create(self, serializer):
        instance = serializer.save()
        # Force calculate available_capacity correctly on creation
        instance.available_capacity = instance.capacity - instance.assigned_count
        instance.save()

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def count_pending_applications(request):
    """Count applications that need to be assigned to test sessions"""
    # Count applications that are approved but not assigned to a test session
    count = Appointment.objects.filter(
        status='waiting_for_test_details',
        test_session__isnull=True
    ).count()
    
    return Response({'count': count})

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def auto_assign_test_details(request):
    """
    Automatically assign test session, center, and room to approved applications
    """
    try:
        data = request.data
        print(f"AUTO-ASSIGN DEBUG: Received raw request data: {data}")
        
        # Extract test_session_id and ensure it's an integer
        try:
            test_session_id = int(data.get('test_session_id', 0) or data.get('session_id', 0))
            print(f"AUTO-ASSIGN DEBUG: Converted test_session_id to integer: {test_session_id}")
        except (TypeError, ValueError) as e:
            print(f"AUTO-ASSIGN DEBUG: Error converting test_session_id: {str(e)}")
            return Response({
                'error': f'Invalid test_session_id format: {data.get("test_session_id")}. Must be an integer.',
                'received_data': data
            }, status=status.HTTP_400_BAD_REQUEST)
            
        limit = int(data.get('limit', 100))  # Default to 100 if not specified
        respect_capacity = data.get('respect_capacity', False)  # Whether to respect room capacity limits
        group_by_school = data.get('group_by_school', False)  # Whether to group students by school
        balance_rooms = data.get('balance_rooms', True)  # Whether to balance students across rooms
        time_slot = data.get('time_slot', '')  # Preferred time slot for assignments
        force_time_slot = data.get('force_time_slot', False)  # Whether to force specific time slot
        ignore_student_preferences = data.get('ignore_student_preferences', False)  # Whether to ignore student preferences
        
        # Initialize counters and result arrays
        assigned_count = 0
        unassigned_count = 0
        assignment_details = []
        assignment_errors = []
        
        # Log request data for debugging
        print(f"AUTO-ASSIGN DEBUG: Processed request with data: test_session_id={test_session_id}, limit={limit}, respect_capacity={respect_capacity}")
        
        # Validate test_session_id
        if not test_session_id:
            return Response({
                'error': 'Missing required parameter: test_session_id',
                'received_data': data
            }, status=status.HTTP_400_BAD_REQUEST)
        
        # Get the test session
        try:
            test_session = TestSession.objects.get(id=test_session_id)
            print(f"AUTO-ASSIGN DEBUG: Found test session: ID={test_session.id}, Type={test_session.exam_type}, Date={test_session.exam_date}")
            print(f"AUTO-ASSIGN DEBUG: Test session registration period: {test_session.registration_start_date} to {test_session.registration_end_date}")
        except TestSession.DoesNotExist:
            return Response({
                'error': f'Test session with ID {test_session_id} not found',
                'received_data': data
            }, status=status.HTTP_404_NOT_FOUND)
        
        # Get pending applications without test details
        pending_applications = Appointment.objects.filter(
            status__in=['waiting_for_test_details', 'pending', 'approved'],
            test_session__isnull=True
        )
        
        # Filter applications to those within the test session registration period
        valid_applications = []
        for application in pending_applications:
            if application.preferred_date >= test_session.registration_start_date and application.preferred_date <= test_session.registration_end_date:
                valid_applications.append(application)
            else:
                unassigned_count += 1
                assignment_errors.append({
                    'application_id': application.id,
                    'error': f'Appointment date ({application.preferred_date}) does not fall within the test session registration period ({test_session.registration_start_date} to {test_session.registration_end_date})'
                })
        
        # Apply limit if specified
        if limit > 0:
            valid_applications = valid_applications[:limit]
        
        # Log application count and IDs for debugging
        application_ids = [app.id for app in valid_applications]
        print(f"AUTO-ASSIGN DEBUG: Found {len(valid_applications)} applications to assign: {application_ids}")
        
        if not valid_applications:
            print("AUTO-ASSIGN DEBUG: No applications found that need assignment")
            return Response({
                'success': False,
                'error': 'No applications found that need assignment',
                'assigned_count': 0,
                'unassigned_count': 0
            }, status=status.HTTP_200_OK)
        
        # Debug: Show information about the first few applications
        for i, app in enumerate(valid_applications[:5]):
            print(f"AUTO-ASSIGN DEBUG: Sample application {i+1}: ID={app.id}, Name={app.full_name}, Status={app.status}, Time Slot={app.time_slot}")
        
        # Get active test centers and rooms
        test_centers = TestCenter.objects.filter(is_active=True)
        
        if not test_centers.exists():
            print("AUTO-ASSIGN DEBUG: No active test centers available")
            return Response({
                'error': 'No active test centers available',
                'assigned_count': 0,
                'unassigned_count': len(valid_applications)
            }, status=status.HTTP_400_BAD_REQUEST)
        
        # Get the first available center (in production, implement a better distribution algorithm)
        center = test_centers.first()
        print(f"AUTO-ASSIGN DEBUG: Selected test center: ID={center.id}, Name={center.name}")
        
        # Get active rooms for this center with capacity
        rooms = TestRoom.objects.filter(test_center=center, is_active=True)
        
        if not rooms.exists():
            print("AUTO-ASSIGN DEBUG: No active rooms available in the selected test center")
            return Response({
                'error': 'No active rooms available in the selected test center',
                'assigned_count': 0,
                'unassigned_count': len(valid_applications)
            }, status=status.HTTP_400_BAD_REQUEST)
        
        print(f"AUTO-ASSIGN DEBUG: Found {len(rooms)} active rooms in center {center.name}")
        
        # Filter rooms that have capacity, if respect_capacity is True
        if respect_capacity:
            rooms = [room for room in rooms if room.available_capacity > 0]
            if not rooms:
                print("AUTO-ASSIGN DEBUG: No rooms with available capacity")
                return Response({
                    'error': 'No rooms with available capacity',
                    'assigned_count': 0,
                    'unassigned_count': len(valid_applications)
                }, status=status.HTTP_400_BAD_REQUEST)
        
        # Filter by time slot if requested
        if time_slot and time_slot != 'both':
            # Filter by morning or afternoon
            filtered_rooms = [room for room in rooms if room.time_slot == time_slot]
            if not filtered_rooms:
                print(f"AUTO-ASSIGN DEBUG: No rooms with {time_slot} time slot available")
                return Response({
                    'error': f'No rooms with {time_slot} time slot available',
                    'assigned_count': 0,
                    'unassigned_count': len(valid_applications)
                }, status=status.HTTP_400_BAD_REQUEST)
            
            # Check if there are any students with matching time slot preferences
            matching_time_slot_students = [app for app in valid_applications if app.time_slot == time_slot]
            if not matching_time_slot_students:
                print(f"AUTO-ASSIGN DEBUG: No students with {time_slot} time slot preference found")
                return Response({
                    'error': f'No students with {time_slot} time slot preference found',
                    'assigned_count': 0,
                    'unassigned_count': 0,
                    'details': {
                        'available_room_count': len(filtered_rooms),
                        'total_application_count': len(valid_applications),
                        'student_time_slots': {app.time_slot: app.time_slot for app in valid_applications},
                        'requested_time_slot': time_slot
                    }
                }, status=status.HTTP_200_OK)
            
            rooms = filtered_rooms
            print(f"AUTO-ASSIGN DEBUG: Filtered to {len(rooms)} {time_slot} rooms")
            print(f"AUTO-ASSIGN DEBUG: Found {len(matching_time_slot_students)} students with {time_slot} time slot preference")
        
        # Group applications by school if requested
        school_groups = {}
        if group_by_school:
            for app in valid_applications:
                school_name = app.school_name or 'Unknown'
                if school_name not in school_groups:
                    school_groups[school_name] = []
                school_groups[school_name].append(app)
            
            # Flatten back to a list but keep schools together
            valid_applications = []
            for school, apps in school_groups.items():
                valid_applications.extend(apps)
        
        # Track room assignments for capacity management
        room_assignments = {room.id: 0 for room in rooms}
        
        # Setup for balanced distribution
        if balance_rooms:
            # Sort rooms by available capacity (descending)
            rooms = sorted(rooms, key=lambda r: r.available_capacity, reverse=True)
        
        for application in valid_applications:
            # Skip application if it already has a test session
            if application.test_session:
                continue
            
            # Debug student time slot preference
            student_time_slot = application.time_slot
            print(f"AUTO-ASSIGN DEBUG: Student ID={application.id} prefers time_slot: {student_time_slot}")
            
            # If force_time_slot is enabled, prepare to use the admin-selected time slot
            # but don't overwrite the student's original preference
            admin_selected_time_slot = None
            if force_time_slot and time_slot and time_slot != 'both':
                admin_selected_time_slot = time_slot
                print(f"AUTO-ASSIGN DEBUG: Admin selected time_slot: {admin_selected_time_slot}")
            
            # Apply time slot filter if specified and not ignoring preferences
            # If we're filtering to a specific time slot (morning/afternoon), skip students who don't match
            if time_slot and time_slot != 'both' and student_time_slot != time_slot and not ignore_student_preferences and not force_time_slot:
                print(f"AUTO-ASSIGN DEBUG: Skipping application ID={application.id} because time_slot doesn't match ({student_time_slot} != {time_slot})")
                continue
                
            # Find the best room for this application
            assigned_room = None
            
            if balance_rooms:
                # Find room with most available capacity
                for room in rooms:
                    # Skip if room is at capacity and we're respecting capacity
                    if respect_capacity and room.available_capacity <= 0:
                        continue
                    
                    # Match time slot preference with room time slot only if not ignoring preferences
                    # Student time slot preference must match room time slot
                    room_matches_student = room.time_slot == student_time_slot
                    if not room_matches_student and not ignore_student_preferences and not force_time_slot:
                        print(f"AUTO-ASSIGN DEBUG: Room {room.id} time_slot={room.time_slot} doesn't match student preference={student_time_slot}")
                        continue
                    
                    # When forcing time slot, only use rooms with the specified time slot
                    if force_time_slot and time_slot and time_slot != 'both' and room.time_slot != time_slot:
                        print(f"AUTO-ASSIGN DEBUG: Room {room.id} time_slot={room.time_slot} doesn't match forced time_slot={time_slot}")
                        continue
                    
                    print(f"AUTO-ASSIGN DEBUG: Found matching room {room.id} with time_slot={room.time_slot} for student preference={student_time_slot}")
                    assigned_room = room
                    break
            else:
                # Just use the first room that has capacity
                for room in rooms:
                    # Skip if room is at capacity and we're respecting capacity
                    if respect_capacity and room.available_capacity <= 0:
                        continue
                    
                    # Match time slot preference with room time slot only if not ignoring preferences
                    # Student time slot preference must match room time slot
                    room_matches_student = room.time_slot == student_time_slot
                    if not room_matches_student and not ignore_student_preferences and not force_time_slot:
                        continue
                    
                    # When forcing time slot, only use rooms with the specified time slot
                    if force_time_slot and time_slot and time_slot != 'both' and room.time_slot != time_slot:
                        continue
                    
                    assigned_room = room
                    break
            
            # If no suitable room was found, skip this application
            if not assigned_room:
                unassigned_count += 1
                error_msg = f"No matching room found for application ID={application.id} with time_slot={student_time_slot}"
                assignment_errors.append({
                    'id': application.id,
                    'name': application.full_name,
                    'error': error_msg
                })
                print(f"AUTO-ASSIGN DEBUG: {error_msg}")
                continue
            
            try:
                # Make the assignments
                application.test_session = test_session
                application.test_center = center
                application.test_room = assigned_room
                
                # Store the assigned test time slot separately without overwriting the original preference
                if admin_selected_time_slot or force_time_slot:
                    # Use the admin-selected time slot or the room's time slot
                    new_time_slot = admin_selected_time_slot or assigned_room.time_slot
                    application.assigned_test_time_slot = new_time_slot
                    application.is_time_slot_modified = True
                    print(f"AUTO-ASSIGN DEBUG: Set assigned_test_time_slot to {new_time_slot} without changing original preference {application.time_slot}")
                else:
                    # If not forcing a time slot, still track the assignment but match the student's preference
                    application.assigned_test_time_slot = assigned_room.time_slot
                    print(f"AUTO-ASSIGN DEBUG: Set assigned_test_time_slot to {assigned_room.time_slot} (same as preference)")
                
                application.save()
                
                # Verify the assignment was saved by reloading from database
                refreshed_app = Appointment.objects.get(id=application.id)
                if (refreshed_app.test_session and refreshed_app.test_session.id == test_session.id and
                    refreshed_app.test_center and refreshed_app.test_center.id == center.id and
                    refreshed_app.test_room and refreshed_app.test_room.id == assigned_room.id):
                    
                    assigned_count += 1
                    
                    # Track this assignment for the database update
                    if assigned_room.id not in room_assignments:
                        room_assignments[assigned_room.id] = 0
                    room_assignments[assigned_room.id] += 1
                    
                    # Update the in-memory room capacity
                    assigned_room.assigned_count += 1
                    assigned_room.available_capacity = assigned_room.capacity - assigned_room.assigned_count
                    
                    # Record assignment details for response
                    assignment_details.append({
                        'id': application.id,
                        'student_id': application.id,
                        'application_id': application.id,
                        'room_id': assigned_room.id,
                        'name': application.full_name,
                        'room': assigned_room.name,
                        'room_code': assigned_room.room_code,
                        'original_time_slot': application.time_slot,
                        'assigned_test_time_slot': application.assigned_test_time_slot,
                        'verified': True
                    })
                    
                    # Send email notification to the user about test details
                    notification_sent = send_test_details_notification(refreshed_app)
                    print(f"AUTO-ASSIGN DEBUG: Notification sent to {refreshed_app.email}: {notification_sent}")
                    
                    print(f"AUTO-ASSIGN DEBUG: Successfully assigned application ID={application.id} to room ID={assigned_room.id}")
                else:
                    # Assignment didn't persist correctly
                    unassigned_count += 1
                    error_msg = (f"Assignment not persisted correctly for application ID={application.id}")
                    assignment_errors.append({
                        'id': application.id,
                        'name': application.full_name,
                        'error': error_msg
                    })
                    print(f"AUTO-ASSIGN DEBUG: {error_msg}")
            except Exception as e:
                unassigned_count += 1
                error_msg = f"Failed to assign application ID={application.id}: {str(e)}"
                assignment_errors.append({
                    'id': application.id,
                    'name': application.full_name,
                    'error': error_msg
                })
                print(f"AUTO-ASSIGN DEBUG: {error_msg}")
                continue
        
        # Update the database with the new assignment counts
        for room_id, count in room_assignments.items():
            try:
                # Use F() expression to safely update the count in the database
                from django.db.models import F
                TestRoom.objects.filter(id=room_id).update(
                    assigned_count=F('assigned_count') + count,
                    available_capacity=F('capacity') - (F('assigned_count') + count)
                )
                print(f"AUTO-ASSIGN DEBUG: Updated room ID={room_id} with {count} new assignments")
            except Exception as e:
                print(f"AUTO-ASSIGN DEBUG: Error updating room count for room ID={room_id}: {str(e)}")
        
        # Get the count again to verify overall success
        updated_count = Appointment.objects.filter(
            status='waiting_for_submission',
            test_session_id=test_session.id
        ).count()
        
        # Create a list of room assignments in the format expected by updateRoomCapacities
        room_assignments = []
        for detail in assignment_details:
            room_assignments.append({
                'room_id': detail['room_id'],
                'student_id': detail['student_id'],
                'application_id': detail['application_id']
            })
        
        print(f"AUTO-ASSIGN DEBUG: Completed assignment - assigned: {assigned_count}, unassigned: {unassigned_count}")
        
        return Response({
            'success': assigned_count > 0,
            'assigned_count': assigned_count,
            'unassigned_count': unassigned_count,
            'details': assignment_details[:10],  # Include first 10 assignment details for verification
            'room_assignments': room_assignments,  # For frontend updateRoomCapacities method
            'errors': assignment_errors[:10] if assignment_errors else [],
            'database_verify_count': updated_count
        }, status=status.HTTP_200_OK)
        
    except Exception as e:
        print(f"AUTO-ASSIGN DEBUG: Unexpected error: {str(e)}")
        import traceback
        traceback.print_exc()
        return Response({
            'error': str(e),
            'assigned_count': 0,
            'unassigned_count': 0
        }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_test_details(request, appointment_id):
    """
    Get test session, center, and room details for a specific appointment
    """
    try:
        # Check if the appointment exists
        try:
            appointment = Appointment.objects.get(id=appointment_id)
            print(f"TEST DETAILS DEBUG: Found appointment ID={appointment_id}, status={appointment.status}")
        except Appointment.DoesNotExist:
            print(f"TEST DETAILS DEBUG: Appointment not found with ID: {appointment_id}")
            return Response(
                {'error': f'Appointment not found with ID: {appointment_id}'}, 
                status=status.HTTP_404_NOT_FOUND
            )
        
        # Check if the user has permission to view this appointment
        if not request.user.is_staff and not request.user.is_superuser and request.user.email != appointment.email:
            print(f"TEST DETAILS DEBUG: Permission denied for user {request.user.email} to view appointment {appointment_id}")
            return Response(
                {'error': 'You do not have permission to view this appointment'}, 
                status=status.HTTP_403_FORBIDDEN
            )
        
        # Check direct database values before creating response
        print(f"TEST DETAILS DEBUG: Direct DB values for appointment {appointment_id}:")
        print(f"- test_session_id: {appointment.test_session_id}")
        print(f"- test_center_id: {appointment.test_center_id}")
        print(f"- test_room_id: {appointment.test_room_id}")
        print(f"- appointment time_slot: {appointment.time_slot}")
        print(f"- assigned_test_time_slot: {appointment.assigned_test_time_slot}")
        print(f"- is_time_slot_modified: {appointment.is_time_slot_modified}")
        
        # Get test details
        test_details = {
            'test_session': None,
            'test_center': None,
            'test_room': None,
            'time_slot_details': {
                'preferred_time_slot': appointment.time_slot,
                'assigned_test_time_slot': appointment.assigned_test_time_slot,
                'is_time_slot_modified': appointment.is_time_slot_modified
            }
        }
        
        if appointment.test_session:
            print(f"TEST DETAILS DEBUG: Found test session: ID={appointment.test_session.id}, type={appointment.test_session.exam_type}, date={appointment.test_session.exam_date}")
            test_details['test_session'] = {
                'id': appointment.test_session.id,
                'exam_type': appointment.test_session.exam_type,
                'exam_date': appointment.test_session.exam_date,
                'status': appointment.test_session.status
            }
        else:
            print(f"TEST DETAILS DEBUG: No test session found for appointment {appointment_id}")
        
        if appointment.test_center:
            print(f"TEST DETAILS DEBUG: Found test center: ID={appointment.test_center.id}, name={appointment.test_center.name}")
            test_details['test_center'] = {
                'id': appointment.test_center.id,
                'name': appointment.test_center.name,
                'code': appointment.test_center.code,
                'address': appointment.test_center.address
            }
        else:
            print(f"TEST DETAILS DEBUG: No test center found for appointment {appointment_id}")
        
        if appointment.test_room:
            print(f"TEST DETAILS DEBUG: Found test room: ID={appointment.test_room.id}, name={appointment.test_room.name}")
            test_details['test_room'] = {
                'id': appointment.test_room.id,
                'name': appointment.test_room.name,
                'room_code': appointment.test_room.room_code,
                'capacity': appointment.test_room.capacity,
                'time_slot': appointment.test_room.time_slot
            }
        else:
            print(f"TEST DETAILS DEBUG: No test room found for appointment {appointment_id}")
        
        print(f"TEST DETAILS DEBUG: Returning test details for appointment {appointment_id}: {test_details}")
        return Response(test_details)
        
    except Exception as e:
        print(f"TEST DETAILS DEBUG: Error getting test details: {str(e)}")
        return Response(
            {'error': str(e)}, 
            status=status.HTTP_500_INTERNAL_SERVER_ERROR
        )

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def mark_application_submitted(request, appointment_id):
    """
    Mark an application as officially submitted
    """
    try:
        # Check if the appointment exists
        try:
            appointment = Appointment.objects.get(id=appointment_id)
        except Appointment.DoesNotExist:
            return Response({'error': 'Appointment not found'}, status=status.HTTP_404_NOT_FOUND)
        
        # Check if the user has permission to update this appointment
        if not request.user.is_staff and not request.user.is_superuser and request.user.email != appointment.email:
            return Response({'error': 'You do not have permission to update this appointment'}, status=status.HTTP_403_FORBIDDEN)
        
        # Mark as submitted
        appointment.is_submitted = True
        appointment.save()
        
        return Response({
            'success': True,
            'message': 'Application marked as submitted successfully'
        }, status=status.HTTP_200_OK)
        
    except Exception as e:
        return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def batch_verify_applications(request):
    """
    Batch verify applications by IDs
    """
    try:
        # Check if user has admin privileges
        if not request.user.is_staff and not request.user.is_superuser:
            return Response({'error': 'You do not have permission to perform this action'}, status=status.HTTP_403_FORBIDDEN)
        
        data = request.data
        application_ids = data.get('application_ids', [])
        action = data.get('action', 'approve')  # Default to approve
        
        if not application_ids:
            return Response({'error': 'No application IDs provided'}, status=status.HTTP_400_BAD_REQUEST)
        
        # Get the applications
        applications = Appointment.objects.filter(id__in=application_ids)
        
        if not applications.exists():
            return Response({'error': 'No matching applications found'}, status=status.HTTP_404_NOT_FOUND)
        
        # Update status based on action
        status_value = 'approved' if action == 'approve' else 'rejected'
        
        updated_count = 0
        for application in applications:
            application.status = status_value
            application.save()
            updated_count += 1
        
        return Response({
            'success': True,
            'message': f'Successfully {status_value} {updated_count} applications',
            'updated_count': updated_count
        }, status=status.HTTP_200_OK)
        
    except Exception as e:
        return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def debug_test_assignments(request):
    """
    Get debug information about test sessions, appointments, and assignments
    """
    if not request.user.is_staff and not request.user.is_superuser:
        return Response({'error': 'You do not have permission to access this information'}, 
                       status=status.HTTP_403_FORBIDDEN)
    
    try:
        # Get test sessions info
        test_sessions = TestSession.objects.all()
        test_sessions_data = []
        
        print(f"DEBUG: Found {test_sessions.count()} test sessions in database")
        for session in test_sessions:
            appointments_count = Appointment.objects.filter(test_session=session).count()
            test_sessions_data.append({
                'id': session.id,
                'exam_type': session.exam_type,
                'exam_date': session.exam_date,
                'status': session.status,
                'appointments_count': appointments_count
            })
            print(f"DEBUG: Test session ID={session.id} has {appointments_count} assigned appointments")
            
        # Get appointments by status
        total_appointments = Appointment.objects.count()
        approved_appointments = Appointment.objects.filter(status='waiting_for_test_details').count()
        with_session = Appointment.objects.filter(test_session__isnull=False).count()
        without_session = Appointment.objects.filter(status='waiting_for_test_details', test_session__isnull=True).count()
        
        # Check for database connections
        print(f"DEBUG: Database connection check - able to query {Appointment.objects.count()} appointments total")
        
        # Get test centers and rooms counts
        test_centers_count = TestCenter.objects.filter(is_active=True).count()
        test_rooms_count = TestRoom.objects.filter(is_active=True).count()
        print(f"DEBUG: Found {test_centers_count} active test centers and {test_rooms_count} active test rooms")
        
        # Get a sample of problematic appointments (approved but no test session)
        problem_sample = Appointment.objects.filter(
            status='waiting_for_test_details', 
            test_session__isnull=True
        )[:5]
        
        problem_sample_data = []
        for app in problem_sample:
            problem_sample_data.append({
                'id': app.id,
                'full_name': app.full_name,
                'status': app.status,
                'is_submitted': app.is_submitted,
                'created_at': app.created_at.isoformat()
            })
            
        return Response({
            'test_sessions': test_sessions_data,
            'appointments_stats': {
                'total': total_appointments,
                'waiting_for_test_details': approved_appointments,
                'with_test_session': with_session,
                'without_test_session': without_session,
            },
            'test_centers_count': test_centers_count,
            'test_rooms_count': test_rooms_count,
            'problematic_sample': problem_sample_data
        }, status=status.HTTP_200_OK)
        
    except Exception as e:
        print(f"DEBUG ERROR: {str(e)}")
        import traceback
        traceback.print_exc()
        return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_room_assignment_counts(request):
    """
    Get the current assignment counts for all test rooms
    """
    try:
        # Get all rooms with their current assignment counts
        rooms = TestRoom.objects.all().order_by('test_center__name', 'name')
        
        # Format the response
        result = []
        for room in rooms:
            # Verify available_capacity is correctly calculated
            correct_available = room.capacity - room.assigned_count
            if room.available_capacity != correct_available:
                print(f"ROOM COUNT DEBUG: Room {room.id} has inconsistent capacity: available_capacity={room.available_capacity}, but should be {correct_available} (capacity={room.capacity} - assigned_count={room.assigned_count})")
                # Fix it in the database
                room.available_capacity = correct_available
                room.save()
                print(f"ROOM COUNT DEBUG: Fixed room {room.id} capacity to {room.available_capacity}")
            
            result.append({
                'room_id': room.id,
                'name': room.name,
                'center_name': room.test_center.name,
                'capacity': room.capacity,
                'assigned_count': room.assigned_count,
                'available_capacity': room.available_capacity,
                'is_active': room.is_active
            })
        
        return Response(result, status=status.HTTP_200_OK)
    except Exception as e:
        print(f"Error getting room assignment counts: {str(e)}")
        return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def update_appointment_status(request):
    """
    Update status for multiple appointments
    """
    try:
        appointment_ids = request.data.get('appointment_ids', [])
        new_status = request.data.get('new_status')
        
        if not appointment_ids or not new_status:
            return Response({'error': 'Missing required parameters'}, status=status.HTTP_400_BAD_REQUEST)
        
        # Validate the status
        valid_statuses = [status_choice[0] for status_choice in Appointment.STATUS_CHOICES]
        if new_status not in valid_statuses:
            return Response({'error': f'Invalid status. Valid options are: {valid_statuses}'}, 
                          status=status.HTTP_400_BAD_REQUEST)
        
        # If status is being changed to 'rescheduled', we need to update room capacities
        if new_status == 'rescheduled':
            # Get appointments that have room assignments
            appointments_with_rooms = Appointment.objects.filter(
                id__in=appointment_ids, 
                test_room__isnull=False
            ).exclude(status='rescheduled')  # Exclude already rescheduled appointments
            
            # Group appointments by room to count how many to remove from each room
            room_counts = {}
            for appointment in appointments_with_rooms:
                room_id = appointment.test_room.id
                if room_id not in room_counts:
                    room_counts[room_id] = 0
                room_counts[room_id] += 1
            
            # Update each room's availability
            updated_rooms = []
            for room_id, count in room_counts.items():
                try:
                    room = TestRoom.objects.get(id=room_id)
                    old_assigned = room.assigned_count
                    # Decrease assigned count and recalculate available capacity
                    room.assigned_count = max(0, room.assigned_count - count)
                    room.available_capacity = room.capacity - room.assigned_count
                    room.save()
                    updated_rooms.append({
                        'id': room.id,
                        'name': room.name,
                        'old_assigned_count': old_assigned,
                        'new_assigned_count': room.assigned_count,
                        'new_available_capacity': room.available_capacity
                    })
                except TestRoom.DoesNotExist:
                    continue
                except Exception as e:
                    print(f"Error updating room {room_id}: {str(e)}")
        
        # Update appointments
        updated_count = Appointment.objects.filter(id__in=appointment_ids).update(status=new_status)
        
        response_data = {
            'success': True,
            'message': f'Updated {updated_count} appointments to status: {new_status}'
        }
        
        # Add room update information if applicable
        if new_status == 'rescheduled' and 'updated_rooms' in locals():
            response_data['updated_rooms'] = updated_rooms
        
        return Response(response_data, status=status.HTTP_200_OK)
        
    except Exception as e:
        return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def create_individual_test_detail(request):
    """
    Create a test detail for a single application
    """
    try:
        data = request.data
        application_id = data.get('application_id')
        test_session_id = data.get('test_session_id')
        room_id = data.get('room_id')
        time_slot = data.get('time_slot')
        force_time_slot = data.get('force_time_slot', False)
        ignore_student_preferences = data.get('ignore_student_preferences', False)
        
        print(f"CREATE TEST DETAIL DEBUG: Received request to create test detail for application {application_id}")
        print(f"CREATE TEST DETAIL DEBUG: Parameters: test_session_id={test_session_id}, room_id={room_id}, time_slot={time_slot}")
        print(f"CREATE TEST DETAIL DEBUG: Options: force_time_slot={force_time_slot}, ignore_student_preferences={ignore_student_preferences}")
        
        # Validate required parameters
        if not application_id or not test_session_id or not room_id:
            return Response({
                'error': 'Missing required parameters: application_id, test_session_id, room_id',
                'received': data
            }, status=status.HTTP_400_BAD_REQUEST)
        
        # Get the application
        try:
            application = Appointment.objects.get(id=application_id)
        except Appointment.DoesNotExist:
            return Response({
                'error': f'Application with ID {application_id} not found'
            }, status=status.HTTP_404_NOT_FOUND)
        
        # Get the test session
        try:
            test_session = TestSession.objects.get(id=test_session_id)
        except TestSession.DoesNotExist:
            return Response({
                'error': f'Test session with ID {test_session_id} not found'
            }, status=status.HTTP_404_NOT_FOUND)
        
        # Validate appointment date against test session registration period
        if application.preferred_date < test_session.registration_start_date or application.preferred_date > test_session.registration_end_date:
            return Response({
                'error': f'Appointment date ({application.preferred_date}) does not fall within the test session registration period ({test_session.registration_start_date} to {test_session.registration_end_date})',
                'suggestion': 'Choose a test session with a registration period that includes the appointment date'
            }, status=status.HTTP_400_BAD_REQUEST)
        
        # Get the room
        try:
            room = TestRoom.objects.get(id=room_id)
        except TestRoom.DoesNotExist:
            return Response({
                'error': f'Room with ID {room_id} not found'
            }, status=status.HTTP_404_NOT_FOUND)
        
        # Get the room's center
        center = room.test_center
        
        # Check if the room has available capacity
        if room.available_capacity <= 0:
            return Response({
                'error': f'Room {room.name} has no available capacity'
            }, status=status.HTTP_400_BAD_REQUEST)
        
        # Get the student's time slot preference and the room's time slot
        student_time_slot = application.time_slot
        room_time_slot = room.time_slot
        
        # Check time slot compatibility only if not forcing or ignoring preferences
        if not force_time_slot and not ignore_student_preferences and student_time_slot != room_time_slot:
            return Response({
                'error': f'Room time slot ({room_time_slot}) does not match student preference ({student_time_slot})',
                'suggestion': 'Set force_time_slot=true to override student preference'
            }, status=status.HTTP_400_BAD_REQUEST)
        
        # Make the assignments
        application.test_session = test_session
        application.test_center = center
        application.test_room = room
        
        # Store the assigned test time slot separately without overwriting the original preference
        # When forcing time slot or admin has specified a time slot
        if force_time_slot and time_slot:
            application.assigned_test_time_slot = time_slot
            application.is_time_slot_modified = True
            print(f"CREATE TEST DETAIL DEBUG: Set assigned_test_time_slot to forced value: {time_slot}")
        # If not forcing a time slot, use the room's time slot as the assigned test time slot
        else:
            application.assigned_test_time_slot = room.time_slot
            # Only mark as modified if it differs from the original preference
            application.is_time_slot_modified = (room.time_slot != application.time_slot)
            print(f"CREATE TEST DETAIL DEBUG: Set assigned_test_time_slot to room's time_slot: {room.time_slot}")
        
        # Update status to waiting for submission
        application.status = 'waiting_for_submission'
        application.save()
        
        # Update room capacity
        print(f"CREATE TEST DETAIL DEBUG: Room capacity before update: capacity={room.capacity}, assigned_count={room.assigned_count}, available_capacity={room.available_capacity}")
        
        # First, double-check current database values to ensure we're working with fresh data
        fresh_room = TestRoom.objects.get(id=room.id)
        print(f"CREATE TEST DETAIL DEBUG: Fresh room data from DB: capacity={fresh_room.capacity}, assigned_count={fresh_room.assigned_count}, available_capacity={fresh_room.available_capacity}")
        
        # Update with fresh data
        room = fresh_room
        room.assigned_count += 1
        # Explicitly calculate from scratch to prevent incremental errors
        room.available_capacity = room.capacity - room.assigned_count
        print(f"CREATE TEST DETAIL DEBUG: Room capacity calculated: {room.capacity} - {room.assigned_count} = {room.available_capacity}")
        room.save()
        
        # Verify what was saved to the database
        saved_room = TestRoom.objects.get(id=room.id)
        print(f"CREATE TEST DETAIL DEBUG: Room capacity after save: capacity={saved_room.capacity}, assigned_count={saved_room.assigned_count}, available_capacity={saved_room.available_capacity}")
        
        print(f"CREATE TEST DETAIL DEBUG: Successfully assigned application {application_id} to room {room_id}")
        
        # Return the updated application
        return Response({
            'id': application.id,
            'full_name': application.full_name,
            'email': application.email,
            'time_slot': application.time_slot,
            'assigned_test_time_slot': application.assigned_test_time_slot,
            'is_time_slot_modified': application.is_time_slot_modified,
            'test_session': {
                'id': test_session.id,
                'exam_type': test_session.exam_type,
                'exam_date': test_session.exam_date
            },
            'test_center': {
                'id': center.id,
                'name': center.name,
                'code': center.code
            },
            'test_room': {
                'id': room.id,
                'name': room.name,
                'room_code': room.room_code,
                'time_slot': room.time_slot,
                'capacity': room.capacity,
                'assigned_count': room.assigned_count,
                'available_capacity': room.available_capacity
            },
            'success': True
        }, status=status.HTTP_201_CREATED)
        
    except Exception as e:
        import traceback
        traceback.print_exc()
        return Response({
            'error': str(e)
        }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def create_bulk_test_details(request):
    """
    Create test details for multiple applications at once
    """
    try:
        data = request.data
        test_session_id = data.get('test_session_id')
        center_id = data.get('center_id')
        applications = data.get('applications', [])
        time_slot = data.get('time_slot', '')
        force_time_slot = data.get('force_time_slot', False)
        ignore_student_preferences = data.get('ignore_student_preferences', False)
        
        # Validate required parameters
        if not test_session_id or not center_id or not applications:
            return Response({
                'error': 'Missing required parameters: test_session_id, center_id, applications',
                'received': data
            }, status=status.HTTP_400_BAD_REQUEST)
        
        # Get the test session
        try:
            test_session = TestSession.objects.get(id=test_session_id)
        except TestSession.DoesNotExist:
            return Response({
                'error': f'Test session with ID {test_session_id} not found'
            }, status=status.HTTP_404_NOT_FOUND)
        
        # Get the center
        try:
            center = TestCenter.objects.get(id=center_id)
        except TestCenter.DoesNotExist:
            return Response({
                'error': f'Center with ID {center_id} not found'
            }, status=status.HTTP_404_NOT_FOUND)
        
        # Get all rooms for this center that are still available
        rooms = TestRoom.objects.filter(test_center=center, is_active=True).exclude(available_capacity=0)
        if not rooms:
            return Response({
                'error': f'No available rooms found for center {center.name}'
            }, status=status.HTTP_400_BAD_REQUEST)
        
        # Initialize counters
        assigned_count = 0
        unassigned_count = 0
        assignment_details = []
        
        # Process applications
        for app_id in applications:
            try:
                # Get the application
                application = Appointment.objects.get(id=app_id)
                
                # Skip if already assigned
                if application.test_session:
                    print(f"BULK TEST DETAIL DEBUG: Skipping application {app_id} - already has test session")
                    continue
                
                # Validate appointment date against test session registration period
                if application.preferred_date < test_session.registration_start_date or application.preferred_date > test_session.registration_end_date:
                    print(f"BULK TEST DETAIL DEBUG: Skipping application {app_id} - date outside registration period")
                    unassigned_count += 1
                    continue
                
                # Find a suitable room
                suitable_room = None
                student_time_slot = application.time_slot
                
                # If specific time slot is requested and force_time_slot is True, use that as matching criteria
                if force_time_slot and time_slot:
                    suitable_rooms = rooms.filter(time_slot=time_slot, available_capacity__gt=0)
                    if suitable_rooms.exists():
                        suitable_room = suitable_rooms.first()
                    else:
                        # No rooms with the forced time slot available
                        print(f"BULK TEST DETAIL DEBUG: No rooms with forced time slot {time_slot} available")
                        unassigned_count += 1
                        continue
                # Otherwise, try to respect student preferences if not ignoring them
                elif not ignore_student_preferences:
                    suitable_rooms = rooms.filter(time_slot=student_time_slot, available_capacity__gt=0)
                    if suitable_rooms.exists():
                        suitable_room = suitable_rooms.first()
                    else:
                        # No rooms matching the student's preference available
                        print(f"BULK TEST DETAIL DEBUG: No rooms with student preference {student_time_slot} available")
                        unassigned_count += 1
                        continue
                # If ignoring preferences, just use the first available room
                else:
                    available_rooms = rooms.filter(available_capacity__gt=0)
                    if available_rooms.exists():
                        suitable_room = available_rooms.first()
                    else:
                        # No rooms with available capacity
                        print("BULK TEST DETAIL DEBUG: No rooms with available capacity")
                        unassigned_count += 1
                        continue
                
                if not suitable_room:
                    print(f"BULK TEST DETAIL DEBUG: No suitable room found for application {app_id}")
                    unassigned_count += 1
                    continue
                
                # Make the assignments
                application.test_session = test_session
                application.test_center = center
                application.test_room = suitable_room
                
                # Store the assigned test time slot separately without overwriting the original preference
                if force_time_slot and time_slot:
                    application.assigned_test_time_slot = time_slot
                    application.is_time_slot_modified = True
                    print(f"BULK TEST DETAIL DEBUG: Set assigned_test_time_slot to forced value: {time_slot}")
                else:
                    application.assigned_test_time_slot = suitable_room.time_slot
                    # Only mark as modified if it differs from the original preference
                    application.is_time_slot_modified = (suitable_room.time_slot != application.time_slot)
                    print(f"BULK TEST DETAIL DEBUG: Set assigned_test_time_slot to room's time_slot: {suitable_room.time_slot}")
                
                # Update status to waiting for submission
                application.status = 'waiting_for_submission'
                application.save()
                
                # Update room capacity
                suitable_room.assigned_count += 1
                suitable_room.available_capacity = suitable_room.capacity - suitable_room.assigned_count
                suitable_room.save()
                
                print(f"BULK TEST DETAIL DEBUG: Successfully assigned application {app_id} to room {suitable_room.id}")
                assigned_count += 1
                
                # Record assignment details
                assignment_details.append({
                    'id': application.id,
                    'full_name': application.full_name,
                    'email': application.email,
                    'original_time_slot': application.time_slot,
                    'assigned_test_time_slot': application.assigned_test_time_slot,
                    'time_slot_modified': application.is_time_slot_modified,
                    'test_session': {
                        'id': test_session.id,
                        'exam_type': test_session.exam_type,
                        'exam_date': test_session.exam_date
                    },
                    'test_center': {
                        'id': center.id,
                        'name': center.name,
                        'code': center.code
                    },
                    'test_room': {
                        'id': suitable_room.id,
                        'name': suitable_room.name,
                        'room_code': suitable_room.room_code,
                        'time_slot': suitable_room.time_slot
                    }
                })
                
            except Appointment.DoesNotExist:
                print(f"BULK TEST DETAIL DEBUG: Application with ID {app_id} not found")
                unassigned_count += 1
                continue
            except Exception as e:
                print(f"BULK TEST DETAIL DEBUG: Error processing application {app_id}: {str(e)}")
                unassigned_count += 1
                continue
        
        return Response({
            'success': assigned_count > 0,
            'assigned_count': assigned_count,
            'unassigned_count': unassigned_count,
            'details': assignment_details
        }, status=status.HTTP_200_OK)
        
    except Exception as e:
        import traceback
        traceback.print_exc()
        return Response({
            'error': str(e)
        }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

class AnnouncementViewSet(viewsets.ModelViewSet):
    queryset = Announcement.objects.all()
    serializer_class = AnnouncementSerializer
    
    def get_queryset(self):
        # Filter only active announcements for non-admin users
        queryset = Announcement.objects.all()
        
        # Apply filters
        is_active = self.request.query_params.get('is_active')
        type_filter = self.request.query_params.get('type')
        
        if not self.request.user.is_staff:
            queryset = queryset.filter(is_active=True)
        elif is_active is not None:
            queryset = queryset.filter(is_active=bool(int(is_active)))
            
        if type_filter:
            queryset = queryset.filter(type=type_filter)
            
        return queryset
    
    def perform_create(self, serializer):
        serializer.save(created_by=self.request.user)

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_student_exam_score(request):
    """
    Get detailed exam score for the authenticated student
    """
    try:
        # Find the user's appointment
        user = request.user
        
        # First check for submitted appointments (primary case)
        appointments = Appointment.objects.filter(user=user, status__in=['submitted', 'approved', 'claimed'])
        
        if not appointments.exists():
            # Return model field info in the error response to help frontend
            from .models import ExamScore
            score_fields = [field.name for field in ExamScore._meta.get_fields() 
                           if field.name.startswith('part') or field.name == 'oapr']
            
            return Response({
                'status': 'not_found',
                'detail': 'No eligible appointments found for this user. Please submit your application first.',
                'model_info': {
                    'available_score_fields': score_fields,
                    'labels': {
                        'part1': 'English Proficiency',
                        'part2': 'Reading Comprehension',
                        'part3': 'Science Process Skills',
                        'part4': 'Quantitative Skills',
                        'part5': 'Abstract Thinking Skills',
                        'oapr': 'Overall Ability Percentile Rank'
                    }
                }
            }, status=404)
        
        # Get the most recent appointment with an exam score
        appointment = None
        for appt in appointments:
            try:
                if hasattr(appt, 'exam_score') and appt.exam_score is not None:
                    appointment = appt
                    break
            except Exception as e:
                print(f"Error checking exam score for appointment {appt.id}: {str(e)}")
                continue
        
        if not appointment:
            # Check if there are any manually created exam scores for this user
            # by name matching (in case scores were imported but not linked)
            try:
                user_full_name = f"{user.first_name} {user.last_name}".strip()
                if user_full_name:
                    standalone_scores = ExamScore.objects.filter(name__icontains=user_full_name)
                    if standalone_scores.exists():
                        serializer = ExamScoreDetailSerializer(standalone_scores.first())
                        return Response(serializer.data)
            except Exception as e:
                print(f"Error checking standalone scores: {str(e)}")
            
            # Return model field info in the error response to help frontend
            from .models import ExamScore
            score_fields = [field.name for field in ExamScore._meta.get_fields() 
                           if field.name.startswith('part') or field.name == 'oapr']
            
            return Response({
                'status': 'no_scores',
                'detail': 'Your application has been submitted, but no exam scores have been uploaded yet.',
                'model_info': {
                    'available_score_fields': score_fields,
                    'labels':{
                        'part1': 'English Proficiency',
                        'part2': 'Reading Comprehension',
                        'part3': 'Science Process Skills',
                        'part4': 'Quantitative Skills',
                        'part5': 'Abstract Thinking Skills',
                        'oapr': 'Overall Ability Percentile'
                    }
                }
            }, status=404)
        
        # Get the exam score
        try:
            exam_score = appointment.exam_score
            serializer = ExamScoreDetailSerializer(exam_score)
            return Response(serializer.data)
        except Exception as e:
            print(f"Error retrieving exam score data: {str(e)}")
            return Response({
                'status': 'error',
                'detail': 'Error retrieving your exam scores. Please contact support.'
            }, status=404)
            
    except Exception as e:
        print(f"Unexpected error in get_student_exam_score: {str(e)}")
        return Response({
            'status': 'error',
            'error': str(e)
        }, status=400)

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def import_scores_api(request):
    """
    Import exam scores from a CSV file
    Expected columns: app_no, lastname, firstname, middleinitial, school, date, part1, part2, part3, part4, part5, oapr
    """
    print("import_scores_api called with request:", request.method)
    print("Request DATA:", request.data)
    print("Request FILES:", request.FILES)
    
    if 'file' not in request.FILES:
        return Response({'error': 'No file provided'}, status=400)
        
    csv_file = request.FILES['file']
    exam_type = request.data.get('examType', '')
    
    print(f"Processing file: {csv_file.name}, exam type: {exam_type}")
    
    # Process the CSV file
    try:
        # Read the CSV file
        csv_text = csv_file.read().decode('utf-8')
        csv_reader = csv.reader(io.StringIO(csv_text))
        
        # Get header row to identify columns
        headers = next(csv_reader)
        headers = [h.lower().strip() for h in headers]
        
        print(f"CSV Headers: {headers}")
        
        # Find column indices based on the new structure
        col_indices = {
            'app_no': headers.index('app_no') if 'app_no' in headers else None,
            'lastname': headers.index('lastname') if 'lastname' in headers else None,
            'firstname': headers.index('firstname') if 'firstname' in headers else None,
            'middleinitial': headers.index('middleinitial') if 'middleinitial' in headers else None,
            'school': headers.index('school') if 'school' in headers else None,
            'date': headers.index('date') if 'date' in headers else None,
            'part1': headers.index('part1') if 'part1' in headers else None,
            'part2': headers.index('part2') if 'part2' in headers else None,
            'part3': headers.index('part3') if 'part3' in headers else None,
            'part4': headers.index('part4') if 'part4' in headers else None,
            'part5': headers.index('part5') if 'part5' in headers else None,
            'oapr': headers.index('oapr') if 'oapr' in headers else None,
        }
        
        # Ensure required columns exist
        if (col_indices['lastname'] is None or col_indices['firstname'] is None or 
            col_indices['school'] is None):
            return Response({
                'error': 'CSV must include lastname, firstname, and school columns'
            }, status=400)
        
        # Track results
        matched_count = 0
        unmatched_count = 0
        updated_count = 0
        created_count = 0
        
        for row in csv_reader:
            if len(row) < 2:
                continue  # Skip rows without enough columns
                
            # Extract name components
            lastname = row[col_indices['lastname']].strip() if col_indices['lastname'] is not None and col_indices['lastname'] < len(row) else ''
            firstname = row[col_indices['firstname']].strip() if col_indices['firstname'] is not None and col_indices['firstname'] < len(row) else ''
            middleinitial = row[col_indices['middleinitial']].strip() if col_indices['middleinitial'] is not None and col_indices['middleinitial'] < len(row) else ''
            
            # Construct full name
            full_name = f"{firstname} {middleinitial} {lastname}".strip().replace("  ", " ")
            
            school = row[col_indices['school']].strip() if col_indices['school'] is not None and col_indices['school'] < len(row) else ''
            app_no = row[col_indices['app_no']].strip() if col_indices['app_no'] is not None and col_indices['app_no'] < len(row) else ''
            
            # Extract all test part scores
            part1 = row[col_indices['part1']].strip() if col_indices['part1'] is not None and col_indices['part1'] < len(row) else ''
            part2 = row[col_indices['part2']].strip() if col_indices['part2'] is not None and col_indices['part2'] < len(row) else ''
            part3 = row[col_indices['part3']].strip() if col_indices['part3'] is not None and col_indices['part3'] < len(row) else ''
            part4 = row[col_indices['part4']].strip() if col_indices['part4'] is not None and col_indices['part4'] < len(row) else ''
            part5 = row[col_indices['part5']].strip() if col_indices['part5'] is not None and col_indices['part5'] < len(row) else ''
            oapr = row[col_indices['oapr']].strip() if col_indices['oapr'] is not None and col_indices['oapr'] < len(row) else ''
            
            # Parse date if present
            exam_date = None
            if col_indices['date'] is not None and col_indices['date'] < len(row):
                date_str = row[col_indices['date']].strip()
                try:
                    # Try different date formats
                    exam_date = datetime.strptime(date_str, '%Y-%m-%d').date()
                except ValueError:
                    try:
                        exam_date = datetime.strptime(date_str, '%m/%d/%Y').date()
                    except ValueError:
                        pass
            
            # Try to find a matching appointment
            matching_appointments = Appointment.objects.filter(
                full_name__iexact=full_name,
                school_name__iexact=school,
                status='submitted'  # Only match submitted appointments
            )
            
            if matching_appointments.exists():
                # Update or create exam score for each match
                for appointment in matching_appointments:
                    score_obj, created = ExamScore.objects.update_or_create(
                        appointment=appointment,
                        defaults={
                            'app_no': app_no,
                            'name': full_name,  # Use constructed full name
                            'school': school,
                            'score': oapr,  # Use OAPR as main score
                            'part1': part1,
                            'part2': part2,
                            'part3': part3,
                            'part4': part4,
                            'part5': part5,
                            'oapr': oapr,
                            'exam_date': exam_date,
                            'exam_type': exam_type,
                            'imported_by': request.user
                        }
                    )
                    
                    if created:
                        matched_count += 1
                    else:
                        updated_count += 1
            else:
                # Create unmatched score
                ExamScore.objects.create(
                    appointment=None,
                    app_no=app_no,
                    name=full_name,  # Use constructed full name
                    school=school,
                    score=oapr,  # Use OAPR as main score
                    part1=part1,
                    part2=part2,
                    part3=part3,
                    part4=part4,
                    part5=part5,
                    oapr=oapr,
                    exam_date=exam_date,
                    exam_type=exam_type,
                    imported_by=request.user
                )
                created_count += 1
                unmatched_count += 1
            
        return Response({
            'success': True,
            'matched': matched_count,
            'updated': updated_count,
            'unmatched': unmatched_count,
            'created_count': created_count
        })
        
    except Exception as e:
        return Response({'error': str(e)}, status=400)

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_dashboard_stats(request):
    """
    Get dashboard statistics for admin
    """
    if not request.user.is_staff and not request.user.is_superuser:
        return Response({'error': 'You do not have permission to access this information'}, 
                      status=status.HTTP_403_FORBIDDEN)
    
    try:
        # Get total appointments count
        total_appointments = Appointment.objects.count()
        print(f"DEBUG: Total appointments: {total_appointments}")
        
        # Get upcoming appointments (next 7 days)
        today = date.today()
        week_later = today + timezone.timedelta(days=7)
        upcoming_appointments = Appointment.objects.filter(
            preferred_date__gte=today,
            preferred_date__lte=week_later
        ).count()
        print(f"DEBUG: Upcoming appointments: {upcoming_appointments}")
        
        # Debug: Print all possible statuses in the database
        all_statuses = Appointment.objects.values_list('status', flat=True).distinct()
        print(f"DEBUG: All appointment statuses in system: {list(all_statuses)}")
        
        # Check how many appointments are marked as is_submitted=True
        is_submitted_true = Appointment.objects.filter(is_submitted=True).count()
        print(f"DEBUG: Appointments with is_submitted=True: {is_submitted_true}")
        
        # Check submitted with status='submitted' specifically
        status_submitted = Appointment.objects.filter(status='submitted').count()
        print(f"DEBUG: Appointments with status='submitted': {status_submitted}")
        
        # More flexible query for submitted forms - check multiple possible statuses
        submitted_forms = Appointment.objects.filter(
            status__in=['submitted', 'claimed', 'approved']
        ).count()
        
        # If still zero, try just with is_submitted flag
        if submitted_forms == 0:
            submitted_forms = is_submitted_true
            
        print(f"DEBUG: Final submitted forms count: {submitted_forms}")
        
        # Count pending assignments (appointments waiting for test details)
        pending_assignments = Appointment.objects.filter(
            status='waiting_for_test_details',
            test_session__isnull=True
        ).count()
        print(f"DEBUG: Pending assignments: {pending_assignments}")
        
        return Response({
            'total_appointments': total_appointments,
            'upcoming_appointments': upcoming_appointments,
            'pending_assignments': pending_assignments,
            'submitted_forms': submitted_forms
        }, status=status.HTTP_200_OK)
    
    except Exception as e:
        print(f"ERROR in get_dashboard_stats: {str(e)}")
        import traceback
        traceback.print_exc()
        return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_recent_appointments(request):
    """
    Get recent appointments with pagination and filtering for admin dashboard
    """
    if not request.user.is_staff and not request.user.is_superuser:
        return Response({'error': 'You do not have permission to access this information'}, 
                      status=status.HTTP_403_FORBIDDEN)
    
    try:
        # Get page number and size from query parameters
        page = int(request.query_params.get('page', 1))
        page_size = int(request.query_params.get('page_size', 10))
        
        # Get filter parameters
        search_term = request.query_params.get('search', '')
        status_filter = request.query_params.get('status', '')
        from_date = request.query_params.get('from_date', '')
        to_date = request.query_params.get('to_date', '')
        
        # Start with all appointments
        appointments = Appointment.objects.all()
        
        # Apply filters
        if search_term:
            appointments = appointments.filter(full_name__icontains=search_term)
            
        if status_filter:
            appointments = appointments.filter(status=status_filter)
            
        if from_date:
            try:
                from_date_obj = datetime.strptime(from_date, '%Y-%m-%d').date()
                appointments = appointments.filter(preferred_date__gte=from_date_obj)
            except ValueError:
                # Invalid date format, ignore this filter
                pass
                
        if to_date:
            try:
                to_date_obj = datetime.strptime(to_date, '%Y-%m-%d').date()
                appointments = appointments.filter(preferred_date__lte=to_date_obj)
            except ValueError:
                # Invalid date format, ignore this filter
                pass
        
        # Order by most recent first
        appointments = appointments.order_by('-created_at')
        
        # Count total filtered appointments
        total_count = appointments.count()
        
        # Calculate offset
        offset = (page - 1) * page_size
        
        # Apply pagination
        appointments_page = appointments[offset:offset + page_size]
        
        # Serialize appointments
        serializer = AppointmentSerializer(appointments_page, many=True)
        
        return Response({
            'appointments': serializer.data,
            'total': total_count,
            'page': page,
            'page_size': page_size,
            'total_pages': (total_count + page_size - 1) // page_size
        }, status=status.HTTP_200_OK)
    
    except Exception as e:
        print(f"ERROR in get_recent_appointments: {str(e)}")
        import traceback
        traceback.print_exc()
        return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def reset_test_session_rooms(request):
    """
    Manually reset room availability for a specific test session
    """
    try:
        data = request.data
        test_session_id = data.get('test_session_id')
        
        if not test_session_id:
            return Response({
                'error': 'Missing required parameter: test_session_id'
            }, status=status.HTTP_400_BAD_REQUEST)
        
        # Get the test session
        try:
            test_session = TestSession.objects.get(id=test_session_id)
        except TestSession.DoesNotExist:
            return Response({
                'error': f'Test session with ID {test_session_id} not found'
            }, status=status.HTTP_404_NOT_FOUND)
        
        # Get all appointments for this test session
        appointments = Appointment.objects.filter(test_session=test_session)
        
        # Group appointments by room to count how many to remove from each room
        room_counts = {}
        for appointment in appointments:
            if appointment.test_room:
                room_id = appointment.test_room.id
                if room_id not in room_counts:
                    room_counts[room_id] = 0
                room_counts[room_id] += 1
        
        # Update each room's availability
        updated_rooms = []
        for room_id, count in room_counts.items():
            try:
                room = TestRoom.objects.get(id=room_id)
                old_assigned = room.assigned_count
                # Reset assigned count and recalculate available capacity
                room.assigned_count = max(0, room.assigned_count - count)
                room.available_capacity = room.capacity - room.assigned_count
                room.save()
                updated_rooms.append({
                    'id': room.id,
                    'name': room.name,
                    'old_assigned_count': old_assigned,
                    'new_assigned_count': room.assigned_count,
                    'new_available_capacity': room.available_capacity
                })
            except TestRoom.DoesNotExist:
                continue
            except Exception as e:
                print(f"Error updating room {room_id}: {str(e)}")
        
        return Response({
            'success': True,
            'message': f'Successfully reset availability for {len(updated_rooms)} rooms',
            'updated_rooms': updated_rooms
        }, status=status.HTTP_200_OK)
        
    except Exception as e:
        return Response({
            'error': str(e)
        }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

@api_view(['GET'])
def get_exam_years(request):
    """
    Get all unique exam years from ExamResult records
    """
    # Get distinct exam years, handle NULL values
    years = list(ExamResult.objects.exclude(year__isnull=True)
                .values_list('year', flat=True)
                .distinct().order_by('-year'))
    
    # Add current year if it's not in the list
    current_year = str(datetime.now().year)
    if current_year not in years:
        years.insert(0, current_year)
    
    return Response(years)

@api_view(['GET'])
def search_public_exam_scores(request):
    """
    Public endpoint for searching exam scores using application number and other details.
    Does not require authentication.
    """
    try:
        app_no = request.query_params.get('app_no', '')
        last_name = request.query_params.get('last_name', '')
        first_name = request.query_params.get('first_name', '')
        middle_initial = request.query_params.get('middle_initial', '')
        exam_year = request.query_params.get('exam_year', '')
        exam_type = request.query_params.get('exam_type', '')
        
        print(f"SEARCH: app_no={app_no}, last_name={last_name}, first_name={first_name}, middle_initial={middle_initial}")
        
        # Basic validation
        if not app_no or not last_name:
            return Response({
                'status': 'error',
                'detail': 'Application Number and Last Name are required.'
            }, status=400)
        
        # Start with a base query
        query = Q(app_no=app_no)
        
        # Since the `name` field now stores the full name as a combined string
        # (firstname middleinitial lastname), we need to search using icontains
        # to match any part of the name field
        
        # First, try with exact application number and then filter by name components
        if last_name:
            query = query & Q(name__icontains=last_name)
        
        if first_name:
            query = query & Q(name__icontains=first_name)
        
        if middle_initial:
            query = query & Q(name__icontains=middle_initial)
            
        # Add exam type and year if provided
        if exam_type:
            query = query & Q(exam_type=exam_type)
            
        if exam_year:
            query = query & Q(year=exam_year)
          # For debugging
        print(f"Executing query: {query}")
        
        # Execute the query - prioritize exact exam type match if provided
        if exam_type:
            print(f"Searching with specific exam type: {exam_type}")
            exam_scores = ExamScore.objects.filter(query).order_by('-created_at')
            
            if exam_scores.exists():
                print(f"Found {exam_scores.count()} scores, using the most recent one")
                exam_score = exam_scores.first()
                serializer = ExamScoreDetailSerializer(exam_score)
                return Response(serializer.data)
        
        # If no exam_type was provided or no results found with exam_type, try without it
        if not exam_type or not exam_scores.exists():
            # Remove exam_type from query if it was included
            if exam_type:
                # Recreate the base query without the exam_type filter
                base_query = Q(app_no=app_no)
                if last_name:
                    base_query = base_query & Q(name__icontains=last_name)
                if first_name:
                    base_query = base_query & Q(name__icontains=first_name)
                if middle_initial:
                    base_query = base_query & Q(name__icontains=middle_initial)
                if exam_year:
                    base_query = base_query & Q(year=exam_year)
            else:
                base_query = query
                
            # Try to find any exam scores with the app_no and last_name
            exam_scores = ExamScore.objects.filter(base_query).order_by('-created_at')
            
            if exam_scores.exists():
                # If multiple scores found, return all of them as a list
                if exam_scores.count() > 1:
                    print(f"Found {exam_scores.count()} different exam scores for app_no={app_no}")
                    serializer = ExamScoreDetailSerializer(exam_scores, many=True)
                    return Response(serializer.data)
                else:
                    # Just one score found
                    print(f"Found single exam score: {exam_scores.first()}")
                    serializer = ExamScoreDetailSerializer(exam_scores.first())
                    return Response(serializer.data)
            else:
                # No scores found, try a simplified search
                print("No results with all criteria, trying simplified search")
                simplified_query = Q(app_no=app_no) & Q(name__icontains=last_name)
                exam_scores = ExamScore.objects.filter(simplified_query).order_by('-created_at')
                
                if exam_scores.exists():
                    # If multiple scores found, return all of them as a list
                    if exam_scores.count() > 1:
                        print(f"Found {exam_scores.count()} different exam scores with simplified criteria")
                        serializer = ExamScoreDetailSerializer(exam_scores, many=True)
                        return Response(serializer.data)
                    else:
                        # Just one score found
                        print(f"Found single exam score with simplified criteria: {exam_scores.first()}")
                        serializer = ExamScoreDetailSerializer(exam_scores.first())
                        return Response(serializer.data)
                else:
                    print(f"No exam scores found for criteria: app_no={app_no}, last_name={last_name}")
                    return Response({
                        'status': 'not_found',
                        'detail': 'No exam score found matching your criteria.'
                    }, status=404)
            
    except Exception as e:
        print(f"Error in search_public_exam_scores: {str(e)}")
        return Response({
            'status': 'error',
            'detail': 'An error occurred while searching for exam scores.'
        }, status=500)
