import requests
import json
from django.conf import settings
from django.urls import reverse
from django.core.mail import send_mail, EmailMultiAlternatives
from django.template.loader import render_to_string
from django.utils.html import strip_tags
from django.contrib.auth.models import User

def send_test_details_notification(appointment):
    """
    Send notification email to user when test details are assigned
    """
    try:
        # Get required appointment data
        email = appointment.email
        full_name = appointment.full_name
        program_name = appointment.program.name if appointment.program else "CET"
        
        # Get test details
        test_session = appointment.test_session
        test_center = appointment.test_center
        test_room = appointment.test_room
        
        # Skip if any required test detail is missing
        if not test_session or not test_center or not test_room:
            print(f"Skipping notification for {email}: Missing test details")
            return False
        
        # Format test date
        test_date = test_session.exam_date.strftime("%B %d, %Y") if test_session.exam_date else "TBA"
        
        # Format time slot
        time_slot = appointment.assigned_test_time_slot or appointment.time_slot
        reporting_time = "7:30 AM" if time_slot == "morning" else "12:30 PM"
        
        # URL for MailerSend API
        url = "https://api.mailersend.com/v1/email"
        
        # Set headers for API request
        headers = {
            "Content-Type": "application/json",
            "X-Requested-With": "XMLHttpRequest",
            "Authorization": f"Bearer {settings.MAILERSEND_API_KEY}"
        }
        
        # Prepare email content
        data = {
            "from": {
                "email": settings.MAILERSEND_DEFAULT_FROM,
                "name": settings.MAILERSEND_DEFAULT_FROM_NAME
            },
            "to": [
                {
                    "email": email,
                    "name": full_name
                }
            ],
            "subject": f"Your {program_name} Test Details Are Ready",
            "text": f"""
Hello {full_name},

Your test details for the {program_name} have been assigned:

Test Date: {test_date}
Test Center: {test_center.name}
Room: {test_room.name} {test_room.room_code}
Reporting Time: {reporting_time}

Please bring the following requirements on the day of your exam:
1. Valid ID (School ID, Government ID, or any valid photo ID)
2. Printed copy of your Application Form
3. At least two #2 pencils
4. Non-programmable calculator (if required)

You can download your application form from your account dashboard.

If you have any questions, please contact us at admin@example.com.

Thank you,
{settings.MAILERSEND_DEFAULT_FROM_NAME}
            """,
            "html": f"""
<div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px; border: 1px solid #eee; border-radius: 5px;">
    <!-- Header with WMSU Logo -->
    <div style="text-align: center; margin-bottom: 30px; padding: 20px; background: linear-gradient(135deg, #8B0000 0%, #A0002A 100%); border-radius: 5px; color: white;">
        <img src="https://wmsu.edu.ph/wp-content/uploads/2024/05/site_logo.png" 
             alt="WMSU Logo" 
             style="height: 50px; width: auto; margin-bottom: 10px; filter: brightness(0) invert(1);"
             onerror="this.style.display='none'">
        <div style="font-size: 14px; font-weight: bold; margin-bottom: 5px; opacity: 0.9;">
            Western Mindanao State University
        </div>
        <div style="font-size: 12px; opacity: 0.8; margin-bottom: 15px;">
            Testing and Evaluation Center
        </div>
        <h1 style="color: white; margin: 0; font-size: 20px;">Your Test Details Are Ready</h1>
    </div>

    <p>Hello {full_name},</p>
    
    <p>Your test details for the <strong>{program_name}</strong> have been assigned:</p>
    
    <div style="background-color: #f8f9fa; padding: 15px; border-radius: 5px; margin: 20px 0;">
        <table style="width: 100%;">
            <tr>
                <td style="padding: 8px 0; font-weight: bold;">Test Date:</td>
                <td style="padding: 8px 0;">{test_date}</td>
            </tr>
            <tr>
                <td style="padding: 8px 0; font-weight: bold;">Test Center:</td>
                <td style="padding: 8px 0;">{test_center.name}</td>
            </tr>
            <tr>
                <td style="padding: 8px 0; font-weight: bold;">Room:</td>
                <td style="padding: 8px 0;">{test_room.name} {test_room.room_code}</td>
            </tr>
            <tr>
                <td style="padding: 8px 0; font-weight: bold;">Reporting Time:</td>
                <td style="padding: 8px 0;">{reporting_time}</td>
            </tr>
        </table>
    </div>
    
    <h3 style="color: #8B0000;">What to Bring:</h3>
    <ul style="padding-left: 20px;">
        <li>Valid ID (School ID, Government ID, or any valid photo ID)</li>
        <li>Printed copy of your Application Form</li>
        <li>At least two #2 pencils</li>
        <li>Non-programmable calculator (if required)</li>
    </ul>
    
    <div style="margin: 25px 0; text-align: center;">
        <a href="#" style="background-color: #8B0000; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px; font-weight: bold;">Download Application Form</a>
    </div>
    
    <p>If you have any questions, please contact us at <a href="mailto:admin@example.com">admin@example.com</a>.</p>
    
    <p>Thank you,<br/>{settings.MAILERSEND_DEFAULT_FROM_NAME}</p>
    
    <div style="margin-top: 20px; padding-top: 20px; border-top: 1px solid #eee; font-size: 12px; color: #666;">
        <p>This is an automated message, please do not reply to this email.</p>
    </div>
</div>
            """
        }
        
        # Make the API request
        response = requests.post(url, headers=headers, json=data)
        
        # Check response
        if response.status_code >= 200 and response.status_code < 300:
            print(f"Test details notification sent successfully to {email}")
            return True
        else:
            print(f"Error sending test details notification: {response.status_code} - {response.text}")
            return False
    
    except Exception as e:
        print(f"Exception sending test details notification: {str(e)}")
        return False

def send_gmail_notification(notification, user_email=None, appointment=None):
    """
    Send Gmail SMTP notification based on a Notification object
    Only sends emails for appointment-related notifications
    """
    try:
        # Only send Gmail notifications for appointment-related events
        if notification.type != 'appointment':
            print(f"Skipping Gmail notification for type '{notification.type}' - only appointment notifications are sent via email")
            return True  # Return True to indicate success (notification was processed)
        
        # Determine recipient email
        if user_email:
            recipient_email = user_email
        elif notification.user:
            recipient_email = notification.user.email
        else:
            # For global notifications, we'll need to handle this differently
            print("No specific user email found for notification")
            return False
        
        if not recipient_email:
            print(f"No email found for notification {notification.id}")
            return False
        
        # Get recipient name
        recipient_name = "User"
        if notification.user:
            recipient_name = notification.user.get_full_name() or notification.user.username
        
        # Format subject
        subject = f"[TEC] {notification.title}"
        
        # Get appointment details HTML if this is an appointment notification
        appointment_details_html = get_appointment_details_html(notification, appointment)
        
        # Create HTML email content
        html_content = f"""
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{notification.title}</title>
</head>
<body style="font-family: Arial, sans-serif; background-color: #f5f5f5; margin: 0; padding: 20px;">
    <div style="max-width: 600px; margin: 0 auto; background-color: white; border-radius: 8px; overflow: hidden; box-shadow: 0 2px 10px rgba(0,0,0,0.1);">
        
        <!-- Header -->
        <div style="background: linear-gradient(135deg, #8B0000 0%, #A0002A 100%); color: white; padding: 30px 20px; text-align: center;">
            <!-- WMSU Logo -->
            <div style="margin-bottom: 20px;">
                <img src="https://wmsu.edu.ph/wp-content/uploads/2024/05/site_logo.png" 
                     alt="WMSU Logo" 
                     style="height: 60px; width: auto; margin-bottom: 10px; filter: brightness(0) invert(1);"
                     onerror="this.style.display='none'">
                <div style="font-size: 14px; font-weight: bold; margin-top: 5px; opacity: 0.9;">
                    Western Mindanao State University
                </div>
                <div style="font-size: 12px; opacity: 0.8;">
                    Testing and Evaluation Center
                </div>
            </div>
            
            <h1 style="margin: 0; font-size: 24px; font-weight: bold;">
                <i class="fas fa-{notification.icon}" style="margin-right: 10px;"></i>
                {notification.title}
            </h1>
        </div>
        
        <!-- Content -->
        <div style="padding: 30px 20px;">
            <p style="color: #333; font-size: 16px; line-height: 1.5; margin: 0 0 20px 0;">
                Hello {recipient_name},
            </p>
            
            <div style="background-color: #f8f9fa; padding: 20px; border-radius: 6px; border-left: 4px solid #{get_priority_color(notification.priority)}; margin: 20px 0;">
                <p style="color: #444; font-size: 16px; line-height: 1.6; margin: 0;">
                    {notification.message}
                </p>
            </div>
            
            {appointment_details_html}
            
            {get_action_button_html(notification)}
            
            <div style="margin-top: 30px; padding-top: 20px; border-top: 1px solid #eee;">
                <p style="color: #666; font-size: 14px; margin: 0;">
                    <strong>Notification Details:</strong><br>
                    Type: {notification.get_type_display()}<br>
                    Priority: {notification.get_priority_display()}<br>
                    Date: {notification.created_at.strftime('%B %d, %Y at %I:%M %p')}
                </p>
            </div>
        </div>
        
        <!-- Footer -->
        <div style="background-color: #f8f9fa; padding: 20px; text-align: center; border-top: 1px solid #eee;">
            <p style="color: #666; font-size: 12px; margin: 0 0 10px 0;">
                This is an automated notification from the Testing and Evaluation Center.
            </p>
            <p style="color: #666; font-size: 12px; margin: 0;">
                If you have any questions, please contact us at 
                <a href="mailto:{settings.DEFAULT_FROM_EMAIL}" style="color: #8B0000;">{settings.DEFAULT_FROM_EMAIL}</a>
            </p>
        </div>
    </div>
</body>
</html>
        """
        
        # Create plain text version
        appointment_details_text = get_appointment_details_text(notification, appointment)
        
        text_content = f"""
{notification.title}

Hello {recipient_name},

{notification.message}

{appointment_details_text}

Notification Details:
- Type: {notification.get_type_display()}
- Priority: {notification.get_priority_display()}
- Date: {notification.created_at.strftime('%B %d, %Y at %I:%M %p')}

---
This is an automated notification from the Testing and Evaluation Center.
If you have any questions, please contact us at {settings.DEFAULT_FROM_EMAIL}
        """
        
        # Create email message
        email = EmailMultiAlternatives(
            subject=subject,
            body=text_content,
            from_email=settings.DEFAULT_FROM_EMAIL,
            to=[recipient_email]
        )
        
        # Attach HTML version
        email.attach_alternative(html_content, "text/html")
        
        # Send email
        email.send()
        
        print(f"Gmail notification sent successfully to {recipient_email}")
        return True
        
    except Exception as e:
        print(f"Error sending Gmail notification: {str(e)}")
        return False

def get_priority_color(priority):
    """Get color code for notification priority"""
    colors = {
        'low': '28a745',      # Green
        'normal': '007bff',   # Blue  
        'high': 'ffc107',     # Yellow
        'urgent': 'dc3545'    # Red
    }
    return colors.get(priority, '007bff')

def get_action_button_html(notification):
    """Generate action button HTML if notification has a link"""
    if not notification.link:
        return ""
    
    # Determine button text based on notification type
    button_text = "View Details"
    if notification.type == 'appointment':
        button_text = "View Appointment"
    elif notification.type == 'exam':
        button_text = "View Results"
    elif notification.type == 'system':
        button_text = "View Dashboard"
    
    return f"""
    <div style="text-align: center; margin: 25px 0;">
        <a href="{settings.FRONTEND_URL or 'http://localhost:3001'}{notification.link}" 
           style="background-color: #8B0000; color: white; padding: 12px 24px; text-decoration: none; border-radius: 5px; font-weight: bold; display: inline-block;">
            {button_text}
        </a>
    </div>
    """

def send_bulk_gmail_notifications(notification):
    """
    Send Gmail notifications to multiple users for global notifications
    Only sends emails for appointment-related notifications
    """
    # Only send Gmail notifications for appointment-related events
    if notification.type != 'appointment':
        print(f"Skipping bulk Gmail notification for type '{notification.type}' - only appointment notifications are sent via email")
        return True  # Return True to indicate success (notification was processed)
    
    if not notification.is_global:
        # For non-global notifications, send to specific user
        return send_gmail_notification(notification)
    
    try:
        # For global notifications, send to all active users
        active_users = User.objects.filter(is_active=True).exclude(email__isnull=True).exclude(email__exact='')
        
        success_count = 0
        total_count = active_users.count()
        
        for user in active_users:
            if send_gmail_notification(notification, user.email):
                success_count += 1
        
        print(f"Global Gmail notification sent to {success_count}/{total_count} users")
        return success_count > 0
        
    except Exception as e:
        print(f"Error sending bulk Gmail notifications: {str(e)}")
        return False

def send_notification_digest_email(user, notifications):
    """
    Send a digest email with multiple notifications to a user
    Only includes appointment-related notifications in email digests
    """
    try:
        if not user.email:
            return False
        
        # Filter notifications to only include appointment-related ones for email
        appointment_notifications = [n for n in notifications if n.type == 'appointment']
        
        if not appointment_notifications:
            print(f"No appointment notifications to send in digest for user {user.email}")
            return True  # Return True as this is not an error
        
        recipient_name = user.get_full_name() or user.username
        subject = f"[TEC] You have {len(appointment_notifications)} new appointment notifications"
        
        # Create HTML content for digest
        notifications_html = ""
        for notification in appointment_notifications:
            notifications_html += f"""
            <div style="border: 1px solid #ddd; border-radius: 5px; padding: 15px; margin: 10px 0; background-color: #fafafa;">
                <h4 style="margin: 0 0 10px 0; color: #8B0000;">
                    <i class="fas fa-{notification.icon}"></i> {notification.title}
                </h4>
                <p style="margin: 0 0 10px 0; color: #555;">{notification.message}</p>
                <small style="color: #777;">
                    {notification.get_type_display()} • {notification.created_at.strftime('%B %d, %Y at %I:%M %p')}
                </small>
            </div>
            """
        
        html_content = f"""
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Notification Digest</title>
</head>
<body style="font-family: Arial, sans-serif; background-color: #f5f5f5; margin: 0; padding: 20px;">
    <div style="max-width: 600px; margin: 0 auto; background-color: white; border-radius: 8px; overflow: hidden; box-shadow: 0 2px 10px rgba(0,0,0,0.1);">
        
        <!-- Header -->
        <div style="background: linear-gradient(135deg, #8B0000 0%, #A0002A 100%); color: white; padding: 30px 20px; text-align: center;">
            <!-- WMSU Logo -->
            <div style="margin-bottom: 20px;">
                <img src="https://wmsu.edu.ph/wp-content/uploads/2024/05/site_logo.png" 
                     alt="WMSU Logo" 
                     style="height: 60px; width: auto; margin-bottom: 10px; filter: brightness(0) invert(1);"
                     onerror="this.style.display='none'">
                <div style="font-size: 14px; font-weight: bold; margin-top: 5px; opacity: 0.9;">
                    Western Mindanao State University
                </div>
                <div style="font-size: 12px; opacity: 0.8;">
                    Testing and Evaluation Center
                </div>
            </div>
            
            <h1 style="margin: 0; font-size: 24px; font-weight: bold;">
                <i class="fas fa-bell"></i> Notification Digest
            </h1>
            <p style="margin: 10px 0 0 0; opacity: 0.9;">You have {len(appointment_notifications)} new appointment notifications</p>
        </div>
        
        <!-- Content -->
        <div style="padding: 30px 20px;">
            <p style="color: #333; font-size: 16px; line-height: 1.5; margin: 0 0 20px 0;">
                Hello {recipient_name},
            </p>
            
            <p style="color: #555; font-size: 14px; margin: 0 0 20px 0;">
                Here are your recent appointment notifications from the Testing and Evaluation Center:
            </p>
            
            {notifications_html}
            
            <div style="text-align: center; margin: 25px 0;">
                <a href="{settings.FRONTEND_URL or 'http://localhost:3001'}/notifications" 
                   style="background-color: #8B0000; color: white; padding: 12px 24px; text-decoration: none; border-radius: 5px; font-weight: bold; display: inline-block;">
                    View All Notifications
                </a>
            </div>
        </div>
        
        <!-- Footer -->
        <div style="background-color: #f8f9fa; padding: 20px; text-align: center; border-top: 1px solid #eee;">
            <p style="color: #666; font-size: 12px; margin: 0 0 10px 0;">
                This is an automated digest from the Testing and Evaluation Center.
            </p>
            <p style="color: #666; font-size: 12px; margin: 0;">
                If you have any questions, please contact us at 
                <a href="mailto:{settings.DEFAULT_FROM_EMAIL}" style="color: #8B0000;">{settings.DEFAULT_FROM_EMAIL}</a>
            </p>
        </div>
    </div>
</body>
</html>
        """
        
        # Create plain text version
        text_content = f"""
Notification Digest

Hello {recipient_name},

You have {len(appointment_notifications)} new appointment notifications from the Testing and Evaluation Center:

"""
        for i, notification in enumerate(appointment_notifications, 1):
            text_content += f"""
{i}. {notification.title}
   {notification.message}
   Type: {notification.get_type_display()} | Date: {notification.created_at.strftime('%B %d, %Y at %I:%M %p')}

"""
        
        text_content += f"""
---
This is an automated digest from the Testing and Evaluation Center.
If you have any questions, please contact us at {settings.DEFAULT_FROM_EMAIL}
        """
        
        # Create and send email
        email = EmailMultiAlternatives(
            subject=subject,
            body=text_content,
            from_email=settings.DEFAULT_FROM_EMAIL,
            to=[user.email]
        )
        
        email.attach_alternative(html_content, "text/html")
        email.send()
        
        print(f"Notification digest sent successfully to {user.email}")
        return True
        
    except Exception as e:
        print(f"Error sending notification digest: {str(e)}")
        return False

def get_appointment_details_html(notification, appointment=None):
    """
    Generate appointment details HTML for approved appointments
    """
    try:
        # Only show appointment details for appointment-type notifications
        if notification.type != 'appointment':
            return ""
        
        # Try to get appointment from notification context or parameter
        if not appointment and notification.user:
            # Try to find the most recent appointment for this user
            from .models import Appointment
            try:
                appointment = Appointment.objects.filter(
                    user=notification.user,
                    status='approved'
                ).order_by('-created_at').first()
                
                # If no approved appointment, try to find by email
                if not appointment:
                    appointment = Appointment.objects.filter(
                        email=notification.user.email,
                        status='approved'
                    ).order_by('-created_at').first()
            except:
                appointment = None
        
        if not appointment or appointment.status != 'approved':
            return ""
        
        # Format date
        test_date = "Not set"
        if appointment.test_session and appointment.test_session.exam_date:
            test_date = appointment.test_session.exam_date.strftime("%B %d, %Y")
        
        # Format time slot
        time_slot = appointment.assigned_test_time_slot or appointment.time_slot
        formatted_time = ""
        if time_slot == "morning":
            formatted_time = "Morning (8:00 AM - 12:00 PM)"
        elif time_slot == "afternoon":
            formatted_time = "Afternoon (1:00 PM - 5:00 PM)"
        else:
            formatted_time = time_slot or "Not set"
        
        # Get test center info
        test_center_name = "Not assigned"
        test_center_address = ""
        if appointment.test_center:
            test_center_name = appointment.test_center.name
            if hasattr(appointment.test_center, 'address') and appointment.test_center.address:
                test_center_address = appointment.test_center.address
        
        # Get room info
        room_info = "Not assigned"
        if appointment.test_room:
            room_name = appointment.test_room.name
            room_code = getattr(appointment.test_room, 'room_code', '')
            if room_name and room_code and room_name != room_code:
                room_info = f"{room_name} (Code: {room_code})"
            elif room_code:
                room_info = f"Room {room_code}"
            elif room_name:
                room_info = room_name
        
        # Get program name
        program_name = "Program"
        if appointment.program:
            program_name = appointment.program.name
        
        return f"""
        <!-- Appointment Details Section -->
        <div style="background: linear-gradient(135deg, #d4edda 0%, #c3e6cb 100%); padding: 25px; border-radius: 12px; margin: 25px 0; border: 1px solid #c3e6cb; box-shadow: 0 4px 12px rgba(0,0,0,0.1);">
            <!-- Improved Status Badge Layout -->
            <div style="text-align: center; margin-bottom: 25px;">
                <div style="display: inline-flex; align-items: center; background-color: #28a745; color: white; padding: 12px 24px; border-radius: 25px; box-shadow: 0 3px 8px rgba(40, 167, 69, 0.3);">
                    <div style="background-color: rgba(255,255,255,0.2); width: 40px; height: 40px; border-radius: 50%; display: flex; align-items: center; justify-content: center; margin-right: 12px;">
                        <span style="font-size: 20px; font-weight: bold;">✓</span>
                    </div>
                    <span style="font-size: 18px; font-weight: bold; letter-spacing: 0.5px;">APPROVED</span>
                </div>
            </div>
            
            <!-- Congratulations Message -->
            <div style="background: linear-gradient(135deg, rgba(40, 167, 69, 0.1) 0%, rgba(195, 230, 203, 0.3) 100%); padding: 25px; border-radius: 10px; border-left: 5px solid #28a745; margin: 25px 0; text-align: center;">
                <h3 style="color: #155724; font-size: 20px; margin: 0 0 15px 0; font-weight: bold;">
                    🎉 Congratulations! Your application has been approved.
                </h3>
                <p style="color: #155724; font-size: 16px; margin: 0; line-height: 1.5;">
                    You are scheduled for the examination on <strong style="color: #0d4e1a;">{test_date}</strong> during the <strong style="color: #0d4e1a;">{formatted_time}</strong> session.
                </p>
            </div>
            
            <!-- Test Location Card -->
            <div style="background-color: white; padding: 25px; border-radius: 10px; margin: 25px 0; border: 2px solid #c3e6cb; box-shadow: 0 2px 8px rgba(0,0,0,0.05);">
                <h3 style="color: #155724; font-size: 18px; margin: 0 0 20px 0; font-weight: bold; display: flex; align-items: center;">
                    <span style="background: linear-gradient(135deg, #28a745, #20c997); color: white; width: 32px; height: 32px; border-radius: 50%; display: inline-flex; align-items: center; justify-content: center; margin-right: 12px; font-size: 16px;">📍</span>
                    Test Location Details
                </h3>
                
                <table style="width: 100%; border-collapse: collapse; margin-top: 10px;">
                    <tr>
                        <td style="padding: 12px 0; font-weight: bold; color: #155724; width: 35%; border-bottom: 1px solid #e8f5e8;">
                            <span style="display: inline-flex; align-items: center;">
                                <span style="width: 6px; height: 6px; background-color: #28a745; border-radius: 50%; margin-right: 10px;"></span>
                                Test Center:
                            </span>
                        </td>
                        <td style="padding: 12px 0; color: #155724; border-bottom: 1px solid #e8f5e8; font-weight: 500;">{test_center_name}</td>
                    </tr>
                    <tr>
                        <td style="padding: 12px 0; font-weight: bold; color: #155724; border-bottom: 1px solid #e8f5e8;">
                            <span style="display: inline-flex; align-items: center;">
                                <span style="width: 6px; height: 6px; background-color: #28a745; border-radius: 50%; margin-right: 10px;"></span>
                                Test Room:
                            </span>
                        </td>
                        <td style="padding: 12px 0; color: #155724; border-bottom: 1px solid #e8f5e8; font-weight: 500;">{room_info}</td>
                    </tr>
                    {f'<tr><td style="padding: 12px 0; font-weight: bold; color: #155724;"><span style="display: inline-flex; align-items: center;"><span style="width: 6px; height: 6px; background-color: #28a745; border-radius: 50%; margin-right: 10px;"></span>Address:</span></td><td style="padding: 12px 0; color: #155724; font-weight: 500;">{test_center_address}</td></tr>' if test_center_address else ''}
                </table>
            </div>
            
            <!-- Important Instructions Card -->
            <div style="background: linear-gradient(135deg, #fff3cd 0%, #ffeaa7 30%); padding: 20px; border-radius: 10px; border-left: 5px solid #ffc107; margin: 25px 0; box-shadow: 0 2px 8px rgba(255, 193, 7, 0.2);">
                <h4 style="color: #856404; margin: 0 0 15px 0; font-size: 18px; display: flex; align-items: center;">
                    <span style="background: linear-gradient(135deg, #ffc107, #ffab00); color: white; width: 32px; height: 32px; border-radius: 50%; display: inline-flex; align-items: center; justify-content: center; margin-right: 12px; font-size: 16px;">⚠️</span>
                    Important Exam Day Requirements
                </h4>
                <p style="color: #856404; font-size: 15px; margin: 0 0 15px 0; line-height: 1.5;">
                    Please arrive <strong>30 minutes before</strong> your scheduled time and bring the following items:
                </p>
                <div style="background-color: rgba(255,255,255,0.7); padding: 15px; border-radius: 8px; margin-top: 10px;">
                    <ul style="color: #856404; font-size: 14px; margin: 0; padding-left: 20px; line-height: 1.8;">
                        <li style="margin-bottom: 8px;"><strong>Printed application form</strong> (mandatory)</li>
                        <li style="margin-bottom: 8px;"><strong>Valid government-issued ID</strong></li>
                        <li style="margin-bottom: 8px;"><strong>Examination permit</strong> (if issued)</li>
                        <li style="margin-bottom: 8px;"><strong>#2 pencils</strong> and <strong>eraser</strong></li>
                    </ul>
                </div>
            </div>
            
            <!-- Download Application Form Section -->
            <div style="background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%); padding: 25px; border-radius: 12px; border: 2px solid #dee2e6; margin: 25px 0; text-align: center; box-shadow: 0 3px 10px rgba(0,0,0,0.1);">
                <div style="margin-bottom: 20px;">
                    <div style="background: linear-gradient(135deg, #dc3545, #c82333); color: white; width: 50px; height: 50px; border-radius: 50%; display: inline-flex; align-items: center; justify-content: center; margin-bottom: 15px; box-shadow: 0 4px 12px rgba(220, 53, 69, 0.3);">
                        <span style="font-size: 24px;">📋</span>
                    </div>
                    <h4 style="color: #495057; margin: 0 0 10px 0; font-size: 18px; font-weight: bold;">Download Your Application Form</h4>
                    <p style="color: #6c757d; font-size: 14px; margin: 0; line-height: 1.6; max-width: 400px; margin: 0 auto;">
                        Click the button below to download your completed application form. <strong>You must print and bring this form on your test day.</strong>
                    </p>
                </div>
                
                <a href="{settings.FRONTEND_URL or 'http://localhost:3001'}/profile?download_form={appointment.id}" 
                   style="background: linear-gradient(135deg, #dc3545 0%, #c82333 100%); color: white; padding: 15px 30px; text-decoration: none; border-radius: 8px; font-weight: bold; display: inline-flex; align-items: center; box-shadow: 0 4px 15px rgba(220, 53, 69, 0.4); transition: all 0.3s ease; font-size: 16px;">
                    <span style="margin-right: 10px; font-size: 18px;">�</span>
                    Download Application Form (PDF)
                </a>
                
                <p style="color: #6c757d; font-size: 12px; margin: 20px 0 0 0; font-style: italic;">
                    Having trouble downloading? Visit your profile page and use the "Download Application Form" button.
                </p>
            </div>
        </div>
        """
        
    except Exception as e:
        print(f"Error generating appointment details HTML: {str(e)}")
        return ""

def get_appointment_details_text(notification, appointment=None):
    """
    Generate appointment details text for approved appointments (plain text version)
    """
    try:
        # Only show appointment details for appointment-type notifications
        if notification.type != 'appointment':
            return ""
        
        # Try to get appointment from notification context or parameter
        if not appointment and notification.user:
            # Try to find the most recent appointment for this user
            from .models import Appointment
            try:
                appointment = Appointment.objects.filter(
                    user=notification.user,
                    status='approved'
                ).order_by('-created_at').first()
                
                # If no approved appointment, try to find by email
                if not appointment:
                    appointment = Appointment.objects.filter(
                        email=notification.user.email,
                        status='approved'
                    ).order_by('-created_at').first()
            except:
                appointment = None
        
        if not appointment or appointment.status != 'approved':
            return ""
        
        # Format date
        test_date = "Not set"
        if appointment.test_session and appointment.test_session.exam_date:
            test_date = appointment.test_session.exam_date.strftime("%B %d, %Y")
        
        # Format time slot
        time_slot = appointment.assigned_test_time_slot or appointment.time_slot
        formatted_time = ""
        if time_slot == "morning":
            formatted_time = "Morning (8:00 AM - 12:00 PM)"
        elif time_slot == "afternoon":
            formatted_time = "Afternoon (1:00 PM - 5:00 PM)"
        else:
            formatted_time = time_slot or "Not set"
        
        # Get test center info
        test_center_name = "Not assigned"
        test_center_address = ""
        if appointment.test_center:
            test_center_name = appointment.test_center.name
            if hasattr(appointment.test_center, 'address') and appointment.test_center.address:
                test_center_address = appointment.test_center.address
        
        # Get room info
        room_info = "Not assigned"
        if appointment.test_room:
            room_name = appointment.test_room.name
            room_code = getattr(appointment.test_room, 'room_code', '')
            if room_name and room_code and room_name != room_code:
                room_info = f"{room_name} (Code: {room_code})"
            elif room_code:
                room_info = f"Room {room_code}"
            elif room_name:
                room_info = room_name
        
        return f"""
APPOINTMENT DETAILS:
===================

Status: APPROVED ✓

Congratulations! Your application has been approved.
You are scheduled for the examination on {test_date} during the {formatted_time} session.

Test Location Details:
- Test Center: {test_center_name}
- Test Room: {room_info}
{f"- Address: {test_center_address}" if test_center_address else ""}

Important:
Please arrive 30 minutes before your scheduled time and bring the following:
• Printed application form
• Valid ID  
• Examination permit

Download Your Application Form:
==============================
You can download your completed application form by visiting:
{settings.FRONTEND_URL or 'http://localhost:3001'}/profile

Look for the "Download Application Form" button in your profile page.
You must print and bring this form on your test day.
"""
        
    except Exception as e:
        print(f"Error generating appointment details text: {str(e)}")
        return ""