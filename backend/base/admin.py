from django.contrib import admin
from .models import (
    Program, Appointment, FAQ, ExamScore, 
    ExamResult, TestCenter, TestRoom, TestSession,
    Announcement
)

@admin.register(Program)
class ProgramAdmin(admin.ModelAdmin):
    list_display = ('name', 'code', 'status', 'capacity_limit', 'availability_date')
    search_fields = ('name', 'code')
    list_filter = ('status',)

@admin.register(Appointment)
class AppointmentAdmin(admin.ModelAdmin):
    list_display = ('full_name', 'email', 'program', 'preferred_date', 'time_slot', 'status')
    list_filter = ('status', 'time_slot', 'preferred_date')
    search_fields = ('full_name', 'email', 'school_name')
    date_hierarchy = 'preferred_date'

admin.site.register(FAQ)
admin.site.register(ExamScore)
admin.site.register(ExamResult)
admin.site.register(TestCenter)
admin.site.register(TestRoom)
admin.site.register(TestSession)
admin.site.register(Announcement)
