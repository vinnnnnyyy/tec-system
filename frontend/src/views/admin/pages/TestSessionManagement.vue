<template>
  <div class="min-h-screen bg-gray-50 py-8">
    <div class="container mx-auto px-4">
      <!-- Header -->
      <div class="mb-8">
        <h1 class="text-3xl font-bold text-gray-900 mb-2">Test Session Management</h1>
        <p class="text-gray-600">Configure test sessions, centers, and manage room allocations</p>
      </div>

      <!-- Top Cards with Quick Stats -->
      <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
        <div class="bg-white rounded-lg shadow-md hover:shadow-lg transition-shadow p-6 border border-gray-100">
          <h2 class="text-lg font-semibold text-gray-900 mb-2">Upcoming Sessions</h2>
          <div class="text-3xl font-bold text-crimson-600 mb-2">{{ stats.upcomingSessions }}</div>
          <p class="text-sm text-gray-500">Scheduled test sessions</p>
        </div>
        
        <div class="bg-white rounded-lg shadow-md hover:shadow-lg transition-shadow p-6 border border-gray-100">
          <h2 class="text-lg font-semibold text-gray-900 mb-2">Available Centers</h2>
          <div class="text-3xl font-bold text-crimson-600 mb-2">{{ stats.availableCenters }}</div>
          <p class="text-sm text-gray-500">Test centers ready for use</p>
        </div>
        
        <div class="bg-white rounded-lg shadow-md hover:shadow-lg transition-shadow p-6 border border-gray-100">
          <h2 class="text-lg font-semibold text-gray-900 mb-2">Pending Assignments</h2>
          <div class="text-3xl font-bold text-crimson-600 mb-2">{{ stats.pendingAssignments }}</div>
          <p class="text-sm text-gray-500">Applications waiting for assignment</p>
          <button 
            @click="showAutoAssignConfirmation"
            class="mt-3 w-full px-4 py-2 bg-crimson-600 text-white rounded-lg hover:bg-crimson-700 transition"
            :disabled="stats.pendingAssignments === 0"
          >
            <i class="fas fa-magic mr-2"></i> Auto-Assign
          </button>
        </div>
      </div>

      <!-- Tabs for Sessions/Centers/Rooms -->
      <div class="bg-white rounded-lg shadow-md border border-gray-100 overflow-hidden mb-8">
        <div class="flex border-b border-gray-200">
          <button 
            @click="activeTab = 'sessions'"
            :class="[
              'px-6 py-4 text-sm font-medium transition-colors duration-200',
              activeTab === 'sessions' 
                ? 'text-crimson-600 border-b-2 border-crimson-600 bg-crimson-50' 
                : 'text-gray-500 hover:text-gray-700 hover:bg-gray-50'
            ]"
          >
            <i class="fas fa-calendar-alt mr-2"></i> Test Sessions
          </button>
          <button 
            @click="activeTab = 'centers'"
            :class="[
              'px-6 py-4 text-sm font-medium transition-colors duration-200',
              activeTab === 'centers' 
                ? 'text-crimson-600 border-b-2 border-crimson-600 bg-crimson-50' 
                : 'text-gray-500 hover:text-gray-700 hover:bg-gray-50'
            ]"
          >
            <i class="fas fa-building mr-2"></i> Test Centers
          </button>
          <button 
            @click="activeTab = 'rooms'"
            :class="[
              'px-6 py-4 text-sm font-medium transition-colors duration-200',
              activeTab === 'rooms' 
                ? 'text-crimson-600 border-b-2 border-crimson-600 bg-crimson-50' 
                : 'text-gray-500 hover:text-gray-700 hover:bg-gray-50'
            ]"
          >
            <i class="fas fa-door-open mr-2"></i> Test Rooms
          </button>
        </div>
        
        <!-- Tab Content -->
        <div class="p-6">
          <!-- Test Sessions Tab -->
          <div v-if="activeTab === 'sessions'" class="animate-fadeIn">
            <div class="flex justify-between mb-6">
              <h2 class="text-lg font-semibold text-gray-900">Test Sessions</h2>
              <div class="flex space-x-3">
                <button 
                  @click="updateSessionStatus"
                  class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition flex items-center"
                  :disabled="loading.updateStatus"
                >
                  <i class="fas fa-sync mr-2" :class="{ 'animate-spin': loading.updateStatus }"></i> 
                  Update Status
                </button>
                <button 
                  @click="showCreateSessionModal = true"
                  class="px-4 py-2 bg-crimson-600 text-white rounded-lg hover:bg-crimson-700 transition flex items-center"
                >
                  <i class="fas fa-plus mr-2"></i> New Session
                </button>
              </div>
            </div>
            
            <!-- Sessions Table -->
            <div class="bg-white rounded-lg border border-gray-200 overflow-hidden">
              <div class="overflow-x-auto">
                <table class="min-w-full divide-y divide-gray-200">
                  <thead class="bg-gray-50">
                    <tr>
                      <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Exam Type</th>
                      <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Registration Period</th>
                      <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Exam Date</th>
                      <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Status</th>
                      <th class="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">Actions</th>
                    </tr>
                  </thead>
                  <tbody class="bg-white divide-y divide-gray-200">
                    <tr v-if="loading.sessions">
                      <td colspan="5" class="px-6 py-4 text-center">
                        <div class="flex justify-center">
                          <div class="animate-spin rounded-full h-6 w-6 border-b-2 border-crimson-600"></div>
                        </div>
                      </td>
                    </tr>
                    <tr v-else-if="testSessions.length === 0">
                      <td colspan="5" class="px-6 py-4 text-center text-gray-500">
                        <div class="py-6">
                          <i class="fas fa-calendar-times text-gray-300 text-4xl mb-2"></i>
                          <p>No test sessions found. Create your first session.</p>
                        </div>
                      </td>
                    </tr>
                    <tr v-for="session in paginatedSessions" :key="session.id" class="hover:bg-gray-50">
                      <td class="px-6 py-4 whitespace-nowrap">
                        <div class="text-sm font-medium text-gray-900">{{ session.exam_type }}</div>
                      </td>
                      <td class="px-6 py-4 whitespace-nowrap">
                        <div class="text-sm text-gray-500">
                          {{ formatDate(session.registration_start_date) }} to {{ formatDate(session.registration_end_date) }}
                        </div>
                      </td>
                      <td class="px-6 py-4 whitespace-nowrap">
                        <div class="text-sm text-gray-500">{{ formatDate(session.exam_date) }}</div>
                      </td>
                      <td class="px-6 py-4 whitespace-nowrap">
                        <span 
                          class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full"
                          :class="{
                            'bg-yellow-100 text-yellow-800': session.status === 'SCHEDULED',
                            'bg-green-100 text-green-800': session.status === 'ONGOING',
                            'bg-blue-100 text-blue-800': session.status === 'COMPLETED',
                            'bg-red-100 text-red-800': session.status === 'CANCELLED'
                          }"
                        >
                          {{ session.status }}
                        </span>
                      </td>
                      <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                        <button 
                          @click="editSession(session)"
                          class="text-indigo-600 hover:text-indigo-900 mr-3"
                          title="Edit Session"
                        >
                          <i class="fas fa-edit"></i>
                        </button>
                        <button 
                          @click="checkRoomAllocations(session)"
                          class="text-blue-600 hover:text-blue-900 mr-3"
                          title="View Room Allocations"
                        >
                          <i class="fas fa-door-open"></i>
                        </button>
                        <button 
                          v-if="session.status === 'COMPLETED'"
                          @click="resetRoomAvailability(session)"
                          class="text-green-600 hover:text-green-900 mr-3"
                          title="Reset Room Availability"
                        >
                          <i class="fas fa-recycle"></i>
                        </button>
                        <button 
                          @click="showDeleteConfirmation(session)"
                          class="text-red-600 hover:text-red-900"
                          title="Delete Session"
                        >
                          <i class="fas fa-trash"></i>
                        </button>
                      </td>
                    </tr>
                  </tbody>
                </table>
              </div>
              
              <!-- Sessions Summary & Pagination -->
              <div v-if="testSessions.length > 0" class="bg-gray-50 px-4 py-3 border-t border-gray-200 sm:px-6">
                <div class="text-sm text-gray-500 mb-2">
                  Showing {{ (pagination.sessions.currentPage - 1) * pagination.sessions.itemsPerPage + 1 }} 
                  to {{ Math.min(pagination.sessions.currentPage * pagination.sessions.itemsPerPage, pagination.sessions.totalItems) }} 
                  of {{ pagination.sessions.totalItems }} sessions
                </div>
                <!-- Sessions Pagination -->
                <AdminPagination
                  :model-value="pagination.sessions.currentPage"
                  :items-per-page="pagination.sessions.itemsPerPage"
                  :total-items="pagination.sessions.totalItems"
                  @update:model-value="changeSessionsPage"
                />
              </div>
            </div>
          </div>
          
          <!-- Test Centers Tab -->
          <div v-if="activeTab === 'centers'" class="animate-fadeIn">
            <div class="flex justify-between mb-6">
              <h2 class="text-lg font-semibold text-gray-900">Test Centers</h2>
              <button 
                @click="showCreateCenterModal = true"
                class="px-4 py-2 bg-crimson-600 text-white rounded-lg hover:bg-crimson-700 transition flex items-center"
              >
                <i class="fas fa-plus mr-2"></i> New Center
              </button>
            </div>
            
            <!-- Centers Table -->
            <div class="bg-white rounded-lg border border-gray-200 overflow-hidden">
              <div class="overflow-x-auto">
                <table class="min-w-full divide-y divide-gray-200">
                  <thead class="bg-gray-50">
                    <tr>
                      <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Center Name</th>
                      <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Code</th>
                      <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Address</th>
                      <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Rooms</th>
                      <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Status</th>
                      <th class="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">Actions</th>
                    </tr>
                  </thead>
                  <tbody class="bg-white divide-y divide-gray-200">
                    <tr v-if="loading.centers">
                      <td colspan="6" class="px-6 py-4 text-center">
                        <div class="flex justify-center">
                          <div class="animate-spin rounded-full h-6 w-6 border-b-2 border-crimson-600"></div>
                        </div>
                      </td>
                    </tr>
                    <tr v-else-if="testCenters.length === 0">
                      <td colspan="6" class="px-6 py-4 text-center text-gray-500">
                        <div class="py-6">
                          <i class="fas fa-building text-gray-300 text-4xl mb-2"></i>
                          <p>No test centers found. Create your first center.</p>
                        </div>
                      </td>
                    </tr>
                    <tr v-for="center in paginatedCenters" :key="center.id" class="hover:bg-gray-50">
                      <td class="px-6 py-4 whitespace-nowrap">
                        <div class="text-sm font-medium text-gray-900">{{ center.name }}</div>
                      </td>
                      <td class="px-6 py-4 whitespace-nowrap">
                        <div class="text-sm text-gray-500">{{ center.code }}</div>
                      </td>
                      <td class="px-6 py-4">
                        <div class="text-sm text-gray-500">{{ center.address || 'No address specified' }}</div>
                      </td>
                      <td class="px-6 py-4 whitespace-nowrap">
                        <div class="text-sm text-gray-500">
                          <i class="fas fa-door-open mr-1"></i> {{ center.roomCount || 0 }} Rooms
                        </div>
                      </td>
                      <td class="px-6 py-4 whitespace-nowrap">
                        <span 
                          class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full"
                          :class="{
                            'bg-green-100 text-green-800': center.is_active,
                            'bg-red-100 text-red-800': !center.is_active
                          }"
                        >
                          {{ center.is_active ? 'Active' : 'Inactive' }}
                        </span>
                      </td>
                      <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                        <button 
                          @click="viewCenterRooms(center)"
                          class="text-blue-600 hover:text-blue-900 mr-3"
                          title="View Rooms"
                        >
                          <i class="fas fa-door-open"></i>
                        </button>
                        <button 
                          @click="editCenter(center)"
                          class="text-indigo-600 hover:text-indigo-900"
                          title="Edit Center"
                        >
                          <i class="fas fa-edit"></i>
                        </button>
                        <button 
                          @click="showDeleteCenterConfirmation(center)"
                          class="text-red-600 hover:text-red-900"
                          title="Delete Center"
                        >
                          <i class="fas fa-trash"></i>
                        </button>
                      </td>
                    </tr>
                  </tbody>
                </table>
                <!-- Centers Pagination -->
                <AdminPagination
                  v-if="testCenters.length > 0"
                  :model-value="pagination.centers.currentPage"
                  :items-per-page="pagination.centers.itemsPerPage"
                  :total-items="pagination.centers.totalItems"
                  @update:model-value="changeCentersPage"
                />
              </div>
            </div>
          </div>
          
          <!-- Test Rooms Tab -->
          <div v-if="activeTab === 'rooms'">
            <div class="flex justify-between mb-6">
              <h2 class="text-lg font-semibold text-gray-900">Test Rooms</h2>
              <button 
                @click="showCreateRoomModal = true"
                class="px-4 py-2 bg-crimson-600 text-white rounded-lg hover:bg-crimson-700 transition"
              >
                <i class="fas fa-plus mr-2"></i> New Room
              </button>
            </div>
            
            <!-- Filter Section -->
            <div class="bg-white rounded-lg border border-gray-200 p-4 mb-6">
              <h3 class="text-md font-medium text-gray-700 mb-3">Filter Rooms</h3>
              
              <div class="flex flex-wrap gap-4">
                <!-- Filter by Center -->
                <div class="w-full md:w-5/12">
                  <label class="block text-sm font-medium text-gray-700 mb-1">Test Center</label>
                  <select 
                    v-model="roomFilters.centerId" 
                    class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-crimson-500"
                  >
                    <option value="">All Test Centers</option>
                    <option v-for="center in testCenters" :key="center.id" :value="center.id">
                      {{ center.name }}
                    </option>
                  </select>
                </div>
                
                <!-- Filter by Time Slot -->
                <div class="w-full md:w-5/12">
                  <label class="block text-sm font-medium text-gray-700 mb-1">Time Slot</label>
                  <select 
                    v-model="roomFilters.timeSlot" 
                    class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-crimson-500"
                  >
                    <option value="">All Time Slots</option>
                    <option value="morning">Morning (8:00 AM - 12:00 PM)</option>
                    <option value="afternoon">Afternoon (1:00 PM - 5:00 PM)</option>
                  </select>
                </div>
                
                <!-- Clear Filters Button -->
                <div class="w-full md:w-1/12 flex items-end">
                  <button 
                    @click="clearRoomFilters" 
                    class="w-full px-3 py-2 bg-gray-200 text-gray-700 rounded-lg hover:bg-gray-300 transition"
                    :disabled="!roomFilters.centerId && !roomFilters.timeSlot"
                  >
                    <i class="fas fa-times mr-1"></i> Clear
                  </button>
                </div>
              </div>
              
              <!-- Filter Status -->
              <div v-if="roomFilters.centerId || roomFilters.timeSlot" class="mt-3 text-sm text-gray-500">
                <span>
                  Active filters: 
                  <span v-if="roomFilters.centerId" class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-blue-100 text-blue-800 mr-1">
                    Center: {{ getCenterName(roomFilters.centerId) }}
                  </span>
                  <span v-if="roomFilters.timeSlot" class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800 mr-1">
                    {{ roomFilters.timeSlot === 'morning' ? 'Morning' : 'Afternoon' }}
                  </span>
                </span>
                <span class="ml-2">
                  <strong>{{ filteredRooms.length }}</strong> rooms found
                </span>
              </div>
            </div>
            
            <!-- Rooms Table -->
            <div class="overflow-x-auto">
              <table class="min-w-full divide-y divide-gray-200">
                <thead class="bg-gray-50">
                  <tr>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Room Name</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Test Center</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Room Code</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Time Slot</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Capacity</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Available</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Status</th>
                    <th class="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">Actions</th>
                  </tr>
                </thead>
                <tbody class="bg-white divide-y divide-gray-200">
                  <tr v-if="loading.rooms">
                    <td colspan="8" class="px-6 py-4 text-center">
                      <div class="flex justify-center">
                        <div class="animate-spin rounded-full h-6 w-6 border-b-2 border-crimson-600"></div>
                      </div>
                    </td>
                  </tr>
                  <tr v-else-if="filteredRooms.length === 0">
                    <td colspan="8" class="px-6 py-4 text-center text-gray-500">
                      No rooms found. Create a new room or change your filter.
                    </td>
                  </tr>
                  <tr v-for="room in paginatedRooms" :key="room.id" class="hover:bg-gray-50">
                    <td class="px-6 py-4 whitespace-nowrap">
                      <div class="text-sm font-medium text-gray-900">{{ room.name }}</div>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap">
                      <div class="text-sm text-gray-500">{{ room.center_name }}</div>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap">
                      <div class="text-sm text-gray-500">{{ room.room_code }}</div>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap">
                      <div class="text-sm text-gray-500">{{ room.time_slot === 'morning' ? 'Morning (8:00 AM - 12:00 PM)' : 'Afternoon (1:00 PM - 5:00 PM)' }}</div>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap">
                      <div class="text-sm text-gray-500">{{ room.capacity }}</div>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap">
                      <div class="text-sm" :class="{'text-green-600': room.available_capacity > 0, 'text-red-600': room.available_capacity <= 0}">
                        {{ room.available_capacity }} 
                        <span class="text-xs text-gray-500">({{ room.assigned_count }} assigned)</span>
                      </div>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap">
                      <span 
                        class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full"
                        :class="{
                          'bg-green-100 text-green-800': room.is_active,
                          'bg-red-100 text-red-800': !room.is_active
                        }"
                      >
                        {{ room.is_active ? 'Active' : 'Inactive' }}
                      </span>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                      <button 
                        @click="editRoom(room)"
                        class="text-indigo-600 hover:text-indigo-900 mr-3"
                      >
                        <i class="fas fa-edit"></i>
                      </button>
                      <button 
                        @click="showDeleteRoomConfirmation(room)"
                        class="text-red-600 hover:text-red-900"
                      >
                        <i class="fas fa-trash"></i>
                      </button>
                    </td>
                  </tr>
                </tbody>
              </table>
              <!-- Rooms Pagination -->
              <AdminPagination
                v-if="filteredRooms.length > 0"
                :model-value="pagination.rooms.currentPage"
                :items-per-page="pagination.rooms.itemsPerPage"
                :total-items="pagination.rooms.totalItems"
                @update:model-value="changeRoomsPage"
              />
            </div>
          </div>
        </div>
      </div>

      <!-- Auto-Assign Confirmation Modal -->
      <div v-if="showAutoAssignConfirmModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
        <div class="bg-white rounded-xl shadow-lg w-full max-w-md p-6">
          <div class="text-center">
            <i class="fas fa-magic text-4xl text-purple-500 mb-4"></i>
            <h3 class="text-lg font-semibold mb-2">Auto-Assign Students</h3>
            <p class="text-gray-600 mb-6">
              Are you sure you want to proceed with auto-assigning {{ stats.pendingAssignments }} student(s) to test rooms?
              <span class="block mt-2 text-sm text-gray-500">
                This will assign rooms to all eligible students who are waiting for placement.
              </span>
            </p>
            
            <div class="flex justify-center space-x-3">
              <button 
                @click="showAutoAssignConfirmModal = false" 
                class="px-4 py-2 text-sm font-medium text-gray-700 bg-gray-100 rounded-lg hover:bg-gray-200"
              >
                Cancel
              </button>
              <button 
                @click="openAutoAssignSettings" 
                class="px-4 py-2 text-sm font-medium text-white bg-purple-600 rounded-lg hover:bg-purple-700 flex items-center justify-center"
              >
                <i class="fas fa-cog mr-2"></i>
                Configure Settings
              </button>
            </div>
          </div>
        </div>
      </div>

      <!-- Auto-Assign Modal -->
      <div v-if="showAutoAssignModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-40">
        <div class="bg-white rounded-lg max-w-xl w-full p-6">
          <h3 class="text-lg font-semibold text-gray-900 mb-4">
            Auto-Assign Test Details
          </h3>
          <p class="text-gray-600 mb-6">
            The system will automatically assign test details to all verified applications that don't already have test details assigned.
          </p>
          
          <div class="space-y-6">
            <!-- Test Session Selection -->
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">Select Test Session</label>
              <select 
                v-model="autoAssign.testSessionId" 
                class="w-full border border-gray-300 rounded-md px-3 py-2 focus:ring-crimson-500 focus:border-crimson-500"
                @change="console.log('Selected test session ID:', autoAssign.testSessionId)"
              >
                <option value="">Select a test session</option>
                <option 
                  v-for="session in testSessions.filter(s => s.status !== 'COMPLETED' && s.status !== 'CANCELLED' && s.status !== 'SCHEDULED')" 
                  :key="session.id" 
                  :value="session.id"
                >
                  {{ session.exam_type }} - {{ formatDate(session.exam_date) }} ({{ session.status }})
                </option>
              </select>
            </div>
            
            <!-- Additional Options -->
            <div>
              <h4 class="text-sm font-medium text-gray-700 mb-2">Assignment Options</h4>
              
              <div class="space-y-3">
                <div class="flex items-center">
                  <input 
                    type="checkbox" 
                    id="balanceRooms" 
                    v-model="autoAssign.balanceRooms"
                    class="h-4 w-4 text-crimson-600 focus:ring-crimson-500 border-gray-300 rounded"
                  >
                  <label for="balanceRooms" class="ml-2 block text-sm text-gray-700">
                    Balance students across available rooms
                  </label>
                </div>
              </div>
            </div>
            
            <!-- Time Slot Options -->
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">Time Slot Assignment</label>
              <div class="flex flex-col space-y-2">
                <label class="inline-flex items-center">
                  <input 
                    type="radio" 
                    v-model="autoAssign.timeSlot" 
                    value="morning"
                    class="h-4 w-4 text-crimson-600 focus:ring-crimson-500 border-gray-300"
                  >
                  <span class="ml-2 text-sm text-gray-700">Morning sessions only (8:00 AM - 12:00 PM)</span>
                </label>
                <label class="inline-flex items-center">
                  <input 
                    type="radio" 
                    v-model="autoAssign.timeSlot" 
                    value="afternoon"
                    class="h-4 w-4 text-crimson-600 focus:ring-crimson-500 border-gray-300"
                  >
                  <span class="ml-2 text-sm text-gray-700">Afternoon sessions only (1:00 PM - 5:00 PM)</span>
                </label>
                <label class="inline-flex items-center">
                  <input 
                    type="radio" 
                    v-model="autoAssign.timeSlot" 
                    value="both"
                    class="h-4 w-4 text-crimson-600 focus:ring-crimson-500 border-gray-300"
                  >
                  <span class="ml-2 text-sm text-gray-700">Use both morning and afternoon sessions</span>
                </label>
                <div class="mt-2 text-xs text-gray-500 bg-yellow-50 p-2 rounded-md border border-yellow-100" v-if="autoAssign.timeSlot === 'both'">
                  <i class="fas fa-info-circle mr-1"></i> Students will be allocated between morning and afternoon rooms, balancing capacity across all available rooms.
                </div>
              </div>
            </div>
          </div>
          
          <div class="mt-6 flex justify-end space-x-3">
            <button 
              @click="showAutoAssignModal = false" 
              class="px-4 py-2 border border-gray-300 rounded-md text-gray-700 bg-white hover:bg-gray-50"
            >
              Cancel
            </button>
            <button 
              @click="runAutoAssign" 
              class="px-4 py-2 border border-transparent rounded-md shadow-sm text-white bg-crimson-600 hover:bg-crimson-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-crimson-500"
              :disabled="!autoAssign.testSessionId || loading.autoAssign"
            >
              <i v-if="loading.autoAssign" class="fas fa-spinner fa-spin mr-2"></i>
              <i v-else class="fas fa-magic mr-2"></i>
              Run Auto-Assignment
            </button>
          </div>
        </div>
      </div>

      <!-- Create Test Session Modal -->
      <div v-if="showCreateSessionModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-40">
        <div class="bg-white rounded-lg max-w-xl w-full p-6">
          <h3 class="text-lg font-semibold text-gray-900 mb-4">
            Create New Test Session
          </h3>
          
          <div class="space-y-4">
            <!-- Exam Type -->
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Exam Type</label>
              <select 
                v-model="newSession.exam_type" 
                class="w-full border border-gray-300 rounded-md px-3 py-2 focus:ring-crimson-500 focus:border-crimson-500"
              >
                <option value="">Select a program</option>
                <option v-for="program in programs" :key="program.id" :value="program.code">
                  {{ program.code }} - {{ program.name }}
                </option>
              </select>
            </div>
            
            <!-- Registration Period -->
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Registration Start Date</label>
                <input 
                  type="date" 
                  v-model="newSession.registration_start_date" 
                  class="w-full border border-gray-300 rounded-md px-3 py-2 focus:ring-crimson-500 focus:border-crimson-500"
                >
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Registration End Date</label>
                <input 
                  type="date" 
                  v-model="newSession.registration_end_date" 
                  class="w-full border border-gray-300 rounded-md px-3 py-2 focus:ring-crimson-500 focus:border-crimson-500"
                >
              </div>
            </div>
            
            <!-- Exam Date -->
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Exam Date</label>
              <input 
                type="date" 
                v-model="newSession.exam_date" 
                class="w-full border border-gray-300 rounded-md px-3 py-2 focus:ring-crimson-500 focus:border-crimson-500"
              >
            </div>
            
            <!-- Status -->
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Status</label>
              <select 
                v-model="newSession.status" 
                class="w-full border border-gray-300 rounded-md px-3 py-2 focus:ring-crimson-500 focus:border-crimson-500"
              >
                <option value="SCHEDULED">Scheduled</option>
                <option value="ONGOING">Ongoing</option>
                <option value="COMPLETED">Completed</option>
                <option value="CANCELLED">Cancelled</option>
              </select>
            </div>
          </div>
          
          <div class="mt-6 flex justify-end space-x-3">
            <button 
              @click="cancelSessionModal" 
              class="px-4 py-2 border border-gray-300 rounded-md text-gray-700 bg-white hover:bg-gray-50"
            >
              Cancel
            </button>
            <button 
              @click="createSession" 
              id="createSessionBtn"
              class="px-4 py-2 border border-transparent rounded-md shadow-sm text-white bg-crimson-600 hover:bg-crimson-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-crimson-500"
              :disabled="!isValidSession || loading.createSession"
            >
              <i v-if="loading.createSession" class="fas fa-spinner fa-spin mr-2"></i>
              <i v-else class="fas fa-plus mr-2"></i>
              Create Session
            </button>
          </div>
        </div>
      </div>

      <!-- Create Center Modal -->
      <div v-if="showCreateCenterModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-40">
        <div class="bg-white rounded-lg max-w-md w-full p-6">
          <h3 class="text-lg font-semibold text-gray-900 mb-4">
            Create New Test Center
          </h3>
          
          <div class="space-y-4">
            <!-- Center Name -->
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Center Name</label>
              <input 
                type="text" 
                v-model="newCenter.name" 
                class="w-full border border-gray-300 rounded-md px-3 py-2 focus:ring-crimson-500 focus:border-crimson-500"
                placeholder="Enter center name"
              >
            </div>
            
            <!-- Center Code -->
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Center Code</label>
              <input 
                type="text" 
                v-model="newCenter.code" 
                class="w-full border border-gray-300 rounded-md px-3 py-2 focus:ring-crimson-500 focus:border-crimson-500"
                placeholder="Enter unique code"
              >
            </div>
            
            <!-- Center Address -->
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Address</label>
              <textarea 
                v-model="newCenter.address" 
                rows="2"
                class="w-full border border-gray-300 rounded-md px-3 py-2 focus:ring-crimson-500 focus:border-crimson-500"
                placeholder="Enter address"
              ></textarea>
            </div>
            
            <!-- Active Status -->
            <div class="flex items-center">
              <input 
                type="checkbox" 
                id="centerActive" 
                v-model="newCenter.is_active"
                class="h-4 w-4 text-crimson-600 focus:ring-crimson-500 border-gray-300 rounded"
              >
              <label for="centerActive" class="ml-2 block text-sm text-gray-900">
                Active
              </label>
            </div>
          </div>
          
          <div class="mt-6 flex justify-end space-x-3">
            <button 
              @click="cancelCenterModal" 
              class="px-4 py-2 border border-gray-300 rounded-md text-gray-700 bg-white hover:bg-gray-50"
            >
              Cancel
            </button>
            <button 
              @click="createCenter" 
              id="createCenterBtn"
              class="px-4 py-2 border border-transparent rounded-md shadow-sm text-white bg-crimson-600 hover:bg-crimson-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-crimson-500"
              :disabled="!newCenter.name || !newCenter.code || loading.createCenter"
            >
              <i v-if="loading.createCenter" class="fas fa-spinner fa-spin mr-2"></i>
              <i v-else class="fas fa-plus mr-2"></i>
              Create Center
            </button>
          </div>
        </div>
      </div>
      
      <!-- Create Room Modal -->
      <div v-if="showCreateRoomModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-40">
        <div class="bg-white rounded-lg max-w-md w-full p-6">
          <h3 class="text-lg font-semibold text-gray-900 mb-4">
            Create New Test Room
          </h3>
          
          <div class="space-y-4">
            <!-- Test Center Selection -->
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Test Center</label>
              <select 
                v-model="newRoom.test_center" 
                class="w-full border border-gray-300 rounded-md px-3 py-2 focus:ring-crimson-500 focus:border-crimson-500"
              >
                <option value="">Select a test center</option>
                <option v-for="center in testCenters" :key="center.id" :value="center.id">
                  {{ center.name }}
                </option>
              </select>
            </div>
            
            <!-- Room Name -->
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Room Name</label>
              <input 
                type="text" 
                v-model="newRoom.name" 
                class="w-full border border-gray-300 rounded-md px-3 py-2 focus:ring-crimson-500 focus:border-crimson-500"
                placeholder="Enter room name"
              >
            </div>
            
            <!-- Room Code -->
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Room Code</label>
              <input 
                type="text" 
                v-model="newRoom.room_code" 
                class="w-full border border-gray-300 rounded-md px-3 py-2 focus:ring-crimson-500 focus:border-crimson-500"
                placeholder="Enter room code"
              >
            </div>
            
            <!-- Time Slot -->
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Time Slot</label>
              <select 
                v-model="newRoom.time_slot" 
                class="w-full border border-gray-300 rounded-md px-3 py-2 focus:ring-crimson-500 focus:border-crimson-500"
              >
                <option value="morning">Morning (8:00 AM - 12:00 PM)</option>
                <option value="afternoon">Afternoon (1:00 PM - 5:00 PM)</option>
              </select>
            </div>
            
            <!-- Capacity -->
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Capacity</label>
              <input 
                type="number" 
                v-model="newRoom.capacity" 
                class="w-full border border-gray-300 rounded-md px-3 py-2 focus:ring-crimson-500 focus:border-crimson-500"
                placeholder="Maximum number of students"
              >
            </div>
            
            <!-- Active Status -->
            <div class="flex items-center">
              <input 
                type="checkbox" 
                id="roomActive" 
                v-model="newRoom.is_active"
                class="h-4 w-4 text-crimson-600 focus:ring-crimson-500 border-gray-300 rounded"
              >
              <label for="roomActive" class="ml-2 block text-sm text-gray-900">
                Active
              </label>
            </div>
            
            <!-- Create Both Time Slots -->
            <div class="flex items-center">
              <input 
                type="checkbox" 
                id="createBothTimeSlots" 
                v-model="createBothSlots"
                class="h-4 w-4 text-crimson-600 focus:ring-crimson-500 border-gray-300 rounded"
              >
              <label for="createBothTimeSlots" class="ml-2 block text-sm text-gray-900">
                Create both morning and afternoon rooms
              </label>
            </div>
          </div>
          
          <div class="mt-6 flex justify-end space-x-3">
            <button 
              @click="cancelRoomModal" 
              class="px-4 py-2 border border-gray-300 rounded-md text-gray-700 bg-white hover:bg-gray-50"
            >
              Cancel
            </button>
            <button 
              @click="createRoom" 
              id="createRoomBtn"
              class="px-4 py-2 border border-transparent rounded-md shadow-sm text-white bg-crimson-600 hover:bg-crimson-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-crimson-500"
              :disabled="!newRoom.name || !newRoom.room_code || !newRoom.test_center || loading.createRoom"
            >
              <i v-if="loading.createRoom" class="fas fa-spinner fa-spin mr-2"></i>
              <i v-else class="fas fa-plus mr-2"></i>
              Create Room
            </button>
          </div>
        </div>
      </div>

      <!-- Confirmation Modal for Deletions -->
      <div v-if="showConfirmationModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
        <div class="bg-white rounded-xl shadow-lg w-full max-w-md p-6">
          <div class="text-center">
            <i class="fas fa-exclamation-triangle text-4xl text-yellow-500 mb-4"></i>
            <h3 class="text-lg font-semibold mb-2">{{ confirmationData.title }}</h3>
            <p class="text-gray-600 mb-6">
              {{ confirmationData.message }}
              <span v-if="confirmationData.item" class="block mt-2 font-medium">
                {{ getItemDisplayText(confirmationData.item) }}
              </span>
            </p>
            
            <div class="flex justify-center space-x-3">
              <button 
                @click="showConfirmationModal = false" 
                class="px-4 py-2 text-sm font-medium text-gray-700 bg-gray-100 rounded-lg hover:bg-gray-200"
              >
                Cancel
              </button>
              <button 
                @click="confirmAction" 
                class="px-4 py-2 text-sm font-medium text-white bg-red-600 rounded-lg hover:bg-red-700 flex items-center justify-center"
                :disabled="loading.confirmation"
              >                <i v-if="loading.confirmation" class="fas fa-spinner fa-spin mr-2"></i>
                <i v-else class="fas fa-trash mr-2"></i>
                {{ confirmationData.confirmButtonText }}
              </button>
            </div>
          </div>
        </div>
      </div>
      
      <!-- Room Allocations Modal -->
      <RoomAllocationsModal
        :show="showRoomAllocationsModal"
        :session="selectedSession"
        :rooms="roomAllocations.data"
        :loading="roomAllocations.loading"
        :error="roomAllocations.error"
        @close="showRoomAllocationsModal = false"
        @retry="checkRoomAllocations"
        @success="showToast($event, 'success')"
        @error="showToast($event, 'error')"
      />
    </div>
  </div>
</template>

<script>
// Make sure API_URL doesn't have a trailing slash
const API_URL = (import.meta.env.VITE_API_URL || 'http://localhost:8000').replace(/\/$/, '');
import AuthService from '../../../services/auth.service';
import axiosInstance from '../../../services/axios.interceptor';
import AdminPagination from '../components/AdminPagination.vue';
import RoomAllocationsModal from './room-allocations-modal.vue';
import { useToast } from '../../../composables/useToast';

export default {
  components: {
    AdminPagination,
    RoomAllocationsModal
  },
  setup() {
    const { showToast } = useToast();
    return { showToast };
  },
  data() {
    return {
      activeTab: 'sessions',
      testSessions: [],
      testCenters: [],
      testRooms: [],
      programs: [],
      loading: {
        sessions: false,
        centers: false,
        rooms: false,
        autoAssign: false,
        createSession: false,
        createCenter: false,
        createRoom: false,
        confirmation: false,
        updateStatus: false
      },
      stats: {
        upcomingSessions: 0,
        availableCenters: 0,
        pendingAssignments: 0
      },
      showAutoAssignModal: false,
      showCreateSessionModal: false,
      showCreateCenterModal: false,
      showCreateRoomModal: false,
      showRoomAllocationsModal: false, // New modal state
      createBothSlots: false,
      // Store the selected session for room allocations
      selectedSession: null,
      roomAllocations: {
        loading: false,
        data: [],
        error: null
      },
      autoAssign: {
        testSessionId: '',
        groupBySchool: true,
        balanceRooms: true,
        timeSlot: 'both',
        limit: 100,
        ignorePreferences: true
      },
      roomFilters: {
        centerId: '',
        timeSlot: ''
      },
      newSession: {
        exam_type: '',
        registration_start_date: '',
        registration_end_date: '',
        exam_date: '',
        capacity: 100,
        status: 'SCHEDULED'
      },
      newCenter: {
        name: '',
        code: '',
        address: '',
        is_active: true
      },
      newRoom: {
        test_center: '',
        name: '',
        room_code: '',
        capacity: 30,
        is_active: true,
        time_slot: 'morning'
      },
      // Pagination variables
      pagination: {
        sessions: {
          currentPage: 1,
          itemsPerPage: 10,
          totalItems: 0
        },
        centers: {
          currentPage: 1,
          itemsPerPage: 10,
          totalItems: 0
        },
        rooms: {
          currentPage: 1,
          itemsPerPage: 10,
          totalItems: 0
        }
      },
      editingSessionId: null,
      editingCenterId: null,
      editingRoomId: null,
      showConfirmationModal: false,
      confirmationData: {
        title: '',
        message: '',
        confirmButtonText: 'Delete',
        action: null,
        item: null
      },
      showApproveModal: false,
      showClaimModal: false,
      showAutoAssignConfirmModal: false,
      selectedAppointment: null
    };
  },
  computed: {
    filteredRooms() {
      return this.testRooms.filter(room => {
        // Filter by center if specified
        if (this.roomFilters.centerId && room.test_center.toString() !== this.roomFilters.centerId.toString()) {
          return false;
        }
        
        // Filter by time slot if specified
        if (this.roomFilters.timeSlot && room.time_slot !== this.roomFilters.timeSlot) {
          return false;
        }
        
        return true;
      });
    },
    isValidSession() {
      return this.newSession.exam_type && 
        this.newSession.registration_start_date && 
        this.newSession.registration_end_date && 
        this.newSession.exam_date;
    },
    // Pagination computed properties
    paginatedSessions() {
      const { currentPage, itemsPerPage } = this.pagination.sessions;
      const startIndex = (currentPage - 1) * itemsPerPage;
      const endIndex = startIndex + itemsPerPage;
      return this.testSessions.slice(startIndex, endIndex);
    },
    paginatedCenters() {
      const { currentPage, itemsPerPage } = this.pagination.centers;
      const startIndex = (currentPage - 1) * itemsPerPage;
      const endIndex = startIndex + itemsPerPage;
      return this.testCenters.slice(startIndex, endIndex);
    },
    paginatedRooms() {
      const { currentPage, itemsPerPage } = this.pagination.rooms;
      const startIndex = (currentPage - 1) * itemsPerPage;
      const endIndex = startIndex + itemsPerPage;
      return this.filteredRooms.slice(startIndex, endIndex);
    }
  },
  async created() {
    // Fetch all data when component is mounted
    await this.fetchPrograms();
    await this.fetchTestSessions();
    await this.fetchTestCenters();
    await this.fetchTestRooms();
    await this.fetchPendingAssignments();
  },
  methods: {
    // Fetch data methods
    async fetchPrograms() {
      try {
        const response = await axiosInstance.get('/api/programs/');
        this.programs = response.data;
      } catch (error) {
        console.error('Error fetching programs:', error);
      }
    },
    
    async fetchTestSessions() {
      this.loading.sessions = true;
      try {
        const response = await axiosInstance.get('/api/admin/test-sessions/');
        this.testSessions = response.data;
        
        // Debug: log test sessions data to help diagnose issues
        console.log('Fetched test sessions:', this.testSessions);
        
        // Update stats
        this.stats.upcomingSessions = response.data.filter(s => s.status === 'SCHEDULED').length;
        // Update pagination total
        this.pagination.sessions.totalItems = this.testSessions.length;
      } catch (error) {
        console.error('Error fetching test sessions:', error);
        // Show error notification
      } finally {
        this.loading.sessions = false;
      }
    },
    
    async updateSessionStatus() {
      this.loading.updateStatus = true;
      try {
        const response = await axiosInstance.post('/api/admin/test-sessions/update-status/');
        
        // Show success message
        this.showToast(response.data.message, 'success');
        
        // Refresh the test sessions list to reflect any status changes
        await this.fetchTestSessions();
        
      } catch (error) {
        console.error('Error updating session status:', error);
        this.showToast('Failed to update session status', 'error');
      } finally {
        this.loading.updateStatus = false;
      }
    },
    
    async fetchTestCenters() {
      this.loading.centers = true;
      try {
        const response = await axiosInstance.get('/api/admin/test-centers/');
        const data = response.data;
        
        // Fetch room counts for each center
        for (const center of data) {
          try {
            const roomsResponse = await axiosInstance.get(`/api/admin/test-centers/${center.id}/rooms/`);
            center.roomCount = roomsResponse.data.length;
          } catch (error) {
            console.error(`Error fetching rooms for center ${center.id}:`, error);
            center.roomCount = 0;
          }
        }
        
        this.testCenters = data;
        
        // Update stats
        this.stats.availableCenters = data.filter(c => c.is_active).length;
        // Update pagination total
        this.pagination.centers.totalItems = this.testCenters.length;
      } catch (error) {
        console.error('Error fetching test centers:', error);
        // Show error notification
      } finally {
        this.loading.centers = false;
      }
    },
    
    async fetchTestRooms() {
      try {
        this.loading.rooms = true;
        const response = await axiosInstance.get('/api/admin/test-rooms/');
        this.testRooms = response.data.map(room => ({
          ...room,
          assigned_count: 0,
          available_capacity: room.capacity,
          // Set default time_slot if not present in the API response
          time_slot: room.time_slot || 'morning'
        }));
        
        // We'll no longer call an API that doesn't exist
        // Instead, we'll load any existing assignments when they're needed
        this.fetchRoomAssignmentCounts();
        
        // Update pagination total using the method to ensure consistency
        this.updateRoomsPagination();
        
        this.loading.rooms = false;
      } catch (error) {
        console.error("Error fetching test rooms:", error);
        this.loading.rooms = false;
      }
    },
    
    // This method will be called directly by methods that need fresh assignment data
    // rather than being called on initial load
    async fetchRoomAssignmentCounts() {
      try {
        // Use the new endpoint that returns counts from the database
        const response = await axiosInstance.get('/api/admin/test-rooms/assignments/count/');
        
        if (response.data && Array.isArray(response.data)) {
          // The response data is already in the format we need
          // Just sync it with our local testRooms array
          console.log('Room assignment counts fetched from server:', response.data);
          
          this.testRooms = this.testRooms.map(room => {
            // Find the matching room in the response
            const roomData = response.data.find(r => r.room_id === room.id);
            
            if (roomData) {
              // Only log if there's a difference between local and server data
              if (room.assigned_count !== roomData.assigned_count || room.available_capacity !== roomData.available_capacity) {
                console.log(`Updating room ${room.id} from server: 
                  - capacity: ${room.capacity} (unchanged)
                  - assigned_count: ${room.assigned_count} -> ${roomData.assigned_count}
                  - available_capacity: ${room.available_capacity} -> ${roomData.available_capacity}`);
              }
              
              // Update with data from database
              return {
                ...room,
                assigned_count: roomData.assigned_count,
                available_capacity: roomData.available_capacity
              };
            }
            return room;
          });
        }
      } catch (error) {
        console.error("Error fetching room assignment counts:", error);
        // No need to reset - will keep current values
      }
    },
    
    async fetchPendingAssignments() {
      try {
        // Try multiple endpoints with a fallback approach for pending assignments count
        const endpoints = [
          '/api/admin/applications/count-pending/',
          '/api/admin/applications/pending/count/',
          '/api/admin/test-sessions/pending-count/',
          '/api/applications/pending/'
        ];
        
        let success = false;
        
        for (const endpoint of endpoints) {
          try {
            const response = await axiosInstance.get(endpoint);
            
            // Different response formats that might contain the count
            if (response.data) {
              if (typeof response.data.count === 'number') {
                this.stats.pendingAssignments = response.data.count;
                success = true;
                break;
              } else if (typeof response.data === 'number') {
                this.stats.pendingAssignments = response.data;
                success = true;
                break;
              } else if (Array.isArray(response.data)) {
                // If it's an array, use the length
                this.stats.pendingAssignments = response.data.length;
                success = true;
                break;
              }
            }
          } catch (err) {
            // Continue to next endpoint
            console.log(`Endpoint ${endpoint} failed:`, err.message);
          }
        }
        
        if (!success) {
          console.warn('Could not fetch pending assignments count from any endpoint');
          // Leave the existing count as is instead of resetting to 0
        }
      } catch (error) {
        console.error('Error fetching pending assignments:', error);
        // Don't reset to 0, just keep the current value
      }
    },
    
    // UI action methods
    editSession(session) {
      // Set up form data for editing
      this.newSession = { ...session };
      this.showCreateSessionModal = true;
      
      // Change the button text and action to reflect editing
      const createButton = document.querySelector("#createSessionBtn");
      if (createButton) {
        createButton.textContent = "Save Changes";
      }
      
      // Store the session ID for the update operation
      this.editingSessionId = session.id;
    },      async checkRoomAllocations(session) {
      // Store the selected session and show the modal
      this.selectedSession = session;
      this.roomAllocations.loading = true;
      this.roomAllocations.error = null;
      this.roomAllocations.data = [];
      
      try {
        // First try using the new API endpoint which provides allocations for a specific session
        try {
          // This will use the new endpoint we just created
          const response = await axiosInstance.get(`/api/admin/test-sessions/${session.id}/allocations/`);
          if (response.data && Array.isArray(response.data)) {
            this.roomAllocations.data = response.data;
            console.log('Room allocations fetched from specific endpoint:', this.roomAllocations.data);
          }
        } catch (specificError) {
          console.warn('Specific allocations endpoint failed, falling back to generic approach:', specificError);
          
          // Fallback approach: Fetch test rooms data and centers data separately
          const roomsResponse = await axiosInstance.get('/api/admin/test-rooms/');
          const centersResponse = await axiosInstance.get('/api/admin/test-centers/');
          
          const centers = centersResponse.data || [];
          const allRooms = roomsResponse.data || [];
          
          // Process and format room data for display
          const roomsWithCenterNames = allRooms.map(room => {
            // Find the center this room belongs to
            const center = centers.find(c => c.id === room.test_center);
            
            return {
              ...room,
              center_name: center ? center.name : 'Unknown Center',
              test_center_name: center ? center.name : 'Unknown Center',
              test_session_id: session.id
            };
          });
          
          // Assign these rooms to the modal data
          this.roomAllocations.data = roomsWithCenterNames;
          console.log('Room allocations prepared via fallback:', this.roomAllocations.data);
        }
      } catch (error) {
        console.error('Error fetching room allocations:', error);
        this.roomAllocations.error = 'Failed to load room allocations. Please try again.';
        this.showToast('Failed to load room allocations', 'error');
      } finally {
        this.roomAllocations.loading = false;
      }
      
      // Show the modal
      this.showRoomAllocationsModal = true;
    },
    
    showDeleteConfirmation(session) {
      this.confirmationData = {
        title: 'Delete Test Session',
        message: `Are you sure you want to delete the ${session.exam_type} test session on ${this.formatDate(session.exam_date)}? This action cannot be undone.`,
        confirmButtonText: 'Delete',
        action: this.deleteSession,
        item: session
      };
      this.showConfirmationModal = true;
    },
    
    showAutoAssignConfirmation() {
      if (this.stats.pendingAssignments === 0) {
        this.showToast('No pending assignments to auto-assign', 'info');
        return;
      }
      this.showAutoAssignConfirmModal = true;
    },
    
    async deleteSession(session) {
      try {
        await axiosInstance.delete(`/api/admin/test-sessions/${session.id}/`);
        
        // Remove from local array
        this.testSessions = this.testSessions.filter(s => s.id !== session.id);
        
        // Show success message
        this.showToast('Session deleted successfully', 'success');
      } catch (error) {
        console.error('Error deleting session:', error);
        throw error;
      }
    },
    
    viewCenterRooms(center) {
      // Switch to rooms tab and filter by this center
      this.activeTab = 'rooms';
      this.roomFilters.centerId = center.id;
      // Update pagination when filter changes
      this.updateRoomsPagination();
    },
    
    editCenter(center) {
      // Set up form data for editing
      this.newCenter = { ...center };
      this.showCreateCenterModal = true;
      
      // Change the button text and action to reflect editing
      const createButton = document.querySelector("#createCenterBtn");
      if (createButton) {
        createButton.textContent = "Save Changes";
      }
      
      // Store the center ID for the update operation
      this.editingCenterId = center.id;
    },
    
    editRoom(room) {
      // Set up form data for editing
      this.newRoom = { ...room };
      this.showCreateRoomModal = true;
      
      // Change the button text and action to reflect editing
      const createButton = document.querySelector("#createRoomBtn");
      if (createButton) {
        createButton.textContent = "Save Changes";
      }
      
      // Store the room ID for the update operation
      this.editingRoomId = room.id;
    },
    
    showDeleteCenterConfirmation(center) {
      this.confirmationData = {
        title: 'Delete Test Center',
        message: `Are you sure you want to delete the center "${center.name}"? This will also delete all rooms associated with this center.`,
        confirmButtonText: 'Delete',
        action: this.deleteCenter,
        item: center
      };
      this.showConfirmationModal = true;
    },
    
    async deleteCenter(center) {
      try {
        await axiosInstance.delete(`/api/admin/test-centers/${center.id}/`);
        this.showToast('Test center deleted successfully', 'success');
        await this.fetchTestCenters();
        await this.fetchTestRooms(); // Refresh rooms since they might be affected
      } catch (error) {
        console.error('Error deleting test center:', error);
        this.showToast('Failed to delete test center', 'error');
      }
    },
    
    showDeleteRoomConfirmation(room) {
      this.confirmationData = {
        title: 'Delete Test Room',
        message: `Are you sure you want to delete the room "${room.name}"? Any assigned students will need to be reassigned.`,
        confirmButtonText: 'Delete',
        action: this.deleteRoom,
        item: room
      };
      this.showConfirmationModal = true;
    },
    
    async deleteRoom(room) {
      try {
        await axiosInstance.delete(`/api/admin/test-rooms/${room.id}/`);
        
        // Remove from local array
        this.testRooms = this.testRooms.filter(r => r.id !== room.id);
        
        // Show success message
        this.showToast('Room deleted successfully', 'success');
      } catch (error) {
        console.error('Error deleting room:', error);
        throw error;
      }
    },
    
    async createSession() {
      if (!this.isValidSession) {
        this.showToast('Please fill out all required fields', 'error');
        return;
      }
      
      this.loading.createSession = true;
      
      try {
        // Check if we're editing an existing session or creating a new one
        if (this.editingSessionId) {
          // Update existing session
          const response = await axiosInstance.put(`/api/admin/test-sessions/${this.editingSessionId}/`, this.newSession);
          
          // Update in the local array
          const index = this.testSessions.findIndex(s => s.id === this.editingSessionId);
          if (index !== -1) {
            this.testSessions[index] = response.data;
          }
          
          // Show success message
          this.showToast('Test session updated successfully', 'success');
        } else {
          // Create new session
          const response = await axiosInstance.post('/api/admin/test-sessions/', this.newSession);
          
          // Add to local array
          this.testSessions.push(response.data);
          
          // Show success message
          this.showToast('Test session created successfully', 'success');
        }
        
        // Update stats
        this.stats.upcomingSessions = this.testSessions.filter(s => s.status === 'SCHEDULED').length;
        
        // Reset form and close modal
        this.newSession = {
          exam_type: '',
          registration_start_date: '',
          registration_end_date: '',
          exam_date: '',
          status: 'SCHEDULED'
        };
        this.editingSessionId = null;
        this.showCreateSessionModal = false;
        
        // Reset button text
        const createButton = document.querySelector("#createSessionBtn");
        if (createButton) {
          createButton.textContent = "Create Session";
        }
      } catch (error) {
        console.error('Error with test session:', error);
        this.showToast(this.editingSessionId ? 'Error updating test session' : 'Error creating test session', 'error');
      } finally {
        this.loading.createSession = false;
      }
    },
    
    async createCenter() {
      if (!this.newCenter.name || !this.newCenter.code) {
        this.showToast('Please fill out all required fields', 'error');
        return;
      }
      
      this.loading.createCenter = true;
      
      try {
        // Check if we're editing an existing center or creating a new one
        if (this.editingCenterId) {
          // Update existing center
          const response = await axiosInstance.put(`/api/admin/test-centers/${this.editingCenterId}/`, this.newCenter);
          
          // Update in the local array
          const index = this.testCenters.findIndex(c => c.id === this.editingCenterId);
          if (index !== -1) {
            // Preserve the room count
            response.data.roomCount = this.testCenters[index].roomCount;
            this.testCenters[index] = response.data;
          }
          
          // Show success message
          this.showToast('Test center updated successfully', 'success');
        } else {
          // Create new center
          const response = await axiosInstance.post('/api/admin/test-centers/', this.newCenter);
          
          // Add room count property
          response.data.roomCount = 0;
          
          // Add to local array
          this.testCenters.push(response.data);
          
          // Show success message
          this.showToast('Test center created successfully', 'success');
        }
        
        // Update stats
        this.stats.availableCenters = this.testCenters.filter(c => c.is_active).length;
        
        // Reset form and close modal
        this.newCenter = {
          name: '',
          code: '',
          address: '',
          is_active: true
        };
        this.editingCenterId = null;
        this.showCreateCenterModal = false;
        
        // Reset button text
        const createButton = document.querySelector("#createCenterBtn");
        if (createButton) {
          createButton.textContent = "Create Center";
        }
      } catch (error) {
        console.error('Error with test center:', error);
        this.showToast(this.editingCenterId ? 'Error updating test center' : 'Error creating test center', 'error');
      } finally {
        this.loading.createCenter = false;
      }
    },
    
    async createRoom() {
      if (!this.newRoom.name || !this.newRoom.room_code || !this.newRoom.test_center) {
        this.showToast('Please fill out all required fields', 'error');
        return;
      }
      
      this.loading.createRoom = true;
      
      try {
        // Check if we're editing an existing room or creating a new one
        if (this.editingRoomId) {
          // Update existing room
          const response = await axiosInstance.put(`/api/admin/test-rooms/${this.editingRoomId}/`, this.newRoom);
          
          // Update in the local array
          const index = this.testRooms.findIndex(r => r.id === this.editingRoomId);
          if (index !== -1) {
            // Preserve assigned_count and available_capacity
            response.data.assigned_count = this.testRooms[index].assigned_count;
            response.data.available_capacity = response.data.capacity - this.testRooms[index].assigned_count;
            this.testRooms[index] = response.data;
          }
          
          // Show success message
          this.showToast('Test room updated successfully', 'success');
        } else {
          // If creating both time slots
          if (this.createBothSlots) {
            // Create morning room
            const morningRoom = {
              ...this.newRoom,
              time_slot: 'morning',
              name: `${this.newRoom.name} - Morning`
            };
            
            // Create afternoon room
            const afternoonRoom = {
              ...this.newRoom,
              time_slot: 'afternoon',
              name: `${this.newRoom.name} - Afternoon`,
              room_code: `${this.newRoom.room_code}-PM` // Add PM suffix to differentiate
            };
            
            // Create both rooms
            const [morningResponse, afternoonResponse] = await Promise.all([
              axiosInstance.post('/api/admin/test-rooms/', morningRoom),
              axiosInstance.post('/api/admin/test-rooms/', afternoonRoom)
            ]);
            
            // Add assigned count and available capacity properties
            morningResponse.data.assigned_count = 0;
            morningResponse.data.available_capacity = morningResponse.data.capacity;
            afternoonResponse.data.assigned_count = 0;
            afternoonResponse.data.available_capacity = afternoonResponse.data.capacity;
            
            // Add to local array
            this.testRooms.push(morningResponse.data);
            this.testRooms.push(afternoonResponse.data);
            
            // Show success message
            this.showToast('Both morning and afternoon test rooms created successfully', 'success');
          } else {
            // Just create a single room
            const response = await axiosInstance.post('/api/admin/test-rooms/', this.newRoom);
            
            // Add assigned count and available capacity properties
            response.data.assigned_count = 0;
            response.data.available_capacity = response.data.capacity;
            
            // Add to local array
            this.testRooms.push(response.data);
            
            // Show success message
            this.showToast('Test room created successfully', 'success');
          }
        }
        
        // Update pagination when adding new rooms
        this.updateRoomsPagination();
        
        // Reset form
        this.newRoom = {
          test_center: '',
          name: '',
          room_code: '',
          capacity: 30,
          is_active: true,
          time_slot: 'morning'
        };
        this.createBothSlots = false;
        this.editingRoomId = null;
        this.showCreateRoomModal = false;
        
        // Reset button text
        const createButton = document.querySelector("#createRoomBtn");
        if (createButton) {
          createButton.textContent = "Create Room";
        }
      } catch (error) {
        console.error('Error with test room:', error);
        this.showToast(this.editingRoomId ? 'Error updating test room' : 'Error creating test room', 'error');
      } finally {
        this.loading.createRoom = false;
      }
    },
    
    /**
     * Runs the auto-assign process for students
     */
    async runAutoAssign() {
      if (!this.autoAssign.testSessionId) {
        this.showToast('Invalid test session ID', 'error');
        return;
      }

      this.loading.autoAssign = true;
      
      try {
        // Check if rooms with selected time slot exist and have capacity
        const timeSlotToCheck = this.autoAssign.timeSlot === 'both' ? null : this.autoAssign.timeSlot;
        await this.checkRoomAvailability(timeSlotToCheck);

        // Prepare request data for auto-assignment
        const requestData = {
          session_id: this.autoAssign.testSessionId,
          test_session_id: this.autoAssign.testSessionId,
          group_by_school: this.autoAssign.groupBySchool,
          balance_rooms: this.autoAssign.balanceRooms,
          time_slot: this.autoAssign.timeSlot,
          respect_capacity: true,
          ignore_student_preferences: this.autoAssign.ignorePreferences,
          force_time_slot: this.autoAssign.timeSlot !== 'both'
        };

        console.log('Auto-assign request:', requestData);
        
        // Try the main auto-assign endpoint
        const response = await axiosInstance.post('/api/admin/auto-assign-test-details/', requestData);
        
        if (response.data.success) {
          console.log('Auto-assignment successful:', response.data);
          const assignedCount = response.data.assigned_count || response.data.assignments_made || 0;
          
          if (assignedCount > 0) {
            this.showToast(`Successfully assigned ${assignedCount} students to test rooms`, 'success');
            
            // Update room capacities based on the assignment results
            if (response.data.room_assignments) {
              await this.updateRoomCapacities(response.data.room_assignments);
            }
            
            // Refresh data and close modal
            await this.fetchRoomAssignmentCounts();  
            await this.fetchPendingAssignments();
            this.showAutoAssignModal = false;
          } else {
            this.showToast('No students were assigned. Check if there are available rooms and pending applications.', 'warning');
          }
        } else {
          const message = response.data.message || 'Auto-assignment completed but no students were assigned';
          this.showToast(message, 'warning');
        }
        
      } catch (error) {
        console.error('Auto-assignment error:', error);
        
        const errorMessage = error?.response?.data?.message || 
                             error?.response?.data?.error ||
                             error?.message ||
                             'Error occurred during auto-assignment';
                            
        this.showToast(errorMessage, 'error');
      } finally {
        this.loading.autoAssign = false;
      }
    },
    
    /**
     * Checks if rooms with the specified time slot exist and have capacity
     * @param {String|null} timeSlot - 'morning', 'afternoon', or null for both
     */
    async checkRoomAvailability(timeSlot) {
      try {
        // First ensure we have fresh room data
        if (this.testRooms.length === 0) {
          await this.fetchTestRooms();
        }
        
        // Filter rooms by time slot if specified
        const availableRooms = this.testRooms.filter(room => {
          // Only include active rooms
          if (!room.is_active) return false;
          
          // Filter by time slot if specified
          if (timeSlot && room.time_slot !== timeSlot) return false;
          
          // Check if the room has capacity
          return (room.available_capacity || 0) > 0;
        });
        
        console.log(`Available rooms for time slot ${timeSlot || 'both'}:`, availableRooms);
        
        // If no rooms available for the selected time slot, show warning
        if (availableRooms.length === 0) {
          const slotDisplay = timeSlot || 'any time slot';
          const warningMessage = `No available rooms found for ${slotDisplay}. Create rooms with capacity for this time slot before assigning.`;
          
          this.showToast(warningMessage, 'warning');
          
          throw new Error(warningMessage);
        }
        
        return true;
      } catch (error) {
        console.error('Error checking room availability:', error);
        throw error;
      }
    },
    
    /**
     * Updates room capacities based on assignment results
     * Note: The actual counts are stored in the database and retrieved via API
     * This method is just for immediate UI feedback until the next data refresh
     * @param {Array} roomAssignments - Array of room assignment data 
     */
    async updateRoomCapacities(roomAssignments) {
      if (!roomAssignments || !Array.isArray(roomAssignments)) {
        console.log('No room assignments provided to update capacities');
        return;
      }
      
      try {
        // Update local room capacities based on assignment results
        roomAssignments.forEach(assignment => {
          const room = this.testRooms.find(r => r.id === assignment.room_id);
          if (room) {
            // Update assigned count if provided
            if (assignment.assigned_count !== undefined) {
              room.assigned_count = assignment.assigned_count;
              room.available_capacity = room.capacity - assignment.assigned_count;
            }
            // Or increment by 1 if this is a single assignment
            else if (assignment.student_id || assignment.application_id) {
              room.assigned_count = (room.assigned_count || 0) + 1;
              room.available_capacity = room.capacity - room.assigned_count;
            }
          }
        });
        
        console.log('Updated room capacities locally');
        
        // Also refresh from the server to ensure accuracy
        await this.fetchRoomAssignmentCounts();
        
      } catch (error) {
        console.error('Error updating room capacities:', error);
      }
    },
    
    // Pagination methods
    changeSessionsPage(page) {
      this.pagination.sessions.currentPage = page;
    },
    
    changeCentersPage(page) {
      this.pagination.centers.currentPage = page;
    },
    
    changeRoomsPage(page) {
      this.pagination.rooms.currentPage = page;
    },
    
    updateRoomsPagination() {
      this.pagination.rooms.totalItems = this.filteredRooms.length;
      // Reset to page 1 if current page is beyond available pages
      const totalPages = Math.ceil(this.pagination.rooms.totalItems / this.pagination.rooms.itemsPerPage);
      if (this.pagination.rooms.currentPage > totalPages && totalPages > 0) {
        this.pagination.rooms.currentPage = 1;
      }
    },
    
    cancelCenterModal() {
      this.showCreateCenterModal = false;
      this.newCenter = {
        name: '',
        code: '',
        address: '',
        is_active: true
      };
      this.editingCenterId = null;
      
      // Reset button text
      const createButton = document.querySelector("#createCenterBtn");
      if (createButton) {
        createButton.textContent = "Create Center";
      }
    },
    
    cancelSessionModal() {
      this.showCreateSessionModal = false;
      this.newSession = {
        exam_type: '',
        registration_start_date: '',
        registration_end_date: '',
        exam_date: '',
        status: 'SCHEDULED'
      };
      this.editingSessionId = null;
      
      // Reset button text
      const createButton = document.querySelector("#createSessionBtn");
      if (createButton) {
        createButton.textContent = "Create Session";
      }
    },
    
    cancelRoomModal() {
      this.showCreateRoomModal = false;
      this.newRoom = {
        test_center: '',
        name: '',
        room_code: '',
        capacity: 30,
        is_active: true,
        time_slot: 'morning'
      };
      this.createBothSlots = false;
      this.editingRoomId = null;
      
      // Reset button text
      const createButton = document.querySelector("#createRoomBtn");
      if (createButton) {
        createButton.textContent = "Create Room";
      }
    },
    
    // Handle confirmation modal actions
    async confirmAction() {
      if (this.confirmationData.action) {
        this.loading.confirmation = true;
        try {
          await this.confirmationData.action(this.confirmationData.item);
          this.showConfirmationModal = false;
        } catch (error) {
          console.error('Error executing confirmation action:', error);
          this.showToast('An error occurred while processing your request', 'error');
        } finally {
          this.loading.confirmation = false;
        }
      }
    },
    
    // Get display text for confirmation modal
    getItemDisplayText(item) {
      if (!item) return '';
      
      if (item.exam_type) {
        // Test session
        return `${item.exam_type} - ${this.formatDate(item.exam_date)}`;
      } else if (item.name && item.code) {
        // Test center
        return `${item.name} (${item.code})`;
      } else if (item.name && item.room_code) {
        // Test room
        return `${item.name} (${item.room_code})`;
      }
      
      return item.name || item.code || 'Unknown item';
    },
    
    // Delete session method
    async deleteSession(session) {
      try {
        await axiosInstance.delete(`/api/admin/test-sessions/${session.id}/`);
        this.showToast('Test session deleted successfully', 'success');
        await this.fetchTestSessions();
      } catch (error) {
        console.error('Error deleting test session:', error);
        this.showToast('Failed to delete test session', 'error');
      }
    },
    
    // Utility methods for formatting
    formatDate(dateString) {
      if (!dateString) return 'N/A';
      return new Date(dateString).toLocaleDateString();
    },
    
    formatDateTime(dateString) {
      if (!dateString) return 'N/A';
      return new Date(dateString).toLocaleString();
    }
  },
  watch: {
    'roomFilters.centerId': function() {
      this.updateRoomsPagination();
    },
    'roomFilters.timeSlot': function() {
      this.updateRoomsPagination();
    }
  }
};
</script>