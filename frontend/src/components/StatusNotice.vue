<template>
  <!-- Status-specific notices -->
  <div v-if="status === 'pending'" class="bg-yellow-50 border-l-4 border-yellow-400 p-3 rounded-md my-2">
    <div class="flex">
      <div class="flex-shrink-0">
        <i class="fas fa-info-circle text-yellow-400"></i>
      </div>
      <div class="ml-3">
        <p class="text-yellow-700 text-sm">
          <span v-if="appointment.is_rescheduled" class="font-medium block mb-1">
            This is your new rescheduled appointment.
          </span>
          Your appointment is pending approval. You will receive an email notification once it's approved.
          <span v-if="appointment.is_rescheduled" class="block mt-1">
            The original appointment has been cancelled.
          </span>
        </p>
      </div>
    </div>
  </div>
  
  <div v-else-if="status === 'approved'" class="bg-green-50 border-l-4 border-green-400 p-3 rounded-md my-2">
    <div class="flex">
      <div class="flex-shrink-0">
        <i class="fas fa-check-circle text-green-400"></i>
      </div>
      <div class="ml-3">
        <p class="text-green-700 text-sm">
          <span class="font-medium">Congratulations! Your application has been approved.</span>
          <span class="block mt-1">You are scheduled for the examination on <strong>{{ formatDate(appointment.preferred_date) }}</strong> during the <strong>{{ formatTimeSlot(getEffectiveTimeSlot()) }}</strong> session.</span>
          
          <span v-if="appointment.test_center" class="block mt-2 font-medium">Test Location Details:</span>
          <span v-if="appointment.test_center" class="block mt-1">
            <strong>Test Center:</strong> {{ appointment.test_center }}
            <span v-if="appointment.test_center_code && !appointment.test_center.includes(appointment.test_center_code)" class="text-gray-600">
              (ID: {{ appointment.test_center_code }})
            </span>
          </span>
          <span v-if="appointment.room_number || appointment.room_code" class="block mt-1">
            <strong>Test Room:</strong> {{ appointment.room_number }}
            <span v-if="appointment.room_code && !String(appointment.room_number).includes(appointment.room_code)" 
                  class="text-gray-600">
              (Code: {{ appointment.room_code }})
            </span>
          </span>
          <span v-if="appointment.test_center_address" class="block mt-1">
            <strong>Address:</strong> {{ appointment.test_center_address }}
          </span>
          
          <span class="block mt-2 font-medium">Important:</span>
          <span class="block mt-1">Please arrive 30 minutes before your scheduled time and bring the following:</span>
          <ul class="list-disc ml-5 mt-1 space-y-1">
            <li>Printed application form</li>
            <li>Valid ID</li>
            <li>Examination permit</li>
          </ul>
        </p>
      </div>
    </div>
  </div>
  
  <div v-else-if="status === 'completed'" class="bg-blue-50 border-l-4 border-blue-400 p-3 rounded-md my-2">
    <div class="flex">
      <div class="flex-shrink-0">
        <i class="fas fa-check-double text-blue-400"></i>
      </div>
      <div class="ml-3">
        <p class="text-blue-700 text-sm">
          Your appointment has been completed. Thank you for using our services!
        </p>
      </div>
    </div>
  </div>
  
  <div v-else-if="status === 'cancelled' || status === 'rejected'" class="bg-red-50 border-l-4 border-red-400 p-3 rounded-md my-2">
    <div class="flex">
      <div class="flex-shrink-0">
        <i class="fas fa-exclamation-triangle text-red-400"></i>
      </div>
      <div class="ml-3">
        <p class="text-red-700 text-sm">
          Your appointment was cancelled. Please contact the office for more information.
        </p>
      </div>
    </div>
  </div>
  
  <div v-else-if="status === 'rescheduled'" class="bg-purple-50 border-l-4 border-purple-400 p-3 rounded-md my-2">
    <div class="flex">
      <div class="flex-shrink-0">
        <i class="fas fa-calendar-alt text-purple-400"></i>
      </div>
      <div class="ml-3">
        <p class="text-purple-700 text-sm">
          This appointment has been marked for rescheduling. Please use the button below to schedule a new appointment.
          <span v-if="appointment.admin_notes" class="block mt-1 italic">
            Note: {{ appointment.admin_notes }}
          </span>
        </p>
      </div>
    </div>
  </div>
  
  <div v-else-if="status === 'waiting_for_test_details'" class="bg-yellow-50 border-l-4 border-yellow-400 p-3 rounded-md my-2">
    <div class="flex">
      <div class="flex-shrink-0">
        <i class="fas fa-clock text-yellow-400"></i>
      </div>
      <div class="ml-3">
        <p class="text-yellow-700 text-sm">
          <span v-if="appointment.is_rescheduled" class="font-medium block mb-1">
            This is your rescheduled appointment.
          </span>
          Your application is pending assignment of test details. The Testing and Evaluation Center is currently processing your request for <strong>{{ formatDate(appointment.preferred_date) }}</strong>. You will receive an email notification when test information is available.
        </p>
      </div>
    </div>
  </div>
  
  <div v-else-if="status === 'submitted'" class="bg-yellow-50 border-l-4 border-yellow-400 p-3 rounded-md my-2">
    <div class="flex">
      <div class="flex-shrink-0">
        <i class="fas fa-clock text-yellow-400"></i>
      </div>
      <div class="ml-3">
        <p class="text-yellow-700 text-sm">
          <span v-if="appointment.is_rescheduled" class="font-medium block mb-1">
            This is your rescheduled appointment.
          </span>
          Your application has been submitted and is waiting for test details. The Testing and Evaluation Center is currently processing your request for <strong>{{ formatDate(appointment.preferred_date) }}</strong>. You will receive an email notification when test information is available.
        </p>
      </div>
    </div>
  </div>
  
  <div v-else-if="status === 'waiting_for_submission'" class="bg-teal-50 border-l-4 border-teal-400 p-3 rounded-md my-2">
    <div class="flex">
      <div class="flex-shrink-0">
        <i class="fas fa-file-upload text-teal-400"></i>
      </div>
      <div class="ml-3">
        <p class="text-teal-700 text-sm">
          Test details assigned! Please download and submit your application form before <strong>{{ formatDate(appointment.preferred_date) }}</strong>. Failure to submit on time may result in cancellation.
        </p>
      </div>
    </div>
  </div>
  
  <div v-else-if="status === 'claimed'" class="bg-blue-50 border-l-4 border-blue-400 p-3 rounded-md my-2">
    <div class="flex">
      <div class="flex-shrink-0">
        <i class="fas fa-check-circle text-blue-400"></i>
      </div>
      <div class="ml-3">
        <p class="text-blue-700 text-sm">
          This appointment has been marked as claimed. You will be redirected to the schedule page in a moment.
          <span class="block mt-1">
            You can check your exam score in your profile page.
          </span>
        </p>
      </div>
    </div>
  </div>
</template>

<script setup>
defineProps({
  status: {
    type: String,
    required: true
  },
  appointment: {
    type: Object,
    required: true
  },
  formatDate: {
    type: Function,
    required: true
  },
  formatTimeSlot: {
    type: Function,
    required: true
  },
  getEffectiveTimeSlot: {
    type: Function,
    required: true
  }
})
</script>