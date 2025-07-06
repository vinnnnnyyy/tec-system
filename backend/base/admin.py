from django.contrib import admin
from .models import (
    Program, Appointment, FAQ, ExamScore, 
    ExamResult, TestCenter, TestRoom, TestSession,
    Announcement, Notification
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

@admin.register(Notification)
class NotificationAdmin(admin.ModelAdmin):
    list_display = ('title', 'type', 'priority', 'user', 'is_global', 'is_read', 'created_at')
    list_filter = ('type', 'priority', 'is_global', 'is_read', 'created_at')
    search_fields = ('title', 'message', 'user__username')
    date_hierarchy = 'created_at'
    readonly_fields = ('created_at', 'updated_at')
    fieldsets = (
        ('Basic Information', {
            'fields': ('title', 'message', 'type', 'priority', 'icon')
        }),
        ('Target', {
            'fields': ('user', 'is_global')
        }),
        ('Status', {
            'fields': ('is_read', 'link')
        }),
        ('Timestamps', {
            'fields': ('created_at', 'updated_at'),
            'classes': ('collapse',)
        })
    )
