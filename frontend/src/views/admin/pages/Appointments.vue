<template>
  <main class="flex-1 overflow-y-auto">
    <!-- Top Navigation -->
    <header class="bg-white shadow-sm sticky top-0 z-40">
      <div class="flex justify-between items-center px-6 py-4">
        <h1 class="text-2xl font-bold text-gray-800">Appointments</h1>
        <div class="flex items-center space-x-4">
          <button class="p-2 hover:bg-gray-100 rounded-full">
            <i class="fas fa-bell text-gray-600"></i>
          </button>
          <div class="flex items-center space-x-2">
            <div class="w-8 h-8 rounded-full bg-gray-200 flex items-center justify-center">
              <i class="fas fa-user text-gray-500"></i>
            </div>
            <span class="text-gray-700">Admin User</span>
          </div>
        </div>
      </div>
    </header>

    <!-- Appointments Content -->
    <div class="p-6">
      <!-- Filters and Actions -->
      <div class="bg-white rounded-xl shadow-sm border border-gray-100 p-6 mb-6">
        <div class="flex flex-wrap gap-4 items-center justify-between mb-4">
          <div class="flex flex-wrap gap-4 items-center">
            <div class="relative">
              <input 
                type="text" 
                v-model="searchQuery"
                placeholder="Search appointments..." 
                class="pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-crimson-500 focus:border-transparent"
              >
              <i class="fas fa-search absolute left-3 top-3 text-gray-400"></i>
            </div>
            <select v-model="programFilter" class="px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-crimson-500">
              <option value="all">All Programs</option>
              <option v-for="program in programOptions" 
                      :key="program" 
                      :value="program.toLowerCase()">
                {{ program }}
              </option>
            </select>
            <select v-model="statusFilter" class="px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-crimson-500">
              <option value="all">All Status</option>
              <option v-for="status in statusOptions" 
                      :key="status" 
                      :value="status">
                {{ formatStatus(status) }}
              </option>
            </select>
            <input type="date" v-model="dateFilter" class="px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-crimson-500">
          </div>
        </div>
      </div>

      <!-- Add this right after the filter div, before the table -->
      <div v-if="loading" class="flex justify-center py-8">
        <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-crimson-600"></div>
      </div>

      <!-- Show a message when there are no appointments -->
      <div v-else-if="appointments.length === 0" class="py-8 text-center text-gray-500">
        <i class="fas fa-calendar-times text-4xl mb-2"></i>
        <p>No appointments found</p>
      </div>

      <!-- Appointments Table -->
      <div v-else class="bg-white rounded-xl shadow-sm border border-gray-100 overflow-hidden">
        <div class="p-6 border-b border-gray-100 flex justify-between items-center">
          <div>
            <h2 class="text-xl font-bold text-gray-800">Appointments</h2>
            <p class="text-sm text-gray-500 mt-1">Manage and track your appointments</p>
          </div>
          <div class="flex space-x-2">
            <button @click="showFilters = !showFilters" class="px-4 py-2 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200 transition-colors duration-200">
              <i class="fas fa-filter mr-2"></i>
              {{ showFilters ? 'Hide Filters' : 'Filter' }}
            </button>
            <button class="px-4 py-2 bg-crimson-600 text-white rounded-lg hover:bg-crimson-700 transition-colors duration-200">
              <i class="fas fa-plus mr-2"></i>
              New Appointment
            </button>
          </div>
        </div>
        
        <!-- Tab Navigation -->
        <div class="flex border-b border-gray-200">
          <button 
            @click="activeTab = 'all'" 
            :class="[
              'px-4 py-2 font-medium text-sm focus:outline-none',
              activeTab === 'all' 
                ? 'border-b-2 border-crimson-600 text-crimson-600' 
                : 'text-gray-500 hover:text-gray-700'
            ]"
          >
            All Appointments
          </button>
          <button 
            @click="activeTab = 'waiting_for_submission'" 
            :class="[
              'px-4 py-2 font-medium text-sm focus:outline-none',
              activeTab === 'waiting_for_submission' 
                ? 'border-b-2 border-crimson-600 text-crimson-600' 
                : 'text-gray-500 hover:text-gray-700'
            ]"
          >
            Waiting for Submission
          </button>
          <button 
            @click="activeTab = 'approved'" 
            :class="[
              'px-4 py-2 font-medium text-sm focus:outline-none',
              activeTab === 'approved' 
                ? 'border-b-2 border-crimson-600 text-crimson-600' 
                : 'text-gray-500 hover:text-gray-700'
            ]"
          >
            Approved Appointments
          </button>
          <button 
            @click="activeTab = 'claimed'" 
            :class="[
              'px-4 py-2 font-medium text-sm focus:outline-none',
              activeTab === 'claimed' 
                ? 'border-b-2 border-crimson-600 text-crimson-600' 
                : 'text-gray-500 hover:text-gray-700'
            ]"
          >
            Claimed
          </button>
        </div>
        
        <!-- Filter Section -->
        <div v-if="showFilters" class="p-4 bg-gray-50 border-b border-gray-100">
          <div class="grid grid-cols-1 md:grid-cols-4 gap-4">
            <!-- Search Filter -->
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Search by Name</label>
              <input 
                type="text" 
                v-model="searchQuery" 
                placeholder="Search by name..."
                class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-crimson-500 focus:border-crimson-500"
                @keyup.enter="applyFilters"
              />
            </div>
            
            <!-- Status Filter -->
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Status</label>
              <select 
                v-model="statusFilter" 
                class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-crimson-500 focus:border-crimson-500"
                @change="applyFilters"
              >
                <option value="all">All Statuses</option>
                <option value="waiting_for_test_details">Waiting for Test Details</option>
                <option value="waiting_for_submission">Waiting for Submission</option>
                <option value="submitted">Submitted</option>
                <option value="rejected">Rejected</option>
                <option value="claimed">Claimed</option>
                <option value="rescheduled">Rescheduled</option>
              </select>
            </div>
            
            <!-- Date Range Filters -->
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">From Date</label>
              <input 
                type="date" 
                v-model="dateFilterFrom" 
                class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-crimson-500 focus:border-crimson-500"
                @change="applyFilters"
              />
            </div>
            
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">To Date</label>
              <input 
                type="date" 
                v-model="dateFilterTo" 
                class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-crimson-500 focus:border-crimson-500"
                @change="applyFilters"
              />
            </div>
            
            <!-- Filter Actions -->
            <div class="md:col-span-4 flex justify-end space-x-2 mt-2">
              <button 
                @click="resetFilters" 
                class="px-4 py-2 bg-gray-200 text-gray-700 rounded-lg hover:bg-gray-300 transition-colors duration-200"
              >
                Reset Filters
              </button>
              <button 
                @click="applyFilters" 
                class="px-4 py-2 bg-crimson-600 text-white rounded-lg hover:bg-crimson-700 transition-colors duration-200"
              >
                Apply Filters
              </button>
            </div>
          </div>
        </div>

        <div class="overflow-x-auto">
          <table class="w-full text-sm">
            <thead class="bg-gray-50">
              <tr>
                <th class="px-3 py-2 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">Applicant</th>
                <th class="px-3 py-2 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">School</th>
                <th class="px-3 py-2 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">Contact</th>
                <th class="px-3 py-2 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">Program</th>
                <th class="px-3 py-2 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">Date</th>
                <th class="px-3 py-2 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">Time</th>
                <th class="px-3 py-2 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">Status</th>
                <th class="px-3 py-2 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">Actions</th>
              </tr>
            </thead>
            <tbody class="divide-y divide-gray-100">
              <tr v-for="appointment in paginatedAppointments" 
                  :key="appointment.id" 
                  class="hover:bg-gray-50 transition-colors duration-200">
                <td class="px-3 py-2">
                  <div class="flex items-center">
                    <div class="w-8 h-8 rounded-full bg-gradient-to-r from-gray-100 to-gray-200 flex items-center justify-center mr-2">
                      <i class="fas fa-user text-sm text-gray-600"></i>
                    </div>
                    <div>
                      <div class="text-xs font-medium text-gray-900">{{ appointment.applicantName }}</div>
                      <div class="text-xs text-gray-500">{{ appointment.email }}</div>
                    </div>
                  </div>
                </td>
                <td class="px-3 py-2">
                  <div class="text-xs text-gray-900">{{ appointment.school }}</div>
                </td>
                <td class="px-3 py-2">
                  <div class="text-xs text-gray-600">{{ appointment.contact }}</div>
                </td>
                <td class="px-3 py-2">
                  <div class="text-xs font-medium text-gray-900">{{ appointment.program }}</div>
                </td>
                <td class="px-3 py-2">
                  <div class="text-xs text-gray-600">{{ formatDate(appointment.date) }}</div>
                </td>
                <td class="px-3 py-2">
                  <div class="text-xs text-gray-600">
                    {{ appointment.time.replace('Morning (', 'AM (').replace('Afternoon (', 'PM (') }}
                  </div>
                </td>
                <td class="px-3 py-2">
                  <span :class="getStatusClass(appointment.status)" class="inline-flex items-center text-xs">
                    <span class="w-1.5 h-1.5 rounded-full mr-1" :class="{
                      'bg-yellow-400': appointment.status === 'pending' || appointment.status === 'waiting_for_submission',
                      'bg-green-400': appointment.status === 'approved' || appointment.status === 'submitted',
                      'bg-red-400': appointment.status === 'rejected',
                      'bg-blue-400': appointment.status === 'claimed',
                      'bg-purple-400': appointment.status === 'rescheduled',
                      'bg-orange-400': appointment.status === 'waiting_for_test_details'
                    }"></span>
                    {{ formatStatus(appointment.status) }}
                  </span>
                </td>
                <td class="px-3 py-2">
                  <div class="flex items-center space-x-2">
                    <!-- View Button -->
                    <button @click="openDetailsModal(appointment)" 
                            class="px-3 py-1 bg-crimson-600 text-white text-xs rounded-md hover:bg-crimson-700 transition-colors duration-200 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-crimson-500"
                            title="View Details">
                      <i class="fas fa-eye mr-1"></i>
                      View
                    </button>
                    
                    <!-- Actions Menu -->
                    <div class="relative">
                      <button @click="toggleActionsMenu($event, appointment.id)" 
                              class="p-1.5 rounded-full hover:bg-gray-100 transition-colors duration-200 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-crimson-500"
                              title="Actions">
                        <i class="fas fa-ellipsis-h text-gray-600"></i>
                      </button>
                    
                    <!-- Enhanced Dropdown menu with position awareness -->
                    <div v-if="activeActionMenu === appointment.id" 
                         :class="[
                           dropdownPositions[appointment.id] === 'top' ? 'bottom-full mb-2' : 'top-full mt-2',
                           'absolute right-0 py-2 w-56 bg-white rounded-lg shadow-lg z-50 border border-gray-200 animate-fade-in'
                         ]">
                      <div class="px-4 py-2 border-b border-gray-100">
                        <p class="text-xs font-semibold text-gray-500 uppercase">Actions</p>
                      </div>
                      
                      <!-- View details -->
                      <button @click="openDetailsModal(appointment)" 
                              class="w-full text-left px-4 py-2 text-sm text-gray-700 hover:bg-gray-50 flex items-center">
                        <i class="fas fa-info-circle mr-2 text-crimson-500"></i> View Details
                      </button>
                      
                      <!-- Conditional actions based on status -->
                      <div v-if="appointment.status === 'pending'" class="border-t border-gray-100 mt-1 pt-1">
                        <button @click="approveAppointment(appointment)" 
                                class="w-full text-left px-4 py-2 text-sm text-green-600 hover:bg-green-50 flex items-center">
                          <i class="fas fa-check mr-3"></i> Approve Appointment
                        </button>
                        
                        <button @click="rejectAppointment(appointment)" 
                                class="w-full text-left px-4 py-2 text-sm text-red-600 hover:bg-red-50 flex items-center">
                          <i class="fas fa-times mr-3"></i> Reject Appointment
                        </button>
                      </div>
                      
                      <!-- Add Mark as Claimed option for approved appointments -->
                      <div v-if="appointment.status === 'approved'" class="border-t border-gray-100 mt-1 pt-1">
                        <button @click="openClaimModal(appointment)" 
                                class="w-full text-left px-4 py-2 text-sm text-blue-600 hover:bg-blue-50 flex items-center">
                          <i class="fas fa-clipboard-check mr-3"></i> Mark as Claimed
                        </button>
                      </div>
                      
                      <!-- Add Submitted option for waiting_for_submission status -->
                      <div v-if="appointment.status === 'waiting_for_submission'" class="border-t border-gray-100 mt-1 pt-1">
                        <button @click="markAsSubmitted(appointment)" 
                                class="w-full text-left px-4 py-2 text-sm text-green-600 hover:bg-green-50 flex items-center">
                          <i class="fas fa-file-signature mr-3"></i> Mark as Submitted
                        </button>
                      </div>
                      
                      <!-- Only show reschedule option if NOT claimed, NOT pending, and NOT submitted -->
                      <div v-if="appointment.status !== 'claimed' && appointment.status !== 'pending' && appointment.status !== 'submitted'" class="border-t border-gray-100 mt-1 pt-1">
                        <button @click="openRescheduleModal(appointment)" 
                                class="w-full text-left px-4 py-2 text-sm text-purple-600 hover:bg-purple-50 flex items-center">
                          <i class="fas fa-calendar-alt mr-3"></i> Reschedule
                        </button>
                      </div>
                    </div>
                    </div>
                  </div>
                </td>
              </tr>
            </tbody>
          </table>
        </div>

        <!-- Pagination -->
        <AdminPagination
          :model-value="currentPage"
          :items-per-page="itemsPerPage"
          :total-items="totalAppointments"
          @update:model-value="changePage"
        />
      </div>
    </div>

    <!-- Appointment Details Modal -->
    <AppointmentDetailsModal 
      :show="showDetailsModal"
      :appointment="selectedAppointment" 
      @close="showDetailsModal = false"
      @approve="approveAppointment"
      @reject="rejectAppointment"
      @claim="openClaimModal"
      @reschedule="openRescheduleModal"
    />

    <!-- Reschedule Modal -->
    <div v-if="showRescheduleModal" class="fixed inset-0 z-50 overflow-y-auto">
      <div class="flex items-center justify-center min-h-screen pt-4 px-4 pb-20 text-center sm:block sm:p-0">
        <div class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity" 
             aria-hidden="true" 
             @click="showRescheduleModal = false"></div>

        <!-- Modal panel -->
        <div class="inline-block align-bottom bg-white rounded-lg text-left overflow-hidden shadow-xl transform transition-all sm:my-8 sm:align-middle sm:max-w-lg sm:w-full">
          <div v-if="selectedAppointment" class="bg-white">
            <div class="px-4 py-5 border-b border-gray-200 sm:px-6">
              <h3 class="text-lg leading-6 font-medium text-gray-900">
                Reschedule Appointment
              </h3>
              <p class="mt-1 max-w-2xl text-sm text-gray-500">
                Allow the student to reschedule their appointment
              </p>
            </div>
            
            <div class="px-4 py-5 sm:p-6">
              <div class="bg-yellow-50 border-l-4 border-yellow-400 p-4 mb-4">
                <div class="flex">
                  <div class="flex-shrink-0">
                    <i class="fas fa-exclamation-triangle text-yellow-400"></i>
                  </div>
                  <div class="ml-3">
                    <p class="text-sm text-yellow-700">
                      This will mark the appointment for rescheduling and notify the student that they can select a new date.
                    </p>
                  </div>
                </div>
              </div>
              
              <div class="mt-2">
                <p class="text-sm text-gray-500">
                  Student: <span class="font-medium text-gray-900">{{ selectedAppointment.applicantName }}</span>
                </p>
                <p class="text-sm text-gray-500 mt-1">
                  Current date: <span class="font-medium text-gray-900">{{ formatDate(selectedAppointment.date) }}</span>
                </p>
              </div>
              
              <!-- Optional reason field -->
              <div class="mt-4">
                <label for="reschedule-reason" class="block text-sm font-medium text-gray-700">
                  Reason for reschedule (optional)
                </label>
                <textarea
                  id="reschedule-reason"
                  v-model="rescheduleReason"
                  rows="3"
                  class="mt-1 shadow-sm focus:ring-crimson-500 focus:border-crimson-500 block w-full sm:text-sm border-gray-300 rounded-md"
                  placeholder="Provide a reason for rescheduling"
                ></textarea>
              </div>
            </div>
            
            <div class="px-4 py-3 bg-gray-50 sm:px-6 sm:flex sm:flex-row-reverse">
              <button 
                @click="confirmReschedule"
                class="w-full inline-flex justify-center rounded-md border border-transparent shadow-sm px-4 py-2 bg-purple-600 text-base font-medium text-white hover:bg-purple-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-purple-500 sm:ml-3 sm:w-auto sm:text-sm"
              >
                Confirm Reschedule
              </button>
              <button 
                @click="showRescheduleModal = false"
                class="mt-3 w-full inline-flex justify-center rounded-md border border-gray-300 shadow-sm px-4 py-2 bg-white text-base font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-crimson-500 sm:mt-0 sm:ml-3 sm:w-auto sm:text-sm"
              >
                Cancel
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Claim Appointment Modal -->
    <div v-if="showClaimModal" class="fixed inset-0 z-50 overflow-y-auto">
      <div class="flex items-center justify-center min-h-screen pt-4 px-4 pb-20 text-center sm:block sm:p-0">
        <div class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity" 
             aria-hidden="true" 
             @click="showClaimModal = false"></div>

        <!-- Modal panel -->
        <div class="inline-block align-bottom bg-white rounded-lg text-left overflow-hidden shadow-xl transform transition-all sm:my-8 sm:align-middle sm:max-w-lg sm:w-full">
          <div v-if="selectedAppointment" class="bg-white">
            <!-- Modal Header -->
            <div class="px-6 py-4 border-b border-gray-200">
              <div class="flex items-center justify-between">
                <div>
                  <h3 class="text-lg font-semibold text-gray-900">
                    Mark Appointment as Claimed
                  </h3>
                  <p class="mt-1 text-sm text-gray-500">
                    Complete the claiming process by entering the application number
                  </p>
                </div>
                <span class="px-3 py-1 text-xs font-medium rounded-full" 
                      :class="getStatusClass(selectedAppointment.status)">
                  {{ selectedAppointment.status }}
                </span>
              </div>
            </div>
            
            <!-- Modal Body -->
            <div class="px-6 py-4">
              <!-- Student Information -->
              <div class="bg-gray-50 rounded-lg p-4 mb-6">
                <div class="grid grid-cols-2 gap-4">
                  <div>
                    <p class="text-sm text-gray-500">Student Name</p>
                    <p class="text-sm font-medium text-gray-900">{{ selectedAppointment.applicantName }}</p>
                  </div>
                  <div>
                    <p class="text-sm text-gray-500">Program</p>
                    <p class="text-sm font-medium text-gray-900">{{ selectedAppointment.program }}</p>
                  </div>
                  <div>
                    <p class="text-sm text-gray-500">Appointment Date</p>
                    <p class="text-sm font-medium text-gray-900">{{ formatDate(selectedAppointment.date) }}</p>
                  </div>
                  <div>
                    <p class="text-sm text-gray-500">Time Slot</p>
                    <p class="text-sm font-medium text-gray-900">{{ selectedAppointment.time }}</p>
                  </div>
                </div>
              </div>

              <!-- Info Alert -->
              <div class="bg-blue-50 border-l-4 border-blue-400 p-4 rounded">
                <div class="flex">
                  <div class="flex-shrink-0">
                    <i class="fas fa-info-circle text-blue-400"></i>
                  </div>
                  <div class="ml-3">
                    <h4 class="text-sm font-medium text-blue-800">Important Note</h4>
                    <p class="mt-1 text-sm text-blue-700">
                      Marking an appointment as claimed means the student has completed their exam.
                      This action cannot be undone.
                    </p>
                  </div>
                </div>
              </div>
            </div>
            
            <!-- Modal Footer -->
            <div class="px-6 py-4 bg-gray-50 flex justify-end space-x-3">
              <button 
                @click="showClaimModal = false"
                class="px-4 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-lg hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500"
              >
                Cancel
              </button>
              <button 
                @click="confirmClaim"
                :disabled="isClaimProcessing"
                class="px-4 py-2 text-sm font-medium text-white bg-blue-600 rounded-lg hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 disabled:opacity-50 disabled:cursor-not-allowed flex items-center"
              >
                <i v-if="isClaimProcessing" class="fas fa-spinner fa-spin mr-2"></i>
                <span>Mark as Claimed</span>
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Appointment Approval Confirmation Modal -->
    <div v-if="showApproveModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
      <div class="bg-white rounded-xl shadow-lg w-full max-w-md p-6">
        <div class="text-center">
          <i class="fas fa-check-circle text-4xl text-green-500 mb-4"></i>
          <h3 class="text-lg font-semibold mb-2">Confirm Approval</h3>
          <p class="text-gray-600 mb-6">
            Are you sure you want to approve this appointment? 
            <span v-if="selectedAppointment" class="block mt-2 font-medium">
              {{ selectedAppointment.applicantName }} - {{ formatDate(selectedAppointment.date) }} ({{ selectedAppointment.time }})
            </span>
          </p>
          
          <div class="flex justify-center space-x-3">
            <button 
              @click="showApproveModal = false"
              class="px-4 py-2 text-sm font-medium text-gray-700 bg-gray-100 rounded-lg hover:bg-gray-200"
            >
              Cancel
            </button>
            <button 
              @click="confirmApprove"
              :disabled="isApproving"
              class="px-4 py-2 text-sm font-medium text-white bg-green-600 rounded-lg hover:bg-green-700 flex items-center justify-center"
            >
              <i v-if="isApproving" class="fas fa-spinner fa-spin mr-2"></i>
              Approve Appointment
            </button>
          </div>
        </div>
      </div>
    </div>
  </main>
</template>

<script>
import axios from '@/plugins/axios.js'
import AdminPagination from '../components/AdminPagination.vue'
import { useToast } from '../../../composables/useToast'
import AppointmentDetailsModal from '../components/AppointmentDetailsModal.vue'


export default {
  name: 'Appointments',
  components: {
    AdminPagination,
    AppointmentDetailsModal
  },
  setup() {
    const { showToast } = useToast()
    return { showToast }
  },
  data() {
    return {
      searchQuery: '',
      programFilter: 'all',
      statusFilter: 'all',
      dateFilter: '',
      dateFilterTo: '',
      currentPage: 1,
      itemsPerPage: 10,
      appointments: [],
      programOptions: [],
      statusOptions: [],
      loading: false,
      error: null,
      activeActionMenu: null,
      showDetailsModal: false,
      showRescheduleModal: false,
      showApproveModal: false,
      showClaimModal: false,
      selectedAppointment: null,
      dropdownPositions: {},
      rescheduleReason: '',
      isApproving: false,
      isClaimProcessing: false,
      activeTab: 'all',
      showFilters: false
    }
  },
  created() {
    this.fetchAppointments()
  },
  mounted() {
    this.adjustItemsPerPage()
    window.addEventListener('resize', this.adjustItemsPerPage)
    document.addEventListener('click', this.closeAllActionMenus);
    
    // Watch for route changes to refresh data
    this.$watch(
      () => this.$route.name,
      (newRouteName) => {
        if (newRouteName === 'AdminAppointments') {
          console.log('Returned to Appointments page, refreshing data...');
          this.fetchAppointments();
        }
      }
    );
  },
  beforeDestroy() {
    window.removeEventListener('resize', this.adjustItemsPerPage)
    document.removeEventListener('click', this.closeAllActionMenus);
  },
  computed: {
    filteredAppointments() {
      return this.appointments.filter(appointment => {
        const matchesSearch = 
          appointment.applicantName.toLowerCase().includes(this.searchQuery.toLowerCase()) ||
          appointment.email.toLowerCase().includes(this.searchQuery.toLowerCase())
        const matchesProgram = this.programFilter === 'all' || appointment.program.toLowerCase().includes(this.programFilter)
        const matchesStatus = this.statusFilter === 'all' || appointment.status === this.statusFilter
        const matchesDate = !this.dateFilter || appointment.date === this.dateFilter
        
        // Tab filtering
        let matchesTab = true
        switch (this.activeTab) {
          case 'waiting_for_submission':
            matchesTab = appointment.status === 'waiting_for_submission'
            break
          case 'approved':
            matchesTab = appointment.status === 'approved'
            break
          case 'claimed':
            matchesTab = appointment.status === 'claimed'
            break
          case 'all':
          default:
            matchesTab = true
        }
        
        return matchesSearch && matchesProgram && matchesStatus && matchesDate && matchesTab
      })
    },
    paginatedAppointments() {
      const start = (this.currentPage - 1) * this.itemsPerPage
      const end = start + this.itemsPerPage
      return this.filteredAppointments.slice(start, end)
    },
    totalAppointments() {
      return this.filteredAppointments.length
    },
    totalPages() {
      return Math.ceil(this.totalAppointments / this.itemsPerPage)
    },
    startEntry() {
      return ((this.currentPage - 1) * this.itemsPerPage) + 1
    },
    endEntry() {
      return Math.min(this.currentPage * this.itemsPerPage, this.totalAppointments)
    }
  },
  methods: {
    async fetchAppointments() {
      this.loading = true
      this.error = null
      
      try {
        const response = await axios.get('/api/appointments/')
        
        this.appointments = response.data.map(appointment => ({
          id: appointment.id,
          applicantName: appointment.full_name,
          email: appointment.email,
          school: appointment.school_name,
          contact: appointment.contact_number,
          program: appointment.program_name,
          date: appointment.preferred_date,
          time: appointment.time_slot === 'morning' ? 
                'Morning (8:00 AM - 12:00 PM)' : 
                'Afternoon (1:00 PM - 5:00 PM)',
          status: appointment.status,
          expandSchool: false, // Initialize the expand state
          fullDetails: appointment // Store the full appointment details
        }))

        // Extract unique status options but filter out the standard ones
        // Fix: Use a Set to ensure we only get unique status values
        const uniqueStatuses = [...new Set(this.appointments.map(a => a.status))];
        this.statusOptions = uniqueStatuses
          .filter(status => !['approved', 'pending', 'claimed', 'rejected'].includes(status))
          .sort();
        
        // Extract unique program options
        this.programOptions = [...new Set(this.appointments.map(a => a.program))].sort()
      } catch (error) {
        console.error('Error fetching appointments:', error)
        this.error = 'Failed to load appointments. Please try again.'
      } finally {
        this.loading = false
      }
    },
    async approveAppointment(appointment) {
      this.openApproveModal(appointment);
    },
    async rejectAppointment(appointment) {
      try {
        const response = await axios.patch(`/api/appointments/${appointment.id}/`, {
          status: 'rejected'
        })
        
        const index = this.appointments.findIndex(a => a.id === appointment.id)
        if (index !== -1) {
          this.appointments[index].status = 'rejected'
        }
        
        // Show success notification using centralized toast
        this.showToast(`Appointment for ${appointment.applicantName} has been rejected.`, 'success');
        
        console.log('Appointment rejected:', response.data)
      } catch (error) {
        console.error('Error rejecting appointment:', error)
        this.showToast('Failed to reject appointment. Please try again.', 'error');
      }
    },
    async markAsSubmitted(appointment) {
      try {
        // Close the dropdown menu
        this.activeActionMenu = null;
        
        // Update the appointment status
        const response = await axios.patch(`/api/appointments/${appointment.id}/`, {
          status: 'submitted'
        });
        
        // Update the appointment in the local array
        const index = this.appointments.findIndex(a => a.id === appointment.id);
        if (index !== -1) {
          this.appointments[index].status = 'submitted';
        }
        
        // Show success notification
        this.showToast(`Application for ${appointment.applicantName} has been marked as submitted successfully!`, 'success');
        
        console.log('Application marked as submitted:', response.data);
      } catch (error) {
        console.error('Error marking application as submitted:', error);
        this.showToast('Failed to update application status. Please try again.', 'error');
      }
    },
    async markAsClaimed(appointment) {
      this.openClaimModal(appointment);
    },
    
    formatDate(date) {
      return new Date(date).toLocaleDateString('en-US', {
        year: 'numeric',
        month: 'short',
        day: 'numeric'
      })
    },
    formatStatus(status) {
      const statusMap = {
        'pending': 'Pending',
        'approved': 'Approved',
        'rejected': 'Rejected',
        'claimed': 'Claimed',
        'rescheduled': 'reschedule',
        'waiting_for_test_details': 'waiting for test details',
        'waiting_for_submission': 'waiting for submission',
        'submitted': 'Submitted'
      };
      return statusMap[status] || status;
    },
    getStatusClass(status) {
      const classes = {
        pending: 'bg-yellow-100 text-yellow-800',
        approved: 'bg-green-100 text-green-800',
        rejected: 'bg-red-100 text-red-800',
        claimed: 'bg-blue-100 text-blue-800',
        rescheduled: 'bg-purple-100 text-purple-800',
        waiting_for_test_details: 'bg-indigo-100 text-indigo-800',
        waiting_for_submission: 'bg-teal-100 text-teal-800',
        submitted: 'bg-emerald-100 text-emerald-800'
      }
      return classes[status] || ''
    },
    openNewAppointmentModal() {
      console.log('Opening new appointment modal')
    },
    previousPage() {
      if (this.currentPage > 1) {
        this.currentPage--
      }
    },
    nextPage() {
      if (this.currentPage < this.totalPages) {
        this.currentPage++
      }
    },
    goToPage(page) {
      this.currentPage = page
    },
    adjustItemsPerPage() {
      if (window.innerWidth < 640) { // Small screens
        this.itemsPerPage = 6
      } else if (window.innerWidth < 1024) { // Medium screens
        this.itemsPerPage = 8
      } else { // Large screens
        this.itemsPerPage = 10
      }
    },
    toggleActionsMenu(event, id) {
      event.stopPropagation();
      
      if (this.activeActionMenu === id) {
        this.activeActionMenu = null;
      } else {
        // Determine if the dropdown should open upward or downward
        this.$nextTick(() => {
          const button = event.currentTarget;
          const buttonRect = button.getBoundingClientRect();
          const windowHeight = window.innerHeight;
          
          // If button is in the bottom third of the screen, open dropdown upward
          this.dropdownPositions[id] = buttonRect.bottom > (windowHeight * 0.7) ? 'top' : 'bottom';
          
          this.activeActionMenu = id;
        });
      }
    },
    
    closeAllActionMenus() {
      this.activeActionMenu = null;
    },
    openDetailsModal(appointment) {
      this.selectedAppointment = appointment;
      this.showDetailsModal = true;
      this.activeActionMenu = null; // Close the dropdown when opening modal
      
      // Fetch the latest detailed data for this appointment
      this.fetchAppointmentDetails(appointment.id);
    },
    async fetchAppointmentDetails(appointmentId) {
      try {
        const response = await axios.get(`/api/appointments/${appointmentId}/`);
        
        // Update the selected appointment with the full details
        if (response.data) {
          this.selectedAppointment = {
            ...this.selectedAppointment,
            fullDetails: response.data
          };
          
          // Also update the appointment in the appointments list
          const index = this.appointments.findIndex(a => a.id === appointmentId);
          if (index !== -1) {
            this.appointments[index].fullDetails = response.data;
          }
        }
      } catch (error) {
        console.error('Error fetching appointment details:', error);
        this.showToast('Failed to load complete appointment details', 'error');
      }
    },
    openRescheduleModal(appointment) {
      this.selectedAppointment = appointment;
      this.showRescheduleModal = true;
      this.activeActionMenu = null; // Close the dropdown when opening modal
    },
    openApproveModal(appointment) {
      this.selectedAppointment = appointment;
      this.showApproveModal = true;
      this.activeActionMenu = null; // Close the dropdown when opening modal
    },
    openClaimModal(appointment) {
      this.selectedAppointment = appointment;
      this.showClaimModal = true;
      this.activeActionMenu = null; // Close the dropdown when opening modal
    },
    async confirmApprove() {
      this.isApproving = true;
      try {
        const response = await axios.patch(`/api/appointments/${this.selectedAppointment.id}/`, {
          status: 'approved'
        });
        
        const index = this.appointments.findIndex(a => a.id === this.selectedAppointment.id);
        if (index !== -1) {
          this.appointments[index].status = 'approved';
        }
        
        console.log('Appointment approved:', response.data);
        this.showApproveModal = false;
        
        // Show success notification
        this.showToast('Appointment for ' + this.selectedAppointment.applicantName + ' has been approved successfully!', 'success');
        
      } catch (error) {
        console.error('Error approving appointment:', error);
      } finally {
        this.isApproving = false;
      }
    },
    async confirmReschedule() {
      try {
        const response = await axios.patch(`/api/appointments/${this.selectedAppointment.id}/`, {
          status: 'rescheduled',
          reschedule_requested: true,
          admin_notes: this.rescheduleReason || 'Rescheduling requested by admin'
        });
        
        // Update the appointment in the local array
        const index = this.appointments.findIndex(a => a.id === this.selectedAppointment.id);
        if (index !== -1) {
          this.appointments[index].status = 'rescheduled';
          this.appointments[index].reschedule_requested = true;
        }
        
        // Close the modal and reset
        this.showRescheduleModal = false;
        this.rescheduleReason = '';
        
        // Log room capacity update if there was one
        if (response.data.room_updated) {
          console.log(`Room capacity updated: ${response.data.room_name}, new available capacity: ${response.data.room_available_capacity}`);
        }
        
        // Show success notification using centralized toast
        this.showToast(`Appointment for ${this.selectedAppointment.applicantName} has been marked for rescheduling.`, 'success');
        
        console.log('Appointment marked for rescheduling:', response.data);
      } catch (error) {
        console.error('Error requesting reschedule:', error);
        this.showToast('Failed to reschedule appointment. Please try again.', 'error');
      }
    },
    async confirmClaim() {
      this.isClaimProcessing = true;
      
      try {
        // Update the appointment status to claimed
        const response = await axios.patch(`/api/appointments/${this.selectedAppointment.id}/`, {
          status: 'claimed'
        });
        
        const index = this.appointments.findIndex(a => a.id === this.selectedAppointment.id);
        if (index !== -1) {
          this.appointments[index].status = 'claimed';
        }
        
        // Close the modal
        this.showClaimModal = false;
        
        // Show success notification
        this.showToast('Appointment for ' + this.selectedAppointment.applicantName + ' has been marked as claimed successfully!', 'success');
      } catch (error) {
        console.error('Error marking appointment as claimed:', error);
        
        // Show general error
        this.showToast('Failed to mark appointment as claimed. Please try again.', 'error');
      } finally {
        this.isClaimProcessing = false;
      }
    },
    async changePage(newPage) {
      // Show loading indicator while changing pages
      this.loading = true
      
      // Change the page
      this.currentPage = newPage
      
      // Simulate network delay (you can remove this in production)
      await new Promise(resolve => setTimeout(resolve, 500))
      
      // Hide loading indicator
      this.loading = false
    },
    toggleSchoolExpand(appointment) {
      // Use Vue.set to ensure reactivity
      if (appointment.expandSchool === undefined) {
        this.$set(appointment, 'expandSchool', true);
      } else {
        appointment.expandSchool = !appointment.expandSchool;
      }
    },
    applyFilters() {
      // Reset to first page when filters are applied
      this.currentPage = 1;
      // The filtering is handled by the computed property
    },
    
    resetFilters() {
      this.searchQuery = '';
      this.programFilter = 'all';
      this.statusFilter = 'all';
      this.dateFilter = '';
      this.dateFilterTo = '';
      this.currentPage = 1;
    },
  }
}
</script>

<style>
.bg-crimson-600 {
  background-color: #DC2626;
}

.bg-crimson-700 {
  background-color: #B91C1C;
}

.bg-crimson-100 {
  background-color: #FEE2E2;
}

.bg-crimson-50 {
  background-color: #FEF2F2;
}

.text-crimson-500 {
  color: #EF4444;
}

.text-crimson-600 {
  color: #DC2626;
}

.text-crimson-700 {
  color: #B91C1C;
}

.hover\:bg-crimson-700:hover {
  background-color: #B91C1C;
}

.focus\:ring-crimson-500:focus {
  --tw-ring-color: rgba(220, 38, 38, 0.5);
}

.animate-fade-in {
  animation: slideInRight 0.3s ease-out forwards;
}

@keyframes slideInRight {
  from { transform: translateX(100%); opacity: 0; }
  to { transform: translateX(0); opacity: 1; }
}

/* Add these styles for the dropdown animation based on direction */
.animate-fade-in[class*="top-full"] {
  animation: fadeInDown 0.2s ease-in-out;
}

.animate-fade-in[class*="bottom-full"] {
  animation: fadeInUp 0.2s ease-in-out;
}

/* New animations for tab transitions */
[v-if="activeTab"] {
  animation: fadeIn 0.3s ease-out;
}

@keyframes fadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}

@keyframes fadeInDown {
  from { opacity: 0; transform: translateY(-10px); }
  to { opacity: 1; transform: translateY(0); }
}

@keyframes fadeInUp {
  from { opacity: 0; transform: translateY(10px); }
  to { opacity: 1; transform: translateY(0); }
}

@keyframes shrinkWidth {
  from { width: 100%; }
  to { width: 0%; }
}

.animate-shrink-width {
  animation: shrinkWidth 5s linear forwards;
}

/* Additional custom styles for rounded icons */
.ml-13 {
  margin-left: 3.25rem;
}

/* Card hover effects */
.card-hover {
  transition: transform 0.2s ease-in-out, box-shadow 0.2s ease-in-out;
}

.card-hover:hover {
  transform: translateY(-2px);
  box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
}

/* Custom tab transitions */
.tab-enter-active, .tab-leave-active {
  transition: opacity 0.3s, transform 0.3s;
}
.tab-enter, .tab-leave-to {
  opacity: 0;
  transform: translateX(20px);
}

/* Status badge enhancements */
.status-badge {
  transition: all 0.2s ease;
}
.status-badge:hover {
  transform: scale(1.05);
}
</style>