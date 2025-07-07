# Gmail SMTP Notification System

This document describes the Gmail SMTP notification system integrated with the NotificationViewSet.

## Overview

The system automatically sends Gmail notifications whenever:
1. A notification is created through the NotificationViewSet
2. An appointment status changes 
3. Exam results or scores are released

## Features

### 🔧 **Automatic Email Notifications**
- **Status Changes**: Users receive emails when their appointment status changes
- **Exam Results**: Global notifications sent to all users when exam results are released
- **Custom Notifications**: Admin-created notifications automatically trigger emails

### 📧 **Email Types**
1. **Individual Notifications**: Sent to specific users for appointment-related updates
2. **Global Notifications**: Sent to all active users for exam results/announcements
3. **Digest Emails**: Multiple notifications bundled into one email (future feature)

### 🎨 **Professional Email Design**
- **Responsive HTML Templates**: Beautiful, mobile-friendly email design
- **Branded Styling**: TEC-themed colors and styling
- **Action Buttons**: Direct links to relevant sections of the application
- **Priority Indicators**: Visual indicators for notification priority levels

## Configuration

### Environment Variables (`.env`)
```properties
# Email Configuration (Gmail SMTP)
EMAIL_BACKEND=django.core.mail.backends.smtp.EmailBackend
EMAIL_HOST=smtp.gmail.com
EMAIL_PORT=587
EMAIL_USE_TLS=True
EMAIL_HOST_USER=your-email@gmail.com
EMAIL_HOST_PASSWORD=your-app-password
DEFAULT_FROM_EMAIL=your-email@gmail.com

# Frontend URL for email links
FRONTEND_URL=http://localhost:3001
```

### Gmail Setup
1. **Enable 2-Factor Authentication** on your Gmail account
2. **Generate App Password**:
   - Go to Google Account settings
   - Security → 2-Step Verification → App passwords
   - Generate password for "Mail"
3. **Update .env** with your email and app password

## API Endpoints

### Test Endpoints
```bash
# Test individual Gmail notification
POST /api/test/gmail-notification/
Authorization: Bearer <token>

# Test bulk Gmail notification (global)
POST /api/test/bulk-gmail-notification/
Authorization: Bearer <token>

# Test notification creation (also sends email)
POST /api/test/create-notification/
Authorization: Bearer <token>
```

### Notification CRUD
```bash
# Create notification (automatically sends email)
POST /api/notifications/
Authorization: Bearer <token>
{
    "title": "Your notification title",
    "message": "Your notification message",
    "type": "appointment",
    "priority": "normal",
    "is_global": false
}

# List user notifications
GET /api/notifications/
Authorization: Bearer <token>

# Mark notification as read
POST /api/notifications/{id}/mark-read/
Authorization: Bearer <token>

# Mark all notifications as read
POST /api/notifications/mark-all-read/
Authorization: Bearer <token>
```

## Email Templates

### Status Change Email
- **Subject**: `[TEC] Appointment Approved` (example)
- **Content**: Appointment details, status change information
- **Action**: Link to profile page

### Exam Results Email
- **Subject**: `[TEC] Exam Results Released`
- **Content**: Exam type, year, score count
- **Action**: Link to results page

### Custom Notification Email
- **Subject**: `[TEC] {notification.title}`
- **Content**: Custom message from admin
- **Action**: Link to specified page

## Priority Colors

```css
low: #28a745 (Green)
normal: #007bff (Blue)
high: #ffc107 (Yellow)
urgent: #dc3545 (Red)
```

## Functions

### Core Functions

#### `send_gmail_notification(notification, user_email=None)`
- Sends individual Gmail notification
- Returns `True` if successful, `False` otherwise

#### `send_bulk_gmail_notifications(notification)`
- Sends Gmail notification to all active users
- Used for global notifications
- Returns `True` if any emails were sent successfully

#### `send_notification_digest_email(user, notifications)`
- Sends digest email with multiple notifications
- Useful for daily/weekly notification summaries

### Helper Functions

#### `get_priority_color(priority)`
- Returns color code for notification priority

#### `get_action_button_html(notification)`
- Generates action button HTML for emails

## Integration

### Automatic Triggers

1. **NotificationViewSet.create()**: Automatically sends email when notification is created
2. **create_status_change_notification()**: Sends email when appointment status changes
3. **create_exam_results_notification()**: Sends bulk emails when exam results are released
4. **create_exam_scores_notification()**: Sends bulk emails when exam scores are released

### Error Handling
- Email failures don't prevent notification creation
- Errors are logged but don't break the application flow
- Graceful fallback for missing email addresses

## Testing

### Manual Testing
1. **Configure Gmail**: Set up Gmail SMTP credentials in `.env`
2. **Test Individual**: Call `/api/test/gmail-notification/`
3. **Test Bulk**: Call `/api/test/bulk-gmail-notification/`
4. **Check Email**: Verify emails are received in target inboxes

### Production Considerations
- **Rate Limits**: Gmail has sending limits (500 emails/day for free accounts)
- **Authentication**: Use App Passwords, not regular passwords
- **Monitoring**: Monitor email delivery success rates
- **Fallbacks**: Consider backup email providers for high-volume scenarios

## Security

### Best Practices
- ✅ Gmail App Passwords (not regular passwords)
- ✅ Environment variables for credentials
- ✅ TLS encryption for SMTP
- ✅ No sensitive data in email templates
- ✅ User email validation

### Privacy
- Only sends to users with valid email addresses
- Respects user account status (active users only)
- No email tracking or analytics

## Troubleshooting

### Common Issues

1. **Authentication Failed**
   - Solution: Use App Password instead of regular password
   - Enable 2-Factor Authentication first

2. **Connection Refused**
   - Solution: Check firewall settings
   - Verify Gmail SMTP settings (smtp.gmail.com:587)

3. **No Emails Received**
   - Solution: Check spam folder
   - Verify email address in user profile

4. **HTML Not Rendering**
   - Solution: Check email client HTML support
   - Plain text fallback is always included

### Debug Commands
```bash
# Test Django email configuration
python manage.py shell
>>> from django.core.mail import send_mail
>>> send_mail('Test', 'Test message', 'from@email.com', ['to@email.com'])

# Check notification creation
python manage.py shell
>>> from base.models import Notification
>>> Notification.objects.all()
```

## Future Enhancements

- [ ] Email templates as Django templates
- [ ] Notification preferences per user
- [ ] Email scheduling/queuing system
- [ ] Email analytics and tracking
- [ ] Multiple email provider support
- [ ] Rich text editor for admin notifications
