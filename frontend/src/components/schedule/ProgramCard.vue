<template>
  <div class="bg-white/90 backdrop-blur-sm rounded-xl overflow-hidden shadow-lg border border-gray-100 h-full flex flex-col hover:border-gray-200 hover:shadow-xl hover:transform hover:scale-[1.01] transition-all duration-300 relative group">
    <!-- Card Header with colored accent -->
    <div class="h-1.5 bg-gradient-to-r from-crimson-500 to-crimson-600"></div>
    
    <div class="flex flex-col h-full p-5 sm:p-6">
      <!-- Header Section -->
      <div class="flex justify-between items-start mb-4">
        <div class="flex items-center flex-grow min-w-0">
          <div class="flex-shrink-0 mr-4">
            <div class="w-11 h-11 bg-crimson-50 border border-crimson-100 text-crimson-600 rounded-full flex items-center justify-center shadow-sm">
              <i :class="`fas fa-${program.icon || 'book'} text-base`"></i>
            </div>
          </div>
          <div class="flex-grow min-w-0">
            <h3 class="font-semibold text-gray-800 text-lg truncate" :title="program.name">{{ program.name }}</h3>
            <p class="text-sm text-gray-500">{{ program.code }}</p>
          </div>
        </div>
      </div>
      
      <!-- Description -->
      <div class="mb-5 text-sm text-gray-600 flex-grow" ref="descriptionContainer">
        <p :class="{'line-clamp-3': !showFullDescription && isDescriptionLong}" :style="{ 'max-height': showFullDescription ? 'none' : '60px' }">
          {{ program.description || 'No description available.' }}
        </p>
        <button 
          v-if="isDescriptionLong" 
          @click="toggleDescription" 
          class="text-crimson-600 text-xs font-medium mt-1.5 hover:text-crimson-700 transition-colors duration-200"
        >
          {{ showFullDescription ? 'Show less' : 'Read more' }}
        </button>
      </div>
      
      <!-- Action Buttons -->
      <div class="mt-auto pt-4 border-t border-gray-100">
        <div class="flex flex-col gap-3">
          <!-- Schedule/Check Status Button -->
          <button 
            @click="handleButtonClick"
            class="w-full font-semibold text-sm py-3 px-4 rounded-lg transition-all duration-300 flex items-center justify-center shadow-sm hover:shadow-md transform hover:-translate-y-0.5"
            :class="[
              isRestricted 
                ? 'bg-gray-300 text-gray-500 cursor-not-allowed' 
                : isScheduled && !hasClaimedAppointment
                  ? 'bg-gradient-to-r from-green-500 to-green-600 hover:from-green-600 hover:to-green-700 text-white' 
                  : 'bg-gradient-to-r from-crimson-600 to-crimson-700 hover:from-crimson-700 hover:to-crimson-800 text-white'
            ]"
            :disabled="isRestricted"
            :title="isRestricted ? restrictionReason : (isScheduled && !hasClaimedAppointment ? 'Check your appointment status' : 'Schedule an appointment')"
          >
            <i :class="['mr-2 text-xs', isScheduled && !hasClaimedAppointment ? 'fas fa-hourglass-half' : 'fas fa-calendar-check']"></i>
            <span>{{ isScheduled && !hasClaimedAppointment ? 'Check Status' : 'Schedule Now' }}</span>
          </button>
          
          <!-- Requirements Button -->
          <button 
            @click="toggleRequirements"
            class="w-full bg-gray-50 hover:bg-gray-100 border border-gray-200 text-gray-700 text-sm font-medium py-2.5 px-4 rounded-lg transition-all duration-200 flex items-center justify-center shadow-sm hover:shadow-xs"
            title="View program requirements"
          >
            <i class="fas fa-list-ul mr-2 text-gray-400 text-xs"></i>
            <span>View Requirements</span>
            <i :class="['fas ml-auto text-gray-400 text-xs transition-transform duration-200', showRequirements ? 'fa-chevron-up' : 'fa-chevron-down']"></i>
          </button>
        </div>
      </div>
    </div>
    
    <!-- Requirements Overlay Panel -->
    <Transition name="fade">
      <div v-if="showRequirements" 
           class="requirements-panel" 
           @click.self="toggleRequirements">
        <div class="requirements-content bg-white rounded-xl shadow-2xl border border-gray-200 overflow-hidden">
          <div class="p-5 sm:p-6">
            <div class="flex items-center justify-between mb-4">
              <h5 class="font-semibold text-gray-800 text-lg">Program Requirements</h5>
              <button @click="toggleRequirements" class="text-gray-400 hover:text-gray-600 transition-colors rounded-full w-8 h-8 flex items-center justify-center hover:bg-gray-100">
                <i class="fas fa-times"></i>
              </button>
            </div>
            
            <div class="max-h-[60vh] sm:max-h-[50vh] overflow-y-auto scrollbar-thin pr-2 -mr-2">
              <ul v-if="program.requirements && program.requirements.length > 0" class="space-y-2">
                <li v-for="(requirement, index) in program.requirements" 
                     :key="index" 
                     class="flex items-start text-sm text-gray-600">
                  <i class="fas fa-check-circle text-green-500 mt-1 mr-2.5 flex-shrink-0"></i>
                  <span>{{ requirement }}</span>
                </li>
              </ul>
              <div v-else class="py-6 text-sm text-gray-500 text-center italic">
                No specific requirements listed for this program.
              </div>
            </div>
          </div>
          <div class="bg-gray-50 px-5 py-3 sm:px-6 sm:py-4 text-right">
             <button @click="toggleRequirements" class="px-4 py-2 bg-gray-200 text-gray-700 text-sm font-medium rounded-md hover:bg-gray-300 transition-colors">
               Close
             </button>
          </div>
        </div>
      </div>
    </Transition>
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
    },
    appointmentId: {
      type: [String, Number, Array],
      default: null
    },
    hasClaimedAppointment: {
      type: Boolean,
      default: false
    },
    isRestricted: {
      type: Boolean,
      default: false
    },
    restrictionReason: {
      type: String,
      default: ''
    }
  },
  data() {
    return {
      showRequirements: false,
      showFullDescription: false,
      isDescriptionLong: false
    }
  },
  mounted() {
    this.checkDescriptionLength();
  },
  updated() {
    this.checkDescriptionLength();
  },
  methods: {
    checkDescriptionLength() {
      // Check if description needs truncation only after mount/update
      this.$nextTick(() => {
        const el = this.$refs.descriptionContainer;
        if (el) {
          // A simple approximation: check if content height exceeds line-clamp height
          this.isDescriptionLong = el.scrollHeight > 65; // Adjust 65 based on line-height * lines
        }
      });
    },
    toggleDescription() {
      this.showFullDescription = !this.showFullDescription;
    },
    toggleRequirements() {
      this.showRequirements = !this.showRequirements
    },
    handleButtonClick() {
      if (this.isRestricted) return;
      
      if (this.isScheduled && !this.hasClaimedAppointment) {
        const latestAppointmentId = Array.isArray(this.appointmentId) 
          ? this.appointmentId[this.appointmentId.length - 1] 
          : this.appointmentId;
          
        this.$emit('check-status', {
          program: this.program,
          appointmentId: String(latestAppointmentId)
        });
      } else {
        const isRescheduling = this.$route.query.reschedule === 'true';
        const originalAppointmentId = this.$route.query.appointmentId;
        
        if (isRescheduling && originalAppointmentId) {
          this.$emit('schedule', {
            program: this.program,
            reschedulingInfo: {
              isRescheduling: true,
              originalAppointmentId: originalAppointmentId
            }
          });
        } else {
          this.$emit('schedule', this.program);
        }
      }
    },
    formatDate(dateString) {
      if (!dateString) return 'Ongoing';
      const date = new Date(dateString);
      // Check if date is valid
      if (isNaN(date.getTime())) {
        return 'Invalid Date';
      }
      try {
        return new Intl.DateTimeFormat('en-US', {
          month: 'short', day: 'numeric', year: 'numeric'
        }).format(date);
      } catch (e) {
        console.error("Error formatting date:", e);
        return dateString; // Fallback to original string
      }
    }
  }
}
</script>

<style scoped>
.line-clamp-3 {
  display: -webkit-box;
  -webkit-line-clamp: 3;
  -webkit-box-orient: vertical;
  overflow: hidden;
  text-overflow: ellipsis;
}

/* Requirements Panel */
.requirements-panel {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(0, 0, 0, 0.6); /* Darker overlay */
  backdrop-filter: blur(5px);
  z-index: 100; /* Higher z-index */
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 1rem;
}

.requirements-content {
  width: 100%;
  max-width: 550px; /* Slightly wider */
  max-height: 90vh;
  display: flex;
  flex-direction: column;
}

/* Transitions for the overlay */
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.3s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}

/* Slide up transition for the content within the overlay */
.fade-enter-active .requirements-content,
.fade-leave-active .requirements-content {
  transition: transform 0.3s ease, opacity 0.3s ease;
}

.fade-enter-from .requirements-content {
  transform: translateY(20px);
  opacity: 0;
}
.fade-leave-to .requirements-content {
  transform: translateY(20px);
  opacity: 0;
}

.scrollbar-thin {
  scrollbar-width: thin;
  scrollbar-color: #d1d5db #f9fafb; /* thumb track */
}

.scrollbar-thin::-webkit-scrollbar {
  width: 5px;
}

.scrollbar-thin::-webkit-scrollbar-track {
  background: #f9fafb;
  border-radius: 3px;
}

.scrollbar-thin::-webkit-scrollbar-thumb {
  background-color: #d1d5db;
  border-radius: 3px;
  border: 1px solid #f9fafb;
}

.scrollbar-thin::-webkit-scrollbar-thumb:hover {
  background-color: #9ca3af;
}

/* Subtle pulse animation for Check Status button */
button.bg-gradient-to-r.from-green-500:not(:disabled):hover {
  animation: pulse 1.5s infinite;
}

@keyframes pulse {
  0%, 100% {
    opacity: 1;
    box-shadow: 0 0 0 0 rgba(34, 197, 94, 0.4);
  }
  50% {
    opacity: 1;
    box-shadow: 0 0 0 6px rgba(34, 197, 94, 0);
  }
}

/* Improve truncation */
.truncate {
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}
</style> 