#!/usr/bin/env python
"""
Test script to verify that the year field is being saved correctly during import.
"""

import os
import sys
import django
from pathlib import Path

# Add the backend directory to the Python path
backend_dir = Path(__file__).parent / 'backend'
sys.path.insert(0, str(backend_dir))

# Set up Django environment
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'backend.settings')
django.setup()

from base.models import ExamScore
from django.db.models import Q

def test_year_field():
    """Test if the year field is being saved correctly."""
    print("Testing year field in ExamScore model...")
    
    # Get the latest exam scores
    latest_scores = ExamScore.objects.all().order_by('-created_at')[:10]
    
    if not latest_scores.exists():
        print("No exam scores found in the database.")
        return
    
    print(f"Found {latest_scores.count()} exam scores:")
    print("-" * 80)
    print(f"{'ID':<5} {'Name':<30} {'Exam Type':<10} {'Year':<10} {'Created':<20}")
    print("-" * 80)
    
    for score in latest_scores:
        year_value = str(score.year) if score.year is not None else 'NULL'
        print(f"{score.id:<5} {score.name[:29]:<30} {score.exam_type:<10} {year_value:<10} {score.created_at.strftime('%Y-%m-%d %H:%M'):<20}")
        print(f"      -> Raw year value: {repr(score.year)}")
    
    # Count NULL years - check both None and empty string
    null_years = ExamScore.objects.filter(Q(year__isnull=True) | Q(year='') | Q(year__exact='')).count()
    
    # Also check specifically for None values
    none_years = ExamScore.objects.filter(year__isnull=True).count()
    empty_years = ExamScore.objects.filter(year='').count()
    total_scores = ExamScore.objects.count()
    
    print("-" * 80)
    print(f"Total scores: {total_scores}")
    print(f"Scores with NULL year (None): {none_years}")
    print(f"Scores with empty year (''): {empty_years}")
    print(f"Scores with NULL/empty year (total): {null_years}")
    print(f"Scores with year set: {total_scores - null_years}")
    
    if null_years > 0:
        print(f"\n⚠️  Warning: {null_years} scores have NULL/empty year values")
        print("This indicates that the year field is not being set during import.")
        print("The fix should resolve this issue for future imports.")
    else:
        print("\n✅ All scores have year values set correctly!")

if __name__ == "__main__":
    test_year_field()
