import random
import string
from datetime import datetime, timedelta
from django.utils import timezone
from django.conf import settings
from django.core.mail import send_mail
from django.template.loader import render_to_string
from .models import OTPVerification

def generate_otp(length=6):
    """Generate a random OTP of specified length"""
    return ''.join(random.choices(string.digits, k=length))

def save_otp(email):
    """
    Generate and save OTP for a user
    Returns the generated OTP
    """
    # Generate a random 6-digit OTP
    otp = generate_otp()
    
    # Set expiry time (10 minutes from now) using timezone-aware datetime
    expiry_time = timezone.now() + timedelta(minutes=10)
    
    # Delete any existing OTP for this email
    OTPVerification.objects.filter(email=email).delete()
    
    # Create new OTP record
    OTPVerification.objects.create(
        email=email,
        otp_code=otp,
        expires_at=expiry_time
    )
    
    return otp

def send_otp_email(email, otp):
    """Send OTP via Django's email system (Gmail SMTP)"""
    try:
        subject = "Your OTP Verification Code"
        
        # Plain text message
        message = f"""
Hello,

Your OTP verification code is: {otp}

This code will expire in 10 minutes.

If you did not request this code, please ignore this email.

Thank you,
TEC Registration System
        """
        
        # HTML message
        html_message = f"""
<div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
    <h2 style="color: #333;">Your Verification Code</h2>
    <p>Hello,</p>
    <p>Your OTP verification code is:</p>
    <div style="background-color: #f5f5f5; padding: 15px; border-radius: 5px; text-align: center; font-size: 24px; letter-spacing: 5px; font-weight: bold; color: #333;">
        {otp}
    </div>
    <p>This code will expire in 10 minutes.</p>
    <p>If you did not request this code, please ignore this email.</p>
    <p>Thank you,<br/>TEC Registration System</p>
</div>
        """
        
        print(f"Sending email to {email} with OTP {otp}")
        print(f"Using sender: {settings.DEFAULT_FROM_EMAIL}")
        
        # Send email using Django's send_mail
        result = send_mail(
            subject=subject,
            message=message,
            from_email=settings.DEFAULT_FROM_EMAIL,
            recipient_list=[email],
            html_message=html_message,
            fail_silently=False
        )
        
        if result:
            print("Email sent successfully!")
            return True
        else:
            print("Failed to send email")
            return False
    
    except Exception as e:
        print(f"Exception sending email: {str(e)}")
        return False

def verify_otp(email, otp):
    """
    Verify if the provided OTP is valid
    Returns True if valid, False otherwise
    """
    try:
        # Get the OTP record for this email
        otp_record = OTPVerification.objects.get(email=email)
        
        # Check if OTP has expired - use timezone-aware datetime for comparison
        if timezone.now() > otp_record.expires_at:
            # Delete expired OTP
            otp_record.delete()
            return False
        
        # Check if OTP matches
        if otp_record.otp_code == otp:
            # Mark as verified
            otp_record.is_verified = True
            otp_record.save()
            return True
        
        return False
    except OTPVerification.DoesNotExist:
        return False 