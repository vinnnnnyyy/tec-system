from django.urls import path, include
from rest_framework.routers import DefaultRouter
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView
from .views import (
    ProgramViewSet, AppointmentViewSet, FAQViewSet, 
    TestCenterViewSet, TestRoomViewSet, TestSessionViewSet,
    import_exam_results, get_exam_results, generate_pdf, create_appointment,
    auto_assign_test_details, get_test_details, mark_application_submitted,
    batch_verify_applications, count_pending_applications, debug_test_assignments,
    get_room_assignment_counts, update_appointment_status,
    create_individual_test_detail, create_bulk_test_details, AnnouncementViewSet,
    get_student_exam_score, import_scores_api, get_exam_years,
    get_dashboard_stats, get_recent_appointments, reset_test_session_rooms,
    search_public_exam_scores, get_public_test_sessions
)
from .date_availability_view import program_availability
from .auth_views import (
    register_user, admin_login, validate_admin, 
    admin_users, delete_user, update_user, get_user_profile
)
from .otp_views import request_otp, signup_with_otp, verify_otp_endpoint

router = DefaultRouter()
router.register(r'programs', ProgramViewSet)
router.register(r'appointments', AppointmentViewSet)
router.register(r'admin/faqs', FAQViewSet)
router.register(r'admin/test-centers', TestCenterViewSet)
router.register(r'admin/test-rooms', TestRoomViewSet)
router.register(r'admin/test-sessions', TestSessionViewSet)
router.register(r'announcements', AnnouncementViewSet)

urlpatterns = [
    # Score import endpoints - try multiple variations to ensure accessibility
    path('score-import/', import_scores_api, name='import_scores_api'),
    path('appointments/import-scores/', import_scores_api, name='import_scores_api2'),
    path('appointments/import-scores/', import_scores_api, name='import_scores_api3'),
    path('admin/import-scores/', import_scores_api, name='import_scores_api4'),  # Additional admin path    # Student exam scores
    path('student/exam-score/', get_student_exam_score, name='get_student_exam_score'),
    
    # Public exam scores search endpoint
    path('public/search-exam-scores/', search_public_exam_scores, name='search_public_exam_scores'),
    
    # Public test sessions endpoint (for calendar highlighting)
    path('public/test-sessions/', get_public_test_sessions, name='get_public_test_sessions'),
    
    # Exam years endpoint
    path('exam-years/', get_exam_years, name='get_exam_years'),
    
    # Dashboard statistics endpoints
    path('admin/dashboard/stats/', get_dashboard_stats, name='get_dashboard_stats'),
    path('admin/dashboard/recent-appointments/', get_recent_appointments, name='get_recent_appointments'),
    
    # Then include the router URLs
    path('', include(router.urls)),
    
    # Authentication routes
    path('token/', TokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
    path('register/', register_user, name='register'),
    path('admin/login/', admin_login, name='admin_login'),
    path('admin/validate/', validate_admin, name='validate_admin'),
    path('admin/users/', admin_users, name='admin_users'),
    path('admin/users/<int:user_id>/', delete_user, name='delete_user'),
    path('admin/users/<int:user_id>/update/', update_user, name='update_user'),
    path('profile/', get_user_profile, name='get_user_profile'),
    
    # OTP verification routes
    path('request-otp/', request_otp, name='request_otp'),
    path('signup-with-otp/', signup_with_otp, name='signup_with_otp'),
    path('verify-otp/', verify_otp_endpoint, name='verify_otp'),
    
    # Application and exam routes
    path('admin/applications/batch-verify/', batch_verify_applications, name='batch_verify_applications'),
    # Add alternative path to support the URL being used in the frontend
    path('admin/appointments/batch-verify/', batch_verify_applications, name='batch_verify_appointments'),
    path('admin/applications/count-pending/', count_pending_applications, name='count_pending_applications'),
    path('admin/test-rooms/assignments/count/', get_room_assignment_counts, name='get_room_assignment_counts'),
    path('admin/auto-assign/', auto_assign_test_details, name='auto_assign_test_details'),
    path('admin/test-details/', create_individual_test_detail, name='create_individual_test_detail'),
    path('admin/test-details/create-bulk/', create_bulk_test_details, name='create_bulk_test_details'),
    path('admin/test-session/reset-rooms/', reset_test_session_rooms, name='reset_test_session_rooms'),
    path('programs/<int:program_id>/availability/', program_availability, name='program_availability'),
    path('appointments/create/', create_appointment, name='create_appointment'),
    path('appointments/<int:appointment_id>/mark-submitted/', mark_application_submitted, name='mark_application_submitted'),
    path('appointments/<int:appointment_id>/test-details/', get_test_details, name='get_test_details'),
    
    # Results import/export
    path('admin/results/import/', import_exam_results, name='import_exam_results'),
    path('admin/results/', get_exam_results, name='get_exam_results'),
    path('generate-pdf/<int:appointment_id>/', generate_pdf, name='generate_pdf'),
    
    # Debug endpoint
    path('debug/test-assignments/', debug_test_assignments, name='debug_test_assignments'),
    path('admin/update-appointment-status/', update_appointment_status, name='update_appointment_status'),

    # Exam years endpoint
    path('admin/exam-years/', get_exam_years, name='get_exam_years'),
]
