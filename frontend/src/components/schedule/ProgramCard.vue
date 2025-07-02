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
            <div v-if="programTestSession" class="mt-2 space-y-1">
              <div class="flex flex-wrap items-center gap-2">
                <span class="inline-flex items-center px-2 py-0.5 rounded text-xs font-medium" 
                  :class="{'bg-red-100 text-red-800': examType === 'CET',
                           'bg-blue-100 text-blue-800': examType === 'EAT',
                           'bg-purple-100 text-purple-800': examType === 'NAT',
                           'bg-crimson-100 text-crimson-800': !['CET', 'EAT', 'NAT'].includes(examType)}">
                  <i class="fas fa-graduation-cap mr-1"></i> {{ examType }}
                </span>
              </div>
              <div class="flex flex-wrap items-center gap-2">
                <span class="inline-flex items-center px-2 py-0.5 rounded text-xs font-medium"
                  :class="{
                    'bg-gray-100 text-gray-600': isExamDatePast,
                    'bg-crimson-100 text-crimson-800': !isExamDatePast
                  }">
                  <i :class="['mr-1', isExamDatePast ? 'fas fa-calendar-times' : 'fas fa-calendar-day']"></i> 
                  Exam: {{ examDateFormatted }}
                </span>
              </div>
              <div class="flex flex-wrap items-center gap-2">
                <span class="inline-flex items-center px-2 py-0.5 rounded text-xs font-medium"
                  :class="{
                    'bg-red-100 text-red-600': registrationStatus === 'closed',
                    'bg-yellow-100 text-yellow-700': registrationStatus === 'not_started',
                    'bg-green-100 text-green-800': registrationStatus === 'open'
                  }">
                  <i :class="[
                    'mr-1',
                    registrationStatus === 'closed' ? 'fas fa-times-circle' :
                    registrationStatus === 'not_started' ? 'fas fa-pause-circle' :
                    'fas fa-clock'
                  ]"></i> 
                  Registration: {{ registrationPeriodFormatted }}
                </span>
              </div>
              <!-- Warning message for past exam dates -->
              <div v-if="isExamDatePast" class="mt-1">
                <span class="inline-flex items-center px-2 py-1 rounded text-xs font-medium bg-orange-100 text-orange-700">
                  <i class="fas fa-exclamation-triangle mr-1"></i>
                  This exam date has already passed
                </span>
              </div>
              <!-- Warning message for closed registration -->
              <div v-else-if="registrationStatus === 'closed'" class="mt-1">
                <span class="inline-flex items-center px-2 py-1 rounded text-xs font-medium bg-red-100 text-red-700">
                  <i class="fas fa-exclamation-circle mr-1"></i>
                  Registration period has ended
                </span>
              </div>
              <!-- Info message for future registration -->
              <div v-else-if="registrationStatus === 'not_started'" class="mt-1">
                <span class="inline-flex items-center px-2 py-1 rounded text-xs font-medium bg-blue-100 text-blue-700">
                  <i class="fas fa-info-circle mr-1"></i>
                  Registration not yet started
                </span>
              </div>
            </div>
            <!-- Debug info when no test session matches -->
            <div v-else-if="testSessions && testSessions.length > 0" class="mt-2 text-xs">
              <div class="bg-yellow-50 border border-yellow-200 p-2 rounded text-gray-700">
                <p><strong>Debug:</strong> Available exam types: {{ testSessions.map(s => s.exam_type).join(', ') }}</p>
                <p><strong>Program:</strong> {{ program.name }} ({{ program.code }})</p>
                <p><strong>Test sessions count:</strong> {{ testSessions.length }}</p>
                <div v-if="testSessions[0]" class="mt-2 text-xs">
                  <p><strong>First session:</strong> {{ testSessions[0].exam_type }} - {{ testSessions[0].exam_date }}</p>
                  <p><strong>Registration:</strong> {{ testSessions[0].registration_start_date }} to {{ testSessions[0].registration_end_date }}</p>
                </div>
              </div>
            </div>
            <!-- When no test sessions at all -->
            <div v-else class="mt-2 text-xs text-gray-400">
              <p>No test sessions available ({{ testSessions ? testSessions.length : 'undefined' }})</p>
            </div>
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
              isRestricted || isExamDatePast || registrationStatus === 'closed'
                ? 'bg-gray-300 text-gray-500 cursor-not-allowed' 
                : isScheduled && !hasClaimedAppointment
                  ? 'bg-gradient-to-r from-green-500 to-green-600 hover:from-green-600 hover:to-green-700 text-white' 
                  : 'bg-gradient-to-r from-crimson-600 to-crimson-700 hover:from-crimson-700 hover:to-crimson-800 text-white'
            ]"
            :disabled="isRestricted || isExamDatePast || registrationStatus === 'closed'"
            :title="getButtonTitle()"
          >
            <i :class="['mr-2 text-xs', isScheduled && !hasClaimedAppointment ? 'fas fa-hourglass-half' : 'fas fa-calendar-check']"></i>
            <span>{{ getButtonText() }}</span>
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
    },
    testSessions: {
      type: Array,
      default: () => []
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
  computed: {
    // Find relevant test session based on program exam type
    programTestSession() {
      console.log('ProgramCard: Computing programTestSession for program:', this.program.name);
      console.log('ProgramCard: Available test sessions:', this.testSessions);
      
      if (!this.testSessions || !this.testSessions.length) {
        console.log('ProgramCard: No test sessions available');
        return null;
      }
      
      // Map program names to potential exam types - expanded and more flexible
      const examTypeMap = {
        'CET': ['CET', 'COLLEGE ENTRANCE', 'COLLEGE'],
        'NAT': ['NAT', 'NURSING APTITUDE', 'NURSING'],
        'EAT': ['EAT', 'ENGINEERING APTITUDE', 'ENGINEERING'],
        'UPCAT': ['UPCAT', 'UNIVERSITY OF THE PHILIPPINES'],
        'DCAT': ['DCAT', 'DE LA SALLE']
      };
      
      // Get the program text to match against
      const programText = (this.program.name + ' ' + (this.program.code || '')).toUpperCase();
      const descText = (this.program.description || '').toUpperCase();
      const fullText = programText + ' ' + descText;
      
      console.log('ProgramCard: Full text to match:', fullText);
      
      // Determine the likely exam type for this program
      let examType = null;
      
      // Method 1: Check exact matches with test session exam types first
      const availableExamTypes = [...new Set(this.testSessions.map(s => s.exam_type))];
      console.log('ProgramCard: Available exam types in sessions:', availableExamTypes);
      
      // Direct match with available exam types
      for (const sessionExamType of availableExamTypes) {
        if (fullText.includes(sessionExamType.toUpperCase())) {
          examType = sessionExamType;
          console.log('ProgramCard: Found direct match with session exam type:', examType);
          break;
        }
      }
      
      // Method 2: Use mapping if no direct match
      if (!examType) {
        for (const [type, keywords] of Object.entries(examTypeMap)) {
          if (keywords.some(keyword => fullText.includes(keyword))) {
            // Check if this exam type exists in our test sessions
            if (availableExamTypes.includes(type)) {
              examType = type;
              console.log('ProgramCard: Found mapped exam type:', type, 'via keywords:', keywords);
              break;
            }
          }
        }
      }
      
      // Method 3: Fallback - try to match program name parts with exam types
      if (!examType) {
        const programWords = this.program.name.toUpperCase().split(' ');
        for (const word of programWords) {
          const matchingSession = this.testSessions.find(session => 
            session.exam_type && session.exam_type.toUpperCase().includes(word)
          );
          if (matchingSession) {
            examType = matchingSession.exam_type;
            console.log('ProgramCard: Found word-based match:', examType, 'for word:', word);
            break;
          }
        }
      }
      
      // Method 4: Special case handling based on program names
      if (!examType) {
        if (fullText.includes('ENGINEERING') || fullText.includes('EAT')) {
          examType = 'EAT';
        } else if (fullText.includes('NURSING') || fullText.includes('NAT')) {
          examType = 'NAT';
        } else if (fullText.includes('COLLEGE') || fullText.includes('CET')) {
          examType = 'CET';
        }
        
        // Verify this exam type exists in sessions
        if (examType && !availableExamTypes.includes(examType)) {
          console.log('ProgramCard: Special case exam type not found in sessions:', examType);
          examType = null;
        } else if (examType) {
          console.log('ProgramCard: Using special case exam type:', examType);
        }
      }
      
      if (!examType) {
        console.log('ProgramCard: No exam type could be determined for program:', this.program.name);
        // Fallback: Use the first available test session if any
        if (this.testSessions.length > 0) {
          console.log('ProgramCard: Using first available test session as fallback');
          return this.testSessions[0];
        }
        return null;
      }
      
      console.log('ProgramCard: Final exam type determined:', examType);
      
      // Find the most relevant test session for this exam type
      const today = new Date();
      today.setHours(0, 0, 0, 0); // Reset time for accurate date comparison
      
      const relevantSessions = this.testSessions
        .filter(session => {
          // Match exam type
          const matchesType = session.exam_type === examType;
          
          // Check if session is valid (not completed/cancelled)
          const isValidStatus = session.status === 'SCHEDULED' || session.status === 'ONGOING';
          
          // Check if exam date hasn't passed
          const examDate = new Date(session.exam_date);
          examDate.setHours(0, 0, 0, 0);
          const isUpcoming = examDate >= today;
          
          const isValid = matchesType && isValidStatus && isUpcoming;
          console.log(`ProgramCard: Session ${session.id} (${session.exam_type}):`, {
            matchesType,
            isValidStatus,
            isUpcoming,
            isValid
          });
          
          return isValid;
        })
        .sort((a, b) => {
          // Sort by exam date - closest upcoming first
          const dateA = new Date(a.exam_date);
          const dateB = new Date(b.exam_date);
          return dateA - dateB;
        });
      
      console.log('ProgramCard: Relevant sessions found:', relevantSessions.length);
      
      const result = relevantSessions.length ? relevantSessions[0] : null;
      console.log('ProgramCard: Final result session:', result);
      
      return result;
    },
    
    // Format the exam date nicely with status checking
    examDateFormatted() {
      if (!this.programTestSession) return null;
      const examDate = new Date(this.programTestSession.exam_date);
      const today = new Date();
      today.setHours(0, 0, 0, 0); // Reset time to start of day for accurate comparison
      
      if (examDate < today) {
        return `${this.formatDate(this.programTestSession.exam_date)} (Past)`;
      }
      return this.formatDate(this.programTestSession.exam_date);
    },
    
    // Registration period formatted with status checking
    registrationPeriodFormatted() {
      if (!this.programTestSession) return null;
      const startDate = this.formatDate(this.programTestSession.registration_start_date);
      const endDate = this.formatDate(this.programTestSession.registration_end_date);
      
      const regStartDate = new Date(this.programTestSession.registration_start_date);
      const regEndDate = new Date(this.programTestSession.registration_end_date);
      const today = new Date();
      today.setHours(0, 0, 0, 0);
      
      if (regEndDate < today) {
        return `${startDate} - ${endDate} (Closed)`;
      } else if (regStartDate > today) {
        return `${startDate} - ${endDate} (Not Started)`;
      }
      return `${startDate} - ${endDate}`;
    },
    
    // Check if exam date is in the past
    isExamDatePast() {
      if (!this.programTestSession) return false;
      
      // Consider both the exam date and session status
      const examDate = new Date(this.programTestSession.exam_date);
      examDate.setHours(0, 0, 0, 0);
      const today = new Date();
      today.setHours(0, 0, 0, 0);
      
      // Session is considered past if:
      // 1. Exam date is in the past OR
      // 2. Status is COMPLETED or CANCELLED
      return examDate < today || 
             ['COMPLETED', 'CANCELLED'].includes(this.programTestSession.status);
    },
    
    // Check registration period status
    registrationStatus() {
      if (!this.programTestSession) return 'unknown';
      const regStartDate = new Date(this.programTestSession.registration_start_date);
      const regEndDate = new Date(this.programTestSession.registration_end_date);
      const today = new Date();
      today.setHours(0, 0, 0, 0);
      
      if (regEndDate < today) return 'closed';
      if (regStartDate > today) return 'not_started';
      return 'open';
    },
    
    // Exam type from the test session
    examType() {
      return this.programTestSession?.exam_type || null;
    }
  },
  watch: {
    testSessions: {
      handler(newSessions) {
        console.log('ProgramCard: testSessions changed for program', this.program.name, ':', newSessions);
      },
      immediate: true,
      deep: true
    }
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
      // Prevent action if restricted, exam date is past, or registration is closed
      if (this.isRestricted || this.isExamDatePast || this.registrationStatus === 'closed') {
        return;
      }
      
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
        // Format the date as Month Day, Year (e.g. July 15, 2025)
        return new Intl.DateTimeFormat('en-US', {
          month: 'short', day: 'numeric', year: 'numeric'
        }).format(date);
      } catch (e) {
        console.error("Error formatting date:", e);
        return dateString; // Fallback to original string
      }
    },
    getButtonText() {
      if (this.isExamDatePast) return 'Exam Ended';
      if (this.registrationStatus === 'closed') return 'Registration Closed';
      if (this.registrationStatus === 'not_started') return 'Registration Soon';
      if (this.isScheduled && !this.hasClaimedAppointment) return 'Check Status';
      return 'Schedule Now';
    },
    getButtonTitle() {
      if (this.isRestricted) return this.restrictionReason;
      if (this.isExamDatePast) return 'This exam has already taken place';
      if (this.registrationStatus === 'closed') return 'Registration period has ended';
      if (this.registrationStatus === 'not_started') return 'Registration has not started yet';
      if (this.isScheduled && !this.hasClaimedAppointment) return 'Check your appointment status';
      return 'Schedule an appointment';
    }
  }
}
</script>

<style scoped>
.line-clamp-3 {
  display: -webkit-box;
  -webkit-line-clamp: 3;
  line-clamp: 3;
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