# Exam Score Import Implementation Summary

## Changes Made

### 1. Backend Changes (views.py)
- Updated `import_scores_api` function to use `middlename` instead of `middleinitial`
- Changed matching logic to look for appointments with `approved` status instead of `submitted`
- Improved name matching by checking individual name components (lastname, firstname, middlename)
- Added case-insensitive matching for names and schools
- Added date matching using both exam_date and preferred_date fields
- Added debug logging for better troubleshooting

### 2. CSV Format Update
- CSV format now expects: `app_no,lastname,firstname,middlename,school,date,part1,part2,part3,part4,part5,oapr`
- Updated sample CSV file to use the new format
- Updated all related documentation and UI text

### 3. Frontend Changes (ExamResultsImport.vue)
- Updated import guidelines to reflect new CSV format
- Added information about approved appointment matching requirement
- Fixed import function to properly send file to backend API
- Improved error handling and success messaging

### 4. Profile View Updates (Profile.vue)
- Updated to display exam scores for both `submitted` and `approved` appointments
- Maintains existing functionality for score viewing and detailed score display

### 5. Additional Files Updated
- `new_import_scores_api.py` - Updated to use new CSV format
- `ImportScore.vue` - Updated documentation
- `sample_exam_scores.csv` - Provides correct format example

## How It Works

1. **CSV Upload**: Admin uploads CSV file with exam scores
2. **Parsing**: System reads CSV and extracts name components, school, and scores
3. **Matching**: For each CSV row, system looks for appointments with:
   - Status = 'approved'
   - Matching lastname, firstname, middlename (case-insensitive)
   - Matching school name (case-insensitive)
   - Optionally matching exam date
4. **Score Creation**: Creates ExamScore records linked to matched appointments
5. **Profile Display**: Students can view their scores in their profile if they have approved appointments with scores

## Testing

Use the provided `sample_exam_scores.csv` file to test the import functionality. The CSV should contain:
- Valid application numbers
- Full names split into lastname, firstname, middlename
- School names that match existing appointments
- Exam dates in YYYY-MM-DD format
- Score values for all test parts

## Notes

- Appointments must have `approved` status to be matched with imported scores
- Names are matched case-insensitively for better compatibility
- Unmatched scores are still imported but without appointment links
- The system handles both exact name matching and partial matching for flexibility
