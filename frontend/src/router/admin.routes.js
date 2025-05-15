import AdminLayout from '../views/admin/layouts/AdminLayout.vue'
import Dashboard from '../views/admin/pages/Dashboard.vue'

export const adminRoutes = [
  // Admin Dashboard - Protected routes
  {
    path: '/admin',
    component: AdminLayout,
    meta: { requiresAdmin: true },
    children: [
      {
        path: '',
        redirect: '/admin/dashboard'
      },
      {
        path: 'dashboard',
        name: 'AdminDashboard',
        component: Dashboard
      },
      {
        path: 'appointments',
        name: 'AdminAppointments',
        component: () => import('../views/admin/pages/Appointments.vue')
      },
     
      {
        path: 'program',
        name: 'AdminPrograms',
        component: () => import('../views/admin/pages/Programs.vue')
      },
      {
        path: 'settings',
        name: 'AdminSettings',
        component: () => import('../views/admin/pages/Settings.vue')
      },
      {
        path: 'results/import',
        name: 'AdminExamResultsImport',
        component: () => import('../views/admin/pages/ExamResultsImport.vue')
      },
      {
        path: 'results/import-score',
        name: 'AdminImportScore',
        component: () => import('../views/admin/pages/ImportScore.vue')
      },
      {
        path: 'test-sessions',
        name: 'AdminTestSessions',
        component: () => import('../views/admin/pages/TestSessionManagement.vue')
      },
    ]
  }
] 