import AuthService from './auth.service';
import { useRouter } from 'vue-router';

export const adminAuthMiddleware = {
  async checkAdminAuth() {
    try {
      // Use the validateToken method with admin check
      return await AuthService.validateToken(true);
    } catch (error) {
      AuthService.logout();
      return false;
    }
  },

  // Utility to encode/decode admin paths for security
  encodeAdminPath(path) {
    // Store original path in session storage instead of exposing in URL
    const redirectKey = 'secure_redirect_' + Math.random().toString(36).substring(2, 10);
    sessionStorage.setItem(redirectKey, path);
    return redirectKey;
  },
  
  decodeAdminPath(key) {
    const path = sessionStorage.getItem(key);
    sessionStorage.removeItem(key); // One-time use
    return path || '/admin/dashboard'; // Default if not found
  },

  // Add navigation guard for admin routes
  setupGuard(router) {
    // Make sure this runs before the general auth middleware
    router.beforeEach(async (to, from, next) => {
      // Check if this is a secure redirect being handled
      if (to.query.secure_redirect) {
        const redirectPath = this.decodeAdminPath(to.query.secure_redirect);
        if (redirectPath && redirectPath.startsWith('/admin')) {
          return next(redirectPath);
        }
      }
      
      // Check if the route requires admin authentication
      if (to.matched.some(record => record.meta.requiresAdmin)) {
        // Check if user is authenticated as admin
        const isAuthenticated = await this.checkAdminAuth();
        
        if (!isAuthenticated) {
          // If not authenticated as admin, redirect to login
          // Don't expose admin routes in the URL
          const currentUser = AuthService.getCurrentUser();
          
          if (currentUser) {
            // If user is logged in but not as admin, log them out first
            // This prevents regular users from accessing admin routes
            AuthService.logout();
          }
          
          // Create a secure redirect key instead of exposing the admin path
          const secureRedirectKey = this.encodeAdminPath(to.fullPath);
          
          next({ 
            path: '/login',
            query: { 
              secure_redirect: secureRedirectKey
            }
          });
        } else {
          // Continue to the admin route if authenticated as admin
          next();
        }
      } else {
        // For non-admin routes, just proceed
        next();
      }
    });
  }
}; 