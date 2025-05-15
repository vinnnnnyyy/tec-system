<template>
  <main class="flex-1 overflow-y-auto bg-gray-50">
    <!-- Page Header -->
    <header class="bg-white shadow-sm sticky top-0 z-10">
      <div class="flex justify-between items-center px-8 py-5">
        <div class="flex items-center space-x-4">
          <h1 class="text-2xl font-bold text-gray-800">Dashboard</h1>
          <span class="text-sm text-gray-500">Welcome back, Admin</span>
        </div>
        <div class="flex items-center space-x-6">
          <button class="p-2 hover:bg-gray-100 rounded-full relative transition-all duration-200">
            <i class="fas fa-bell text-gray-600"></i>
            <span class="absolute top-0 right-0 h-4 w-4 bg-red-500 rounded-full text-xs text-white flex items-center justify-center">3</span>
          </button>
          <div class="flex items-center space-x-3 cursor-pointer hover:bg-gray-50 p-2 rounded-lg transition-all duration-200">
            <div class="w-10 h-10 rounded-full bg-gradient-to-r from-crimson-500 to-crimson-600 flex items-center justify-center text-white shadow-lg">
              <i class="fas fa-user"></i>
            </div>
            <div class="flex flex-col">
              <span class="text-sm font-medium text-gray-700">Admin User</span>
              <span class="text-xs text-gray-500">admin@example.com</span>
            </div>
          </div>
        </div>
      </div>
    </header>

    <!-- Dashboard Content -->
    <div class="p-8">
      <!-- Stats Cards -->
      <div v-if="loading" class="flex justify-center items-center py-10">
        <div class="spinner-border text-primary" role="status">
          <i class="fas fa-circle-notch fa-spin text-4xl text-crimson-600"></i>
        </div>
      </div>
      
      <div v-else class="grid grid-cols-1 md:grid-cols-4 gap-8 mb-8">
        <div class="bg-white p-6 rounded-2xl shadow-sm border border-gray-100 hover:shadow-md transition-all duration-300">
          <div class="flex items-center justify-between mb-4">
            <h3 class="text-gray-600 font-medium">Total Appointments</h3>
            <div class="w-12 h-12 rounded-full bg-crimson-50 flex items-center justify-center">
              <i class="fas fa-calendar text-2xl text-crimson-600"></i>
            </div>
          </div>
          <p class="text-4xl font-bold text-gray-800 mb-2">{{ dashboardStats.totalAppointments }}</p>
          <p class="text-green-600 text-sm flex items-center">
            <i class="fas fa-calendar-check mr-1"></i>
            <span>Total appointments</span>
          </p>
        </div>
        
        <div class="bg-white p-6 rounded-2xl shadow-sm border border-gray-100 hover:shadow-md transition-all duration-300">
          <div class="flex items-center justify-between mb-4">
            <h3 class="text-gray-600 font-medium">Upcoming Appointments</h3>
            <div class="w-12 h-12 rounded-full bg-blue-50 flex items-center justify-center">
              <i class="fas fa-calendar-alt text-2xl text-blue-600"></i>
            </div>
          </div>
          <p class="text-4xl font-bold text-gray-800 mb-2">{{ dashboardStats.upcomingAppointments }}</p>
          <p class="text-gray-600 text-sm flex items-center">
            <i class="fas fa-calendar-day mr-1"></i>
            <span>Next 7 days</span>
          </p>
        </div>
        
        <div class="bg-white p-6 rounded-2xl shadow-sm border border-gray-100 hover:shadow-md transition-all duration-300">
          <div class="flex items-center justify-between mb-4">
            <h3 class="text-gray-600 font-medium">Pending Assignments</h3>
            <div class="w-12 h-12 rounded-full bg-yellow-50 flex items-center justify-center">
              <i class="fas fa-clipboard-list text-2xl text-yellow-600"></i>
            </div>
          </div>
          <p class="text-4xl font-bold text-gray-800 mb-2">{{ dashboardStats.pendingAssignments }}</p>
          <p class="text-yellow-600 text-sm flex items-center">
            <i class="fas fa-exclamation-circle mr-1"></i>
            <span>Waiting for test details</span>
          </p>
        </div>

        <div class="bg-white p-6 rounded-2xl shadow-sm border border-gray-100 hover:shadow-md transition-all duration-300">
          <div class="flex items-center justify-between mb-4">
            <h3 class="text-gray-600 font-medium">Submitted Forms</h3>
            <div class="w-12 h-12 rounded-full bg-green-50 flex items-center justify-center">
              <i class="fas fa-check-circle text-2xl text-green-600"></i>
            </div>
          </div>
          <p class="text-4xl font-bold text-gray-800 mb-2">{{ dashboardStats.submittedForms }}</p>
          <p class="text-green-600 text-sm flex items-center">
            <i class="fas fa-file-alt mr-1"></i>
            <span>Completed applications</span>
          </p>
        </div>
      </div>

      <!-- Recent Appointments Table -->
      <div class="bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden">
        <div class="p-6 border-b border-gray-100 flex justify-between items-center">
          <div>
            <h2 class="text-xl font-bold text-gray-800">Recent Appointments</h2>
            <p class="text-sm text-gray-500 mt-1">Manage and track your recent appointments</p>
          </div>
          <div class="flex space-x-2">
            <button @click="showFilters = !showFilters" class="px-4 py-2 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200 transition-colors duration-200">
              <i class="fas fa-filter mr-2"></i>
              {{ showFilters ? 'Hide Filters' : 'Filter' }}
            </button>
            <button class="px-4 py-2 bg-crimson-600 text-white rounded-lg hover:bg-crimson-700 transition-colors duration-200">
              <i class="fas fa-plus mr-2"></i>
              New Appointment
            </button>
          </div>
        </div>
        
        <!-- Filter Section -->
        <div v-if="showFilters" class="p-4 bg-gray-50 border-b border-gray-100">
          <div class="grid grid-cols-1 md:grid-cols-4 gap-4">
            <!-- Search Filter -->
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Search by Name</label>
              <input 
                type="text" 
                v-model="filters.searchTerm" 
                placeholder="Search by name..."
                class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-crimson-500 focus:border-crimson-500"
                @keyup.enter="applyFilters"
              />
            </div>
            
            <!-- Status Filter -->
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Status</label>
              <select 
                v-model="filters.status" 
                class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-crimson-500 focus:border-crimson-500"
                @change="applyFilters"
              >
                <option value="">All Statuses</option>
                <option value="waiting_for_test_details">Waiting for Test Details</option>
                <option value="waiting_for_submission">Waiting for Submission</option>
                <option value="submitted">Submitted</option>
                <option value="rejected">Rejected</option>
                <option value="claimed">Claimed</option>
                <option value="rescheduled">Rescheduled</option>
              </select>
            </div>
            
            <!-- Date Range Filters -->
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">From Date</label>
              <input 
                type="date" 
                v-model="filters.fromDate" 
                class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-crimson-500 focus:border-crimson-500"
                @change="applyFilters"
              />
            </div>
            
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">To Date</label>
              <input 
                type="date" 
                v-model="filters.toDate" 
                class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-crimson-500 focus:border-crimson-500"
                @change="applyFilters"
              />
            </div>
            
            <!-- Filter Actions -->
            <div class="md:col-span-4 flex justify-end space-x-2 mt-2">
              <button 
                @click="resetFilters" 
                class="px-4 py-2 bg-gray-200 text-gray-700 rounded-lg hover:bg-gray-300 transition-colors duration-200"
              >
                Reset Filters
              </button>
              <button 
                @click="applyFilters" 
                class="px-4 py-2 bg-crimson-600 text-white rounded-lg hover:bg-crimson-700 transition-colors duration-200"
              >
                Apply Filters
              </button>
            </div>
          </div>
        </div>
        
        <!-- Loading state for table -->
        <div v-if="loadingAppointments" class="flex justify-center items-center py-10">
          <div class="spinner-border text-primary" role="status">
            <i class="fas fa-circle-notch fa-spin text-4xl text-crimson-600"></i>
          </div>
        </div>
        
        <div v-else class="overflow-x-auto">
          <table class="w-full text-sm">
            <thead class="bg-gray-50">
              <tr>
                <th class="px-3 py-2 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">Applicant</th>
                <th class="px-3 py-2 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">School</th>
                <th class="px-3 py-2 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">Contact</th>
                <th class="px-3 py-2 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">Program</th>
                <th class="px-3 py-2 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">Date</th>
                <th class="px-3 py-2 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">Time</th>
                <th class="px-3 py-2 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">Status</th>
                <th class="px-3 py-2 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">Action</th>
              </tr>
            </thead>
            <tbody class="divide-y divide-gray-100">
              <tr v-for="appointment in appointments" 
                  :key="appointment.id" 
                  class="hover:bg-gray-50 transition-colors duration-200">
                <td class="px-3 py-2">
                  <div class="flex items-center">
                    <div class="w-8 h-8 rounded-full bg-gradient-to-r from-gray-100 to-gray-200 flex items-center justify-center mr-2">
                      <i class="fas fa-user text-sm text-gray-600"></i>
                    </div>
                    <div>
                      <div class="text-xs font-medium text-gray-900">{{ appointment.full_name }}</div>
                      <div class="text-xs text-gray-500">{{ appointment.email }}</div>
                    </div>
                  </div>
                </td>
                <td class="px-3 py-2">
                  <div class="text-xs text-gray-900">{{ appointment.school_name }}</div>
                </td>
                <td class="px-3 py-2">
                  <div class="text-xs text-gray-600">{{ appointment.contact_number }}</div>
                </td>
                <td class="px-3 py-2">
                  <div class="text-xs font-medium text-gray-900">{{ appointment.program_name }}</div>
                </td>
                <td class="px-3 py-2">
                  <div class="text-xs text-gray-600">{{ formatDate(appointment.preferred_date) }}</div>
                </td>
                <td class="px-3 py-2">
                  <div class="text-xs text-gray-600">
                    {{ formatTimeSlot(appointment.assigned_test_time_slot || appointment.time_slot) }}
                    <span v-if="appointment.assigned_test_time_slot && appointment.assigned_test_time_slot !== appointment.time_slot" 
                          class="ml-1 text-orange-500" 
                          title="Administrator assigned time slot differs from preferred time slot">
                      <i class="fas fa-info-circle"></i>
                    </span>
                  </div>
                </td>
                <td class="px-3 py-2">
                  <span :class="getStatusClass(appointment.status)" class="inline-flex items-center text-xs">
                    <span class="w-1.5 h-1.5 rounded-full mr-1" :class="{
                      'bg-yellow-400': isStatusPending(appointment.status),
                      'bg-green-400': isStatusApproved(appointment.status),
                      'bg-red-400': isStatusRejected(appointment.status),
                      'bg-blue-400': isStatusCompleted(appointment.status),
                      'bg-purple-400': isStatusRescheduled(appointment.status),
                      'bg-orange-400': isStatusWaitingTest(appointment.status)
                    }"></span>
                    {{ formatStatus(appointment.status) }}
                  </span>
                </td>
                <td class="px-3 py-2">
                  <button @click="viewDetails(appointment.id)" 
                          class="text-crimson-600 hover:text-crimson-900 flex items-center text-xs transition-colors duration-200">
                    <i class="fas fa-eye mr-1"></i>
                    <span>View</span>
                  </button>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
        
        <!-- Pagination -->
        <AdminPagination
          v-model="currentPage"
          :total-items="totalAppointments"
          :items-per-page="itemsPerPage"
          class="bg-white border-t border-gray-200 p-4"
          @update:modelValue="fetchRecentAppointments"
        />
      </div>
    </div>
  </main>
</template>

<script>
import { ref, computed, onMounted } from 'vue'
import AdminPagination from '../components/AdminPagination.vue'
import axiosInstance from '../../../services/axios.interceptor'

export default {
  name: 'Dashboard',
  components: {
    AdminPagination
  },
  setup() {
    // Dashboard statistics state
    const dashboardStats = ref({
      totalAppointments: 0,
      upcomingAppointments: 0,
      pendingAssignments: 0,
      submittedForms: 0
    })
    const loading = ref(true)
    
    // Appointments state
    const appointments = ref([])
    const currentPage = ref(1)
    const itemsPerPage = ref(10)
    const totalAppointments = ref(0)
    const loadingAppointments = ref(true)
    
    // Filter state
    const showFilters = ref(false)
    const filters = ref({
      searchTerm: '',
      status: '',
      fromDate: '',
      toDate: ''
    })
    
    // Apply filters
    const applyFilters = () => {
      currentPage.value = 1 // Reset to first page when filters change
      fetchRecentAppointments()
    }
    
    // Reset filters
    const resetFilters = () => {
      filters.value = {
        searchTerm: '',
        status: '',
        fromDate: '',
        toDate: ''
      }
      applyFilters()
    }
    

    // Fetch dashboard statistics
    const fetchDashboardStats = async () => {
      loading.value = true
      try {
        const response = await axiosInstance.get('/api/admin/dashboard/stats/')
        dashboardStats.value = {
          totalAppointments: response.data.total_appointments,
          upcomingAppointments: response.data.upcoming_appointments,
          pendingAssignments: response.data.pending_assignments,
          submittedForms: response.data.submitted_forms
        }
      } catch (error) {
        console.error('Error fetching dashboard stats:', error)
      } finally {
        loading.value = false
      }
    }
    
    // Fetch recent appointments
    const fetchRecentAppointments = async () => {
      loadingAppointments.value = true
      try {
        // Create params object with pagination
        const params = {
          page: currentPage.value,
          page_size: itemsPerPage.value
        }
        
        // Add filters to params if they exist
        if (filters.value.searchTerm) {
          params.search = filters.value.searchTerm
        }
        
        if (filters.value.status) {
          params.status = filters.value.status
        }
        
        if (filters.value.fromDate) {
          params.from_date = filters.value.fromDate
        }
        
        if (filters.value.toDate) {
          params.to_date = filters.value.toDate
        }
        
        const response = await axiosInstance.get('/api/admin/dashboard/recent-appointments/', {
          params: params
        })
        
        appointments.value = response.data.appointments
        totalAppointments.value = response.data.total
      } catch (error) {
        console.error('Error fetching recent appointments:', error)
      } finally {
        loadingAppointments.value = false
      }
    }

    // Format date helper function - more compact version
    const formatDate = (date) => {
      return new Date(date).toLocaleDateString('en-US', {
        year: 'numeric',
        month: 'short',
        day: 'numeric'
      })
    }
    
    // Format time slot helper function - more compact
    const formatTimeSlot = (timeSlot) => {
      const slots = {
        'morning': 'AM (8-12)',
        'afternoon': 'PM (1-5)',
      }
      return slots[timeSlot] || timeSlot
    }
    
    // Format status helper function
    const formatStatus = (status) => {
      const statusMap = {
        'waiting_for_test_details': 'Waiting for Test Details',
        'waiting_for_submission': 'Waiting for Submission',
        'rejected': 'Rejected',
        'claimed': 'Claimed',
        'rescheduled': 'Rescheduled',
        'submitted': 'Submitted',
        'approved': 'Approved'
      }
      return statusMap[status] || status
    }

    // Get status class helper function
    const getStatusClass = (status) => {
      let statusClass = ''
      
      if (isStatusPending(status)) {
        statusClass = 'bg-yellow-100 text-yellow-800'
      } else if (isStatusApproved(status)) {
        statusClass = 'bg-green-100 text-green-800'
      } else if (isStatusRejected(status)) {
        statusClass = 'bg-red-100 text-red-800'
      } else if (isStatusCompleted(status)) {
        statusClass = 'bg-blue-100 text-blue-800'
      } else if (isStatusRescheduled(status)) {
        statusClass = 'bg-purple-100 text-purple-800'
      } else if (isStatusWaitingTest(status)) {
        statusClass = 'bg-orange-100 text-orange-800'
      }
      
      return `px-1.5 py-0.5 text-2xs font-medium rounded-full ${statusClass}`
    }
    
    // Status helper functions
    const isStatusPending = (status) => {
      return ['waiting_for_submission'].includes(status)
    }
    
    const isStatusApproved = (status) => {
      return ['submitted'].includes(status)
    }
    
    const isStatusRejected = (status) => {
      return ['rejected'].includes(status)
    }
    
    const isStatusCompleted = (status) => {
      return ['claimed'].includes(status)
    }

    const isStatusRescheduled = (status) => {
      return ['rescheduled'].includes(status)
    }

    const isStatusWaitingTest = (status) => {
      return ['waiting_for_test_details'].includes(status)
    }

    // View details handler
    const viewDetails = (appointmentId) => {
      // Navigate to appointment details page
      window.location.href = `/admin/appointments/${appointmentId}`
    }
    
    // Initial data fetch
    onMounted(() => {
      fetchDashboardStats()
      fetchRecentAppointments()
    })

    return {
      // Dashboard stats
      dashboardStats,
      loading,
      
      // Appointments
      appointments,
      currentPage,
      itemsPerPage,
      totalAppointments,
      loadingAppointments,
      fetchRecentAppointments,
      
      // Filters
      showFilters,
      filters,
      applyFilters,
      resetFilters,
      
      // UI helpers
      formatDate,
      formatTimeSlot,
      formatStatus,
      getStatusClass,
      isStatusPending,
      isStatusApproved,
      isStatusRejected,
      isStatusCompleted,
      isStatusRescheduled,
      isStatusWaitingTest,
      viewDetails
    }
  }
}
</script>

<style>
.text-crimson-600 {
  color: #DC2626;
}

.text-crimson-900 {
  color: #7F1D1D;
}

.bg-crimson-600 {
  background-color: #DC2626;
}

.bg-crimson-50 {
  background-color: #FEF2F2;
}

.from-crimson-500 {
  --tw-gradient-from: #EF4444;
  --tw-gradient-stops: var(--tw-gradient-from), var(--tw-gradient-to, rgba(239, 68, 68, 0));
}

.to-crimson-600 {
  --tw-gradient-to: #DC2626;
}

.hover\:bg-crimson-700:hover {
  background-color: #B91C1C;
}

.hover\:text-crimson-900:hover {
  color: #7F1D1D;
}

.bg-yellow-50 {
  background-color: #FFFBEB;
}

.text-yellow-600 {
  color: #D97706;
}

.bg-orange-100 {
  background-color: #FFEDD5;
}

.text-orange-800 {
  color: #9A3412;
}

.bg-orange-400 {
  background-color: #FB923C;
}

.bg-purple-100 {
  background-color: #F3E8FF;
}

.text-purple-800 {
  color: #6B21A8;
}

.bg-purple-400 {
  background-color: #C084FC;
}

.text-2xs {
  font-size: 0.7rem;
  line-height: 1rem;
}

/* Add smooth transitions */
.transition-all {
  transition-property: all;
  transition-timing-function: cubic-bezier(0.4, 0, 0.2, 1);
}

.duration-200 {
  transition-duration: 200ms;
}

.duration-300 {
  transition-duration: 300ms;
}
</style> 