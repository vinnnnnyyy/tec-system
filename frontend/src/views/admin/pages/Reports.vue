<template>
  <div>
    <!-- Page Header -->
    <header class="bg-white shadow-sm sticky top-0 z-10">
      <div class="flex justify-between items-center px-8 py-5">
        <div class="flex items-center space-x-4">
          <h1 class="text-2xl font-bold text-gray-800">Reports & Statistics</h1>
          <span class="text-sm text-gray-500">View and analyze testing data</span>
        </div>
      </div>
    </header>

    <!-- Main Content -->
    <div class="p-8">
      <!-- Filter Section -->
      <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-6 mb-8">
        <div class="flex justify-between items-center mb-4">
          <h2 class="text-xl font-bold text-gray-800">Filters</h2>
          <button @click="resetFilters" class="text-crimson-600 hover:text-crimson-800 transition-colors duration-200">
            <i class="fas fa-redo mr-1"></i> Reset
          </button>
        </div>
        
        <div class="grid grid-cols-1 md:grid-cols-4 gap-6">
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">Date Range</label>
            <div class="flex space-x-2">
              <input 
                type="date" 
                v-model="filters.startDate"
                class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-crimson-500 focus:border-crimson-500"
              />
              <span class="flex items-center">to</span>
              <input 
                type="date" 
                v-model="filters.endDate"
                class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-crimson-500 focus:border-crimson-500"
              />
            </div>
          </div>
          
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">Program</label>
            <select 
              v-model="filters.program"
              class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-crimson-500 focus:border-crimson-500"
            >
              <option value="">All Programs</option>
              <option v-for="program in programs" :key="program.id" :value="program.id">
                {{ program.name }}
              </option>
            </select>
          </div>
          
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">Test Center</label>
            <select 
              v-model="filters.testCenter"
              class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-crimson-500 focus:border-crimson-500"
            >
              <option value="">All Test Centers</option>
              <option v-for="center in testCenters" :key="center.id" :value="center.id">
                {{ center.name }}
              </option>
            </select>
          </div>
          
          <div class="flex items-end">
            <button 
              @click="applyFilters"
              class="w-full px-4 py-2 bg-crimson-600 text-white rounded-lg hover:bg-crimson-700 transition-colors duration-200"
            >
              Apply Filters
            </button>
          </div>
        </div>
      </div>
      
      <!-- Statistics Cards -->
      <div class="grid grid-cols-1 md:grid-cols-4 gap-6 mb-8">
        <div class="bg-white p-6 rounded-2xl shadow-sm border border-gray-100 hover:shadow-md transition-all duration-300">
          <div class="flex items-center justify-between mb-4">
            <h3 class="text-gray-600 font-medium">Total Tests</h3>
            <div class="w-12 h-12 rounded-full bg-blue-50 flex items-center justify-center">
              <i class="fas fa-clipboard-check text-2xl text-blue-600"></i>
            </div>
          </div>
          <p class="text-4xl font-bold text-gray-800 mb-2">{{ statistics.totalTests || 0 }}</p>
          <p v-if="filters.startDate && filters.endDate" class="text-gray-600 text-sm flex items-center">
            <i class="fas fa-calendar-alt mr-1"></i>
            <span>{{ formatDateRange() }}</span>
          </p>
        </div>
        
        <div class="bg-white p-6 rounded-2xl shadow-sm border border-gray-100 hover:shadow-md transition-all duration-300">
          <div class="flex items-center justify-between mb-4">
            <h3 class="text-gray-600 font-medium">Pass Rate</h3>
            <div class="w-12 h-12 rounded-full bg-green-50 flex items-center justify-center">
              <i class="fas fa-check-circle text-2xl text-green-600"></i>
            </div>
          </div>
          <p class="text-4xl font-bold text-gray-800 mb-2">{{ statistics.passRate || 0 }}%</p>
          <div class="w-full bg-gray-200 rounded-full h-2 mb-2">
            <div class="bg-green-500 h-2 rounded-full" :style="{width: `${statistics.passRate || 0}%`}"></div>
          </div>
          <p class="text-green-600 text-sm flex items-center">
            <i class="fas fa-users mr-1"></i>
            <span>{{ statistics.approved_appointments || 0 }} approved / {{ statistics.total_exam_results || 0 }} results</span>
          </p>
        </div>
        
        <div class="bg-white p-6 rounded-2xl shadow-sm border border-gray-100 hover:shadow-md transition-all duration-300">
          <div class="flex items-center justify-between mb-4">
            <h3 class="text-gray-600 font-medium">Average Score</h3>
            <div class="w-12 h-12 rounded-full bg-indigo-50 flex items-center justify-center">
              <i class="fas fa-chart-line text-2xl text-indigo-600"></i>
            </div>
          </div>
          <p class="text-4xl font-bold text-gray-800 mb-2">{{ statistics.averageScore || 0 }}</p>
          <p class="text-indigo-600 text-sm flex items-center">
            <i class="fas fa-calculator mr-1"></i>
            <span>Out of 100</span>
          </p>
        </div>
        
        <div class="bg-white p-6 rounded-2xl shadow-sm border border-gray-100 hover:shadow-md transition-all duration-300">
          <div class="flex items-center justify-between mb-4">
            <h3 class="text-gray-600 font-medium">Top Program</h3>
            <div class="w-12 h-12 rounded-full bg-purple-50 flex items-center justify-center">
              <i class="fas fa-trophy text-2xl text-purple-600"></i>
            </div>
          </div>
          <p class="text-xl font-bold text-gray-800 mb-2 truncate">{{ statistics.topProgram || 'N/A' }}</p>
          <p class="text-purple-600 text-sm flex items-center">
            <i class="fas fa-users mr-1"></i>
            <span>Highest pass rate</span>
          </p>
        </div>
      </div>
      
      <!-- Charts Section -->
      <div class="grid grid-cols-1 lg:grid-cols-2 gap-8 mb-8">
        <!-- Monthly Tests Chart -->
        <div class="bg-white p-6 rounded-2xl shadow-sm border border-gray-100">
          <h3 class="text-lg font-bold text-gray-800 mb-4">Monthly Tests</h3>
          <div class="h-64 flex items-center justify-center" v-if="loading">
            <i class="fas fa-circle-notch fa-spin text-2xl text-crimson-600"></i>
          </div>
          <div v-else-if="!monthlyData || monthlyData.length === 0" class="h-64 flex items-center justify-center text-gray-500">
            <div class="text-center">
              <i class="fas fa-chart-bar text-4xl text-gray-300 mb-3"></i>
              <p>No monthly data available</p>
            </div>
          </div>
          <MonthlyTestsChart 
            v-else 
            :key="`monthly-${chartKey}-${monthlyData.length}`"
            :data="monthlyData" 
            canvas-id="monthly-tests-chart"
          />
        </div>
        
        <!-- Pass Rate by Program Chart -->
        <div class="bg-white p-6 rounded-2xl shadow-sm border border-gray-100">
          <h3 class="text-lg font-bold text-gray-800 mb-4">Pass Rate by Program</h3>
          <div class="h-64 flex items-center justify-center" v-if="loading">
            <i class="fas fa-circle-notch fa-spin text-2xl text-crimson-600"></i>
          </div>
          <div v-else-if="!programStats || programStats.length === 0" class="h-64 flex items-center justify-center text-gray-500">
            <div class="text-center">
              <i class="fas fa-chart-line text-4xl text-gray-300 mb-3"></i>
              <p>No program data available</p>
            </div>
          </div>
          <PassRateByProgramChart 
            v-else 
            :key="`program-${chartKey}-${programStats.length}`"
            :data="programStats" 
            canvas-id="pass-rate-program-chart"
          />
        </div>
      </div>
      
      <!-- Top 10 Performers Section -->
      <div class="bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden mb-8">
        <div class="p-6 border-b border-gray-100">
          <div class="flex items-center justify-between mb-4">
            <div>
              <h2 class="text-xl font-bold text-gray-800">🏆 Top 10 Performers</h2>
              <p class="text-sm text-gray-500 mt-1">Highest OAPR scores</p>
            </div>
            <div class="text-right">
              <span class="text-2xl font-bold text-yellow-600">{{ filteredTopPerformers.length }}</span>
              <p class="text-xs text-gray-500">Students</p>
            </div>
          </div>
          
          <!-- Top Performers Filters -->
          <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Filter by Program</label>
              <select 
                v-model="topPerformersFilters.program"
                @change="filterTopPerformers"
                class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-crimson-500 focus:border-crimson-500 text-sm"
              >
                <option value="">All Programs</option>
                <option v-for="program in uniquePrograms" :key="program" :value="program">
                  {{ program }}
                </option>
              </select>
            </div>
            
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Filter by Year</label>
              <select 
                v-model="topPerformersFilters.year"
                @change="filterTopPerformers"
                class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-crimson-500 focus:border-crimson-500 text-sm"
              >
                <option value="">All Years</option>
                <option v-for="year in uniqueYears" :key="year" :value="year">
                  {{ year }}
                </option>
              </select>
            </div>
            
            <div class="flex items-end space-x-2">
              <button 
                @click="resetTopPerformersFilters"
                class="flex-1 px-3 py-2 bg-gray-100 text-gray-700 rounded-md hover:bg-gray-200 transition-colors duration-200 text-sm"
              >
                <i class="fas fa-redo mr-1"></i>
                Reset
              </button>
              <button 
                @click="exportTopPerformersToPDF"
                :disabled="exportingPDF"
                class="flex-1 px-3 py-2 bg-crimson-600 text-white rounded-md hover:bg-crimson-700 transition-colors duration-200 text-sm disabled:opacity-50 disabled:cursor-not-allowed"
              >
                <i :class="exportingPDF ? 'fas fa-spinner fa-spin' : 'fas fa-download'" class="mr-1"></i>
                {{ exportingPDF ? 'Exporting...' : 'Export PDF' }}
              </button>
            </div>
          </div>
        </div>
        
        <!-- Loading state -->
        <div v-if="loading" class="flex justify-center items-center py-10">
          <i class="fas fa-circle-notch fa-spin text-4xl text-crimson-600"></i>
        </div>
        
        <!-- Top Performers Table -->
        <div v-else class="overflow-x-auto">
          <table class="w-full text-sm">
            <thead class="bg-gray-50">
              <tr>
                <th class="px-4 py-3 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">Rank</th>
                <th class="px-4 py-3 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">Student Name</th>
                <th class="px-4 py-3 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">School</th>
                <th class="px-4 py-3 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">Program</th>
                <th class="px-4 py-3 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">OAPR Score</th>
                <th class="px-4 py-3 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">Exam Date</th>
              </tr>
            </thead>
            <tbody class="divide-y divide-gray-100">
              <tr 
                v-for="performer in filteredTopPerformers.slice(0, 10)" 
                :key="performer.rank"
                class="hover:bg-gray-50 transition-colors duration-200"
                :class="{
                  'bg-yellow-50': performer.rank === 1,
                  'bg-gray-100': performer.rank === 2,
                  'bg-orange-50': performer.rank === 3
                }"
              >
                <td class="px-4 py-3">
                  <div class="flex items-center">
                    <div 
                      class="w-8 h-8 rounded-full flex items-center justify-center text-sm font-bold mr-2"
                      :class="{
                        'bg-yellow-500 text-white': performer.rank === 1,
                        'bg-gray-400 text-white': performer.rank === 2,
                        'bg-amber-600 text-white': performer.rank === 3,
                        'bg-blue-500 text-white': performer.rank > 3
                      }"
                    >
                      {{ performer.rank }}
                    </div>
                    <i 
                      v-if="performer.rank <= 3"
                      class="text-lg"
                      :class="{
                        'fas fa-trophy text-yellow-500': performer.rank === 1,
                        'fas fa-medal text-gray-400': performer.rank === 2,
                        'fas fa-award text-amber-600': performer.rank === 3
                      }"
                    ></i>
                  </div>
                </td>
                <td class="px-4 py-3">
                  <p class="font-medium text-gray-900">{{ performer.name }}</p>
                </td>
                <td class="px-4 py-3 text-gray-600">{{ performer.school }}</td>
                <td class="px-4 py-3 text-gray-900">{{ performer.program }}</td>
                <td class="px-4 py-3">
                  <span class="text-lg font-bold text-gray-800">{{ performer.oapr }}</span>
                </td>
                <td class="px-4 py-3 text-gray-500">{{ formatDate(performer.exam_date) }}</td>
              </tr>
              
              <tr v-if="filteredTopPerformers.length === 0">
                <td colspan="6" class="px-4 py-8 text-center text-gray-500">
                  No top performers data available for the selected filters.
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
      
      <!-- Detailed Data Table -->
      <div class="bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden">
        <div class="p-6 border-b border-gray-100">
          <div class="flex items-center justify-between mb-4">
            <div>
              <h2 class="text-xl font-bold text-gray-800">Test Results</h2>
              <p class="text-sm text-gray-500 mt-1">Detailed test results data</p>
            </div>
            <div class="text-right">
              <span class="text-2xl font-bold text-blue-600">{{ filteredTestResults.length }}</span>
              <p class="text-xs text-gray-500">Results</p>
            </div>
          </div>
          
          <!-- Test Results Filters -->
          <div class="grid grid-cols-1 md:grid-cols-4 gap-4">
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Filter by Program</label>
              <select 
                v-model="testResultsFilters.program"
                class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-crimson-500 focus:border-crimson-500 text-sm"
              >
                <option value="">All Programs</option>
                <option v-for="program in uniqueTestPrograms" :key="program" :value="program">
                  {{ program }}
                </option>
              </select>
            </div>
            
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Filter by Year</label>
              <select 
                v-model="testResultsFilters.year"
                class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-crimson-500 focus:border-crimson-500 text-sm"
              >
                <option value="">All Years</option>
                <option v-for="year in uniqueTestYears" :key="year" :value="year">
                  {{ year }}
                </option>
              </select>
            </div>
            
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Filter by Status</label>
              <select 
                v-model="testResultsFilters.status"
                class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-crimson-500 focus:border-crimson-500 text-sm"
              >
                <option value="">All Status</option>
                <option v-for="status in uniqueTestStatuses" :key="status" :value="status">
                  {{ status }}
                </option>
              </select>
            </div>
            
            <div class="flex items-end space-x-2">
              <button 
                @click="resetTestResultsFilters"
                class="flex-1 px-3 py-2 bg-gray-100 text-gray-700 rounded-md hover:bg-gray-200 transition-colors duration-200 text-sm"
              >
                <i class="fas fa-redo mr-1"></i>
                Reset
              </button>
              <button 
                @click="exportTestResultsToPDF"
                :disabled="exportingTestResultsPDF"
                class="flex-1 px-3 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700 transition-colors duration-200 text-sm disabled:opacity-50 disabled:cursor-not-allowed"
              >
                <i :class="exportingTestResultsPDF ? 'fas fa-spinner fa-spin' : 'fas fa-download'" class="mr-1"></i>
                {{ exportingTestResultsPDF ? 'Exporting...' : 'Export PDF' }}
              </button>
            </div>
          </div>
        </div>
        
        <!-- Loading state -->
        <div v-if="loading" class="flex justify-center items-center py-10">
          <i class="fas fa-circle-notch fa-spin text-4xl text-crimson-600"></i>
        </div>
        
        <!-- Data table -->
        <div v-else class="overflow-x-auto">
          <table class="w-full text-sm">
            <thead class="bg-gray-50">
              <tr>
                <th class="px-4 py-3 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">Student</th>
                <th class="px-4 py-3 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">School</th>
                <th class="px-4 py-3 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">Program</th>
                <th class="px-4 py-3 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">Test Date</th>
                <th class="px-4 py-3 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">Score</th>
                <th class="px-4 py-3 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">Status</th>
                <th class="px-4 py-3 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">Test Center</th>
              </tr>
            </thead>
            <tbody class="divide-y divide-gray-100">
              <tr v-for="result in filteredTestResults" :key="result.id" class="hover:bg-gray-50 transition-colors duration-200">
                <td class="px-4 py-3">
                  <div class="flex items-center">
                    <div class="w-8 h-8 rounded-full bg-gray-200 flex items-center justify-center text-gray-600">
                      <i class="fas fa-user"></i>
                    </div>
                    <div class="ml-3">
                      <p class="text-sm font-medium text-gray-900">{{ result.student_name }}</p>
                    </div>
                  </div>
                </td>
                <td class="px-4 py-3 text-sm text-gray-900">{{ result.school || 'N/A' }}</td>
                <td class="px-4 py-3 text-sm text-gray-900">{{ result.program }}</td>
                <td class="px-4 py-3 text-sm text-gray-500">{{ formatDate(result.test_date) }}</td>
                <td class="px-4 py-3 font-medium">{{ result.score }}</td>
                <td class="px-4 py-3">
                  <span :class="getStatusClass(result.status === 'Approved')" class="px-2 py-1 text-xs font-medium rounded-full">
                    {{ result.status }}
                  </span>
                </td>
                <td class="px-4 py-3 text-sm text-gray-900">{{ result.test_center }}</td>
              </tr>
              
              <tr v-if="filteredTestResults.length === 0">
                <td colspan="7" class="px-4 py-8 text-center text-gray-500">
                  No test results found for the selected filters.
                </td>
              </tr>
            </tbody>
          </table>
        </div>
        
        <!-- Pagination -->
        <div class="px-4 py-3 border-t border-gray-200 flex items-center justify-between">
          <div>
            <p class="text-sm text-gray-700">
              Showing <span class="font-medium">{{ ((page - 1) * itemsPerPage) + 1 }}</span> to <span class="font-medium">{{ Math.min(page * itemsPerPage, totalResults) }}</span> of <span class="font-medium">{{ totalResults }}</span> results
            </p>
          </div>
          <div class="flex space-x-2">
            <button 
              @click="changePage(page - 1)"
              class="px-3 py-1 border border-gray-300 rounded-md text-sm bg-white hover:bg-gray-50 disabled:opacity-50" 
              :disabled="page === 1"
            >
              Previous
            </button>
            <button 
              @click="changePage(page + 1)"
              class="px-3 py-1 border border-gray-300 rounded-md text-sm bg-white hover:bg-gray-50 disabled:opacity-50" 
              :disabled="page === totalPages"
            >
              Next
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { ref, reactive, onMounted, computed, nextTick, watch } from 'vue'
import { useRoute } from 'vue-router'
import axiosInstance from '../../../services/axios.interceptor'
import MonthlyTestsChart from '../../../components/charts/MonthlyTestsChart.vue'
import PassRateByProgramChart from '../../../components/charts/PassRateByProgramChart.vue'
import html2pdf from 'html2pdf.js'

export default {
  name: 'Reports',
  components: {
    MonthlyTestsChart,
    PassRateByProgramChart
  },
  setup() {
    const route = useRoute()
    const loading = ref(true)
    const page = ref(1)
    const itemsPerPage = ref(10)
    const totalResults = ref(0)
    const totalPages = ref(1)
    
    const filters = reactive({
      startDate: '',
      endDate: '',
      program: '',
      testCenter: ''
    })
    
    const topPerformersFilters = reactive({
      program: '',
      year: ''
    })
    
    const testResultsFilters = reactive({
      program: '',
      year: '',
      status: ''
    })
    
    const statistics = reactive({
      totalTests: 0,
      passRate: 0,
      averageScore: 0,
      topProgram: ''
    })
    
    const programs = ref([])
    const testCenters = ref([])
    const testResults = ref([])
    const topPerformers = ref([])
    const showAllPerformers = ref(false)
    const exportingPDF = ref(false)
    const exportingTestResultsPDF = ref(false)
    const chartKey = ref(0) // Add reactive key for forcing chart re-render
    
    // Chart data
    const monthlyData = ref([])
    const programStats = ref([])
    
    // Computed properties for top performers filtering
    const uniquePrograms = computed(() => {
      const programs = [...new Set(topPerformers.value.map(p => p.program))]
      return programs.sort()
    })
    
    const uniqueYears = computed(() => {
      const years = [...new Set(topPerformers.value.map(p => {
        if (p.exam_date) {
          return new Date(p.exam_date).getFullYear().toString()
        }
        return null
      }).filter(Boolean))]
      return years.sort().reverse() // Most recent years first
    })
    
    const filteredTopPerformers = computed(() => {
      let filtered = [...topPerformers.value]
      
      if (topPerformersFilters.program) {
        filtered = filtered.filter(p => p.program === topPerformersFilters.program)
      }
      
      if (topPerformersFilters.year) {
        filtered = filtered.filter(p => {
          if (p.exam_date) {
            const year = new Date(p.exam_date).getFullYear().toString()
            return year === topPerformersFilters.year
          }
          return false
        })
      }
      
      // Re-rank the filtered results
      return filtered.map((performer, index) => ({
        ...performer,
        rank: index + 1
      }))
    })
    
    // Computed properties for test results filtering
    const uniqueTestPrograms = computed(() => {
      const programs = [...new Set(testResults.value.map(result => result.program))]
      return programs.sort()
    })
    
    const uniqueTestYears = computed(() => {
      const years = [...new Set(testResults.value.map(result => {
        if (result.exam_date) {
          return new Date(result.exam_date).getFullYear().toString()
        }
        return null
      }).filter(Boolean))]
      return years.sort().reverse() // Most recent years first
    })
    
    const uniqueTestStatuses = computed(() => {
      const statuses = [...new Set(testResults.value.map(result => result.status).filter(Boolean))]
      return statuses.sort()
    })
    
    const filteredTestResults = computed(() => {
      let filtered = [...testResults.value]
      
      if (testResultsFilters.program) {
        filtered = filtered.filter(result => result.program === testResultsFilters.program)
      }
      
      if (testResultsFilters.year) {
        filtered = filtered.filter(result => {
          if (result.exam_date) {
            const year = new Date(result.exam_date).getFullYear().toString()
            return year === testResultsFilters.year
          }
          return false
        })
      }
      
      if (testResultsFilters.status) {
        filtered = filtered.filter(result => result.status === testResultsFilters.status)
      }
      
      return filtered
    })
    
    // Fetch initial data
    onMounted(async () => {
      // Ensure component is fully mounted
      await nextTick()
      
      console.log('Reports component mounted, starting data fetch...')
      await fetchPrograms()
      await fetchTestCenters()
      await fetchTestResults()
    })
    
    // Watch for route changes to refresh data when navigating to this page
    watch(() => route.path, async (newPath) => {
      if (newPath === '/admin/reports') {
        console.log('Navigated to reports page, refreshing data...')
        // Only refresh data if we're not already loading
        if (!loading.value) {
          await fetchTestResults()
        }
      }
    })
    
    const fetchPrograms = async () => {
      try {
        const response = await axiosInstance.get('/api/programs/')
        programs.value = response.data
      } catch (error) {
        console.error('Error fetching programs:', error)
        // Set a sample data for demo purposes
        programs.value = [
          { id: 1, name: 'College Entrance Test' },
          { id: 2, name: 'Medical School Admission Test' },
          { id: 3, name: 'Law School Admission Test' }
        ]
      }
    }
    
    const fetchTestCenters = async () => {
      try {
        const response = await axiosInstance.get('/api/test-centers/')
        testCenters.value = response.data
      } catch (error) {
        console.error('Error fetching test centers:', error)
        // Set sample data for demo purposes
        testCenters.value = [
          { id: 1, name: 'Main Campus Center' },
          { id: 2, name: 'West Wing Testing Facility' },
          { id: 3, name: 'Downtown Center' }
        ]
      }
    }
    
    const fetchTestResults = async () => {
      loading.value = true
      
      try {
        // Construct params
        const params = {
          page: page.value,
          page_size: itemsPerPage.value
        }
        
        if (filters.startDate) params.start_date = filters.startDate
        if (filters.endDate) params.end_date = filters.endDate
        if (filters.program) params.program = filters.program
        if (filters.testCenter) params.test_center = filters.testCenter
        
        // Call the new reports API endpoint
        const response = await axiosInstance.get('/api/admin/reports/statistics/', { params })
        
        if (response.data) {
          console.log('Reports API response:', response.data)
          
          // Update statistics - map backend field names to frontend field names
          const backendStats = response.data.statistics
          statistics.totalTests = backendStats.total_tests || 0
          statistics.passRate = backendStats.pass_rate || 0
          statistics.averageScore = backendStats.average_score || 0
          statistics.topProgram = backendStats.top_program || 'N/A'
          statistics.approved_appointments = backendStats.approved_appointments || 0
          statistics.total_exam_results = backendStats.total_exam_results || 0
          
          // Update test results tables
          testResults.value = response.data.detailed_results || []
          
          // Update chart data
          monthlyData.value = response.data.monthly_data || []
          programStats.value = response.data.program_stats || []
          
          // Update top performers data
          topPerformers.value = response.data.top_performers || []
          
          console.log('Monthly data:', monthlyData.value)
          console.log('Program stats:', programStats.value)
          console.log('Statistics:', statistics)
          
          // Update pagination
          if (response.data.pagination) {
            totalResults.value = response.data.pagination.total_results
            totalPages.value = response.data.pagination.total_pages
          }
        }
        
        loading.value = false
        chartKey.value++ // Force chart re-render
        console.log('Data loaded successfully, chartKey:', chartKey.value)
        
      } catch (error) {
        console.error('Error fetching test results:', error)
        
        // Fallback to demo data if API fails
        console.log('API failed, loading demo data...')
        setTimeout(() => {
          // Mock statistics data
          statistics.totalTests = 2458
          statistics.passRate = 72
          statistics.averageScore = 84.5
          statistics.topProgram = 'College Entrance Test'
          
          // Mock chart data
          monthlyData.value = [
            { month: '2025-01', count: 120 },
            { month: '2025-02', count: 85 },
            { month: '2025-03', count: 150 },
            { month: '2025-04', count: 95 },
            { month: '2025-05', count: 180 },
            { month: '2025-06', count: 200 }
          ]
          
          programStats.value = [
            { program: 'College Entrance Test', total: 800, approved: 640, pass_rate: 80 },
            { program: 'Medical School Test', total: 450, approved: 315, pass_rate: 70 },
            { program: 'Law School Test', total: 200, approved: 140, pass_rate: 70 },
            { program: 'Engineering Test', total: 300, approved: 270, pass_rate: 90 }
          ]
          
          // Mock top performers data
          topPerformers.value = [
            { rank: 1, name: 'JOHN RUEL GARCIA', oapr: 99, school: 'PILAR NHS', program: 'CET', exam_date: '2025-06-25', exam_type: 'CET' },
            { rank: 2, name: 'JUAN ANG DELA CRUZ', oapr: 85, school: 'ZNHS', program: 'CET', exam_date: '2025-06-25', exam_type: 'CET' },
            { rank: 3, name: 'CHRISTIAN JUDE FAMINIANO', oapr: 75, school: 'ZAMBOANGA CHONG HUA HIGH SCHOOL', program: 'CET', exam_date: '2025-07-25', exam_type: 'CET' },
            { rank: 4, name: 'MARIA LOCSON SANTOS', oapr: 73, school: 'ST. JOSEPH HIGH SCHOOL', program: 'CET', exam_date: '2025-06-25', exam_type: 'CET' },
            { rank: 5, name: 'CHRISTIAN JUDE JUDE FAMINIANO', oapr: 64, school: 'ZAMBOANGA CHONG HUA HIGH SCHOOL', program: 'CET', exam_date: '2025-07-24', exam_type: 'CET' }
          ]
          
          // Mock test results
          testResults.value = [
            {
              id: 1,
              student_name: 'John Doe',
              program: 'College Entrance Test',
              test_date: '2025-06-15',
              score: '92',
              status: 'Approved',
              test_center: 'Main Campus Center'
            },
            {
              id: 2,
              student_name: 'Jane Smith',
              program: 'Medical School Admission Test',
              test_date: '2025-06-18',
              score: '85',
              status: 'Approved',
              test_center: 'West Wing Testing Facility'
            },
            {
              id: 3,
              student_name: 'Robert Johnson',
              program: 'Law School Admission Test',
              test_date: '2025-06-20',
              score: '78',
              status: 'Approved',
              test_center: 'Downtown Center'
            },
            {
              id: 4,
              student_name: 'Maria Garcia',
              program: 'College Entrance Test',
              test_date: '2025-06-22',
              score: '65',
              status: 'Rejected',
              test_center: 'Main Campus Center'
            },
            {
              id: 5,
              student_name: 'David Wilson',
              program: 'Medical School Admission Test',
              test_date: '2025-06-25',
              score: '94',
              status: 'Approved',
              test_center: 'West Wing Testing Facility'
            }
          ]
          
          totalResults.value = 145
          totalPages.value = 29
          loading.value = false
          chartKey.value++ // Force chart re-render
          
          console.log('Demo data loaded successfully, chartKey:', chartKey.value)
          console.log('Monthly data after demo load:', monthlyData.value)
          console.log('Program stats after demo load:', programStats.value)
        }, 300) // Reduced timeout
      }
    }
    
    const applyFilters = () => {
      page.value = 1
      fetchTestResults()
    }
    
    const resetFilters = () => {
      filters.startDate = ''
      filters.endDate = ''
      filters.program = ''
      filters.testCenter = ''
      
      page.value = 1
      fetchTestResults()
    }
    
    const formatDate = (date) => {
      return new Date(date).toLocaleDateString('en-US', {
        year: 'numeric',
        month: 'short',
        day: 'numeric'
      })
    }
    
    const formatDateRange = () => {
      if (!filters.startDate || !filters.endDate) return ''
      
      const start = new Date(filters.startDate).toLocaleDateString('en-US', {
        month: 'short',
        day: 'numeric'
      })
      
      const end = new Date(filters.endDate).toLocaleDateString('en-US', {
        month: 'short',
        day: 'numeric',
        year: 'numeric'
      })
      
      return `${start} - ${end}`
    }
    
    const getStatusClass = (passed) => {
      return passed 
        ? 'bg-green-100 text-green-800' 
        : 'bg-red-100 text-red-800'
    }
    
    const changePage = (newPage) => {
      if (newPage >= 1 && newPage <= totalPages.value) {
        page.value = newPage
        fetchTestResults()
      }
    }
    
    const generateReport = () => {
      alert('Report generation feature would be implemented here.')
      // In a real implementation, this would trigger an API call to generate a PDF or Excel report
    }
    
    const filterTopPerformers = () => {
      // The filtering is handled by the computed property, this method can be used for additional logic if needed
      console.log('Top performers filtered:', topPerformersFilters)
    }
    
    const resetTopPerformersFilters = () => {
      topPerformersFilters.program = ''
      topPerformersFilters.year = ''
    }
    
    const resetTestResultsFilters = () => {
      testResultsFilters.program = ''
      testResultsFilters.year = ''
      testResultsFilters.status = ''
    }
    
    const filterTestResults = () => {
      // This method can be used for manual filtering if needed
      // The computed property filteredTestResults already handles the filtering
      console.log('Filtering test results with:', testResultsFilters)
    }
    
    const exportTopPerformersToPDF = async () => {
      if (exportingPDF.value) return
      
      try {
        exportingPDF.value = true
        
        // Create a temporary element with the filtered data
        const element = document.createElement('div')
        element.style.padding = '20px'
        element.style.fontFamily = 'Arial, sans-serif'
        
        // Add title and filters info
        let filtersText = 'All Programs, All Years'
        if (topPerformersFilters.program || topPerformersFilters.year) {
          const programText = topPerformersFilters.program || 'All Programs'
          const yearText = topPerformersFilters.year || 'All Years'
          filtersText = `${programText}, ${yearText}`
        }
        
        element.innerHTML = `
          <div style="text-align: center; margin-bottom: 30px;">
            <h1 style="color: #1f2937; font-size: 24px; font-weight: bold; margin-bottom: 10px;">
              Top 10 Performers Report
            </h1>
            <p style="color: #6b7280; font-size: 14px;">
              Filters Applied: ${filtersText}
            </p>
            <p style="color: #6b7280; font-size: 12px;">
              Generated on: ${new Date().toLocaleDateString()} at ${new Date().toLocaleTimeString()}
            </p>
          </div>
          
          <table style="width: 100%; border-collapse: collapse; margin-top: 20px;">
            <thead>
              <tr style="background-color: #f9fafb;">
                <th style="border: 1px solid #e5e7eb; padding: 12px; text-align: left; font-weight: bold; color: #374151;">Rank</th>
                <th style="border: 1px solid #e5e7eb; padding: 12px; text-align: left; font-weight: bold; color: #374151;">Student Name</th>
                <th style="border: 1px solid #e5e7eb; padding: 12px; text-align: left; font-weight: bold; color: #374151;">School</th>
                <th style="border: 1px solid #e5e7eb; padding: 12px; text-align: left; font-weight: bold; color: #374151;">Program</th>
                <th style="border: 1px solid #e5e7eb; padding: 12px; text-align: left; font-weight: bold; color: #374151;">OAPR Score</th>
                <th style="border: 1px solid #e5e7eb; padding: 12px; text-align: left; font-weight: bold; color: #374151;">Exam Date</th>
              </tr>
            </thead>
            <tbody>
              ${filteredTopPerformers.value.slice(0, 10).map(performer => `
                <tr style="${performer.rank <= 3 ? 'background-color: #fef3c7;' : ''}">
                  <td style="border: 1px solid #e5e7eb; padding: 12px; text-align: center; font-weight: bold;">${performer.rank}</td>
                  <td style="border: 1px solid #e5e7eb; padding: 12px;">${performer.name}</td>
                  <td style="border: 1px solid #e5e7eb; padding: 12px;">${performer.school}</td>
                  <td style="border: 1px solid #e5e7eb; padding: 12px;">${performer.program}</td>
                  <td style="border: 1px solid #e5e7eb; padding: 12px; text-align: center; font-weight: bold;">${performer.oapr}</td>
                  <td style="border: 1px solid #e5e7eb; padding: 12px;">${formatDate(performer.exam_date)}</td>
                </tr>
              `).join('')}
            </tbody>
          </table>
          
          ${filteredTopPerformers.value.length === 0 ? `
            <div style="text-align: center; padding: 40px; color: #6b7280;">
              No top performers data available for the selected filters.
            </div>
          ` : ''}
        `
        
        // PDF options
        const options = {
          margin: 1,
          filename: `top-performers-${topPerformersFilters.program || 'all-programs'}-${topPerformersFilters.year || 'all-years'}-${new Date().toISOString().split('T')[0]}.pdf`,
          image: { type: 'jpeg', quality: 0.98 },
          html2canvas: { 
            scale: 2, 
            useCORS: true,
            allowTaint: false,
            backgroundColor: '#ffffff'
          },
          jsPDF: { unit: 'in', format: 'letter', orientation: 'landscape' }
        }
        
        // Generate and download PDF
        await html2pdf().set(options).from(element).save()
        
      } catch (error) {
        console.error('Error generating PDF:', error)
        // You could add a toast notification here
      } finally {
        exportingPDF.value = false
      }
    }
    
    const exportTestResultsToPDF = async () => {
      if (exportingTestResultsPDF.value) return
      
      try {
        exportingTestResultsPDF.value = true
        
        // Create a temporary element with the filtered data
        const element = document.createElement('div')
        element.style.padding = '20px'
        element.style.fontFamily = 'Arial, sans-serif'
        
        // Add title and filters info
        let filtersText = 'All Programs, All Years, All Status'
        if (testResultsFilters.program || testResultsFilters.year || testResultsFilters.status) {
          const programText = testResultsFilters.program || 'All Programs'
          const yearText = testResultsFilters.year || 'All Years'
          const statusText = testResultsFilters.status || 'All Status'
          filtersText = `${programText}, ${yearText}, ${statusText}`
        }
        
        element.innerHTML = `
          <div style="text-align: center; margin-bottom: 30px;">
            <h1 style="color: #1f2937; font-size: 24px; font-weight: bold; margin-bottom: 10px;">
              Test Results Report
            </h1>
            <p style="color: #6b7280; font-size: 14px;">
              Filters Applied: ${filtersText}
            </p>
            <p style="color: #6b7280; font-size: 12px;">
              Generated on: ${new Date().toLocaleDateString()} at ${new Date().toLocaleTimeString()}
            </p>
          </div>
          
          <table style="width: 100%; border-collapse: collapse; margin-top: 20px;">
            <thead>
              <tr style="background-color: #f9fafb;">
                <th style="border: 1px solid #e5e7eb; padding: 12px; text-align: left; font-weight: bold; color: #374151;">Student Name</th>
                <th style="border: 1px solid #e5e7eb; padding: 12px; text-align: left; font-weight: bold; color: #374151;">School</th>
                <th style="border: 1px solid #e5e7eb; padding: 12px; text-align: left; font-weight: bold; color: #374151;">Program</th>
                <th style="border: 1px solid #e5e7eb; padding: 12px; text-align: left; font-weight: bold; color: #374151;">Score</th>
                <th style="border: 1px solid #e5e7eb; padding: 12px; text-align: left; font-weight: bold; color: #374151;">Status</th>
                <th style="border: 1px solid #e5e7eb; padding: 12px; text-align: left; font-weight: bold; color: #374151;">Exam Date</th>
              </tr>
            </thead>
            <tbody>
              ${filteredTestResults.value.map(result => `
                <tr>
                  <td style="border: 1px solid #e5e7eb; padding: 12px;">${result.student_name || 'N/A'}</td>
                  <td style="border: 1px solid #e5e7eb; padding: 12px;">${result.school || 'N/A'}</td>
                  <td style="border: 1px solid #e5e7eb; padding: 12px;">${result.program || 'N/A'}</td>
                  <td style="border: 1px solid #e5e7eb; padding: 12px; text-align: center; font-weight: bold;">${result.score || 'N/A'}</td>
                  <td style="border: 1px solid #e5e7eb; padding: 12px;">
                    <span style="
                      padding: 4px 8px; 
                      border-radius: 9999px; 
                      font-size: 12px; 
                      font-weight: 500;
                      ${result.status === 'PASSED' ? 'background-color: #d1fae5; color: #065f46;' : 'background-color: #fee2e2; color: #991b1b;'}
                    ">
                      ${result.status}
                    </span>
                  </td>
                  <td style="border: 1px solid #e5e7eb; padding: 12px;">${formatDate(result.exam_date)}</td>
                </tr>
              `).join('')}
            </tbody>
          </table>
          
          ${filteredTestResults.value.length === 0 ? `
            <div style="text-align: center; padding: 40px; color: #6b7280;">
              No test results data available for the selected filters.
            </div>
          ` : ''}
          
          <div style="margin-top: 30px; padding-top: 20px; border-top: 1px solid #e5e7eb; font-size: 12px; color: #6b7280;">
            <p>Total Results: ${filteredTestResults.value.length}</p>
            <p>Passed/Approved: ${filteredTestResults.value.filter(r => r.status === 'PASSED' || r.status === 'Approved').length}</p>
            <p>Failed/Rejected: ${filteredTestResults.value.filter(r => r.status === 'FAILED' || r.status === 'Rejected').length}</p>
          </div>
        `
        
        // PDF options
        const options = {
          margin: 1,
          filename: `test-results-${testResultsFilters.program || 'all-programs'}-${testResultsFilters.year || 'all-years'}-${testResultsFilters.status || 'all-status'}-${new Date().toISOString().split('T')[0]}.pdf`,
          image: { type: 'jpeg', quality: 0.98 },
          html2canvas: { 
            scale: 2, 
            useCORS: true,
            allowTaint: false,
            backgroundColor: '#ffffff'
          },
          jsPDF: { unit: 'in', format: 'letter', orientation: 'landscape' }
        }
        
        // Generate and download PDF
        await html2pdf().set(options).from(element).save()
        
      } catch (error) {
        console.error('Error generating PDF:', error)
        // You could add a toast notification here
      } finally {
        exportingTestResultsPDF.value = false
      }
    }
    
    return {
      loading,
      page,
      itemsPerPage,
      totalResults,
      totalPages,
      filters,
      topPerformersFilters,
      statistics,
      programs,
      testCenters,
      testResults,
      topPerformers,
      filteredTopPerformers,
      uniquePrograms,
      uniqueYears,
      showAllPerformers,
      monthlyData,
      programStats,
      chartKey,
      applyFilters,
      resetFilters,
      filterTopPerformers,
      resetTopPerformersFilters,
      // Test results filtering
      testResultsFilters,
      uniqueTestPrograms,
      uniqueTestYears,
      uniqueTestStatuses,
      filteredTestResults,
      resetTestResultsFilters,
      filterTestResults,
      exportTopPerformersToPDF,
      exportTestResultsToPDF,
      exportingPDF,
      exportingTestResultsPDF,
      formatDate,
      formatDateRange,
      getStatusClass,
      changePage,
      generateReport
    }
  }
}
</script>

<style scoped>
.bg-crimson-600 {
  background-color: #DC2626;
}

.hover\:bg-crimson-700:hover {
  background-color: #B91C1C;
}

.text-crimson-600 {
  color: #DC2626;
}

.hover\:text-crimson-800:hover {
  color: #991B1B;
}

.focus\:ring-crimson-500:focus {
  --tw-ring-color: rgba(239, 68, 68, 0.5);
}

.focus\:border-crimson-500:focus {
  border-color: #EF4444;
}
</style>
