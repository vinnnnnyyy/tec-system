<template>
  <div class="max-w-2xl mx-auto p-6 bg-white rounded-lg shadow-lg">
    <h2 class="text-2xl font-bold text-gray-900 mb-6">Location Dropdowns Test</h2>
    
    <LocationDropdowns 
      v-model="locationData"
      @change="onLocationChange"
      :show-debug="true"
    />
    
    <div class="mt-6 p-4 bg-gray-50 rounded-lg">
      <h3 class="font-semibold mb-2">Selected Location Data:</h3>
      <pre class="text-sm">{{ JSON.stringify(locationData, null, 2) }}</pre>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import LocationDropdowns from '../common/LocationDropdowns.vue'

const locationData = ref({
  region: '',
  province: '',
  city: '',
  barangay: ''
})

const onLocationChange = (data) => {
  console.log('Location changed:', data)
}
</script>
