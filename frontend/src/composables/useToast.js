import { ref } from 'vue'

const toasts = ref([])

export function useToast() {
  const showToast = (message, type = 'success', duration = 5000) => {
    const id = Date.now()
    const toast = {
      id,
      message,
      type,
      show: true
    }
    
    toasts.value.push(toast)

    setTimeout(() => {
      // Start hide animation
      const index = toasts.value.findIndex(t => t.id === id)
      if (index !== -1) {
        toasts.value[index].show = false
        
        // Remove after animation completes
        setTimeout(() => {
          const removeIndex = toasts.value.findIndex(t => t.id === id)
          if (removeIndex !== -1) {
            toasts.value.splice(removeIndex, 1)
          }
        }, 300)
      }
    }, duration)
  }

  return {
    toasts,
    showToast
  }
} 