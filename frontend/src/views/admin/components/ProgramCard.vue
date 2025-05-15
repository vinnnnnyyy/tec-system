<template>
  <div class="bg-white rounded-lg shadow-sm border border-gray-100 hover:shadow-md transition-all duration-300 group h-full flex flex-col">
    <div class="p-4 flex flex-col h-full">
      <!-- Combined Header with Icon, Title and Actions -->
      <div class="flex items-start">
        <!-- Icon and Title -->
        <div class="flex items-center gap-2 flex-1">
          <div class="w-8 h-8 rounded-lg bg-crimson-50 flex items-center justify-center">
            <i :class="`fas fa-${program.icon || 'book'} text-sm text-crimson-600`"></i>
          </div>
          <div>
            <h3 class="text-base font-semibold text-gray-900 line-clamp-1">{{ program.name }}</h3>
            <div class="flex items-center gap-1 mt-0.5">
              <span class="text-xs text-gray-500">{{ program.code }}</span>
              <span class="mx-1 text-gray-300">•</span>
              <span 
                :class="{
                  'text-green-600': program.status === 'active',
                  'text-gray-500': program.status === 'inactive'
                }"
                class="text-xs font-medium capitalize"
              >
                {{ program.status }}
              </span>
            </div>
          </div>
        </div>
        
        <!-- Action Buttons -->
        <div class="flex items-center space-x-1">
          <button 
            @click="$emit('edit', program)"
            class="p-1.5 text-gray-400 hover:text-blue-600 hover:bg-blue-50 rounded-md transition-all"
            title="Edit Program"
          >
            <i class="fas fa-edit text-sm"></i>
          </button>
          <button 
            @click="$emit('delete', program.id)"
            class="p-1.5 text-gray-400 hover:text-red-600 hover:bg-red-50 rounded-md transition-all"
            title="Delete Program"
          >
            <i class="fas fa-trash text-sm"></i>
          </button>
        </div>
      </div>

      <!-- Description - More Compact -->
      <div class="mt-3">
        <div class="description-container h-[50px] overflow-y-auto pr-1 text-xs text-gray-600">
          {{ program.description }}
        </div>
      </div>

      <!-- Key Details - Compact Row -->
      <div class="mt-3 flex items-center justify-between text-xs">
        <div class="flex items-center gap-1">
          <i class="fas fa-users text-crimson-500 text-xs"></i>
          <span class="text-gray-700">{{ program.capacity_limit }}</span>
        </div>
        <div class="flex items-center gap-1">
          <i class="fas fa-calendar text-crimson-500 text-xs"></i>
          <span class="text-gray-700">{{ formatDate(program.availability_date) }}</span>
        </div>
      </div>

      <!-- Requirements - Reduced Height -->
      <div v-if="program.requirements?.length" class="mt-3">
        <div class="flex items-center justify-between">
          <span class="text-xs font-medium text-gray-700">Requirements</span>
          <span class="text-xs text-gray-500">{{ program.requirements.length }}</span>
        </div>
        
        <div class="requirements-container h-[70px] overflow-y-auto pr-1 mt-1">
          <ul class="space-y-1">
            <li 
              v-for="(req, index) in program.requirements" 
              :key="index"
              class="flex items-center gap-1.5 text-xs text-gray-600 bg-gray-50 py-1 px-2 rounded-md"
            >
              <i class="fas fa-check text-green-500 text-xs"></i>
              <span class="line-clamp-1">{{ req }}</span>
            </li>
          </ul>
        </div>
      </div>

      <!-- Add this inside the ProgramCard template, perhaps after the "Schedule Now"/"Check Status" button -->
      <button 
        v-if="isScheduled"
        @click="$emit('simulate-approval', program.id)"
        class="mt-2 w-full bg-green-600 hover:bg-green-700 text-white py-2 px-4 rounded-md transition-all duration-200 flex items-center justify-center"
      >
        <i class="fas fa-check-circle mr-2"></i>
        Simulate Admin Approval
      </button>

      <div class="flex gap-2 mt-2">
        <span 
          v-if="program.auto_approve_appointments" 
          class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800"
        >
          <i class="fas fa-check-circle mr-1"></i>
          Auto-approve
        </span>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'ProgramCard',
  props: {
    program: {
      type: Object,
      required: true
    },
    isScheduled: {
      type: Boolean,
      default: false
    }
  },
  methods: {
    formatDate(dateString) {
      if (!dateString) return 'Not set'
      const date = new Date(dateString)
      // Shorter date format
      return new Intl.DateTimeFormat('en-US', {
        month: 'short',
        day: 'numeric'
      }).format(date)
    },
    getStatusClass(status) {
      return {
        'bg-green-100 text-green-800': status === 'active',
        'bg-gray-100 text-gray-800': status === 'inactive'
      }
    }
  },
  computed: {
    statusClass() {
      return {
        'bg-green-100 text-green-800': this.program.status === 'active',
        'bg-gray-100 text-gray-800': this.program.status === 'inactive'
      }
    }
  }
}
</script>

<style scoped>
.line-clamp-1 {
  display: -webkit-box;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

/* Custom scrollbar styling */
.description-container,
.requirements-container {
  scrollbar-width: thin;
  scrollbar-color: #E4E4E7 #ffffff;
}

.description-container::-webkit-scrollbar,
.requirements-container::-webkit-scrollbar {
  width: 3px;
}

.description-container::-webkit-scrollbar-track,
.requirements-container::-webkit-scrollbar-track {
  background: #ffffff;
}

.description-container::-webkit-scrollbar-thumb,
.requirements-container::-webkit-scrollbar-thumb {
  background-color: #E4E4E7;
  border-radius: 3px;
}
</style> 