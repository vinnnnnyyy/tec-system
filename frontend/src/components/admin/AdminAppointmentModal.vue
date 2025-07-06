<template>
  <div v-if="visible" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
    <div class="bg-white rounded-lg shadow-xl w-full max-w-4xl max-h-[90vh] overflow-y-auto">
      <!-- Header -->
      <div class="flex justify-between items-center p-6 border-b">
        <h2 class="text-xl font-semibold text-gray-900">
          Create New Appointment - Step {{ currentStep }} of 2
        </h2>
        <button @click="closeModal" class="text-gray-400 hover:text-gray-600">
          <i class="fas fa-times text-xl"></i>
        </button>
      </div>

      <!-- Loading State -->
      <div v-if="loading" class="p-6 text-center">
        <div class="w-12 h-12 rounded-full border-4 border-crimson-200 border-t-crimson-600 animate-spin mx-auto mb-4"></div>
        <p class="text-gray-600">Loading programs...</p>
      </div>

      <!-- Form Content -->
      <div v-else class="p-6">
        <!-- Step 1: Personal Information -->
        <div v-if="currentStep === 1" class="space-y-6">
          <!-- Program Selection - Top Priority -->
          <div class="bg-crimson-50 p-4 rounded-lg border border-crimson-200">
            <h3 class="text-lg font-medium text-crimson-900 mb-3">
              <i class="fas fa-graduation-cap mr-2"></i>
              Program Selection
            </h3>
            <div class="text-sm text-crimson-700 mb-3">
              Select the program for this appointment first.
            </div>
            <div>
              <label class="block text-sm font-medium text-crimson-800 mb-2">
                Program *
              </label>
              <select
                v-model="form.program"
                class="w-full px-4 py-3 border border-crimson-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-transparent bg-white"
                required
              >
                <option value="">Select Program</option>
                <option v-for="program in programs" :key="program.id" :value="program.id">
                  {{ program.label }}
                </option>
              </select>
              <div v-if="errors.program" class="text-red-500 text-sm mt-1">
                {{ errors.program }}
              </div>
              <div v-if="loading" class="text-crimson-600 text-sm mt-1">
                <i class="fas fa-spinner fa-spin mr-1"></i>
                Loading programs...
              </div>
            </div>
          </div>

          <div class="mb-6">
            <h3 class="text-lg font-medium text-gray-900 mb-4">Personal Information</h3>
            <div class="text-sm text-gray-600 mb-4">
              Fill in the client's personal details for the appointment.
            </div>
          </div>

          <!-- Name Section -->
          <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">
                Last Name *
              </label>
              <input
                v-model="form.lastName"
                @input="handleTextInput('lastName')"
                type="text"
                class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-transparent"
                placeholder="Enter last name"
                autocapitalize="words"
                required
              />
              <div v-if="errors.lastName" class="text-red-500 text-sm mt-1">
                {{ errors.lastName }}
              </div>
            </div>

            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">
                First Name *
              </label>
              <input
                v-model="form.firstName"
                @input="handleTextInput('firstName')"
                type="text"
                class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-transparent"
                placeholder="Enter first name"
                autocapitalize="words"
                required
              />
              <div v-if="errors.firstName" class="text-red-500 text-sm mt-1">
                {{ errors.firstName }}
              </div>
            </div>

            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">
                Middle Name
              </label>
              <input
                v-model="form.middleName"
                @input="handleTextInput('middleName')"
                type="text"
                class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-transparent"
                placeholder="Enter middle name"
                autocapitalize="words"
              />
            </div>
          </div>

          <!-- Contact Information -->
          <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">
                Email Address *
              </label>
              <input
                v-model="form.email"
                type="email"
                class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-transparent"
                placeholder="Enter email address"
                required
              />
              <div v-if="errors.email" class="text-red-500 text-sm mt-1">
                {{ errors.email }}
              </div>
            </div>

            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">
                Contact Number *
              </label>
              <input
                v-model="form.contactNumber"
                type="tel"
                class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-transparent"
                placeholder="Enter contact number"
                required
              />
              <div v-if="errors.contactNumber" class="text-red-500 text-sm mt-1">
                {{ errors.contactNumber }}
              </div>
            </div>
          </div>

          <!-- Birth Date and Gender -->
          <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">
                Birth Date *
              </label>
              <div class="grid grid-cols-3 gap-2">
                <select
                  v-model="form.birthMonth"
                  class="px-3 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-transparent"
                  required
                >
                  <option value="">Month</option>
                  <option v-for="month in 12" :key="month" :value="month">
                    {{ new Date(0, month - 1).toLocaleString('default', { month: 'long' }) }}
                  </option>
                </select>
                <select
                  v-model="form.birthDay"
                  class="px-3 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-transparent"
                  required
                >
                  <option value="">Day</option>
                  <option v-for="day in 31" :key="day" :value="day">{{ day }}</option>
                </select>
                <select
                  v-model="form.birthYear"
                  class="px-3 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-transparent"
                  required
                >
                  <option value="">Year</option>
                  <option v-for="year in birthYears" :key="year" :value="year">
                    {{ year }}
                  </option>
                </select>
              </div>
              <div v-if="errors.birthDate" class="text-red-500 text-sm mt-1">
                {{ errors.birthDate }}
              </div>
              <div v-if="computedAge" class="text-sm text-gray-600 mt-1">
                Age: {{ computedAge }} years old
              </div>
            </div>

            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">
                Gender *
              </label>
              <select
                v-model="form.gender"
                class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-transparent"
                required
              >
                <option value="">Select Gender</option>
                <option value="male">Male</option>
                <option value="female">Female</option>
              </select>
              <div v-if="errors.gender" class="text-red-500 text-sm mt-1">
                {{ errors.gender }}
              </div>
            </div>
          </div>

          <!-- Address Information -->
          <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">
                Street/Purok *
              </label>
              <input
                v-model="form.streetPurok"
                @input="handleTextInput('streetPurok')"
                type="text"
                class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-transparent"
                placeholder="Enter street/purok"
                autocapitalize="words"
                required
              />
              <div v-if="errors.streetPurok" class="text-red-500 text-sm mt-1">
                {{ errors.streetPurok }}
              </div>
            </div>

            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">
                Barangay *
              </label>
              <input
                v-model="form.barangay"
                @input="handleTextInput('barangay')"
                type="text"
                class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-transparent"
                placeholder="Enter barangay"
                autocapitalize="words"
                required
              />
              <div v-if="errors.barangay" class="text-red-500 text-sm mt-1">
                {{ errors.barangay }}
              </div>
            </div>

            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">
                City *
              </label>
              <input
                v-model="form.city"
                @input="handleTextInput('city')"
                type="text"
                class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-transparent"
                placeholder="Enter city"
                autocapitalize="words"
                required
              />
              <div v-if="errors.city" class="text-red-500 text-sm mt-1">
                {{ errors.city }}
              </div>
            </div>
          </div>

          <!-- Citizenship -->
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-2">
              Citizenship *
            </label>
            <input
              v-model="form.citizenship"
              @input="handleTextInput('citizenship')"
              type="text"
              class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-transparent"
              placeholder="Enter citizenship"
              autocapitalize="words"
              required
            />
            <div v-if="errors.citizenship" class="text-red-500 text-sm mt-1">
              {{ errors.citizenship }}
            </div>
          </div>
        </div>
        
        <!-- Step 2: Program and Appointment Details -->
        <div v-if="currentStep === 2" class="space-y-6">
          <div class="mb-6">
            <h3 class="text-lg font-medium text-gray-900 mb-4">Appointment Details</h3>
            <div class="text-sm text-gray-600 mb-4">
              Set the appointment details and additional information for the client.
            </div>
          </div>

          <!-- Appointment Date and Time -->
          <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">
                Appointment Date *
              </label>
              <input
                v-model="form.appointmentDate"
                type="date"
                class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-transparent"
                :min="minDate"
                required
              />
              <div v-if="errors.appointmentDate" class="text-red-500 text-sm mt-1">
                {{ errors.appointmentDate }}
              </div>
            </div>

            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">
                Time Slot *
              </label>
              <select
                v-model="form.timeSlot"
                class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-transparent"
                required
              >
                <option value="">Select Time</option>
                <option value="morning">Morning (8:00 AM - 12:00 PM)</option>
                <option value="afternoon">Afternoon (1:00 PM - 5:00 PM)</option>
              </select>
              <div v-if="errors.timeSlot" class="text-red-500 text-sm mt-1">
                {{ errors.timeSlot }}
              </div>
            </div>
          </div>

          <!-- Applicant Type -->
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-2">
              Applicant Type *
            </label>
            <select
              v-model="form.applicantType"
              class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-transparent"
              required
            >
              <option value="">Select Applicant Type</option>
              <option value="senior_high_graduating">Senior High Graduating</option>
              <option value="senior_high_graduate">Senior High Graduate</option>
              <option value="college">College</option>
            </select>
            <div v-if="errors.applicantType" class="text-red-500 text-sm mt-1">
              {{ errors.applicantType }}
            </div>
          </div>

          <!-- School Information -->
          <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">
                School Name *
              </label>
              <input
                v-model="form.schoolName"
                @input="handleTextInput('schoolName')"
                type="text"
                class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-transparent"
                placeholder="Enter school name"
                autocapitalize="words"
                required
              />
              <div v-if="errors.schoolName" class="text-red-500 text-sm mt-1">
                {{ errors.schoolName }}
              </div>
            </div>

            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">
                School Address
              </label>
              <input
                v-model="form.schoolAddress"
                @input="handleTextInput('schoolAddress')"
                type="text"
                class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-transparent"
                placeholder="Enter school address"
                autocapitalize="words"
              />
            </div>
          </div>

          <!-- WMSUCET Experience -->
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-2">
              WMSUCET Experience *
            </label>
            <div class="flex items-center space-x-6">
              <label class="flex items-center">
                <input
                  v-model="form.isFirstTime"
                  type="radio"
                  :value="true"
                  name="wmsucetExperience"
                  class="w-4 h-4 text-crimson-600 border-gray-300 focus:ring-crimson-500"
                />
                <span class="ml-2 text-sm text-gray-700">First Time</span>
              </label>
              <label class="flex items-center">
                <input
                  v-model="form.isFirstTime"
                  type="radio"
                  :value="false"
                  name="wmsucetExperience"
                  class="w-4 h-4 text-crimson-600 border-gray-300 focus:ring-crimson-500"
                />
                <span class="ml-2 text-sm text-gray-700">Not First Time</span>
              </label>
            </div>
            <div v-if="!form.isFirstTime" class="mt-3">
              <input
                v-model="form.timesTaken"
                type="number"
                min="1"
                class="w-32 px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-transparent"
                placeholder="Times taken"
              />
              <span class="ml-2 text-sm text-gray-600">times taken</span>
            </div>
          </div>

          <!-- Test Session, Center, and Room Assignment -->
          <div class="bg-blue-50 p-4 rounded-lg border border-blue-200">
            <h4 class="text-md font-medium text-blue-900 mb-3">
              <i class="fas fa-building mr-2"></i>
              Test Assignment
            </h4>
            <div class="text-sm text-blue-700 mb-4">
              Select a test session, test center, and test room to assign to this appointment.
            </div>
            
            <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
              <!-- Test Session Selection -->
              <div class="space-y-2">
                <label class="block text-sm font-medium text-gray-700">Test Session *</label>
                <div class="relative">
                  <select 
                    v-model="form.testSession" 
                    class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-transparent"
                    required>
                    <option value="">Select a test session</option>
                    <option v-for="session in testSessions" :key="session.id" :value="session.id">
                      {{ session.exam_type }} - {{ formatDate(session.exam_date) }}
                    </option>
                  </select>
                  <div v-if="loadingTestSessions" class="absolute right-3 top-2.5">
                    <i class="fas fa-spinner fa-spin text-gray-400"></i>
                  </div>
                </div>
                <div v-if="errors.testSession" class="text-red-500 text-sm">
                  {{ errors.testSession }}
                </div>
                <div v-if="testSessionError" class="text-red-500 text-sm">
                  {{ testSessionError }}
                </div>
              </div>
              
              <!-- Test Center Selection -->
              <div class="space-y-2">
                <label class="block text-sm font-medium text-gray-700">Test Center *</label>
                <div class="relative">
                  <select 
                    v-model="form.testCenter" 
                    @change="onTestCenterChange"
                    class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-transparent"
                    required>
                    <option value="">Select a test center</option>
                    <option v-for="center in testCenters" :key="center.id" :value="center.id">
                      {{ center.name }}
                    </option>
                  </select>
                  <div v-if="loadingTestCenters" class="absolute right-3 top-2.5">
                    <i class="fas fa-spinner fa-spin text-gray-400"></i>
                  </div>
                </div>
                <div v-if="errors.testCenter" class="text-red-500 text-sm">
                  {{ errors.testCenter }}
                </div>
                <div v-if="testCenterError" class="text-red-500 text-sm">
                  {{ testCenterError }}
                </div>
              </div>
              
              <!-- Test Room Selection -->
              <div class="space-y-2">
                <label class="block text-sm font-medium text-gray-700">Test Room *</label>
                <div class="relative">
                  <select 
                    v-model="form.testRoom" 
                    :disabled="!form.testCenter || loadingTestRooms"
                    class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-transparent disabled:bg-gray-100"
                    required>
                    <option value="">Select a test room</option>
                    <option v-for="room in filteredTestRooms" :key="room.id" :value="room.id">
                      {{ room.name }} ({{ room.time_slot === 'morning' ? 'Morning' : 'Afternoon' }}, 
                      {{ room.available_capacity }} available)
                    </option>
                  </select>
                  <div v-if="loadingTestRooms" class="absolute right-3 top-2.5">
                    <i class="fas fa-spinner fa-spin text-gray-400"></i>
                  </div>
                </div>
                <div v-if="errors.testRoom" class="text-red-500 text-sm">
                  {{ errors.testRoom }}
                </div>
                <div v-if="testRoomError" class="text-red-500 text-sm">
                  {{ testRoomError }}
                </div>
              </div>
            </div>
          </div>

          <!-- Status -->
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-2">
              Initial Status *
            </label>
            <select
              v-model="form.status"
              class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-transparent"
              required
            >
              <option value="waiting_for_submission">Waiting for Submission</option>
              <option value="approved">Approved</option>
              <option value="waiting_for_test_details">Waiting for Test Details</option>
            </select>
            <div v-if="errors.status" class="text-red-500 text-sm mt-1">
              {{ errors.status }}
            </div>
          </div>

          <!-- Notes -->
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-2">
              Notes (Optional)
            </label>
            <textarea
              v-model="form.notes"
              rows="4"
              class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-transparent"
              placeholder="Add any additional notes about this appointment..."
            ></textarea>
          </div>
        </div>

        <!-- Form Actions -->
        <div class="flex justify-between items-center mt-8 pt-6 border-t">
          <div class="flex items-center space-x-2">
            <div class="flex space-x-1">
              <div :class="[
                'w-3 h-3 rounded-full',
                currentStep >= 1 ? 'bg-crimson-600' : 'bg-gray-300'
              ]"></div>
              <div :class="[
                'w-3 h-3 rounded-full',
                currentStep >= 2 ? 'bg-crimson-600' : 'bg-gray-300'
              ]"></div>
            </div>
            <span class="text-sm text-gray-600">Step {{ currentStep }} of 2</span>
          </div>

          <div class="flex space-x-3">
            <button
              v-if="currentStep > 1"
              @click="previousStep"
              class="px-6 py-2 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition-colors"
            >
              Previous
            </button>
            <button
              v-if="currentStep < 2"
              @click="nextStep"
              class="px-6 py-2 bg-crimson-600 text-white rounded-lg hover:bg-crimson-700 transition-colors"
            >
              Next
            </button>
            <button
              v-if="currentStep === 2"
              @click="submitForm"
              :disabled="submitting"
              class="px-6 py-2 bg-crimson-600 text-white rounded-lg hover:bg-crimson-700 transition-colors disabled:opacity-50"
            >
              <span v-if="submitting">
                <i class="fas fa-spinner fa-spin mr-2"></i>
                Creating...
              </span>
              <span v-else>Create Appointment</span>
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { ref, computed, watch, onMounted } from 'vue'
import axios from '../../plugins/axios'

export default {
  name: 'AdminAppointmentModal',
  props: {
    visible: {
      type: Boolean,
      default: false
    }
  },
  emits: ['close', 'submit'],
  setup(props, { emit }) {
    const currentStep = ref(1)
    const submitting = ref(false)
    const loading = ref(false)
    const programs = ref([])
    
    // Test assignment data
    const testSessions = ref([])
    const testCenters = ref([])
    const testRooms = ref([])
    const loadingTestSessions = ref(false)
    const loadingTestCenters = ref(false)
    const loadingTestRooms = ref(false)
    const testSessionError = ref(null)
    const testCenterError = ref(null)
    const testRoomError = ref(null)
    
    const form = ref({
      // Personal Information
      lastName: '',
      firstName: '',
      middleName: '',
      email: '',
      contactNumber: '',
      birthMonth: '',
      birthDay: '',
      birthYear: '',
      gender: '',
      age: null,
      streetPurok: '',
      barangay: '',
      city: '',
      citizenship: '',
      
      // Program and Appointment Details
      program: '',
      appointmentDate: '',
      timeSlot: '',
      applicantType: '',
      
      // WMSUCET Experience
      isFirstTime: true,
      timesTaken: 0,
      
      // School Information (based on applicant type)
      schoolName: '',
      schoolAddress: '',
      graduationDate: '',
      collegeLevel: '',
      collegeCourse: '',
      collegeType: '',
      
      // Test Assignment
      testSession: '',
      testCenter: '',
      testRoom: '',
      status: 'waiting_for_submission',
      notes: ''
    })

    const errors = ref({})

    // Computed properties
    const minDate = computed(() => {
      const tomorrow = new Date()
      tomorrow.setDate(tomorrow.getDate() + 1)
      return tomorrow.toISOString().split('T')[0]
    })

    // Computed age based on birth date
    const computedAge = computed(() => {
      if (!form.value.birthMonth || !form.value.birthDay || !form.value.birthYear) {
        return null
      }
      
      const today = new Date()
      const birthDate = new Date(form.value.birthYear, form.value.birthMonth - 1, form.value.birthDay)
      let age = today.getFullYear() - birthDate.getFullYear()
      const monthDiff = today.getMonth() - birthDate.getMonth()
      
      if (monthDiff < 0 || (monthDiff === 0 && today.getDate() < birthDate.getDate())) {
        age--
      }
      
      return age
    })

    // Computed birth years (100 years back from current year)
    const birthYears = computed(() => {
      const currentYear = new Date().getFullYear()
      return Array.from({ length: 100 }, (_, i) => currentYear - i)
    })

    // Computed filtered test rooms based on selected test center
    const filteredTestRooms = computed(() => {
      if (!form.value.testCenter || !testRooms.value.length) return []
      
      return testRooms.value.filter(room => {
        // Match test center ID
        const roomCenterId = room.test_center?.id !== undefined ? 
                           room.test_center.id : 
                           room.test_center
        
        // Only show rooms that belong to the selected test center
        // and have available capacity
        return parseInt(roomCenterId, 10) === parseInt(form.value.testCenter, 10) &&
               room.available_capacity > 0
      })
    })

    // Handle text input with real-time validation and auto-uppercase for key fields
    const handleTextInput = (fieldName, modelPath = null) => {
      const actualPath = modelPath || fieldName
      const keys = actualPath.split('.')
      let target = form.value
      
      // Navigate to the correct nested object
      for (let i = 0; i < keys.length - 1; i++) {
        target = target[keys[i]]
      }
      
      const finalKey = keys[keys.length - 1]
      const currentValue = target[finalKey]
      
      // Convert to uppercase for key fields used in CSV score import matching
      // This ensures consistent data format for score import/matching
      const fieldsToUppercase = [
        'lastName', 'firstName', 'middleName',  // Name fields for score matching
        'streetPurok', 'barangay', 'city', 'citizenship',  // Address fields
        'schoolName', 'schoolAddress'  // School fields
      ]
      
      if (fieldsToUppercase.includes(fieldName)) {
        target[finalKey] = currentValue.toUpperCase()
      }
      // For other fields, keep the original case
    }

    // Watch for birth date changes and auto-calculate age
    watch([
      () => form.value.birthMonth,
      () => form.value.birthDay,
      () => form.value.birthYear
    ], () => {
      if (computedAge.value !== null) {
        form.value.age = computedAge.value
      }
    })

    // Fetch programs on component mount
    const fetchPrograms = async () => {
      try {
        loading.value = true
        const response = await axios.get('/api/programs/')
        
        if (response.data && Array.isArray(response.data)) {
          programs.value = response.data.map(program => ({
            id: program.id,
            code: program.code,
            name: program.name,
            label: `${program.code} - ${program.name}`
          }))
        }
      } catch (error) {
        console.error('Error fetching programs:', error)
      } finally {
        loading.value = false
      }
    }

    // Fetch test sessions
    const fetchTestSessions = async () => {
      try {
        loadingTestSessions.value = true
        testSessionError.value = null
        const response = await axios.get('/api/admin/test-sessions/')
        
        if (response.data && Array.isArray(response.data)) {
          testSessions.value = response.data.filter(session => 
            session.status === 'SCHEDULED' || session.status === 'ONGOING'
          )
        }
      } catch (error) {
        console.error('Error fetching test sessions:', error)
        testSessionError.value = 'Failed to load test sessions'
      } finally {
        loadingTestSessions.value = false
      }
    }

    // Fetch test centers  
    const fetchTestCenters = async () => {
      try {
        loadingTestCenters.value = true
        testCenterError.value = null
        const response = await axios.get('/api/admin/test-centers/')
        
        if (response.data && Array.isArray(response.data)) {
          testCenters.value = response.data.filter(center => center.is_active)
        }
      } catch (error) {
        console.error('Error fetching test centers:', error)
        testCenterError.value = 'Failed to load test centers'
      } finally {
        loadingTestCenters.value = false
      }
    }

    // Fetch test rooms
    const fetchTestRooms = async () => {
      try {
        loadingTestRooms.value = true
        testRoomError.value = null
        const response = await axios.get('/api/admin/test-rooms/')
        
        if (response.data && Array.isArray(response.data)) {
          testRooms.value = response.data.filter(room => room.is_active)
        }
      } catch (error) {
        console.error('Error fetching test rooms:', error)
        testRoomError.value = 'Failed to load test rooms'
      } finally {
        loadingTestRooms.value = false
      }
    }

    // Handle test center change
    const onTestCenterChange = () => {
      // Clear selected test room when test center changes
      form.value.testRoom = ''
    }

    // Format date for display
    const formatDate = (dateString) => {
      if (!dateString) return 'N/A'
      return new Date(dateString).toLocaleDateString()
    }

    // Initialize programs when modal opens
    onMounted(() => {
      fetchPrograms()
      fetchTestSessions()
      fetchTestCenters()
      fetchTestRooms()
    })

    // Methods
    const closeModal = () => {
      resetForm()
      emit('close')
    }

    const resetForm = () => {
      currentStep.value = 1
      form.value = {
        // Personal Information
        lastName: '',
        firstName: '',
        middleName: '',
        email: '',
        contactNumber: '',
        birthMonth: '',
        birthDay: '',
        birthYear: '',
        gender: '',
        age: null,
        streetPurok: '',
        barangay: '',
        city: '',
        citizenship: '',
        
        // Program and Appointment Details
        program: '',
        appointmentDate: '',
        timeSlot: '',
        applicantType: '',
        
        // WMSUCET Experience
        isFirstTime: true,
        timesTaken: 0,
        
        // School Information
        schoolName: '',
        schoolAddress: '',
        graduationDate: '',
        collegeLevel: '',
        collegeCourse: '',
        collegeType: '',
        
        // Test Assignment
        testSession: '',
        testCenter: '',
        testRoom: '',
        status: 'waiting_for_submission',
        notes: ''
      }
      errors.value = {}
      submitting.value = false
    }

    const validateStep1 = () => {
      errors.value = {}
      
      if (!form.value.lastName) {
        errors.value.lastName = 'Last name is required'
      }
      
      if (!form.value.firstName) {
        errors.value.firstName = 'First name is required'
      }
      
      if (!form.value.email) {
        errors.value.email = 'Email is required'
      } else if (!/\S+@\S+\.\S+/.test(form.value.email)) {
        errors.value.email = 'Please enter a valid email'
      }
      
      if (!form.value.contactNumber) {
        errors.value.contactNumber = 'Contact number is required'
      }
      
      if (!form.value.birthMonth || !form.value.birthDay || !form.value.birthYear) {
        errors.value.birthDate = 'Birth date is required'
      }
      
      if (!form.value.gender) {
        errors.value.gender = 'Gender is required'
      }
      
      if (!form.value.streetPurok) {
        errors.value.streetPurok = 'Street/Purok is required'
      }
      
      if (!form.value.barangay) {
        errors.value.barangay = 'Barangay is required'
      }
      
      if (!form.value.city) {
        errors.value.city = 'City is required'
      }
      
      if (!form.value.citizenship) {
        errors.value.citizenship = 'Citizenship is required'
      }
      
      if (!form.value.program) {
        errors.value.program = 'Program is required'
      }
      
      return Object.keys(errors.value).length === 0
    }

    const validateStep2 = () => {
      errors.value = {}
      
      if (!form.value.appointmentDate) {
        errors.value.appointmentDate = 'Appointment date is required'
      }
      
      if (!form.value.timeSlot) {
        errors.value.timeSlot = 'Time slot is required'
      }
      
      if (!form.value.applicantType) {
        errors.value.applicantType = 'Applicant type is required'
      }
      
      if (!form.value.schoolName) {
        errors.value.schoolName = 'School name is required'
      }
      
      if (!form.value.testSession) {
        errors.value.testSession = 'Test session is required'
      }
      
      if (!form.value.testCenter) {
        errors.value.testCenter = 'Test center is required'
      }
      
      if (!form.value.testRoom) {
        errors.value.testRoom = 'Test room is required'
      }
      
      if (!form.value.status) {
        errors.value.status = 'Status is required'
      }
      
      return Object.keys(errors.value).length === 0
    }

    const nextStep = () => {
      if (validateStep1()) {
        currentStep.value = 2
      }
    }

    const previousStep = () => {
      currentStep.value = 1
      errors.value = {}
    }

    const submitForm = async () => {
      if (!validateStep2()) {
        return
      }

      submitting.value = true
      
      try {
        // Prepare form data similar to ScheduleModal
        const homeAddressString = `${form.value.streetPurok}, ${form.value.barangay}, ${form.value.city}`.trim()
        const selectedProgram = programs.value.find(p => p.id === form.value.program)
        
        // Split into appointment creation data and test assignment data
        const appointmentData = {
          // Personal info
          full_name: `${form.value.lastName}, ${form.value.firstName} ${form.value.middleName}`.trim(),
          last_name: form.value.lastName.trim(),
          first_name: form.value.firstName.trim(),
          middle_name: form.value.middleName.trim(),
          contact_number: form.value.contactNumber,
          email: form.value.email,
          birth_month: form.value.birthMonth,
          birth_day: form.value.birthDay,
          birth_year: form.value.birthYear,
          gender: form.value.gender,
          age: parseInt(form.value.age),
          home_address: homeAddressString,
          street_purok: form.value.streetPurok,
          barangay: form.value.barangay,
          city: form.value.city,
          citizenship: form.value.citizenship,
          
          // WMSUCET experience
          is_first_time: form.value.isFirstTime,
          times_taken: form.value.isFirstTime ? 0 : parseInt(form.value.timesTaken) || 0,
          
          // Applicant type
          applicant_type: form.value.applicantType,
          
          // School info
          school_name: form.value.schoolName,
          school_address: form.value.schoolAddress || '',
          school_graduation_date: form.value.graduationDate || '',
          college_level: form.value.collegeLevel || '',
          college_course: form.value.collegeCourse || '',
          college_type: form.value.collegeType || '',
          
          // Appointment details
          program: form.value.program,
          preferred_date: form.value.appointmentDate,
          time_slot: form.value.timeSlot,
          status: form.value.status,
          notes: form.value.notes || null
        }

        // Test assignment data (separate from appointment creation)
        const testAssignmentData = {
          test_session_id: form.value.testSession || null,
          test_center_id: form.value.testCenter || null,
          test_room_id: form.value.testRoom || null
        }

        emit('submit', { appointmentData, testAssignmentData })
        
      } catch (error) {
        console.error('Error preparing form data:', error)
      } finally {
        submitting.value = false
      }
    }

    // Watch for modal visibility changes
    watch(() => props.visible, (newVal) => {
      if (newVal) {
        fetchPrograms()
        fetchTestSessions()
        fetchTestCenters()
        fetchTestRooms()
      } else {
        resetForm()
      }
    })

    return {
      currentStep,
      form,
      errors,
      submitting,
      loading,
      programs,
      testSessions,
      testCenters,
      testRooms,
      loadingTestSessions,
      loadingTestCenters,
      loadingTestRooms,
      testSessionError,
      testCenterError,
      testRoomError,
      minDate,
      computedAge,
      birthYears,
      filteredTestRooms,
      closeModal,
      nextStep,
      previousStep,
      submitForm,
      handleTextInput,
      onTestCenterChange,
      formatDate
    }
  }
}
</script>

<style scoped>
.text-crimson-600 {
  color: #DC2626;
}

.bg-crimson-600 {
  background-color: #DC2626;
}

.hover\:bg-crimson-700:hover {
  background-color: #B91C1C;
}

.focus\:ring-crimson-500:focus {
  --tw-ring-opacity: 1;
  --tw-ring-color: rgb(239 68 68 / var(--tw-ring-opacity));
}

.focus\:border-transparent:focus {
  border-color: transparent;
}
</style>
