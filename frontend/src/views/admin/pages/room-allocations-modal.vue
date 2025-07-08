<template>
  <div v-if="show" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-40">
    <div class="bg-white rounded-lg max-w-4xl w-full p-6">
      <div class="flex justify-between items-center mb-4">
        <h3 class="text-lg font-semibold text-gray-900">
          Room Allocations for {{ session ? session.exam_type : '' }} Session
          <span class="ml-2 text-sm font-normal text-gray-500">
            {{ session ? formatDate(session.exam_date) : '' }}
          </span>
        </h3>
        <button 
          @click="$emit('close')" 
          class="text-gray-500 hover:text-gray-700 focus:outline-none"
        >
          <i class="fas fa-times"></i>
        </button>
      </div>

      <!-- Loading State -->
      <div v-if="loading" class="py-8 text-center">
        <div class="inline-block animate-spin rounded-full h-8 w-8 border-4 border-crimson-600 border-t-transparent"></div>
        <p class="mt-2 text-gray-600">Loading room allocations...</p>
      </div>

      <!-- Error State -->
      <div v-else-if="error" class="bg-red-50 p-4 rounded-md text-center">
        <i class="fas fa-exclamation-circle text-red-500 text-xl mb-2"></i>
        <p class="text-red-700">{{ error }}</p>
        <button 
          @click="$emit('retry', session)" 
          class="mt-3 px-4 py-2 bg-crimson-600 text-white rounded-lg hover:bg-crimson-700 transition"
        >
          Try Again
        </button>
      </div>      <!-- Empty State -->
      <div v-else-if="filteredRooms.length === 0" class="py-8 text-center bg-gray-50 rounded-lg">
        <i class="fas fa-info-circle text-gray-400 text-3xl mb-2"></i>
        <p class="text-gray-600">No room allocations found for this session.</p>
        <p class="mt-1 text-sm text-gray-500">
          You can use the Auto-Assign feature to allocate students to rooms.
        </p>
      </div>

      <!-- Allocations Table -->
      <div v-else>
        <div class="overflow-x-auto rounded-lg border border-gray-200">
          <table class="min-w-full divide-y divide-gray-200">
            <thead class="bg-gray-50">
              <tr>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Test Center</th>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Room</th>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Time Slot</th>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Capacity</th>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Assigned</th>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Available</th>
              </tr>
            </thead>
            <tbody class="bg-white divide-y divide-gray-200">
              <tr v-for="(room, index) in filteredRooms" :key="index" class="hover:bg-gray-50">
                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">{{ room.center_name || room.test_center_name }}</td>
                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">{{ room.room_name || room.name }}</td>
                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                  {{ room.time_slot === 'morning' ? 'Morning (8:00 AM - 12:00 PM)' : 'Afternoon (1:00 PM - 5:00 PM)' }}
                </td>
                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">{{ room.capacity }}</td>
                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">{{ room.assigned_count || room.assigned || 0 }}</td>
                <td class="px-6 py-4 whitespace-nowrap">
                  <div v-if="(room.capacity - (room.assigned_count || room.assigned || 0)) > 0" 
                       class="text-sm text-green-600 font-medium">
                    {{ room.capacity - (room.assigned_count || room.assigned || 0) }}
                  </div>
                  <div v-else class="text-sm text-red-600 font-medium">Full</div>
                </td>
              </tr>
            </tbody>
          </table>
        </div>

        <!-- Action Buttons -->
        <div class="mt-6 flex justify-end space-x-3">
          <button 
            @click="$emit('close')" 
            class="px-4 py-2 border border-gray-300 rounded-md text-gray-700 bg-white hover:bg-gray-50"
          >
            Close
          </button>
          <button 
            @click="exportData" 
            class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition flex items-center"
          >
            <i class="fas fa-download mr-2"></i> Export
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'RoomAllocationsModal',
  props: {
    show: {
      type: Boolean,
      default: false
    },
    session: {
      type: Object,
      default: null
    },
    rooms: {
      type: Array,
      default: () => []
    },
    loading: {
      type: Boolean,
      default: false
    },
    error: {
      type: String,
      default: null
    }
  },
  computed: {
    // Ensure we filter rooms by time slot if needed
    filteredRooms() {
      if (!this.rooms || !Array.isArray(this.rooms)) {
        return [];
      }
      
      return this.rooms.filter(room => room.is_active !== false);
    }
  },
  methods: {
    formatDate(dateString) {
      if (!dateString) return '';
      const date = new Date(dateString);
      return date.toLocaleDateString('en-US', {
        day: 'numeric',
        month: 'short',
        year: 'numeric'
      });
    },    exportData() {
      if (!this.session || !this.filteredRooms || this.filteredRooms.length === 0) {
        this.$emit('error', 'No data available to export');
        return;
      }
      
      try {
        // Prepare CSV content
        let csvContent = 'Test Center,Room,Time Slot,Capacity,Assigned,Available\n';
        
        // Add data rows
        this.filteredRooms.forEach(room => {
          const available = room.capacity - (room.assigned_count || room.assigned || 0);
          const timeSlot = room.time_slot === 'morning' ? 'Morning (8:00 AM - 12:00 PM)' : 'Afternoon (1:00 PM - 5:00 PM)';
          
          csvContent += `"${room.center_name || room.test_center_name}","${room.room_name || room.name}","${timeSlot}",${room.capacity},${room.assigned_count || room.assigned || 0},${available}\n`;
        });
        
        // Create blob and download
        const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' });
        const link = document.createElement('a');
        
        // Set file name with session details
        let fileName = 'room-allocations.csv';
        if (this.session) {
          const examType = this.session.exam_type || 'exam';
          const examDate = this.session.exam_date || new Date().toISOString().split('T')[0];
          fileName = `room-allocations-${examType.replace(/\s+/g, '-')}-${examDate}.csv`;
        }
        
        // Create download link and trigger it
        if (navigator.msSaveBlob) {
          // For IE
          navigator.msSaveBlob(blob, fileName);
        } else {
          const url = URL.createObjectURL(blob);
          link.href = url;
          link.setAttribute('download', fileName);
          document.body.appendChild(link);
          link.click();
          document.body.removeChild(link);
        }
        
        this.$emit('success', 'Export successful');
      } catch (error) {
        console.error('Error exporting room allocations:', error);
        this.$emit('error', 'Failed to export data');
      }
    }
  }
};
</script>
