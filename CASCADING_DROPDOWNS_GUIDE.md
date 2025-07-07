# Cascading Dropdowns Implementation Guide

This guide explains how to implement cascading dropdowns for Philippine location selection (Region → Province → City/Municipality → Barangay) in the TEC System.

## Overview

The system uses JSON data files located in `frontend/src/ph-json/` to provide hierarchical location data:

- `region.json` - Contains all Philippine regions
- `province.json` - Contains provinces linked to regions via region_code
- `city.json` - Contains cities/municipalities linked to provinces via province_code  
- `barangay.json` - Contains barangays linked to cities via city_code

## Data Structure

### Region Data Structure
```json
{
  "id": 1,
  "psgc_code": "010000000", 
  "region_name": "Region I (Ilocos Region)",
  "region_code": "01"
}
```

### Province Data Structure
```json
{
  "province_code": "0128",
  "province_name": "Ilocos Norte", 
  "psgc_code": "012800000",
  "region_code": "01"
}
```

### City Data Structure
```json
{
  "city_code": "012801",
  "city_name": "Adams",
  "province_code": "0128", 
  "psgc_code": "012801000",
  "region_desc": "01"
}
```

### Barangay Data Structure
```json
{
  "brgy_code": "012801001",
  "brgy_name": "Adams (Pob.)",
  "city_code": "012801",
  "province_code": "0128", 
  "region_code": "01"
}
```

## Implementation Steps

### 1. Component Setup

Create a reusable component for location dropdowns:

```vue
<template>
  <div class="location-dropdowns space-y-4">
    <!-- Region Dropdown -->
    <!-- Province Dropdown -->  
    <!-- City Dropdown -->
    <!-- Barangay Dropdown -->
  </div>
</template>
```

### 2. Data Loading

Load all JSON data on component mount:

```javascript
import { ref, computed, onMounted } from 'vue'

const regions = ref([])
const provinces = ref([])
const cities = ref([])
const barangays = ref([])

const loadData = async () => {
  try {
    const [regionsRes, provincesRes, citiesRes, barangaysRes] = await Promise.all([
      fetch('/src/ph-json/region.json'),
      fetch('/src/ph-json/province.json'),
      fetch('/src/ph-json/city.json'),
      fetch('/src/ph-json/barangay.json')
    ])
    
    regions.value = await regionsRes.json()
    provinces.value = await provincesRes.json()
    cities.value = await citiesRes.json()
    barangays.value = await barangaysRes.json()
  } catch (error) {
    console.error('Error loading location data:', error)
  }
}

onMounted(loadData)
```

### 3. Filtering Logic

Create computed properties to filter data based on parent selection:

```javascript
const filteredProvinces = computed(() => {
  if (!selectedRegion.value) return []
  return provinces.value.filter(province => 
    province.region_code === selectedRegion.value
  )
})

const filteredCities = computed(() => {
  if (!selectedProvince.value) return []
  return cities.value.filter(city => 
    city.province_code === selectedProvince.value
  )
})

const filteredBarangays = computed(() => {
  if (!selectedCity.value) return []
  return barangays.value.filter(barangay => 
    barangay.city_code === selectedCity.value
  )
})
```

### 4. Change Handlers

Reset child selections when parent changes:

```javascript
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
```

### 5. Component Usage

Use the LocationDropdowns component in your forms:

```vue
<template>
  <form @submit="handleSubmit">
    <LocationDropdowns 
      v-model="locationData"
      @change="onLocationChange"
      :show-debug="true"
    />
    
    <button type="submit">Submit</button>
  </form>
</template>

<script setup>
import LocationDropdowns from '@/components/common/LocationDropdowns.vue'
import { ref } from 'vue'

const locationData = ref({
  region: '',
  province: '',
  city: '',
  barangay: ''
})

const onLocationChange = (data) => {
  console.log('Location changed:', data)
  // Access data.completeAddress for full address string
  // Access individual codes and names
}
</script>
```

## Advanced Features

### 1. Pre-selecting Values

To pre-select values (e.g., when editing existing data):

```javascript
const locationData = ref({
  region: '09', // Region IX code
  province: '0973', // Zamboanga del Sur code
  city: '097322', // Pagadian City code
  barangay: '097322001' // Specific barangay code
})
```

### 2. Validation

Add validation to ensure all required fields are selected:

```javascript
const validate = () => {
  const errors = []
  
  if (!selectedRegion.value) errors.push('Region is required')
  if (!selectedProvince.value) errors.push('Province is required')
  if (!selectedCity.value) errors.push('City is required')
  if (!selectedBarangay.value) errors.push('Barangay is required')
  
  return errors
}
```

### 3. Search/Filter Functionality

Add search capability to dropdowns for better UX:

```vue
<template>
  <div class="relative">
    <input
      v-model="searchTerm"
      @input="filterOptions"
      placeholder="Search regions..."
      class="w-full px-4 py-2 border rounded-lg"
    />
    <div v-if="showOptions" class="absolute z-10 w-full bg-white border rounded-lg shadow-lg max-h-60 overflow-y-auto">
      <div
        v-for="region in filteredRegions"
        :key="region.region_code"
        @click="selectRegion(region)"
        class="px-4 py-2 hover:bg-gray-100 cursor-pointer"
      >
        {{ region.region_name }}
      </div>
    </div>
  </div>
</template>
```

### 4. Loading States

Show loading indicators while data is being fetched:

```vue
<select :disabled="loading.regions">
  <option value="">
    {{ loading.regions ? 'Loading regions...' : 'Select Region' }}
  </option>
  <option v-for="region in regions" :key="region.region_code" :value="region.region_code">
    {{ region.region_name }}
  </option>
</select>
```

## Integration with Existing Components

The ScheduleModal.vue already implements this pattern. Key integration points:

### 1. Form Data Structure

Ensure your form data includes location fields:

```javascript
const formData = ref({
  // ... other fields
  region: '',
  province: '', 
  city: '',
  barangay: '',
  streetPurok: ''
})
```

### 2. Validation Integration

Include location validation in your form validation:

```javascript
const validateLocation = () => {
  const isValid = formData.value.region && 
                  formData.value.province && 
                  formData.value.city && 
                  formData.value.barangay
  
  if (!isValid) {
    errors.value.location = 'Complete address is required'
  }
  
  return isValid
}
```

### 3. API Integration

When submitting forms, send both codes and names:

```javascript
const submitData = {
  region_code: locationData.value.region,
  region_name: locationData.value.regionName,
  province_code: locationData.value.province,
  province_name: locationData.value.provinceName,
  city_code: locationData.value.city,
  city_name: locationData.value.cityName,
  barangay_code: locationData.value.barangay,
  barangay_name: locationData.value.barangayName,
  complete_address: locationData.value.completeAddress
}
```

## Data Source

The Philippine address data comes from the official Philippine Standard Geographic Code (PSGC) and is maintained in the GitHub repository: https://github.com/isaacdarcilla/philippine-addresses

## Best Practices

1. **Performance**: Load all data once and filter client-side for better performance
2. **User Experience**: Show loading states and disable dependent dropdowns
3. **Validation**: Validate that selections are consistent (child belongs to parent)
4. **Accessibility**: Use proper labels and ARIA attributes
5. **Mobile**: Ensure dropdowns work well on mobile devices
6. **Error Handling**: Handle network errors gracefully
7. **Caching**: Consider caching location data in localStorage

## Troubleshooting

### Common Issues

1. **Empty dropdowns**: Check that JSON files are accessible and properly formatted
2. **Filtering not working**: Verify that parent-child relationships use correct field names
3. **Performance issues**: Consider pagination or virtualization for large datasets
4. **Network errors**: Implement retry logic and fallback data

### Debug Mode

Use the debug prop to see current selections:

```vue
<LocationDropdowns :show-debug="true" />
```

This will display current selection values and complete address for debugging purposes.
