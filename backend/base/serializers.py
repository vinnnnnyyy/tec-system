from rest_framework import serializers
from django.utils import timezone
import datetime
from .models import Program, Appointment, FAQ, ExamScore, ExamResult, TestCenter, TestRoom, TestSession, Announcement, Notification

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
            'exam_date', 'exam_score',
            # Personal Information fields
            'birth_month', 'birth_day', 'birth_year', 'gender', 'age',
            'home_address', 'citizenship',
            # WMSUCET Experience fields
            'is_first_time', 'times_taken',
            # Applicant Type and related information
            'applicant_type', 'high_school_code',
            # Additional school information
            'school_graduation_date', 'school_address',
            'college_course', 'college_type',
            # Course choices and campus information
            'first_choice_course', 'first_choice_campus',
            'second_choice_course', 'second_choice_campus',
            'third_choice_course', 'third_choice_campus',
            # Socio-economic data - Father information
            'father_citizenship', 'father_education', 'father_work_occupation',
            'father_employer', 'father_monthly_income',
            # Socio-economic data - Mother information
            'mother_citizenship', 'mother_education', 'mother_work_occupation',
            'mother_employer', 'mother_monthly_income',
            # Physical disability information
            'has_physical_disability', 'disability_description',
            # Computer usage knowledge
            'knows_computer_usage',
            # Indigenous Peoples Group membership
            'is_indigenous_member', 'indigenous_group_specify',
            # Religious affiliation
            'religious_affiliation', 'religious_affiliation_others'
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
    image_display = serializers.SerializerMethodField()
    
    class Meta:
        model = Announcement
        fields = '__all__'
        read_only_fields = ['created_at', 'updated_at', 'created_by']
    
    def get_image_display(self, obj):
        """Return the appropriate image URL - either uploaded file or external URL"""
        if obj.image:
            request = self.context.get('request')
            if request:
                return request.build_absolute_uri(obj.image.url)
            return obj.image.url
        elif obj.image_url:
            return obj.image_url
        return None

class NotificationSerializer(serializers.ModelSerializer):
    user_name = serializers.CharField(source='user.username', read_only=True)
    created_by_name = serializers.CharField(source='created_by.username', read_only=True)
    time_ago = serializers.SerializerMethodField()
    
    class Meta:
        model = Notification
        fields = [
            'id', 'title', 'message', 'type', 'priority', 'user', 'user_name',
            'is_read', 'is_global', 'icon', 'link', 'created_by', 'created_by_name',
            'created_at', 'updated_at', 'time_ago'
        ]
        read_only_fields = ['created_at', 'updated_at', 'created_by']
    
    def get_time_ago(self, obj):
        """Return a human-readable time difference"""
        now = timezone.now()
        diff = now - obj.created_at
        
        if diff.days > 0:
            return f"{diff.days} day{'s' if diff.days > 1 else ''} ago"
        elif diff.seconds >= 3600:
            hours = diff.seconds // 3600
            return f"{hours} hour{'s' if hours > 1 else ''} ago"
        elif diff.seconds >= 60:
            minutes = diff.seconds // 60
            return f"{minutes} minute{'s' if minutes > 1 else ''} ago"
        else:
            return "Just now"
