<template>
  <!-- Modal/Popup Overlay with frosted glass blur effect -->
  <div 
    v-if="show && !isGeneratingPdf" 
    class="fixed inset-0 bg-white/20 backdrop-blur-md z-50 flex items-center justify-center p-4 transition-opacity duration-300 overflow-y-auto"
    style="backdrop-filter: blur(10px); -webkit-backdrop-filter: blur(10px);"
  >
    <div 
      class="bg-white rounded-xl shadow-2xl w-full max-w-3xl transform transition-all duration-300 scale-100 overflow-hidden my-4"
      :class="{ 'animate-fade-in': show }"
    >
      <!-- Modal Header with Close Button - Fixed height -->
      <div class="bg-crimson-700 text-white px-6 py-4 flex items-center justify-between sticky top-0 z-10">
        <h2 class="text-2xl font-bold">Appointment Status</h2>
        <button 
          @click="emit('close')" 
          class="text-white hover:text-crimson-100 transition-colors rounded-full p-1 hover:bg-crimson-600"
          aria-label="Close"
        >
          <i class="fas fa-times text-xl"></i>
        </button>
      </div>

      <!-- Modal Content - Added max-height with scrolling -->
      <div class="p-6 max-h-[70vh] overflow-y-auto">
        <!-- Loading State - Centered properly -->
        <div v-if="loading" class="flex flex-col items-center justify-center py-16">
          <div class="animate-spin rounded-full h-16 w-16 border-4 border-crimson-200 border-t-4 border-t-crimson-600 mb-4"></div>
          <span class="text-gray-600 font-medium">Loading appointment details...</span>
        </div>

        <!-- Error State -->
        <div v-else-if="error" class="bg-red-50 border-l-4 border-red-500 text-red-700 p-6 rounded-lg">
          <div class="flex items-start">
            <div class="flex-shrink-0">
              <i class="fas fa-exclamation-circle text-2xl text-red-500 mr-4 mt-1"></i>
            </div>
            <div>
              <h3 class="text-lg font-medium text-red-800 mb-1">Error</h3>
              <p>{{ error }}</p>
            </div>
          </div>
        </div>

        <!-- Success State -->
        <div v-else-if="appointment" class="space-y-6">
          <!-- Status Badge - Centered properly -->
          <div class="flex flex-col items-center justify-center py-2">
            <div 
              class="w-16 h-16 rounded-full flex items-center justify-center mb-3"
              :class="getStatusBadgeClass(appointment.status)"
            >
              <i 
                class="fas text-2xl" 
                :class="getStatusIconClass(appointment.status)"
              ></i>
            </div>
            <div 
              class="px-4 py-1.5 rounded-full text-sm font-semibold inline-flex items-center"
              :class="getStatusTextClass(appointment.status)"
            >
              <span>{{ formatStatus(appointment.status) }}</span>
            </div>
          </div>
          
          <!-- Status-specific notices -->
          <StatusNotice 
            v-if="appointment.status" 
            :status="appointment.status" 
            :appointment="appointment" 
            :formatDate="formatDate"
            :formatTimeSlot="formatTimeSlot"
            :getEffectiveTimeSlot="getEffectiveTimeSlot"
          />
          
          <!-- Program Requirements (only shown for waiting_for_submission) -->
          <div 
            v-if="appointment.status === 'waiting_for_submission' && programDetails?.requirements?.length" 
            class="bg-white rounded-xl p-5 shadow-md border border-gray-100 hover:border-crimson-200 transition-colors mt-4"
          >
            <div class="flex items-center mb-3">
              <div class="w-10 h-10 bg-crimson-100 rounded-full flex items-center justify-center">
                <i class="fas fa-clipboard-list text-lg text-crimson-600"></i>
              </div>
              <h3 class="ml-3 font-semibold text-base text-gray-900">Program Requirements</h3>
            </div>
            <p class="text-sm text-gray-600 mb-3">Please ensure you have the following documents ready for submission:</p>
            <ul class="space-y-2">
              <li v-for="(requirement, index) in programDetails.requirements" :key="index" class="flex items-start">
                <div class="flex-shrink-0 mt-1">
                  <i class="fas fa-check-circle text-crimson-500 mr-2"></i>
                </div>
                <span class="text-sm text-gray-700">{{ requirement }}</span>
              </li>
            </ul>
          </div>
          
          <!-- Appointment Details Grid - Improved responsiveness -->
          <div class="grid grid-cols-1 lg:grid-cols-2 gap-4">          <!-- Schedule Information Card -->
          <div class="bg-white rounded-xl p-6 shadow-md border border-gray-100 hover:border-crimson-200 transition-colors lg:col-span-2">
            <div class="flex items-center mb-4">
              <div class="w-10 h-10 bg-crimson-100 rounded-full flex items-center justify-center">
                <i class="fas fa-calendar-alt text-lg text-crimson-600"></i>
              </div>
              <h3 class="ml-3 font-semibold text-lg text-gray-900">Schedule Information</h3>
            </div>
            
            <!-- For 'submitted' and 'waiting_for_submission' status, show both requested and official schedules side by side -->
            <div v-if="appointment.status === 'submitted' || appointment.status === 'waiting_for_submission'" class="space-y-6">
              <!-- Schedule Comparison Section -->
              <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
                <!-- Requested Schedule Card -->
                <div class="bg-gradient-to-br from-gray-50 to-gray-100 rounded-lg p-5 border border-gray-200 shadow-sm">
                  <h4 class="text-base font-semibold text-crimson-600 mb-4 flex items-center">
                    <i class="fas fa-user-clock mr-2"></i>
                    Registration Schedule
                  </h4>
                  <div class="space-y-3">
                    <div class="flex items-center text-gray-700">
                      <div class="w-8 h-8 bg-crimson-100 rounded-full flex items-center justify-center mr-3 flex-shrink-0">
                        <i class="fas fa-calendar-day text-sm text-crimson-600"></i>
                      </div>
                      <div>
                        <p class="text-xs text-gray-500 font-medium">Preferred Date</p>
                        <p class="font-semibold text-sm text-gray-800">{{ formatDate(appointment.preferred_date) }}</p>
                      </div>
                    </div>
                    <div class="flex items-center text-gray-700">
                      <div class="w-8 h-8 bg-crimson-100 rounded-full flex items-center justify-center mr-3 flex-shrink-0">
                        <i class="fas fa-clock text-sm text-crimson-600"></i>
                      </div>
                      <div>
                        <p class="text-xs text-gray-500 font-medium">Preferred Time</p>
                        <p class="font-semibold text-sm text-gray-800">{{ formatTimeSlot(appointment.time_slot) }}</p>
                      </div>
                    </div>
                  </div>
                </div>
                
                <!-- Official Schedule Card -->
                <div class="bg-gradient-to-br from-blue-50 to-blue-100 rounded-lg p-5 border border-blue-200 shadow-sm">
                  <h4 class="text-base font-semibold text-blue-600 mb-4 flex items-center">
                    <i class="fas fa-calendar-check mr-2"></i>
                    Official Exam Schedule
                  </h4>
                  <div v-if="loadingTestSessions" class="flex items-center justify-center py-8">
                    <div class="animate-spin rounded-full h-8 w-8 border-2 border-blue-200 border-t-blue-600"></div>
                    <span class="ml-3 text-sm text-blue-600 font-medium">Loading...</span>
                  </div>
                  <div v-else-if="getMatchingTestSession()" class="space-y-3">
                    <div class="flex items-center text-gray-700">
                      <div class="w-8 h-8 bg-blue-200 rounded-full flex items-center justify-center mr-3 flex-shrink-0">
                        <i class="fas fa-calendar-day text-sm text-blue-600"></i>
                      </div>
                      <div>
                        <p class="text-xs text-gray-500 font-medium">Exam Date</p>
                        <p class="font-semibold text-sm text-gray-800">{{ formatDate(getTestSessionInfo().exam_date) }}</p>
                      </div>
                    </div>
                    <div class="flex items-center text-gray-700">
                      <div class="w-8 h-8 bg-blue-200 rounded-full flex items-center justify-center mr-3 flex-shrink-0">
                        <i class="fas fa-list-alt text-sm text-blue-600"></i>
                      </div>
                      <div>
                        <p class="text-xs text-gray-500 font-medium">Exam Type</p>
                        <p class="font-semibold text-sm text-gray-800">{{ getMatchingTestSession().exam_type }} Exam Session</p>
                      </div>
                    </div>
                    <div class="flex items-center text-gray-700">
                      <div class="w-8 h-8 bg-blue-200 rounded-full flex items-center justify-center mr-3 flex-shrink-0">
                        <i class="fas fa-calendar-plus text-sm text-blue-600"></i>
                      </div>
                      <div>
                        <p class="text-xs text-gray-500 font-medium">Registration Period</p>
                        <p class="font-semibold text-sm text-gray-800">{{ formatDate(getTestSessionInfo().registration_start_date) }} - {{ formatDate(getTestSessionInfo().registration_end_date) }}</p>
                      </div>
                    </div>
                    <div class="flex items-center text-gray-700">
                      <div class="w-8 h-8 bg-blue-200 rounded-full flex items-center justify-center mr-3 flex-shrink-0">
                        <i class="fas fa-info-circle text-sm text-blue-600"></i>
                      </div>
                      <div>
                        <p class="text-xs text-gray-500 font-medium">Session Status</p>
                        <span :class="[
                          'px-3 py-1 text-xs font-semibold rounded-full',
                          getTestSessionInfo().status === 'ONGOING' ? 'bg-green-100 text-green-800' : 'bg-blue-100 text-blue-800'
                        ]">
                          {{ getTestSessionInfo().status }}
                        </span>
                      </div>
                    </div>
                    <div v-if="getMatchingTestSession().description" class="flex items-start text-gray-700">
                      <div class="w-8 h-8 bg-blue-200 rounded-full flex items-center justify-center mr-3 flex-shrink-0 mt-0.5">
                        <i class="fas fa-file-alt text-sm text-blue-600"></i>
                      </div>
                      <div>
                        <p class="text-xs text-gray-500 font-medium">Description</p>
                        <p class="text-sm text-gray-600">{{ getMatchingTestSession().description }}</p>
                      </div>
                    </div>
                  </div>
                  <div v-else class="text-center py-8">
                    <i class="fas fa-calendar-times text-gray-400 text-2xl mb-2"></i>
                    <p class="text-sm text-gray-500 font-medium">No official schedule available yet</p>
                  </div>
                </div>
              </div>
            </div>
            
            <!-- For other statuses, show the original single schedule layout -->
            <div v-else class="space-y-4">
              <!-- Requested Schedule Section -->
              <div class="bg-gray-50 rounded-lg p-4 border border-gray-200">
                <h4 class="text-base font-semibold text-crimson-600 mb-3 flex items-center">
                  <i class="fas fa-user-clock mr-2"></i>
                  Your Requested Schedule
                </h4>
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                  <div class="flex items-center text-gray-700">
                    <div class="w-8 h-8 bg-crimson-100 rounded-full flex items-center justify-center mr-3 flex-shrink-0">
                      <i class="fas fa-calendar-day text-sm text-crimson-600"></i>
                    </div>
                    <div>
                      <p class="text-xs text-gray-500 font-medium">Preferred Date</p>
                      <p class="font-semibold text-sm text-gray-800">{{ formatDate(appointment.preferred_date) }}</p>
                    </div>
                  </div>
                  <div class="flex items-center text-gray-700">
                    <div class="w-8 h-8 bg-crimson-100 rounded-full flex items-center justify-center mr-3 flex-shrink-0">
                      <i class="fas fa-clock text-sm text-crimson-600"></i>
                    </div>
                    <div>
                      <p class="text-xs text-gray-500 font-medium">Preferred Time Slot</p>
                      <p class="font-semibold text-sm text-gray-800">{{ formatTimeSlot(appointment.time_slot) }}</p>
                    </div>
                  </div>
                </div>
              </div>
              
              <!-- Official Test Schedule Section -->
              <div class="bg-blue-50 rounded-lg p-4 border border-blue-200">
                <h4 class="text-base font-semibold text-blue-600 mb-3 flex items-center">
                  <i class="fas fa-calendar-check mr-2"></i>
                  Official Test Schedule
                </h4>
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                  <div class="flex items-center text-gray-700">
                    <div class="w-8 h-8 bg-blue-200 rounded-full flex items-center justify-center mr-3 flex-shrink-0">
                      <i class="fas fa-calendar-check text-sm text-blue-600"></i>
                    </div>
                    <div>
                      <p class="text-xs text-gray-500 font-medium">Assigned Test Date</p>
                      <p class="font-semibold text-sm text-gray-800">{{ formatDate(appointment.test_date || appointment.preferred_date) }}</p>
                      <p 
                        v-if="appointment.test_date && appointment.test_date !== appointment.preferred_date" 
                        class="text-xs text-orange-600 mt-1 flex items-center"
                      >
                        <i class="fas fa-info-circle mr-1"></i>
                        Date changed from your original request
                      </p>
                    </div>
                  </div>
                  <div class="flex items-center text-gray-700">
                    <div class="w-8 h-8 bg-blue-200 rounded-full flex items-center justify-center mr-3 flex-shrink-0">
                      <i class="fas fa-clock text-sm text-blue-600"></i>
                    </div>
                    <div>
                      <p class="text-xs text-gray-500 font-medium">Assigned Time Slot</p>
                      <p class="font-semibold text-sm text-gray-800">{{ formatTimeSlot(appointment.assigned_test_time_slot || appointment.time_slot) }}</p>
                      <p 
                        v-if="appointment.assigned_test_time_slot && appointment.assigned_test_time_slot !== appointment.time_slot" 
                        class="text-xs text-orange-600 mt-1 flex items-center"
                      >
                        <i class="fas fa-info-circle mr-1"></i>
                        Time changed from your original request
                      </p>
                    </div>
                  </div>
                </div>
                
                <!-- Test Center and Room Info (shown for approved status) -->
                <div v-if="appointment.status === 'approved' && (appointment.test_center || appointment.room_number)" class="mt-4 pt-4 border-t border-blue-200">
                  <h5 class="text-sm font-semibold text-green-700 flex items-center mb-3">
                    <i class="fas fa-map-marker-alt mr-2"></i>
                    Your Test Location Details
                  </h5>
                  <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div v-if="appointment.test_center" class="flex items-center text-gray-700">
                      <div class="w-8 h-8 bg-green-100 rounded-full flex items-center justify-center mr-3 flex-shrink-0">
                        <i class="fas fa-building text-sm text-green-600"></i>
                      </div>
                      <div>
                        <p class="text-xs text-gray-500 font-medium">Test Center</p>
                        <p class="font-semibold text-sm text-gray-800">
                          {{ appointment.test_center }}
                          <span v-if="appointment.test_center_code && !String(appointment.test_center).includes(appointment.test_center_code)" 
                                class="text-gray-500 text-xs ml-1">
                            (ID: {{ appointment.test_center_code }})
                          </span>
                        </p>
                      </div>
                    </div>
                    
                    <div v-if="appointment.room_number || appointment.room_code" class="flex items-center text-gray-700">
                      <div class="w-8 h-8 bg-green-100 rounded-full flex items-center justify-center mr-3 flex-shrink-0">
                        <i class="fas fa-door-open text-sm text-green-600"></i>
                      </div>
                      <div>
                        <p class="text-xs text-gray-500 font-medium">Test Room</p>
                        <p class="font-semibold text-sm text-gray-800">
                          {{ appointment.room_number }}
                          <span v-if="appointment.room_code && !String(appointment.room_number).includes(appointment.room_code)" 
                                class="text-gray-500 text-xs ml-1">
                            (Code: {{ appointment.room_code }})
                          </span>
                        </p>
                      </div>
                    </div>
                  </div>
                  
                  <div v-if="appointment.test_center_address" class="flex items-center text-gray-700 mt-3">
                    <div class="w-8 h-8 bg-green-100 rounded-full flex items-center justify-center mr-3 flex-shrink-0">
                      <i class="fas fa-map-marker-alt text-sm text-green-600"></i>
                    </div>
                    <div>
                      <p class="text-xs text-gray-500 font-medium">Address</p>
                      <p class="font-semibold text-sm text-gray-800">{{ appointment.test_center_address }}</p>
                    </div>
                  </div>
                  
                  <!-- Additional helpful information -->
                  <div class="mt-4 pt-3 border-t border-green-200 bg-green-50 rounded-lg p-3">
                    <p class="text-sm text-green-700 flex items-center font-medium">
                      <i class="fas fa-info-circle mr-2"></i>
                      Please arrive at least 30 minutes before your scheduled test time.
                    </p>
                  </div>
                </div>
              </div>
            </div>
            
            <!-- Venue Information Section (for submission of requirements and general testing location) -->
            <div class="mt-6 pt-4 border-t border-gray-200">
              <h4 class="text-base font-semibold text-crimson-600 mb-4 flex items-center">
                <i class="fas fa-map-marker-alt mr-2"></i>
                Venue Information
              </h4>
              
              <!-- Test Center Information (for approved appointments with assigned test center) -->
              <div v-if="appointment.status === 'approved' && appointment.test_center" class="mb-4">
                <div class="bg-blue-50 rounded-lg p-4 border border-blue-200">
                  <h5 class="text-sm font-semibold text-blue-600 mb-3 flex items-center">
                    <i class="fas fa-building mr-2"></i>
                    Your Assigned Test Center
                  </h5>
                  <div class="space-y-3">
                    <div class="flex items-center text-gray-700">
                      <div class="w-8 h-8 bg-blue-200 rounded-full flex items-center justify-center mr-3 flex-shrink-0">
                        <i class="fas fa-building text-sm text-blue-600"></i>
                      </div>
                      <div>
                        <p class="text-xs text-gray-500 font-medium">Test Center</p>
                        <p class="font-semibold text-sm text-gray-800">{{ getTestCenterName() }}</p>
                        <span v-if="appointment.test_center_code" class="text-xs text-gray-500">
                          ID: {{ appointment.test_center_code }}
                        </span>
                      </div>
                    </div>
                    <div v-if="appointment.test_center_address" class="flex items-center text-gray-700">
                      <div class="w-8 h-8 bg-blue-200 rounded-full flex items-center justify-center mr-3 flex-shrink-0">
                        <i class="fas fa-map-marker-alt text-sm text-blue-600"></i>
                      </div>
                      <div>
                        <p class="text-xs text-gray-500 font-medium">Address</p>
                        <p class="font-semibold text-sm text-gray-800">{{ appointment.test_center_address }}</p>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
              
              <!-- Default Venue Information (for all other cases including submission of requirements) -->
              <div v-else class="bg-gray-50 rounded-lg p-4 border border-gray-200">
                <h5 class="text-sm font-semibold text-gray-600 mb-3 flex items-center">
                  <i class="fas fa-map-marker-alt mr-2"></i>
                  <span v-if="appointment.status === 'waiting_for_submission'">
                    Venue for Submission of Requirements
                  </span>
                  <span v-else>
                    Default Test Venue
                  </span>
                </h5>
                <div class="flex items-center text-gray-700">
                  <div class="w-8 h-8 bg-gray-200 rounded-full flex items-center justify-center mr-3 flex-shrink-0">
                    <i class="fas fa-building text-sm text-gray-600"></i>
                  </div>
                  <div>
                    <p class="text-xs text-gray-500 font-medium">Venue</p>
                    <p class="font-semibold text-sm text-gray-800">Testing and Evaluation Center</p>
                    <p class="text-xs text-gray-500">Campus B, Old high school building</p>
                  </div>
                </div>
                
                <!-- Additional information for submission status -->
                <div v-if="appointment.status === 'waiting_for_submission'" class="mt-4 pt-3 border-t border-gray-200 bg-orange-50 rounded-lg p-3">
                  <p class="text-sm text-orange-700 flex items-center font-medium">
                    <i class="fas fa-info-circle mr-2"></i>
                    Please bring all required documents to this location for submission.
                  </p>
                </div>
                
                <!-- General information for other statuses -->
                <div v-else-if="!appointment.test_center" class="mt-4 pt-3 border-t border-gray-200 bg-blue-50 rounded-lg p-3">
                  <p class="text-sm text-blue-700 flex items-center font-medium">
                    <i class="fas fa-info-circle mr-2"></i>
                    <span v-if="appointment.status === 'pending' || appointment.status === 'submitted'">
                      Specific test center will be assigned once your appointment is approved.
                    </span>
                    <span v-else>
                      This is the default testing location.
                    </span>
                  </p>
                </div>
              </div>
            </div>
          </div>
          
          <!-- Test Center and Session Selection Information -->
          </div>
          
          <!-- Action Buttons - More compact and responsive -->
          <!-- Temporarily commented out download button -->
          <!--
          <div 
            v-if="shouldShowFormDownloadButton" 
            class="flex flex-col sm:flex-row justify-center items-center gap-3 pt-2"
          >
            <button 
              @click="downloadApplicationForm"
              :disabled="isGeneratingPdf"
              class="bg-crimson-600 hover:bg-crimson-700 text-white py-2.5 px-5 rounded-lg flex items-center justify-center transition-colors duration-200 text-sm font-medium w-full sm:w-auto"
              aria-label="Download Application Form"
            >
              <i :class="isGeneratingPdf ? 'fas fa-spinner fa-spin' : 'fas fa-file-pdf'" class="mr-2"></i>
              {{ isGeneratingPdf ? 'Generating PDF...' : 'Download Application Form' }}
            </button>
          </div>
          -->
          
          <!-- Add Reschedule Button (shown for appropriate statuses) -->
          <div 
            v-if="shouldShowRescheduleButton" 
            class="flex justify-center mt-4"
          >
            <button 
              @click="handleReschedule"
              class="bg-purple-600 hover:bg-purple-700 text-white py-2.5 px-5 rounded-lg flex items-center justify-center transition-colors duration-200 text-sm font-medium"
              aria-label="Schedule New Appointment"
            >
              <i class="fas fa-calendar-alt mr-2"></i>
              Schedule New Appointment
            </button>
          </div>
        </div>

        <!-- No Data State - Compact version -->
        <div v-else class="flex flex-col items-center justify-center text-center text-gray-600 py-8">
          <div class="w-16 h-16 bg-gray-100 rounded-full flex items-center justify-center mb-3">
            <i class="fas fa-folder-open text-2xl text-gray-400"></i>
          </div>
          <h3 class="text-base font-medium text-gray-700 mb-1">No appointment details found</h3>
          <p class="text-sm text-gray-500 max-w-md">We couldn't find the appointment you're looking for.</p>
        </div>
      </div>
    </div>
  </div>

  <!-- PDF Generation Loading Indicator (optional, can be more prominent) -->
  <div v-if="isGeneratingPdf" class="fixed inset-0 bg-black bg-opacity-75 z-[70] flex flex-col items-center justify-center">
    <div class="animate-spin rounded-full h-16 w-16 border-4 border-crimson-200 border-t-4 border-t-crimson-600 mb-4"></div>
    <span class="text-white font-medium text-lg">Generating PDF, please wait...</span>
  </div>

  <!-- Hidden ApplicationForm for PDF generation -->
  <ApplicationForm
    v-if="pdfFormData"
    :appointment-data="pdfFormData"
    :output-pdf-only="true"
    :start-download="isGeneratingPdf" 
    @pdf-generation-complete="onPdfGenerationComplete"
  />
</template>

<script setup>
import { ref, computed, watch, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import axios from '../../plugins/axios'
import AuthService from '../../services/auth.service'
import ApplicationFormStore from '@/services/ApplicationFormStore'
import ApplicationForm from '@/components/ApplicationForm.vue'
import StatusNotice from '@/components/StatusNotice.vue'

// Props
const props = defineProps({
  id: {
    type: [String, Number],
    required: true
  },
  show: {
    type: Boolean,
    default: false
  }
})

// Emits
const emit = defineEmits(['close', 'reschedule'])

// Router and State
const router = useRouter()
const appointment = ref(null)
const programDetails = ref(null)
const loading = ref(true)
const error = ref(null)
const isGeneratingPdf = ref(false)
const pdfFormData = ref(null)
const testSessions = ref([])
const loadingTestSessions = ref(false)

// Methods (moved before watchers and onMounted)
const formatDate = (date) => {
  if (!date) return 'Not set'
  return new Date(date).toLocaleDateString('en-US', {
    year: 'numeric',
    month: 'long',
    day: 'numeric'
  })
}

const formatTimeSlot = (slot) => {
  const slots = {
    'morning': 'Morning (8:00 AM - 12:00 PM)',
    'afternoon': 'Afternoon (1:00 PM - 5:00 PM)'
  }
  return slots[slot] || slot || 'Not set'
}

const formatStatus = (status) => {
  const statuses = {
    'pending': 'Pending',
    'approved': 'Approved',
    'completed': 'Completed',
    'cancelled': 'Cancelled',
    'rescheduled': 'Rescheduled',
    'waiting_for_test_details': 'Waiting for Test Details',
    'waiting_for_submission': 'Waiting for Submission',
    'submitted': 'Waiting for Test Details',
    'claimed': 'Claimed'
  }
  return statuses[status] || status || 'Not set'
}

const getStatusBadgeClass = (status) => {
  return {
    'bg-yellow-100': status === 'pending' || status === 'waiting_for_test_details' || status === 'submitted',
    'bg-green-100': status === 'approved',
    'bg-blue-100': status === 'completed' || status === 'claimed',
    'bg-red-100': status === 'cancelled' || status === 'rejected',
    'bg-purple-100': status === 'rescheduled',
    'bg-teal-100': status === 'waiting_for_submission'
  }
}

const getStatusIconClass = (status) => {
  return {
    'fa-clock text-yellow-500': status === 'pending' || status === 'waiting_for_test_details' || status === 'submitted',
    'fa-check text-green-500': status === 'approved',
    'fa-check-double text-blue-500': status === 'completed' || status === 'claimed',
    'fa-times text-red-500': status === 'cancelled' || status === 'rejected',
    'fa-calendar-alt text-purple-500': status === 'rescheduled',
    'fa-file-upload text-teal-500': status === 'waiting_for_submission'
  }
}

const getStatusTextClass = (status) => {
  return {
    'bg-yellow-100 text-yellow-800': status === 'pending' || status === 'waiting_for_test_details' || status === 'submitted',
    'bg-green-100 text-green-800': status === 'approved',
    'bg-blue-100 text-blue-800': status === 'completed' || status === 'claimed',
    'bg-red-100 text-red-800': status === 'cancelled' || status === 'rejected',
    'bg-purple-100 text-purple-800': status === 'rescheduled',
    'bg-teal-100 text-teal-800': status === 'waiting_for_submission'
  }
}

const fetchProgramDetails = async (programId) => {
  try {
    const response = await axios.get(`/api/programs/${programId}/`)
    programDetails.value = response.data
    
    if (!programDetails.value.requirements) {
      programDetails.value.requirements = []
    }
    
    if (!Array.isArray(programDetails.value.requirements)) {
      if (typeof programDetails.value.requirements === 'object') {
        programDetails.value.requirements = Object.values(programDetails.value.requirements)
      } else {
        programDetails.value.requirements = []
      }
    }
    
  } catch (error) {
    console.error('Error fetching program details:', error)
    programDetails.value = {
      name: 'College Entrance Exam',
      requirements: [
        'Valid government ID',
        'High school transcripts',
        'Application fee payment receipt'
      ]
    }
  }
}

const getEffectiveTimeSlot = () => {
  return appointment.value.assigned_test_time_slot || appointment.value.time_slot
}

const getTestCenterName = () => {
  return appointment.value.test_center_name || 
         appointment.value.test_center || 
         'Not assigned yet'
}

const getTestSessionInfo = () => {
  // First try to get from the appointment's test session data
  if (appointment.value.test_session_name || appointment.value.test_session_exam_date) {
    return {
      exam_type: appointment.value.test_session_name || 'Unknown',
      exam_date: appointment.value.test_session_exam_date || appointment.value.test_date,
      registration_start_date: appointment.value.test_session_registration_start,
      registration_end_date: appointment.value.test_session_registration_end,
      description: appointment.value.test_session_description,
      status: 'ONGOING' // Default status
    }
  }
  
  // Fall back to matching test session
  return getMatchingTestSession()
}

const fetchTestDetailsForAppointment = async (appointmentId) => {
  try {
    console.log('Fetching test details for appointment:', appointmentId)
    const testDetailsResponse = await axios.get(`/api/appointments/${String(appointmentId)}/test-details/`)
    const testData = testDetailsResponse.data
    
    if (!appointment.value) return
    
    // Log the test details data
    console.log('Test details retrieved:', JSON.stringify(testData, null, 2))
    
    // Process test details - handle both direct fields and nested test_details structure
    const testSession = testData.test_session || (testData.test_details && testData.test_details.session)
    const testCenter = testData.test_center || (testData.test_details && testData.test_details.center)
    const testRoom = testData.test_room || (testData.test_details && testData.test_details.room)
    
    console.log('Processed test data:', { testSession, testCenter, testRoom })
    
    if (testSession) {
      appointment.value.test_date = testSession.exam_date || testSession.date
    }
    
    if (testCenter) {
      appointment.value.test_center = testCenter.name || testCenter.center_name
      appointment.value.test_center_code = testCenter.code || testCenter.id
      appointment.value.test_center_address = testCenter.address || testCenter.location || ''
      
      console.log('Test center data:', {
        name: appointment.value.test_center,
        code: appointment.value.test_center_code,
        address: appointment.value.test_center_address
      })
    }
    
    if (testRoom) {
      // Store the raw room data for debugging
      appointment.value.raw_room_data = testRoom
      
      // Set room name, ensuring we have a proper name
      if (testRoom.name && testRoom.name !== testRoom.room_code && !testRoom.name.includes(`Room ${testRoom.room_code}`)) {
        // If name exists and is different from code, use it
        appointment.value.room_number = testRoom.name
      } else if (testRoom.name && testRoom.name === testRoom.room_code) {
        // If name is same as code, make it more descriptive
        appointment.value.room_number = `Room ${testRoom.room_code}`
      } else if (testRoom.room_code) {
        // Just use room code with prefix
        appointment.value.room_number = `Room ${testRoom.room_code}`
      } else {
        // Fallback to just saying "Room"
        appointment.value.room_number = "Room"
      }
      
      // Store room code separately
      appointment.value.room_code = testRoom.room_code
      
      // Log the room details for debugging
      console.log('Room details:', {
        room_number: appointment.value.room_number,
        room_code: appointment.value.room_code,
        raw_room_data: testRoom
      })
    }
    
    // Log the updated appointment
    console.log('Updated appointment with test details:', {
      test_center: appointment.value.test_center,
      room_number: appointment.value.room_number,
      status: appointment.value.status
    })
  } catch (err) {
    console.error('Failed to fetch test details but continuing:', err)
  }
}

const fetchTestSessions = async () => {
  try {
    loadingTestSessions.value = true
    const response = await axios.get('/api/public/test-sessions/')
    testSessions.value = response.data
    console.log('Test sessions loaded:', testSessions.value)
  } catch (error) {
    console.error('Error fetching test sessions:', error)
    testSessions.value = []
  } finally {
    loadingTestSessions.value = false
  }
}

const getMatchingTestSession = () => {
  if (!appointment.value || !testSessions.value.length) return null
  
  // Try to match based on program code or exam type
  const programCode = programDetails.value?.code || appointment.value.program_code
  
  // Look for exact match first
  let matchingSession = testSessions.value.find(session => {
    return session.exam_type === programCode || 
           session.exam_type.toLowerCase() === programCode?.toLowerCase()
  })
  
  // If no exact match, try partial matches
  if (!matchingSession && programCode) {
    matchingSession = testSessions.value.find(session => {
      return session.exam_type.includes(programCode) || 
             programCode.includes(session.exam_type)
    })
  }
  
  // If still no match, return the first available session
  if (!matchingSession && testSessions.value.length > 0) {
    matchingSession = testSessions.value.find(session => 
      session.status === 'SCHEDULED' || session.status === 'ONGOING'
    )
  }
  
  return matchingSession
}

const fetchAppointmentStatus = async () => {
  try {
    loading.value = true
    error.value = null
    
    const currentUser = AuthService.getCurrentUser()
    
    const minLoadingTime = 500
    const loadingStartTime = Date.now()
    
    const response = await axios.get(`/api/appointments/${String(props.id)}/`)
    
    if (response.data.email !== currentUser.email) {
      error.value = 'You are not authorized to view this appointment or it does not exist.'
      appointment.value = null
      return
    }
    
    appointment.value = response.data
    
    const requiredFields = [
      'full_name', 'email', 'contact_number', 'school_name', 
      'preferred_date', 'time_slot', 'birth_month', 'birth_day', 
      'birth_year', 'gender', 'age', 'home_address', 'citizenship',
      'is_first_time', 'times_taken', 'applicant_type', 'high_school_code',
      'school_address', 'school_graduation_date', 'college_course', 'college_type'
    ]
    
    const missingFields = requiredFields.filter(field => 
      appointment.value[field] === undefined || appointment.value[field] === null
    )
    
    if (missingFields.length > 0) {
      console.warn('Missing fields in appointment data:', missingFields)
    }
    
    const programId = response.data.program || 
                    response.data.program_id || 
                    response.data.programId || 
                    null
    
    if (programId) {
      await fetchProgramDetails(programId).catch(err => {
        console.error('Failed to fetch program details but continuing:', err)
      })
    }
    
    // Fetch test sessions for status 'submitted', 'waiting_for_submission', 'approved' or when we need to show official schedule
    if (appointment.value.status === 'submitted' || appointment.value.status === 'waiting_for_test_details' || 
        appointment.value.status === 'waiting_for_submission' || appointment.value.status === 'approved') {
      await fetchTestSessions()
    }
    
    // Always fetch test details, but prioritize it for approved appointments
    if (appointment.value.status === 'approved') {
      console.log('Appointment is approved, prioritizing fetching test details...')
      await fetchTestDetailsForAppointment(props.id)
    } else {
      // For other statuses, fetch test details normally
      await fetchTestDetailsForAppointment(props.id)
    }
    
    const loadingElapsed = Date.now() - loadingStartTime
    const remainingDelay = Math.max(0, minLoadingTime - loadingElapsed)
    
    if (remainingDelay > 0) {
      await new Promise(resolve => setTimeout(resolve, remainingDelay))
    }
    
  } catch (error) {
    console.error('Error fetching appointment:', error)
    error.value = 'Failed to load appointment details. Please ensure the appointment exists and you have access to it.'
  } finally {
    loading.value = false
  }
}

const downloadApplicationForm = () => {
  if (!appointment.value || isGeneratingPdf.value) {
    console.warn('Cannot download form: No appointment data or PDF generation already in progress.')
    return
  }
  isGeneratingPdf.value = true

  const prepareAndSetData = () => {
    try {
      // Log source data
      console.log('[AppointmentStatus] Source Data for PDF (School Info):',
        'Applicant Type:', appointment.value?.applicant_type,
        'School Name:', appointment.value?.school_name,
        'School Address:', appointment.value?.school_address,
        'Graduation Date:', appointment.value?.school_graduation_date,
        'College Course:', appointment.value?.college_course,
        'College Type:', appointment.value?.college_type
      )
      console.log('[AppointmentStatus] Source Data for PDF (WMSUCET Experience):',
        'Is First Time:', appointment.value?.is_first_time,
        'Times Taken:', appointment.value?.times_taken
      )
      console.log('[AppointmentStatus] Source Data for PDF (High School Code):',
        'High School Code:', appointment.value?.high_school_code
      )

      const formData = {
        fullName: appointment.value.full_name, 
        contactNumber: appointment.value.contact_number,
        email: appointment.value.email,
        birthMonth: appointment.value.birth_month, 
        birthDay: appointment.value.birth_day, 
        birthYear: appointment.value.birth_year,
        gender: appointment.value.gender || '',
        age: appointment.value.age ? appointment.value.age.toString() : '',
        homeAddress: appointment.value.home_address || '',
        citizenship: appointment.value.citizenship || '',
        highSchoolCode: appointment.value.high_school_code || '',
        
        // WMSUCET experience structure
        wmsucetExperience: {
          firstTime: appointment.value.is_first_time === true,
          notFirstTime: appointment.value.is_first_time === false,
          timesTaken: appointment.value.times_taken ? appointment.value.times_taken.toString() : ''
        },
        
        programName: programDetails.value?.name || 'College Entrance Test',
        programId: appointment.value.program_id || appointment.value.program,
        preferredDate: appointment.value.preferred_date,
        timeSlot: getEffectiveTimeSlot(),
        appointmentId: appointment.value.id,
        test_date: appointment.value.test_date,
        test_center: appointment.value.test_center,
        test_center_code: appointment.value.test_center_code,
        room_number: appointment.value.room_number,
        room_code: appointment.value.room_code,
        
        // Applicant type and school info structure
        applicantType: appointment.value.applicant_type || '',
        schoolName: appointment.value.school_name || ''
      }

      // Construct nested school info based on applicant type
      if (appointment.value.applicant_type === 'senior_high_graduating') {
        formData.seniorGraduating = {
          schoolName: appointment.value.school_name || '',
          schoolAddress: appointment.value.school_address || '',
          graduationDate: appointment.value.school_graduation_date || ''
        }
      } else if (appointment.value.applicant_type === 'senior_high_graduate') {
        formData.seniorGraduate = {
          schoolName: appointment.value.school_name || '',
          schoolAddress: appointment.value.school_address || '',
          graduationDate: appointment.value.school_graduation_date || ''
        }
      } else if (appointment.value.applicant_type === 'college') {
        formData.college = {
          schoolName: appointment.value.school_name || '',
          schoolAddress: appointment.value.school_address || '',
          course: appointment.value.college_course || '',
          collegeType: appointment.value.college_type || ''
        }
      }

      formData.gender = {
        male: appointment.value.gender === 'male',
        female: appointment.value.gender === 'female'
      }

      ApplicationFormStore.setFormData(formData)
      ApplicationFormStore.setHasSubmittedData(true)

      pdfFormData.value = formData
    } catch (error) {
      console.error('Error preparing application form data for PDF:', error)
      alert('Failed to prepare the application form: ' + (error.message || 'Unknown error'))
      isGeneratingPdf.value = false
      pdfFormData.value = null
    }
  }

  if (!programDetails.value && (appointment.value.program || appointment.value.program_id)) {
    fetchProgramDetails(appointment.value.program || appointment.value.program_id)
      .then(() => prepareAndSetData())
      .catch(err => {
        console.error('Failed to fetch program details before PDF generation:', err)
        prepareAndSetData()
      })
  } else {
    prepareAndSetData()
  }
}

const onPdfGenerationComplete = ({ success, error }) => {
  isGeneratingPdf.value = false
  pdfFormData.value = null

  if (success) {
    console.log('PDF generated and download initiated successfully.')
  } else {
    console.error('PDF generation failed:', error)
    alert('Sorry, there was an error generating your PDF. Please try again. Details: ' + (error || 'Unknown error'))
  }
}

const handleReschedule = () => {
  emit('close')
  
  const programId = appointment.value.program || 
                    appointment.value.program_id || 
                    appointment.value.programId || 
                    null
  
  emit('reschedule', {
    appointmentId: appointment.value.id,
    programId: programId,
    originalAppointment: {
      id: appointment.value.id,
      full_name: appointment.value.full_name,
      contact_number: appointment.value.contact_number,
      email: appointment.value.email,
      school_name: appointment.value.school_name,
      preferred_date: appointment.value.preferred_date,
      time_slot: appointment.value.time_slot,
      test_center: appointment.value.test_center,
      test_center_name: appointment.value.test_center_name,
      test_session: appointment.value.test_session,
      status: appointment.value.status
    }
  })
}

// Computed Properties
const shouldShowFormDownloadButton = computed(() => {
  return appointment.value && 
    ['approved', 'claimed', 'waiting_for_submission'].includes(appointment.value.status)
})

const shouldShowRescheduleButton = computed(() => {
  return appointment.value && 
    (appointment.value.status === 'rescheduled' || appointment.value.reschedule_requested)
})

// Watchers
watch(() => props.show, (newVal) => {
  if (newVal && props.id) {
    fetchAppointmentStatus()
  } else if (!newVal) {
    isGeneratingPdf.value = false
    pdfFormData.value = null
  }
}, { immediate: true })

watch(() => props.id, (newVal) => {
  if (newVal && props.show) {
    fetchAppointmentStatus()
  }
}, { immediate: true })

watch(() => appointment.value, (newVal, oldVal) => {
  if (newVal && newVal.status === 'claimed') {
    setTimeout(() => {
      emit('close')
      router.push({ name: 'Schedule' })
    }, 1500)
  }
  
  // If status changes to approved or if component loads with an approved status, fetch test details
  if (newVal && newVal.status === 'approved') {
    if (!oldVal || oldVal.status !== 'approved') {
      console.log('Status is approved, fetching test details...')
      fetchTestDetailsForAppointment(props.id)
    } else if (!newVal.test_center || !newVal.room_number) {
      // Also fetch if test details seem to be missing
      console.log('Approved status but missing test details, fetching again...')
      fetchTestDetailsForAppointment(props.id)
    }
  }
}, { deep: true })

// Fetch data on component mount
onMounted(() => {
  if (props.show && props.id) {
    fetchAppointmentStatus()
  }
})
</script>

<style scoped>
.animate-fade-in {
  animation: fadeIn 0.3s ease-in-out;
}

@keyframes fadeIn {
  from { opacity: 0; transform: scale(0.95); }
  to { opacity: 1; transform: scale(1); }
}

/* Blur effect fallback for older browsers */
.backdrop-blur-md {
  backdrop-filter: blur(10px);
  -webkit-backdrop-filter: blur(10px);
}

/* Fallback for browsers that don't support backdrop-filter */
@supports not (backdrop-filter: blur(10px)) {
  .backdrop-blur-md {
    background-color: rgba(255, 255, 255, 0.8);
  }
}
</style> 