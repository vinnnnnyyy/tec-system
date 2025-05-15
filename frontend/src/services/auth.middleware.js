import AuthService from './auth.service';
import router from '../router';

export const authMiddleware = {
  async checkAuth() {
    const token = localStorage.getItem('access_token');
    if (!token) {
      return false;
    }

    try {
      // You can add a token validation request here
      // For example, make an API call to verify the token
      const response = await AuthService.validateToken();
      return true;
    } catch (error) {
      AuthService.logout();
      router.push('/login');
      return false;
    }
  }
}; 