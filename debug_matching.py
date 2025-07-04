#!/usr/bin/env python
"""
Debug script to test appointment matching logic
"""
import os
import sys
import django
from django.conf import settings

# Add the backend directory to Python path
backend_path = os.path.join(os.path.dirname(__file__), 'backend')
sys.path.insert(0, backend_path)

# Set up Django environment
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'backend.settings')
django.setup()

from base.models import Appointment, ExamScore
from django.db.models import Q

def test_appointment_matching():
    """Test the appointment matching logic with actual data"""
    print("=== Testing Appointment Matching ===")
    
    # Test data from CSV
    test_data = {
        'lastname': 'FAMINIANO',
        'firstname': 'CHRISTIAN', 
        'middlename': 'JUDE',
        'school': 'ZAMBOANGA CHONG HUA HIGH SCHOOL'
    }
    
    print(f"Looking for appointment with:")
    print(f"  lastname: {test_data['lastname']}")
    print(f"  firstname: {test_data['firstname']}")
    print(f"  middlename: {test_data['middlename']}")
    print(f"  school: {test_data['school']}")
    print()
    
    # Check all approved appointments
    approved_appointments = Appointment.objects.filter(status='approved')
    print(f"Total approved appointments: {approved_appointments.count()}")
    
    for appt in approved_appointments:
        print(f"  ID {appt.id}: {appt.full_name}")
        print(f"    first_name: '{appt.first_name}'")
        print(f"    last_name: '{appt.last_name}'")
        print(f"    middle_name: '{appt.middle_name}'")
        print(f"    school_name: '{appt.school_name}'")
        print(f"    exam_date: {appt.exam_date}")
        print()
    
    # Test exact matching
    print("=== Testing Exact Matching ===")
    exact_matches = Appointment.objects.filter(
        status='approved',
        last_name__iexact=test_data['lastname'],
        first_name__iexact=test_data['firstname'],
        middle_name__iexact=test_data['middlename'],
        school_name__iexact=test_data['school']
    )
    print(f"Exact matches: {exact_matches.count()}")
    
    # Test step by step matching
    print("=== Testing Step by Step Matching ===")
    
    # Start with approved appointments
    matches = Appointment.objects.filter(status='approved')
    print(f"1. Approved appointments: {matches.count()}")
    
    # Filter by lastname
    matches = matches.filter(last_name__iexact=test_data['lastname'])
    print(f"2. After lastname filter: {matches.count()}")
    
    # Filter by firstname  
    matches = matches.filter(first_name__iexact=test_data['firstname'])
    print(f"3. After firstname filter: {matches.count()}")
    
    # Filter by middlename
    matches = matches.filter(middle_name__iexact=test_data['middlename'])
    print(f"4. After middlename filter: {matches.count()}")
    
    # Filter by school
    matches = matches.filter(school_name__iexact=test_data['school'])
    print(f"5. After school filter: {matches.count()}")
    
    if matches.exists():
        print("\n=== MATCH FOUND! ===")
        for match in matches:
            print(f"Matched appointment: {match.full_name} - {match.school_name}")
            
            # Check if there's already an exam score for this appointment
            existing_score = ExamScore.objects.filter(appointment=match).first()
            if existing_score:
                print(f"  Existing score: {existing_score.oapr}")
            else:
                print("  No existing score")
    else:
        print("\n=== NO MATCH FOUND ===")
        print("Trying alternative matching strategies...")
        
        # Try case-sensitive matching
        case_sensitive = Appointment.objects.filter(
            status='approved',
            last_name=test_data['lastname'],
            first_name=test_data['firstname'],
            middle_name=test_data['middlename'],
            school_name=test_data['school']
        )
        print(f"Case-sensitive matches: {case_sensitive.count()}")
        
        # Try partial matching
        partial_matches = Appointment.objects.filter(
            status='approved',
            school_name__iexact=test_data['school'],
            full_name__icontains=test_data['firstname'],
            full_name__icontains=test_data['lastname']
        )
        print(f"Partial matches: {partial_matches.count()}")
        for match in partial_matches:
            print(f"  {match.full_name}")

if __name__ == "__main__":
    test_appointment_matching()
