#!/usr/bin/env python
"""
Test script to verify the automatic test session status update functionality.
"""

import os
import sys
from datetime import date, timedelta

# Add the backend directory to Python path
sys.path.append(os.path.join(os.path.dirname(__file__), 'backend'))

# Setup Django environment
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'backend.settings')

try:
    import django
    django.setup()
    
    from base.models import TestSession
    from django.contrib.auth.models import User
    
    print("Testing automatic test session status update...")
    
    # Get or create a test user
    user, created = User.objects.get_or_create(
        username='testuser',
        defaults={'email': 'test@example.com', 'is_staff': True}
    )
    
    # Create a test session with past dates
    past_date = date.today() - timedelta(days=30)
    past_exam_date = date.today() - timedelta(days=10)
    
    test_session = TestSession.objects.create(
        exam_type='TEST_CET',
        registration_start_date=past_date - timedelta(days=30),
        registration_end_date=past_date,
        exam_date=past_exam_date,
        description='Test session for automatic status update',
        status='SCHEDULED',
        created_by=user
    )
    
    print(f"Created test session with ID: {test_session.id}")
    print(f"Initial status: {test_session.status}")
    print(f"Registration end date: {test_session.registration_end_date}")
    print(f"Exam date: {test_session.exam_date}")
    print(f"Current date: {date.today()}")
    
    # Test the automatic status update
    updated = test_session.check_and_update_status()
    
    # Refresh from database
    test_session.refresh_from_db()
    
    print(f"Status after update: {test_session.status}")
    print(f"Was updated: {updated}")
    
    if updated and test_session.status == 'COMPLETED':
        print("✓ Test PASSED: Status was correctly updated to COMPLETED")
    else:
        print("✗ Test FAILED: Status was not updated correctly")
    
    # Clean up
    test_session.delete()
    print("Test session cleaned up.")
    
except Exception as e:
    print(f"Error during test: {str(e)}")
    import traceback
    traceback.print_exc()
