<template>
  <!-- Header Banner -->
    <section class="relative min-h-[600px] flex items-center py-20 sm:py-28 md:py-32 overflow-hidden">
      <!-- Background image -->
      <div 
        class="absolute inset-0 bg-cover bg-center bg-no-repeat transform scale-105 transition-transform duration-[2s]"
        :style="{ backgroundImage: `url('https://i.ytimg.com/vi/JoimFFEafbE/maxresdefault.jpg')` }"
      ></div>
      
      <!-- Enhanced Overlay with multiple layers -->
      <div class="absolute inset-0 bg-gradient-to-br from-black/70 via-black/50 to-transparent backdrop-blur-sm"></div>
      <div class="absolute inset-0 bg-gradient-to-t from-black/60 via-transparent to-transparent"></div>
      
      <!-- Content -->
      <div class="container mx-auto px-4 relative z-10">
        <div class="max-w-7xl mx-auto">
          <div class="max-w-2xl">
            <!-- Main Content -->
            <div class="text-left animate-fade-in-up">
              <div class="inline-block">
                <span class="text-crimson-300 bg-white/10 backdrop-blur-lg px-4 py-1.5 rounded-full uppercase tracking-wider text-sm font-semibold mb-4 block">
                  Examination Score Results
                </span>
              </div>
              
              <h1 class="text-4xl sm:text-5xl md:text-6xl font-extrabold text-white mb-6 leading-tight">
                Access Your <span class="text-transparent bg-clip-text bg-gradient-to-r from-crimson-300 to-pink-300">Exam Results</span> and Important Updates
              </h1>
              
              <p class="text-lg sm:text-xl text-gray-200 max-w-xl mb-8 leading-relaxed">
                Access your official exam results, check your scores, and stay updated on important announcements from the Testing and Evaluation Center.
              </p>
            </div>
          </div>
        </div>
      </div>
    </section>  
  <div class="min-h-screen bg-gray-50 py-8">
    <div class="container mx-auto px-4 max-w-4xl">
      <!-- Header Section -->
      <div class="mb-6">
        <div class="flex items-center space-x-4">
          <div class="p-3 bg-crimson-100 rounded-lg">
            <font-awesome-icon :icon="['fas', 'graduation-cap']" class="text-2xl text-crimson-600" />
          </div>
          <div>
            <h1 class="text-2xl md:text-3xl font-bold text-gray-900">Exam Scores</h1>
            <p class="text-sm md:text-base text-gray-600">Check your examination scores using your application details</p>
          </div>
        </div>
      </div>

      <!-- Search Form -->
      <div class="bg-white rounded-lg shadow-md p-6 mb-6">
        <h2 class="text-lg font-semibold text-gray-900 mb-4">Search for your Examination Results</h2>
        <p class="text-sm text-gray-600 mb-4">
          Please enter your information to retrieve your exam scores. You must provide at least your Application Number and Last Name.
        </p>

        <form @submit.prevent="searchScores" class="space-y-4">
          <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
            <!-- Application Number -->
            <div>
              <label for="applicationNumber" class="block text-sm font-medium text-gray-700 mb-1">Application Number *</label>
              <input
                id="applicationNumber"
                v-model="searchForm.appNo"
                type="text"
                placeholder="e.g., 2023-12345"
                class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-crimson-500"
                required
              />
            </div>

            <!-- Last Name -->
            <div>
              <label for="lastName" class="block text-sm font-medium text-gray-700 mb-1">Last Name *</label>
              <input
                id="lastName"
                v-model="searchForm.lastName"
                type="text"
                placeholder="Enter your last name"
                class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-crimson-500"
                required
              />
            </div>

            <!-- First Name -->
            <div>
              <label for="firstName" class="block text-sm font-medium text-gray-700 mb-1">First Name</label>
              <input
                id="firstName"
                v-model="searchForm.firstName"
                type="text"
                placeholder="Enter your first name"
                class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-crimson-500"
              />
            </div>

            <!-- Middle Initial -->
            <div>
              <label for="middleInitial" class="block text-sm font-medium text-gray-700 mb-1">Middle Initial</label>
              <input
                id="middleInitial"
                v-model="searchForm.middleInitial"
                type="text"
                placeholder="e.g., M."
                maxlength="2"
                class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-crimson-500"
              />
            </div>

            <!-- Exam Year -->
            <div>
              <label for="examYear" class="block text-sm font-medium text-gray-700 mb-1">Exam Year</label>
              <select
                id="examYear"
                v-model="searchForm.examYear"
                class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-crimson-500"
              >
                <option value="">All Years</option>
                <option v-for="year in availableYears" :key="year" :value="year">{{ year }}</option>
              </select>
            </div>

            <!-- Exam Type -->
            <div>
              <label for="examType" class="block text-sm font-medium text-gray-700 mb-1">Exam Type</label>              <select
                id="examType"
                v-model="searchForm.examType"
                class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-crimson-500"
                :disabled="loading"
              >
                <option value="">{{ loading ? 'Loading exam types...' : 'All Types' }}</option>
                <option v-for="type in examTypes" :key="type.value" :value="type.value">{{ type.label }}</option>
              </select>
            </div>
          </div>

          <!-- Captcha -->
          <div class="mt-4">
            <label class="block text-sm font-medium text-gray-700 mb-2">Security Check *</label>
            <div class="flex flex-col sm:flex-row gap-4">
              <div class="flex-1">
                <div class="bg-blue-50 p-3 rounded-lg flex items-center justify-center border">
                  <div class="text-2xl font-bold tracking-widest text-blue-800 relative">
                    {{ captcha.text }}
                    <div class="absolute inset-0 bg-blue-100 opacity-20"></div>
                    <div class="absolute inset-0" 
                         :style="{
                           backgroundImage: 'repeating-linear-gradient(45deg, transparent, transparent 5px, rgba(255,255,255,.5) 5px, rgba(255,255,255,.5) 10px)'
                         }">
                    </div>
                  </div>
                </div>
              </div>
              <div class="flex-1">
                <input 
                  v-model="captchaInput"
                  type="text" 
                  class="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-crimson-500"
                  placeholder="Enter the code"
                  required
                  autocomplete="off"
                />
              </div>
              <div>
                <button 
                  @click.prevent="refreshCaptcha" 
                  type="button"
                  class="px-4 py-2.5 text-gray-600 bg-gray-100 rounded-lg hover:bg-gray-200 transition-colors"
                  title="Get new code"
                >
                  <font-awesome-icon :icon="['fas', 'sync']" />
                </button>
              </div>
            </div>
          </div>

          <!-- Error Message -->
          <div v-if="error" class="p-3 bg-red-50 text-red-700 rounded-lg border border-red-200 flex items-start gap-2">
            <font-awesome-icon :icon="['fas', 'exclamation-circle']" class="mt-1 text-red-500" />
            <p>{{ error }}</p>
          </div>

          <!-- Submit Button -->
          <div class="pt-2">
            <button 
              type="submit"
              :disabled="loading"
              class="w-full px-4 py-3 rounded-lg bg-crimson-600 text-white hover:bg-crimson-700 hover:shadow-md transition-all duration-200 flex items-center justify-center space-x-2"
            >
              <font-awesome-icon v-if="loading" :icon="['fas', 'spinner']" spin />
              <font-awesome-icon v-else :icon="['fas', 'search']" />
              <span>{{ loading ? 'Searching...' : 'Search for Exam Scores' }}</span>
            </button>
          </div>
        </form>
      </div>      <!-- Multiple Results Warning (when more than one score found) -->
      <div v-if="multipleScoresFound" class="bg-blue-50 border border-blue-200 rounded-lg p-4 mb-4 animate-fade-in">
        <div class="flex items-center space-x-3">
          <font-awesome-icon :icon="['fas', 'info-circle']" class="text-blue-500 text-xl" />
          <div>
            <h3 class="font-semibold text-gray-900">Multiple Exam Scores Found</h3>
            <p class="text-sm text-gray-600">We found {{ examScores.length }} different exam records for you. Please select the exam type you want to view:</p>
          </div>
        </div>
        <div class="mt-3 flex flex-wrap gap-2">
          <button
            v-for="(score, index) in examScores" 
            :key="index"
            @click="selectExamScore(index)"
            class="px-3 py-1 rounded-full text-sm"
            :class="selectedScoreIndex === index ? 'bg-crimson-600 text-white' : 'bg-gray-100 text-gray-700 hover:bg-gray-200'"
          >
            {{ score.exam_type || 'Unknown Exam' }} ({{ formatDate(score.exam_date) }})
          </button>
        </div>
      </div>

      <!-- Results Section -->
      <div v-if="currentExamScore" class="bg-white rounded-lg shadow-md p-6 animate-fade-in">
        <div class="mb-4">
          <div class="flex items-center justify-between">
            <h2 class="text-lg font-semibold text-gray-900">Examination Results</h2>
            <span class="px-3 py-1 bg-green-100 text-green-800 rounded-full text-sm">
              {{ currentExamScore.exam_type || 'College Entrance Test' }}
            </span>
          </div>
          <p class="text-sm text-gray-600 mt-1">
            Examination Date: {{ formatDate(currentExamScore.exam_date) }}
          </p>
        </div>

        <!-- Student Info -->
        <div class="mb-4 p-4 bg-gray-50 rounded-lg">
          <div class="grid grid-cols-1 md:grid-cols-2 gap-3">
            <div>
              <p class="text-sm text-gray-600">Application No.</p>
              <p class="font-medium">{{ currentExamScore.app_no }}</p>
            </div>
            <div>
              <p class="text-sm text-gray-600">Student Name</p>
              <p class="font-medium">{{ currentExamScore.name }}</p>
            </div>
            <div>
              <p class="text-sm text-gray-600">School</p>
              <p class="font-medium">{{ currentExamScore.school || 'Not specified' }}</p>
            </div>
            <div>
              <p class="text-sm text-gray-600">Overall Score</p>
              <p class="font-medium">{{ currentExamScore.score }}</p>
            </div>
          </div>
        </div>

        <!-- Score Breakdown -->
        <div class="mb-4">
          <h3 class="text-md font-semibold text-gray-900 mb-3">Score Breakdown</h3>
          <div class="overflow-x-auto">
            <table class="min-w-full divide-y divide-gray-200">
              <thead class="bg-gray-50">
                <tr>
                  <th class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Test Component</th>
                  <th class="px-4 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">Score</th>
                </tr>
              </thead>
              <tbody class="bg-white divide-y divide-gray-200">
                <tr>
                  <td class="px-4 py-3 text-sm text-gray-900">English Proficiency</td>
                  <td class="px-4 py-3 text-sm text-right font-semibold">{{ currentExamScore.part1 }}</td>
                </tr>
                <tr>
                  <td class="px-4 py-3 text-sm text-gray-900">Reading Comprehension</td>
                  <td class="px-4 py-3 text-sm text-right font-semibold">{{ currentExamScore.part2 }}</td>
                </tr>
                <tr>
                  <td class="px-4 py-3 text-sm text-gray-900">Science Process Skills</td>
                  <td class="px-4 py-3 text-sm text-right font-semibold">{{ currentExamScore.part3 }}</td>
                </tr>
                <tr>
                  <td class="px-4 py-3 text-sm text-gray-900">Quantitative Skills</td>
                  <td class="px-4 py-3 text-sm text-right font-semibold">{{ currentExamScore.part4 }}</td>
                </tr>
                <tr>
                  <td class="px-4 py-3 text-sm text-gray-900">Abstract Thinking Skills</td>
                  <td class="px-4 py-3 text-sm text-right font-semibold">{{ currentExamScore.part5 }}</td>
                </tr>
              </tbody>
              <tfoot class="bg-crimson-50">
                <tr>
                  <td class="px-4 py-3 text-sm font-semibold text-gray-900">Overall Ability Percentile Rank</td>
                  <td class="px-4 py-3 text-sm text-right font-bold text-crimson-700">{{ currentExamScore.oapr }}</td>
                </tr>
              </tfoot>
            </table>
          </div>
        </div>

        <!-- Note -->
        <div class="text-sm text-gray-500 border-t border-gray-200 pt-4 mt-4">
          <p>
            <font-awesome-icon :icon="['fas', 'info-circle']" class="mr-1" />
            This is your official examination score. For any concerns, please contact the Testing Evaluation Center.
          </p>
        </div>
      </div>

      <!-- No Results Message -->
      <div v-if="noResults" class="bg-yellow-50 border border-yellow-200 rounded-lg p-6 text-center animate-fade-in">
        <font-awesome-icon :icon="['fas', 'exclamation-triangle']" class="text-yellow-500 text-3xl mb-3" />
        <h3 class="text-lg font-semibold text-gray-900 mb-2">No Exam Scores Found</h3>
        <p class="text-gray-600">
          We couldn't find any exam scores matching your provided information. Please ensure all details are correct and try again.
        </p>
        <button 
          @click="resetSearch" 
          class="mt-4 px-4 py-2 bg-crimson-600 text-white rounded-lg hover:bg-crimson-700 transition-colors"
        >
          Try Again
        </button>
      </div>
    </div>
  </div>
</template>

<script>
import { ref, reactive, onMounted, computed } from 'vue'
import axios from 'axios'
import { useToast } from '../composables/useToast'

export default {
  name: 'ExamScores',
  setup() {
    const { showToast } = useToast()
    
    // Form Data
    const searchForm = reactive({
      appNo: '',
      lastName: '',
      firstName: '',
      middleInitial: '',
      examYear: '',
      examType: ''
    })
    
    // Available years (current year down to 2020)
    const currentYear = new Date().getFullYear()
    const availableYears = ref([])
    for (let year = currentYear; year >= 2020; year--) {
      availableYears.value.push(year)
    }    // Available exam types - will be fetched from API
    const examTypes = ref([
      { value: 'CET', label: 'CET - College Entrance Test' },
      { value: 'NAT', label: 'NAT - National Achievement Test' },
      { value: 'EAT', label: 'EAT - Engineering Aptitude Test' }
    ])
    
    // Fetch program codes from the API
    const fetchProgramCodes = async () => {
      try {
        const apiUrl = import.meta.env.VITE_API_URL || 'http://127.0.0.1:8000'
        const apiUrlWithoutTrailingSlash = apiUrl.endsWith('/') ? apiUrl.slice(0, -1) : apiUrl
        
        let response = null
        
        try {
          response = await axios.get(`${apiUrlWithoutTrailingSlash}/api/programs/`)
        } catch (error) {
          try {
            response = await axios.get(`${apiUrlWithoutTrailingSlash}/programs/`)
          } catch (err) {
            console.error('Failed to fetch program codes:', err)
            // Keep default exam types and don't throw error
            return true
          }
        }
        
        if (response && response.data) {
          if (Array.isArray(response.data)) {
            examTypes.value = response.data.map(program => ({
              value: program.code,
              label: `${program.code} - ${program.name}`
            }))
            return true
          } else if (response.data.results && Array.isArray(response.data.results)) {
            examTypes.value = response.data.results.map(program => ({
              value: program.code,
              label: `${program.code} - ${program.name}`
            }))
            return true
          }
        }
        
        // If we reach here, use defaults
        return true
      } catch (e) {
        console.error('Error fetching program codes:', e)
        // Keep default exam types and don't throw error
        return true
      }
    }
      // States
    const loading = ref(false)
    const error = ref('')
    const examScores = ref([])
    const selectedScoreIndex = ref(0)
    const multipleScoresFound = ref(false)
    const noResults = ref(false)
    
    // Computed property to get current selected exam score
    const currentExamScore = computed(() => {
      if (examScores.value.length === 0) return null
      return examScores.value[selectedScoreIndex.value]
    })
    
    // Function to select a specific exam score from multiple results
    const selectExamScore = (index) => {
      selectedScoreIndex.value = index
    }
    
    // Captcha
    const captcha = reactive({
      text: ''
    })
    const captchaInput = ref('')
    
    // Generate random captcha text
    const generateCaptcha = () => {
      const chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ'
      let result = ''
      for (let i = 0; i < 6; i++) {
        result += chars.charAt(Math.floor(Math.random() * chars.length))
      }
      captcha.text = result
    }
    
    // Refresh captcha
    const refreshCaptcha = () => {
      generateCaptcha()
      captchaInput.value = ''
    }
      // Reset search
    const resetSearch = () => {
      examScores.value = []
      multipleScoresFound.value = false
      selectedScoreIndex.value = 0
      noResults.value = false
      error.value = ''
      refreshCaptcha()
    }
      // Search for exam scores
    const searchScores = async () => {
      // Reset states
      error.value = ''
      examScores.value = []
      multipleScoresFound.value = false
      selectedScoreIndex.value = 0
      noResults.value = false
      
      // Validate captcha
      if (captchaInput.value !== captcha.text) {
        error.value = 'The security code you entered is incorrect. Please try again.'
        refreshCaptcha()
        return
      }
      
      // Validate required fields
      if (!searchForm.appNo || !searchForm.lastName) {
        error.value = 'Application Number and Last Name are required fields.'
        return
      }
      
      loading.value = true;
      try {
        // Get the API URL from environment or use default
        const apiUrl = import.meta.env.VITE_API_URL || 'http://127.0.0.1:8000';
        const apiUrlWithoutTrailingSlash = apiUrl.endsWith('/') ? apiUrl.slice(0, -1) : apiUrl;
        
        console.log('Searching with criteria:', {
          app_no: searchForm.appNo,
          last_name: searchForm.lastName,
          first_name: searchForm.firstName,
          middle_initial: searchForm.middleInitial,
          exam_year: searchForm.examYear,
          exam_type: searchForm.examType
        });
        
        const response = await axios.get(`${apiUrlWithoutTrailingSlash}/api/api/public/search-exam-scores/`, {
          params: {
            app_no: searchForm.appNo,
            last_name: searchForm.lastName,
            first_name: searchForm.firstName || null,
            middle_initial: searchForm.middleInitial || null,
            exam_year: searchForm.examYear || null,
            exam_type: searchForm.examType || null
          }
        })
        
        if (response.data) {
          // Check if response data is an array (multiple scores) or a single object
          if (Array.isArray(response.data)) {
            examScores.value = response.data
            console.log('Found multiple exam scores:', examScores.value)
            
            if (examScores.value.length > 1) {
              multipleScoresFound.value = true
              showToast('Success', `Found ${examScores.value.length} different exam scores. Please select the one you're looking for.`, 'info')
            } else if (examScores.value.length === 1) {
              // Only one result in the array
              showToast('Success', 'Exam score found successfully.', 'success')
            }
          } else {
            // Single result (object)
            examScores.value = [response.data]
            console.log('Found single exam score:', examScores.value[0])
            
            // Display appropriate toast message
            if (examScores.value[0].app_no === searchForm.appNo) {
              showToast('Success', 'Exam score found successfully.', 'success')
            } else {
              // This is a partial match - show a warning
              showToast('Warning', 'Partial match found. Please verify this is your score.', 'warning')
            }
          }
        } else {
          noResults.value = true
        }
      } catch (err) {
        console.error('Error fetching exam scores:', err)
        if (err.response && err.response.status === 404) {
          noResults.value = true
        } else {
          error.value = err.response?.data?.detail || 'An error occurred while searching for your exam scores. Please try again later.'
        }
      } finally {
        loading.value = false
        refreshCaptcha()
      }
    }
    
    // Format date
    const formatDate = (dateString) => {
      if (!dateString) return 'Not specified'
      
      const date = new Date(dateString)
      if (isNaN(date)) return 'Invalid date'
      
      return date.toLocaleDateString('en-US', {
        year: 'numeric',
        month: 'long',
        day: 'numeric'
      })
    }
      // Initialize
    onMounted(async () => {
      generateCaptcha()
      loading.value = true // Show loading state immediately
      
      try {
        await fetchProgramCodes() // Fetch exam types from backend
        console.log("Exam types loaded:", examTypes.value)
      } catch (error) {
        console.error('Error fetching exam types:', error)
        showToast('Notice', 'Using default exam types due to connection issue.', 'info')
      } finally {
        loading.value = false // Always reset loading state
      }
    })
      return {
      searchForm,
      loading,
      error,
      examScores,
      currentExamScore,
      multipleScoresFound,
      selectedScoreIndex,
      selectExamScore,
      noResults,
      captcha,
      captchaInput,
      searchScores,
      resetSearch,
      refreshCaptcha,
      formatDate,
      availableYears,
      examTypes
    }
  }
}
</script>

<style scoped>
.animate-fade-in {
  animation: fadeIn 0.5s ease-in-out;
}

@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}
</style>
