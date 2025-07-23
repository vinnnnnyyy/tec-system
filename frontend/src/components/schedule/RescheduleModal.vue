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
                      :testSessions="localTestSessions"
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

            <!-- Test Center Selection -->
            <div class="space-y-3">
              <label class="block text-sm font-medium text-gray-700">Preferred Test Center</label>
              <p class="text-sm text-gray-500">
                Select your preferred test center for the rescheduled appointment.
              </p>
              
              <div v-if="loadingTestCenters" class="flex justify-center py-8">
                <div class="w-8 h-8 rounded-full border-4 border-gray-200 border-t-crimson-600 animate-spin"></div>
              </div>
              
              <div v-else-if="testCenters.length === 0" class="text-center py-8 text-gray-500">
                <i class="fas fa-building text-3xl mb-2"></i>
                <p>No test centers available at the moment.</p>
              </div>
              
              <div v-else class="grid grid-cols-1 gap-3">
                <div v-for="center in testCenters" :key="center.id"
                  @click="selectTestCenter(center)"
                  :class="[
                    'border rounded-lg p-4 cursor-pointer transition-all duration-200 hover:shadow-md',
                    formData.testCenter === center.id 
                      ? 'border-crimson-500 bg-crimson-50 shadow-md' 
                      : 'border-gray-300 hover:border-crimson-300'
                  ]"
                >
                  <div class="flex items-center gap-3">
                    <div :class="[
                      'w-4 h-4 rounded-full border-2 flex items-center justify-center transition-all',
                      formData.testCenter === center.id 
                        ? 'border-crimson-500 bg-crimson-500' 
                        : 'border-gray-300'
                    ]">
                      <div v-if="formData.testCenter === center.id" class="w-2 h-2 bg-white rounded-full"></div>
                    </div>
                    <div class="flex-1">
                      <h4 class="font-semibold text-gray-900">{{ center.name }}</h4>
                      <p class="text-sm text-gray-600">{{ center.address }}</p>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <!-- Test Session Selection -->
            <div v-if="formData.testCenter" class="space-y-3">
              <label class="block text-sm font-medium text-gray-700">Select Test Session</label>
              <p class="text-sm text-gray-500">
                Choose your preferred exam date from the available test sessions for {{ getExamTypeFromProgram }} exams.
              </p>
              
              <div v-if="availableTestSessions.length === 0" class="text-center py-8 text-gray-500">
                <i class="fas fa-calendar-times text-3xl mb-2"></i>
                <p>No test sessions available for this program at the moment.</p>
              </div>
              
              <div v-else class="grid grid-cols-1 gap-3">
                <div v-for="session in availableTestSessions" :key="session.id"
                  @click="formData.testSession = session.id"
                  :class="[
                    'border rounded-lg p-4 cursor-pointer transition-all duration-200 hover:shadow-md',
                    formData.testSession === session.id 
                      ? 'border-crimson-500 bg-crimson-50 shadow-md' 
                      : 'border-gray-300 hover:border-crimson-300'
                  ]"
                >
                  <div class="flex items-center gap-3">
                    <div :class="[
                      'w-4 h-4 rounded-full border-2 flex items-center justify-center transition-all',
                      formData.testSession === session.id 
                        ? 'border-crimson-500 bg-crimson-500' 
                        : 'border-gray-300'
                    ]">
                      <div v-if="formData.testSession === session.id" class="w-2 h-2 bg-white rounded-full"></div>
                    </div>
                    <div class="flex-1">
                      <h4 class="font-semibold text-gray-900">{{ session.exam_type }} Exam Session</h4>
                      <div class="text-sm text-gray-600 mt-1">
                        <div class="flex items-center gap-2 mb-1">
                          <i class="fas fa-calendar-day text-crimson-500"></i>
                          <span>Exam Date: {{ formatDate(session.exam_date) }}</span>
                        </div>
                        <div class="flex items-center gap-2">
                          <i class="fas fa-calendar-plus text-green-500"></i>
                          <span>Registration: {{ formatDate(session.registration_start_date) }} - {{ formatDate(session.registration_end_date) }}</span>
                        </div>
                      </div>
                    </div>
                  </div>
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
                      <p class="text-xs text-gray-500">Test Center</p>
                      <p class="text-sm font-medium text-crimson-700">
                        {{ testCenters.find(c => c.id === formData.testCenter)?.name || 'N/A' }}
                      </p>
                    </div>
                    <div>
                      <p class="text-xs text-gray-500">Test Session</p>
                      <p class="text-sm font-medium text-crimson-700">
                        {{ availableTestSessions.find(s => s.id === formData.testSession)?.exam_type || 'N/A' }} - 
                        {{ formatDate(availableTestSessions.find(s => s.id === formData.testSession)?.exam_date) }}
                      </p>
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
    },
    testSessions: {
      type: Array,
      default: () => []
    }
  },
  emits: ['update:modelValue', 'submit'],
  setup(props, { emit }) {
    const formData = ref({
      preferredDate: '',
      timeSlot: '',
      testCenter: '',
      testSession: ''
    });

    const showConfirmation = ref(false);
    const isSubmitting = ref(false);
    const dateError = ref('');
    const dateInput = ref(null);
    const localTestSessions = ref([]);
    const testCenters = ref([]);
    const loadingTestCenters = ref(false);
    const { showToast } = useToast();

    // Fetch test centers
    const fetchTestCenters = async () => {
      loadingTestCenters.value = true;
      try {
        const endpoints = [
          '/api/test-centers/',       // Public endpoint (no auth required)
          '/api/admin/test-centers/'  // Admin endpoint (auth required)
        ];
        
        let response = null;
        
        for (const endpoint of endpoints) {
          try {
            const axiosInstance = (await import('../../plugins/axios')).default;
            const result = await axiosInstance.get(endpoint);
            response = result.data;
            break;
          } catch (err) {
            console.log(`Failed to fetch from ${endpoint}:`, err.response?.status);
          }
        }
        
        if (!response) {
          console.warn('No test centers available');
          testCenters.value = [];
          return;
        }
        
        testCenters.value = response.filter(center => center.is_active);
        console.log('Test centers loaded for reschedule modal:', testCenters.value.length);
      } catch (err) {
        console.error('Error fetching test centers for reschedule modal:', err);
        testCenters.value = [];
        showToast('Failed to load test centers', 'error');
      } finally {
        loadingTestCenters.value = false;
      }
    };

    // Fetch test sessions if they weren't passed as props
    const fetchTestSessions = async () => {
      if (props.testSessions && props.testSessions.length > 0) {
        localTestSessions.value = props.testSessions;
        return;
      }
      
      try {
        // Try different endpoints to find the working one
        const endpoints = [
          '/api/public/test-sessions/',  // Public endpoint (no auth required)
          '/api/admin/test-sessions/'    // Admin endpoint (auth required)
        ];
        
        let response = null;
        
        for (const endpoint of endpoints) {
          try {
            // Use fetch to avoid importing axios here
            const res = await fetch(endpoint);
            if (res.ok) {
              response = await res.json();
              break;
            }
          } catch (err) {
            console.log(`Failed to fetch from ${endpoint}`, err.message);
            continue;
          }
        }
        
        if (!response) {
          console.warn('No test sessions available');
          localTestSessions.value = [];
          return;
        }
        
        localTestSessions.value = response;
        console.log('Test sessions loaded for reschedule modal:', localTestSessions.value.length);
      } catch (err) {
        console.error('Error fetching test sessions for reschedule modal:', err);
        localTestSessions.value = [];
        showToast('Failed to load test session dates', 'error');
      }
    };

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

    // Get exam type based on program name for test session filtering
    const getExamTypeFromProgram = computed(() => {
      const programName = props.program?.name?.toLowerCase() || '';
      if (programName.includes('cet') || programName.includes('entrance')) {
        return 'CET';
      } else if (programName.includes('law') || programName.includes('philsat')) {
        return 'PhilSAT';
      } else if (programName.includes('graduate') || programName.includes('gmat')) {
        return 'GMAT';
      }
      return 'CET'; // Default fallback
    });

    // Filter available test sessions based on program
    const availableTestSessions = computed(() => {
      if (!localTestSessions.value || localTestSessions.value.length === 0) return [];
      
      const examType = getExamTypeFromProgram.value;
      const currentDate = new Date();
      
      // Filter sessions by exam type and ensure they're in the future
      const filteredSessions = localTestSessions.value.filter(session => {
        const examDate = new Date(session.exam_date);
        const registrationEndDate = new Date(session.registration_end_date);
        
        return session.exam_type === examType && 
               examDate > currentDate && 
               registrationEndDate > currentDate &&
               session.status === 'ONGOING';
      });
      
      // Sort by exam date (earliest first)
      return filteredSessions.sort((a, b) => new Date(a.exam_date) - new Date(b.exam_date));
    });

    // Function to select test center
    const selectTestCenter = (center) => {
      formData.value.testCenter = center.id;
      // Reset test session when center changes
      formData.value.testSession = '';
    };

    // Watch for modal open to fetch test sessions and centers
    watch(() => props.modelValue, (newValue) => {
      if (newValue) {
        fetchTestSessions();
        fetchTestCenters();
      }
    });

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
      // Validate all required fields before showing confirmation
      validateDateSelection();
      if (dateError.value) return;
      
      // Validate test center selection
      if (!formData.value.testCenter) {
        showToast('Please select a test center', 'error');
        return;
      }
      
      // Validate test session selection
      if (!formData.value.testSession) {
        showToast('Please select a test session', 'error');
        return;
      }
      
      // Validate date and time slot selection
      if (!formData.value.preferredDate || !formData.value.timeSlot) {
        showToast('Please select both a date and time slot', 'error');
        return;
      }
      
      console.log('Reschedule form submitted, showing confirmation');
      showConfirmation.value = true;
    };

    const confirmSubmit = async () => {
      if (isSubmitting.value) return;
      if (dateError.value) return;
      
      isSubmitting.value = true;
      
      try {
        // Emit the submit event with all form data
        emit('submit', {
          // Include original appointment ID for proper updating
          appointmentId: props.originalAppointment.id,
          // Include original appointment data
          fullName: props.originalAppointment.full_name,
          contactNumber: props.originalAppointment.contact_number,
          email: props.originalAppointment.email,
          schoolName: props.originalAppointment.school_name,
          // Include new scheduling data
          preferredDate: formData.value.preferredDate,
          timeSlot: formData.value.timeSlot,
          testCenter: formData.value.testCenter,
          testSession: formData.value.testSession
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
      
      // Fetch test sessions and centers if modal is already open
      if (props.modelValue) {
        fetchTestSessions();
        fetchTestCenters();
      }
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
      localTestSessions,
      testCenters,
      loadingTestCenters,
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
      selectTestCenter,
      toggleCalendar,
      closeCalendarWithDelay,
      getExamTypeFromProgram,
      availableTestSessions
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