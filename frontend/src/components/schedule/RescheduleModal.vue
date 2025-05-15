<template>
  <div>
    <!-- Modal Backdrop with Transition -->
    <transition name="backdrop-fade">
      <div v-if="modelValue"
           class="fixed inset-0 bg-black bg-opacity-50"
           @click="$emit('update:modelValue', false)">
      </div>
    </transition>

    <!-- Modal Content with Transition -->
    <transition name="modal-pop">
      <div v-if="modelValue"
           class="fixed inset-0 items-center justify-center z-50 flex"
           style="perspective: 1000px;">
        <div class="bg-white p-4 md:p-6 rounded-xl shadow-xl w-full max-w-md mx-2 md:mx-auto my-4 md:my-0 overflow-y-auto max-h-[90vh]">
          <div class="flex justify-between items-center mb-4">
            <h3 class="text-lg md:text-xl font-bold text-gray-900">
              Reschedule Your Appointment
            </h3>
            <button @click="$emit('update:modelValue', false)" class="text-gray-400 hover:text-gray-500">
              <i class="fas fa-times text-xl"></i>
            </button>
          </div>
          
          <!-- Rescheduling notice -->
          <div class="mb-4 bg-purple-50 border-l-4 border-purple-500 p-4">
            <div class="flex">
              <div class="flex-shrink-0">
                <i class="fas fa-calendar-alt text-purple-500"></i>
              </div>
              <div class="ml-3">
                <p class="text-sm text-purple-700">
                  <span class="font-medium">You are rescheduling your appointment.</span> Your personal information will be kept the same. Please select a new date and time.
                </p>
              </div>
            </div>
          </div>
          
          <!-- Original appointment summary -->
          <div class="mb-5 bg-gray-50 p-4 rounded-lg">
            <h4 class="font-medium text-gray-700 mb-2 text-sm">Original Appointment Details</h4>
            <div class="grid grid-cols-2 gap-3">
              <div>
                <p class="text-xs text-gray-500">Program</p>
                <p class="text-sm font-medium">{{ program?.name || 'N/A' }}</p>
              </div>
              <div>
                <p class="text-xs text-gray-500">Name</p>
                <p class="text-sm font-medium text-gray-700">{{ originalAppointment?.full_name || 'N/A' }}</p>
              </div>
              <div>
                <p class="text-xs text-gray-500">Date</p>
                <p class="text-sm font-medium">{{ formatDate(originalAppointment?.preferred_date) }}</p>
              </div>
              <div>
                <p class="text-xs text-gray-500">Time</p>
                <p class="text-sm font-medium">{{ formatTimeSlot(originalAppointment?.time_slot) }}</p>
              </div>
            </div>
          </div>
          
          <form @submit.prevent.stop="submitForm" class="space-y-5">
            <!-- New date and time -->
            <div class="space-y-4">
              <h4 class="font-medium text-gray-900">New Schedule Details</h4>
              <div class="space-y-2">
                <label class="block text-sm font-medium text-gray-700">Preferred Date</label>
                <div class="relative">
                  <!-- Calendar component -->
                  <div v-if="showCalendar" class="absolute top-full left-0 right-0 mt-1 bg-white shadow-lg rounded-lg z-10 p-3 border border-gray-200 calendar-container" @click.stop>
                    <CustomCalendar 
                      v-model="formData.preferredDate" 
                      v-model:timeSlotValue="formData.timeSlot"
                      :dateAvailability="enhancedDateAvailability"
                      @time-slot-selected="closeCalendarWithDelay"
                    />
                  </div>
                  
                  <!-- Date display field -->
                  <div 
                    @click="toggleCalendar"
                    data-calendar-trigger
                    class="w-full px-4 py-3 border rounded-lg flex justify-between items-center cursor-pointer transition-all border-gray-300 hover:border-crimson-500"
                  >
                    <span v-if="formData.preferredDate">{{ formatDate(formData.preferredDate) }}</span>
                    <span v-else class="text-gray-500">Select a date</span>
                    <i class="fas fa-calendar-alt text-gray-400"></i>
                  </div>
                  
                  <!-- Error message -->
                  <div v-if="dateError" class="text-red-500 text-xs mt-1">
                    {{ dateError }}
                  </div>
                </div>
              </div>
              <div class="space-y-1">
                <!-- Only show selected time slot display, removing the capacity bars from here -->
                <div v-if="formData.preferredDate && formData.timeSlot" class="mt-2 px-3 py-2 bg-gray-50 border border-gray-200 rounded-md text-sm">
                  Selected: <span class="font-medium">{{ formatTimeSlot(formData.timeSlot) }}</span>
                  <button 
                    type="button" 
                    @click="formData.timeSlot = ''" 
                    class="ml-2 text-gray-500 hover:text-crimson-600"
                    title="Change time slot"
                  >
                    <i class="fas fa-times"></i>
                  </button>
                </div>
              </div>
            </div>

            <!-- Form Submit Button -->
            <div class="flex justify-end mt-6 pt-3 border-t border-gray-100">
              <button 
                type="button"
                @click="$emit('update:modelValue', false)"
                class="mr-3 px-4 py-2 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50"
              >
                Cancel
              </button>
              <button 
                type="submit" 
                class="bg-crimson-600 hover:bg-crimson-700 text-white py-2 px-4 rounded-lg transition-all duration-300 flex justify-center items-center focus:outline-none">
                <i class="fas fa-calendar-check mr-2"></i>
                <span>Confirm Reschedule</span>
              </button>
            </div>
          </form>
        </div>
      </div>
    </transition>
    
    <!-- Confirmation Modal -->
    <Teleport to="body">
      <transition name="modal">
        <div v-if="showConfirmation" class="fixed inset-0 z-50 flex items-center justify-center">
          <div class="fixed inset-0 bg-black bg-opacity-50" @click="showConfirmation = false"></div>
          <div class="bg-white rounded-xl p-6 shadow-xl max-w-md mx-auto relative z-10">
            <div class="text-center">
              <i class="fas fa-calendar-check text-3xl text-crimson-500 mb-3"></i>
              <h3 class="text-lg font-semibold text-gray-900 mb-1">
                Confirm Rescheduling
              </h3>
              <p class="text-gray-600 mb-4 text-sm">
                Your previous appointment will be cancelled and replaced with this new schedule. Are you sure you want to proceed?
              </p>
              
              <div class="space-y-3 mb-6">
                <div class="bg-gray-50 rounded-lg p-3 text-left">
                  <div class="grid grid-cols-2 gap-3">
                    <div>
                      <p class="text-xs text-gray-500">Program</p>
                      <p class="text-sm font-medium">{{ program?.name || 'N/A' }}</p>
                    </div>
                    <div>
                      <p class="text-xs text-gray-500">Old Date</p>
                      <p class="text-sm font-medium text-gray-500 line-through">
                        {{ formatDate(originalAppointment?.preferred_date) }}
                      </p>
                    </div>
                    <div>
                      <p class="text-xs text-gray-500">New Date</p>
                      <p class="text-sm font-medium text-crimson-700">{{ formatDate(formData.preferredDate) }}</p>
                    </div>
                    <div>
                      <p class="text-xs text-gray-500">New Time</p>
                      <p class="text-sm font-medium text-crimson-700">{{ formatTimeSlot(formData.timeSlot) }}</p>
                    </div>
                  </div>
                </div>
              </div>
              
              <p class="mt-2 text-sm text-gray-600">
                By confirming this reschedule:
              </p>
              <ul class="list-disc ml-8 mt-1 text-sm text-gray-600">
                <li>Your original appointment will be cancelled</li>
                <li>Your new appointment will be created with the selected date and time</li>
                <li>An administrator will assign your test details (room, center, etc.)</li>
                <li>You'll receive an email notification when the details are ready</li>
              </ul>
              
              <div class="flex space-x-3">
                <button 
                  @click="showConfirmation = false" 
                  class="flex-1 px-4 py-2 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50"
                >
                  Review
                </button>
                <button 
                  @click="confirmSubmit" 
                  class="flex-1 px-4 py-2 bg-crimson-600 text-white rounded-lg hover:bg-crimson-700"
                  :disabled="isSubmitting"
                >
                  <span v-if="isSubmitting">
                    <i class="fas fa-spinner fa-spin mr-2"></i>Processing...
                  </span>
                  <span v-else>
                    Reschedule Now
                  </span>
                </button>
              </div>
            </div>
          </div>
        </div>
      </transition>
    </Teleport>
  </div>
</template>

<script>
import { ref, watch, computed, onMounted } from 'vue'
import CustomCalendar from './CustomCalendar.vue'
import { useToast } from '../../composables/useToast'

export default {
  name: 'RescheduleModal',
  components: {
    CustomCalendar
  },
  props: {
    modelValue: {
      type: Boolean,
      default: false
    },
    program: {
      type: Object,
      required: true
    },
    originalAppointment: {
      type: Object,
      required: true
    },
    dateAvailability: {
      type: Object,
      default: () => ({})
    }
  },
  emits: ['update:modelValue', 'submit'],
  setup(props, { emit }) {
    const formData = ref({
      preferredDate: '',
      timeSlot: ''
    });

    const showConfirmation = ref(false);
    const isSubmitting = ref(false);
    const dateError = ref('');
    const dateInput = ref(null);
    const showCalendar = ref(false);
    
    // Create a computed property to ensure capacity always matches current program
    const programCapacity = computed(() => {
      return props.program?.capacity_limit || 5;
    });
    
    // Computed property for half capacity (for morning/afternoon split)
    const halfProgramCapacity = computed(() => {
      return Math.floor(programCapacity.value / 2);
    });
    
    // Create an enhanced dateAvailability that uses the current program's capacity
    const enhancedDateAvailability = computed(() => {
      if (!props.dateAvailability) return {};
      
      // Clone the dateAvailability object but update the capacity to match current program
      const enhanced = {};
      for (const [date, info] of Object.entries(props.dateAvailability)) {
        // Calculate if morning/afternoon has reached capacity
        const morningCount = info.morning_count || 0;
        const afternoonCount = info.afternoon_count || 0;
        const halfCapacity = Math.floor(programCapacity.value / 2);
        
        // Update availability flags based on counts vs capacity
        const morningAvailable = morningCount < halfCapacity;
        const afternoonAvailable = afternoonCount < halfCapacity;
        
        // Overall date is available if either session has space
        const isAvailable = morningAvailable || afternoonAvailable;
        
        enhanced[date] = {
          ...info,
          capacity: programCapacity.value, // Full day capacity
          morning_capacity: halfCapacity, // Morning capacity
          afternoon_capacity: halfCapacity, // Afternoon capacity
          morning_available: morningAvailable, // Update based on actual capacity
          afternoon_available: afternoonAvailable, // Update based on actual capacity
          available: isAvailable // Date is available if either session has space
        };
      }
      
      return enhanced;
    });
    
    const { showToast } = useToast();

    // Date validation function
    const validateDateSelection = () => {
      dateError.value = '';
      
      if (!formData.value.preferredDate) return;
      
      const selectedDate = new Date(formData.value.preferredDate);
      const dayOfWeek = selectedDate.getDay();
      const dateStr = formData.value.preferredDate; // Format: YYYY-MM-DD
      
      // Sunday is 0 in JavaScript's getDay()
      if (dayOfWeek === 0) {
        dateError.value = 'Sundays are not available for scheduling. Please select another date.';
        // Reset the date selection
        formData.value.preferredDate = '';
        return;
      }
      
      // Check against capacity limits for both overall and specific time slot
      const availabilityInfo = enhancedDateAvailability.value[dateStr];
      
      if (availabilityInfo) {
        // If both morning and afternoon are full, the day is completely booked
        if (!availabilityInfo.morning_available && !availabilityInfo.afternoon_available) {
          dateError.value = 'This date has reached its booking capacity. Please select another date.';
          // Reset the date selection
          formData.value.preferredDate = '';
          return;
        }
        
        // If user has selected a specific time slot, check if it's available
        if (formData.value.timeSlot) {
          const isSlotAvailable = formData.value.timeSlot === 'morning' 
            ? availabilityInfo.morning_available 
            : availabilityInfo.afternoon_available;
            
          if (!isSlotAvailable) {
            dateError.value = `The ${formData.value.timeSlot} session for this date is fully booked. Please select another time slot or date.`;
            // Reset only the time slot, not the date
            formData.value.timeSlot = '';
            return;
          }
        }
      }
      
      // Clear error message if everything is fine
      dateError.value = '';
    };

    // Add a watcher for the dateAvailability prop
    watch(() => props.dateAvailability, (newValue) => {
      console.log('Date availability updated in reschedule modal:', newValue);
      
      // If the currently selected date is no longer available, clear it
      if (formData.value.preferredDate) {
        const dateInfo = enhancedDateAvailability.value[formData.value.preferredDate];
        if (dateInfo && !dateInfo.available) {
          dateError.value = 'This date has reached its booking capacity. Please select another date.';
          formData.value.preferredDate = '';
        }
      }
    });

    // Close calendar when both date and time slot are selected
    watch([() => formData.value.preferredDate, () => formData.value.timeSlot], ([date, timeSlot]) => {
      if (date && timeSlot) {
        // Add a short delay before closing the calendar for better user experience
        setTimeout(() => {
          showCalendar.value = false;
        }, 500); // 500ms delay
      }
    });

    const submitForm = () => {
      // Validate date before showing confirmation
      validateDateSelection();
      if (dateError.value) return;
      
      console.log('Reschedule form submitted, showing confirmation');
      showConfirmation.value = true;
    };

    const confirmSubmit = async () => {
      if (isSubmitting.value) return;
      if (dateError.value) return;
      
      isSubmitting.value = true;
      
      try {
        // Emit the submit event with date and time data
        emit('submit', {
          // Include original appointment data
          fullName: props.originalAppointment.full_name,
          contactNumber: props.originalAppointment.contact_number,
          email: props.originalAppointment.email,
          schoolName: props.originalAppointment.school_name,
          // Include new scheduling data
          preferredDate: formData.value.preferredDate,
          timeSlot: formData.value.timeSlot
        });
        
        // Close both modals
        showConfirmation.value = false;
        emit('update:modelValue', false);
        
        // Show success toast notification
        showToast('Your appointment has been successfully rescheduled. The admin will assign your new test details soon.', 'success');
      } catch (error) {
        console.error('Error in confirmSubmit:', error);
        showToast('Failed to reschedule appointment. Please try again.', 'error');
      } finally {
        isSubmitting.value = false;
      }
    };

    // Helper function to get today's date for min attribute
    const getTodayDate = () => {
      const today = new Date();
      const year = today.getFullYear();
      let month = today.getMonth() + 1;
      let day = today.getDate();
      
      // Add leading zeros if needed
      month = month < 10 ? '0' + month : month;
      day = day < 10 ? '0' + day : day;
      
      return `${year}-${month}-${day}`;
    };

    // Helper function to format dates for display
    const formatDate = (dateString) => {
      const date = new Date(dateString);
      if (isNaN(date.getTime())) {
        return '';
      }
      return date.toLocaleDateString('en-US', {
        year: 'numeric',
        month: 'long',
        day: 'numeric',
        weekday: 'long'
      });
    };

    const formatTimeSlot = (slot) => {
      const slots = {
        'morning': 'Morning (8:00 AM - 12:00 PM)',
        'afternoon': 'Afternoon (1:00 PM - 5:00 PM)'
      };
      return slots[slot] || 'Not selected';
    };

    // Time slot selection with validation
    const selectTimeSlot = (slot) => {
      // Check if the selected time slot is available
      const dateInfo = enhancedDateAvailability.value[formData.value.preferredDate];
      if (!dateInfo) return;
      
      const isAvailable = slot === 'morning' 
        ? dateInfo.morning_available 
        : dateInfo.afternoon_available;
      
      if (!isAvailable) {
        dateError.value = `The ${slot} session for this date is fully booked. Please select another time slot.`;
        return;
      }
      
      // Set the time slot if available
      formData.value.timeSlot = slot;
      dateError.value = ''; // Clear any errors
    };

    // Computed properties for time slot availability
    const isMorningAvailable = computed(() => {
      if (!formData.value.preferredDate) return false;
      
      const dateInfo = enhancedDateAvailability.value[formData.value.preferredDate];
      if (dateInfo) {
        return dateInfo.morning_available;
      }
      
      // If no availability data, assume available
      return true;
    });
    
    const isAfternoonAvailable = computed(() => {
      if (!formData.value.preferredDate) return false;
      
      const dateInfo = enhancedDateAvailability.value[formData.value.preferredDate];
      if (dateInfo) {
        return dateInfo.afternoon_available;
      }
      
      // If no availability data, assume available
      return true;
    });

    // Close calendar when clicking outside
    const handleClickOutside = (event) => {
      // Only close if calendar is open AND click is outside calendar AND outside the date input
      if (showCalendar.value && 
          !event.target.closest('.calendar-container') && 
          !event.target.closest('[data-calendar-trigger]')) {
        showCalendar.value = false;
      }
    };
    
    onMounted(() => {
      // Add click outside listener
      document.addEventListener('click', handleClickOutside);
    });

    // Toggle the calendar visibility
    const toggleCalendar = () => {
      showCalendar.value = !showCalendar.value;
    };
    
    // Close the calendar with a slight delay for better UX
    const closeCalendarWithDelay = () => {
      setTimeout(() => {
        showCalendar.value = false;
      }, 300);
    };

    return {
      formData,
      showConfirmation,
      isSubmitting,
      dateError,
      dateInput,
      submitForm,
      confirmSubmit,
      formatDate,
      formatTimeSlot,
      getTodayDate,
      validateDateSelection,
      showCalendar,
      isMorningAvailable,
      isAfternoonAvailable,
      enhancedDateAvailability,
      programCapacity,
      halfProgramCapacity,
      selectTimeSlot,
      toggleCalendar,
      closeCalendarWithDelay
    };
  }
}
</script>

<style scoped>
/* Backdrop Transition */
.backdrop-fade-enter-active {
  transition: opacity 0.3s cubic-bezier(0.19, 1, 0.22, 1);
}

.backdrop-fade-leave-active {
  transition: opacity 0.2s cubic-bezier(0.19, 1, 0.22, 1);
}

.backdrop-fade-enter-from,
.backdrop-fade-leave-to {
  opacity: 0;
}

/* Modal Transition */
.modal-pop-enter-active {
  transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
}

.modal-pop-leave-active {
  transition: all 0.2s cubic-bezier(0.47, 0, 0.745, 0.715);
}

.modal-pop-enter-from,
.modal-pop-leave-to {
  opacity: 0;
  transform: scale(0.9) translateY(20px);
}

/* Confirmation Modal Transition */
.modal-enter-active,
.modal-leave-active {
  transition: all 0.2s ease;
}

.modal-enter-from,
.modal-leave-to {
  transform: scale(0.95);
  opacity: 0;
}
</style> 