import requests
import json
from django.conf import settings
from django.urls import reverse

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
    <div style="text-align: center; margin-bottom: 20px;">
        <h1 style="color: #8B0000; margin: 0;">Your Test Details Are Ready</h1>
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