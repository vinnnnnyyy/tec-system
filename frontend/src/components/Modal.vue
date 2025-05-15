<template>
  <Teleport to="body">
    <Transition name="modal">
      <div v-if="show" class="fixed inset-0 z-[9999] overflow-y-auto" aria-labelledby="modal-title" role="dialog" aria-modal="true">
        <div class="flex justify-center px-4 pt-6">
          <!-- Overlay -->
          <div 
            class="fixed inset-0 transition-opacity bg-black/50" 
            @click="$emit('close')"
            aria-hidden="true"
          ></div>

          <!-- Modal panel -->
          <div class="relative inline-block w-full max-w-md p-6 text-left align-middle bg-white shadow-xl rounded-xl">
            <!-- Close button -->
            <button 
              type="button" 
              class="absolute top-3 right-3 text-gray-400 hover:text-gray-600 focus:outline-none p-1 rounded-full hover:bg-gray-100 transition-colors"
              @click="$emit('close')"
              aria-label="Close"
            >
              <font-awesome-icon :icon="['fas', 'times']" class="w-4 h-4" />
            </button>
            
            <div class="flex items-start gap-4">
              <div v-if="icon" class="flex-shrink-0 p-2 rounded-xl" :class="iconBgClass">
                <font-awesome-icon :icon="icon" class="w-6 h-6" :class="iconClass" aria-hidden="true" />
              </div>
              
              <div class="flex-1">
                <h3 class="text-xl font-semibold leading-6 text-gray-900" id="modal-title">
                  {{ title }}
                </h3>
                <div class="mt-3">
                  <p class="text-sm text-gray-600">
                    {{ message }}
                  </p>
                </div>
              </div>
            </div>

            <!-- Button layout -->
            <div class="flex flex-col-reverse gap-2 mt-6 sm:flex-row sm:justify-end">
              <button 
                type="button" 
                class="flex items-center justify-center w-full px-4 py-2 text-sm font-medium text-gray-700 transition-colors duration-200 bg-white border border-gray-300 rounded-lg sm:w-auto hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-gray-500"
                @click="$emit('close')"
              >
                {{ cancelText }}
              </button>
              <button 
                v-if="showConfirm" 
                type="button" 
                class="flex items-center justify-center w-full px-4 py-2 text-sm font-medium text-white transition-colors duration-200 rounded-lg sm:w-auto focus:outline-none focus:ring-2 focus:ring-offset-2"
                :class="confirmButtonClass"
                @click="$emit('confirm')"
              >
                {{ confirmText }}
              </button>
            </div>
          </div>
        </div>
      </div>
    </Transition>
  </Teleport>
</template>

<script>
import { computed } from 'vue'
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'

export default {
  name: 'Modal',
  components: {
    FontAwesomeIcon
  },
  emits: ['confirm', 'close'],
  props: {
    show: {
      type: Boolean,
      required: true
    },
    title: {
      type: String,
      default: 'Confirmation'
    },
    message: {
      type: String,
      default: 'Are you sure you want to proceed?'
    },
    icon: {
      type: Array,
      default: () => ['fas', 'exclamation-triangle']
    },
    type: {
      type: String,
      default: 'warning',
      validator: (value) => ['success', 'warning', 'danger', 'info'].includes(value)
    },
    showConfirm: {
      type: Boolean,
      default: true
    },
    confirmText: {
      type: String,
      default: 'Confirm'
    },
    cancelText: {
      type: String,
      default: 'Cancel'
    }
  },
  setup(props) {
    const iconBgClass = computed(() => {
      switch (props.type) {
        case 'success': return 'bg-green-100'
        case 'danger': return 'bg-red-100'
        case 'info': return 'bg-blue-100'
        default: return 'bg-yellow-100'
      }
    })

    const iconClass = computed(() => {
      switch (props.type) {
        case 'success': return 'text-green-600'
        case 'danger': return 'text-red-600'
        case 'info': return 'text-blue-600'
        default: return 'text-yellow-600'
      }
    })

    const confirmButtonClass = computed(() => {
      switch (props.type) {
        case 'success': return 'bg-green-600 hover:bg-green-700 focus:ring-green-500'
        case 'danger': return 'bg-red-600 hover:bg-red-700 focus:ring-red-500'
        case 'info': return 'bg-blue-600 hover:bg-blue-700 focus:ring-blue-500'
        default: return 'bg-yellow-600 hover:bg-yellow-700 focus:ring-yellow-500'
      }
    })

    return {
      iconBgClass,
      iconClass,
      confirmButtonClass
    }
  }
}
</script>

<style scoped>
.modal-enter-active,
.modal-leave-active {
  transition: opacity 0.15s ease;
}

.modal-enter-from,
.modal-leave-to {
  opacity: 0;
}

.modal-enter-to,
.modal-leave-from {
  opacity: 1;
}

/* Add a separate transition for the modal content */
.modal-enter-active .relative {
  transition: transform 0.2s ease-out;
}

.modal-enter-from .relative {
  transform: translateY(-20px);
}

.modal-enter-to .relative {
  transform: translateY(0);
}
</style> 