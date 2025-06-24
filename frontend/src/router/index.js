import { createRouter, createWebHistory } from 'vue-router'
import Home from '../views/Home.vue'
import { adminRoutes } from './admin.routes'
import AuthService from '../services/auth.service'
import { adminAuthMiddleware } from '../services/admin-auth.middleware'
import ExamResults from '../views/ExamResults.vue'
const routes = [
  {
    path: '/',
    name: 'Home',
    component: Home
  },
  {
    path: '/schedule',
    name: 'Schedule',
    component: () => import('../views/Schedule.vue'),
    meta: { requiresAuth: true }
  },
  {
    path: '/profile',
    name: 'Profile',
    component: () => import('../views/Profile.vue'),
    meta: { requiresAuth: true }
  },
  {
    path: '/faq',
    name: 'FAQ',
    component: () => import('../views/FAQ.vue')
  },
  {
    path: '/about',
    name: 'About',
    component: () => import('../views/About.vue')
  },
  {
    path: '/requirements',
    name: 'Requirements',
    component: () => import('../views/Requirements.vue')
  },
  {
    path: '/announcements',
    name: 'Announcements',
    component: () => import('../views/Announcements.vue')
  },
  {
    path: '/login',
    name: 'Login',
    component: () => import('../views/Login.vue'),
    meta: { requiresAuth: false }
  },
  {
    path: '/signup',
    name: 'Signup',
    component: () => import('../views/Signup.vue')
  },
  {
    path: '/appointments/:id/status',
    name: 'AppointmentStatus',
    component: () => import('../components/schedule/AppointmentStatus.vue'),
    props: route => ({ id: route.params.id }),
    meta: { requiresAuth: true }
  },
  {
    path: '/application-form',
    name: 'ApplicationForm',
    component: () => import('../components/ApplicationForm.vue'),
    meta: { requiresAuth: true }
  },
  {
    path: '/application-form/:appointmentId',
    name: 'ApplicationFormWithId',
    component: () => import('../components/ApplicationForm.vue'),
    props: route => ({ appointmentId: route.params.appointmentId }),
    meta: { requiresAuth: true }
  },  {
    path: '/results',
    name: 'ExamResults',
    component: ExamResults
  },
  {
    path: '/scores',
    name: 'ExamScores',
    component: () => import('../views/ExamScores.vue')
  },
 
  
  // Spread the adminRoutes array
  ...adminRoutes
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

// First handle admin auth guard - this needs to run before the general auth check
adminAuthMiddleware.setupGuard(router);

// Then handle general authentication
router.beforeEach((to, from, next) => {
  // If already handled by admin middleware, don't process again
  if (to.matched.some(record => record.meta.requiresAdmin)) {
    return next(); // Already handled by the admin middleware
  }

  // Check if this is a non-admin route but starts with /admin
  // This is an edge case where someone might try to access an admin route that's not properly marked
  if (to.path.startsWith('/admin') && !to.matched.some(record => record.meta.requiresAdmin)) {
    // Redirect to home page instead of exposing error
    return next('/');
  }

  // Handle regular authentication
  const requiresAuth = to.matched.some(record => record.meta.requiresAuth)
  const currentUser = AuthService.getCurrentUser()

  if (requiresAuth && !currentUser) {
    // Only use regular redirect for non-admin routes
    if (!to.path.startsWith('/admin')) {
      next({
        path: '/login',
        query: { redirect: to.fullPath }
      });
    } else {
      // For admin routes that somehow got here, redirect to login without exposing the path
      next('/login');
    }
  } else if (to.path === '/login' && currentUser) {
    // If already logged in and trying to access login page
    // Check if the user is an admin, and redirect accordingly
    if (AuthService.isAdmin()) {
      next('/admin/dashboard');
    } else {
      next('/schedule');
    }
  } else {
    // Handle logout query parameter cleanup
    if (to.path === '/' && to.query.logout === 'success' && from.path !== '/') {
      // Keep the query parameter when first arriving after logout
      next()
    } else if (to.query.logout === 'success' && from.query.logout === 'success') {
      // Remove the query parameter when navigating away from home after logout
      const query = { ...to.query }
      delete query.logout
      next({ path: to.path, query, hash: to.hash })
    } else {
      next()
    }
  }
})

export default router