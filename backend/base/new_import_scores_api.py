from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from django.db.models import Q
from django.contrib.auth.models import User
from datetime import datetime
import csv
import io
from .models import Appointment, ExamScore, Notification

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def import_scores_api(request):
    """
    Import exam scores from a CSV file
    Expected columns: app_no, lastname, firstname, middlename, school, date, part1, part2, part3, part4, part5, oapr
    """
    print("import_scores_api called with request:", request.method)
    print("Request DATA:", request.data)
    print("Request FILES:", request.FILES)
    
    if 'file' not in request.FILES:
        return Response({'error': 'No file provided'}, status=400)
        
    csv_file = request.FILES['file']
    exam_type = request.data.get('examType', '')
    exam_year = request.data.get('year', '')
    
    print(f"Processing file: {csv_file.name}, exam type: {exam_type}, exam year: {exam_year}")
    
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
            'middlename': headers.index('middlename') if 'middlename' in headers else None,
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
            middlename = row[col_indices['middlename']].strip() if col_indices['middlename'] is not None and col_indices['middlename'] < len(row) else ''
            
            # Construct full name
            full_name = f"{firstname} {middlename} {lastname}".strip().replace("  ", " ")
            
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
            
            print(f"\n=== Processing CSV row ===")
            print(f"lastname='{lastname}', firstname='{firstname}', middlename='{middlename}'")
            print(f"school='{school}', app_no='{app_no}'")
            
            # Step 1: First, let's check what schools exist for debugging
            all_approved = Appointment.objects.filter(status='approved')
            print(f"Total approved appointments: {all_approved.count()}")
            
            if all_approved.exists():
                unique_schools = set(all_approved.values_list('school_name', flat=True))
                print(f"Available schools in database: {list(unique_schools)}")
            
            # Step 2: Find all approved appointments with exact school match
            base_query = Appointment.objects.filter(
                status='approved',
                school_name__iexact=school
            )
            print(f"Base query count (approved + school '{school}'): {base_query.count()}")
            
            # If no school match, try more flexible school matching
            if not base_query.exists():
                print("No exact school match, trying flexible school matching...")
                # Try partial school name matching
                flexible_school_query = all_approved.filter(
                    school_name__icontains=school.split()[-1] if school else ""
                )
                print(f"Flexible school query count: {flexible_school_query.count()}")
                if flexible_school_query.exists():
                    print(f"Found schools: {[apt.school_name for apt in flexible_school_query]}")
                    base_query = flexible_school_query
            
            # Step 3: Try EXACT component matching first (most strict)
            exact_matches = base_query.filter(
                last_name__iexact=lastname,
                first_name__iexact=firstname,
                middle_name__iexact=middlename
            )
            
            print(f"Exact matches count: {exact_matches.count()}")
            if exact_matches.exists():
                print(f"Found exact matches:")
                for apt in exact_matches:
                    print(f"  - ID {apt.id}: {apt.full_name} (first:'{apt.first_name}' middle:'{apt.middle_name}' last:'{apt.last_name}' exam_date:{apt.exam_date})")
                matching_appointments = exact_matches
            else:
                # Step 4: If no exact matches, try lastname + firstname exact matching ONLY if names are EXACT
                # This prevents "CHRISTIAN" from matching "CHRISTIAN JUDE"
                partial_matches = base_query.filter(
                    last_name__iexact=lastname,
                    first_name__iexact=firstname
                )
                
                print(f"Partial matches (lastname+firstname exact): {partial_matches.count()}")
                if partial_matches.exists():
                    print(f"Found partial matches:")
                    for apt in partial_matches:
                        print(f"  - ID {apt.id}: {apt.full_name} (first:'{apt.first_name}' middle:'{apt.middle_name}' last:'{apt.last_name}' exam_date:{apt.exam_date})")
                    
                    # If we have middle name in CSV, REQUIRE exact middle name match
                    if middlename:
                        middle_filtered = partial_matches.filter(middle_name__iexact=middlename)
                        if middle_filtered.exists():
                            matching_appointments = middle_filtered
                            print(f"Narrowed down by exact middle name: {middle_filtered.count()}")
                        else:
                            # No exact middle name match - this should not match
                            print(f"No exact middle name match for '{middlename}' - rejecting match")
                            matching_appointments = Appointment.objects.none()
                    else:
                        # CSV has no middle name, only match if appointment also has no middle name
                        no_middle_matches = partial_matches.filter(
                            Q(middle_name__isnull=True) | Q(middle_name__exact='')
                        )
                        if no_middle_matches.exists():
                            matching_appointments = no_middle_matches
                            print(f"Matched appointments with no middle name: {no_middle_matches.count()}")
                        else:
                            # All appointments have middle names but CSV doesn't - be strict
                            print(f"CSV has no middle name but appointments do - rejecting match")
                            matching_appointments = Appointment.objects.none()
                else:
                    # Step 5: Last resort - no matches found
                    matching_appointments = Appointment.objects.none()
                    print("No matches found")
            
            # Step 6: Additional filter by exam date if available (MANDATORY for exact matching)
            if exam_date and matching_appointments.exists():
                print(f"Applying exam date filter: {exam_date}")
                date_filtered = matching_appointments.filter(
                    Q(exam_date=exam_date) | Q(preferred_date=exam_date)
                )
                print(f"Date filtered appointments: {date_filtered.count()}")
                if date_filtered.exists():
                    matching_appointments = date_filtered
                    print(f"Date filter applied, final matches: {date_filtered.count()}")
                else:
                    # If date doesn't match, no appointment should be matched
                    print(f"No appointments found with exam date {exam_date}")
                    matching_appointments = Appointment.objects.none()
            elif exam_date and not matching_appointments.exists():
                print(f"No appointments to date filter (exam_date: {exam_date})")
            
            print(f"Final matching appointments after date filter: {matching_appointments.count()}")
            if matching_appointments.exists():
                for appt in matching_appointments:
                    print(f"  -> FINAL MATCH ID {appt.id}: {appt.full_name} - {appt.school_name} (exam_date: {appt.exam_date})")
            else:
                print("  -> NO FINAL MATCHES FOUND")
            
            if matching_appointments.exists():
                # Take only the first match to avoid duplicates
                appointment = matching_appointments.first()
                
                print(f"\n=== Processing Single Match ===")
                print(f"Selected appointment: ID {appointment.id}: {appointment.full_name}")
                
                # Check if score already exists to avoid duplicates
                existing_score = ExamScore.objects.filter(appointment=appointment).first()
                if existing_score:
                    print(f"Updating existing score for appointment {appointment.id}")
                    # Update the existing score
                    existing_score.app_no = app_no
                    existing_score.name = full_name
                    existing_score.school = school
                    existing_score.score = oapr
                    existing_score.part1 = part1
                    existing_score.part2 = part2
                    existing_score.part3 = part3
                    existing_score.part4 = part4
                    existing_score.part5 = part5
                    existing_score.oapr = oapr
                    existing_score.exam_date = exam_date
                    existing_score.exam_type = exam_type
                    existing_score.year = exam_year
                    existing_score.imported_by = request.user
                    existing_score.save()
                    updated_count += 1
                    print(f"Updated score with OAPR: {oapr}")
                else:
                    print(f"Creating new score for appointment {appointment.id}")
                    # Create new score
                    new_score = ExamScore.objects.create(
                        appointment=appointment,
                        app_no=app_no,
                        name=full_name,
                        school=school,
                        score=oapr,
                        part1=part1,
                        part2=part2,
                        part3=part3,
                        part4=part4,
                        part5=part5,
                        oapr=oapr,
                        exam_date=exam_date,
                        exam_type=exam_type,
                        year=exam_year,
                        imported_by=request.user
                    )
                    matched_count += 1
                    print(f"Created new score with OAPR: {oapr}")
                
                print(f"Score processed for appointment {appointment.id}")
                print("---")
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
                    year=exam_year,
                    imported_by=request.user
                )
                created_count += 1
                unmatched_count += 1
            
        # Create global notification for exam results release
        total_scores_imported = matched_count + updated_count
        if total_scores_imported > 0:
            try:
                Notification.objects.create(
                    user=None,  # No specific user - this is a global notification
                    title="Exam Scores Released",
                    message=f"The results for {exam_type} ({exam_year}) are now available. {total_scores_imported} scores have been published. You can check your results in the Results section.",
                    type='exam',
                    priority='high',
                    icon='graduation-cap',
                    link='/profile',
                    created_by=request.user,
                    is_read=False,
                    is_global=True  # This makes it visible to all users
                )
                print(f"Created global exam results notification for {exam_type} ({exam_year})")
            except Exception as notification_error:
                print(f"Error creating notification: {str(notification_error)}")
                # Don't fail the import if notification creation fails
            
        return Response({
            'success': True,
            'matched': matched_count,
            'updated': updated_count,
            'unmatched': unmatched_count,
            'created_count': created_count
        })
        
    except Exception as e:
        return Response({'error': str(e)}, status=400)
