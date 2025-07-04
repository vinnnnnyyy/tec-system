#!/usr/bin/env python
"""
Test script to verify exam score import functionality
"""
import os
import sys
import django
from django.conf import settings

# Add the backend directory to Python path
sys.path.insert(0, os.path.join(os.path.dirname(__file__), 'backend'))

# Set up Django environment
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'backend.settings')
django.setup()

from base.models import Appointment, ExamScore
from django.contrib.auth.models import User

def test_appointment_matching():
    """Test the exact matching logic for appointments"""
    print("=== Testing Exact Matching Logic ===")
    
    # Test data from sample CSV
    test_cases = [
        ('FAMINIANO', 'CHRISTIAN JUDE', 'JUDE'),  # Should match ID 325
        ('FAMINIANO', 'CHRISTIAN', 'JUDE'),       # Should match ID 326
    ]
    
    for lastname, firstname, middlename in test_cases:
        print(f"\nTesting: {lastname}, {firstname}, {middlename}")
        
        # Step 1: Find all approved appointments with exact school match
        base_query = Appointment.objects.filter(
            status='approved',
            school_name__iexact='WMSU-EXTERNAL SERVICES CORPORATION'
        )
        print(f"Base query count: {base_query.count()}")
        
        # Step 2: Try EXACT component matching first
        exact_matches = base_query.filter(
            last_name__iexact=lastname,
            first_name__iexact=firstname,
            middle_name__iexact=middlename
        )
        
        print(f"Exact matches count: {exact_matches.count()}")
        if exact_matches.exists():
            for apt in exact_matches:
                print(f"  - ID {apt.id}: {apt.full_name} (first: '{apt.first_name}', middle: '{apt.middle_name}', last: '{apt.last_name}')")
        else:
            print("  No exact matches found")
            
            # Step 3: Try lastname + firstname exact matching
            partial_matches = base_query.filter(
                last_name__iexact=lastname,
                first_name__iexact=firstname
            )
            
            print(f"Partial matches (lastname+firstname): {partial_matches.count()}")
            if partial_matches.exists():
                for apt in partial_matches:
                    print(f"  - ID {apt.id}: {apt.full_name} (first: '{apt.first_name}', middle: '{apt.middle_name}', last: '{apt.last_name}')")
                    
                # If we have middle name, try to narrow down further
                if middlename:
                    middle_filtered = partial_matches.filter(middle_name__iexact=middlename)
                    if middle_filtered.exists():
                        print(f"  Narrowed down by middle name: {middle_filtered.count()}")
                        for apt in middle_filtered:
                            print(f"    -> ID {apt.id}: {apt.full_name}")
                    else:
                        print(f"  No middle name matches for '{middlename}'")
            else:
                print("  No partial matches found")
    """Test the appointment matching logic"""
    print("Testing appointment matching logic...")
    
    # Create a test user
    try:
        user = User.objects.get(username='testuser')
    except User.DoesNotExist:
        user = User.objects.create_user(
            username='testuser',
            email='test@example.com',
            password='testpass123'
        )
    
    # Look for existing appointments with 'approved' status
    approved_appointments = Appointment.objects.filter(status='approved')
    
    print(f"Found {approved_appointments.count()} approved appointments")
    
    if approved_appointments.exists():
        sample_appointment = approved_appointments.first()
        print(f"Sample appointment: {sample_appointment.full_name} - {sample_appointment.school_name}")
        
        # Check if there's an exam score for this appointment
        exam_score = ExamScore.objects.filter(appointment=sample_appointment).first()
        if exam_score:
            print(f"Exam score found: {exam_score.score} (OAPR: {exam_score.oapr})")
        else:
            print("No exam score found for this appointment")
    else:
        print("No approved appointments found")
    
    # Check unmatched scores
    unmatched_scores = ExamScore.objects.filter(appointment__isnull=True)
    print(f"Found {unmatched_scores.count()} unmatched scores")
    
    if unmatched_scores.exists():
        sample_score = unmatched_scores.first()
        print(f"Sample unmatched score: {sample_score.name} - {sample_score.school}")

if __name__ == "__main__":
    test_appointment_matching()
