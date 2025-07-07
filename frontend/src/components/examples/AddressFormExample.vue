<!-- Example usage of cascading location dropdowns -->
<template>
  <div class="max-w-2xl mx-auto p-6 bg-white rounded-lg shadow-lg">
    <h2 class="text-2xl font-bold text-gray-900 mb-6">Address Information</h2>
    
    <!-- Location Dropdowns Component -->
    <LocationDropdowns 
      v-model="addressData"
      @change="onAddressChange"
      :show-debug="showDebugInfo"
    />
    
    <!-- Additional Address Fields -->
    <div class="mt-6 space-y-4">
      <div>
        <label for="street" class="block text-sm font-medium text-gray-700 mb-2">
          Street/Purok <span class="text-red-500">*</span>
        </label>
        <input
          id="street"
          v-model="addressData.streetPurok"
          type="text"
          class="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-crimson-500"
          placeholder="Enter street address or purok"
          required
        />
      </div>
    </div>
    
    <!-- Form Actions -->
    <div class="mt-8 flex flex-col sm:flex-row gap-4">
      <button
        @click="validateAndSubmit"
        :disabled="!isFormValid"
        class="flex-1 px-6 py-3 bg-crimson-600 text-white rounded-lg hover:bg-crimson-700 disabled:bg-gray-300 disabled:cursor-not-allowed transition-colors"
      >
        Save Address
      </button>
      
      <button
        @click="clearForm"
        class="flex-1 px-6 py-3 bg-gray-200 text-gray-700 rounded-lg hover:bg-gray-300 transition-colors"
      >
        Clear
      </button>
      
      <button
        @click="toggleDebug"
        class="px-6 py-3 bg-blue-100 text-blue-700 rounded-lg hover:bg-blue-200 transition-colors"
      >
        {{ showDebugInfo ? 'Hide' : 'Show' }} Debug
      </button>
    </div>
    
    <!-- Form Output -->
    <div v-if="submittedData" class="mt-8 p-4 bg-green-50 border border-green-200 rounded-lg">
      <h3 class="text-lg font-semibold text-green-800 mb-2">Submitted Address:</h3>
      <div class="text-sm text-green-700">
        <p><strong>Complete Address:</strong> {{ submittedData.fullAddress }}</p>
        <p><strong>Region:</strong> {{ submittedData.regionName }} ({{ submittedData.region }})</p>
        <p><strong>Province:</strong> {{ submittedData.provinceName }} ({{ submittedData.province }})</p>
        <p><strong>City:</strong> {{ submittedData.cityName }} ({{ submittedData.city }})</p>
        <p><strong>Barangay:</strong> {{ submittedData.barangayName }} ({{ submittedData.barangay }})</p>
        <p><strong>Street:</strong> {{ submittedData.streetPurok }}</p>
      </div>
    </div>
    
    <!-- Validation Errors -->
    <div v-if="errors.length > 0" class="mt-4 p-4 bg-red-50 border border-red-200 rounded-lg">
      <h3 class="text-lg font-semibold text-red-800 mb-2">Please fix the following errors:</h3>
      <ul class="list-disc list-inside text-sm text-red-700">
        <li v-for="error in errors" :key="error">{{ error }}</li>
      </ul>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import LocationDropdowns from './LocationDropdowns.vue'

// Reactive data
const addressData = ref({
  region: '',
  province: '',
  city: '',
  barangay: '',
  streetPurok: '',
  // These will be populated by the LocationDropdowns component
  regionName: '',
  provinceName: '',
  cityName: '',
  barangayName: '',
  completeAddress: ''
})

const submittedData = ref(null)
const errors = ref([])
const showDebugInfo = ref(false)

// Computed properties
const isFormValid = computed(() => {
  return addressData.value.region &&
         addressData.value.province &&
         addressData.value.city &&
         addressData.value.barangay &&
         addressData.value.streetPurok.trim()
})

// Methods
const onAddressChange = (locationData) => {
  // Update address data with location information
  Object.assign(addressData.value, locationData)
  
  // Clear any previous errors when address changes
  errors.value = []
  
  console.log('Address changed:', locationData)
}

const validateForm = () => {
  errors.value = []
  
  if (!addressData.value.region) {
    errors.value.push('Region is required')
  }
  
  if (!addressData.value.province) {
    errors.value.push('Province is required')
  }
  
  if (!addressData.value.city) {
    errors.value.push('City/Municipality is required')
  }
  
  if (!addressData.value.barangay) {
    errors.value.push('Barangay is required')
  }
  
  if (!addressData.value.streetPurok.trim()) {
    errors.value.push('Street/Purok is required')
  }
  
  return errors.value.length === 0
}

const validateAndSubmit = () => {
  if (validateForm()) {
    // Create full address string
    const fullAddress = [
      addressData.value.streetPurok,
      addressData.value.barangayName,
      addressData.value.cityName,
      addressData.value.provinceName,
      addressData.value.regionName
    ].filter(Boolean).join(', ')
    
    // Simulate form submission
    submittedData.value = {
      ...addressData.value,
      fullAddress
    }
    
    // Show success message
    alert('Address saved successfully!')
    
    console.log('Form submitted:', submittedData.value)
  }
}

const clearForm = () => {
  addressData.value = {
    region: '',
    province: '',
    city: '',
    barangay: '',
    streetPurok: '',
    regionName: '',
    provinceName: '',
    cityName: '',
    barangayName: '',
    completeAddress: ''
  }
  submittedData.value = null
  errors.value = []
}

const toggleDebug = () => {
  showDebugInfo.value = !showDebugInfo.value
}

// Example: Pre-populate with Zamboanga City address (for testing)
const loadZamboangaExample = () => {
  addressData.value = {
    region: '09', // Region IX
    province: '0973', // Zamboanga del Sur
    city: '097332', // Zamboanga City
    barangay: '', // Will be populated after cascading
    streetPurok: 'Sample Street, Purok 1'
  }
}

// Example: Pre-populate with Pagadian City address (for testing)  
const loadPagadianExample = () => {
  addressData.value = {
    region: '09', // Region IX
    province: '0973', // Zamboanga del Sur
    city: '097322', // Pagadian City
    barangay: '', // Will be populated after cascading
    streetPurok: 'Sample Road, Purok 2'
  }
}

// Expose methods for external use (optional)
defineExpose({
  validateForm,
  clearForm,
  loadZamboangaExample,
  loadPagadianExample
})
</script>

<style scoped>
/* Custom styles for this example component */
.fade-enter-active, .fade-leave-active {
  transition: opacity 0.3s ease;
}

.fade-enter-from, .fade-leave-to {
  opacity: 0;
}

/* Responsive adjustments */
@media (max-width: 640px) {
  .max-w-2xl {
    margin: 1rem;
    padding: 1rem;
  }
}
</style>
