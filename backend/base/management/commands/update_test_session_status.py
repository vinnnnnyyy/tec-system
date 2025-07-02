from django.core.management.base import BaseCommand
from base.models import TestSession
from datetime import date

class Command(BaseCommand):
    help = 'Update test session status based on registration and exam dates'

    def handle(self, *args, **options):
        updated_count = 0
        sessions = TestSession.objects.filter(status__in=['SCHEDULED', 'ONGOING'])
        
        self.stdout.write(f"Checking {sessions.count()} test sessions for status updates...")
        
        for session in sessions:
            if session.check_and_update_status():
                updated_count += 1
                self.stdout.write(
                    self.style.SUCCESS(
                        f'Updated session {session.id} ({session.exam_type} - {session.exam_date}) to COMPLETED'
                    )
                )
        
        if updated_count == 0:
            self.stdout.write(self.style.WARNING('No test sessions needed status updates'))
        else:
            self.stdout.write(
                self.style.SUCCESS(f'Successfully updated {updated_count} test session(s) to COMPLETED status')
            )
