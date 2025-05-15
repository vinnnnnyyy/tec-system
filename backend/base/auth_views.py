from django.contrib.auth.models import User
from rest_framework import status
from rest_framework.response import Response
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import AllowAny, IsAuthenticated
from django.db import IntegrityError
from django.contrib.auth import authenticate
from rest_framework_simplejwt.tokens import RefreshToken
from .models import Appointment

@api_view(['POST'])
@permission_classes([AllowAny])
def register_user(request):
    """
    Register a new user
    """
    return Response(
        {
            'detail': 'Direct registration is disabled. Please use OTP verification by calling /request-otp/ first, then complete registration with /signup-with-otp/'
        },
        status=status.HTTP_400_BAD_REQUEST
    )

@api_view(['POST'])
@permission_classes([AllowAny])
def admin_login(request):
    """
    Admin login endpoint
    """
    try:
        username = request.data.get('username')
        password = request.data.get('password')

        # Validate input data
        if not username or not password:
            return Response(
                {'detail': 'Please provide username and password'},
                status=status.HTTP_400_BAD_REQUEST
            )

        # Authenticate the user
        user = authenticate(username=username, password=password)
        
        if user is None:
            return Response(
                {'detail': 'Invalid credentials'},
                status=status.HTTP_401_UNAUTHORIZED
            )
            
        # Check if user is staff/admin
        if not user.is_staff:
            return Response(
                {'detail': 'You do not have admin privileges'},
                status=status.HTTP_403_FORBIDDEN
            )
            
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
                    'last_name': user.last_name,
                    'is_staff': user.is_staff,
                    'is_admin': user.is_superuser
                }
            },
            status=status.HTTP_200_OK
        )
    except Exception as e:
        return Response(
            {'detail': f'An error occurred: {str(e)}'},
            status=status.HTTP_500_INTERNAL_SERVER_ERROR
        )

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def validate_admin(request):
    """
    Validate if the current user is an admin
    """
    user = request.user
    
    if not user.is_staff and not user.is_superuser:
        return Response(
            {
                'is_admin': False,
                'detail': 'You do not have admin privileges'
            },
            status=status.HTTP_403_FORBIDDEN
        )
        
    return Response(
        {
            'is_admin': True,
            'user': {
                'id': user.id,
                'username': user.username,
                'email': user.email,
                'is_staff': user.is_staff,
                'is_superuser': user.is_superuser
            }
        },
        status=status.HTTP_200_OK
    )

@api_view(['GET', 'POST'])
@permission_classes([IsAuthenticated])
def admin_users(request):
    """
    Get all users or create a new user (admin only)
    """
    user = request.user
    
    # Check if user is admin
    if not user.is_staff and not user.is_superuser:
        return Response(
            {'detail': 'You do not have admin privileges'},
            status=status.HTTP_403_FORBIDDEN
        )
    
    if request.method == 'GET':
        try:
            users = User.objects.all()
            user_data = []
            
            for user in users:
                user_data.append({
                    'id': user.id,
                    'name': f"{user.first_name} {user.last_name}".strip(),
                    'email': user.email,
                    'username': user.username,
                    'role': 'Admin' if user.is_staff else 'User',
                    'status': 'Active' if user.is_active else 'Inactive',
                    'lastLogin': user.last_login.strftime('%Y-%m-%d %H:%M') if user.last_login else 'Never'
                })
            
            return Response(user_data, status=status.HTTP_200_OK)
        except Exception as e:
            return Response(
                {'detail': f'An error occurred: {str(e)}'},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )
    
    elif request.method == 'POST':
        try:
            # Get user data from request
            username = request.data.get('username')
            email = request.data.get('email')
            password = request.data.get('password')
            first_name = request.data.get('first_name', '')
            last_name = request.data.get('last_name', '')
            is_staff = request.data.get('is_staff', False)
            is_active = request.data.get('is_active', True)

            # Validate required fields
            if not username or not email or not password:
                return Response(
                    {'detail': 'Please provide username, email, and password'},
                    status=status.HTTP_400_BAD_REQUEST
                )

            # Create the user
            user = User.objects.create_user(
                username=username,
                email=email,
                password=password,
                first_name=first_name,
                last_name=last_name
            )
            
            # Set staff and active status
            user.is_staff = is_staff
            user.is_active = is_active
            user.save()

            return Response({
                'id': user.id,
                'username': user.username,
                'email': user.email,
                'first_name': user.first_name,
                'last_name': user.last_name,
                'is_staff': user.is_staff,
                'is_active': user.is_active
            }, status=status.HTTP_201_CREATED)

        except IntegrityError:
            return Response(
                {'detail': 'Username or email already exists'},
                status=status.HTTP_400_BAD_REQUEST
            )
        except Exception as e:
            return Response(
                {'detail': f'An error occurred: {str(e)}'},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )

@api_view(['DELETE'])
@permission_classes([IsAuthenticated])
def delete_user(request, user_id):
    """
    Delete a user (admin only)
    """
    admin = request.user
    
    # Check if user is admin
    if not admin.is_staff and not admin.is_superuser:
        return Response(
            {'detail': 'You do not have admin privileges'},
            status=status.HTTP_403_FORBIDDEN
        )
    
    try:
        # Get the user to delete
        user_to_delete = User.objects.get(id=user_id)
        
        # Prevent admin from deleting themselves
        if user_to_delete.id == admin.id:
            return Response(
                {'detail': 'You cannot delete your own account'},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        # Delete the user
        user_to_delete.delete()
        
        return Response(status=status.HTTP_204_NO_CONTENT)
    except User.DoesNotExist:
        return Response(
            {'detail': 'User not found'},
            status=status.HTTP_404_NOT_FOUND
        )
    except Exception as e:
        return Response(
            {'detail': f'An error occurred: {str(e)}'},
            status=status.HTTP_500_INTERNAL_SERVER_ERROR
        )

@api_view(['PUT'])
@permission_classes([IsAuthenticated])
def update_user(request, user_id):
    """
    Update a user (admin only)
    """
    admin = request.user
    
    # Check if user is admin
    if not admin.is_staff and not admin.is_superuser:
        return Response(
            {'detail': 'You do not have admin privileges'},
            status=status.HTTP_403_FORBIDDEN
        )
    
    try:
        # Get the user to update
        user_to_update = User.objects.get(id=user_id)
        
        # Update user fields
        user_to_update.username = request.data.get('username', user_to_update.username)
        user_to_update.email = request.data.get('email', user_to_update.email)
        user_to_update.first_name = request.data.get('first_name', user_to_update.first_name)
        user_to_update.last_name = request.data.get('last_name', user_to_update.last_name)
        user_to_update.is_staff = request.data.get('is_staff', user_to_update.is_staff)
        user_to_update.is_active = request.data.get('is_active', user_to_update.is_active)
        
        # If password is provided, update it
        password = request.data.get('password')
        if password:
            user_to_update.set_password(password)
        
        user_to_update.save()
        
        return Response({
            'id': user_to_update.id,
            'username': user_to_update.username,
            'email': user_to_update.email,
            'first_name': user_to_update.first_name,
            'last_name': user_to_update.last_name,
            'is_staff': user_to_update.is_staff,
            'is_active': user_to_update.is_active
        }, status=status.HTTP_200_OK)
        
    except User.DoesNotExist:
        return Response(
            {'detail': 'User not found'},
            status=status.HTTP_404_NOT_FOUND
        )
    except Exception as e:
        return Response(
            {'detail': f'An error occurred: {str(e)}'},
            status=status.HTTP_500_INTERNAL_SERVER_ERROR
        )

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_user_profile(request):
    """
    Get the profile of the currently authenticated user
    """
    user = request.user
    
    try:
        # Try to find the latest appointment for this user to get additional info
        latest_appointment = Appointment.objects.filter(
            email=user.email
        ).order_by('-created_at').first()
        
        profile_data = {
            'id': user.id,
            'username': user.username,
            'email': user.email,
            'full_name': f"{user.first_name} {user.last_name}".strip() or user.username,
        }
        
        # Add appointment-related info if available
        if latest_appointment:
            profile_data.update({
                'contact_number': latest_appointment.contact_number,
                'school_name': latest_appointment.school_name,
                'college_level': latest_appointment.college_level
            })
        
        return Response(profile_data, status=status.HTTP_200_OK)
        
    except Exception as e:
        return Response(
            {'detail': f'An error occurred: {str(e)}'},
            status=status.HTTP_500_INTERNAL_SERVER_ERROR
        )