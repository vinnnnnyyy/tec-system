#!/usr/bin/env python
"""
Script to clean up incorrect exam score matches
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

def clean_incorrect_matches():
    """Clean up incorrect exam score matches"""
    print("=== Cleaning Incorrect Exam Score Matches ===")
    
    # Delete all existing scores first to start fresh
    all_scores = ExamScore.objects.all()
    print(f"Found {all_scores.count()} existing scores")
    
    for score in all_scores:
        if score.appointment:
            print(f"Deleting score ID {score.id}: {score.name} (OAPR: {score.oapr}) -> Appointment ID {score.appointment.id}")
        else:
            print(f"Deleting unmatched score ID {score.id}: {score.name} (OAPR: {score.oapr})")
        score.delete()
    
    print(f"Deleted all {all_scores.count()} scores. Database is now clean for fresh import.")

def show_current_appointments():
    """Show current appointment data for reference"""
    print("\n=== Current Appointments (for reference) ===")
    appointments = Appointment.objects.filter(status='approved')
    
    for apt in appointments:
        print(f"ID {apt.id}: {apt.full_name}")
        print(f"  - First: '{apt.first_name}', Middle: '{apt.middle_name}', Last: '{apt.last_name}'")
        print(f"  - School: '{apt.school_name}'")
        print(f"  - Exam Date: {apt.exam_date}")
        print()

if __name__ == "__main__":
    show_current_appointments()
    clean_incorrect_matches()
    print("\nReady for fresh import test!")
