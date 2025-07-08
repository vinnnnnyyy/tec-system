#!/usr/bin/env python
"""
Test script to verify the improved exam score import functionality
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

def test_appointment_data():
    """Test what appointment data we have"""
    print("=== Current Appointment Data ===")
    
    # Show all approved appointments
    approved_appointments = Appointment.objects.filter(status='approved')
    print(f"Total approved appointments: {approved_appointments.count()}")
    
    for apt in approved_appointments:
        print(f"ID {apt.id}: {apt.full_name}")
        print(f"  - First: '{apt.first_name}', Middle: '{apt.middle_name}', Last: '{apt.last_name}'")
        print(f"  - School: '{apt.school_name}'")
        print(f"  - Exam Date: {apt.exam_date}")
        print()

def test_score_matching():
    """Test the score matching logic"""
    print("=== Current ExamScore Data ===")
    
    scores = ExamScore.objects.all()
    print(f"Total scores: {scores.count()}")
    
    for score in scores:
        if score.appointment:
            print(f"Score ID {score.id}: {score.name} (OAPR: {score.oapr}) -> Appointment ID {score.appointment.id}")
        else:
            print(f"Score ID {score.id}: {score.name} (OAPR: {score.oapr}) -> UNMATCHED")
    
    print("\n=== Checking for Duplicates ===")
    
    # Check for duplicate scores per appointment
    appointments_with_scores = Appointment.objects.filter(examscore__isnull=False).distinct()
    for apt in appointments_with_scores:
        score_count = ExamScore.objects.filter(appointment=apt).count()
        if score_count > 1:
            print(f"WARNING: Appointment {apt.id} has {score_count} scores!")
            for score in ExamScore.objects.filter(appointment=apt):
                print(f"  - Score ID {score.id}: OAPR {score.oapr}")
        else:
            score = ExamScore.objects.filter(appointment=apt).first()
            print(f"OK: Appointment {apt.id} has 1 score (OAPR: {score.oapr})")

def clean_duplicate_scores():
    """Remove duplicate scores if any"""
    print("\n=== Cleaning Duplicate Scores ===")
    
    appointments_with_scores = Appointment.objects.filter(examscore__isnull=False).distinct()
    for apt in appointments_with_scores:
        scores = ExamScore.objects.filter(appointment=apt).order_by('id')
        if scores.count() > 1:
            print(f"Removing duplicate scores for appointment {apt.id}")
            # Keep the first one, remove the rest
            for score in scores[1:]:
                print(f"  - Removing score ID {score.id}")
                score.delete()

if __name__ == "__main__":
    print("Testing appointment matching logic...")
    test_appointment_data()
    test_score_matching()
    
    # Uncomment to clean duplicates
    # clean_duplicate_scores()
