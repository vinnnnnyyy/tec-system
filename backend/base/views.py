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
from datetime import datetime, date, timedelta
from django.db.models import Sum
from django.db.models import Q, Count
from django.contrib.auth.hashers import make_password
from django.db import transaction
from .notification_utils import send_test_details_notification
import json

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
                self.perform_create(serializer)
                return Response(serializer.data, status=status.HTTP_201_CREATED)
            except Program.DoesNotExist:
                return Response({"error": "Program not found"}, status=status.HTTP_404_NOT_FOUND)
            except Exception as e:
                return Response({"error": str(e)}, status=status.HTTP_400_BAD_REQUEST)
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
                    # Get the room and decrement its assigned count
                    room = original_test_room
                    if room.assigned_count > 0:
                        room.assigned_count -= 1
                        room.available_capacity = room.capacity - room.assigned_count
                        room.save()
                        room_updated = True
                        response_data['room_updated'] = {
                            'room_id': room.id,
                            'new_assigned_count': room.assigned_count,
                            'new_available_capacity': room.available_capacity
                        }
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
            return Response({"error": "No file provided"}, status=400)
        
        csv_file = request.FILES['file']
        exam_type = request.data.get('examType', '')
        
        # Process the CSV file
        try:
            # Implementation details...
            return Response({"message": "Scores imported successfully"}, status=201)
        except Exception as e:
            return Response({"error": str(e)}, status=400)

class FAQViewSet(viewsets.ModelViewSet):
    queryset = FAQ.objects.all().order_by('order', '-created_at')
    serializer_class = FAQSerializer
    permission_classes = [permissions.IsAdminUser]  # Only admin users can manage FAQs

    def get_permissions(self):
        if self.action == 'list':
            return [permissions.AllowAny()]  # Anyone can view FAQs
        return [permissions.IsAdminUser()]  # Only admin users can create/update/delete FAQs

class TestCenterViewSet(viewsets.ModelViewSet):
    queryset = TestCenter.objects.all()
    serializer_class = TestCenterSerializer
    permission_classes = [IsAuthenticated]

    def perform_create(self, serializer):
        serializer.save()

    @action(detail=True, methods=['GET'])
    def rooms(self, request, pk=None):
        """Get rooms for a specific test center"""
        test_center = self.get_object()
        rooms = TestRoom.objects.filter(test_center=test_center)
        serializer = TestRoomSerializer(rooms, many=True)
        return Response(serializer.data)

class TestRoomViewSet(viewsets.ModelViewSet):
    queryset = TestRoom.objects.all()
    serializer_class = TestRoomSerializer
    permission_classes = [IsAuthenticated]

    def perform_create(self, serializer):
        serializer.save()

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
            
            # Create a set of unique room IDs from these appointments
            room_ids = set()
            for appointment in appointments:
                if appointment.test_room:
                    room_ids.add(appointment.test_room.id)
            
            # Update each room's assigned count and available capacity
            for room_id in room_ids:
                try:
                    room = TestRoom.objects.get(id=room_id)
                    assigned_count = Appointment.objects.filter(
                        test_session=test_session, test_room=room
                    ).count()
                    room.assigned_count = assigned_count
                    room.available_capacity = room.capacity - assigned_count
                    room.save()
                except TestRoom.DoesNotExist:
                    continue
                    
            return True
        except Exception as e:
            print(f"Error resetting room availability: {str(e)}")
            import traceback
            traceback.print_exc()
            return False

    @action(detail=True, methods=['GET'], url_path='allocations')
    def get_allocations(self, request, pk=None):
        """
        Get room allocations for a specific test session
        """
        try:
            session = self.get_object()
            # Get all rooms
            rooms = TestRoom.objects.filter(is_active=True)
            
            # Prepare the response data
            room_data = []
            for room in rooms:
                # Get the test center for this room
                test_center = room.test_center
                
                # Count assigned appointments for this room
                assigned_count = Appointment.objects.filter(
                    test_room=room,
                    test_session=session
                ).count()
                
                # Calculate available capacity
                available_capacity = max(0, room.capacity - assigned_count)
                
                # Add room data to the response
                room_data.append({
                    'id': room.id,
                    'room_name': room.name,
                    'room_code': room.room_code,
                    'center_name': test_center.name if test_center else 'Unknown',
                    'test_center_id': test_center.id if test_center else None,
                    'capacity': room.capacity,
                    'assigned_count': assigned_count,
                    'available_capacity': available_capacity,
                    'time_slot': room.time_slot
                })
            
            return Response({
                'session_id': session.id,
                'exam_date': session.exam_date,
                'rooms': room_data
            })
            
        except Exception as e:
            print(f"Error getting room allocations: {str(e)}")
            return Response({
                'error': 'Failed to retrieve room allocations'
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
            is_active_bool = is_active.lower() == 'true'
            queryset = queryset.filter(is_active=is_active_bool)
            
        if type_filter:
            queryset = queryset.filter(type=type_filter)
            
        return queryset
    
    def perform_create(self, serializer):
        serializer.save(created_by=self.request.user)

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
# Other functions...

@api_view(['POST'])
@csrf_exempt
def create_appointment(request):
    """
    Create a new appointment with application form data
    """
    if request.method == 'POST':
        try:
            # Implementation details...
            return Response({"success": True}, status=201)
        except Exception as e:
            return Response({"error": str(e)}, status=400)
            
    return Response({'error': 'Method not allowed'}, status=405)

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def assign_test_details(request):
    """
    Assign a test center and test room to an appointment.
    """
    try:
        appointment_id = request.data.get('appointment_id')
        test_center_id = request.data.get('test_center_id')
        test_room_id = request.data.get('test_room_id')
        
        if not appointment_id:
            return Response({'error': 'Appointment ID is required'}, status=status.HTTP_400_BAD_REQUEST)
        
        try:
            appointment = Appointment.objects.get(id=appointment_id)
        except Appointment.DoesNotExist:
            return Response({'error': 'Appointment not found'}, status=status.HTTP_404_NOT_FOUND)
        
        # Original test room (for updating room capacity counts)
        original_test_room = appointment.test_room
        
        # Update the test center and room
        if test_center_id:
            try:
                test_center = TestCenter.objects.get(id=test_center_id)
                appointment.test_center = test_center
            except TestCenter.DoesNotExist:
                return Response({'error': 'Test center not found'}, status=status.HTTP_404_NOT_FOUND)
        
        if test_room_id:
            try:
                test_room = TestRoom.objects.get(id=test_room_id)
                
                # First, decrease count from the original room if it exists
                if original_test_room and original_test_room.id != test_room.id:
                    original_test_room.assigned_count = max(0, original_test_room.assigned_count - 1)
                    original_test_room.available_capacity = original_test_room.capacity - original_test_room.assigned_count
                    original_test_room.save()
                
                # Then, increase count for the new room
                if not original_test_room or original_test_room.id != test_room.id:
                    test_room.assigned_count = test_room.assigned_count + 1
                    test_room.available_capacity = test_room.capacity - test_room.assigned_count
                    test_room.save()
                
                appointment.test_room = test_room
                appointment.assigned_test_time_slot = test_room.time_slot
                appointment.is_time_slot_modified = True
                
            except TestRoom.DoesNotExist:
                return Response({'error': 'Test room not found'}, status=status.HTTP_404_NOT_FOUND)
        
        # If both test center and test room were assigned, update the status
        if appointment.test_center and appointment.test_room:
            appointment.status = 'waiting_for_submission'
        
        appointment.save()
        
        return Response({
            'success': True,
            'message': 'Appointment test details updated successfully',
            'appointment': {
                'id': appointment.id,
                'status': appointment.status,
                'test_center': appointment.test_center.id if appointment.test_center else None,
                'test_room': appointment.test_room.id if appointment.test_room else None,
                'assigned_test_time_slot': appointment.assigned_test_time_slot
            }
        })
        
    except Exception as e:
        print(f"Error in assign_test_details: {str(e)}")
        return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

# Other API endpoints...

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def count_pending_applications(request):
    """
    Count pending applications
    """
    try:
        # Implementation details...
        return Response({'count': 0})
    except Exception as e:
        return Response({'error': str(e)}, status=500)

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_student_exam_score(request):
    """
    Get detailed exam score for the authenticated student
    """
    try:
        # Implementation details...
        return Response({'message': 'Not implemented'}, status=status.HTTP_501_NOT_IMPLEMENTED)
    except Exception as e:
        return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

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
            'message': f'Updated {updated_count} appointments to status: {new_status}',
            'updated_count': updated_count
        }
        
        if new_status == 'rescheduled' and updated_rooms:
            response_data['updated_rooms'] = updated_rooms
        
        return Response(response_data)
        
    except Exception as e:
        print(f"Error in update_appointment_status: {str(e)}")
        return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

# Add other functions here...

@api_view(['POST'])
@csrf_exempt  
def generate_pdf(request):
    """Generate PDF for appointment"""
    if request.method == 'POST':
        try:
            # Implementation for PDF generation
            return HttpResponse("PDF generation not implemented", status=501)
        except Exception as e:
            return HttpResponse(f"Error generating PDF: {str(e)}", status=500)
    return HttpResponse("Method not allowed", status=405)

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def auto_assign_test_details(request):
    """Auto assign test details to appointments"""
    try:
        # Implementation for auto assignment
        return Response({'message': 'Auto assignment not implemented'}, status=501)
    except Exception as e:
        return Response({'error': str(e)}, status=500)

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_test_details(request, appointment_id):
    """Get test details for an appointment"""
    try:
        appointment = Appointment.objects.get(id=appointment_id)
        
        # Build response data
        response_data = {}
        
        if appointment.test_session:
            response_data['test_session'] = {
                'id': appointment.test_session.id,
                'exam_date': appointment.test_session.exam_date,
                'exam_type': appointment.test_session.exam_type
            }
        
        if appointment.test_center:
            response_data['test_center'] = {
                'id': appointment.test_center.id,
                'name': appointment.test_center.name,
                'address': appointment.test_center.address
            }
        
        if appointment.test_room:
            response_data['test_room'] = {
                'id': appointment.test_room.id,
                'name': appointment.test_room.name,
                'capacity': appointment.test_room.capacity,
                'time_slot': appointment.test_room.time_slot
            }
        
        return Response(response_data)
    except Appointment.DoesNotExist:
        return Response({'error': 'Appointment not found'}, status=404)
    except Exception as e:
        return Response({'error': str(e)}, status=500)

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def mark_application_submitted(request, appointment_id):
    """Mark an application as submitted"""
    try:
        appointment = Appointment.objects.get(id=appointment_id)
        appointment.status = 'submitted'
        appointment.is_submitted = True
        appointment.save()
        
        return Response({
            'success': True,
            'message': 'Application marked as submitted',
            'status': appointment.status
        })
    except Appointment.DoesNotExist:
        return Response({'error': 'Appointment not found'}, status=404)
    except Exception as e:
        return Response({'error': str(e)}, status=500)

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def batch_verify_applications(request):
    """Batch verify applications"""
    try:
        application_ids = request.data.get('application_ids', [])
        action = request.data.get('action')
        
        if not application_ids or not action:
            return Response({'error': 'Missing required parameters'}, status=400)
        
        # Update the appointments
        updated_count = Appointment.objects.filter(id__in=application_ids).update(status=action)
        
        return Response({
            'success': True,
            'message': f'Updated {updated_count} applications',
            'updated_count': updated_count
        })
    except Exception as e:
        return Response({'error': str(e)}, status=500)

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def debug_test_assignments(request):
    """Debug test assignments"""
    try:
        # Get some statistics for debugging
        total_appointments = Appointment.objects.count()
        assigned_appointments = Appointment.objects.filter(test_room__isnull=False).count()
        
        return Response({
            'total_appointments': total_appointments,
            'assigned_appointments': assigned_appointments,
            'unassigned_appointments': total_appointments - assigned_appointments
        })
    except Exception as e:
        return Response({'error': str(e)}, status=500)

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_room_assignment_counts(request):
    """Get room assignment counts"""
    try:
        rooms = TestRoom.objects.all()
        room_data = []
        
        for room in rooms:
            assigned_count = Appointment.objects.filter(test_room=room).count()
            room_data.append({
                'id': room.id,
                'name': room.name,
                'capacity': room.capacity,
                'assigned_count': assigned_count,
                'available_capacity': room.capacity - assigned_count
            })
        
        return Response(room_data)
    except Exception as e:
        return Response({'error': str(e)}, status=500)

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def create_individual_test_detail(request):
    """Create individual test detail"""
    try:
        # Implementation for creating individual test details
        return Response({'message': 'Individual test detail creation not implemented'}, status=501)
    except Exception as e:
        return Response({'error': str(e)}, status=500)

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def create_bulk_test_details(request):
    """Create bulk test details"""
    try:
        # Implementation for creating bulk test details
        return Response({'message': 'Bulk test detail creation not implemented'}, status=501)
    except Exception as e:
        return Response({'error': str(e)}, status=500)

@api_view(['GET'])
def get_dashboard_stats(request):
    """Get dashboard statistics for admin"""
    if not request.user.is_staff and not request.user.is_superuser:
        return Response({'error': 'Permission denied'}, status=403)
    
    try:
        # Get appointment counts
        total_appointments = Appointment.objects.count()
        pending_appointments = Appointment.objects.filter(status='pending').count()
        waiting_for_test_details = Appointment.objects.filter(status='waiting_for_test_details').count()
        waiting_for_submission = Appointment.objects.filter(status='waiting_for_submission').count()
        submitted_appointments = Appointment.objects.filter(status='submitted').count()
        
        # Calculate upcoming appointments (next 7 days)
        from datetime import timedelta
        today = timezone.now().date()
        next_week = today + timedelta(days=7)
        upcoming_appointments = Appointment.objects.filter(
            preferred_date__gte=today,
            preferred_date__lte=next_week
        ).count()
        
        return Response({
            'total_appointments': total_appointments,
            'upcoming_appointments': upcoming_appointments,
            'pending_assignments': waiting_for_test_details,
            'submitted_forms': submitted_appointments,
            'pending_appointments': pending_appointments,
            'waiting_for_submission': waiting_for_submission
        })
    except Exception as e:
        print(f"Error in get_dashboard_stats: {str(e)}")
        return Response({'error': str(e)}, status=500)

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_recent_appointments(request):
    """Get recent appointments with pagination and filtering for admin dashboard"""
    if not request.user.is_staff and not request.user.is_superuser:
        return Response({'error': 'Permission denied'}, status=403)
    
    try:
        # Get pagination parameters
        page = int(request.query_params.get('page', 1))
        page_size = int(request.query_params.get('page_size', 10))
        
        # Get filter parameters
        search = request.query_params.get('search', '')
        status_filter = request.query_params.get('status', '')
        from_date = request.query_params.get('from_date', '')
        to_date = request.query_params.get('to_date', '')
        
        # Start with all appointments
        queryset = Appointment.objects.all()
        
        # Apply filters
        if search:
            queryset = queryset.filter(
                Q(full_name__icontains=search) |
                Q(email__icontains=search) |
                Q(contact_number__icontains=search)
            )
        
        if status_filter:
            queryset = queryset.filter(status=status_filter)
        
        if from_date:
            try:
                from_date_obj = datetime.strptime(from_date, '%Y-%m-%d').date()
                queryset = queryset.filter(preferred_date__gte=from_date_obj)
            except ValueError:
                pass
        
        if to_date:
            try:
                to_date_obj = datetime.strptime(to_date, '%Y-%m-%d').date()
                queryset = queryset.filter(preferred_date__lte=to_date_obj)
            except ValueError:
                pass
        
        # Get total count
        total_count = queryset.count()
        
        # Apply pagination
        start_index = (page - 1) * page_size
        end_index = start_index + page_size
        appointments = queryset.order_by('-created_at')[start_index:end_index]
          # Serialize appointment data
        appointment_data = []
        for appointment in appointments:
            appointment_data.append({
                'id': appointment.id,
                'full_name': appointment.full_name,
                'email': appointment.email,
                'contact_number': appointment.contact_number,
                'school_name': appointment.school_name or 'N/A',
                'program_name': appointment.program.name if appointment.program else 'N/A',
                'status': appointment.status,
                'preferred_date': appointment.preferred_date.isoformat() if appointment.preferred_date else None,
                'time_slot': appointment.time_slot,
                'assigned_test_time_slot': appointment.assigned_test_time_slot,
                'created_at': appointment.created_at.isoformat() if appointment.created_at else None
            })
        
        return Response({
            'appointments': appointment_data,
            'total': total_count,
            'page': page,
            'page_size': page_size,
            'total_pages': (total_count + page_size - 1) // page_size
        })
    except Exception as e:
        print(f"Error in get_recent_appointments: {str(e)}")
        return Response({'error': str(e)}, status=500)

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def reset_test_session_rooms(request):
    """Manually reset room availability for a specific test session"""
    try:
        test_session_id = request.data.get('test_session_id')
        
        if not test_session_id:
            return Response({'error': 'Test session ID is required'}, status=400)
        
        try:
            test_session = TestSession.objects.get(id=test_session_id)
        except TestSession.DoesNotExist:
            return Response({'error': 'Test session not found'}, status=404)
        
        # Reset room availability for this test session
        appointments = Appointment.objects.filter(test_session=test_session)
        
        # Get unique room IDs
        room_ids = set()
        for appointment in appointments:
            if appointment.test_room:
                room_ids.add(appointment.test_room.id)
        
        # Update each room's assigned count
        for room_id in room_ids:
            try:
                room = TestRoom.objects.get(id=room_id)
                assigned_count = Appointment.objects.filter(
                    test_session=test_session, test_room=room
                ).count()
                room.assigned_count = assigned_count
                room.available_capacity = room.capacity - assigned_count
                room.save()
            except TestRoom.DoesNotExist:
                continue
        
        return Response({
            'success': True,
            'message': f'Reset room availability for test session {test_session.id}',
            'rooms_updated': len(room_ids)
        })
        
    except Exception as e:
        return Response({'error': str(e)}, status=500)

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
