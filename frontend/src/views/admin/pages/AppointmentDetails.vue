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
          <div class="flex flex-wrap items-center gap-3">
            <!-- Application Approve button for 'submitted' status -->
            <button v-if="canApproveSubmitted()"
                    @click="approveSubmittedApplication"
                    class="button button-success">
              <i class="fas fa-check-circle mr-2"></i>
              Application Approve
            </button>
            
            <button v-if="canApprove()"
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
            </button>            <button v-if="canMarkAsSubmitted()"
                    @click="markAsSubmitted"
                    class="button button-primary">
              <i class="fas fa-clipboard-check mr-2"></i>
              Mark as Submitted
            </button>
            
            <button v-if="canMarkAsClaimed()"
                    @click="markAsClaimed"
                    class="button button-primary">
              <i class="fas fa-check-double mr-2"></i>
              Mark as Claimed
            </button>
            <button v-if="canReschedule()"
                    @click="rescheduleAppointment"
                    class="button button-warning">
              <i class="fas fa-calendar-alt mr-2"></i>
              Reschedule
            </button>
            
            <!-- PDF Export Button -->
            <button @click="exportToPDF"
                    :disabled="exportingPDF"
                    class="button button-secondary">
              <i class="fas fa-file-pdf mr-2"></i>
              <span v-if="exportingPDF">Generating PDF...</span>
              <span v-else>Export PDF</span>
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
            
            <div v-if="appointment.exam_date">
              <label class="text-xs font-medium text-gray-500">Exam Date</label>
              <p class="mt-1 text-sm font-medium text-gray-900">
                {{ formatDate(appointment.exam_date) }}
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

        <!-- Applicant's Registration Schedule Details -->
        <div class="lg:col-span-3 bg-white rounded-lg border border-gray-200 shadow-sm">
          <div class="p-4 border-b border-gray-100">
            <h3 class="text-lg font-semibold text-gray-900 flex items-center">
              <i class="fas fa-user-calendar text-indigo-500 mr-2"></i>
              Applicant's Registration Schedule Details
            </h3>
            <p class="text-sm text-gray-600 mt-1">Details selected by the applicant during registration</p>
          </div>
          <div class="p-6">
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
              <!-- Preferred Date -->
              <div class="space-y-2">
                <div class="flex items-center gap-2">
                  <i class="fas fa-calendar text-indigo-500"></i>
                  <label class="text-xs font-medium text-gray-500">Preferred Date</label>
                </div>
                <p class="text-sm font-medium text-gray-900 bg-gray-50 p-3 rounded-lg">
                  {{ formatDate(appointment.preferred_date) }}
                </p>
              </div>
              
              <!-- Preferred Time Slot -->
              <div class="space-y-2">
                <div class="flex items-center gap-2">
                  <i class="fas fa-clock text-indigo-500"></i>
                  <label class="text-xs font-medium text-gray-500">Preferred Time Slot</label>
                </div>
                <p class="text-sm font-medium text-gray-900 bg-gray-50 p-3 rounded-lg">
                  {{ formatTimeSlot(appointment.time_slot) }}
                </p>
              </div>
              
              <!-- Selected Test Center -->
              <div class="space-y-2">
                <div class="flex items-center gap-2">
                  <i class="fas fa-building text-indigo-500"></i>
                  <label class="text-xs font-medium text-gray-500">Selected Test Center</label>
                </div>
                <p class="text-sm font-medium text-gray-900 bg-gray-50 p-3 rounded-lg">
                  {{ appointment.test_center_name || 'Not selected' }}
                </p>
              </div>
              
              <!-- Test Session -->
              <div class="space-y-2">
                <div class="flex items-center gap-2">
                  <i class="fas fa-graduation-cap text-indigo-500"></i>
                  <label class="text-xs font-medium text-gray-500">Selected Test Session</label>
                </div>
                <div class="bg-gray-50 p-3 rounded-lg space-y-1">
                  <p class="text-sm font-medium text-gray-900">
                    {{ appointment.test_session_name || 'Not selected' }}
                  </p>
                  <p v-if="appointment.test_session_exam_date" class="text-xs text-gray-600">
                    Exam Date: {{ formatDate(appointment.test_session_exam_date) }}
                  </p>
                </div>
              </div>
            </div>

            <!-- Test Session Registration Details -->
            <div v-if="appointment.test_session_registration_start || appointment.test_session_registration_end" 
                 class="mt-6 pt-4 border-t border-gray-200">
              <h4 class="text-sm font-medium text-gray-700 mb-3 flex items-center gap-2">
                <i class="fas fa-info-circle text-blue-500"></i>
                Test Session Registration Period
              </h4>
              <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div v-if="appointment.test_session_registration_start" class="space-y-1">
                  <label class="text-xs font-medium text-gray-500">Registration Start</label>
                  <p class="text-sm font-medium text-gray-900 bg-green-50 px-3 py-2 rounded border border-green-200">
                    {{ formatDate(appointment.test_session_registration_start) }}
                  </p>
                </div>
                <div v-if="appointment.test_session_registration_end" class="space-y-1">
                  <label class="text-xs font-medium text-gray-500">Registration End</label>
                  <p class="text-sm font-medium text-gray-900 bg-red-50 px-3 py-2 rounded border border-red-200">
                    {{ formatDate(appointment.test_session_registration_end) }}
                  </p>
                </div>
              </div>
            </div>

            <!-- Additional Test Session Info -->
            <div v-if="appointment.test_session_description" 
                 class="mt-6 pt-4 border-t border-gray-200">
              <h4 class="text-sm font-medium text-gray-700 mb-2 flex items-center gap-2">
                <i class="fas fa-file-alt text-gray-500"></i>
                Test Session Description
              </h4>
              <p class="text-sm text-gray-600 bg-blue-50 p-3 rounded-lg border border-blue-200">
                {{ appointment.test_session_description }}
              </p>
            </div>
          </div>
        </div>

        <!-- Automatic Assignment Status - Show when status is submitted and no test room assigned -->
        <div v-if="appointment && appointment.status === 'submitted' && !testDetails.test_room" 
             class="lg:col-span-3 bg-blue-50 rounded-lg border border-blue-200 shadow-sm">
          <div class="p-4 border-b border-blue-100">
            <h3 class="text-lg font-semibold text-blue-900 flex items-center">
              <i class="fas fa-robot text-blue-500 mr-2"></i>
              Automatic Test Room Assignment
            </h3>
          </div>
          
          <div class="p-6">
            <div class="flex items-center gap-4 text-blue-800">
              <i class="fas fa-info-circle text-blue-500"></i>
              <div>
                <p class="font-medium">Test room will be automatically assigned</p>
                <p class="text-sm text-blue-600 mt-1">
                  When you approve this application, the system will automatically assign an available test room 
                  based on the applicant's selected test center ({{ appointment.test_center ? testDetails.test_center?.name : 'Not selected' }}) 
                  and preferred time slot ({{ formatTimeSlot(appointment.time_slot) }}).
                </p>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Personal Information Section -->
      <div class="mt-6">
        <div class="bg-white rounded-lg border border-gray-200 shadow-sm">
          <div class="p-4 border-b border-gray-100">
            <h3 class="text-lg font-semibold text-gray-900 flex items-center">
              <i class="fas fa-id-card text-blue-500 mr-2"></i>
              Complete Personal Information
            </h3>
          </div>
          <div class="p-6">
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
              <!-- Basic Information -->
              <div class="space-y-4">
                <h4 class="font-medium text-gray-900 border-b pb-2">Basic Information</h4>
                <div>
                  <label class="text-xs font-medium text-gray-500">Last Name</label>
                  <p class="mt-1 text-sm font-medium text-gray-900">{{ appointment.last_name || 'N/A' }}</p>
                </div>
                <div>
                  <label class="text-xs font-medium text-gray-500">First Name</label>
                  <p class="mt-1 text-sm font-medium text-gray-900">{{ appointment.first_name || 'N/A' }}</p>
                </div>
                <div>
                  <label class="text-xs font-medium text-gray-500">Middle Name</label>
                  <p class="mt-1 text-sm font-medium text-gray-900">{{ appointment.middle_name || 'N/A' }}</p>
                </div>
                <div>
                  <label class="text-xs font-medium text-gray-500">Birth Date</label>
                  <p class="mt-1 text-sm font-medium text-gray-900">{{ formatBirthDate() }}</p>
                </div>
                <div>
                  <label class="text-xs font-medium text-gray-500">Age</label>
                  <p class="mt-1 text-sm font-medium text-gray-900">{{ appointment.age || 'N/A' }}</p>
                </div>
                <div>
                  <label class="text-xs font-medium text-gray-500">Gender</label>
                  <p class="mt-1 text-sm font-medium text-gray-900">{{ formatGender(appointment.gender) }}</p>
                </div>
              </div>

              <!-- Contact & Address -->
              <div class="space-y-4">
                <h4 class="font-medium text-gray-900 border-b pb-2">Contact & Address</h4>
                <div>
                  <label class="text-xs font-medium text-gray-500">Home Address</label>
                  <p class="mt-1 text-sm font-medium text-gray-900">{{ appointment.home_address || 'N/A' }}</p>
                </div>
                <div>
                  <label class="text-xs font-medium text-gray-500">Citizenship</label>
                  <p class="mt-1 text-sm font-medium text-gray-900">{{ appointment.citizenship || 'N/A' }}</p>
                </div>
                <div>
                  <label class="text-xs font-medium text-gray-500">High School Code</label>
                  <p class="mt-1 text-sm font-medium text-gray-900">{{ appointment.high_school_code || 'N/A' }}</p>
                </div>
              </div>

              <!-- WMSUCET Experience -->
              <div class="space-y-4">
                <h4 class="font-medium text-gray-900 border-b pb-2">WMSUCET Experience</h4>
                <div>
                  <label class="text-xs font-medium text-gray-500">First Time Taking WMSUCET</label>
                  <p class="mt-1 text-sm font-medium text-gray-900">{{ appointment.is_first_time ? 'Yes' : 'No' }}</p>
                </div>
                <div v-if="!appointment.is_first_time">
                  <label class="text-xs font-medium text-gray-500">Times Previously Taken</label>
                  <p class="mt-1 text-sm font-medium text-gray-900">{{ appointment.times_taken || 'N/A' }}</p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Educational Background Section -->
      <div class="mt-6">
        <div class="bg-white rounded-lg border border-gray-200 shadow-sm">
          <div class="p-4 border-b border-gray-100">
            <h3 class="text-lg font-semibold text-gray-900 flex items-center">
              <i class="fas fa-graduation-cap text-green-500 mr-2"></i>
              Educational Background
            </h3>
          </div>
          <div class="p-6">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
              <!-- Applicant Type -->
              <div class="space-y-4">
                <h4 class="font-medium text-gray-900 border-b pb-2">Applicant Type</h4>
                <div>
                  <label class="text-xs font-medium text-gray-500">Type</label>
                  <p class="mt-1 text-sm font-medium text-gray-900">
                    {{ appointment.applicant_type === 'senior_high_graduating' ? 'Senior High School Graduating Student' :
                       appointment.applicant_type === 'senior_high_graduate' ? 'Senior High School Graduate' :
                       appointment.applicant_type === 'college' ? 'College Student' : 'N/A' }}
                  </p>
                </div>
                <div v-if="appointment.school_graduation_date">
                  <label class="text-xs font-medium text-gray-500">Graduation Date</label>
                  <p class="mt-1 text-sm font-medium text-gray-900">{{ appointment.school_graduation_date }}</p>
                </div>
              </div>

              <!-- School Information -->
              <div class="space-y-4">
                <h4 class="font-medium text-gray-900 border-b pb-2">School Information</h4>
                <div>
                  <label class="text-xs font-medium text-gray-500">School Name</label>
                  <p class="mt-1 text-sm font-medium text-gray-900">{{ appointment.school_name || 'N/A' }}</p>
                </div>
                <div v-if="appointment.school_address">
                  <label class="text-xs font-medium text-gray-500">School Address</label>
                  <p class="mt-1 text-sm font-medium text-gray-900">{{ appointment.school_address }}</p>
                </div>
                <div v-if="appointment.school_type">
                  <label class="text-xs font-medium text-gray-500">School Type</label>
                  <p class="mt-1 text-sm font-medium text-gray-900">{{ appointment.school_type }}</p>
                </div>
                <div v-if="appointment.college_course">
                  <label class="text-xs font-medium text-gray-500">College Course</label>
                  <p class="mt-1 text-sm font-medium text-gray-900">{{ appointment.college_course }}</p>
                </div>
                <div v-if="appointment.college_type">
                  <label class="text-xs font-medium text-gray-500">College Type</label>
                  <p class="mt-1 text-sm font-medium text-gray-900">{{ appointment.college_type }}</p>
                </div>
                <div v-if="appointment.track_specialization">
                  <label class="text-xs font-medium text-gray-500">Track/Specialization</label>
                  <p class="mt-1 text-sm font-medium text-gray-900">{{ appointment.track_specialization }}</p>
                </div>
                <div v-if="appointment.grade_level">
                  <label class="text-xs font-medium text-gray-500">Grade Level</label>
                  <p class="mt-1 text-sm font-medium text-gray-900">{{ appointment.grade_level }}</p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Course Choices Section -->
      <div class="mt-6">
        <div class="bg-white rounded-lg border border-gray-200 shadow-sm">
          <div class="p-4 border-b border-gray-100">
            <h3 class="text-lg font-semibold text-gray-900 flex items-center">
              <i class="fas fa-list-ol text-purple-500 mr-2"></i>
              Course Choices
            </h3>
          </div>
          <div class="p-6">
            <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
              <!-- First Choice -->
              <div class="space-y-3">
                <h4 class="font-medium text-gray-900 border-b pb-2">1st Choice</h4>
                <div>
                  <label class="text-xs font-medium text-gray-500">Course</label>
                  <p class="mt-1 text-sm font-medium text-gray-900">{{ appointment.first_choice_course || 'N/A' }}</p>
                </div>
                <div>
                  <label class="text-xs font-medium text-gray-500">Campus</label>
                  <p class="mt-1 text-sm font-medium text-gray-900">{{ appointment.first_choice_campus || 'N/A' }}</p>
                </div>
              </div>

              <!-- Second Choice -->
              <div class="space-y-3">
                <h4 class="font-medium text-gray-900 border-b pb-2">2nd Choice</h4>
                <div>
                  <label class="text-xs font-medium text-gray-500">Course</label>
                  <p class="mt-1 text-sm font-medium text-gray-900">{{ appointment.second_choice_course || 'N/A' }}</p>
                </div>
                <div>
                  <label class="text-xs font-medium text-gray-500">Campus</label>
                  <p class="mt-1 text-sm font-medium text-gray-900">{{ appointment.second_choice_campus || 'N/A' }}</p>
                </div>
              </div>

              <!-- Third Choice -->
              <div class="space-y-3">
                <h4 class="font-medium text-gray-900 border-b pb-2">3rd Choice</h4>
                <div>
                  <label class="text-xs font-medium text-gray-500">Course</label>
                  <p class="mt-1 text-sm font-medium text-gray-900">{{ appointment.third_choice_course || 'N/A' }}</p>
                </div>
                <div>
                  <label class="text-xs font-medium text-gray-500">Campus</label>
                  <p class="mt-1 text-sm font-medium text-gray-900">{{ appointment.third_choice_campus || 'N/A' }}</p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Socio-Economic Data Section -->
      <div class="mt-6">
        <div class="bg-white rounded-lg border border-gray-200 shadow-sm">
          <div class="p-4 border-b border-gray-100">
            <h3 class="text-lg font-semibold text-gray-900 flex items-center">
              <i class="fas fa-users text-orange-500 mr-2"></i>
              Socio-Economic Data
            </h3>
          </div>
          <div class="p-6">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
              <!-- Father's Information -->
              <div class="space-y-4">
                <h4 class="font-medium text-blue-800 border-b border-blue-200 pb-2 flex items-center">
                  <i class="fas fa-male mr-2"></i>
                  Father's Information
                </h4>
                <div class="space-y-3">
                  <div>
                    <label class="text-xs font-medium text-gray-500">Citizenship</label>
                    <p class="mt-1 text-sm font-medium text-gray-900">{{ appointment.father_citizenship || 'N/A' }}</p>
                  </div>
                  <div>
                    <label class="text-xs font-medium text-gray-500">Highest Educational Attainment</label>
                    <p class="mt-1 text-sm font-medium text-gray-900">{{ appointment.father_education || 'N/A' }}</p>
                  </div>
                  <div>
                    <label class="text-xs font-medium text-gray-500">Work/Occupation</label>
                    <p class="mt-1 text-sm font-medium text-gray-900">{{ appointment.father_work_occupation || 'N/A' }}</p>
                  </div>
                  <div>
                    <label class="text-xs font-medium text-gray-500">Employer/Place of Work</label>
                    <p class="mt-1 text-sm font-medium text-gray-900">{{ appointment.father_employer || 'N/A' }}</p>
                  </div>
                  <div>
                    <label class="text-xs font-medium text-gray-500">Monthly Income/Salary</label>
                    <p class="mt-1 text-sm font-medium text-gray-900">{{ appointment.father_monthly_income || 'N/A' }}</p>
                  </div>
                </div>
              </div>

              <!-- Mother's Information -->
              <div class="space-y-4">
                <h4 class="font-medium text-pink-800 border-b border-pink-200 pb-2 flex items-center">
                  <i class="fas fa-female mr-2"></i>
                  Mother's Information
                </h4>
                <div class="space-y-3">
                  <div>
                    <label class="text-xs font-medium text-gray-500">Citizenship</label>
                    <p class="mt-1 text-sm font-medium text-gray-900">{{ appointment.mother_citizenship || 'N/A' }}</p>
                  </div>
                  <div>
                    <label class="text-xs font-medium text-gray-500">Highest Educational Attainment</label>
                    <p class="mt-1 text-sm font-medium text-gray-900">{{ appointment.mother_education || 'N/A' }}</p>
                  </div>
                  <div>
                    <label class="text-xs font-medium text-gray-500">Work/Occupation</label>
                    <p class="mt-1 text-sm font-medium text-gray-900">{{ appointment.mother_work_occupation || 'N/A' }}</p>
                  </div>
                  <div>
                    <label class="text-xs font-medium text-gray-500">Employer/Place of Work</label>
                    <p class="mt-1 text-sm font-medium text-gray-900">{{ appointment.mother_employer || 'N/A' }}</p>
                  </div>
                  <div>
                    <label class="text-xs font-medium text-gray-500">Monthly Income/Salary</label>
                    <p class="mt-1 text-sm font-medium text-gray-900">{{ appointment.mother_monthly_income || 'N/A' }}</p>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Additional Information Section -->
      <div class="mt-6">
        <div class="bg-white rounded-lg border border-gray-200 shadow-sm">
          <div class="p-4 border-b border-gray-100">
            <h3 class="text-lg font-semibold text-gray-900 flex items-center">
              <i class="fas fa-info-circle text-indigo-500 mr-2"></i>
              Additional Information
            </h3>
          </div>
          <div class="p-6">
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
              <!-- Disability Information -->
              <div class="space-y-3">
                <h4 class="font-medium text-gray-900 border-b pb-2">Disability & Special Needs</h4>
                <div>
                  <label class="text-xs font-medium text-gray-500">Has Physical Disability</label>
                  <p class="mt-1 text-sm font-medium text-gray-900">
                    {{ appointment.has_physical_disability ? 'Yes' : 'No' }}
                  </p>
                </div>
                <div v-if="appointment.has_physical_disability && appointment.disability_description">
                  <label class="text-xs font-medium text-gray-500">Disability Description</label>
                  <p class="mt-1 text-sm font-medium text-gray-900">{{ appointment.disability_description }}</p>
                </div>
              </div>

              <!-- Computer Skills & Indigenous Group -->
              <div class="space-y-3">
                <h4 class="font-medium text-gray-900 border-b pb-2">Skills & Background</h4>
                <div>
                  <label class="text-xs font-medium text-gray-500">Computer Usage Knowledge</label>
                  <p class="mt-1 text-sm font-medium text-gray-900">
                    {{ appointment.knows_computer_usage ? 'Yes' : 'No' }}
                  </p>
                </div>
                <div>
                  <label class="text-xs font-medium text-gray-500">Indigenous Peoples Group Member</label>
                  <p class="mt-1 text-sm font-medium text-gray-900">
                    {{ appointment.is_indigenous_member ? 'Yes' : 'No' }}
                  </p>
                </div>
                <div v-if="appointment.is_indigenous_member && appointment.indigenous_group_specify">
                  <label class="text-xs font-medium text-gray-500">Indigenous Group</label>
                  <p class="mt-1 text-sm font-medium text-gray-900">{{ appointment.indigenous_group_specify }}</p>
                </div>
              </div>

              <!-- Religious Affiliation -->
              <div class="space-y-3">
                <h4 class="font-medium text-gray-900 border-b pb-2">Religious Affiliation</h4>
                <div>
                  <label class="text-xs font-medium text-gray-500">Religion</label>
                  <p class="mt-1 text-sm font-medium text-gray-900">
                    {{ appointment.religious_affiliation === 'roman_catholic' ? 'Roman Catholic' :
                       appointment.religious_affiliation === 'protestant' ? 'Protestant' :
                       appointment.religious_affiliation === 'islam' ? 'Islam' :
                       appointment.religious_affiliation === 'others' ? 'Others' : 'N/A' }}
                  </p>
                </div>
                <div v-if="appointment.religious_affiliation === 'others' && appointment.religious_affiliation_others">
                  <label class="text-xs font-medium text-gray-500">Other Religion</label>
                  <p class="mt-1 text-sm font-medium text-gray-900">{{ appointment.religious_affiliation_others }}</p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Exam Score Section (if available) -->
      <div v-if="appointment.exam_score" class="mt-6">
        <div class="bg-white rounded-lg border border-gray-200 shadow-sm">
          <div class="p-4 border-b border-gray-100">
            <h3 class="text-lg font-semibold text-gray-900 flex items-center">
              <i class="fas fa-chart-line text-green-500 mr-2"></i>
              Exam Results
            </h3>
          </div>
          <div class="p-6">
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
              <div>
                <label class="text-xs font-medium text-gray-500">Overall Score</label>
                <p class="mt-1 text-lg font-bold text-green-600">{{ appointment.exam_score.score || 'N/A' }}</p>
              </div>
              <div>
                <label class="text-xs font-medium text-gray-500">OAPR (Overall Ability Percentile Rank)</label>
                <p class="mt-1 text-lg font-bold text-blue-600">{{ appointment.exam_score.oapr || 'N/A' }}</p>
              </div>
              <div>
                <label class="text-xs font-medium text-gray-500">Exam Date</label>
                <p class="mt-1 text-sm font-medium text-gray-900">
                  {{ appointment.exam_score.exam_date ? formatDate(appointment.exam_score.exam_date) : 'N/A' }}
                </p>
              </div>
            </div>
            
            <!-- Test Parts Breakdown -->
            <div class="mt-6">
              <h4 class="font-medium text-gray-900 border-b pb-2 mb-4">Test Parts Breakdown</h4>
              <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-5 gap-4">
                <div v-if="appointment.exam_score.part1">
                  <label class="text-xs font-medium text-gray-500">English Proficiency</label>
                  <p class="mt-1 text-sm font-bold text-gray-900">{{ appointment.exam_score.part1 }}</p>
                </div>
                <div v-if="appointment.exam_score.part2">
                  <label class="text-xs font-medium text-gray-500">Reading Comprehension</label>
                  <p class="mt-1 text-sm font-bold text-gray-900">{{ appointment.exam_score.part2 }}</p>
                </div>
                <div v-if="appointment.exam_score.part3">
                  <label class="text-xs font-medium text-gray-500">Science Process Skills</label>
                  <p class="mt-1 text-sm font-bold text-gray-900">{{ appointment.exam_score.part3 }}</p>
                </div>
                <div v-if="appointment.exam_score.part4">
                  <label class="text-xs font-medium text-gray-500">Quantitative Skills</label>
                  <p class="mt-1 text-sm font-bold text-gray-900">{{ appointment.exam_score.part4 }}</p>
                </div>
                <div v-if="appointment.exam_score.part5">
                  <label class="text-xs font-medium text-gray-500">Abstract Thinking Skills</label>
                  <p class="mt-1 text-sm font-bold text-gray-900">{{ appointment.exam_score.part5 }}</p>
                </div>
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
import jsPDF from 'jspdf'
import html2canvas from 'html2canvas'

export default {
  name: 'AppointmentDetails',
  props: {
    id: {
      type: [Number, String],
      required: false
    }
  },
  setup(props) {
    const route = useRoute()
    const router = useRouter()
    const { showToast } = useToast()
    
    const appointmentId = ref(route.params.id)
    const appointment = ref(null)
    const testDetails = ref({})
    const loading = ref(true)
    const error = ref(null)
    
    // PDF export state
    const exportingPDF = ref(false)
    
    // Check if the assigned time slot matches the preferred time slot
    const timeSlotsMatch = computed(() => {
      if (!appointment.value) return true
      if (!appointment.value.assigned_test_time_slot) return true
      return appointment.value.assigned_test_time_slot === appointment.value.time_slot
    })
    
    const fetchAppointmentDetails = async () => {
      loading.value = true
      error.value = null
      console.log('Fetching appointment details for ID:', appointmentId.value)
      
      try {
        const response = await axiosInstance.get(`/api/appointments/${appointmentId.value}/`)
        console.log('Appointment API response status:', response.data.status)
        appointment.value = response.data
        
        // Fetch test details if available
        if (appointment.value) {
          console.log('After assignment and fetching - Appointment status:', appointment.value?.status)
          await fetchTestDetails()
        }
      } catch (err) {
        console.error('Error fetching appointment details:', err)
        error.value = 'Failed to load appointment details'
      } finally {
        loading.value = false
      }
    }
    
    const fetchTestDetails = async () => {
      try {
        const response = await axiosInstance.get(`/api/appointments/${appointmentId.value}/test-details/`)
        testDetails.value = response.data
        console.log('Test details loaded:', testDetails.value)
      } catch (err) {
        console.error('Failed to load test details:', err)
        // Don't set this as an error since test details might not exist yet
        testDetails.value = {}
      }
    }
    
    const goBack = () => {
      router.push('/admin/appointments')
    }
    
    // Status actions
    const canApprove = () => {
      return appointment.value?.status === 'pending'
    }
    
    const canApproveSubmitted = () => {
      return appointment.value?.status === 'submitted'
    }
    
    const canReject = () => {
      return ['pending', 'waiting_for_test_details', 'waiting_for_submission'].includes(appointment.value?.status)
    }
    
    const canMarkAsSubmitted = () => {
      return appointment.value?.status === 'waiting_for_submission'
    }
    
    const canMarkAsClaimed = () => {
      return appointment.value?.status === 'approved'
    }
    
    const canReschedule = () => {
      return ['pending', 'waiting_for_test_details', 'waiting_for_submission'].includes(appointment.value?.status)
    }
    
    const canSetWaitingForClaiming = () => {
      return appointment.value?.status === 'submitted'
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
    
    const approveSubmittedApplication = async () => {
      try {
        // First approve the application
        const response = await axiosInstance.post(`/api/appointments/${appointment.value.id}/update-status/`, {
          status: 'approved'
        })
        
        if (response.data.success) {
          appointment.value.status = 'approved'
          
          // Then automatically assign test room if not already assigned
          if (!appointment.value.test_room) {
            try {
              const autoAssignResponse = await axiosInstance.post('/api/admin/auto-assign/', {
                appointment_id: appointment.value.id
              })
              
              if (autoAssignResponse.data.success) {
                showToast(`Application approved and automatically assigned to ${autoAssignResponse.data.assignment.test_room.name}`, 'success')
                // Refresh the appointment details to show the new assignment
                fetchAppointmentDetails()
              } else {
                showToast('Application approved, but auto-assignment failed', 'warning')
              }
            } catch (autoAssignErr) {
              console.error('Auto-assignment failed:', autoAssignErr)
              showToast('Application approved, but auto-assignment failed. Please assign manually if needed.', 'warning')
            }
          } else {
            showToast('Application approved successfully', 'success')
          }
        }
      } catch (error) {
        showToast('Failed to approve application: ' + (error.response?.data?.error || error.message), 'error')
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
    
    const markAsSubmitted = async () => {
      try {
        // First update the status to submitted
        await axiosInstance.post('/api/admin/update-appointment-status/', {
          appointment_ids: [appointmentId.value],
          new_status: 'submitted'
        })
        
        // Then automatically assign test room based on selected test center and session
        try {
          const autoAssignResponse = await axiosInstance.post('/api/admin/auto-assign/', {
            appointment_id: appointmentId.value
          })
          
          if (autoAssignResponse.data.success) {
            showToast(`Appointment marked as submitted and automatically assigned to ${autoAssignResponse.data.assignment.test_room.name}`, 'success')
          } else {
            showToast('Appointment marked as submitted, but auto-assignment failed', 'warning')
          }
        } catch (autoAssignErr) {
          console.error('Auto-assignment failed:', autoAssignErr)
          showToast('Appointment marked as submitted, but auto-assignment failed. Please assign manually if needed.', 'warning')
        }
        
        fetchAppointmentDetails()
      } catch (err) {
        showToast('Failed to update status', 'error')
        console.error('Error updating status:', err)
      }
    }
    
    const markAsClaimed = async () => {
      try {
        const response = await axiosInstance.post(`/api/appointments/${appointment.value.id}/update-status/`, {
          status: 'claimed'
        })
        
        if (response.data.success) {
          appointment.value.status = 'claimed'
          showToast('Appointment marked as claimed successfully', 'success')
        }
      } catch (error) {
        showToast('Failed to mark as claimed: ' + (error.response?.data?.error || error.message), 'error')
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
    
    const setWaitingForClaiming = async () => {
      try {
        const response = await axiosInstance.post(`/api/appointments/${appointment.value.id}/update-status/`, {
          status: 'waiting_for_claiming'
        })
        
        if (response.data.success) {
          appointment.value.status = 'waiting_for_claiming'
          showToast('Status updated successfully', 'success')
        }
      } catch (error) {
        showToast('Failed to update status: ' + (error.response?.data?.error || error.message), 'error')
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
    
    // PDF Export function
    const exportToPDF = async () => {
      if (!appointment.value) {
        showToast('No appointment data to export', 'error')
        return
      }
      
      exportingPDF.value = true
      
      try {
        // Create a temporary container for PDF content
        const tempElement = document.createElement('div')
        tempElement.style.position = 'absolute'
        tempElement.style.left = '-9999px'
        tempElement.style.top = '0'
        tempElement.style.width = '210mm' // A4 width
        tempElement.style.padding = '20px'
        tempElement.style.backgroundColor = 'white'
        tempElement.style.fontFamily = 'Arial, sans-serif'
        tempElement.style.fontSize = '12px'
        tempElement.style.lineHeight = '1.4'
        
        // Format religious affiliation
        const formatReligiousAffiliation = (affiliation, other) => {
          if (!affiliation) return 'N/A'
          if (affiliation === 'roman_catholic') return 'Roman Catholic'
          if (affiliation === 'protestant') return 'Protestant'
          if (affiliation === 'islam') return 'Islam'
          if (affiliation === 'others') return other || 'Others'
          return affiliation
        }
        
        // Format applicant type
        const formatApplicantType = (type) => {
          if (type === 'senior_high_graduating') return 'Senior High School Graduating Student'
          if (type === 'senior_high_graduate') return 'Senior High School Graduate'
          if (type === 'college') return 'College Student'
          return type || 'N/A'
        }
        
        // Generate PDF content
        tempElement.innerHTML = `
          <div style="text-align: center; margin-bottom: 30px; border-bottom: 2px solid #DC2626; padding-bottom: 20px;">
            <h1 style="color: #DC2626; margin: 0; font-size: 24px; font-weight: bold;">
              Western Mindanao State University
            </h1>
            <h2 style="color: #666; margin: 5px 0 0 0; font-size: 18px;">
              Testing and Evaluation Center (TEC)
            </h2>
            <h3 style="color: #666; margin: 5px 0 0 0; font-size: 16px;">
              Applicant Details Report
            </h3>
          </div>
          
          <div style="margin-bottom: 25px;">
            <h3 style="background-color: #DC2626; color: white; padding: 8px; margin: 0 0 15px 0; font-size: 14px;">
              Basic Information
            </h3>
            <table style="width: 100%; border-collapse: collapse;">
              <tr>
                <td style="padding: 6px; border: 1px solid #ddd; font-weight: bold; width: 30%;">Full Name:</td>
                <td style="padding: 6px; border: 1px solid #ddd;">${appointment.value.full_name || 'N/A'}</td>
              </tr>
              <tr>
                <td style="padding: 6px; border: 1px solid #ddd; font-weight: bold;">Last Name:</td>
                <td style="padding: 6px; border: 1px solid #ddd;">${appointment.value.last_name || 'N/A'}</td>
              </tr>
              <tr>
                <td style="padding: 6px; border: 1px solid #ddd; font-weight: bold;">First Name:</td>
                <td style="padding: 6px; border: 1px solid #ddd;">${appointment.value.first_name || 'N/A'}</td>
              </tr>
              <tr>
                <td style="padding: 6px; border: 1px solid #ddd; font-weight: bold;">Middle Name:</td>
                <td style="padding: 6px; border: 1px solid #ddd;">${appointment.value.middle_name || 'N/A'}</td>
              </tr>
              <tr>
                <td style="padding: 6px; border: 1px solid #ddd; font-weight: bold;">Birth Date:</td>
                <td style="padding: 6px; border: 1px solid #ddd;">${formatBirthDate()}</td>
              </tr>
              <tr>
                <td style="padding: 6px; border: 1px solid #ddd; font-weight: bold;">Age:</td>
                <td style="padding: 6px; border: 1px solid #ddd;">${appointment.value.age || 'N/A'}</td>
              </tr>
              <tr>
                <td style="padding: 6px; border: 1px solid #ddd; font-weight: bold;">Gender:</td>
                <td style="padding: 6px; border: 1px solid #ddd;">${formatGender(appointment.value.gender)}</td>
              </tr>
              <tr>
                <td style="padding: 6px; border: 1px solid #ddd; font-weight: bold;">Email:</td>
                <td style="padding: 6px; border: 1px solid #ddd;">${appointment.value.email || 'N/A'}</td>
              </tr>
              <tr>
                <td style="padding: 6px; border: 1px solid #ddd; font-weight: bold;">Contact Number:</td>
                <td style="padding: 6px; border: 1px solid #ddd;">${appointment.value.contact_number || 'N/A'}</td>
              </tr>
              <tr>
                <td style="padding: 6px; border: 1px solid #ddd; font-weight: bold;">Home Address:</td>
                <td style="padding: 6px; border: 1px solid #ddd;">${appointment.value.home_address || 'N/A'}</td>
              </tr>
              <tr>
                <td style="padding: 6px; border: 1px solid #ddd; font-weight: bold;">Citizenship:</td>
                <td style="padding: 6px; border: 1px solid #ddd;">${appointment.value.citizenship || 'N/A'}</td>
              </tr>
            </table>
          </div>
          
          <div style="margin-bottom: 25px;">
            <h3 style="background-color: #DC2626; color: white; padding: 8px; margin: 0 0 15px 0; font-size: 14px;">
              Educational Background
            </h3>
            <table style="width: 100%; border-collapse: collapse;">
              <tr>
                <td style="padding: 6px; border: 1px solid #ddd; font-weight: bold; width: 30%;">Program:</td>
                <td style="padding: 6px; border: 1px solid #ddd;">${appointment.value.program_name || 'N/A'}</td>
              </tr>
              <tr>
                <td style="padding: 6px; border: 1px solid #ddd; font-weight: bold;">School Name:</td>
                <td style="padding: 6px; border: 1px solid #ddd;">${appointment.value.school_name || 'N/A'}</td>
              </tr>
              <tr>
                <td style="padding: 6px; border: 1px solid #ddd; font-weight: bold;">School Address:</td>
                <td style="padding: 6px; border: 1px solid #ddd;">${appointment.value.school_address || 'N/A'}</td>
              </tr>
              <tr>
                <td style="padding: 6px; border: 1px solid #ddd; font-weight: bold;">High School Code:</td>
                <td style="padding: 6px; border: 1px solid #ddd;">${appointment.value.high_school_code || 'N/A'}</td>
              </tr>
              <tr>
                <td style="padding: 6px; border: 1px solid #ddd; font-weight: bold;">Applicant Type:</td>
                <td style="padding: 6px; border: 1px solid #ddd;">${formatApplicantType(appointment.value.applicant_type)}</td>
              </tr>
              <tr>
                <td style="padding: 6px; border: 1px solid #ddd; font-weight: bold;">Graduation Date:</td>
                <td style="padding: 6px; border: 1px solid #ddd;">${appointment.value.school_graduation_date || 'N/A'}</td>
              </tr>
              <tr>
                <td style="padding: 6px; border: 1px solid #ddd; font-weight: bold;">College Course:</td>
                <td style="padding: 6px; border: 1px solid #ddd;">${appointment.value.college_course || 'N/A'}</td>
              </tr>
              <tr>
                <td style="padding: 6px; border: 1px solid #ddd; font-weight: bold;">College Type:</td>
                <td style="padding: 6px; border: 1px solid #ddd;">${appointment.value.college_type || 'N/A'}</td>
              </tr>
            </table>
          </div>
          
          <div style="margin-bottom: 25px;">
            <h3 style="background-color: #DC2626; color: white; padding: 8px; margin: 0 0 15px 0; font-size: 14px;">
              Course Choices
            </h3>
            <table style="width: 100%; border-collapse: collapse;">
              <tr>
                <td style="padding: 6px; border: 1px solid #ddd; font-weight: bold; width: 30%;">1st Choice Course:</td>
                <td style="padding: 6px; border: 1px solid #ddd;">${appointment.value.first_choice_course || 'N/A'}</td>
              </tr>
              <tr>
                <td style="padding: 6px; border: 1px solid #ddd; font-weight: bold;">1st Choice Campus:</td>
                <td style="padding: 6px; border: 1px solid #ddd;">${appointment.value.first_choice_campus || 'N/A'}</td>
              </tr>
              <tr>
                <td style="padding: 6px; border: 1px solid #ddd; font-weight: bold;">2nd Choice Course:</td>
                <td style="padding: 6px; border: 1px solid #ddd;">${appointment.value.second_choice_course || 'N/A'}</td>
              </tr>
              <tr>
                <td style="padding: 6px; border: 1px solid #ddd; font-weight: bold;">2nd Choice Campus:</td>
                <td style="padding: 6px; border: 1px solid #ddd;">${appointment.value.second_choice_campus || 'N/A'}</td>
              </tr>
              <tr>
                <td style="padding: 6px; border: 1px solid #ddd; font-weight: bold;">3rd Choice Course:</td>
                <td style="padding: 6px; border: 1px solid #ddd;">${appointment.value.third_choice_course || 'N/A'}</td>
              </tr>
              <tr>
                <td style="padding: 6px; border: 1px solid #ddd; font-weight: bold;">3rd Choice Campus:</td>
                <td style="padding: 6px; border: 1px solid #ddd;">${appointment.value.third_choice_campus || 'N/A'}</td>
              </tr>
            </table>
          </div>
          
          <div style="margin-bottom: 25px;">
            <h3 style="background-color: #DC2626; color: white; padding: 8px; margin: 0 0 15px 0; font-size: 14px;">
              WMSUCET Experience
            </h3>
            <table style="width: 100%; border-collapse: collapse;">
              <tr>
                <td style="padding: 6px; border: 1px solid #ddd; font-weight: bold; width: 30%;">First Time Taking WMSUCET:</td>
                <td style="padding: 6px; border: 1px solid #ddd;">${appointment.value.is_first_time ? 'Yes' : 'No'}</td>
              </tr>
              ${!appointment.value.is_first_time ? `
              <tr>
                <td style="padding: 6px; border: 1px solid #ddd; font-weight: bold;">Times Previously Taken:</td>
                <td style="padding: 6px; border: 1px solid #ddd;">${appointment.value.times_taken || 'N/A'}</td>
              </tr>
              ` : ''}
            </table>
          </div>
          
          <div style="margin-bottom: 25px;">
            <h3 style="background-color: #DC2626; color: white; padding: 8px; margin: 0 0 15px 0; font-size: 14px;">
              Socio-Economic Data
            </h3>
            <h4 style="color: #2563EB; margin: 15px 0 10px 0; font-size: 13px;">Father's Information</h4>
            <table style="width: 100%; border-collapse: collapse; margin-bottom: 15px;">
              <tr>
                <td style="padding: 6px; border: 1px solid #ddd; font-weight: bold; width: 30%;">Citizenship:</td>
                <td style="padding: 6px; border: 1px solid #ddd;">${appointment.value.father_citizenship || 'N/A'}</td>
              </tr>
              <tr>
                <td style="padding: 6px; border: 1px solid #ddd; font-weight: bold;">Education:</td>
                <td style="padding: 6px; border: 1px solid #ddd;">${appointment.value.father_education || 'N/A'}</td>
              </tr>
              <tr>
                <td style="padding: 6px; border: 1px solid #ddd; font-weight: bold;">Occupation:</td>
                <td style="padding: 6px; border: 1px solid #ddd;">${appointment.value.father_work_occupation || 'N/A'}</td>
              </tr>
              <tr>
                <td style="padding: 6px; border: 1px solid #ddd; font-weight: bold;">Employer:</td>
                <td style="padding: 6px; border: 1px solid #ddd;">${appointment.value.father_employer || 'N/A'}</td>
              </tr>
              <tr>
                <td style="padding: 6px; border: 1px solid #ddd; font-weight: bold;">Monthly Income:</td>
                <td style="padding: 6px; border: 1px solid #ddd;">${appointment.value.father_monthly_income || 'N/A'}</td>
              </tr>
            </table>
            
            <h4 style="color: #EC4899; margin: 15px 0 10px 0; font-size: 13px;">Mother's Information</h4>
            <table style="width: 100%; border-collapse: collapse;">
              <tr>
                <td style="padding: 6px; border: 1px solid #ddd; font-weight: bold; width: 30%;">Citizenship:</td>
                <td style="padding: 6px; border: 1px solid #ddd;">${appointment.value.mother_citizenship || 'N/A'}</td>
              </tr>
              <tr>
                <td style="padding: 6px; border: 1px solid #ddd; font-weight: bold;">Education:</td>
                <td style="padding: 6px; border: 1px solid #ddd;">${appointment.value.mother_education || 'N/A'}</td>
              </tr>
              <tr>
                <td style="padding: 6px; border: 1px solid #ddd; font-weight: bold;">Occupation:</td>
                <td style="padding: 6px; border: 1px solid #ddd;">${appointment.value.mother_work_occupation || 'N/A'}</td>
              </tr>
              <tr>
                <td style="padding: 6px; border: 1px solid #ddd; font-weight: bold;">Employer:</td>
                <td style="padding: 6px; border: 1px solid #ddd;">${appointment.value.mother_employer || 'N/A'}</td>
              </tr>
              <tr>
                <td style="padding: 6px; border: 1px solid #ddd; font-weight: bold;">Monthly Income:</td>
                <td style="padding: 6px; border: 1px solid #ddd;">${appointment.value.mother_monthly_income || 'N/A'}</td>
              </tr>
            </table>
          </div>
          
          <div style="margin-bottom: 25px;">
            <h3 style="background-color: #DC2626; color: white; padding: 8px; margin: 0 0 15px 0; font-size: 14px;">
              Additional Information
            </h3>
            <table style="width: 100%; border-collapse: collapse;">
              <tr>
                <td style="padding: 6px; border: 1px solid #ddd; font-weight: bold; width: 30%;">Physical Disability:</td>
                <td style="padding: 6px; border: 1px solid #ddd;">${appointment.value.has_physical_disability ? 'Yes' : 'No'}</td>
              </tr>
              ${appointment.value.has_physical_disability && appointment.value.disability_description ? `
              <tr>
                <td style="padding: 6px; border: 1px solid #ddd; font-weight: bold;">Disability Description:</td>
                <td style="padding: 6px; border: 1px solid #ddd;">${appointment.value.disability_description}</td>
              </tr>
              ` : ''}
              <tr>
                <td style="padding: 6px; border: 1px solid #ddd; font-weight: bold;">Computer Usage Knowledge:</td>
                <td style="padding: 6px; border: 1px solid #ddd;">${appointment.value.knows_computer_usage ? 'Yes' : 'No'}</td>
              </tr>
              <tr>
                <td style="padding: 6px; border: 1px solid #ddd; font-weight: bold;">Indigenous Peoples Group Member:</td>
                <td style="padding: 6px; border: 1px solid #ddd;">${appointment.value.is_indigenous_member ? 'Yes' : 'No'}</td>
              </tr>
              ${appointment.value.is_indigenous_member && appointment.value.indigenous_group_specify ? `
              <tr>
                <td style="padding: 6px; border: 1px solid #ddd; font-weight: bold;">Indigenous Group:</td>
                <td style="padding: 6px; border: 1px solid #ddd;">${appointment.value.indigenous_group_specify}</td>
              </tr>
              ` : ''}
              <tr>
                <td style="padding: 6px; border: 1px solid #ddd; font-weight: bold;">Religious Affiliation:</td>
                <td style="padding: 6px; border: 1px solid #ddd;">${formatReligiousAffiliation(appointment.value.religious_affiliation, appointment.value.religious_affiliation_others)}</td>
              </tr>
            </table>
          </div>
          
          <div style="margin-bottom: 25px;">
            <h3 style="background-color: #DC2626; color: white; padding: 8px; margin: 0 0 15px 0; font-size: 14px;">
              Applicant's Registration Schedule Details
            </h3>
            <table style="width: 100%; border-collapse: collapse;">
              <tr>
                <td style="padding: 6px; border: 1px solid #ddd; font-weight: bold; width: 30%;">Preferred Date:</td>
                <td style="padding: 6px; border: 1px solid #ddd;">${formatDate(appointment.value.preferred_date)}</td>
              </tr>
              <tr>
                <td style="padding: 6px; border: 1px solid #ddd; font-weight: bold;">Preferred Time Slot:</td>
                <td style="padding: 6px; border: 1px solid #ddd;">${formatTimeSlot(appointment.value.time_slot)}</td>
              </tr>
              <tr>
                <td style="padding: 6px; border: 1px solid #ddd; font-weight: bold;">Selected Test Center:</td>
                <td style="padding: 6px; border: 1px solid #ddd;">${appointment.value.test_center_name || 'Not selected'}</td>
              </tr>
              <tr>
                <td style="padding: 6px; border: 1px solid #ddd; font-weight: bold;">Test Session:</td>
                <td style="padding: 6px; border: 1px solid #ddd;">${appointment.value.test_session_name || 'Not selected'}</td>
              </tr>
              ${appointment.value.test_session_exam_date ? `
              <tr>
                <td style="padding: 6px; border: 1px solid #ddd; font-weight: bold;">Test Session Exam Date:</td>
                <td style="padding: 6px; border: 1px solid #ddd;">${formatDate(appointment.value.test_session_exam_date)}</td>
              </tr>
              ` : ''}
              ${appointment.value.test_session_registration_start ? `
              <tr>
                <td style="padding: 6px; border: 1px solid #ddd; font-weight: bold;">Registration Start:</td>
                <td style="padding: 6px; border: 1px solid #ddd;">${formatDate(appointment.value.test_session_registration_start)}</td>
              </tr>
              ` : ''}
              ${appointment.value.test_session_registration_end ? `
              <tr>
                <td style="padding: 6px; border: 1px solid #ddd; font-weight: bold;">Registration End:</td>
                <td style="padding: 6px; border: 1px solid #ddd;">${formatDate(appointment.value.test_session_registration_end)}</td>
              </tr>
              ` : ''}
              ${appointment.value.test_session_description ? `
              <tr>
                <td style="padding: 6px; border: 1px solid #ddd; font-weight: bold;">Test Session Description:</td>
                <td style="padding: 6px; border: 1px solid #ddd;">${appointment.value.test_session_description}</td>
              </tr>
              ` : ''}
            </table>
          </div>
          
          <div style="margin-bottom: 25px;">
            <h3 style="background-color: #DC2626; color: white; padding: 8px; margin: 0 0 15px 0; font-size: 14px;">
              Test Schedule Information
            </h3>
            <table style="width: 100%; border-collapse: collapse;">
              <tr>
                <td style="padding: 6px; border: 1px solid #ddd; font-weight: bold; width: 30%;">Preferred Date:</td>
                <td style="padding: 6px; border: 1px solid #ddd;">${formatDate(appointment.value.preferred_date)}</td>
              </tr>
              <tr>
                <td style="padding: 6px; border: 1px solid #ddd; font-weight: bold;">Preferred Time Slot:</td>
                <td style="padding: 6px; border: 1px solid #ddd;">${formatTimeSlot(appointment.value.time_slot)}</td>
              </tr>
              <tr>
                <td style="padding: 6px; border: 1px solid #ddd; font-weight: bold;">Status:</td>
                <td style="padding: 6px; border: 1px solid #ddd;">${formatStatus(appointment.value.status)}</td>
              </tr>
              ${appointment.value.assigned_test_time_slot ? `
              <tr>
                <td style="padding: 6px; border: 1px solid #ddd; font-weight: bold;">Assigned Time Slot:</td>
                <td style="padding: 6px; border: 1px solid #ddd;">${formatTimeSlot(appointment.value.assigned_test_time_slot)}</td>
              </tr>
              ` : ''}
              ${appointment.value.exam_date ? `
              <tr>
                <td style="padding: 6px; border: 1px solid #ddd; font-weight: bold;">Exam Date:</td>
                <td style="padding: 6px; border: 1px solid #ddd;">${formatDate(appointment.value.exam_date)}</td>
              </tr>
              ` : ''}
              ${testDetails.value.test_center ? `
              <tr>
                <td style="padding: 6px; border: 1px solid #ddd; font-weight: bold;">Test Center:</td>
                <td style="padding: 6px; border: 1px solid #ddd;">${testDetails.value.test_center.name || testDetails.value.test_center.center_name}</td>
              </tr>
              ` : ''}
              ${testDetails.value.test_room ? `
              <tr>
                <td style="padding: 6px; border: 1px solid #ddd; font-weight: bold;">Test Room:</td>
                <td style="padding: 6px; border: 1px solid #ddd;">${testDetails.value.test_room.name || testDetails.value.test_room.room_name || testDetails.value.test_room.number}</td>
              </tr>
              ` : ''}
            </table>
          </div>
          
          ${appointment.value.exam_score ? `
          <div style="margin-bottom: 25px;">
            <h3 style="background-color: #DC2626; color: white; padding: 8px; margin: 0 0 15px 0; font-size: 14px;">
              Exam Results
            </h3>
            <table style="width: 100%; border-collapse: collapse;">
              <tr>
                <td style="padding: 6px; border: 1px solid #ddd; font-weight: bold; width: 30%;">Overall Score:</td>
                <td style="padding: 6px; border: 1px solid #ddd; color: #059669; font-weight: bold;">${appointment.value.exam_score.score || 'N/A'}</td>
              </tr>
              <tr>
                <td style="padding: 6px; border: 1px solid #ddd; font-weight: bold;">OAPR:</td>
                <td style="padding: 6px; border: 1px solid #ddd; color: #2563EB; font-weight: bold;">${appointment.value.exam_score.oapr || 'N/A'}</td>
              </tr>
              <tr>
                <td style="padding: 6px; border: 1px solid #ddd; font-weight: bold;">English Proficiency:</td>
                <td style="padding: 6px; border: 1px solid #ddd;">${appointment.value.exam_score.part1 || 'N/A'}</td>
              </tr>
              <tr>
                <td style="padding: 6px; border: 1px solid #ddd; font-weight: bold;">Reading Comprehension:</td>
                <td style="padding: 6px; border: 1px solid #ddd;">${appointment.value.exam_score.part2 || 'N/A'}</td>
              </tr>
              <tr>
                <td style="padding: 6px; border: 1px solid #ddd; font-weight: bold;">Science Process Skills:</td>
                <td style="padding: 6px; border: 1px solid #ddd;">${appointment.value.exam_score.part3 || 'N/A'}</td>
              </tr>
              <tr>
                <td style="padding: 6px; border: 1px solid #ddd; font-weight: bold;">Quantitative Skills:</td>
                <td style="padding: 6px; border: 1px solid #ddd;">${appointment.value.exam_score.part4 || 'N/A'}</td>
              </tr>
              <tr>
                <td style="padding: 6px; border: 1px solid #ddd; font-weight: bold;">Abstract Thinking Skills:</td>
                <td style="padding: 6px; border: 1px solid #ddd;">${appointment.value.exam_score.part5 || 'N/A'}</td>
              </tr>
              <tr>
                <td style="padding: 6px; border: 1px solid #ddd; font-weight: bold;">Exam Date:</td>
                <td style="padding: 6px; border: 1px solid #ddd;">${appointment.value.exam_score.exam_date ? formatDate(appointment.value.exam_score.exam_date) : 'N/A'}</td>
              </tr>
            </table>
          </div>
          ` : ''}
          
          <div style="margin-top: 30px; text-align: center; font-size: 11px; color: #666; border-top: 1px solid #ddd; padding-top: 15px;">
            <p>Generated on ${new Date().toLocaleDateString('en-US', { 
              year: 'numeric', 
              month: 'long', 
              day: 'numeric',
              hour: '2-digit',
              minute: '2-digit'
            })}</p>
            <p>Western Mindanao State University - Testing and Evaluation Center</p>
          </div>
        `
        
        document.body.appendChild(tempElement)
        
        // Convert to canvas
        const canvas = await html2canvas(tempElement, {
          scale: 2,
          useCORS: true,
          allowTaint: true,
          backgroundColor: '#ffffff',
          width: tempElement.scrollWidth,
          height: tempElement.scrollHeight
        })
        
        // Remove temporary element
        document.body.removeChild(tempElement)
        
        // Create PDF
        const imgData = canvas.toDataURL('image/png')
        const pdf = new jsPDF('p', 'mm', 'a4')
        
        const imgWidth = 210 // A4 width in mm
        const pageHeight = 295 // A4 height in mm
        const imgHeight = (canvas.height * imgWidth) / canvas.width
        let heightLeft = imgHeight
        
        let position = 0
        
        // Add first page
        pdf.addImage(imgData, 'PNG', 0, position, imgWidth, imgHeight)
        heightLeft -= pageHeight
        
        // Add additional pages if needed
        while (heightLeft >= 0) {
          position = heightLeft - imgHeight
          pdf.addPage()
          pdf.addImage(imgData, 'PNG', 0, position, imgWidth, imgHeight)
          heightLeft -= pageHeight
        }
        
        // Save the PDF
        const fileName = `WMSU_TEC_Applicant_${appointment.value.full_name.replace(/\s+/g, '_')}_${appointment.value.id}.pdf`
        pdf.save(fileName)
        
        showToast('PDF exported successfully!', 'success')
        
      } catch (error) {
        console.error('Error generating PDF:', error)
        showToast('Error generating PDF. Please try again.', 'error')
      } finally {
        exportingPDF.value = false
      }
    }
    
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
      canApproveSubmitted,
      canMarkAsSubmitted,
      canMarkAsClaimed,
      canReschedule,
      canSetWaitingForClaiming,
      approveAppointment,
      rejectAppointment,
      approveSubmittedApplication,
      markAsSubmitted,
      markAsClaimed,
      rescheduleAppointment,
      setWaitingForClaiming,
      
      // PDF Export
      exportingPDF,
      exportToPDF
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

.button-info {
  color: white;
  background-color: #3B82F6;
  border: 1px solid transparent;
}

.button-info:hover {
  background-color: #2563EB;
}

.button-secondary {
  color: #374151;
  background-color: #F3F4F6;
  border: 1px solid #D1D5DB;
}

.button-secondary:hover {
  background-color: #E5E7EB;
  border-color: #9CA3AF;
}

.button-secondary:disabled {
  background-color: #F9FAFB;
  color: #9CA3AF;
  cursor: not-allowed;
}
</style>