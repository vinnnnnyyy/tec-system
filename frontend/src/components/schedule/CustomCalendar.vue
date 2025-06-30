<template>
  <div class="custom-calendar" @click.stop>
    <div class="calendar-header flex justify-between items-center mb-2 md:mb-4">
      <button 
        @click.stop.prevent="prevMonth" 
        class="text-gray-600 hover:text-gray-900 p-1"
        aria-label="Previous month"
      >
        <i class="fas fa-chevron-left"></i>
      </button>
      <h3 class="text-sm md:text-lg font-medium text-gray-900">{{ monthYearText }}</h3>
      <button 
        @click.stop.prevent="nextMonth" 
        class="text-gray-600 hover:text-gray-900 p-1"
        aria-label="Next month"
      >
        <i class="fas fa-chevron-right"></i>
      </button>
    </div>
    
    <!-- Days of week header -->
    <div class="grid grid-cols-7 gap-1 mb-1 md:mb-2">
      <div v-for="day in daysOfWeek" :key="day" class="text-center text-xs md:text-sm font-medium text-gray-700 py-1">
        {{ day }}
      </div>
    </div>
    
    <!-- Calendar grid -->
    <div class="grid grid-cols-7 gap-1">
      <!-- Empty cells for days before the 1st of the month -->
      <div 
        v-for="_ in firstDayOfMonth" 
        :key="'empty-start-' + _" 
        class="h-8 md:h-10 rounded-md"
      ></div>
      
      <!-- Actual date cells -->
      <div 
        v-for="date in daysInMonth" 
        :key="date"
        :class="[
          'relative h-8 md:h-12 flex flex-col items-center justify-center rounded-lg cursor-pointer transition-all duration-200 text-xs md:text-sm font-medium',
          isDateSelected(date) ? '' : 'hover:bg-purple-50 hover:border-purple-200',
          !isDateSelectable(date) ? 'opacity-50 cursor-not-allowed' : '',
          isDateToday(date) ? 'ring-2 ring-purple-400 ring-offset-1' : '',
          getExamDateClasses(date),
          getRegistrationDateClasses(date),
          // Fallback for selected dates without special highlighting
          isDateSelected(date) && !isExamDate(date) && !isRegistrationDate(date) ? 'bg-purple-600 text-white border-2 border-purple-700 shadow-lg' : ''
        ]"
        @click="selectDate(date)"
      >
        <!-- Date number -->
        <span class="mb-0.5 md:mb-1 font-bold relative z-10 text-shadow-sm">{{ date }}</span>
        
        <!-- Date type indicators with enhanced styling -->
        <div class="absolute top-1 right-1 flex flex-col gap-0.5">
          <!-- Exam date indicator with enhanced tooltip -->
          <div v-if="isExamDate(date)" 
               class="relative group">
            <span :class="[
              'h-3 w-3 md:h-4 md:w-4 rounded-full border-2 border-white shadow-lg animate-pulse',
              getExamTypeColors(getTestSessionForDate(date)?.exam_type).dotColor
            ]"></span>
            <!-- Enhanced tooltip for exam date -->
            <div class="absolute z-30 bottom-full right-0 mb-2 px-3 py-2 bg-gray-900 text-white text-xs rounded-lg opacity-0 group-hover:opacity-100 transition-opacity whitespace-nowrap pointer-events-none shadow-xl">
              <div class="font-semibold">{{ getExamTypeColors(getTestSessionForDate(date)?.exam_type).name }}</div>
              <div class="text-gray-300">Exam Date</div>
              <!-- Arrow pointing down -->
              <div class="absolute top-full right-2 w-0 h-0 border-l-4 border-r-4 border-t-4 border-transparent border-t-gray-900"></div>
            </div>
          </div>
          
          <!-- Registration period indicator with enhanced tooltip -->
          <div v-if="isRegistrationDate(date) && !isExamDate(date)" 
               class="relative group">
            <span class="h-3 w-3 md:h-4 md:w-4 rounded-full bg-green-500 border-2 border-white shadow-lg animate-pulse"></span>
            <!-- Enhanced tooltip for registration date -->
            <div class="absolute z-30 bottom-full right-0 mb-2 px-3 py-2 bg-gray-900 text-white text-xs rounded-lg opacity-0 group-hover:opacity-100 transition-opacity whitespace-nowrap pointer-events-none shadow-xl">
              <div class="font-semibold">Registration Open</div>
              <div class="text-gray-300">{{ getRegistrationSessionsForDate(date).length }} exam(s)</div>
              <!-- Arrow pointing down -->
              <div class="absolute top-full right-2 w-0 h-0 border-l-4 border-r-4 border-t-4 border-transparent border-t-gray-900"></div>
            </div>
          </div>
        </div>
        
        <!-- Capacity indicators -->
        <div class="flex justify-center gap-0.5 md:gap-1">
          <!-- Morning capacity -->
          <div v-if="getDateCapacity(date, 'morning')" 
               class="relative group">
            <span 
              :class="[
                'h-1 w-1 md:h-1.5 md:w-1.5 rounded-full',
                getCapacityColor(date, 'morning')
              ]"
            ></span>
            <!-- Tooltip with capacity details - positioned better for mobile -->
            <div class="absolute z-20 bottom-full left-1/2 transform -translate-x-1/2 -translate-y-1 mb-1 px-2 py-1 bg-gray-800 text-white text-xs rounded opacity-0 group-hover:opacity-100 transition-opacity whitespace-nowrap pointer-events-none">
              Morning: {{ getDateCapacityText(date, 'morning') }}
            </div>
          </div>
          
          <!-- Afternoon capacity -->
          <div v-if="getDateCapacity(date, 'afternoon')" 
               class="relative group">
            <span 
              :class="[
                'h-1 w-1 md:h-1.5 md:w-1.5 rounded-full',
                getCapacityColor(date, 'afternoon')
              ]"
            ></span>
            <!-- Tooltip with capacity details - positioned better for mobile -->
            <div class="absolute z-20 bottom-full left-1/2 transform -translate-x-1/2 -translate-y-1 mb-1 px-2 py-1 bg-gray-800 text-white text-xs rounded opacity-0 group-hover:opacity-100 transition-opacity whitespace-nowrap pointer-events-none">
              Afternoon: {{ getDateCapacityText(date, 'afternoon') }}
            </div>
          </div>
        </div>
      </div>
      
      <!-- Empty cells for days after the last day of the month -->
      <div 
        v-for="_ in emptyCellsAtEnd" 
        :key="'empty-end-' + _" 
        class="h-8 md:h-10 rounded-md"
      ></div>
    </div>
    
    <!-- Legend -->
    <div class="mt-2 md:mt-4 space-y-2">
      <!-- Capacity indicators legend -->
      <div class="flex flex-wrap items-center justify-start gap-2 md:gap-4 text-xs text-gray-600">
        <div class="flex items-center">
          <span class="h-2 w-2 rounded-full bg-green-500 mr-1"></span>
          <span>Morning</span>
        </div>
        <div class="flex items-center">
          <span class="h-2 w-2 rounded-full bg-blue-500 mr-1"></span>
          <span>Afternoon</span>
        </div>
        <div class="flex items-center">
          <span class="h-2 w-2 rounded-full bg-yellow-500 mr-1"></span>
          <span>Half Full</span>
        </div>
        <div class="flex items-center">
          <span class="h-2 w-2 rounded-full bg-orange-500 mr-1"></span>
          <span>Nearly Full</span>
        </div>
        <div class="flex items-center">
          <span class="h-2 w-2 rounded-full bg-red-500 mr-1"></span>
          <span>Full</span>
        </div>
      </div>
      
      <!-- Enhanced date type indicators legend -->
      <div class="flex flex-wrap items-center justify-start gap-2 md:gap-4 text-xs text-gray-600 pt-2 border-t border-gray-200">
        <div class="flex items-center">
          <div class="h-3 w-3 rounded-sm bg-green-50 border-4 border-green-400 mr-1"></div>
          <span>Registration Open</span>
        </div>
        
        <!-- Exam type legends based on actual test sessions -->
        <div class="flex items-center">
          <div class="h-3 w-3 rounded-sm bg-red-100 border-4 border-red-500 mr-1"></div>
          <span>CET Exam</span>
        </div>
        <div class="flex items-center">
          <div class="h-3 w-3 rounded-sm bg-blue-100 border-4 border-blue-500 mr-1"></div>
          <span>EAT Exam</span>
        </div>
        <div class="flex items-center">
          <div class="h-3 w-3 rounded-sm bg-purple-100 border-4 border-purple-500 mr-1"></div>
          <span>NAT Exam</span>
        </div>
        <div class="flex items-center">
          <div class="h-3 w-3 rounded-sm bg-yellow-100 border-4 border-yellow-500 mr-1"></div>
          <span>Other Exam</span>
        </div>
        <div class="flex items-center">
          <div class="h-3 w-3 rounded-sm bg-indigo-100 border-4 border-indigo-500 mr-1"></div>
          <span>Diagnostic Test</span>
        </div>
        
        <div class="flex items-center">
          <div class="h-3 w-3 rounded-sm ring-2 ring-purple-400 ring-offset-1 mr-1"></div>
          <span>Today</span>
        </div>
      </div>
    </div>
    
    <!-- Selected date display -->
    <div v-if="selectedDateFormatted" class="mt-2 md:mt-4 p-2 md:p-3 bg-gray-50 rounded-lg">
      <div class="font-medium text-xs md:text-sm">Selected Date: {{ selectedDateFormatted }}</div>
      
      <!-- Enhanced test session information for selected date -->
      <div v-if="selectedDate" class="mt-2 space-y-2">
        <!-- Exam date notification with enhanced styling -->
        <div v-if="isExamDate(selectedDate)" :class="[
          'p-3 rounded-lg border-l-4 shadow-sm',
          getExamTypeColors(getTestSessionForDate(selectedDate)?.exam_type).background,
          `border-l-${getExamTypeColors(getTestSessionForDate(selectedDate)?.exam_type).border.split('-')[1]}-500`,
          getExamTypeColors(getTestSessionForDate(selectedDate)?.exam_type).text
        ]">
          <div class="flex items-center text-sm font-semibold">
            <i class="fas fa-calendar-day mr-2"></i>
            <span>{{ getExamTypeColors(getTestSessionForDate(selectedDate)?.exam_type).name }}</span>
          </div>
          <div class="text-xs mt-1 opacity-80">
            Exam scheduled for {{ selectedDateFormatted }}
          </div>
          <div v-if="getTestSessionForDate(selectedDate)?.description" class="text-xs mt-2 font-medium">
            {{ getTestSessionForDate(selectedDate).description }}
          </div>
        </div>
        
        <!-- Registration period notification with enhanced styling -->
        <div v-if="isRegistrationDate(selectedDate) && !isExamDate(selectedDate)" class="p-3 bg-green-50 border-l-4 border-l-green-500 rounded-lg shadow-sm">
          <div class="flex items-center text-sm text-green-800 font-semibold">
            <i class="fas fa-user-check mr-2"></i>
            <span>Registration Period Active</span>
          </div>
          <div class="text-xs text-green-700 mt-1">
            Registration is open for {{ getRegistrationSessionsForDate(selectedDate).length }} upcoming exam(s)
          </div>
          <div class="mt-2 space-y-1">
            <div v-for="session in getRegistrationSessionsForDate(selectedDate)" :key="session.id" class="text-xs text-green-700">
              • {{ getExamTypeColors(session.exam_type).name }} (Exam: {{ session.exam_date }})
            </div>
          </div>
        </div>
      </div>
      
      <!-- Capacity information for selected date -->
      <div v-if="selectedDate && getDateCapacity(selectedDate, 'morning')" class="mt-2 mb-2 md:mb-3 text-xs">
        <div class="grid grid-cols-2 gap-2">
          <!-- Morning capacity -->
          <div>
            <div class="flex justify-between mb-1">
              <span class="text-gray-600">Morning:</span>
              <span :class="getCapacityColor(selectedDate, 'morning').replace('bg-', 'text-')">
                {{ getDateCapacity(selectedDate, 'morning').count }}/{{ getDateCapacity(selectedDate, 'morning').capacity }}
              </span>
            </div>
            <div class="w-full bg-gray-200 rounded-full h-1.5">
              <div class="h-1.5 rounded-full" 
                   :class="getCapacityColor(selectedDate, 'morning')"
                   :style="{
                     width: Math.min(
                       (getDateCapacity(selectedDate, 'morning').count / 
                        getDateCapacity(selectedDate, 'morning').capacity) * 100, 
                       100
                     ) + '%'
                   }">
              </div>
            </div>
          </div>
          
          <!-- Afternoon capacity -->
          <div>
            <div class="flex justify-between mb-1">
              <span class="text-gray-600">Afternoon:</span>
              <span :class="getCapacityColor(selectedDate, 'afternoon').replace('bg-', 'text-')">
                {{ getDateCapacity(selectedDate, 'afternoon').count }}/{{ getDateCapacity(selectedDate, 'afternoon').capacity }}
              </span>
            </div>
            <div class="w-full bg-gray-200 rounded-full h-1.5">
              <div class="h-1.5 rounded-full" 
                   :class="getCapacityColor(selectedDate, 'afternoon')"
                   :style="{
                     width: Math.min(
                       (getDateCapacity(selectedDate, 'afternoon').count / 
                        getDateCapacity(selectedDate, 'afternoon').capacity) * 100, 
                       100
                     ) + '%'
                   }">
              </div>
            </div>
          </div>
        </div>
      </div>
      
      <div class="flex flex-wrap gap-1 md:gap-2 mt-2">
        <div 
          v-if="isMorningAvailable" 
          :class="[
            'px-2 md:px-3 py-1 rounded-md text-xs md:text-sm cursor-pointer transition-all',
            selectedTimeSlot === 'morning' ? 'bg-purple-600 text-white' : 'bg-gray-200 hover:bg-gray-300'
          ]"
          @click="selectTimeSlot('morning')"
        >
          Morning (8:00 AM - 12:00 PM)
        </div>
        <div 
          v-if="isAfternoonAvailable" 
          :class="[
            'px-2 md:px-3 py-1 rounded-md text-xs md:text-sm cursor-pointer transition-all',
            selectedTimeSlot === 'afternoon' ? 'bg-purple-600 text-white' : 'bg-gray-200 hover:bg-gray-300'
          ]"
          @click="selectTimeSlot('afternoon')"
        >
          Afternoon (1:00 PM - 5:00 PM)
        </div>
        <div v-if="!isMorningAvailable && !isAfternoonAvailable" class="text-red-500 text-xs md:text-sm">
          No available time slots for this date
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { ref, computed, watch, onMounted } from 'vue';

export default {
  name: 'CustomCalendar',
  props: {
    modelValue: {
      type: String,
      default: ''
    },
    dateAvailability: {
      type: Object,
      default: () => ({})
    },
    timeSlotValue: {
      type: String,
      default: ''
    },
    testSessions: {
      type: Array,
      default: () => []
    }
  },
  emits: ['update:modelValue', 'update:timeSlotValue', 'date-selected', 'time-slot-selected'],
  
  setup(props, { emit }) {
    const currentMonth = ref(new Date().getMonth());
    const currentYear = ref(new Date().getFullYear());
    const selectedDate = ref(null);
    const selectedTimeSlot = ref(props.timeSlotValue || '');
    
    // Days of the week labels
    const daysOfWeek = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    
    // Calculate days in the current month
    const daysInMonth = computed(() => {
      return new Date(currentYear.value, currentMonth.value + 1, 0).getDate();
    });
    
    // Calculate the first day of the month (0 = Sunday, 6 = Saturday)
    const firstDayOfMonth = computed(() => {
      return new Date(currentYear.value, currentMonth.value, 1).getDay();
    });
    
    // Calculate empty cells at the end to complete the grid
    const emptyCellsAtEnd = computed(() => {
      const totalCells = 42; // 6 rows of 7 days
      return totalCells - (firstDayOfMonth.value + daysInMonth.value);
    });
    
    // Format month and year for display
    const monthYearText = computed(() => {
      const monthNames = [
        'January', 'February', 'March', 'April', 'May', 'June', 
        'July', 'August', 'September', 'October', 'November', 'December'
      ];
      return `${monthNames[currentMonth.value]} ${currentYear.value}`;
    });
    
    // Format the selected date for display (YYYY-MM-DD)
    const selectedDateFormatted = computed(() => {
      if (!selectedDate.value) return '';
      
      const day = selectedDate.value;
      const month = currentMonth.value + 1;
      const year = currentYear.value;
      
      return `${year}-${month.toString().padStart(2, '0')}-${day.toString().padStart(2, '0')}`;
    });
    
    // Check if a date is selectable (not a Sunday and has availability)
    const isDateSelectable = (day) => {
      // Get today's date
      const today = new Date();
      today.setHours(0, 0, 0, 0);
      
      // Get the date to check
      const dateToCheck = new Date(currentYear.value, currentMonth.value, day);
      
      // Don't allow selection of past dates or today
      if (dateToCheck <= today) return false;
      
      // Don't allow selection of Sundays
      if (new Date(currentYear.value, currentMonth.value, day).getDay() === 0) {
        return false;
      }
      
      // Check if date is available in the availability data
      const dateStr = formatDateForApi(new Date(currentYear.value, currentMonth.value, day));
      if (props.dateAvailability && props.dateAvailability[dateStr]) {
        // Date is selectable if either morning OR afternoon has availability
        return props.dateAvailability[dateStr].morning_available || 
               props.dateAvailability[dateStr].afternoon_available;
      }
      
      // If no availability data, assume available (except Sundays)
      return true;
    };
    
    // Check if a date is an exam date
    const isExamDate = (day) => {
      const dateStr = formatDateForApi(new Date(currentYear.value, currentMonth.value, day));
      const result = props.testSessions.some(session => session.exam_date === dateStr);
      
      // Debug logging - only log for specific dates to avoid spam
      if (dateStr === '2025-06-29' || dateStr === '2025-07-29' || dateStr === '2025-07-21' || dateStr === '2025-06-27') {
        console.log(`📅 Checking exam date ${dateStr}: ${result}`, {
          testSessionsCount: props.testSessions.length,
          matchingSessions: props.testSessions.filter(s => s.exam_date === dateStr)
        });
      }
      
      return result;
    };

    // Check if a date is within registration period
    const isRegistrationDate = (day) => {
      const dateStr = formatDateForApi(new Date(currentYear.value, currentMonth.value, day));
      const currentDate = new Date(dateStr);
      
      const result = props.testSessions.some(session => {
        const regStart = new Date(session.registration_start_date);
        const regEnd = new Date(session.registration_end_date);
        return currentDate >= regStart && currentDate <= regEnd;
      });
      
      // Debug logging - only log for specific dates
      if (dateStr === '2025-06-29' || dateStr === '2025-06-30' || dateStr === '2025-07-01') {
        const matchingSessions = props.testSessions.filter(session => {
          const regStart = new Date(session.registration_start_date);
          const regEnd = new Date(session.registration_end_date);
          return currentDate >= regStart && currentDate <= regEnd;
        });
        console.log(`🟢 Checking registration date ${dateStr}: ${result}`, {
          testSessionsCount: props.testSessions.length,
          matchingSessions
        });
      }
      
      return result;
    };

    // Get test session for a date
    const getTestSessionForDate = (day) => {
      const dateStr = formatDateForApi(new Date(currentYear.value, currentMonth.value, day));
      return props.testSessions.find(session => session.exam_date === dateStr);
    };

    // Get exam type color scheme
    const getExamTypeColors = (examType) => {
      const colorSchemes = {
        'CET': {
          background: 'bg-red-100',
          border: 'border-red-500',
          text: 'text-red-800',
          selectedBg: 'bg-red-600',
          dotColor: 'bg-red-600',
          name: 'CET'
        },
        'EAT': {
          background: 'bg-blue-100',
          border: 'border-blue-500',
          text: 'text-blue-800',
          selectedBg: 'bg-blue-600',
          dotColor: 'bg-blue-600',
          name: 'EAT'
        },
        'NAT': {
          background: 'bg-purple-100',
          border: 'border-purple-500',
          text: 'text-purple-800',
          selectedBg: 'bg-purple-600',
          dotColor: 'bg-purple-600',
          name: 'NAT'
        },
        'WMSU-CET': {
          background: 'bg-red-100',
          border: 'border-red-500',
          text: 'text-red-800',
          selectedBg: 'bg-red-600',
          dotColor: 'bg-red-600',
          name: 'WMSU-CET'
        },
        'ENTRANCE': {
          background: 'bg-yellow-100',
          border: 'border-yellow-500',
          text: 'text-yellow-800',
          selectedBg: 'bg-yellow-600',
          dotColor: 'bg-yellow-600',
          name: 'Entrance Exam'
        },
        'PLACEMENT': {
          background: 'bg-indigo-100',
          border: 'border-indigo-500',
          text: 'text-indigo-800',
          selectedBg: 'bg-indigo-600',
          dotColor: 'bg-indigo-600',
          name: 'Placement Test'
        }
      };
      
      // Default to yellow if exam type not found
      return colorSchemes[examType] || colorSchemes['ENTRANCE'];
    };

    // Get exam date styling classes
    const getExamDateClasses = (day) => {
      const session = getTestSessionForDate(day);
      if (!session) return '';
      
      const colors = getExamTypeColors(session.exam_type);
      
      if (isDateSelected(day)) {
        return `${colors.selectedBg} text-white border-4 shadow-lg transform scale-105`;
      }
      
      return `${colors.background} border-4 ${colors.border} shadow-md hover:shadow-lg transform hover:scale-102 transition-all duration-200`;
    };

    // Get registration sessions for a date
    const getRegistrationSessionsForDate = (day) => {
      const dateStr = formatDateForApi(new Date(currentYear.value, currentMonth.value, day));
      const currentDate = new Date(dateStr);
      
      return props.testSessions.filter(session => {
        const regStart = new Date(session.registration_start_date);
        const regEnd = new Date(session.registration_end_date);
        return currentDate >= regStart && currentDate <= regEnd;
      });
    };

    // Get registration date styling classes
    const getRegistrationDateClasses = (day) => {
      if (isExamDate(day)) return ''; // Exam dates take priority
      
      const sessions = getRegistrationSessionsForDate(day);
      if (sessions.length === 0) return '';
      
      if (isDateSelected(day)) {
        return `bg-green-600 text-white border-4 border-green-700 shadow-lg transform scale-105`;
      }
      
      return `bg-green-50 border-4 border-green-400 shadow-md hover:shadow-lg hover:bg-green-100 transform hover:scale-102 transition-all duration-200`;
    };
    const isDateToday = (day) => {
      const today = new Date();
      return (
        day === today.getDate() &&
        currentMonth.value === today.getMonth() &&
        currentYear.value === today.getFullYear()
      );
    };
    
    // Check if a date is the selected date
    const isDateSelected = (day) => {
      return selectedDate.value === day;
    };
    
    // Check if a date has availability for a specific time slot
    const hasDateAvailability = (day, timeSlot) => {
      const dateStr = formatDateForApi(new Date(currentYear.value, currentMonth.value, day));
      
      if (props.dateAvailability && props.dateAvailability[dateStr]) {
        if (timeSlot === 'morning') {
          return props.dateAvailability[dateStr].morning_available;
        } else if (timeSlot === 'afternoon') {
          return props.dateAvailability[dateStr].afternoon_available;
        }
      }
      
      // If no availability data, assume available (except Sundays)
      const isSelectable = isDateSelectable(day);
      return isSelectable;
    };
    
    // Get capacity information for a specific date and time slot
    const getDateCapacity = (day, timeSlot) => {
      const dateStr = formatDateForApi(new Date(currentYear.value, currentMonth.value, day));
      
      if (props.dateAvailability && props.dateAvailability[dateStr]) {
        const dateInfo = props.dateAvailability[dateStr];
        const totalCapacity = dateInfo.capacity || 1;
        // Split capacity evenly between morning and afternoon (50% each)
        const halfCapacity = Math.floor(totalCapacity / 2);
        
        if (timeSlot === 'morning') {
          return {
            count: dateInfo.morning_count || 0,
            capacity: halfCapacity,
            available: dateInfo.morning_available
          };
        } else if (timeSlot === 'afternoon') {
          return {
            count: dateInfo.afternoon_count || 0,
            capacity: halfCapacity,
            available: dateInfo.afternoon_available
          };
        }
      }
      
      return null;
    };
    
    // Get color for capacity indicator based on utilization
    const getCapacityColor = (day, timeSlot) => {
      const capacity = getDateCapacity(day, timeSlot);
      if (!capacity) return 'bg-gray-400';
      
      if (!capacity.available) return 'bg-red-500';
      
      const utilization = capacity.count / capacity.capacity;
      if (utilization >= 0.8) return 'bg-orange-500';
      if (utilization >= 0.5) return 'bg-yellow-500';
      return timeSlot === 'morning' ? 'bg-green-500' : 'bg-blue-500';
    };
    
    // Get text for capacity tooltip
    const getDateCapacityText = (day, timeSlot) => {
      const capacity = getDateCapacity(day, timeSlot);
      if (!capacity) return 'Not available';
      
      if (!capacity.available) return 'Fully booked';
      
      return `${capacity.count}/${capacity.capacity} slots filled`;
    };
    
    // Computed properties for time slot availability
    const isMorningAvailable = computed(() => {
      if (!selectedDate.value) return false;
      return hasDateAvailability(selectedDate.value, 'morning');
    });
    
    const isAfternoonAvailable = computed(() => {
      if (!selectedDate.value) return false;
      return hasDateAvailability(selectedDate.value, 'afternoon');
    });
    
    // Helper function to format dates for API
    const formatDateForApi = (date) => {
      const year = date.getFullYear();
      const month = String(date.getMonth() + 1).padStart(2, '0');
      const day = String(date.getDate()).padStart(2, '0');
      return `${year}-${month}-${day}`;
    };
    
    // Calendar navigation
    const prevMonth = () => {
      if (currentMonth.value === 0) {
        currentMonth.value = 11;
        currentYear.value--;
      } else {
        currentMonth.value--;
      }
    };
    
    const nextMonth = () => {
      if (currentMonth.value === 11) {
        currentMonth.value = 0;
        currentYear.value++;
      } else {
        currentMonth.value++;
      }
    };
    
    // Date selection
    const selectDate = (day) => {
      if (!isDateSelectable(day)) return;
      
      selectedDate.value = day;
      const formattedDate = formatDateForApi(new Date(currentYear.value, currentMonth.value, day));
      emit('update:modelValue', formattedDate);
      
      // Reset time slot if previously selected
      selectedTimeSlot.value = '';
      emit('update:timeSlotValue', '');
      
      // Removed the date-selected event emission to prevent calendar from closing after date selection
      // This ensures the calendar stays open for time slot selection
    };
    
    // Time slot selection
    const selectTimeSlot = (slot) => {
      selectedTimeSlot.value = slot;
      emit('update:timeSlotValue', slot);
      
      // Keep this event emission so the calendar closes after time slot selection
      emit('time-slot-selected');
    };
    
    // Initialize from props
    onMounted(() => {
      if (props.modelValue) {
        const date = new Date(props.modelValue);
        if (!isNaN(date.getTime())) {
          currentMonth.value = date.getMonth();
          currentYear.value = date.getFullYear();
          selectedDate.value = date.getDate();
        }
      }
      
      if (props.timeSlotValue) {
        selectedTimeSlot.value = props.timeSlotValue;
      }
    });
    
    // Watch for changes in props
    watch(() => props.modelValue, (newValue) => {
      if (newValue) {
        const date = new Date(newValue);
        if (!isNaN(date.getTime())) {
          currentMonth.value = date.getMonth();
          currentYear.value = date.getFullYear();
          selectedDate.value = date.getDate();
        }
      } else {
        selectedDate.value = null;
      }
    });
    
    watch(() => props.timeSlotValue, (newValue) => {
      selectedTimeSlot.value = newValue;
    });
    
    // Watch for test sessions changes
    watch(() => props.testSessions, (newSessions) => {
      console.log('🔄 CustomCalendar: Test sessions updated:', newSessions);
      console.log('📊 CustomCalendar: Test sessions count:', newSessions?.length || 0);
    }, { immediate: true });
    
    return {
      currentMonth,
      currentYear,
      daysOfWeek,
      daysInMonth,
      firstDayOfMonth,
      emptyCellsAtEnd,
      monthYearText,
      selectedDate,
      selectedDateFormatted,
      selectedTimeSlot,
      isDateSelectable,
      isDateToday,
      isDateSelected,
      isExamDate,
      isRegistrationDate,
      getTestSessionForDate,
      getRegistrationSessionsForDate,
      getExamTypeColors,
      getExamDateClasses,
      getRegistrationDateClasses,
      hasDateAvailability,
      getDateCapacity,
      getCapacityColor,
      getDateCapacityText,
      isMorningAvailable,
      isAfternoonAvailable,
      prevMonth,
      nextMonth,
      selectDate,
      selectTimeSlot
    };
  }
};
</script>

<style scoped>
.custom-calendar {
  font-family: system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
  max-width: 100%;
  margin: 0 auto;
}

/* Enhanced animations and effects */
@keyframes pulse-glow {
  0%, 100% {
    transform: scale(1);
    opacity: 1;
  }
  50% {
    transform: scale(1.1);
    opacity: 0.8;
  }
}

.animate-pulse {
  animation: pulse-glow 2s infinite;
}

/* Text shadow for better readability */
.text-shadow-sm {
  text-shadow: 0 1px 2px rgba(0, 0, 0, 0.1);
}

/* Hover scale effects */
.hover\:scale-102:hover {
  transform: scale(1.02);
}

.scale-105 {
  transform: scale(1.05);
}

/* Enhanced tooltip styles */
.group:hover .opacity-0 {
  opacity: 1;
  transition: opacity 0.3s ease-in-out;
}

/* Improve mobile tooltip behavior */
@media (max-width: 640px) {
  .group:hover .group-hover\:opacity-100 {
    opacity: 1;
    display: block;
  }
  
  /* Adjust position for smaller screens */
  .group .absolute {
    left: 50%;
    transform: translateX(-50%);
    min-width: 100px;
    text-align: center;
  }
  
  /* Reduce animation intensity on mobile */
  .animate-pulse {
    animation: pulse-glow 3s infinite;
  }
}

/* Custom border colors for different exam types */
.border-red-500 { border-color: #ef4444; }
.border-blue-500 { border-color: #3b82f6; }
.border-purple-500 { border-color: #8b5cf6; }
.border-yellow-500 { border-color: #eab308; }
.border-indigo-500 { border-color: #6366f1; }
.border-green-400 { border-color: #4ade80; }

/* Enhanced shadow effects */
.shadow-lg {
  box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
}

.shadow-xl {
  box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
}
</style> 