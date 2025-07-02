#!/usr/bin/env python
"""
Simple test script to verify test session status update functionality.
"""

import requests
import json
from datetime import date, timedelta

# Test the backend status update functionality
API_BASE = 'http://localhost:8000/api'

def test_status_update():
    print("Testing Test Session Status Update Functionality")
    print("=" * 50)
    
    try:
        # Test 1: Check if we can get test sessions
        print("1. Fetching test sessions...")
        response = requests.get(f'{API_BASE}/admin/test-sessions/')
        
        if response.status_code == 200:
            sessions = response.json()
            print(f"✓ Found {len(sessions)} test sessions")
            
            for session in sessions[:3]:  # Show first 3 sessions
                print(f"  - {session.get('exam_type', 'Unknown')} | "
                      f"Exam: {session.get('exam_date', 'Unknown')} | "
                      f"Registration End: {session.get('registration_end_date', 'Unknown')} | "
                      f"Status: {session.get('status', 'Unknown')}")
        else:
            print(f"✗ Failed to fetch sessions: {response.status_code}")
            return False
            
        # Test 2: Try to update status manually
        print("\n2. Testing manual status update...")
        response = requests.post(f'{API_BASE}/admin/test-sessions/update-status/')
        
        if response.status_code == 200:
            result = response.json()
            print(f"✓ Status update successful: {result.get('message', 'No message')}")
            if 'updated_count' in result:
                print(f"  Updated {result['updated_count']} session(s)")
        else:
            print(f"✗ Status update failed: {response.status_code}")
            try:
                error_detail = response.json()
                print(f"  Error: {error_detail}")
            except:
                print(f"  Error: {response.text}")
            
        # Test 3: Check sessions again to see if any status changed
        print("\n3. Checking sessions after update...")
        response = requests.get(f'{API_BASE}/admin/test-sessions/')
        
        if response.status_code == 200:
            sessions_after = response.json()
            print(f"✓ Sessions after update: {len(sessions_after)}")
            
            completed_sessions = [s for s in sessions_after if s.get('status') == 'COMPLETED']
            print(f"  Sessions with COMPLETED status: {len(completed_sessions)}")
            
            for session in completed_sessions[:3]:  # Show first 3 completed sessions
                print(f"  - {session.get('exam_type', 'Unknown')} | "
                      f"Exam: {session.get('exam_date', 'Unknown')} | "
                      f"Registration End: {session.get('registration_end_date', 'Unknown')} | "
                      f"Status: {session.get('status', 'Unknown')}")
        else:
            print(f"✗ Failed to fetch sessions after update: {response.status_code}")
            
        print("\n✓ Test completed successfully!")
        return True
        
    except requests.exceptions.ConnectionError:
        print("✗ Could not connect to Django server. Make sure it's running on localhost:8000")
        return False
    except Exception as e:
        print(f"✗ Test failed with error: {str(e)}")
        return False

if __name__ == '__main__':
    test_status_update()
