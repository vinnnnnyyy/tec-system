<template>
  <div>
    <ScheduleHero />
    
    <!-- Welcome notification for newly logged in or registered users -->
    <div v-if="showWelcomeNotification" class="container mx-auto px-3 sm:px-4 md:px-6 lg:px-8 mt-4">
      <div class="bg-green-50 border-l-4 border-green-500 p-4 flex items-start">
        <div class="flex-shrink-0 mt-0.5">
          <i class="fas fa-check-circle text-green-500"></i>
        </div>
        <div class="ml-3">
          <p class="text-sm text-green-700">
            Welcome! You've successfully signed in. You can now schedule your exams.
          </p>
        </div>
        <button @click="dismissWelcomeNotification" class="ml-auto text-green-500 hover:text-green-600">
          <i class="fas fa-times"></i>
        </button>
      </div>
    </div>
    
    <div class="container mx-auto px-3 sm:px-4 md:px-6 lg:px-8 py-6 sm:py-10 md:py-16">
      <!-- Loading state -->
      <div v-if="loading" class="flex justify-center py-12">
        <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-crimson-600"></div>
      </div>
      
      <!-- Error state -->
      <div v-else-if="error" class="bg-red-50 text-red-700 p-4 rounded-lg mb-6">
        {{ error }}
      </div>
      
      <!-- No active programs message -->
      <div v-else-if="activePrograms.length === 0" 
           class="flex flex-col items-center justify-center py-12 px-4 text-center">
        <div class="rounded-full bg-gray-100 p-6 mb-4">
          <i class="fas fa-calendar-times text-4xl text-gray-400"></i>
        </div>
        <h3 class="text-xl font-semibold text-gray-900 mb-2">No Active Programs</h3>
        <p class="text-gray-600">There are no active programs available for scheduling right now.</p>
      </div>
      
      <!-- Programs grid -->
      <div v-else>
        <!-- Full page loading state for pagination - matches initial page load -->
        <div v-if="paginationLoading" class="flex justify-center py-12">
          <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-crimson-600"></div>
        </div>
        
        <!-- Cards container only shown when not loading -->
        <div v-else class="grid grid-cols-1 md:grid-cols-2 gap-4 sm:gap-6 md:gap-8">
          <div 
            v-for="program in paginatedPrograms" 
            :key="program.id"
            class="h-full flex"
          >
            <ProgramCard 
              :program="program"
              :is-scheduled="scheduledProgramIds.has(program.id)"
              :appointment-id="appointmentIds[program.id]"
              :has-claimed-appointment="claimedProgramIds.has(program.id)"
              :is-restricted="!!restrictedPrograms[program.id]"
              :restriction-reason="restrictedPrograms[program.id]?.reason"
              :test-sessions="testSessions"
              @schedule="handleSchedule"
              @check-status="handleStatusCheck"
              class="w-full"
            />
          </div>
          <!-- Empty state placeholders for better grid alignment -->
          <template v-for="n in (itemsPerPage - paginatedPrograms.length)" :key="'empty-'+n">
            <div v-if="paginatedPrograms.length % 2 !== 0" class="hidden md:block"></div>
          </template>
        </div>
        
        <!-- Pagination - always visible -->
        <div class="mt-12 flex justify-center">
          <div class="inline-flex rounded-md shadow-sm">
            <button 
              @click="prevPage"
              :disabled="currentPage === 1"
              class="px-3 py-2 rounded-l-md border border-gray-300 bg-white text-gray-500 hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed"
            >
              <i class="fas fa-chevron-left text-xs"></i>
            </button>
            
            <template v-for="item in paginationItems" :key="item">
              <!-- Ellipsis -->
              <span 
                v-if="item === '...'" 
                class="px-4 py-2 border-t border-b border-gray-300 bg-white text-gray-500"
              >
                ...
              </span>
              
              <!-- Page number -->
              <button 
                v-else
                @click="goToPage(item)"
                class="px-4 py-2 border-t border-b border-gray-300"
                :class="currentPage === item 
                  ? 'bg-crimson-50 text-crimson-600 font-medium' 
                  : 'bg-white text-gray-500 hover:bg-gray-50'"
              >
                {{ item }}
              </button>
            </template>
            
            <button 
              @click="nextPage"
              :disabled="currentPage === totalPages"
              class="px-3 py-2 rounded-r-md border border-gray-300 bg-white text-gray-500 hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed"
            >
              <i class="fas fa-chevron-right text-xs"></i>
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Schedule Modal - Only render when there's a selected program -->
    <ScheduleModal
      v-if="selectedProgram && !isRescheduling"
      v-model="showScheduleModal"
      :program="selectedProgram"
      :date-availability="dateAvailability"
      @submit="handleScheduleSubmit"
    />

    <!-- Dedicated Reschedule Modal -->
    <RescheduleModal
      v-if="selectedProgram && isRescheduling && reschedulingInfo?.originalAppointment"
      v-model="showRescheduleModal"
      :program="selectedProgram"
      :original-appointment="reschedulingInfo.originalAppointment"
      :date-availability="dateAvailability"
      @submit="handleScheduleSubmit"
    />

    <!-- Add the AppointmentStatus modal -->
    <AppointmentStatus 
      v-if="selectedAppointmentId"
      :id="selectedAppointmentId"
      :show="showStatusModal"
      @close="closeStatusModal"
      @reschedule="handleRescheduleRequest"
    />
  </div>
</template>

<script>
import ScheduleHero from '../components/schedule/ScheduleHero.vue'
import ProgramCard from '../components/schedule/ProgramCard.vue'
import ScheduleModal from '../components/schedule/ScheduleModal.vue'
import RescheduleModal from '../components/schedule/RescheduleModal.vue'
import AppointmentStatus from '../components/schedule/AppointmentStatus.vue'
import axios from '../plugins/axios'
import AuthService from '../services/auth.service'
import { useToast } from '../composables/useToast'
import ApplicationFormStore from '../services/ApplicationFormStore'

// Fallback programs in case API is not available
const fallbackPrograms = [
  {
    id: 1,
    name: 'WMSU College Entrance Test (WMSU-CET)',
    description: 'College entrance examination for WMSU undergraduate programs',
    status: 'active',
    capacity_limit: 50
  },
  {
    id: 2,
    name: 'Graduate School Entrance Test',
    description: 'Entrance examination for graduate school programs',
    status: 'active', 
    capacity_limit: 30
  }
];

export default {
  name: 'Schedule',
  components: {
    ScheduleHero,
    ProgramCard,
    ScheduleModal,
    RescheduleModal,
    AppointmentStatus
  },
  data() {
    return {
      programs: [],
      loading: true,
      error: null,
      showScheduleModal: false,
      showRescheduleModal: false,
      selectedProgram: null,
      showWelcomeNotification: false,
      // Initialize empty by default - data will come from API
      scheduledProgramIds: new Set(),
      appointmentIds: {},
      showStatusModal: false,
      selectedAppointmentId: null,
      reschedulingInfo: null,
      isRescheduling: false,
      // Add new data property for date availability
      dateAvailability: {},
      claimedProgramIds: new Set(),
      // Add new data properties for exam scores
      userExamScores: {},
      restrictedPrograms: {},
      // Pagination properties
      currentPage: 1,
      itemsPerPage: 4,
      paginationLoading: false,
      // Test sessions for exam dates
      testSessions: [],
    }
  },
  async created() {
    // First fetch programs
    await this.fetchPrograms();
    
    // Fetch test sessions for exam dates
    await this.fetchTestSessions();
    
    // Check if the user just logged in or registered by looking at the navigation state
    if (this.$route.params.justLoggedIn || 
        this.$route.query.from === 'login' || 
        this.$route.query.from === 'register') {
      this.showWelcomeNotification = true
    }
    
    // Check if we're in rescheduling mode from URL parameters
    if (this.$route.query.reschedule === 'true' && this.$route.query.appointmentId) {
      this.isRescheduling = true;
      this.reschedulingInfo = {
        isRescheduling: true,
        originalAppointmentId: this.$route.query.appointmentId
      };
    }

    // Fetch appointments for the current user
    await this.fetchUserAppointments();
    
    // Fetch exam scores to check program eligibility
    await this.fetchUserExamScores();
    
    // Watch for route changes to refresh data when returning to Schedule
    this.$watch(
      () => this.$route.name,
      (newRouteName) => {
        if (newRouteName === 'Schedule') {
          this.fetchUserAppointments().then(() => {
            this.fetchUserExamScores();
            this.fetchTestSessions();
          });
        }
      }
    );
  },
  mounted() {
    // Add route watcher to refresh appointments when returning to this page
    this.$watch(
      () => this.$route.name,
      (newRouteName) => {
        if (newRouteName === 'Schedule') {
          this.fetchUserAppointments().then(() => {
            this.fetchUserExamScores();
            this.fetchTestSessions();
          });
        }
      }
    );
  },
  methods: {
    dismissWelcomeNotification() {
      this.showWelcomeNotification = false
    },
    async fetchTestSessions() {
      try {
        // Try different endpoints to find the working one
        const endpoints = [
          '/api/public/test-sessions/',  // Public endpoint (no auth required)
          '/api/admin/test-sessions/'    // Admin endpoint (auth required)
        ];
        
        let response = null;
        
        for (const endpoint of endpoints) {
          try {
            response = await axios.get(endpoint);
            if (response.data) break;
          } catch (err) {
            console.log(`Failed to fetch from ${endpoint}`, err.message);
            continue;
          }
        }
        
        if (!response) {
          console.warn('No test sessions available');
          this.testSessions = [];
          return;
        }
        
        this.testSessions = response.data;
        console.log('Test sessions loaded:', this.testSessions.length);
        console.log('Test sessions data:', this.testSessions);
        
        // Log each session for debugging
        this.testSessions.forEach((session, index) => {
          console.log(`Session ${index + 1}:`, {
            id: session.id,
            exam_type: session.exam_type,
            exam_date: session.exam_date,
            registration_start: session.registration_start_date,
            registration_end: session.registration_end_date,
            status: session.status
          });
        });
        
        // Also log what programs we have for comparison
        console.log('Available programs for matching:', this.programs.map(p => ({
          name: p.name,
          code: p.code
        })));
      } catch (err) {
        console.error('Error fetching test sessions:', err);
        this.testSessions = [];
      }
    },
    async fetchPrograms() {
      this.loading = true
      this.error = null
      
      try {
        // Fetch programs from the API
        const response = await axios.get('/api/programs') 

        this.programs = response.data
      } catch (err) {
        this.programs = fallbackPrograms
        this.error = 'Could not load the latest programs. Showing default programs instead.'
      } finally {
        // Add a minimum delay of 800ms before hiding the loading spinner
        // for a better user experience
        const minLoadingTime = 800 // milliseconds
        const startTime = Date.now()
        const elapsedTime = Date.now() - startTime
        const remainingTime = Math.max(0, minLoadingTime - elapsedTime)
        
        setTimeout(() => {
          this.loading = false
        }, remainingTime)
      }
    },
    resetSchedulingState() {
      this.isRescheduling = false;
      this.reschedulingInfo = null;
      this.showRescheduleModal = false;
      
      // Update URL to remove reschedule parameters
      this.$router.replace({
        name: 'Schedule',
        query: {}
      });
    },
    handleSchedule(programData) {
      // Reset scheduling state first to ensure modal works properly
      this.resetSchedulingState();
      
      // Check if this is a full program object or just program data with rescheduling info
      if (programData.reschedulingInfo) {
        // Store rescheduling information
        this.reschedulingInfo = programData.reschedulingInfo;
        this.isRescheduling = true;
        this.selectedProgram = programData.program;
        
        // Fetch availability data before showing the modal
        this.fetchDateAvailability(this.selectedProgram.id).then(() => {
          this.showRescheduleModal = true;
        });
      } else {
        // Regular scheduling (no rescheduling info provided)
        this.selectedProgram = programData;
        
        // Fetch availability data before showing the modal
        this.fetchDateAvailability(this.selectedProgram.id).then(() => {
          this.showScheduleModal = true;
        });
      }
    },
    async handleScheduleSubmit(formData) {
      try {
        // Store rescheduling info for later
        const isRescheduling = this.isRescheduling && this.reschedulingInfo;
        const originalAppointmentId = isRescheduling ? this.reschedulingInfo.originalAppointmentId : null;
        const originalAppointment = isRescheduling ? this.reschedulingInfo.originalAppointment : null;
        
        // Check if we have the complete data from the form
        if (!formData.serverModel && !isRescheduling) {
          console.error('Missing complete form data. The serverModel object is required.');
          throw new Error('Form data is incomplete. Please fill in all required fields.');
        }
        
        // Use serverModel from ApplicationFormStore if available (contains properly formatted data for API)
        let appointmentData;
        
        if (isRescheduling && originalAppointment) {
          // For rescheduling, use original appointment data but update date and time
          appointmentData = {
            ...originalAppointment,
            preferred_date: formData.preferredDate,
            time_slot: formData.timeSlot,
            is_rescheduled: true,
            status: 'waiting_for_test_details', // This status ensures it's in the admin's queue for assignment
            // Clear any previous test assignments
            test_session: null,
            test_center: null,
            test_room: null
          };
        } else if (formData.serverModel) {
          // For new appointments, use the complete serverModel object which matches API structure
          appointmentData = formData.serverModel;
          
          // Make sure the program ID is set correctly
          appointmentData.program = this.selectedProgram.id;
          
          // Ensure the appointment status is set to waiting_for_test_details
          appointmentData.status = 'waiting_for_test_details'; // Changed from 'pending'
        } else {
          // Fallback to constructing basic appointment data if serverModel is not available
          appointmentData = {
            // Required fields that must be present
            full_name: formData.fullName,
            contact_number: formData.contactNumber,
            email: formData.email,
            preferred_date: formData.preferredDate,
            time_slot: formData.timeSlot,
            program: this.selectedProgram.id,
            status: 'waiting_for_test_details',
            
            // Additional fields that should be included
            birth_month: formData.birthMonth || '',
            birth_day: formData.birthDay || '',
            birth_year: formData.birthYear || '',
            gender: formData.gender || '',
            age: formData.age ? parseInt(formData.age) : null,
            home_address: formData.homeAddress || '',
            citizenship: formData.citizenship || '',
            high_school_code: formData.highSchoolCode || '',
            
            // WMSUCET experience
            is_first_time: formData.wmsucetExperience?.firstTime || true,
            times_taken: formData.wmsucetExperience?.timesTaken ? parseInt(formData.wmsucetExperience.timesTaken) : 0,
            
            // Applicant type and school information
            applicant_type: formData.applicantType || '',
            school_name: formData.schoolName || '',
          };
          
          // Set additional fields based on applicant type
          if (formData.applicantType === 'senior_high_graduating' && formData.seniorGraduating) {
            appointmentData.school_name = formData.seniorGraduating.schoolName || '';
            appointmentData.school_address = formData.seniorGraduating.schoolAddress || '';
            appointmentData.school_graduation_date = formData.seniorGraduating.graduationDate || '';
          } 
          else if (formData.applicantType === 'senior_high_graduate' && formData.seniorGraduate) {
            appointmentData.school_name = formData.seniorGraduate.schoolName || '';
            appointmentData.school_address = formData.seniorGraduate.schoolAddress || '';
            appointmentData.school_graduation_date = formData.seniorGraduate.graduationDate || '';
          } 
          else if (formData.applicantType === 'college' && formData.college) {
            appointmentData.school_name = formData.college.schoolName || '';
            appointmentData.school_address = formData.college.schoolAddress || '';
            appointmentData.college_course = formData.college.course || '';
            appointmentData.college_type = formData.college.collegeType || '';
          }
        }

        // If we're rescheduling, try to update the original appointment to mark it appropriately
        let originalAppointmentUpdated = false;
        if (isRescheduling && originalAppointmentId) {
          try {
            // First try with admin_notes only (no status change) to avoid validation issues
            await axios.patch(`/api/appointments/${originalAppointmentId}/`, {
              admin_notes: 'This appointment has been cancelled due to a reschedule request. A new appointment is being created.'
            });
            
            // Then attempt to update the status separately - if this fails, we at least have the notes
            try {
              // Update to 'rescheduled' instead of 'cancelled' to trigger room capacity release
              await axios.patch(`/api/appointments/${originalAppointmentId}/`, {
                status: 'rescheduled'
              });
              console.log('Successfully marked original appointment as rescheduled');
              originalAppointmentUpdated = true;
            } catch (statusError) {
              console.warn('Could not update appointment status directly, continuing with the admin notes only:', statusError);
              // We continue the flow even with this error, as we have updated the admin notes
            }
          } catch (error) {
            console.error('Error updating original appointment:', error);
            if (error.response?.data) {
              console.error('Error details:', error.response.data);
            }
            // Continue with the flow even if this fails completely
          }
        }

        // Create the new appointment
        const response = await axios.post('/api/appointments/', appointmentData);
        
        // Convert ID to string when storing
        const newId = String(response.data.id);
        
        // Update the ApplicationFormStore with appointment ID for reference
        if (!isRescheduling) {
          // Get existing data and add the appointmentId
          const formData = ApplicationFormStore.state.formData;
          ApplicationFormStore.setFormData({
            ...formData,
            appointmentId: newId,
            serverResponse: response.data
          });
        }
        
        // If we're rescheduling and we haven't updated the original appointment fully yet, 
        // try again with a reference to the new appointment ID
        if (isRescheduling && originalAppointmentId && !originalAppointmentUpdated) {
          try {
            console.log('Making another attempt to update original appointment with reference to new ID:', originalAppointmentId);
            
            // Use a different approach - try using a reschedule_reference field that might exist
            const updatePayload = {
              admin_notes: `Cancelled due to reschedule. New appointment ID: ${newId}`
            };
            
            // Some APIs might accept specific fields for this purpose
            // Try these common fields that might be supported
            try {
              updatePayload.reschedule_reference = newId;
            } catch (e) { /* Ignore if this field is rejected */ }
            
            try {
              updatePayload.replacement_appointment_id = newId;
            } catch (e) { /* Ignore if this field is rejected */ }
            
            // Try the update with these fields
            await axios.patch(`/api/appointments/${originalAppointmentId}/`, updatePayload);
            console.log('Successfully updated original appointment with reference on second attempt');
          } catch (error) {
            console.error('Final attempt to update original appointment failed:', error);
            // At this point, we've done our best to update the original appointment
            // Continue with the flow regardless
          }
        }
        
        // Close the modal first to prevent UI jank
        this.showScheduleModal = false;
        
        // Reset rescheduling state
        this.isRescheduling = false;
        this.reschedulingInfo = null;
        
        // For rescheduling, we need to make sure we show the correct appointment
        if (isRescheduling) {
          // First refresh appointments to get the latest data
          await this.fetchUserAppointments();
          
          // Force a direct fetch of the new appointment to ensure we're showing the right one
          try {
            // Verify the appointment exists and is accessible
            const checkResponse = await axios.get(`/api/appointments/${newId}/`);
            
            // Set it directly in the local data structure
            if (!this.appointmentIds[this.selectedProgram.id]) {
              this.appointmentIds[this.selectedProgram.id] = [];
            }
            
            // Make sure this appointment ID is at the front of the array
            this.appointmentIds[this.selectedProgram.id] = 
              [newId, ...this.appointmentIds[this.selectedProgram.id].filter(id => id !== newId)];
            
            // Set a short timeout to ensure the UI has time to update
            setTimeout(() => {
              this.selectedAppointmentId = newId;
              this.showStatusModal = true;
              
              // Show a toast notification explaining what happens next
              const { showToast } = useToast();
              showToast('Your appointment has been rescheduled. Test details will be assigned by an administrator.', 'success', 5000);
            }, 100);
          } catch (error) {
            // Don't show the modal if there was an error
          }
        } else {
          // For regular appointments, just refresh the data
          await this.fetchUserAppointments();
          
          // Show simple success toast
          const { showToast } = useToast();
          showToast('Appointment scheduled successfully!', 'success', 5000);
        }
        
      } catch (error) {
        let errorMessage = 'Failed to schedule appointment. Please try again.';
        
        // Handle the duplicate appointment error specifically
        if (error.response?.data?.non_field_errors && 
            error.response.data.non_field_errors.includes('The fields email, program, preferred_date, time_slot must make a unique set.')) {
          // Provide a more user-friendly message
          errorMessage = 'You already have an appointment scheduled for this program on the selected date and time. ' +
                         'Please choose a different date or time slot.';
                          
          // If we were trying to reschedule, provide more context
          if (this.isRescheduling) {
            errorMessage = 'You cannot reschedule to the same date and time slot as your current appointment. ' +
                           'Please select a different date or time slot.';
          }
        } else if (error.response?.data?.error && 
            error.response.data.error.includes('A person with this name has already registered for this program')) {
          // Handle the duplicate name error
          errorMessage = 'Registration not allowed: A person with your name has already registered for this program. ' + 
                         'Each person can only register once per program, even with different accounts.';
        } else if (error.response?.data) {
          if (typeof error.response.data === 'string') {
            errorMessage = error.response.data;
          } else if (error.response.data.detail) {
            errorMessage = error.response.data.detail;
          } else if (error.response.data.message) {
            errorMessage = error.response.data.message;
          } else if (typeof error.response.data === 'object') {
            const fieldErrors = [];
            for (const field in error.response.data) {
              if (Object.hasOwnProperty.call(error.response.data, field)) {
                const errorDetails = error.response.data[field];
                // Skip the specific validation errors we want to remove
                if (field === 'full_name' || field === 'contact_number' || 
                    field === 'preferred_date' || field === 'time_slot') {
                  continue;
                }
                fieldErrors.push(`${field}: ${Array.isArray(errorDetails) ? errorDetails.join(', ') : errorDetails}`);
              }
            }
            if (fieldErrors.length > 0) {
              errorMessage = 'Validation errors: ' + fieldErrors.join('; ');
            } else {
              // If all errors were skipped, don't show any error message
              errorMessage = '';
            }
          }
        }
        
        // Only show toast if there's an error message
        if (errorMessage) {
          const { showToast } = useToast();
          showToast(errorMessage, 'error');
        }
        
        // Keep the modals open when we have validation errors
        if (this.showScheduleModal === false && !this.isRescheduling) {
          this.showScheduleModal = true;
        } else if (this.showRescheduleModal === false && this.isRescheduling) {
          this.showRescheduleModal = true;
        }
      } finally {
        // Always clear the rescheduling state if we're not keeping the modal open
        if (!this.showRescheduleModal) {
          this.resetSchedulingState();
        }
      }
    },
    async handleStatusCheck({ program }) {
      const ids = this.appointmentIds[program.id];
      if (!ids || ids.length === 0) {
        alert('Could not find appointment details.');
        return;
      }
      
      // Use the first appointment ID (which should be the newest active one)
      const latestId = ids[0];
      this.selectedAppointmentId = String(latestId);
      this.showStatusModal = true;
    },
    async fetchUserAppointments() {
      try {
        const response = await axios.get('/api/appointments/');
        
        // Initialize appointmentIds as an object with arrays
        this.appointmentIds = {};
        
        // Track which programs have only claimed appointments
        const claimedProgramIds = new Set();
        
        // Sort appointments by created_at date in descending order (newest first)
        const sortedAppointments = [...response.data].sort((a, b) => {
          if (a.created_at && b.created_at) {
            return new Date(b.created_at) - new Date(a.created_at);
          }
          return parseInt(b.id) - parseInt(a.id);
        });
        
        // Group appointments by program, separating by status
        const activeAppointmentsByProgram = {};
        const cancelledAppointmentsByProgram = {};
        const claimedAppointmentsByProgram = {};
        
        // First, separate active, claimed, and cancelled appointments by program
        sortedAppointments.forEach(appointment => {
          const programId = appointment.program;
          const appointmentId = String(appointment.id);
          
          // Track the program as scheduled regardless of status
          this.scheduledProgramIds.add(programId);
          
          // Separate by status
          if (appointment.status === 'cancelled') {
            if (!cancelledAppointmentsByProgram[programId]) {
              cancelledAppointmentsByProgram[programId] = [];
            }
            cancelledAppointmentsByProgram[programId].push(appointmentId);
          } 
          else if (appointment.status === 'claimed') {
            // Track claimed appointments separately
            if (!claimedAppointmentsByProgram[programId]) {
              claimedAppointmentsByProgram[programId] = [];
            }
            claimedAppointmentsByProgram[programId].push(appointmentId);
          }
          else {
            // Active appointments (pending, approved, rescheduled)
            if (!activeAppointmentsByProgram[programId]) {
              activeAppointmentsByProgram[programId] = [];
            }
            activeAppointmentsByProgram[programId].push(appointmentId);
          }
        });
        
        // For each program, determine which appointments to use
        for (const programId of this.scheduledProgramIds) {
          const activeAppointments = activeAppointmentsByProgram[programId] || [];
          const claimedAppointments = claimedAppointmentsByProgram[programId] || [];
          const cancelledAppointments = cancelledAppointmentsByProgram[programId] || [];
          
          if (activeAppointments.length > 0) {
            // If there are active appointments, use those
            this.appointmentIds[programId] = activeAppointments;
          } 
          else if (claimedAppointments.length > 0) {
            // If there are only claimed appointments, we'll allow creating a new one
            // But we'll still store the claimed appointment ID for reference
            this.appointmentIds[programId] = claimedAppointments;
            // Mark this program as having only claimed appointments
            claimedProgramIds.add(programId);
          }
          else {
            // If there are only cancelled appointments, use those
            this.appointmentIds[programId] = cancelledAppointments;
          }
        }
        
        // Store the set of programs with only claimed appointments
        this.claimedProgramIds = claimedProgramIds;
        
      } catch (error) {
        // Handle unauthorized errors
        if (error.response && error.response.status === 401) {
          // Redirect to login or logout the user
          AuthService.logout();
          this.$router.push('/login');
        }
      }
    },
    closeStatusModal() {
      this.showStatusModal = false;
      setTimeout(() => {
        this.selectedAppointmentId = null;
      }, 300); // Wait for animation to complete
    },
    async handleRescheduleRequest({ appointmentId, programId }) {
      // Set rescheduling mode
      this.isRescheduling = true;
      
      // Update URL to reflect rescheduling state without full page reload
      this.$router.replace({
        name: 'Schedule',
        query: { 
          reschedule: 'true', 
          appointmentId: appointmentId 
        }
      });
      
      // Fetch the original appointment details to pre-populate the form
      let originalAppointment = null;
      try {
        const response = await axios.get(`/api/appointments/${appointmentId}/`);
        originalAppointment = response.data;
        
        // Try to get program ID from the response if not provided
        if (!programId) {
          programId = originalAppointment.program || originalAppointment.program_id || null;
          
          if (programId) {
            console.log('Found program ID from appointment details:', programId);
          } else {
            console.log('Could not find program ID in appointment details');
          }
        }
      } catch (error) {
        console.error('Error fetching appointment details:', error);
        alert('Could not retrieve your appointment details. Please try again.');
        return;
      }
      
      // Store rescheduling information including the original appointment data
      this.reschedulingInfo = {
        isRescheduling: true,
        originalAppointmentId: appointmentId,
        originalAppointment: originalAppointment // Store the full appointment object
      };
      
      // If program ID is provided or was fetched successfully, we can pre-select that program
      if (programId) {
        // Convert to number if it's a string (API might return string ID)
        const programIdNum = typeof programId === 'string' ? parseInt(programId, 10) : programId;
        const program = this.programs.find(p => p.id === programIdNum);
        
        if (program) {
          console.log('Found matching program:', program.name);
          this.selectedProgram = program;
          this.showRescheduleModal = true; // Show reschedule modal instead
        } else {
          console.log('Program not found with ID:', programId);
          alert('Could not find the program for this appointment. Please select a program manually.');
        }
      } else {
        console.log('No program ID provided for rescheduling. User will need to select a program.');
        alert('Please select a program to reschedule your appointment.');
      }
    },
    // Add a method to fetch date availability based on program capacity
    async fetchDateAvailability(programId) {
      try {
        // Define the date range - from today to 6 months ahead
        const today = new Date();
        const endDate = new Date(today);
        endDate.setMonth(today.getMonth() + 6); // Look 6 months ahead
        
        // Format dates for API
        const startDateStr = this.formatDateForApi(today);
        const endDateStr = this.formatDateForApi(endDate);
        
        // Make the API call with the updated endpoint
        const response = await axios.get(`/api/programs/${programId}/availability/`, {
          params: {
            start_date: startDateStr,
            end_date: endDateStr
          }
        });
        
        // Store the availability data
        this.dateAvailability = response.data.availability || {};
        
        return this.dateAvailability;
      } catch (error) {
        // Add fallback behavior when the API fails
        console.log('Using fallback date availability (allowing all dates except Sundays)');
        
        // Create fallback data - allow all dates except Sundays
        const today = new Date();
        const fallbackAvailability = {};
        
        // Generate data for 180 days
        for (let i = 0; i < 180; i++) {
          const date = new Date(today);
          date.setDate(today.getDate() + i);
          
          // Skip Sundays (0 is Sunday in JavaScript's getDay())
          const isSunday = date.getDay() === 0;
          
          const dateStr = this.formatDateForApi(date);
          fallbackAvailability[dateStr] = {
            available: !isSunday,
            morning_available: !isSunday,
            afternoon_available: !isSunday,
            morning_count: 0,
            afternoon_count: 0,
            capacity: this.selectedProgram?.capacity_limit || 5
          };
        }
        
        this.dateAvailability = fallbackAvailability;
        return fallbackAvailability;
      }
    },
    
    // Helper to format date for API
    formatDateForApi(date) {
      const year = date.getFullYear();
      const month = String(date.getMonth() + 1).padStart(2, '0');
      const day = String(date.getDate()).padStart(2, '0');
      return `${year}-${month}-${day}`;
    },
    async fetchUserExamScores() {
      try {
        // Fetch user appointments with exam scores
        const response = await axios.get('/api/appointments/');
        
        // Initialize the user exam scores object
        this.userExamScores = {};
        
        // Process each appointment that has an exam score
        response.data.forEach(appointment => {
          if (appointment.status === 'claimed' && appointment.exam_score) {
            const programId = appointment.program;
            const programName = appointment.program_name;
            
            // Store the score
            this.userExamScores[programId] = {
              programName: programName,
              score: appointment.exam_score.score
            };
          }
        });
        
      } finally {
        // Always check program eligibility, even if there was an error fetching scores
        this.checkProgramEligibility();
      }
    },
    
    checkProgramEligibility() {
      // Initialize restricted programs
      this.restrictedPrograms = {};
      const { showToast } = useToast();
      
      // Find the College Entrance Exam program ID and NAT program ID
      const collegeEntranceProgram = this.programs.find(p => 
        p.name.toLowerCase().includes('college entrance') || 
        p.code.toLowerCase().includes('cee'));
      
      const natProgram = this.programs.find(p => 
        p.name.toLowerCase().includes('nursing aptitude test') || 
        p.code.toLowerCase().includes('nat'));
      
      if (!collegeEntranceProgram || !natProgram) {
        console.log('College Entrance Exam or NAT program not found');
        return;
      }
      
      const collegeEntranceProgramId = collegeEntranceProgram.id;
      const natProgramId = natProgram.id;
      
      // Check if the user has a score for the College Entrance Exam
      if (this.userExamScores[collegeEntranceProgramId]) {
        const score = this.userExamScores[collegeEntranceProgramId].score;
        const scoreValue = parseInt(score, 10);
        
        // If the score is below 90%, restrict NAT program
        if (!isNaN(scoreValue) && scoreValue < 90) {
          const restrictionReason = `Your College Entrance Exam score (${score}%) is below the required 90% to qualify for the Nursing Aptitude Test program.`;
          
          this.restrictedPrograms[natProgramId] = {
            reason: restrictionReason,
            requiredScore: 90,
            actualScore: scoreValue
          };
          
          // Show a toast notification for the restriction
          showToast(restrictionReason, 'warning', 8000); // Show for 8 seconds
          
          console.log(`User restricted from NAT program due to low score: ${score}%`);
        } else {
          console.log(`User eligible for NAT program with score: ${score}%`);
        }
      }
    },
    // Pagination methods
    async switchPage(newPage) {
      this.paginationLoading = true;
      this.currentPage = newPage;
      
      // Scroll to top of cards
      this.scrollToCards();
      
      // Increased delay for better UX
      await new Promise(resolve => setTimeout(resolve, 600));
      this.paginationLoading = false;
    },
    async nextPage() {
      if (this.currentPage < this.totalPages) {
        await this.switchPage(this.currentPage + 1);
      }
    },
    async prevPage() {
      if (this.currentPage > 1) {
        await this.switchPage(this.currentPage - 1);
      }
    },
    async goToPage(pageNumber) {
      if (pageNumber >= 1 && pageNumber <= this.totalPages) {
        await this.switchPage(pageNumber);
      }
    },
    scrollToCards() {
      // Smooth scroll to the top of the cards container
      const cardsContainer = document.querySelector('.container');
      if (cardsContainer) {
        cardsContainer.scrollIntoView({ behavior: 'smooth', block: 'start' });
      }
    }
  },
  computed: {
    activePrograms() {
      return this.programs.filter(program => program.status === 'active')
    },
    // Add computed property for paginated programs
    paginatedPrograms() {
      const start = (this.currentPage - 1) * this.itemsPerPage;
      const end = start + this.itemsPerPage;
      return this.activePrograms.slice(start, end);
    },
    // Add computed property for total pages
    totalPages() {
      return Math.ceil(this.activePrograms.length / this.itemsPerPage);
    },
    startEntry() {
      return this.activePrograms.length > 0 ? ((this.currentPage - 1) * this.itemsPerPage) + 1 : 0
    },
    
    endEntry() {
      return Math.min(this.currentPage * this.itemsPerPage, this.activePrograms.length)
    },
    
    paginationItems() {
      // For small number of pages, show all
      if (this.totalPages <= 7) {
        return Array.from({ length: this.totalPages }, (_, i) => i + 1)
      }
      
      // For large number of pages, show limited range with ellipses
      const items = []
      
      // Always show first page
      items.push(1)
      
      // Show ellipsis if needed
      if (this.currentPage > 3) {
        items.push('...')
      }
      
      // Calculate range around current page
      let rangeStart = Math.max(2, this.currentPage - 1)
      let rangeEnd = Math.min(this.totalPages - 1, this.currentPage + 1)
      
      // Adjust range to show at least 3 pages when possible
      if (this.currentPage <= 3) {
        rangeEnd = Math.min(4, this.totalPages - 1)
      }
      if (this.currentPage >= this.totalPages - 2) {
        rangeStart = Math.max(2, this.totalPages - 3)
      }
      
      // Add range pages
      for (let i = rangeStart; i <= rangeEnd; i++) {
        items.push(i)
      }
      
      // Show ellipsis if needed
      if (this.currentPage < this.totalPages - 2) {
        items.push('...')
      }
      
      // Always show last page
      if (this.totalPages > 1) {
        items.push(this.totalPages)
      }
      
      return items
    }
  }
}
</script>

<style scoped>
/* Add smooth transitions for pagination */
.grid {
  transition: opacity 0.3s ease;
}
</style>