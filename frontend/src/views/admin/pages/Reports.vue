<template>
  <div>
    <!-- Page Header -->
    <header class="bg-white shadow-sm sticky top-0 z-10">
      <div class="flex justify-between items-center px-8 py-5">
        <div class="flex items-center space-x-4">
          <h1 class="text-2xl font-bold text-gray-800">Reports & Statistics</h1>
          <span class="text-sm text-gray-500">View and analyze testing data</span>
        </div>
        <div class="flex items-center space-x-3">
          <button @click="generateReport" class="px-4 py-2 bg-crimson-600 text-white rounded-lg hover:bg-crimson-700 transition-colors duration-200">
            <i class="fas fa-download mr-2"></i>
            Export Report
          </button>
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
          <MonthlyTestsChart 
            v-else 
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
          <PassRateByProgramChart 
            v-else 
            :data="programStats" 
            canvas-id="pass-rate-program-chart"
          />
        </div>
      </div>
      
      <!-- Top 10 Performers Section -->
      <div class="bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden mb-8">
        <div class="p-6 border-b border-gray-100">
          <div class="flex items-center justify-between">
            <div>
              <h2 class="text-xl font-bold text-gray-800">🏆 Top 10 Performers</h2>
              <p class="text-sm text-gray-500 mt-1">Highest OAPR scores</p>
            </div>
            <div class="text-right">
              <span class="text-2xl font-bold text-yellow-600">{{ topPerformers.length }}</span>
              <p class="text-xs text-gray-500">Students</p>
            </div>
          </div>
        </div>
        
        <!-- Loading state -->
        <div v-if="loading" class="flex justify-center items-center py-10">
          <i class="fas fa-circle-notch fa-spin text-4xl text-crimson-600"></i>
        </div>
        
        <!-- Top Performers Grid -->
        <div v-else class="p-6">
          <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-5 gap-4">
            <div 
              v-for="performer in topPerformers.slice(0, 10)" 
              :key="performer.rank"
              class="bg-gradient-to-br from-yellow-50 to-orange-50 p-4 rounded-xl border border-yellow-200 hover:shadow-md transition-all duration-300"
              :class="{
                'ring-2 ring-yellow-400 bg-gradient-to-br from-yellow-100 to-orange-100': performer.rank <= 3,
                'transform hover:scale-105': performer.rank <= 3
              }"
            >
              <div class="text-center">
                <!-- Rank Badge -->
                <div class="flex justify-center mb-3">
                  <div 
                    class="w-8 h-8 rounded-full flex items-center justify-center text-sm font-bold"
                    :class="{
                      'bg-yellow-500 text-white': performer.rank === 1,
                      'bg-gray-400 text-white': performer.rank === 2,
                      'bg-amber-600 text-white': performer.rank === 3,
                      'bg-blue-500 text-white': performer.rank > 3
                    }"
                  >
                    {{ performer.rank }}
                  </div>
                </div>
                
                <!-- Trophy for top 3 -->
                <div v-if="performer.rank <= 3" class="flex justify-center mb-2">
                  <i 
                    class="text-2xl"
                    :class="{
                      'fas fa-trophy text-yellow-500': performer.rank === 1,
                      'fas fa-medal text-gray-400': performer.rank === 2,
                      'fas fa-award text-amber-600': performer.rank === 3
                    }"
                  ></i>
                </div>
                
                <!-- OAPR Score -->
                <div class="mb-2">
                  <span class="text-2xl font-bold text-gray-800">{{ performer.oapr }}</span>
                  <p class="text-xs text-gray-500">OAPR</p>
                </div>
                
                <!-- Student Name -->
                <h4 class="font-semibold text-gray-800 text-sm mb-1 truncate" :title="performer.name">
                  {{ performer.name }}
                </h4>
                
                <!-- School -->
                <p class="text-xs text-gray-600 mb-1 truncate" :title="performer.school">
                  {{ performer.school }}
                </p>
                
                <!-- Program & Date -->
                <div class="text-xs text-gray-500">
                  <p class="truncate">{{ performer.program }}</p>
                  <p>{{ formatDate(performer.exam_date) }}</p>
                </div>
              </div>
            </div>
            
            <!-- Empty states if less than 10 -->
            <div 
              v-for="n in Math.max(0, 10 - topPerformers.length)" 
              :key="`empty-${n}`"
              class="bg-gray-50 p-4 rounded-xl border border-gray-200 flex items-center justify-center"
            >
              <div class="text-center text-gray-400">
                <i class="fas fa-user-plus text-2xl mb-2"></i>
                <p class="text-xs">No data</p>
              </div>
            </div>
          </div>
          
          <!-- Show more button if there are more than 10 results -->
          <div v-if="topPerformers.length > 10" class="text-center mt-6">
            <button 
              @click="showAllPerformers = !showAllPerformers"
              class="px-4 py-2 bg-crimson-600 text-white rounded-lg hover:bg-crimson-700 transition-colors duration-200"
            >
              <i class="fas fa-chevron-down mr-2" v-if="!showAllPerformers"></i>
              <i class="fas fa-chevron-up mr-2" v-else></i>
              {{ showAllPerformers ? 'Show Less' : 'Show All' }}
            </button>
          </div>
        </div>
      </div>
      
      <!-- Detailed Data Table -->
      <div class="bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden">
        <div class="p-6 border-b border-gray-100">
          <h2 class="text-xl font-bold text-gray-800">Test Results</h2>
          <p class="text-sm text-gray-500 mt-1">Detailed test results data</p>
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
                <th class="px-4 py-3 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">Program</th>
                <th class="px-4 py-3 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">Test Date</th>
                <th class="px-4 py-3 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">Score</th>
                <th class="px-4 py-3 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">Status</th>
                <th class="px-4 py-3 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">Test Center</th>
              </tr>
            </thead>
            <tbody class="divide-y divide-gray-100">
              <tr v-for="result in testResults" :key="result.id" class="hover:bg-gray-50 transition-colors duration-200">
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
              
              <tr v-if="testResults.length === 0">
                <td colspan="6" class="px-4 py-8 text-center text-gray-500">
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
import { ref, reactive, onMounted } from 'vue'
import axiosInstance from '../../../services/axios.interceptor'
import MonthlyTestsChart from '../../../components/charts/MonthlyTestsChart.vue'
import PassRateByProgramChart from '../../../components/charts/PassRateByProgramChart.vue'

export default {
  name: 'Reports',
  components: {
    MonthlyTestsChart,
    PassRateByProgramChart
  },
  setup() {
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
    
    // Chart data
    const monthlyData = ref([])
    const programStats = ref([])
    
    // Fetch initial data
    onMounted(() => {
      fetchPrograms()
      fetchTestCenters()
      fetchTestResults()
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
        
      } catch (error) {
        console.error('Error fetching test results:', error)
        
        // Fallback to demo data if API fails
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
        }, 800)
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
    
    return {
      loading,
      page,
      itemsPerPage,
      totalResults,
      totalPages,
      filters,
      statistics,
      programs,
      testCenters,
      testResults,
      topPerformers,
      showAllPerformers,
      monthlyData,
      programStats,
      applyFilters,
      resetFilters,
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
