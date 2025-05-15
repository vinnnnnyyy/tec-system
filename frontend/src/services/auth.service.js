import axios from 'axios';

// Import the API URL from the environment
const API_URL = import.meta.env.VITE_API_URL
const API_ENDPOINT = `${API_URL}api/`;

class AuthService {
  async login(email, password) {
    try {
      let isAdmin = false;
      let userData = null;
      
      // First try to authenticate as an admin
      try {
        const adminResponse = await axios.post(API_ENDPOINT + 'admin/login/', {
          username: email,
          password: password
        });
        
        if (adminResponse.data.access) {
          isAdmin = true;
          userData = adminResponse.data;
        }
      } catch (adminError) {
        // If admin login fails, try regular user login
        console.log('Not an admin user, trying regular login');
        isAdmin = false;
      }
      
      // If not authenticated as admin, try regular user login
      if (!isAdmin) {
        const response = await axios.post(API_ENDPOINT + 'token/', {
          username: email,
          password: password
        });
        
        if (response.data.access) {
          userData = response.data;
        }
      }
      
      // Set user session if we have data
      if (userData) {
        this.setUserSession(userData, email, isAdmin);
      }
      
      return userData;
    } catch (error) {
      throw error;
    }
  }
  
  // Helper method to set user session data
  setUserSession(data, email, isAdmin = false) {
    localStorage.setItem('access_token', data.access);
    localStorage.setItem('refresh_token', data.refresh);
    
    if (isAdmin) {
      localStorage.setItem('is_admin', 'true');
    }
    
    // Store user info
    const userInfo = {
      email: email,
      isAdmin: isAdmin,
      ...(data.user || {})
    };
    localStorage.setItem('user_info', JSON.stringify(userInfo));
  }

  // Request OTP for email verification
  async requestOTP(email) {
    try {
      const response = await axios.post(API_ENDPOINT + 'request-otp/', {
        email: email
      });
      return response.data;
    } catch (error) {
      throw {
        message: error.response?.data?.detail || 'Failed to send OTP. Please try again.',
        status: error.response?.status,
        originalError: error
      };
    }
  }

  // Verify OTP code
  async verifyOTP(email, otp) {
    try {
      const response = await axios.post(API_ENDPOINT + 'verify-otp/', {
        email: email,
        otp: otp
      });
      return response.data;
    } catch (error) {
      throw {
        message: error.response?.data?.detail || 'Invalid or expired OTP code.',
        status: error.response?.status,
        originalError: error
      };
    }
  }

  // Complete registration with OTP
  async registerWithOTP(firstName, lastName, email, password, otp) {
    try {
      const response = await axios.post(API_ENDPOINT + 'signup-with-otp/', {
        username: email,  // Using email as username
        email: email,
        password: password,
        otp: otp,
        first_name: firstName,
        last_name: lastName
      });

      // If registration is successful, set the user session
      if (response.data && response.data.access) {
        // Set user session without admin privileges
        localStorage.setItem('access_token', response.data.access);
        localStorage.setItem('refresh_token', response.data.refresh);
        
        // Explicitly set as NOT admin
        localStorage.setItem('is_admin', 'false');
        
        // Store user info
        const userInfo = {
          email: email,
          isAdmin: false,
          is_staff: false,
          is_superuser: false,
          ...(response.data.user || {})
        };
        localStorage.setItem('user_info', JSON.stringify(userInfo));
      }
      
      return response.data;
    } catch (error) {
      throw {
        message: error.response?.data?.detail || 'Registration failed. Please try again.',
        status: error.response?.status,
        originalError: error
      };
    }
  }

  async register(firstName, lastName, email, password) {
    try {
      const response = await axios.post(API_ENDPOINT + 'register/', {
        username: email,  // Using email as username
        email: email,
        password: password,
        password2: password,  // Add password confirmation
        first_name: firstName,
        last_name: lastName
      });

      // If registration is successful, try to login automatically
      // But EXPLICITLY as a regular user, not admin
      if (response.data) {
        try {
          // Use a direct token call instead of the login method to avoid admin login attempt
          const loginResponse = await axios.post(API_ENDPOINT + 'token/', {
            username: email,
            password: password
          });
          
          if (loginResponse.data.access) {
            // Set user session without admin privileges
            localStorage.setItem('access_token', loginResponse.data.access);
            localStorage.setItem('refresh_token', loginResponse.data.refresh);
            
            // Explicitly set as NOT admin
            localStorage.setItem('is_admin', 'false');
            
            // Store user info
            const userInfo = {
              email: email,
              isAdmin: false,
              is_staff: false,
              is_superuser: false
            };
            localStorage.setItem('user_info', JSON.stringify(userInfo));
          }
          
          return response.data;
        } catch (loginError) {
          // If auto-login fails, still return registration data but with a flag
          return {
            ...response.data,
            autoLoginFailed: true
          };
        }
      }
      return response.data;
    } catch (error) {
      // Throw a more detailed error message
      throw {
        message: error.response?.data?.detail || 'Registration failed. Please try again.',
        status: error.response?.status,
        originalError: error
      };
    }
  }

  logout() {
    localStorage.removeItem('access_token');
    localStorage.removeItem('refresh_token');
    localStorage.removeItem('user_info');
    localStorage.removeItem('is_admin');
  }

  getCurrentUser() {
    const token = localStorage.getItem('access_token');
    if (token) {
      try {
        // Try to parse the stored user info
        return JSON.parse(localStorage.getItem('user_info') || '{}');
      } catch (e) {
        return token;
      }
    }
    return null;
  }

  isAdmin() {
    const userInfo = this.getCurrentUser();
    return localStorage.getItem('is_admin') === 'true' || 
           (userInfo && userInfo.isAdmin) || 
           (userInfo && userInfo.is_staff);
  }

  async validateToken(checkAdmin = false) {
    try {
      const token = localStorage.getItem('access_token');
      if (!token) {
        return false;
      }
      
      if (checkAdmin) {
        // First check local storage for cached admin status
        if (localStorage.getItem('is_admin') === 'true') {
          // For extra security, we could still validate with the backend
          // but we'll trust the token for better performance
          return true;
        }
        
        try {
          // Validate admin status with backend
          const response = await axios.get(API_ENDPOINT + 'admin/validate/', {
            headers: {
              'Authorization': `Bearer ${token}`
            }
          });
          
          // Update local storage if backend confirms admin status
          if (response.data.is_admin) {
            localStorage.setItem('is_admin', 'true');
          }
          
          return response.data.is_admin;
        } catch (error) {
          // If server validation fails, fall back to local checks
          const userInfo = this.getCurrentUser();
          return !!(userInfo && (userInfo.isAdmin || userInfo.is_staff || userInfo.is_superuser));
        }
      }
      
      // For regular validation, just check if token exists
      return true;
    } catch (error) {
      // If validation fails, clear tokens
      if (error.response && (error.response.status === 401 || error.response.status === 403)) {
        this.logout();
      }
      return false;
    }
  }
}

export default new AuthService(); 