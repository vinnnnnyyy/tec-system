from django.db import models
from django.contrib.auth.models import User
from django.utils import timezone
from datetime import date

## program model
class Program(models.Model):
    name = models.CharField(max_length=200)
    code = models.CharField(max_length=50, unique=True)
    description = models.TextField()
    requirements = models.JSONField(default=list)
    status = models.CharField(max_length=20, default='active')
    icon = models.CharField(max_length=50, default='book')
    capacity_limit = models.IntegerField(default=1)
    availability_date = models.DateField()
    auto_approve_appointments = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f"{self.code} - {self.name}"

    class Meta:
        ordering = ['-created_at']

## FAQ model
class FAQ(models.Model):
    question = models.TextField()
    answer = models.TextField()
    category = models.CharField(max_length=100)
    icon = models.CharField(max_length=50, default='fas fa-question')
    is_active = models.BooleanField(default=True)
    order = models.IntegerField(default=0)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return self.question[:100] + "..."

    class Meta:
        ordering = ['order', '-created_at']
        verbose_name = 'FAQ'
        verbose_name_plural = 'FAQs'

# Appointment Model
class Appointment(models.Model):
    TIME_SLOT_CHOICES = [
        ('morning', 'Morning (8:00 AM - 12:00 PM)'),
        ('afternoon', 'Afternoon (1:00 PM - 5:00 PM)'),
    ]
    
    STATUS_CHOICES = [
        ('pending', 'Pending'),
        ('approved', 'Approved'),
        ('waiting_for_test_details', 'Waiting for Test Details'),
        ('waiting_for_submission', 'Waiting for Submission'),
        ('rejected', 'Rejected'),
        ('claimed', 'Claimed'),
        ('rescheduled', 'Rescheduled'),
        ('submitted', 'Submitted'),
        ('waiting_for_claiming', 'Waiting to be Claimed'),
    ]
    
    COLLEGE_LEVEL_CHOICES = [
        ('', 'Not Applicable'),
        ('undergraduate', 'Undergraduate'),
        ('graduate', 'Graduate'),
    ]
    
    GENDER_CHOICES = [
        ('male', 'Male'),
        ('female', 'Female'),
    ]
    
    APPLICANT_TYPE_CHOICES = [
        ('senior_high_graduating', 'Senior High School Graduating Student'),
        ('senior_high_graduate', 'Senior High School Graduate'),
        ('college', 'College Student'),
    ]
    
    # Base appointment fields
    program = models.ForeignKey(Program, on_delete=models.CASCADE, related_name='appointments')
    full_name = models.CharField(max_length=255)
    
    # Individual name components for CSV import matching
    last_name = models.CharField(max_length=100, blank=True, null=True)
    first_name = models.CharField(max_length=100, blank=True, null=True)
    middle_name = models.CharField(max_length=100, blank=True, null=True)
    
    email = models.EmailField()
    contact_number = models.CharField(max_length=20)
    school_name = models.CharField(max_length=255, blank=True, null=True)
    college_level = models.CharField(max_length=20, choices=COLLEGE_LEVEL_CHOICES, default='', blank=True)
    preferred_date = models.DateField()
    time_slot = models.CharField(max_length=20, choices=TIME_SLOT_CHOICES)
    status = models.CharField(max_length=30, choices=STATUS_CHOICES, default='waiting_for_submission')
    
    # New field for admin-assigned test time slot
    assigned_test_time_slot = models.CharField(max_length=20, choices=TIME_SLOT_CHOICES, blank=True, null=True)
    # Flag to track if admin has explicitly changed the time slot
    is_time_slot_modified = models.BooleanField(default=False)
    
    # Personal Information fields (from TestApplicationForm)
    birth_month = models.CharField(max_length=2, blank=True, null=True)
    birth_day = models.CharField(max_length=2, blank=True, null=True)
    birth_year = models.CharField(max_length=4, blank=True, null=True)
    gender = models.CharField(max_length=10, choices=GENDER_CHOICES, blank=True, null=True)
    age = models.IntegerField(blank=True, null=True)
    home_address = models.TextField(blank=True, null=True)
    citizenship = models.CharField(max_length=50, blank=True, null=True)
    
    # WMSUCET Experience fields
    is_first_time = models.BooleanField(default=True, blank=True, null=True)
    times_taken = models.IntegerField(blank=True, null=True)
    
    # Applicant Type and related information
    applicant_type = models.CharField(max_length=50, choices=APPLICANT_TYPE_CHOICES, blank=True, null=True)
    high_school_code = models.CharField(max_length=50, blank=True, null=True)
    
    # Additional school information based on applicant type
    school_graduation_date = models.CharField(max_length=50, blank=True, null=True)
    school_address = models.TextField(blank=True, null=True)
    college_course = models.CharField(max_length=100, blank=True, null=True)
    college_type = models.CharField(max_length=50, blank=True, null=True)
    
    # Meta fields
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='appointments', null=True, blank=True)
    
    # Test assignment fields
    test_session = models.ForeignKey('TestSession', on_delete=models.SET_NULL, null=True, blank=True, related_name='appointments')
    test_center = models.ForeignKey('TestCenter', on_delete=models.SET_NULL, null=True, blank=True, related_name='appointments')
    test_room = models.ForeignKey('TestRoom', on_delete=models.SET_NULL, null=True, blank=True, related_name='appointments')
    
    # Store the exam date directly on the appointment for easy access
    exam_date = models.DateField(null=True, blank=True, help_text="The actual exam date assigned to this appointment")
    
    # Add a field to track if this is an officially submitted application
    is_submitted = models.BooleanField(default=False)
    
    def __str__(self):
        return f"{self.full_name} - {self.program.name} ({self.preferred_date})"
    
    class Meta:
        ordering = ['-preferred_date', '-created_at']
        # Only prevent duplicate bookings for the same program, date, and time slot
        unique_together = ['email', 'program', 'preferred_date', 'time_slot']

    def save(self, *args, **kwargs):
        # Auto-update status based on current date and registration dates
        current_date = date.today()
        if self.status == 'pending':
            if self.program.availability_date <= current_date:
                self.status = 'waiting_for_test_details'
        
        super().save(*args, **kwargs)

# Exam Score Model
class ExamScore(models.Model):
    appointment = models.OneToOneField(Appointment, on_delete=models.CASCADE, related_name='exam_score', null=True, blank=True)
    app_no = models.CharField(max_length=50, null=True, blank=True)
    name = models.CharField(max_length=255, null=True, blank=True)
    school = models.CharField(max_length=255, null=True, blank=True)
    exam_type = models.CharField(max_length=50, null=True, blank=True, default='')
    score = models.CharField(max_length=20, null=True, blank=True)
    year = models.CharField(max_length=4, null=True, blank=True)
    # Add fields for test parts
    part1 = models.CharField(max_length=20, null=True, blank=True, verbose_name="English Proficiency")
    part2 = models.CharField(max_length=20, null=True, blank=True, verbose_name="Reading Comprehension")
    part3 = models.CharField(max_length=20, null=True, blank=True, verbose_name="Science Process Skills")
    part4 = models.CharField(max_length=20, null=True, blank=True, verbose_name="Quantitative Skills")
    part5 = models.CharField(max_length=20, null=True, blank=True, verbose_name="Abstract Thinking Skills")
    oapr = models.CharField(max_length=20, null=True, blank=True, verbose_name="Overall Ability Percentile Rank")
    exam_date = models.DateField(null=True, blank=True)
    imported_by = models.ForeignKey(User, on_delete=models.SET_NULL, null=True, blank=True, related_name='imported_scores')
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    def __str__(self):
        if self.appointment:
            return f"{self.appointment.full_name} - Score: {self.score}"
        else:
            return f"{self.name} - {self.exam_type} - App No: {self.app_no}"
            
    class Meta:
        indexes = [
            models.Index(fields=['app_no']),
            models.Index(fields=['exam_type']),
            models.Index(fields=['name']),
            models.Index(fields=['year']),
        ]

# Exam Result Model - For storing imported exam results
class ExamResult(models.Model):
    serial_no = models.IntegerField(null=True, blank=True)
    app_no = models.CharField(max_length=50)
    name = models.CharField(max_length=255)
    school = models.CharField(max_length=255)
    exam_type = models.CharField(max_length=50)
    year = models.CharField(max_length=4, null=True, blank=True)
    imported_by = models.ForeignKey(User, on_delete=models.SET_NULL, null=True, related_name='imported_results')
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    def __str__(self):
        return f"{self.name} - {self.exam_type} - App No: {self.app_no}"
    
    class Meta:
        ordering = ['serial_no', 'app_no']
        indexes = [
            models.Index(fields=['app_no']),
            models.Index(fields=['exam_type']),
            models.Index(fields=['name']),
            models.Index(fields=['year']),
        ]

# Test Center Model
class TestCenter(models.Model):
    name = models.CharField(max_length=255)
    code = models.CharField(max_length=20, unique=True)
    address = models.TextField(blank=True, null=True)
    is_active = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    def __str__(self):
        return f"{self.name} ({self.code})"

# Test Room Model
class TestRoom(models.Model):
    TIME_SLOT_CHOICES = [
        ('morning', 'Morning (8:00 AM - 12:00 PM)'),
        ('afternoon', 'Afternoon (1:00 PM - 5:00 PM)'),
    ]
    
    test_center = models.ForeignKey(TestCenter, on_delete=models.CASCADE, related_name='rooms')
    name = models.CharField(max_length=100)
    room_code = models.CharField(max_length=20)
    capacity = models.IntegerField(default=30)
    is_active = models.BooleanField(default=True)
    assigned_count = models.IntegerField(default=0, help_text="Number of students assigned to this room")
    available_capacity = models.IntegerField(default=30, help_text="Available capacity (calculated as capacity - assigned_count)")
    time_slot = models.CharField(max_length=20, choices=TIME_SLOT_CHOICES, default='morning')
    
    def save(self, *args, **kwargs):
        # Auto-calculate available capacity when saving
        self.available_capacity = self.capacity - self.assigned_count
        super().save(*args, **kwargs)
    
    def __str__(self):
        time_slot_display = "Morning" if self.time_slot == "morning" else "Afternoon"
        return f"{self.name} at {self.test_center.name} ({time_slot_display}, Capacity: {self.capacity}, Assigned: {self.assigned_count})"

# Test Session Model
class TestSession(models.Model):
    exam_type = models.CharField(max_length=50)
    registration_start_date = models.DateField()
    registration_end_date = models.DateField()
    exam_date = models.DateField()
    description = models.TextField(blank=True, null=True)
    status = models.CharField(max_length=20, choices=[
        ('SCHEDULED', 'Scheduled'),
        ('ONGOING', 'Ongoing'),
        ('COMPLETED', 'Completed'),
        ('CANCELLED', 'Cancelled')
    ], default='SCHEDULED')
    created_by = models.ForeignKey(User, on_delete=models.SET_NULL, null=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    def check_and_update_status(self):
        """
        Check if the registration and exam dates have passed and update status to COMPLETED
        """
        today = date.today()
        
        # If both registration end date and exam date have passed, mark as completed
        if (self.registration_end_date < today and 
            self.exam_date < today and 
            self.status not in ['COMPLETED', 'CANCELLED']):
            self.status = 'COMPLETED'
            self.save(update_fields=['status', 'updated_at'])
            return True
        return False
    
    def __str__(self):
        return f"{self.exam_type} - {self.exam_date}"

# Announcement Model
class Announcement(models.Model):
    TYPE_CHOICES = [
        ('New', 'New'),
        ('Update', 'Update'),
        ('Resource', 'Resource'),
        ('Event', 'Event'),
        ('Passers', 'Passers'),
    ]
    
    title = models.CharField(max_length=255)
    content = models.TextField()
    type = models.CharField(max_length=20, choices=TYPE_CHOICES, default='New')
    date = models.DateField(auto_now_add=True)
    icon = models.CharField(max_length=50, default='fas fa-bell')
    author = models.CharField(max_length=100, default='Admin Team')
    link = models.CharField(max_length=255, blank=True, null=True)
    image = models.ImageField(upload_to='announcements/', blank=True, null=True, help_text='Image file for announcement')
    image_url = models.URLField(max_length=1000, blank=True, null=True, help_text='External URL for announcement image (alternative to file upload)')
    is_active = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    created_by = models.ForeignKey(User, on_delete=models.SET_NULL, null=True, related_name='announcements')
    
    def __str__(self):
        return f"{self.title} ({self.type})"
    
    class Meta:
        ordering = ['-created_at']

# OTP Verification Model
class OTPVerification(models.Model):
    email = models.EmailField(unique=True)
    otp_code = models.CharField(max_length=6)
    is_verified = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)
    expires_at = models.DateTimeField()
    
    def __str__(self):
        return f"{self.email} - {'Verified' if self.is_verified else 'Not Verified'}"
    
    class Meta:
        ordering = ['-created_at']
