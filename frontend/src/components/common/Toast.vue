<template>
  <div class="fixed top-5 right-5 z-50 flex flex-col items-end space-y-2">
    <transition-group name="toast">
      <div 
        v-for="toast in toasts" 
        :key="toast.id"
        class="max-w-md transform transition-all duration-300 ease-in-out animate-fade-in"
        :class="[
          toast.show ? 'translate-x-0 opacity-100' : 'translate-x-full opacity-0',
          toast.type === 'success' ? 'bg-green-100 border-l-4 border-green-500 text-green-700' :
          toast.type === 'error' ? 'bg-red-100 border-l-4 border-red-500 text-red-700' :
          toast.type === 'info' ? 'bg-blue-100 border-l-4 border-blue-500 text-blue-700' :
          'bg-yellow-100 border-l-4 border-yellow-500 text-yellow-700'
        ]"
      >
        <div class="p-4 rounded shadow-md flex items-center">
          <div class="flex-shrink-0">
            <font-awesome-icon 
              :icon="[
                'fas',
                toast.type === 'success' ? 'check-circle' :
                toast.type === 'error' ? 'exclamation-circle' :
                toast.type === 'info' ? 'info-circle' : 'exclamation-triangle'
              ]" 
              class="h-5 w-5"
              :class="[
                toast.type === 'success' ? 'text-green-500' :
                toast.type === 'error' ? 'text-red-500' :
                toast.type === 'info' ? 'text-blue-500' : 'text-yellow-500'
              ]"
              aria-hidden="true" 
            />
          </div>
          <div class="ml-3">
            <p class="text-sm font-medium">{{ toast.message }}</p>
          </div>
          <div class="ml-auto pl-3">
            <div class="-mx-1.5 -my-1.5">
              <button 
                @click="closeToast(toast.id)" 
                class="inline-flex focus:outline-none"
                :class="[
                  toast.type === 'success' ? 'text-green-500 hover:text-green-600' :
                  toast.type === 'error' ? 'text-red-500 hover:text-red-600' :
                  toast.type === 'info' ? 'text-blue-500 hover:text-blue-600' :
                  'text-yellow-500 hover:text-yellow-600'
                ]"
              >
                <span class="sr-only">Dismiss</span>
                <font-awesome-icon icon="times" class="h-4 w-4" />
              </button>
            </div>
          </div>
        </div>
      </div>
    </transition-group>
  </div>
</template>

<script>
import { useToast } from '../composables/useToast'
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'

export default {
  name: 'Toast',
  components: {
    FontAwesomeIcon
  },
  setup() {
    const { toasts, showToast } = useToast()

    const closeToast = (id) => {
      const index = toasts.value.findIndex(toast => toast.id === id)
      if (index !== -1) {
        toasts.value[index].show = false
        setTimeout(() => {
          const removeIndex = toasts.value.findIndex(toast => toast.id === id)
          if (removeIndex !== -1) {
            toasts.value.splice(removeIndex, 1)
          }
        }, 300)
      }
    }

    return {
      toasts,
      closeToast
    }
  }
}
</script>

<style scoped>
.toast-enter-active, .toast-leave-active {
  transition: all 0.3s ease;
}
.toast-enter-from {
  opacity: 0;
  transform: translateX(30px);
}
.toast-leave-to {
  opacity: 0;
  transform: translateX(30px);
}

/* Add a simple fade-in animation */
@keyframes fadeIn {
  from { opacity: 0; transform: translateY(-10px); }
  to { opacity: 1; transform: translateY(0); }
}

.animate-fade-in {
  animation: fadeIn 0.3s ease-in-out;
}
</style> 