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
                
                <!-- Information about score release -->
                <div class="bg-blue-50 border border-blue-200 rounded-lg p-3 sm:p-4 mt-3">
                  <div class="flex items-start space-x-2">
                    <i class="fas fa-info-circle text-blue-500 text-sm mt-0.5 flex-shrink-0"></i>
                    <div class="text-xs sm:text-sm text-blue-700">
                      <p class="font-medium mb-1">Score Release Information</p>
                      <p>If your scores are officially released, you must visit <strong>WMSU-TEC at Campus B of Western Mindanao State University</strong> to obtain your official score report.</p>
                    </div>
                  </div>
                </div>
              </div>

              <!-- Other States -->
              <div v-else class="bg-gray-50 rounded-lg p-4 sm:p-6 text-center">
                <div v-if="appointment.status !== 'submitted' && appointment.status !== 'approved' && appointment.exam_score">
                  <i class="fas fa-lock text-gray-400 text-xl sm:text-2xl mb-2"></i>
                  <p class="text-xs sm:text-sm text-gray-600">Score will be available once application is submitted</p>
                </div>
                <div v-else-if="appointment.status === 'approved' && !appointment.exam_score">
                  <i class="fas fa-hourglass-half text-gray-400 text-xl sm:text-2xl mb-2"></i>
                  <p class="text-xs sm:text-sm text-gray-600 mb-3">Score is being processed</p>
                  
                  <!-- Download Application Form Button for Approved Appointments -->
                  <div class="mb-4">
                    <button 
                      @click="downloadApplicationForm(appointment)" 
                      :disabled="isGeneratingPdf"
                      class="w-full sm:w-auto bg-crimson-600 hover:bg-crimson-700 text-white py-2.5 px-5 rounded-lg flex items-center justify-center transition-colors duration-200 text-sm font-medium mb-3"
                      aria-label="Download Application Form"
                    >
                      <i :class="isGeneratingPdf ? 'fas fa-spinner fa-spin' : 'fas fa-file-pdf'" class="mr-2"></i>
                      {{ isGeneratingPdf ? 'Generating PDF...' : 'Download Application Form' }}
                    </button>
                  </div>
                  
                  <!-- Simple View Scores Button (no password required) -->
                  <button 
                    @click="fetchScoresForAppointment(appointment)" 
                    class="px-4 py-2 bg-crimson-600 text-white rounded-lg hover:bg-crimson-700 transition-colors duration-200 text-sm font-medium"
                    :disabled="loadingScores"
                  >
                    <i v-if="loadingScores" class="fas fa-spinner fa-spin mr-2"></i>
                    <i v-else class="fas fa-eye mr-2"></i>
                    {{ loadingScores ? 'Loading...' : 'View Scores' }}
                  </button>
                  
                  <!-- Alternative search option -->
                  <div class="mt-4 p-3 bg-blue-50 border border-blue-200 rounded-lg">
                    <p class="text-xs text-blue-700 mb-2">
                      Can't find your scores? Try our secure search:
                    </p>
                    <button 
                      @click="showSecureSearchModal"
                      class="inline-flex items-center px-3 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors duration-200 text-sm font-medium"
                    >
                      <i class="fas fa-search mr-2"></i>
                      Search Exam Scores (Secure)
                    </button>
                  </div>
                </div>
                <div v-else-if="(appointment.status === 'submitted') && !appointment.exam_score">
                  <i class="fas fa-hourglass-half text-gray-400 text-xl sm:text-2xl mb-2"></i>
                  <p class="text-xs sm:text-sm text-gray-600 mb-3">Score is being processed</p>
                  
                  <!-- Alternative search option for submitted appointments -->
                  <div class="mt-4 p-3 bg-blue-50 border border-blue-200 rounded-lg">
                    <p class="text-xs text-blue-700 mb-2">
                      If your scores have been released, you can search for them:
                    </p>
                    <button 
                      @click="showSecureSearchModal"
                      class="inline-flex items-center px-3 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors duration-200 text-sm font-medium"
                    >
                      <i class="fas fa-search mr-2"></i>
                      Search Exam Scores (Secure)
                    </button>
                  </div>
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

    <!-- Secure Search Password Modal -->
    <div v-if="showSecureSearchVerification" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
      <div class="bg-white rounded-lg shadow-xl w-full max-w-md">
        <div class="p-6">
          <div class="flex items-center justify-between mb-4">
            <h3 class="text-lg font-semibold text-gray-900">Secure Search Access</h3>
            <button @click="closeSecureSearchModal" class="text-gray-400 hover:text-gray-600">
              <i class="fas fa-times"></i>
            </button>
          </div>
          
          <div class="mb-4">
            <p class="text-sm text-gray-600 mb-4">
              Please enter your account password to access the secure exam scores search.
            </p>
            
            <div class="space-y-4">
              <div>
                <label for="securePassword" class="block text-sm font-medium text-gray-700 mb-1">Password</label>
                <div class="relative">
                  <input
                    id="securePassword"
                    v-model="secureSearchForm.password"
                    :type="secureSearchForm.showPassword ? 'text' : 'password'"
                    class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-crimson-500"
                    placeholder="Enter your password"
                    @keyup.enter="verifyPasswordAndSearch"
                  >
                  <button
                    type="button"
                    @click="secureSearchForm.showPassword = !secureSearchForm.showPassword"
                    class="absolute inset-y-0 right-0 px-3 py-2 flex items-center focus:outline-none hover:text-crimson-500 transition-colors duration-200"
                  >
                    <i :class="secureSearchForm.showPassword ? 'fas fa-eye-slash' : 'fas fa-eye'" class="h-4 w-4 text-gray-400"></i>
                  </button>
                </div>
              </div>
              
              <div v-if="secureSearchForm.error" class="p-3 bg-red-50 text-red-700 rounded-lg border border-red-200 flex items-start gap-2">
                <i class="fas fa-exclamation-circle mt-1 text-red-500 flex-shrink-0"></i>
                <p class="text-sm">{{ secureSearchForm.error }}</p>
              </div>
            </div>
          </div>
          
          <div class="flex justify-end space-x-3">
            <button 
              @click="closeSecureSearchModal"
              class="px-4 py-2 text-gray-700 bg-gray-100 rounded-lg hover:bg-gray-200 transition-colors duration-200"
            >
              Cancel
            </button>
            <button 
              @click="verifyPasswordAndSearch"
              :disabled="secureSearchForm.loading || !secureSearchForm.password"
              class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors duration-200 disabled:bg-gray-300 disabled:cursor-not-allowed flex items-center"
            >
              <i v-if="secureSearchForm.loading" class="fas fa-spinner fa-spin mr-2"></i>
              <i v-else class="fas fa-search mr-2"></i>
              {{ secureSearchForm.loading ? 'Verifying...' : 'Search Scores' }}
            </button>
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
      scoreModelInfo: null,
      loadingScores: false,
      isGeneratingPdf: false,
      showSecureSearchVerification: false,
      secureSearchForm: {
        password: '',
        showPassword: false,
        loading: false,
        error: ''
      }
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
  mounted() {
    // Check for download form URL parameter
    const urlParams = new URLSearchParams(window.location.search);
    const downloadFormId = urlParams.get('download_form');
    
    if (downloadFormId) {
      // Wait for appointments to load, then trigger download
      this.$nextTick(() => {
        setTimeout(() => {
          const appointment = this.appointments.find(app => app.id == downloadFormId);
          if (appointment && appointment.status === 'approved') {
            this.downloadApplicationForm(appointment);
          }
        }, 1000); // Wait 1 second for data to load
      });
    }
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
    },
    
    async fetchScoresForAppointment(appointment) {
      this.loadingScores = true;
      
      try {
        // Try to fetch scores for the specific appointment
        const apiUrl = import.meta.env.VITE_API_URL || 'http://127.0.0.1:8000';
        const response = await axios.get(`${apiUrl}/api/appointments/${appointment.id}/scores/`);
        
        if (response.data) {
          // Successfully retrieved scores
          this.showToast('Scores retrieved successfully!', 'success');
          
          // Update the appointment with the score data
          const appointmentIndex = this.appointments.findIndex(
            app => app.id === appointment.id
          );
          
          if (appointmentIndex !== -1) {
            this.appointments[appointmentIndex].exam_score = response.data;
            // Force reactivity update
            this.$forceUpdate();
          }
        } else {
          this.showToast('No scores available yet. Please try again later.', 'warning');
        }
      } catch (error) {
        console.error('Error fetching scores:', error);
        if (error.response?.status === 404) {
          this.showToast('No scores found for this appointment yet.', 'warning');
        } else {
          this.showToast('Failed to retrieve scores. Please try again.', 'error');
        }
      } finally {
        this.loadingScores = false;
      }
    },
    
    showSecureSearchModal() {
      this.showSecureSearchVerification = true;
      this.secureSearchForm.password = '';
      this.secureSearchForm.error = '';
      this.secureSearchForm.loading = false;
    },
    
    async downloadApplicationForm(appointment) {
      if (!appointment || this.isGeneratingPdf) {
        console.warn('Cannot download form: No appointment data or PDF generation already in progress.');
        return;
      }
      
      try {
        this.isGeneratingPdf = true;
        this.showToast('Generating application form PDF...', 'info');
        
        // Import ApplicationForm component dynamically
        const { default: ApplicationForm } = await import('@/components/ApplicationForm.vue');
        
        // Create a Vue instance with the ApplicationForm component
        const { createApp } = await import('vue');
        
        // Prepare form data from appointment
        const formData = {
          appointmentId: appointment.id,
          fullName: appointment.full_name,
          email: appointment.email,
          birthMonth: appointment.birth_month,
          birthDay: appointment.birth_day,
          birthYear: appointment.birth_year,
          gender: {
            male: appointment.gender === 'Male',
            female: appointment.gender === 'Female'
          },
          age: appointment.age,
          homeAddress: appointment.home_address,
          citizenship: appointment.citizenship,
          contactNumber: appointment.contact_number,
          programName: appointment.program?.name || 'College Entrance Test',
          preferredDate: appointment.created_at,
          applicantType: appointment.applicant_type,
          schoolName: appointment.school_name,
          wmsucetExperience: {
            firstTime: appointment.is_first_time_taking_test,
            notFirstTime: !appointment.is_first_time_taking_test,
            timesTaken: appointment.times_taken_test || ''
          },
          highSchoolCode: appointment.high_school_code || '',
          // Test details
          test_date: appointment.test_session?.exam_date,
          test_center: appointment.test_center?.name,
          test_center_code: appointment.test_center?.id,
          room_number: appointment.test_room?.name || appointment.test_room?.room_code,
          room_code: appointment.test_room?.room_code,
          time_slot: appointment.assigned_test_time_slot || appointment.time_slot
        };
        
        // Create a temporary container for the form
        const tempContainer = document.createElement('div');
        tempContainer.style.position = 'absolute';
        tempContainer.style.left = '-9999px';
        tempContainer.style.top = '-9999px';
        tempContainer.style.width = '8.5in';
        tempContainer.style.height = '14in';
        document.body.appendChild(tempContainer);
        
        // Create Vue app instance
        const app = createApp(ApplicationForm, {
          appointmentData: formData,
          outputPdfOnly: true,
          startDownload: true
        });
        
        // Handle PDF generation complete event
        app.config.globalProperties.$emit = (event, data) => {
          if (event === 'pdf-generation-complete') {
            this.isGeneratingPdf = false;
            document.body.removeChild(tempContainer);
            
            if (data.success) {
              this.showToast('Application form downloaded successfully!', 'success');
            } else {
              this.showToast('Failed to generate PDF. Please try again.', 'error');
              console.error('PDF generation failed:', data.error);
            }
          }
        };
        
        // Mount the app
        const instance = app.mount(tempContainer);
        
        // Fallback timeout in case PDF generation fails
        setTimeout(() => {
          if (this.isGeneratingPdf) {
            this.isGeneratingPdf = false;
            if (document.body.contains(tempContainer)) {
              document.body.removeChild(tempContainer);
            }
            this.showToast('PDF generation timed out. Please try again.', 'error');
          }
        }, 30000); // 30 second timeout
        
      } catch (error) {
        console.error('Error downloading application form:', error);
        this.isGeneratingPdf = false;
        this.showToast('Failed to download application form. Please try again.', 'error');
      }
    },
    
    closeSecureSearchModal() {
      this.showSecureSearchVerification = false;
      this.secureSearchForm.password = '';
      this.secureSearchForm.error = '';
      this.secureSearchForm.loading = false;
    },
    
    async verifyPasswordAndSearch() {
      if (!this.secureSearchForm.password) {
        this.secureSearchForm.error = 'Please enter your password';
        return;
      }
      
      this.secureSearchForm.loading = true;
      this.secureSearchForm.error = '';
      
      try {
        // Verify password with backend
        const apiUrl = import.meta.env.VITE_API_URL || 'http://127.0.0.1:8000';
        const verifyResponse = await axios.post(`${apiUrl}/api/verify-password/`, {
          password: this.secureSearchForm.password
        });
        
        if (verifyResponse.data.valid) {
          // Password is correct, redirect to the secure search page
          this.showToast('Password verified! Redirecting to secure search...', 'success');
          this.closeSecureSearchModal();
          
          // Navigate to the secure search page
          this.$router.push('/scores');
        } else {
          this.secureSearchForm.error = 'Invalid password. Please try again.';
        }
      } catch (error) {
        console.error('Error verifying password:', error);
        if (error.response?.status === 401) {
          this.secureSearchForm.error = 'Invalid password. Please try again.';
        } else {
          this.secureSearchForm.error = 'Authentication failed. Please try again.';
        }
      } finally {
        this.secureSearchForm.loading = false;
      }
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