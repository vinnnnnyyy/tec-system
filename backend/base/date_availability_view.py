from django.db.models import Count
from django.http import JsonResponse
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from datetime import datetime, timedelta
from .models import Program, Appointment

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def program_availability(request, program_id):
    """
    Get availability for a program based on capacity limits.
    Returns a dictionary of dates and their availability status.
    """
    try:
        # Get query parameters for date range
        start_date_str = request.query_params.get('start_date')
        end_date_str = request.query_params.get('end_date')
        
        # Default to today if not provided
        if not start_date_str:
            start_date = datetime.now().date()
        else:
            start_date = datetime.strptime(start_date_str, '%Y-%m-%d').date()
        
        # Default to 3 months from now if not provided
        if not end_date_str:
            end_date = start_date + timedelta(days=90)
        else:
            end_date = datetime.strptime(end_date_str, '%Y-%m-%d').date()
        
        # Get the program
        program = Program.objects.get(id=program_id)
        capacity_limit = program.capacity_limit
        
        # Query appointments between the dates, grouped by date and time slot
        # Count how many appointments exist for each day
        appointments_count = Appointment.objects.filter(
            program_id=program_id,
            preferred_date__gte=start_date,
            preferred_date__lte=end_date,
            # Consider all relevant appointment statuses when checking capacity
            status__in=['pending', 'approved', 'rescheduled', 'waiting_for_test_details', 'waiting_for_submission', 'submitted']
        ).values('preferred_date', 'time_slot').annotate(
            count=Count('id')
        )
        
        # Store counts in a more accessible format
        date_counts = {}
        for item in appointments_count:
            date_str = item['preferred_date'].strftime('%Y-%m-%d')
            time_slot = item['time_slot']
            count = item['count']
            
            if date_str not in date_counts:
                date_counts[date_str] = {'morning': 0, 'afternoon': 0}
            
            date_counts[date_str][time_slot] = count
        
        # Generate the availability dictionary
        availability = {}
        current_date = start_date
        while current_date <= end_date:
            date_str = current_date.strftime('%Y-%m-%d')
            
            # Skip Sundays
            if current_date.weekday() == 6:  # 6 is Sunday in Python's weekday()
                availability[date_str] = {
                    'available': False,
                    'reason': 'Sunday',
                    'morning_count': 0,
                    'afternoon_count': 0
                }
            else:
                # Get counts for this date
                morning_count = date_counts.get(date_str, {}).get('morning', 0)
                afternoon_count = date_counts.get(date_str, {}).get('afternoon', 0)
                
                # Check if either slot is available
                morning_available = morning_count < capacity_limit
                afternoon_available = afternoon_count < capacity_limit
                
                availability[date_str] = {
                    'available': morning_available or afternoon_available,
                    'morning_available': morning_available,
                    'afternoon_available': afternoon_available,
                    'morning_count': morning_count,
                    'afternoon_count': afternoon_count,
                    'capacity': capacity_limit
                }
            
            current_date += timedelta(days=1)
        
        return JsonResponse({
            'program_id': program_id,
            'capacity_limit': capacity_limit,
            'availability': availability
        })
    
    except Program.DoesNotExist:
        return JsonResponse({'error': 'Program not found'}, status=404)
    except Exception as e:
        return JsonResponse({'error': str(e)}, status=500) 