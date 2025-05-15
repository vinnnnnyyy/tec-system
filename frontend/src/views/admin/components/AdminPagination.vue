<template>
  <div class="px-6 py-4 bg-gray-50 border-t border-gray-200">
    <div class="flex items-center justify-between">
      <div class="text-sm text-gray-500">
        Showing {{ startEntry }} to {{ endEntry }} of {{ totalItems }} entries
      </div>
      <div class="flex space-x-2">
        <!-- First page button -->
        <button 
          @click="$emit('update:modelValue', 1)"
          :disabled="currentPage === 1"
          class="px-3 py-1 border border-gray-300 rounded-lg hover:bg-gray-100 disabled:opacity-50 disabled:cursor-not-allowed"
        >
          <i class="fas fa-angle-double-left"></i>
        </button>
        
        <!-- Previous button -->
        <button 
          @click="$emit('update:modelValue', currentPage - 1)"
          :disabled="currentPage === 1"
          class="px-3 py-1 border border-gray-300 rounded-lg hover:bg-gray-100 disabled:opacity-50 disabled:cursor-not-allowed"
        >
          <span>Previous</span>
        </button>
        
        <!-- Page buttons with ellipses -->
        <template v-for="item in paginationItems" :key="item">
          <!-- Ellipsis -->
          <span v-if="item === '...'" class="px-3 py-1 text-gray-500">...</span>
          
          <!-- Page button -->
          <button 
            v-else
            @click="$emit('update:modelValue', item)"
            :class="[
              'px-3 py-1 rounded-lg',
              currentPage === item 
                ? 'bg-crimson-600 text-white' 
                : 'border border-gray-300 hover:bg-gray-100'
            ]"
          >
            {{ item }}
          </button>
        </template>
        
        <!-- Next button -->
        <button 
          @click="$emit('update:modelValue', currentPage + 1)"
          :disabled="currentPage === totalPages"
          class="px-3 py-1 border border-gray-300 rounded-lg hover:bg-gray-100 disabled:opacity-50 disabled:cursor-not-allowed"
        >
         <span>Next</span>
        </button>
        
        <!-- Last page button -->
        <button 
          @click="$emit('update:modelValue', totalPages)"
          :disabled="currentPage === totalPages"
          class="px-3 py-1 border border-gray-300 rounded-lg hover:bg-gray-100 disabled:opacity-50 disabled:cursor-not-allowed"
        >
          <i class="fas fa-angle-double-right"></i>
        </button>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'AdminPagination',
  props: {
    modelValue: {
      type: Number,
      required: true
    },
    totalItems: {
      type: Number,
      required: true
    },
    itemsPerPage: {
      type: Number,
      required: true
    }
  },
  computed: {
    currentPage() {
      return this.modelValue
    },
    totalPages() {
      return Math.ceil(this.totalItems / this.itemsPerPage)
    },
    startEntry() {
      return this.totalItems > 0 ? ((this.currentPage - 1) * this.itemsPerPage) + 1 : 0
    },
    endEntry() {
      return Math.min(this.currentPage * this.itemsPerPage, this.totalItems)
    },
    paginationItems() {
      // For small number of pages, show all
      if (this.totalPages <= 7) {
        return Array.from({ length: this.totalPages }, (_, i) => i + 1)
      }
      
      // For large number of pages, show limited range with ellipses
      const items = []
      
      // Always show first page
      items.push(1)
      
      // Show ellipsis if needed
      if (this.currentPage > 3) {
        items.push('...')
      }
      
      // Calculate range around current page
      let rangeStart = Math.max(2, this.currentPage - 1)
      let rangeEnd = Math.min(this.totalPages - 1, this.currentPage + 1)
      
      // Adjust range to show at least 3 pages when possible
      if (this.currentPage <= 3) {
        rangeEnd = Math.min(4, this.totalPages - 1)
      }
      if (this.currentPage >= this.totalPages - 2) {
        rangeStart = Math.max(2, this.totalPages - 3)
      }
      
      // Add range pages
      for (let i = rangeStart; i <= rangeEnd; i++) {
        items.push(i)
      }
      
      // Show ellipsis if needed
      if (this.currentPage < this.totalPages - 2) {
        items.push('...')
      }
      
      // Always show last page
      if (this.totalPages > 1) {
        items.push(this.totalPages)
      }
      
      return items
    }
  }
}
</script> 