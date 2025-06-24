<template>
  <main class="flex-1 overflow-y-auto bg-gray-50 p-6">
    <!-- Page Header -->
    <header class="bg-white shadow-sm rounded-lg mb-6">
      <div class="flex justify-between items-center p-6">
        <div class="flex items-center space-x-4">
          <button @click="goBack" class="p-2 bg-gray-100 hover:bg-gray-200 rounded-full transition-all">
            <i class="fas fa-arrow-left text-gray-600"></i>
          </button>
          <div class="space-y-1">
            <h1 class="text-2xl font-bold text-gray-800">Appointment Details</h1>
            <p class="text-sm text-gray-500" v-if="appointment">ID: #{{ appointment.id }}</p>
          </div>
        </div>
        
        <!-- Status Badge -->
        <div class="flex items-center space-x-4" v-if="appointment">
          <span :class="getStatusClass()">
            {{ formatStatus(appointment.status) }}
          </span>
        </div>
      </div>
    </header>

    <!-- Loading Indicator -->
    <div v-if="loading" class="flex justify-center items-center py-20">
      <div class="spinner-border text-primary" role="status">
        <i class="fas fa-circle-notch fa-spin text-4xl text-crimson-600"></i>
      </div>
    </div>

    <!-- Error Message -->
    <div v-else-if="error" class="bg-red-50 rounded-lg p-6 text-center">
      <i class="fas fa-exclamation-circle text-3xl text-red-500 mb-2"></i>
      <h2 class="text-lg font-medium text-red-800 mb-2">Error Loading Details</h2>
      <p class="text-red-600">{{ error }}</p>
      <button @click="goBack" class="mt-4 px-4 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700 transition-colors">
        Go Back
      </button>
    </div>

    <!-- Content Area -->
    <div v-else-if="appointment" class="space-y-6">
      <!-- Quick Actions Bar -->
      <div class="bg-white rounded-lg shadow-sm p-4">
        <div class="flex flex-wrap items-center justify-between gap-4">
          <div class="flex flex-wrap items-center gap-4">
            <div class="flex items-center space-x-2 text-sm text-gray-500">
              <i class="fas fa-calendar"></i>
              <span>{{ formatDate(appointment.preferred_date) }}</span>
            </div>
            <div class="flex items-center space-x-2 text-sm text-gray-500">
              <i class="fas fa-clock"></i>
              <span>{{ formatTimeSlot(appointment.assigned_test_time_slot || appointment.time_slot) }}</span>
            </div>
          </div>
          <div class="flex flex-wrap items-center gap-3">            <button v-if="canApprove()"
                    @click="approveAppointment"
                    class="button button-success">
              <i class="fas fa-check mr-2"></i>
              Set Waiting for Submission
            </button>
            <button v-if="canReject()"
                    @click="rejectAppointment"
                    class="button button-danger">
              <i class="fas fa-times mr-2"></i>
              Reject
            </button>
            <button v-if="canMarkClaimed()"
                    @click="markAsClaimed"
                    class="button button-primary">
              <i class="fas fa-clipboard-check mr-2"></i>
              Mark as Claimed
            </button>
            <button v-if="canReschedule()"
                    @click="rescheduleAppointment"
                    class="button button-warning">
              <i class="fas fa-calendar-alt mr-2"></i>
              Reschedule
            </button>
          </div>
        </div>
      </div>

      <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <!-- Applicant Information -->
        <div class="bg-white rounded-lg border border-gray-200 shadow-sm">
          <div class="p-4 border-b border-gray-100">
            <h3 class="text-lg font-semibold text-gray-900 flex items-center">
              <i class="fas fa-user text-blue-500 mr-2"></i>
              Applicant Information
            </h3>
          </div>
          <div class="p-4 space-y-4">
            <div>
              <label class="text-xs font-medium text-gray-500">Full Name</label>
              <p class="mt-1 text-sm font-medium text-gray-900">
                {{ appointment.full_name }}
              </p>
            </div>
            <div>
              <label class="text-xs font-medium text-gray-500">Email</label>
              <p class="mt-1 text-sm font-medium text-gray-900 flex items-center">
                <i class="fas fa-envelope text-gray-400 mr-2"></i>
                {{ appointment.email }}
              </p>
            </div>
            <div>
              <label class="text-xs font-medium text-gray-500">Contact</label>
              <p class="mt-1 text-sm font-medium text-gray-900 flex items-center">
                <i class="fas fa-phone text-gray-400 mr-2"></i>
                {{ appointment.contact_number }}
              </p>
            </div>
          </div>
        </div>

        <!-- Program Details -->
        <div class="bg-white rounded-lg border border-gray-200 shadow-sm">
          <div class="p-4 border-b border-gray-100">
            <h3 class="text-lg font-semibold text-gray-900 flex items-center">
              <i class="fas fa-graduation-cap text-green-500 mr-2"></i>
              Program Details
            </h3>
          </div>
          <div class="p-4 space-y-4">
            <div>
              <label class="text-xs font-medium text-gray-500">Program</label>
              <p class="mt-1 text-sm font-medium text-gray-900">
                {{ appointment.program_name }}
              </p>
            </div>
            <div>
              <label class="text-xs font-medium text-gray-500">School</label>
              <p class="mt-1 text-sm font-medium text-gray-900">
                {{ appointment.school_name }}
              </p>
            </div>
            <div v-if="appointment.school_address">
              <label class="text-xs font-medium text-gray-500">School Address</label>
              <p class="mt-1 text-sm font-medium text-gray-900">
                {{ appointment.school_address }}
              </p>
            </div>
          </div>
        </div>

        <!-- Test Schedule Details -->
        <div class="bg-white rounded-lg border border-gray-200 shadow-sm">
          <div class="p-4 border-b border-gray-100">
            <h3 class="text-lg font-semibold text-gray-900 flex items-center">
              <i class="fas fa-calendar-check text-purple-500 mr-2"></i>
              Test Schedule Details
            </h3>
          </div>
          <div class="p-4 space-y-4">
            <div>
              <label class="text-xs font-medium text-gray-500">Preferred Time Slot</label>
              <p class="mt-1 text-sm font-medium text-gray-900">
                {{ formatTimeSlot(appointment.time_slot) }}
              </p>
            </div>
            
            <div v-if="appointment.assigned_test_time_slot">
              <label class="text-xs font-medium text-gray-500">Assigned Test Time Slot</label>
              <div class="mt-1 flex items-center">
                <p class="text-sm font-medium" 
                   :class="timeSlotsMatch ? 'text-gray-900' : 'text-orange-600'">
                  {{ formatTimeSlot(appointment.assigned_test_time_slot) || 'Same as preferred' }}
                </p>
                <i v-if="!timeSlotsMatch" 
                   class="fas fa-exclamation-triangle text-orange-500 ml-2" 
                   title="Assigned time slot differs from preferred time"></i>
              </div>
            </div>
            
            <div v-if="testDetails.test_session">
              <label class="text-xs font-medium text-gray-500">Test Session</label>
              <p class="mt-1 text-sm font-medium text-gray-900">
                {{ testDetails.test_session.exam_date ? formatDate(testDetails.test_session.exam_date) : 'Not assigned' }}
              </p>
            </div>
            
            <div v-if="testDetails.test_center">
              <label class="text-xs font-medium text-gray-500">Test Center</label>
              <p class="mt-1 text-sm font-medium text-gray-900">
                {{ testDetails.test_center.name || testDetails.test_center.center_name }}
              </p>
            </div>
            
            <div v-if="testDetails.test_room">
              <label class="text-xs font-medium text-gray-500">Test Room</label>
              <p class="mt-1 text-sm font-medium text-gray-900">
                {{ testDetails.test_room.name || testDetails.test_room.room_name || testDetails.test_room.number }}
              </p>
            </div>
          </div>
        </div>
      </div>

      <!-- Personal Information Section -->
      <div class="mt-6">
        <div class="bg-white rounded-lg border border-gray-200 shadow-sm">
          <div class="p-4 border-b border-gray-100">
            <h3 class="text-lg font-semibold text-gray-900 flex items-center">
              <i class="fas fa-user-circle text-indigo-500 mr-2"></i>
              Personal Information
            </h3>
          </div>
          <div class="p-4">
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
              <div>
                <label class="text-xs font-medium text-gray-500">Date of Birth</label>
                <p class="mt-1 text-sm font-medium text-gray-900">
                  {{ formatBirthDate() }}
                </p>
              </div>
              <div>
                <label class="text-xs font-medium text-gray-500">Gender</label>
                <p class="mt-1 text-sm font-medium text-gray-900">
                  {{ formatGender(appointment.gender) }}
                </p>
              </div>
              <div>
                <label class="text-xs font-medium text-gray-500">Age</label>
                <p class="mt-1 text-sm font-medium text-gray-900">
                  {{ appointment.age || 'N/A' }}
                </p>
              </div>
              <div class="md:col-span-2 lg:col-span-3">
                <label class="text-xs font-medium text-gray-500">Home Address</label>
                <p class="mt-1 text-sm font-medium text-gray-900">
                  {{ appointment.home_address || 'N/A' }}
                </p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- No Data State -->
    <div v-else class="bg-white rounded-lg p-8 text-center shadow-sm">
      <i class="fas fa-calendar-times text-4xl text-gray-400 mb-2"></i>
      <h2 class="text-lg font-medium text-gray-700 mb-2">Appointment Not Found</h2>
      <p class="text-gray-500 mb-4">The appointment you're looking for could not be found or has been deleted.</p>
      <button @click="goBack" class="px-4 py-2 bg-crimson-600 text-white rounded-lg hover:bg-crimson-700 transition-colors">
        Return to Appointments
      </button>
    </div>
  </main>
</template>

<script>
import { ref, computed, onMounted } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import axiosInstance from '../../../services/axios.interceptor'
import { useToast } from '../../../composables/useToast'

export default {
  name: 'AppointmentDetails',
  props: {
    id: {
      type: [Number, String],
      required: false
    }
  },
  setup(props) {
    const router = useRouter()
    const route = useRoute()
    const { showToast } = useToast()
    
    // Use either prop or route param for ID
    const appointmentId = computed(() => props.id || route.params.id)
    
    // State
    const appointment = ref(null)
    const testDetails = ref({})
    const loading = ref(true)
    const error = ref(null)
    
    // Computed
    const timeSlotsMatch = computed(() => {
      if (!appointment.value) return true;
      
      // If assigned test time slot is not set, they match by default
      if (!appointment.value.assigned_test_time_slot) return true;
      
      // Compare preferred time slot with assigned test time slot
      return appointment.value.time_slot === appointment.value.assigned_test_time_slot;
    })
    
    // Methods
    const fetchAppointmentDetails = async () => {
      loading.value = true
      error.value = null
      
      try {
        // Fetch main appointment data
        const response = await axiosInstance.get(`/api/appointments/${appointmentId.value}/`)
        appointment.value = response.data
        
        // Fetch test details if the appointment is assigned
        if (appointment.value.status === 'waiting_for_submission' || 
            appointment.value.status === 'submitted' ||
            appointment.value.status === 'claimed') {
          try {
            const testDetailsResponse = await axiosInstance.get(`/api/appointments/${appointmentId.value}/test-details/`)
            testDetails.value = testDetailsResponse.data
            console.log('Test details loaded:', testDetails.value)
          } catch (err) {
            console.error('Failed to load test details:', err)
          }
        }
      } catch (err) {
        console.error('Error fetching appointment:', err)
        error.value = err.response?.data?.error || 'Failed to load appointment details'
      } finally {
        loading.value = false
      }
    }
    
    const goBack = () => {
      router.push('/admin/appointments')
    }
    
    // Status actions
    const canApprove = () => {
      return appointment.value?.status === 'waiting_for_test_details' || 
             appointment.value?.status === 'pending'
    }
    
    const canReject = () => {
      return appointment.value?.status === 'waiting_for_test_details' || 
             appointment.value?.status === 'pending'
    }
      const canMarkClaimed = () => {
      return appointment.value?.status === 'submitted' || 
             appointment.value?.status === 'approved' ||
             appointment.value?.status === 'waiting_for_submission'
    }
    
    const canReschedule = () => {
      return appointment.value?.status !== 'claimed' && 
             appointment.value?.status !== 'pending'
    }
      const approveAppointment = async () => {
      try {
        await axiosInstance.post('/api/admin/applications/batch-verify/', {
          application_ids: [appointmentId.value],
          action: 'waiting_for_submission'
        })
        
        showToast('Appointment set to waiting for submission', 'success')
        fetchAppointmentDetails()
      } catch (err) {
        showToast('Failed to update appointment status', 'error')
        console.error('Error updating appointment status:', err)
      }
    }
    
    const rejectAppointment = async () => {
      try {
        await axiosInstance.post('/api/admin/applications/batch-verify/', {
          application_ids: [appointmentId.value],
          action: 'reject'
        })
        
        showToast('Appointment rejected', 'success')
        fetchAppointmentDetails()
      } catch (err) {
        showToast('Failed to reject appointment', 'error')
        console.error('Error rejecting appointment:', err)
      }
    }
    
    const markAsClaimed = async () => {
      try {
        await axiosInstance.post('/api/admin/update-appointment-status/', {
          appointment_ids: [appointmentId.value],
          new_status: 'claimed'
        })
        
        showToast('Appointment marked as claimed', 'success')
        fetchAppointmentDetails()
      } catch (err) {
        showToast('Failed to update status', 'error')
        console.error('Error updating status:', err)
      }
    }
    
    const rescheduleAppointment = async () => {
      try {
        await axiosInstance.post('/api/admin/update-appointment-status/', {
          appointment_ids: [appointmentId.value],
          new_status: 'rescheduled'
        })
        
        showToast('Appointment marked for rescheduling', 'success')
        fetchAppointmentDetails()
      } catch (err) {
        showToast('Failed to reschedule appointment', 'error')
        console.error('Error rescheduling appointment:', err)
      }
    }
    
    // Formatting functions
    const formatStatus = (status) => {
      if (!status) return '';
      
      const statusMap = {
        'waiting_for_test_details': 'Waiting for Test Details',
        'waiting_for_submission': 'Waiting for Submission',
        'rejected': 'Rejected',
        'claimed': 'Claimed',
        'rescheduled': 'Rescheduled',
        'submitted': 'Submitted',
        'approved': 'Approved'
      };
      
      return statusMap[status] || status.split('_')
        .map(word => word.charAt(0).toUpperCase() + word.slice(1))
        .join(' ');
    }
    
    const getStatusClass = () => {
      const baseClasses = 'px-3 py-1 text-sm font-medium rounded-full';
      const statusClasses = {
        pending: 'bg-yellow-100 text-yellow-800',
        approved: 'bg-green-100 text-green-800',
        rejected: 'bg-red-100 text-red-800',
        claimed: 'bg-blue-100 text-blue-800',
        rescheduled: 'bg-purple-100 text-purple-800',
        waiting_for_test_details: 'bg-indigo-100 text-indigo-800',
        waiting_for_submission: 'bg-teal-100 text-teal-800'
      };
      return `${baseClasses} ${statusClasses[appointment.value?.status] || ''}`;
    }
    
    const formatDate = (date) => {
      if (!date) return 'Not specified';
      return new Date(date).toLocaleDateString('en-US', {
        weekday: 'long',
        year: 'numeric',
        month: 'long',
        day: 'numeric'
      });
    }
    
    const formatTimeSlot = (slot) => {
      if (!slot) return 'Not specified';
      
      if (slot === 'morning') {
        return 'Morning (8:00 AM - 12:00 PM)';
      } else if (slot === 'afternoon') {
        return 'Afternoon (1:00 PM - 5:00 PM)';
      }
      
      return slot;
    }
    
    const formatBirthDate = () => {
      if (!appointment.value) return 'N/A';
      const { birth_month, birth_day, birth_year } = appointment.value;
      if (!birth_month || !birth_day || !birth_year) return 'N/A';
      return new Date(birth_year, birth_month - 1, birth_day).toLocaleDateString('en-US', {
        year: 'numeric',
        month: 'long',
        day: 'numeric'
      });
    }
    
    const formatGender = (gender) => {
      if (!gender) return 'N/A';
      return gender.charAt(0).toUpperCase() + gender.slice(1);
    }
    
    // Lifecycle hooks
    onMounted(() => {
      if (appointmentId.value) {
        fetchAppointmentDetails()
      } else {
        error.value = 'No appointment ID provided'
        loading.value = false
      }
    })
    
    return {
      appointment,
      testDetails,
      loading,
      error,
      timeSlotsMatch,
      fetchAppointmentDetails,
      goBack,
      formatStatus,
      getStatusClass,
      formatDate,
      formatTimeSlot,
      formatBirthDate,
      formatGender,
      canApprove,
      canReject,
      canMarkClaimed,
      canReschedule,
      approveAppointment,
      rejectAppointment,
      markAsClaimed,
      rescheduleAppointment
    }
  }
}
</script>

<style scoped>
.button {
  display: inline-flex;
  align-items: center;
  padding: 0.5rem 1rem;
  font-size: 0.875rem;
  font-weight: 500;
  border-radius: 0.375rem;
  transition: all 0.2s;
}

.button-primary {
  color: white;
  background-color: #4F46E5;
  border: 1px solid transparent;
}

.button-primary:hover {
  background-color: #4338CA;
}

.button-success {
  color: white;
  background-color: #059669;
  border: 1px solid transparent;
}

.button-success:hover {
  background-color: #047857;
}

.button-danger {
  color: white;
  background-color: #DC2626;
  border: 1px solid transparent;
}

.button-danger:hover {
  background-color: #B91C1C;
}

.button-warning {
  color: white;
  background-color: #D97706;
  border: 1px solid transparent;
}

.button-warning:hover {
  background-color: #B45309;
}
</style>