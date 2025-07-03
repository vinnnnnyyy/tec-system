from rest_framework import serializers
from .models import Program, Appointment, FAQ, ExamScore, ExamResult, TestCenter, TestRoom, TestSession, Announcement

class ProgramSerializer(serializers.ModelSerializer):
    class Meta:
        model = Program
        fields = ['id', 'code', 'name', 'description', 'status', 'requirements', 'icon', 'capacity_limit', 'availability_date', 'auto_approve_appointments']
        read_only_fields = ['id', 'created_at', 'updated_at']

class AppointmentSerializer(serializers.ModelSerializer):
    program_name = serializers.CharField(source='program.name', read_only=True)
    test_center_name = serializers.CharField(source='test_center.name', read_only=True)
    test_room_name = serializers.CharField(source='test_room.name', read_only=True)
    test_session_date = serializers.DateField(source='test_session.exam_date', read_only=True)
    exam_score = serializers.SerializerMethodField()
    
    class Meta:
        model = Appointment
        fields = [
            'id', 'program', 'program_name', 'full_name', 'last_name', 'first_name', 'middle_name',
            'email', 'contact_number', 'school_name', 'college_level', 'preferred_date', 'time_slot', 'status',
            'created_at', 'updated_at', 'birth_month', 'birth_day', 'birth_year',
            'gender', 'age', 'home_address', 'citizenship', 'is_first_time',
            'times_taken', 'applicant_type', 'high_school_code', 'school_graduation_date',
            'school_address', 'college_course', 'college_type', 'is_submitted',
            'test_session', 'test_center', 'test_room', 'test_center_name',
            'test_room_name', 'test_session_date', 'assigned_test_time_slot', 'is_time_slot_modified',
            'exam_score',
            # Personal Information fields
            'birth_month', 'birth_day', 'birth_year', 'gender', 'age',
            'home_address', 'citizenship',
            # WMSUCET Experience fields
            'is_first_time', 'times_taken',
            # Applicant Type and related information
            'applicant_type', 'high_school_code',
            # Additional school information
            'school_graduation_date', 'school_address',
            'college_course', 'college_type'
        ]
        read_only_fields = ['id', 'created_at', 'updated_at', 'user']

    def get_exam_score(self, obj):
        try:
            exam_score = obj.exam_score
            if exam_score:
                return {
                    'score': exam_score.score,
                    'part1': exam_score.part1,
                    'part2': exam_score.part2,
                    'part3': exam_score.part3,
                    'part4': exam_score.part4,
                    'part5': exam_score.part5,
                    'oapr': exam_score.oapr,
                    'exam_date': exam_score.exam_date,
                    'created_at': exam_score.created_at
                }
            return None
        except Appointment.exam_score.RelatedObjectDoesNotExist:
            return None

class FAQSerializer(serializers.ModelSerializer):
    class Meta:
        model = FAQ
        fields = ['id', 'question', 'answer', 'category', 'icon', 'is_active', 'order', 'created_at', 'updated_at']
        read_only_fields = ['id', 'created_at', 'updated_at']

class ExamScoreSerializer(serializers.ModelSerializer):
    class Meta:
        model = ExamScore
        fields = ['id', 'score', 'part1', 'part2', 'part3', 'part4', 'part5', 'oapr', 'exam_date', 'created_at']

# Add detailed exam score serializer
class ExamScoreDetailSerializer(serializers.ModelSerializer):
    class Meta:
        model = ExamScore
        fields = [
            'id', 'app_no', 'name', 'school', 'exam_type', 'score', 'year',
            'part1', 'part2', 'part3', 'part4', 'part5', 'oapr',
            'exam_date', 'created_at'
        ]

class TestCenterSerializer(serializers.ModelSerializer):
    class Meta:
        model = TestCenter
        fields = ['id', 'name', 'code', 'address', 'is_active']

class TestRoomSerializer(serializers.ModelSerializer):
    center_name = serializers.CharField(source='test_center.name', read_only=True)
    
    class Meta:
        model = TestRoom
        fields = ['id', 'test_center', 'center_name', 'name', 'room_code', 'capacity', 'is_active', 'time_slot', 'assigned_count', 'available_capacity']

class TestSessionSerializer(serializers.ModelSerializer):
    class Meta:
        model = TestSession
        fields = ['id', 'exam_type', 'registration_start_date', 'registration_end_date', 
                  'exam_date', 'description', 'status']
        read_only_fields = ['created_by', 'created_at', 'updated_at']

class AnnouncementSerializer(serializers.ModelSerializer):
    class Meta:
        model = Announcement
        fields = '__all__'
        read_only_fields = ['created_at', 'updated_at', 'created_by']
