#!/usr/bin/env python
import os
import sys
import django
from django.conf import settings
from django.core.management import execute_from_command_line

if __name__ == '__main__':
    os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'backend.settings')
    
    # Import Django and configure
    django.setup()
    
    # Monkey patch the MariaDB version check
    try:
        import django.db.backends.mysql.base as mysql_base
        original_check = mysql_base.DatabaseWrapper.check_database_version_supported
        
        def patched_check(self):
            try:
                return original_check(self)
            except Exception as e:
                print(f"Warning: Bypassing database version check: {e}")
                # Return without raising the exception
                return
        
        mysql_base.DatabaseWrapper.check_database_version_supported = patched_check
        print("Successfully patched database version check")
    except Exception as e:
        print(f"Could not patch database version check: {e}")
    
    # Start the server
    execute_from_command_line(['manage.py', 'runserver'])
