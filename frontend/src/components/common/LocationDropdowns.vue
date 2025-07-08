<template>
  <div class="location-dropdowns space-y-4">
    <!-- Region Selection -->
    <div class="form-group">
      <label for="region" class="block text-sm font-medium text-gray-700 mb-2">
        Region <span class="text-red-500">*</span>
      </label>
      <select
        id="region"
        v-model="selectedRegion"
        @change="onRegionChange"
        class="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-crimson-500 transition-all"
        :disabled="loading.regions"
      >
        <option value="">{{ loading.regions ? 'Loading regions...' : 'Select Region' }}</option>
        <option v-for="region in regions" :key="region.region_code" :value="region.region_code">
          {{ region.region_name }}
        </option>
      </select>
    </div>

    <!-- Province Selection -->
    <div class="form-group" v-if="selectedRegion">
      <label for="province" class="block text-sm font-medium text-gray-700 mb-2">
        Province <span class="text-red-500">*</span>
      </label>
      <select
        id="province"
        v-model="selectedProvince"
        @change="onProvinceChange"
        class="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-crimson-500 transition-all"
        :disabled="loading.provinces"
      >
        <option value="">{{ loading.provinces ? 'Loading provinces...' : 'Select Province' }}</option>
        <option v-for="province in filteredProvinces" :key="province.province_code" :value="province.province_code">
          {{ province.province_name }}
        </option>
      </select>
    </div>

    <!-- City/Municipality Selection -->
    <div class="form-group" v-if="selectedProvince">
      <label for="city" class="block text-sm font-medium text-gray-700 mb-2">
        City/Municipality <span class="text-red-500">*</span>
      </label>
      <select
        id="city"
        v-model="selectedCity"
        @change="onCityChange"
        class="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-crimson-500 transition-all"
        :disabled="loading.cities"
      >
        <option value="">{{ loading.cities ? 'Loading cities...' : 'Select City/Municipality' }}</option>
        <option v-for="city in filteredCities" :key="city.city_code" :value="city.city_code">
          {{ city.city_name }}
        </option>
      </select>
    </div>

    <!-- Barangay Selection -->
    <div class="form-group" v-if="selectedCity">
      <label for="barangay" class="block text-sm font-medium text-gray-700 mb-2">
        Barangay <span class="text-red-500">*</span>
      </label>
      <select
        id="barangay"
        v-model="selectedBarangay"
        @change="onBarangayChange"
        class="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-crimson-500 transition-all"
        :disabled="loading.barangays"
      >
        <option value="">{{ loading.barangays ? 'Loading barangays...' : 'Select Barangay' }}</option>
        <option v-for="barangay in filteredBarangays" :key="barangay.brgy_code" :value="barangay.brgy_code">
          {{ barangay.brgy_name }}
        </option>
      </select>
    </div>

    <!-- Debug Information (only in development) -->
    <div v-if="showDebug" class="mt-4 p-4 bg-gray-100 rounded-lg text-sm">
      <h4 class="font-semibold mb-2">Debug Information:</h4>
      <p><strong>Selected Region:</strong> {{ getRegionName(selectedRegion) }}</p>
      <p><strong>Selected Province:</strong> {{ getProvinceName(selectedProvince) }}</p>
      <p><strong>Selected City:</strong> {{ getCityName(selectedCity) }}</p>
      <p><strong>Selected Barangay:</strong> {{ getBarangayName(selectedBarangay) }}</p>
      <p><strong>Complete Address:</strong> {{ completeAddress }}</p>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, watch, onMounted } from 'vue'

// Props
const props = defineProps({
  modelValue: {
    type: Object,
    default: () => ({
      region: '',
      province: '',
      city: '',
      barangay: ''
    })
  },
  showDebug: {
    type: Boolean,
    default: false
  },
  required: {
    type: Boolean,
    default: true
  }
})

// Emits
const emit = defineEmits(['update:modelValue', 'change'])

// Reactive data
const regions = ref([])
const provinces = ref([])
const cities = ref([])
const barangays = ref([])

const selectedRegion = ref(props.modelValue.region || '')
const selectedProvince = ref(props.modelValue.province || '')
const selectedCity = ref(props.modelValue.city || '')
const selectedBarangay = ref(props.modelValue.barangay || '')

const loading = ref({
  regions: false,
  provinces: false,
  cities: false,
  barangays: false
})

// Computed properties for filtered data
const filteredProvinces = computed(() => {
  if (!selectedRegion.value) return []
  return provinces.value.filter(province => province.region_code === selectedRegion.value)
})

const filteredCities = computed(() => {
  if (!selectedProvince.value) return []
  return cities.value.filter(city => city.province_code === selectedProvince.value)
})

const filteredBarangays = computed(() => {
  if (!selectedCity.value) return []
  return barangays.value.filter(barangay => barangay.city_code === selectedCity.value)
})

// Helper methods to get names
const getRegionName = (regionCode) => {
  const region = regions.value.find(r => r.region_code === regionCode)
  return region ? region.region_name : ''
}

const getProvinceName = (provinceCode) => {
  const province = provinces.value.find(p => p.province_code === provinceCode)
  return province ? province.province_name : ''
}

const getCityName = (cityCode) => {
  const city = cities.value.find(c => c.city_code === cityCode)
  return city ? city.city_name : ''
}

const getBarangayName = (barangayCode) => {
  const barangay = barangays.value.find(b => b.brgy_code === barangayCode)
  return barangay ? barangay.brgy_name : ''
}

// Computed complete address
const completeAddress = computed(() => {
  const parts = []
  if (selectedBarangay.value) parts.push(getBarangayName(selectedBarangay.value))
  if (selectedCity.value) parts.push(getCityName(selectedCity.value))
  if (selectedProvince.value) parts.push(getProvinceName(selectedProvince.value))
  if (selectedRegion.value) parts.push(getRegionName(selectedRegion.value))
  return parts.join(', ')
})

// Event handlers
const onRegionChange = () => {
  selectedProvince.value = ''
  selectedCity.value = ''
  selectedBarangay.value = ''
  emitChange()
}

const onProvinceChange = () => {
  selectedCity.value = ''
  selectedBarangay.value = ''
  emitChange()
}

const onCityChange = () => {
  selectedBarangay.value = ''
  emitChange()
}

const onBarangayChange = () => {
  emitChange()
}

const emitChange = () => {
  const value = {
    region: selectedRegion.value,
    province: selectedProvince.value,
    city: selectedCity.value,
    barangay: selectedBarangay.value,
    regionName: getRegionName(selectedRegion.value),
    provinceName: getProvinceName(selectedProvince.value),
    cityName: getCityName(selectedCity.value),
    barangayName: getBarangayName(selectedBarangay.value),
    completeAddress: completeAddress.value
  }
  
  emit('update:modelValue', value)
  emit('change', value)
}

// Watch for external changes
watch(() => props.modelValue, (newValue) => {
  selectedRegion.value = newValue.region || ''
  selectedProvince.value = newValue.province || ''
  selectedCity.value = newValue.city || ''
  selectedBarangay.value = newValue.barangay || ''
}, { deep: true })

// Load all data on mount
onMounted(async () => {
  console.log('LocationDropdowns: Loading location data...')
  
  try {
    // Use fetch with public paths
    const [regionRes, provinceRes, cityRes, barangayRes] = await Promise.all([
      fetch('/data/region.json'),
      fetch('/data/province.json'),
      fetch('/data/city.json'),
      fetch('/data/barangay.json')
    ])
    
    if (!regionRes.ok || !provinceRes.ok || !cityRes.ok || !barangayRes.ok) {
      throw new Error('Failed to fetch one or more JSON files')
    }
    
    regions.value = await regionRes.json()
    provinces.value = await provinceRes.json()
    cities.value = await cityRes.json()
    barangays.value = await barangayRes.json()
    
    console.log('LocationDropdowns: Data loaded:', {
      regions: regions.value.length,
      provinces: provinces.value.length,
      cities: cities.value.length,
      barangays: barangays.value.length
    })
  } catch (error) {
    console.error('LocationDropdowns: Error loading data:', error)
    // Initialize with empty arrays as fallback
    regions.value = []
    provinces.value = []
    cities.value = []
    barangays.value = []
  }
})
</script>

<style scoped>
.location-dropdowns select:disabled {
  background-color: #f9fafb;
  cursor: not-allowed;
}

.form-group {
  position: relative;
}

.form-group select:focus {
  outline: none;
  box-shadow: 0 0 0 3px rgba(220, 38, 38, 0.1);
}
</style>
