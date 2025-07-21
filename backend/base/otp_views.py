from rest_framework import status
from rest_framework.response import Response
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import AllowAny
from django.contrib.auth.models import User
from rest_framework_simplejwt.tokens import RefreshToken
from .otp_utils import save_otp, send_otp_email, verify_otp
from .models import OTPVerification

@api_view(['POST'])
@permission_classes([AllowAny])
def request_otp(request):
    """
    Request an OTP for the given email
    """
    try:
        email = request.data.get('email')
        
        if not email:
            return Response(
                {'detail': 'Email is required'},
                status=status.HTTP_400_BAD_REQUEST
            )
            
        # Generate and save OTP
        otp = save_otp(email)
        
        # Send OTP via email
        send_otp_email(email, otp)
        
        return Response(
            {'detail': 'OTP has been sent to your email'},
            status=status.HTTP_200_OK
        )
    except Exception as e:
        return Response(
            {'detail': f'An error occurred: {str(e)}'},
            status=status.HTTP_500_INTERNAL_SERVER_ERROR
        )

@api_view(['POST'])
@permission_classes([AllowAny])
def signup_with_otp(request):
    """
    Register a new user after OTP verification
    """
    try:
        username = request.data.get('username')
        email = request.data.get('email')
        password = request.data.get('password')
        otp = request.data.get('otp')
        first_name = request.data.get('first_name', '')
        last_name = request.data.get('last_name', '')
        middle_name = request.data.get('middle_name', '')
        
        # Combine first and middle name if middle name is provided
        if middle_name:
            full_first_name = f"{first_name} {middle_name}".strip()
        else:
            full_first_name = first_name
        
        print(f"Signup attempt with OTP: {otp} for email: {email}")
        
        # Validate input data
        if not username or not email or not password or not otp:
            print("Missing required fields for signup")
            return Response(
                {'detail': 'Please provide username, email, password, and OTP'},
                status=status.HTTP_400_BAD_REQUEST
            )
            
        # Verify OTP
        if not verify_otp(email, otp):
            print(f"OTP verification failed for signup: {email}")
            return Response(
                {'detail': 'Invalid or expired OTP'},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        print(f"OTP verified successfully for signup: {email}")
            
        # Check if user already exists
        if User.objects.filter(username=username).exists():
            print(f"Username already exists: {username}")
            return Response(
                {'detail': 'Username already exists'},
                status=status.HTTP_400_BAD_REQUEST
            )
            
        if User.objects.filter(email=email).exists():
            print(f"Email already registered: {email}")
            return Response(
                {'detail': 'Email already registered'},
                status=status.HTTP_400_BAD_REQUEST
            )
            
        # Create the user
        user = User.objects.create_user(
            username=username,
            email=email,
            password=password,
            first_name=full_first_name,
            last_name=last_name
        )
        
        # Set regular user permissions
        user.is_staff = False
        user.is_superuser = False
        user.save()
        
        print(f"User created successfully: {username}")
        
        # Delete the OTP record
        OTPVerification.objects.filter(email=email).delete()
        
        # Generate tokens
        refresh = RefreshToken.for_user(user)
        
        return Response(
            {
                'refresh': str(refresh),
                'access': str(refresh.access_token),
                'user': {
                    'id': user.id,
                    'username': user.username,
                    'email': user.email,
                    'first_name': user.first_name,
                    'last_name': user.last_name
                },
                'detail': 'User registered successfully'
            },
            status=status.HTTP_201_CREATED
        )
    except Exception as e:
        print(f"Exception in signup_with_otp: {str(e)}")
        return Response(
            {'detail': f'An error occurred: {str(e)}'},
            status=status.HTTP_500_INTERNAL_SERVER_ERROR
        )
        
@api_view(['POST'])
@permission_classes([AllowAny])
def verify_otp_endpoint(request):
    """
    Verify an OTP for the given email
    """
    try:
        email = request.data.get('email')
        otp = request.data.get('otp')
        
        print(f"Verifying OTP: {otp} for email: {email}")
        
        if not email or not otp:
            print("Missing email or OTP")
            return Response(
                {'detail': 'Email and OTP are required'},
                status=status.HTTP_400_BAD_REQUEST
            )
            
        # Try to get the OTP record directly for debugging
        try:
            otp_record = OTPVerification.objects.get(email=email)
            print(f"Found OTP record: code={otp_record.otp_code}, expires={otp_record.expires_at}, verified={otp_record.is_verified}")
        except OTPVerification.DoesNotExist:
            print(f"No OTP record found for email: {email}")
        
        # Verify OTP
        verification_result = verify_otp(email, otp)
        print(f"OTP verification result: {verification_result}")
        
        if verification_result:
            return Response(
                {'detail': 'OTP verified successfully'},
                status=status.HTTP_200_OK
            )
        else:
            return Response(
                {'detail': 'Invalid or expired OTP'},
                status=status.HTTP_400_BAD_REQUEST
            )
    except Exception as e:
        print(f"Exception in verify_otp_endpoint: {str(e)}")
        return Response(
            {'detail': f'An error occurred: {str(e)}'},
            status=status.HTTP_500_INTERNAL_SERVER_ERROR
        ) 