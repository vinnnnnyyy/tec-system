<template>
  <main class="flex-1 overflow-x-hidden overflow-y-auto bg-gray-50">
    <!-- Success Toast Notification - removed in favor of centralized toast system -->

    <div class="container mx-auto px-6 py-8">
      <!-- Header Section -->
      <div class="flex flex-wrap items-center justify-between gap-4 mb-8">
        <div>
          <h3 class="text-gray-700 text-3xl font-semibold">Programs Management</h3>
          <p class="mt-2 text-gray-600">Manage and organize your examination programs</p>
        </div>
        <button 
          @click="openNewProgramModal" 
          class="bg-crimson-600 text-white px-6 py-3 rounded-lg hover:bg-crimson-700 transition-colors flex items-center space-x-3 shadow-sm"
        >
          <i class="fas fa-plus"></i>
          <span>Add New Program</span>
        </button>
      </div>

      <!-- Search and Filters Bar -->
      <div class="bg-white rounded-xl shadow-sm border border-gray-100 p-6 mb-8">
        <div class="flex flex-wrap gap-4 items-center">
          <div class="flex-1 min-w-[300px]">
            <div class="relative">
              <input 
                type="text" 
                v-model="filters.search"
                placeholder="Search programs by name or description..." 
                class="w-full pl-10 pr-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-crimson-500 focus:border-transparent"
              >
              <i class="fas fa-search absolute left-3 top-1/2 -translate-y-1/2 text-gray-400"></i>
            </div>
          </div>
          <div class="flex gap-3">
            <select 
              v-model="filters.status"
              class="px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-crimson-500"
            >
              <option value="">All Status</option>
              <option value="active">Active</option>
              <option value="inactive">Inactive</option>
            </select>
          </div>
        </div>
      </div>

      <!-- Loading State -->
      <div v-if="programsStore.loading" class="flex justify-center items-center py-12">
        <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-crimson-600"></div>
      </div>

      <!-- Error State -->
      <div v-else-if="programsStore.error" class="bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded-lg mb-8">
        {{ programsStore.error }}
        <button 
          @click="programsStore.fetchPrograms()" 
          class="ml-2 underline"
        >
          Try again
        </button>
      </div>
      <!-- Programs Grid and Pagination with proper spacing -->
      <div v-else class="space-y-6">
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          <ProgramCard
            v-for="program in paginatedPrograms"
            :key="program.id"
            :program="program"
            @edit="editProgram"
            @delete="deleteProgram"
          />
        </div>
        
        <!-- AdminPagination will now have consistent spacing -->
        <AdminPagination 
          v-if="filteredPrograms.length > 0"
          v-model="currentPage"
          :total-items="filteredPrograms.length"
          :items-per-page="itemsPerPage"
          class="bg-white rounded-lg shadow-sm"
        />
      </div>
    </div>

    <!-- Program Modal -->
    <ProgramModal 
      :show="showModal"
      :program="selectedProgram"
      @close="showModal = false"
      @submit="handleSubmit"
    />

    <!-- Create/Update Confirmation Modal -->
    <div v-if="showConfirmationModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
      <div class="bg-white rounded-xl shadow-lg w-full max-w-md p-6">
        <div class="text-center">
          <i class="fas fa-check-circle text-4xl text-green-500 mb-4"></i>
          <h3 class="text-lg font-semibold mb-2">Confirm Action</h3>
          <p class="text-gray-600 mb-6">
            {{ confirmationMessage }}
            <span v-if="programToConfirm" class="block mt-2 font-medium">
              {{ programToConfirm.name }}
            </span>
          </p>
          
          <div class="flex justify-center space-x-3">
            <button 
              @click="cancelConfirmation"
              class="px-4 py-2 text-sm font-medium text-gray-700 bg-gray-100 rounded-lg hover:bg-gray-200"
            >
              Cancel
            </button>
            <button 
              @click="confirmAction"
              :disabled="isProcessing"
              class="px-4 py-2 text-sm font-medium text-white bg-green-600 rounded-lg hover:bg-green-700 flex items-center justify-center"
            >
              <i v-if="isProcessing" class="fas fa-spinner fa-spin mr-2"></i>
              {{ confirmButtonText }}
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Delete Confirmation Modal -->
    <div v-if="showDeleteConfirmModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
      <div class="bg-white rounded-xl shadow-lg w-full max-w-md p-6">
        <div class="text-center">
          <i class="fas fa-exclamation-triangle text-4xl text-red-500 mb-4"></i>
          <h3 class="text-lg font-semibold mb-2">Confirm Deletion</h3>
          <p class="text-gray-600 mb-6">
            Are you sure you want to delete this program? This action cannot be undone.
            <span v-if="programToDelete" class="block mt-2 font-medium text-red-600">
              {{ programToDelete.name }}
            </span>
          </p>
          
          <div class="flex justify-center space-x-3">
            <button 
              @click="cancelDelete"
              class="px-4 py-2 text-sm font-medium text-gray-700 bg-gray-100 rounded-lg hover:bg-gray-200"
            >
              Cancel
            </button>
            <button 
              @click="confirmDelete"
              :disabled="isDeleting"
              class="px-4 py-2 text-sm font-medium text-white bg-red-600 rounded-lg hover:bg-red-700 flex items-center justify-center"
            >
              <i v-if="isDeleting" class="fas fa-spinner fa-spin mr-2"></i>
              Delete Program
            </button>
          </div>
        </div>
      </div>
    </div>
  </main>
</template>

<script>
import { ref, onMounted, computed, watch } from 'vue'
import { usePrograms } from '@/stores/programs'
import ProgramModal from '../components/ProgramModal.vue'
import ProgramCard from '../components/ProgramCard.vue'
import AdminPagination from '../components/AdminPagination.vue'
import { useToast } from '../../../composables/useToast'

export default {
  name: 'Programs',
  components: {
    ProgramCard,
    ProgramModal,
    AdminPagination
  },
  setup() {
    const programsStore = usePrograms()
    const showModal = ref(false)
    const selectedProgram = ref(null)
    const debugInfo = ref('')
    const filters = ref({
      search: '',
      status: ''
    })
    
    // Get toast function from composable
    const { showToast } = useToast()
    
    // Confirmation modal state
    const showConfirmationModal = ref(false)
    const confirmationMessage = ref('')
    const isProcessing = ref(false)
    const confirmButtonText = ref('Confirm')
    const actionType = ref('') // 'create' or 'update'
    const programToConfirm = ref(null)
    
    // Pagination state
    const currentPage = ref(1)
    const itemsPerPage = ref(6)

    // Delete confirmation modal state
    const showDeleteConfirmModal = ref(false)
    const programToDelete = ref(null)
    const isDeleting = ref(false)
    
    // Reset page when filters change
    watch([() => filters.value.search, () => filters.value.status], () => {
      currentPage.value = 1
    })

    // Fetch programs on component mount
    onMounted(async () => {
      try {
        await programsStore.fetchPrograms()
      } catch (error) {
        console.error('Error fetching programs:', error)
        debugInfo.value = `Error fetching programs: ${error.message || 'Unknown error'}`
      }
    })

    // Computed property for filtered programs
    const filteredPrograms = computed(() => {
      if (!programsStore.programs || !Array.isArray(programsStore.programs)) return []
      
      return programsStore.programs.filter(program => {
        const searchTerm = filters.value.search.toLowerCase()
        const matchesSearch = !searchTerm || 
          program.name?.toLowerCase().includes(searchTerm) ||
          program.description?.toLowerCase().includes(searchTerm)
        
        const matchesStatus = !filters.value.status || 
          program.status === filters.value.status

        return matchesSearch && matchesStatus
      })
    })
    
    // Paginated programs
    const paginatedPrograms = computed(() => {
      const start = (currentPage.value - 1) * itemsPerPage.value
      const end = start + itemsPerPage.value
      return filteredPrograms.value.slice(start, end)
    })

    // Modal handlers
    const openNewProgramModal = () => {
      selectedProgram.value = null
      showModal.value = true
    }

    const editProgram = (program) => {
      selectedProgram.value = { ...program }
      showModal.value = true
    }

    const deleteProgram = async (programId) => {
      // Find the program in our list using the ID
      const programObj = programsStore.programs.find(p => p.id === programId);
      
      if (!programObj) {
        console.error('Program not found with ID:', programId);
        return;
      }
      
      programToDelete.value = programObj;
      showDeleteConfirmModal.value = true;
    }

    const handleSubmit = async (programData) => {
      // Show confirmation modal first
      programToConfirm.value = programData
      
      if (programData.id) {
        actionType.value = 'update'
        confirmationMessage.value = 'Are you sure you want to update this program?'
        confirmButtonText.value = 'Update Program'
      } else {
        actionType.value = 'create'
        confirmationMessage.value = 'Are you sure you want to create this program?'
        confirmButtonText.value = 'Create Program'
      }
      
      showModal.value = false
      showConfirmationModal.value = true
    }
    
    const confirmAction = async () => {
      if (!programToConfirm.value) return
      
      isProcessing.value = true
      const startTime = Date.now()
      const MIN_LOADING_TIME = 1200 // Minimum 1.2 seconds of loading time for better UX
      
      try {
        let result;
        if (actionType.value === 'update') {
          result = await programsStore.updateProgram(programToConfirm.value)
          // Show toast with success message
          showToast(`Program "${programToConfirm.value.name}" has been successfully updated.`)
        } else {
          result = await programsStore.createProgram(programToConfirm.value)
          // Show toast with success message
          showToast(`Program "${programToConfirm.value.name}" has been successfully created.`)
        }
        
        // Calculate how much time has passed
        const elapsedTime = Date.now() - startTime
        
        // If operation was too fast, add artificial delay for better UX
        if (elapsedTime < MIN_LOADING_TIME) {
          await new Promise(resolve => setTimeout(resolve, MIN_LOADING_TIME - elapsedTime))
        }
        
        closeConfirmationModal()
        return result
      } catch (error) {
        console.error('Error saving program:', error)
        debugInfo.value = `Error saving program: ${error.message || 'Unknown error'}`
        
        // Even for errors, ensure minimum loading time
        const elapsedTime = Date.now() - startTime
        if (elapsedTime < MIN_LOADING_TIME) {
          await new Promise(resolve => setTimeout(resolve, MIN_LOADING_TIME - elapsedTime))
        }
      } finally {
        isProcessing.value = false
      }
    }
    
    const cancelConfirmation = () => {
      // Reopening the edit modal with the program data intact
      if (programToConfirm.value) {
        selectedProgram.value = { ...programToConfirm.value }
        showModal.value = true
      }
      closeConfirmationModal()
    }
    
    const closeConfirmationModal = () => {
      showConfirmationModal.value = false
      confirmationMessage.value = ''
      programToConfirm.value = null
      isProcessing.value = false
    }

    const confirmDelete = async () => {
      if (!programToDelete.value || !programToDelete.value.id) {
        console.error('No valid program ID to delete');
        return;
      }
      
      isDeleting.value = true;
      const startTime = Date.now();
      const MIN_LOADING_TIME = 1200; // Minimum 1.2 seconds of loading time
      
      try {
        // Add debugging log to check the ID
        console.log('Deleting program with ID:', programToDelete.value.id);
        
        await programsStore.deleteProgram(programToDelete.value.id);
        
        // Calculate how much time has passed
        const elapsedTime = Date.now() - startTime;
        
        // If operation was too fast, add artificial delay for better UX
        if (elapsedTime < MIN_LOADING_TIME) {
          await new Promise(resolve => setTimeout(resolve, MIN_LOADING_TIME - elapsedTime));
        }
        
        // Show success toast
        showToast(`Program "${programToDelete.value.name}" has been successfully deleted.`)
        closeDeleteModal();
      } catch (error) {
        console.error('Error deleting program:', error);
        debugInfo.value = `Error deleting program: ${error.message || 'Unknown error'}`;
        
        // Even for errors, ensure minimum loading time
        const elapsedTime = Date.now() - startTime;
        if (elapsedTime < MIN_LOADING_TIME) {
          await new Promise(resolve => setTimeout(resolve, MIN_LOADING_TIME - elapsedTime));
        }
      } finally {
        isDeleting.value = false;
      }
    }
    
    const cancelDelete = () => {
      closeDeleteModal()
    }
    
    const closeDeleteModal = () => {
      showDeleteConfirmModal.value = false
      programToDelete.value = null
    }

    return {
      programsStore,
      showModal,
      selectedProgram,
      filters,
      debugInfo,
      filteredPrograms,
      paginatedPrograms,
      currentPage,
      itemsPerPage,
      showConfirmationModal,
      confirmationMessage,
      isProcessing,
      confirmButtonText,
      programToConfirm,
      openNewProgramModal,
      editProgram,
      deleteProgram,
      handleSubmit,
      confirmAction,
      cancelConfirmation,
      closeConfirmationModal,
      showDeleteConfirmModal,
      programToDelete,
      isDeleting,
      confirmDelete,
      cancelDelete,
      showToast
    }
  }
}
</script>

<style scoped>
/* Add animations for toast notifications */
@keyframes fadeIn {
  from { opacity: 0; transform: translateX(20px); }
  to { opacity: 1; transform: translateX(0); }
}

.animate-fade-in {
  animation: fadeIn 0.3s ease-in-out;
}
</style> 
