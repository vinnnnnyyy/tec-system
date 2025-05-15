<template>
  <div v-if="show" class="fixed inset-0 z-50 overflow-y-auto" aria-labelledby="modal-title" role="dialog" aria-modal="true">
    <!-- Backdrop -->
    <div class="fixed inset-0 bg-black bg-opacity-50 backdrop-blur-sm transition-opacity" @click="$emit('close')"></div>

    <!-- Modal Container -->
    <div class="flex min-h-screen items-center justify-center p-4">
      <div class="relative w-full max-w-4xl rounded-lg bg-white shadow-2xl transform transition-all">
        <!-- Modal Header -->
        <div class="flex items-start justify-between p-6 border-b border-gray-100">
          <div class="space-y-1">
            <h2 class="text-2xl font-bold text-gray-900">
              Appointment Details
            </h2>
            <p class="text-sm text-gray-500">
              ID: #{{ appointment.id }}
            </p>
          </div>
          
          <!-- Status Badge -->
          <div class="flex items-center space-x-4">
            <span :class="getStatusClass()">
              {{ formatStatus(appointment.status) }}
            </span>
            <button @click="$emit('close')" class="text-gray-400 hover:text-gray-500">
              <span class="sr-only">Close</span>
              <i class="fas fa-times text-xl"></i>
            </button>
          </div>
        </div>

        <!-- Quick Actions Bar -->
        <div class="bg-gray-50 px-6 py-3 flex items-center justify-between border-b border-gray-100">
          <div class="flex items-center space-x-4">
            <div class="flex items-center space-x-2 text-sm text-gray-500">
              <i class="fas fa-calendar"></i>
              <span>{{ formatDate(appointment.date) }}</span>
            </div>
            <div class="flex items-center space-x-2 text-sm text-gray-500">
              <i class="fas fa-clock"></i>
              <span>{{ appointment.time }}</span>
            </div>
          </div>
          <div class="flex items-center space-x-3">
            <button v-if="appointment.status === 'pending'"
                    @click="$emit('approve', appointment)"
                    class="button button-success">
              <i class="fas fa-check mr-2"></i>
              Approve
            </button>
            <button v-if="appointment.status === 'pending'"
                    @click="$emit('reject', appointment)"
                    class="button button-danger">
              <i class="fas fa-times mr-2"></i>
              Reject
            </button>
            <button v-if="appointment.status === 'approved'"
                    @click="$emit('claim', appointment)"
                    class="button button-primary">
              <i class="fas fa-clipboard-check mr-2"></i>
              Mark as Claimed
            </button>
            <button v-if="appointment.status !== 'claimed' && appointment.status !== 'pending'"
                    @click="$emit('reschedule', appointment)"
                    class="button button-warning">
              <i class="fas fa-calendar-alt mr-2"></i>
              Reschedule
            </button>
          </div>
        </div>

        <!-- Content Area -->
        <div class="p-6">
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
                    {{ appointment.applicantName }}
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
                    {{ appointment.contact }}
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
                    {{ appointment.program }}
                  </p>
                </div>
                <div>
                  <label class="text-xs font-medium text-gray-500">School</label>
                  <p class="mt-1 text-sm font-medium text-gray-900">
                    {{ appointment.school }}
                  </p>
                </div>
                <div v-if="appointment.fullDetails?.school_address">
                  <label class="text-xs font-medium text-gray-500">School Address</label>
                  <p class="mt-1 text-sm font-medium text-gray-900">
                    {{ appointment.fullDetails.school_address }}
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
                    {{ formatTimeSlot(appointment.fullDetails?.time_slot) }}
                  </p>
                </div>
                
                <div v-if="appointment.fullDetails?.test_session">
                  <label class="text-xs font-medium text-gray-500">Assigned Test Time Slot</label>
                  <div class="mt-1 flex items-center">
                    <p class="text-sm font-medium" 
                       :class="timeSlotsMatch ? 'text-gray-900' : 'text-orange-600'">
                      {{ formatTimeSlot(appointment.fullDetails?.assigned_test_time_slot) || 'Same as preferred' }}
                    </p>
                    <i v-if="!timeSlotsMatch" 
                       class="fas fa-exclamation-triangle text-orange-500 ml-2" 
                       title="Assigned time slot differs from preferred time"></i>
                  </div>
                </div>
                
                <div v-if="appointment.fullDetails?.test_session">
                  <label class="text-xs font-medium text-gray-500">Test Session</label>
                  <p class="mt-1 text-sm font-medium text-gray-900">
                    {{ appointment.fullDetails?.test_session_date ? formatDate(appointment.fullDetails.test_session_date) : 'Not assigned' }}
                  </p>
                </div>
                
                <div v-if="appointment.fullDetails?.test_center_name">
                  <label class="text-xs font-medium text-gray-500">Test Center</label>
                  <p class="mt-1 text-sm font-medium text-gray-900">
                    {{ appointment.fullDetails.test_center_name }}
                  </p>
                </div>
                
                <div v-if="appointment.fullDetails?.test_room_name">
                  <label class="text-xs font-medium text-gray-500">Test Room</label>
                  <p class="mt-1 text-sm font-medium text-gray-900">
                    {{ appointment.fullDetails.test_room_name }}
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
                      {{ formatBirthDate(appointment.fullDetails) }}
                    </p>
                  </div>
                  <div>
                    <label class="text-xs font-medium text-gray-500">Gender</label>
                    <p class="mt-1 text-sm font-medium text-gray-900">
                      {{ formatGender(appointment.fullDetails?.gender) }}
                    </p>
                  </div>
                  <div>
                    <label class="text-xs font-medium text-gray-500">Age</label>
                    <p class="mt-1 text-sm font-medium text-gray-900">
                      {{ appointment.fullDetails?.age || 'N/A' }}
                    </p>
                  </div>
                  <div class="md:col-span-2 lg:col-span-3">
                    <label class="text-xs font-medium text-gray-500">Home Address</label>
                    <p class="mt-1 text-sm font-medium text-gray-900">
                      {{ appointment.fullDetails?.home_address || 'N/A' }}
                    </p>
                  </div>
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
export default {
  name: 'AppointmentDetailsModal',
  props: {
    show: {
      type: Boolean,
      default: false
    },
    appointment: {
      type: Object,
      default: null
    }
  },
  computed: {
    timeSlotsMatch() {
      if (!this.appointment.fullDetails) return true;
      
      // If assigned test time slot is not set, they match by default
      if (!this.appointment.fullDetails.assigned_test_time_slot) return true;
      
      // Compare preferred time slot with assigned test time slot
      return this.appointment.fullDetails.time_slot === this.appointment.fullDetails.assigned_test_time_slot;
    }
  },
  methods: {
    formatStatus(status) {
      if (!status) return '';
      
      // Convert underscores to spaces and capitalize each word
      return status.split('_')
        .map(word => word.charAt(0).toUpperCase() + word.slice(1))
        .join(' ');
    },
    getStatusClass() {
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
      return `${baseClasses} ${statusClasses[this.appointment.status] || ''}`;
    },
    formatDate(date) {
      return new Date(date).toLocaleDateString('en-US', {
        weekday: 'long',
        year: 'numeric',
        month: 'long',
        day: 'numeric'
      });
    },
    formatTimeSlot(slot) {
      if (!slot) return 'Not specified';
      
      if (slot === 'morning') {
        return 'Morning (8:00 AM - 12:00 PM)';
      } else if (slot === 'afternoon') {
        return 'Afternoon (1:00 PM - 5:00 PM)';
      }
      
      return slot;
    },
    formatBirthDate(details) {
      if (!details) return 'N/A';
      const { birth_month, birth_day, birth_year } = details;
      if (!birth_month || !birth_day || !birth_year) return 'N/A';
      return new Date(birth_year, birth_month - 1, birth_day).toLocaleDateString('en-US', {
        year: 'numeric',
        month: 'long',
        day: 'numeric'
      });
    },
    formatGender(gender) {
      if (!gender) return 'N/A';
      return gender.charAt(0).toUpperCase() + gender.slice(1);
    },
    formatApplicantType(type) {
      if (!type) return 'N/A';
      const typeMap = {
        'senior_high_graduating': 'Senior High School Graduating Student',
        'senior_high_graduate': 'Senior High School Graduate',
        'college': 'College Student'
      };
      return typeMap[type] || type;
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

/* Transition for modal */
.backdrop-blur-sm {
  backdrop-filter: blur(4px);
}

/* Animation for modal */
.transform {
  transform-origin: center;
  transition-property: opacity, transform;
  transition-timing-function: cubic-bezier(0.4, 0, 0.2, 1);
  transition-duration: 150ms;
}
</style> 