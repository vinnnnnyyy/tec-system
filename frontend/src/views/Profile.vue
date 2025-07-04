<template>
  <div class="container mx-auto px-3 sm:px-4 py-6 sm:py-8 min-h-screen bg-gray-50">
    <div class="max-w-4xl mx-auto space-y-4 sm:space-y-6">
      <!-- Profile Header Card -->
      <div class="bg-white rounded-xl sm:rounded-2xl shadow-md sm:shadow-lg overflow-hidden transform transition-all duration-300 hover:shadow-xl">
        <div class="bg-gradient-to-r from-crimson-600 to-crimson-700 px-4 sm:px-8 py-4 sm:py-6">
          <div class="flex items-center justify-between">
            <h1 class="text-xl sm:text-2xl font-bold text-white">Student Profile</h1>
            <div class="text-crimson-100">
              <i class="fas fa-graduation-cap text-xl sm:text-2xl"></i>
            </div>
          </div>
        </div>
        
        <div class="p-4 sm:p-6 md:p-8">
          <div class="flex flex-col sm:flex-row items-start sm:items-center space-y-4 sm:space-y-0 sm:space-x-6">
            <div class="w-16 h-16 sm:w-20 sm:h-20 rounded-xl sm:rounded-2xl bg-gradient-to-br from-crimson-100 to-pink-50 flex items-center justify-center shadow-inner">
              <i class="fas fa-user text-crimson-600 text-xl sm:text-2xl"></i>
            </div>
            <div class="space-y-1 sm:space-y-2">
              <h2 class="text-xl sm:text-2xl font-bold text-gray-800">{{ userProfile?.full_name || 'Student' }}</h2>
              <div class="flex items-center text-gray-600 space-x-2">
                <i class="fas fa-envelope text-xs sm:text-sm"></i>
                <p class="text-sm sm:text-base truncate max-w-[250px] sm:max-w-none">{{ userProfile?.email }}</p>
              </div>
            </div>
          </div>
        </div>
      </div>
      
      <!-- Exam Results Section -->
      <div class="bg-white rounded-xl sm:rounded-2xl shadow-md sm:shadow-lg overflow-hidden">
        <div class="px-4 sm:px-8 py-4 sm:py-6 border-b border-gray-100">
          <div class="flex items-center justify-between">
            <h2 class="text-lg sm:text-xl font-bold text-gray-800">Exam Results</h2>
            <span class="text-xs sm:text-sm text-gray-500">
              {{ appointments.length }} {{ appointments.length === 1 ? 'Exam' : 'Exams' }}
            </span>
          </div>
        </div>

        <!-- Loading State -->
        <div v-if="loading" class="p-8 sm:p-12 flex justify-center">
          <div class="animate-spin rounded-full h-10 w-10 sm:h-12 sm:w-12 border-4 border-crimson-100 border-t-crimson-600"></div>
        </div>
        
        <!-- Empty State -->
        <div v-else-if="!hasAppointments" class="p-8 sm:p-12 text-center">
          <div class="space-y-3 sm:space-y-4">
            <div class="w-14 h-14 sm:w-16 sm:h-16 mx-auto rounded-full bg-gray-100 flex items-center justify-center">
              <i class="fas fa-file-alt text-gray-400 text-xl sm:text-2xl"></i>
            </div>
            <div class="space-y-1 sm:space-y-2">
              <p class="text-gray-600 font-medium">No Exam Records Found</p>
              <p class="text-gray-400 text-xs sm:text-sm">Your exam appointments will appear here</p>
            </div>
          </div>
        </div>
        
        <!-- Exam List -->
        <div v-else class="p-3 sm:p-6 space-y-3 sm:space-y-4">
          <div v-for="appointment in appointments" 
               :key="appointment.id" 
               class="bg-white rounded-lg sm:rounded-xl border border-gray-200 hover:border-crimson-200 transition-all duration-300 hover:shadow-md">
            <div class="p-4 sm:p-6 space-y-3 sm:space-y-4">
              <!-- Header -->
              <div class="flex flex-col sm:flex-row sm:justify-between sm:items-start gap-2 sm:gap-0">
                <div class="space-y-1">
                  <h3 class="text-base sm:text-lg font-bold text-gray-800">{{ appointment.program_name }}</h3>
                  <div class="flex flex-wrap items-center gap-2 text-xs sm:text-sm text-gray-500">
                    <div class="flex items-center">
                      <i class="fas fa-calendar mr-1"></i>
                      <span>{{ formatDate(appointment.preferred_date) }}</span>
                    </div>
                    <span class="hidden sm:inline text-gray-300">|</span>
                    <div class="flex items-center">
                      <i class="fas fa-clock mr-1"></i>
                      <span>{{ getTimeSlotDisplay(appointment) }}</span>
                    </div>
                  </div>
                </div>
                <span class="self-start px-3 sm:px-4 py-1 sm:py-2 text-xs sm:text-sm font-semibold rounded-full transform hover:scale-105 transition-transform"
                      :class="getStatusClass(appointment.status)">
                  {{ appointment.status }}
                </span>
              </div>

              <!-- Score Section -->
              <div v-if="(appointment.status === 'submitted' || appointment.status === 'approved') && appointment.exam_score" 
                   class="bg-gray-50 rounded-lg p-4 sm:p-6 space-y-3 sm:space-y-4">
                <div class="flex justify-between items-center mb-1 sm:mb-2">
                  <h4 class="text-base sm:text-lg font-semibold text-gray-700">Overall Ability Percentile Rank</h4>
                  <div class="text-2xl sm:text-3xl font-bold text-gray-900">
                    {{ appointment.exam_score.oapr || appointment.exam_score.score }}
                  </div>
                </div>

                <!-- Show basic score or detailed scores -->
                <Transition name="detailed-scores">
                  <div v-if="detailedScores" class="relative">
                    <button @click="closeDetailedScores" 
                            title="Close detailed scores"
                            class="absolute -right-2 -top-2 w-7 h-7 sm:w-8 sm:h-8 flex items-center justify-center rounded-full bg-gray-200 hover:bg-gray-300 border border-gray-300 text-gray-600 hover:text-gray-800 shadow-sm transition-all duration-200 z-10 focus:outline-none focus:ring-2 focus:ring-crimson-200">
                      <i class="fas fa-times text-sm sm:text-base"></i>
                    </button>
                    <StudentScoreCard :exam-score="detailedScores" 
                                     :model-info="scoreModelInfo" />
                  </div>
                </Transition>
                <div v-if="!detailedScores" class="text-center mt-4">
                  <button @click="fetchDetailedScores" 
                          class="px-3 sm:px-4 py-1.5 sm:py-2 text-xs sm:text-sm bg-crimson-50 text-crimson-600 rounded-full hover:bg-crimson-100 transition-colors duration-200">
                    <i class="fas fa-chart-bar mr-1"></i>
                    View Detailed Scores
                  </button>
                </div>

                <!-- Notes -->
                <div v-if="appointment.exam_score.notes" 
                     class="bg-white p-3 sm:p-4 rounded-lg border border-gray-100">
                  <p class="text-xs sm:text-sm text-gray-600">
                    <i class="fas fa-comment-alt text-gray-400 mr-2"></i>
                    {{ appointment.exam_score.notes }}
                  </p>
                </div>

                <div class="text-2xs sm:text-xs text-gray-400">
                  <i class="fas fa-clock mr-1"></i>
                  Score imported on {{ formatDateTime(appointment.exam_score.created_at) }}
                </div>
              </div>

              <!-- Other States -->
              <div v-else class="bg-gray-50 rounded-lg p-4 sm:p-6 text-center">
                <div v-if="appointment.status !== 'submitted' && appointment.status !== 'approved' && appointment.exam_score">
                  <i class="fas fa-lock text-gray-400 text-xl sm:text-2xl mb-2"></i>
                  <p class="text-xs sm:text-sm text-gray-600">Score will be available once application is submitted</p>
                </div>
                <div v-else-if="(appointment.status === 'submitted' || appointment.status === 'approved') && !appointment.exam_score">
                  <i class="fas fa-hourglass-half text-gray-400 text-xl sm:text-2xl mb-2"></i>
                  <p class="text-xs sm:text-sm text-gray-600">Score is being processed</p>
                </div>
                <div v-else>
                  <i class="fas fa-calendar-check text-gray-400 text-xl sm:text-2xl mb-2"></i>
                  <p class="text-xs sm:text-sm text-gray-600">Complete your exam and submit your application to receive your score</p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from '@/plugins/axios.js'
import { useToast } from '../composables/useToast'
import StudentScoreCard from '../components/StudentScoreCard.vue'

export default {
  name: 'StudentProfile',
  components: {
    StudentScoreCard
  },
  setup() {
    const { showToast } = useToast()
    return { showToast }
  },
  data() {
    return {
      userProfile: null,
      appointments: [],
      loading: true,
      error: null,
      detailedScores: null,
      scoreModelInfo: null
    }
  },
  computed: {
    hasAppointments() {
      return this.appointments && this.appointments.length > 0
    }
  },
  created() {
    this.fetchUserProfile()
    this.fetchAppointments()
  },
  methods: {
    async fetchUserProfile() {
      try {
        const apiUrl = import.meta.env.VITE_API_URL || 'http://127.0.0.1:8000';
        const response = await axios.get(`${apiUrl}/api/profile/`)
        this.userProfile = response.data
      } catch (error) {
        console.error('Error fetching user profile:', error)
        this.showToast('Failed to load user profile', 'error')
      }
    },
    async fetchAppointments() {
      this.loading = true
      try {
        const response = await axios.get('/api/appointments/')
        this.appointments = response.data
      } catch (error) {
        console.error('Error fetching appointments:', error)
        this.error = 'Failed to load appointments'
        this.showToast('Failed to load appointment data', 'error')
      } finally {
        this.loading = false
      }
    },
    formatDate(dateString) {
      return new Date(dateString).toLocaleDateString('en-US', {
        year: 'numeric',
        month: 'short',
        day: 'numeric'
      })
    },
    formatDateTime(dateTimeString) {
      // Use a shorter format on mobile screens
      const options = window.innerWidth < 640 ? 
        {
          year: 'numeric',
          month: 'short',
          day: 'numeric',
          hour: '2-digit',
          minute: '2-digit'
        } : 
        {
          year: 'numeric',
          month: 'short',
          day: 'numeric',
          hour: '2-digit',
          minute: '2-digit'
        };
      
      return new Date(dateTimeString).toLocaleString('en-US', options)
    },
    getStatusClass(status) {
      const classes = {
        pending: 'bg-yellow-100 text-yellow-800',
        approved: 'bg-green-100 text-green-800',
        rejected: 'bg-red-100 text-red-800',
        submitted: 'bg-blue-100 text-blue-800',
        rescheduled: 'bg-purple-100 text-purple-800'
      }
      return classes[status] || ''
    },
    getScoreBarClass(score) {
      if (score >= 80) return 'bg-green-500';
      if (score >= 60) return 'bg-yellow-500';
      return 'bg-red-500';
    },
    async fetchDetailedScores() {
      try {
        // Instead of making a separate API call, use the appointment data we already have
        const appointmentsWithScores = this.appointments.filter(
          appointment => (appointment.status === 'submitted' || appointment.status === 'approved') && appointment.exam_score
        );
        
        if (appointmentsWithScores.length === 0) {
          this.showToast('No exam scores found for your account', 'warning');
          return;
        }
        
        // Get the most recent appointment with a score
        const sortedAppointments = [...appointmentsWithScores].sort(
          (a, b) => new Date(b.exam_score.created_at) - new Date(a.exam_score.created_at)
        );
        
        const latestAppointment = sortedAppointments[0];
        
        // If we already have the full score object, use it directly
        if (latestAppointment.exam_score.part1 || latestAppointment.exam_score.part2) {
          this.detailedScores = latestAppointment.exam_score;
          return;
        }
        
        // Otherwise, we need to fetch additional details for this score
        // Try to fetch more details for this specific exam score if needed
        const scoreId = latestAppointment.exam_score.id;
        try {
          const response = await axios.get(`/api/appointments/${latestAppointment.id}/`);
          if (response.data && response.data.exam_score) {
            this.detailedScores = response.data.exam_score;
          } else {
            // If we can't get more details, use what we have
            this.detailedScores = {
              id: scoreId,
              app_no: latestAppointment.application_number || `A-${latestAppointment.id}`,
              name: this.userProfile?.full_name || 'Student',
              school: this.userProfile?.school_name || '',
              exam_type: latestAppointment.program || 'COLLEGE',
              score: latestAppointment.exam_score.score,
              exam_date: latestAppointment.preferred_date,
              created_at: latestAppointment.exam_score.created_at
            };
          }
        } catch (detailError) {
          console.error('Error fetching appointment details:', detailError);
          // Use the basic data we already have
          this.detailedScores = latestAppointment.exam_score;
        }
      } catch (error) {
        console.error('Error processing detailed scores:', error);
        this.showToast('Failed to process exam score data', 'error');
      }
    },
    closeDetailedScores() {
      this.detailedScores = null;
    },
    getTimeSlotDisplay(appointment) {
      // Use assigned test time slot if available, otherwise use the original time slot
      const timeSlot = appointment.assigned_test_time_slot || appointment.time_slot;
      
      // Format the time slot nicely
      if (timeSlot === 'morning') {
        return 'Morning';
      } else if (timeSlot === 'afternoon') {
        return 'Afternoon';
      }
      return timeSlot || 'Not specified';
    }
  }
}
</script>

<style scoped>
/* Enhanced animations */
.score-bar {
  transition: width 1.5s cubic-bezier(0.4, 0, 0.2, 1);
}

/* Improved status badges */
.bg-yellow-100, .bg-green-100, .bg-red-100, .bg-blue-100, .bg-purple-100 {
  @apply bg-opacity-90 hover:bg-opacity-100;
}

/* Card hover effects */
.hover\:shadow-xl:hover {
  transform: translateY(-2px);
}

/* Loading spinner animation */
@keyframes spin {
  to {
    transform: rotate(360deg);
  }
}

/* Score bar animation */
@keyframes expandWidth {
  from {
    width: 0;
  }
  to {
    width: var(--score-width);
  }
}

/* Score details transitions */
.detailed-scores-enter-active, 
.detailed-scores-leave-active {
  transition: all 0.3s ease-out;
}
.detailed-scores-enter-from, 
.detailed-scores-leave-to {
  opacity: 0;
  transform: translateY(-20px);
}

/* Extra small text size for very small screens */
.text-2xs {
  font-size: 0.65rem;
  line-height: 1rem;
}

/* Additional responsive adjustments for very small screens */
@media (max-width: 360px) {
  .container {
    @apply px-2;
  }
  
  .p-4 {
    @apply p-3;
  }
  
  .text-base {
    @apply text-sm;
  }
  
  .text-xl {
    @apply text-lg;
  }
}
</style> 