<template>
  <div>
    <!-- Modal Backdrop with transition -->
    <transition name="fade">
      <div v-if="show"
           class="fixed inset-0 bg-black bg-opacity-50"
           @click="close">
      </div>
    </transition>

    <!-- Modal Content with transition -->
    <transition name="modal">
      <div v-if="show"
           class="fixed inset-0 items-center justify-center z-50 flex">
        <div class="bg-white p-4 md:p-8 rounded-xl shadow-xl w-full max-w-md md:max-w-3xl lg:max-w-4xl mx-2 md:mx-auto my-4 md:my-0 overflow-y-auto max-h-[90vh]">
          <div class="flex justify-between items-center mb-6">
            <h3 class="text-xl md:text-2xl font-bold text-gray-900 flex items-center gap-3">
              <div class="w-10 h-10 rounded-lg bg-crimson-100 flex items-center justify-center">
                <i class="fas fa-graduation-cap text-xl text-crimson-600"></i>
              </div>
              {{ isEditing ? 'Edit Program' : 'Add New Program' }}
            </h3>
            <button @click="close" class="text-gray-400 hover:text-gray-500 p-2 hover:bg-gray-100 rounded-lg transition-all">
              <i class="fas fa-times text-xl"></i>
            </button>
          </div>
          
          <form @submit.prevent="handleSubmit" class="space-y-8">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
              <!-- Left Column -->
              <div class="space-y-6">
                <!-- Basic Information Section -->
                <div class="space-y-6">
                  <div class="flex items-center gap-2 text-lg font-semibold text-gray-900 mb-2">
                    <i class="fas fa-info-circle text-crimson-500"></i>
                    <h4>Basic Information</h4>
                  </div>
                  
                  <!-- Name -->
                  <div class="space-y-2">
                    <label class="block text-sm font-medium text-gray-700">Program Name</label>
                    <input 
                      type="text" 
                      v-model="formData.name"
                      class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-crimson-500 text-base transition-all"
                      placeholder="Enter program name"
                      required
                    >
                  </div>

                  <!-- Code -->
                  <div class="space-y-2">
                    <label class="block text-sm font-medium text-gray-700">Program Code</label>
                    <input 
                      type="text" 
                      v-model="formData.code"
                      class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-crimson-500 text-base uppercase transition-all"
                      placeholder="Enter program code"
                      required
                    >
                  </div>

                  <!-- Description -->
                  <div class="space-y-2">
                    <label class="block text-sm font-medium text-gray-700">Description</label>
                    <textarea 
                      v-model="formData.description"
                      rows="4"
                      class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-crimson-500 text-base transition-all"
                      placeholder="Enter program description"
                      required
                    ></textarea>
                  </div>

                  <!-- Status -->
                  <div class="space-y-2">
                    <label class="block text-sm font-medium text-gray-700">Status</label>
                    <div class="flex gap-6">
                      <label class="relative flex items-center gap-3 cursor-pointer group">
                        <input 
                          type="radio" 
                          v-model="formData.status" 
                          value="active"
                          class="form-radio text-crimson-600 focus:ring-crimson-500 h-5 w-5"
                        >
                        <div class="flex items-center gap-2">
                          <div class="w-2 h-2 rounded-full bg-green-500"></div>
                          <span class="text-sm text-gray-700 group-hover:text-gray-900">Active</span>
                        </div>
                      </label>
                      <label class="relative flex items-center gap-3 cursor-pointer group">
                        <input 
                          type="radio" 
                          v-model="formData.status" 
                          value="inactive"
                          class="form-radio text-crimson-600 focus:ring-crimson-500 h-5 w-5"
                        >
                        <div class="flex items-center gap-2">
                          <div class="w-2 h-2 rounded-full bg-gray-400"></div>
                          <span class="text-sm text-gray-700 group-hover:text-gray-900">Inactive</span>
                        </div>
                      </label>
                    </div>
                  </div>
                </div>
              </div>

              <!-- Right Column -->
              <div class="space-y-6">
                <!-- Advanced Settings Section -->
                <div class="space-y-6">
                  <div class="flex items-center gap-2 text-lg font-semibold text-gray-900 mb-2">
                    <i class="fas fa-cog text-crimson-500"></i>
                    <h4>Advanced Settings</h4>
                  </div>

                  <!-- Icon with Preview -->
                  <div class="space-y-2">
                    <label class="block text-sm font-medium text-gray-700">Program Icon</label>
                    <div class="flex gap-4 items-center">
                      <input 
                        type="text" 
                        v-model="formData.icon"
                        placeholder="e.g. laptop-code"
                        class="flex-1 px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-crimson-500 text-base transition-all"
                        required
                      >
                      <div class="w-12 h-12 rounded-lg bg-gradient-to-br from-crimson-50 to-crimson-100 flex items-center justify-center shadow-sm border border-crimson-200">
                        <i :class="`fas fa-${formData.icon || 'question'} text-2xl text-crimson-600`"></i>
                      </div>
                    </div>
                    <p class="text-xs text-gray-500 mt-1">Enter a Font Awesome icon name (e.g. book, graduation-cap, laptop-code)</p>
                  </div>

                  <!-- Capacity -->
                  <div class="space-y-2">
                    <label class="block text-sm font-medium text-gray-700">Capacity Limit</label>
                    <div class="relative">
                      <input 
                        type="number" 
                        v-model="formData.capacity_limit"
                        min="1"
                        class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-crimson-500 text-base transition-all"
                        required
                      >
                      <div class="absolute inset-y-0 right-0 flex items-center pr-3 pointer-events-none">
                        <i class="fas fa-users text-gray-400"></i>
                      </div>
                    </div>
                  </div>

                  <!-- Availability Date -->
                  <div class="space-y-2">
                    <label class="block text-sm font-medium text-gray-700">Availability Date</label>
                    <div class="relative">
                      <input 
                        type="date" 
                        v-model="formData.availability_date"
                        class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-crimson-500 text-base transition-all"
                        required
                      >
                      <div class="absolute inset-y-0 right-0 flex items-center pr-3 pointer-events-none">
                        <i class="fas fa-calendar text-gray-400"></i>
                      </div>
                    </div>
                  </div>

                  <!-- Requirements -->
                  <div class="space-y-2">
                    <label class="block text-sm font-medium text-gray-700">Requirements</label>
                    <div class="h-[250px] overflow-hidden rounded-lg border border-gray-200 bg-gray-50">
                      <div class="h-full flex flex-col">
                        <div class="flex-1 overflow-y-auto p-4 space-y-3">
                          <div 
                            v-for="(req, index) in formData.requirements" 
                            :key="index" 
                            class="flex items-center gap-3 group"
                          >
                            <div class="flex-1">
                              <input 
                                type="text" 
                                v-model="formData.requirements[index]"
                                class="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-crimson-500 text-sm transition-all bg-white"
                                placeholder="Enter requirement"
                              >
                            </div>
                            <button 
                              type="button"
                              @click="removeRequirement(index)"
                              class="text-gray-400 hover:text-red-600 hover:bg-red-50 p-2 rounded-lg transition-all"
                            >
                              <i class="fas fa-trash text-sm"></i>
                            </button>
                          </div>
                        </div>
                        <div class="p-4 border-t border-gray-200">
                          <button 
                            type="button"
                            @click="addRequirement"
                            class="w-full py-2 px-4 border-2 border-dashed border-gray-300 rounded-lg text-sm text-gray-600 hover:text-crimson-600 hover:border-crimson-300 hover:bg-crimson-50 transition-all flex items-center justify-center gap-2"
                          >
                            <i class="fas fa-plus"></i>
                            <span>Add Requirement</span>
                          </button>
                        </div>
                      </div>
                    </div>
                  </div>

                  <!-- Auto-approve appointments toggle -->
                  <div class="space-y-2">
                    <div class="flex items-center justify-between">
                      <label class="text-sm font-medium text-gray-700">Auto-approve appointments</label>
                      <div class="relative inline-block w-12 h-6 transition duration-200 ease-in-out rounded-full">
                        <input 
                          type="checkbox" 
                          v-model="formData.auto_approve_appointments" 
                          class="absolute w-6 h-6 opacity-0 z-10 cursor-pointer"
                        >
                        <div class="w-12 h-6 bg-gray-300 rounded-full flex items-center transition-all" 
                             :class="{'bg-crimson-500': formData.auto_approve_appointments}">
                          <div class="w-5 h-5 bg-white rounded-full shadow transform transition-transform"
                               :class="{'translate-x-6': formData.auto_approve_appointments}"></div>
                        </div>
                      </div>
                    </div>
                    <p class="text-xs text-gray-500">
                      When enabled, all appointment requests for this program will be automatically approved without manual review.
                    </p>
                  </div>
                </div>
              </div>
            </div>

            <!-- Action Buttons -->
            <div class="flex gap-4 pt-6 border-t border-gray-100">
              <button 
                type="submit"
                class="flex-1 bg-gradient-to-r from-crimson-600 to-crimson-700 text-white px-6 py-3 rounded-lg hover:from-crimson-700 hover:to-crimson-800 transition-all text-base font-medium shadow-sm flex items-center justify-center gap-2"
              >
                <i class="fas fa-save"></i>
                {{ isEditing ? 'Update Program' : 'Create Program' }}
              </button>
              <button 
                type="button"
                @click="close"
                class="flex-1 bg-gray-100 text-gray-700 px-6 py-3 rounded-lg hover:bg-gray-200 transition-all text-base font-medium flex items-center justify-center gap-2"
              >
                <i class="fas fa-times"></i>
                Cancel
              </button>
            </div>
          </form>
        </div>
      </div>
    </transition>
  </div>
</template>

<script>
import { ref, watch } from 'vue'
import { usePrograms } from '@/stores/programs'

export default {
  name: 'ProgramModal',
  props: {
    show: {
      type: Boolean,
      required: true
    },
    program: {
      type: Object,
      default: null
    }
  },
  emits: ['close', 'submit'],
  setup(props, { emit }) {
    const programsStore = usePrograms()
    const isEditing = ref(false)
    const formData = ref({
      name: '',
      code: '',
      description: '',
      requirements: [],
      status: 'active',
      icon: '',
      capacity_limit: 1,
      auto_approve_appointments: false,
      availability_date: new Date().toISOString().split('T')[0]
    })
    const error = ref(null)
    const isSubmitting = ref(false)

    const resetForm = () => {
      formData.value = {
        name: '',
        code: '',
        description: '',
        requirements: [],
        status: 'active',
        icon: '',
        capacity_limit: 1,
        auto_approve_appointments: false,
        availability_date: new Date().toISOString().split('T')[0]
      }
      error.value = null
    }

    watch(() => props.program, (newProgram) => {
      if (newProgram) {
        isEditing.value = true
        formData.value = {
          ...formData.value,
          ...newProgram,
          availability_date: newProgram.availability_date || new Date().toISOString().split('T')[0],
          requirements: [...(newProgram.requirements || [])]
        }
      } else {
        isEditing.value = false
        resetForm()
      }
    }, { immediate: true })

    const validateForm = () => {
      if (!formData.value.name.trim()) {
        error.value = 'Program name is required'
        return false
      }
      if (!formData.value.code.trim()) {
        error.value = 'Program code is required'
        return false
      }
      if (!formData.value.description.trim()) {
        error.value = 'Description is required'
        return false
      }
      if (!formData.value.status) {
        error.value = 'Status is required'
        return false
      }
      if (!formData.value.availability_date) {
        error.value = 'Availability date is required'
        return false
      }
      if (formData.value.capacity_limit < 1) {
        error.value = 'Capacity limit must be at least 1'
        return false
      }
      return true
    }

    const addRequirement = () => {
      formData.value.requirements.push('')
    }

    const removeRequirement = (index) => {
      formData.value.requirements.splice(index, 1)
    }

    const close = () => {
      if (!isSubmitting.value) {
        emit('close')
        resetForm()
      }
    }

    const handleSubmit = async () => {
      error.value = null
      if (!validateForm()) return

      try {
        isSubmitting.value = true
        const cleanedData = {
          ...formData.value,
          code: formData.value.code.toUpperCase(),
          capacity_limit: Number(formData.value.capacity_limit),
          icon: formData.value.icon.trim() || 'book',
          requirements: formData.value.requirements.filter(req => req.trim() !== ''),
          auto_approve_appointments: formData.value.auto_approve_appointments
        }

        if (props.program?.id) {
          cleanedData.id = props.program.id
        }

        emit('submit', cleanedData)
        resetForm()
      } catch (err) {
        error.value = err.message || 'An error occurred while saving the program'
      } finally {
        isSubmitting.value = false
      }
    }

    // Watch for show prop changes to reset form when modal is opened
    watch(() => props.show, (newShow) => {
      if (newShow && !props.program) {
        resetForm()
      }
    })

    return {
      isEditing,
      formData,
      error,
      isSubmitting,
      addRequirement,
      removeRequirement,
      close,
      handleSubmit
    }
  }
}
</script>

<style scoped>
/* Fade animation for backdrop */
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.3s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}

/* Modal animation */
.modal-enter-active,
.modal-leave-active {
  transition: all 0.3s ease;
}

.modal-enter-from,
.modal-leave-to {
  opacity: 0;
  transform: translateY(-30px);
}

.modal-enter-to,
.modal-leave-from {
  opacity: 1;
  transform: translateY(0);
}

.overflow-y-auto {
  scrollbar-width: thin;
  scrollbar-color: #E4E4E7 #ffffff;
}

.overflow-y-auto::-webkit-scrollbar {
  width: 6px;
}

.overflow-y-auto::-webkit-scrollbar-track {
  background: #ffffff;
}

.overflow-y-auto::-webkit-scrollbar-thumb {
  background-color: #E4E4E7;
  border-radius: 3px;
}

/* Add these styles for the radio buttons */
.form-radio {
  @apply border-gray-300;
}

.form-radio:checked {
  background-image: url("data:image/svg+xml,%3csvg viewBox='0 0 16 16' fill='white' xmlns='http://www.w3.org/2000/svg'%3e%3ccircle cx='8' cy='8' r='3'/%3e%3c/svg%3e");
}
</style> 