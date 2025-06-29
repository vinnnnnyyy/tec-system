<template>
  <div class="min-h-screen bg-gray-50 py-8">
    <div class="container mx-auto px-4">
      <!-- Header Section -->
      <div class="mb-8">
        <h1 class="text-3xl font-bold text-gray-900 mb-2">Import Exam Results</h1>
        <p class="text-gray-600">Upload and import examination results for different exam types</p>
      </div>

      <!-- Main Content -->
      <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
        <!-- Upload Section -->
        <div class="lg:col-span-2">
          <div class="bg-white rounded-xl shadow-lg p-6">
            <div class="mb-6">
              <h2 class="text-xl font-semibold text-gray-900 mb-2">Upload Results File</h2>
              <p class="text-sm text-gray-600 mb-4">Upload your CSV or Excel file containing the exam results</p>
                <!-- File Upload Area -->
              <div 
                class="border-2 border-dashed border-gray-300 rounded-xl p-8 text-center hover:border-crimson-500 transition-colors duration-200"
                @dragover="handleDragOver"
                @drop="handleFileDrop"
              >
                <div class="space-y-4">
                  <div class="w-16 h-16 mx-auto bg-crimson-50 rounded-full flex items-center justify-center">
                    <i class="fas fa-file-upload text-2xl text-crimson-600"></i>
                  </div>
                  <div v-if="!fileName">
                    <p class="text-sm text-gray-600">Drag and drop your file here, or</p>
                    <label class="mt-2 inline-flex items-center px-4 py-2 bg-crimson-600 text-white rounded-lg hover:bg-crimson-700 transition-colors duration-200 cursor-pointer">
                      <i class="fas fa-folder-open mr-2"></i>
                      Browse Files
                      <input 
                        type="file" 
                        class="hidden" 
                        accept=".csv,.xlsx,.xls"
                        @change="handleFileSelect"
                      >
                    </label>
                    <p class="mt-2 text-xs text-gray-500">Supported formats: CSV, Excel (.xlsx, .xls)</p>
                  </div>
                  <div v-else class="text-center">
                    <div class="flex items-center justify-center space-x-2 mb-2">
                      <i class="fas fa-file-excel text-xl text-green-600" v-if="fileName.endsWith('.xlsx') || fileName.endsWith('.xls')"></i>
                      <i class="fas fa-file-csv text-xl text-blue-600" v-else-if="fileName.endsWith('.csv')"></i>
                      <i class="fas fa-file text-xl text-gray-600" v-else></i>
                      <span class="font-medium text-gray-800">{{ fileName }}</span>
                    </div>
                    <button 
                      @click="file = null; fileName = ''"
                      class="text-sm text-crimson-600 hover:text-crimson-800 transition-colors"
                    >
                      <i class="fas fa-times mr-1"></i>
                      Remove file
                    </button>
                  </div>
                </div>
              </div>
            </div>

            <!-- Import Settings -->
            <div class="space-y-6">
              <h3 class="text-lg font-semibold text-gray-900">Import Settings</h3>
                <!-- Exam Type Selection -->
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Select Exam Type</label>
                <select 
                  v-model="selectedExamType"
                  class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-crimson-500"
                >
                  <option value="">Choose an exam type</option>
                  <option value="LSAT">LSAT Exam</option>
                  <option value="NAT">NAT Exam</option>
                  <option value="EAT">EAT Exam</option>
                  <option value="CET">CET Exam</option>
                  <option value="LET">LET Exam</option>
                  <option value="NLE">NLE Exam</option>
                  <option value="CLE">CLE Exam</option>
                  <option value="CPE">CPE Exam</option>
                </select>
              </div>              <!-- Exam Year Selection -->
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Select Exam Year</label>
                <select 
                  id="yearSelect"
                  ref="yearSelect"
                  v-model="selectedYear"
                  class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-crimson-500"
                >
                  <option value="" disabled>Select a year</option>
                  <!-- Hardcoded options for immediate testing -->
                  <option value="2025">2025</option>
                  <option value="2024">2024</option>
                  <option value="2023">2023</option>
                  <option value="2022">2022</option>
                  <option value="2021">2021</option>
                  <option value="2020">2020</option>
                  <option value="2019">2019</option>
                  <option value="2018">2018</option>
                  <option value="2017">2017</option>
                  <option value="2016">2016</option>
                </select>
              </div>
              <!-- File Format Settings -->
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">File Format Settings</label>
                <div class="space-y-4">
                  <div class="flex items-center space-x-4">
                    <div class="flex-1">                      <label class="block text-sm text-gray-600 mb-1">Column for Application Number</label>
                      <select 
                        v-model="columnMappings.appNo"
                        class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-crimson-500"
                      >
                        <option value="">Select column</option>
                        <option value="A">Column A</option>
                        <option value="B">Column B</option>
                        <option value="C">Column C</option>
                        <option value="D">Column D</option>
                        <option value="E">Column E</option>
                      </select>
                    </div>
                    <div class="flex-1">
                      <label class="block text-sm text-gray-600 mb-1">Column for Full Name</label>
                      <select 
                        v-model="columnMappings.name"
                        class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-crimson-500"
                      >
                        <option value="">Select column</option>
                        <option value="A">Column A</option>
                        <option value="B">Column B</option>
                        <option value="C">Column C</option>
                        <option value="D">Column D</option>
                        <option value="E">Column E</option>
                      </select>
                    </div>
                  </div>
                  <div class="flex items-center space-x-4">
                    <div class="flex-1">
                      <label class="block text-sm text-gray-600 mb-1">Column for School</label>
                      <select 
                        v-model="columnMappings.school"
                        class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-crimson-500"
                      >
                        <option value="">Select column</option>
                        <option value="A">Column A</option>
                        <option value="B">Column B</option>
                        <option value="C">Column C</option>
                        <option value="D">Column D</option>
                        <option value="E">Column E</option>
                      </select>
                    </div>
                    <div class="flex-1">
                      <label class="block text-sm text-gray-600 mb-1">Column for Score (Optional)</label>
                      <select 
                        v-model="columnMappings.score"
                        class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-crimson-500"
                      >
                        <option value="">Select column</option>
                        <option value="A">Column A</option>
                        <option value="B">Column B</option>
                        <option value="C">Column C</option>
                        <option value="D">Column D</option>
                        <option value="E">Column E</option>
                      </select>
                    </div>
                  </div>
                </div>
              </div>              <!-- Import Button -->
              <div class="pt-4">
                <button 
                  @click="importResults"
                  :disabled="!isFormValid || isUploading"
                  class="w-full px-6 py-3 bg-crimson-600 text-white rounded-lg hover:bg-crimson-700 transition-colors duration-200 flex items-center justify-center space-x-2 disabled:opacity-50 disabled:cursor-not-allowed"
                >
                  <i :class="isUploading ? 'fas fa-spinner fa-spin' : 'fas fa-upload'"></i>
                  <span>{{ isUploading ? 'Importing...' : 'Start Import' }}</span>
                </button>
                <p v-if="!isFormValid && file" class="mt-2 text-xs text-red-500">
                  Please select exam type, year and map required columns before importing.
                </p>
              </div>
            </div>
          </div>
        </div>

        <!-- Import History & Guidelines -->
        <div class="space-y-6">
          <!-- Import Guidelines -->
          <div class="bg-white rounded-xl shadow-lg p-6">
            <h2 class="text-xl font-semibold text-gray-900 mb-4">Import Guidelines</h2>
            <div class="space-y-4">
              <div class="flex items-start space-x-3">
                <div class="w-6 h-6 rounded-full bg-crimson-100 flex items-center justify-center flex-shrink-0">
                  <i class="fas fa-info text-crimson-600 text-sm"></i>
                </div>
                <p class="text-sm text-gray-600">Ensure your file contains the required columns: Application Number, Full Name, and School</p>
              </div>
              <div class="flex items-start space-x-3">
                <div class="w-6 h-6 rounded-full bg-crimson-100 flex items-center justify-center flex-shrink-0">
                  <i class="fas fa-file-alt text-crimson-600 text-sm"></i>
                </div>
                <p class="text-sm text-gray-600">File should be in CSV or Excel format (.xlsx, .xls)</p>
              </div>
              <div class="flex items-start space-x-3">
                <div class="w-6 h-6 rounded-full bg-crimson-100 flex items-center justify-center flex-shrink-0">
                  <i class="fas fa-exclamation-triangle text-crimson-600 text-sm"></i>
                </div>
                <p class="text-sm text-gray-600">Maximum file size: 10MB</p>
              </div>
            </div>
          </div>          <!-- Recent Imports -->
          <div class="bg-white rounded-xl shadow-lg p-6">
            <h2 class="text-xl font-semibold text-gray-900 mb-4">Recent Imports</h2>
            
            <!-- Loading State -->
            <div v-if="loadingImports" class="py-8 text-center">
              <div class="inline-block animate-spin rounded-full h-8 w-8 border-4 border-crimson-600 border-t-transparent"></div>
              <p class="mt-2 text-gray-600 text-sm">Loading import history...</p>
            </div>
            
            <!-- Error State -->
            <div v-else-if="importError" class="p-4 bg-red-50 rounded-lg text-center">
              <i class="fas fa-exclamation-circle text-red-500 text-xl mb-2"></i>
              <p class="text-red-700">{{ importError }}</p>
              <button 
                @click="fetchRecentImports" 
                class="mt-2 text-sm text-crimson-600 hover:text-crimson-800"
              >
                Try again
              </button>
            </div>
            
            <!-- Empty State -->
            <div v-else-if="recentImports.length === 0" class="p-6 bg-gray-50 rounded-lg text-center">
              <i class="fas fa-history text-gray-400 text-2xl mb-2"></i>
              <p class="text-gray-600">No import history available</p>
            </div>
              <!-- Import History List -->
            <div v-else class="space-y-4">
              <div v-for="(import_, index) in recentImports" :key="index" 
                   class="p-4 bg-gray-50 rounded-lg hover:bg-gray-100 transition-colors">
                <div class="flex items-center justify-between mb-2">
                  <div class="flex items-center">
                    <div class="w-8 h-8 rounded-full bg-crimson-50 flex items-center justify-center mr-2">
                      <i :class="['text-crimson-600', getExamIcon(import_.examType)]"></i>
                    </div>
                    <span class="text-sm font-medium text-gray-900">{{ import_.examType }}</span>
                  </div>
                  <span class="text-xs text-gray-500 whitespace-nowrap">{{ formatDate(import_.date) }}</span>
                </div>
                <div class="flex flex-wrap items-center gap-4 text-sm mt-3">
                  <span class="bg-green-50 text-green-700 px-2.5 py-1 rounded-full flex items-center">
                    <i class="fas fa-check-circle mr-1.5"></i>
                    {{ import_.successful }} successful
                  </span>
                  <span class="bg-red-50 text-red-700 px-2.5 py-1 rounded-full flex items-center" v-if="import_.failed > 0">
                    <i class="fas fa-times-circle mr-1.5"></i>
                    {{ import_.failed }} failed
                  </span>
                  <span class="text-gray-500 text-xs flex-grow text-right">
                    Total: {{ import_.successful + import_.failed }} records
                  </span>
                </div>
              </div>
            </div>
            
            <!-- Refresh Button -->
            <div v-if="recentImports.length > 0" class="mt-4 text-center">
              <button 
                @click="fetchRecentImports" 
                class="text-sm text-crimson-600 hover:text-crimson-800 flex items-center justify-center mx-auto"
              >
                <i class="fas fa-sync-alt mr-1"></i>
                Refresh history
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  name: 'ExamResultsImport',
  data() {
    return {
      // Form data
      selectedExamType: '',
      selectedYear: new Date().getFullYear().toString(),
      availableYears: [],
      file: null,
      fileName: '',
      isUploading: false,
      
      // Column mappings
      columnMappings: {
        appNo: '',
        name: '',
        school: '',
        score: ''
      },
      
      // Recent imports data
      recentImports: [],
      loadingImports: false,
      importError: null
    }
  },  computed: {
    // Main computed property for years to display in the dropdown
    years() {
      // Get current year and generate the 10-year range we need
      const currentYear = new Date().getFullYear();
      const generatedYears = [];
      
      for (let i = 0; i < 10; i++) {
        generatedYears.push((currentYear - i).toString());
      }
      
      // If we have years from API, merge and de-duplicate
      if (this.availableYears && this.availableYears.length > 0) {
        // Combine API years with generated years and remove duplicates
        const combinedYears = [...this.availableYears, ...generatedYears];
        const uniqueYears = [...new Set(combinedYears)];
        
        // Sort in descending order (newest first)
        return uniqueYears.sort((a, b) => parseInt(b) - parseInt(a));
      }
      
      return generatedYears;
    },
    
    // Check if form is valid for submission
    isFormValid() {
      return this.selectedExamType && 
             this.selectedYear && 
             this.file &&
             this.columnMappings.appNo && 
             this.columnMappings.name;
    }
  },
  methods: {
    // Handle file selection
    handleFileSelect(event) {
      const files = event.target.files;
      if (files.length > 0) {
        this.file = files[0];
        this.fileName = this.file.name;
      }
    },
    
    // Handle file drop
    handleFileDrop(event) {
      event.preventDefault();
      const files = event.dataTransfer.files;
      if (files.length > 0) {
        this.file = files[0];
        this.fileName = this.file.name;
      }
    },
    
    // Prevent default drag behavior
    handleDragOver(event) {
      event.preventDefault();
    },
    
    // Import results from uploaded file
    async importResults() {
      if (!this.isFormValid) return;
      
      this.isUploading = true;
      
      try {
        const formData = new FormData();
        formData.append('file', this.file);
        formData.append('exam_type', this.selectedExamType);
        formData.append('exam_year', this.selectedYear);
        formData.append('column_app_no', this.columnMappings.appNo);
        formData.append('column_name', this.columnMappings.name);
        formData.append('column_school', this.columnMappings.school || '');
        formData.append('column_score', this.columnMappings.score || '');
        
        // Use the API URL from environment variables or fallback to localhost
        const apiUrl = import.meta.env.VITE_API_URL || 'http://localhost:8000';
        const response = await axios.post(`${apiUrl}/api/admin/import-results/`, formData, {
          headers: {
            'Content-Type': 'multipart/form-data'
          }
        });
        
        // Show success message
        alert('Results imported successfully!');
        
        // Reset form
        this.file = null;
        this.fileName = '';
        
        // Refresh recent imports
        this.fetchRecentImports();
      } catch (error) {
        console.error('Error importing results:', error);
        alert('Error importing results: ' + (error.response?.data?.error || error.message));
      } finally {
        this.isUploading = false;
      }
    },    // Fetch available years from API
    async fetchAvailableYears() {
      try {
        const apiUrl = import.meta.env.VITE_API_URL || 'http://localhost:8000';
        console.log('Attempting to fetch exam years from:', `${apiUrl}/api/exam-years/`);
        
        const response = await axios.get(`${apiUrl}/api/exam-years/`);
        
        if (response.data && Array.isArray(response.data)) {
          // Make sure years are strings and filter out any invalid values
          const validYears = response.data
            .filter(year => year && !isNaN(year)) // Filter out non-numeric values
            .map(year => year.toString());         // Convert to strings
          
          if (validYears.length > 0) {
            this.availableYears = validYears;
            console.log('Years fetched from API:', this.availableYears);
          } else {
            console.warn('API returned no valid years, using default years');
            this.generateDefaultYears();
          }
        } else {
          console.warn('API returned invalid data format for years:', response.data);
          this.generateDefaultYears();
        }
      } catch (error) {
        console.error('Error fetching available years:', error);
        // Ensure default years are available even after API failure
        this.generateDefaultYears();
      } finally {
        // Force update and check options in either case
        this.$forceUpdate();
        this.$nextTick(() => this.checkYearOptions());
      }
    },
      // Generate default list of years (current year and previous 9 years)
    generateDefaultYears() {
      // Explicitly set the years to ensure they are rendered
      this.availableYears = [
        '2025', '2024', '2023', '2022', '2021',
        '2020', '2019', '2018', '2017', '2016'
      ];
      
      console.log('Generated explicit default years:', this.availableYears);
      
      // Force update to ensure rendering
      this.$forceUpdate();
      
      // Log the current state of the DOM
      setTimeout(() => {
        console.log('Selected year value:', this.selectedYear);
        const selectElement = document.getElementById('yearSelect');
        if (selectElement) {
          console.log('Year options count:', selectElement.options.length);
          console.log('Option values:', Array.from(selectElement.options).map(o => o.value));
        } else {
          console.error('Year select element not found in DOM');
        }
      }, 500);
    },
    
    // Check the year options in the dropdown
    checkYearOptions() {
      setTimeout(() => {
        // Use ref or getElementById for more reliable selection
        const yearSelect = this.$refs.yearSelect || document.getElementById('yearSelect');
        
        if (yearSelect) {
          console.log('Year dropdown found, option count:', yearSelect.options.length);
          
          // Log all available options
          const options = Array.from(yearSelect.options);
          console.log('Available years in dropdown:', options.map(o => o.value).filter(v => v !== ''));
        } else {
          console.warn('Could not find year dropdown element');
        }
      }, 500);
    },
    
    // Helper to log the current state of year options in DOM
    logYearOptions(label = 'Current state') {
      console.log(`[${label}] Selected year:`, this.selectedYear);
      
      const selectElement = document.getElementById('yearSelect');
      if (selectElement) {
        const options = Array.from(selectElement.options);
        console.log(`[${label}] Year options in DOM:`, options.length);
        console.log(`[${label}] Year values:`, options.map(o => o.value));
        console.log(`[${label}] Year texts:`, options.map(o => o.text));
      } else {
        console.error(`[${label}] Year select element not found in DOM`);
      }
    },
    
    // Fetch recent imports from API
    async fetchRecentImports() {
      this.loadingImports = true;
      this.importError = null;
      
      try {
        const apiUrl = import.meta.env.VITE_API_URL || 'http://localhost:8000';
        const response = await axios.get(`${apiUrl}/api/admin/import-history/`);
        
        if (response.data && Array.isArray(response.data)) {
          // Ensure each import record has consistent properties
          this.recentImports = response.data.map(item => {
            return {
              examType: item.examType || item.exam_type || 'Unknown',
              date: item.date || item.import_date || new Date().toISOString(),
              successful: item.successful || item.success_count || 0,
              failed: item.failed || item.failure_count || 0
            };
          });
          
          console.log('Recent imports loaded:', this.recentImports);
        } else {
          console.warn('Unexpected API response format for import history:', response.data);
          this.generateSampleImports();
        }
      } catch (error) {
        console.error('Error fetching recent imports:', error);
        this.importError = 'Failed to load import history';
        this.generateSampleImports();
      } finally {
        this.loadingImports = false;
      }
    },
      // Generate sample import history data for demonstration
    generateSampleImports() {
      // Get current date in YYYY-MM-DD format
      const today = new Date().toISOString().split('T')[0];
      
      // Create dynamic sample data
      this.recentImports = [
        {
          examType: 'LSAT Exam',
          date: `${today} 14:30`,
          successful: 150,
          failed: 3
        },
        {
          examType: 'NAT Exam',
          date: `${today} 10:15`,
          successful: 200,
          failed: 5
        },
        {
          examType: 'CET Exam',
          date: `${today} 08:45`,
          successful: 180,
          failed: 2
        }
      ];
      
      console.log('Generated sample import history:', this.recentImports);
    },
    
    // Format date for display
    formatDate(dateString) {
      if (!dateString) return 'Unknown date';
      
      try {
        // Try to parse the date string
        let date;
        if (dateString.includes('T')) {
          // ISO format
          date = new Date(dateString);
        } else if (dateString.includes(' ')) {
          // Format like "2025-06-25 14:30"
          const [datePart, timePart] = dateString.split(' ');
          date = new Date(`${datePart}T${timePart}`);
        } else {
          // Just date
          date = new Date(dateString);
        }
        
        // Check if date is valid
        if (isNaN(date.getTime())) {
          return dateString; // Return as is if invalid
        }
        
        // Format date nicely
        return date.toLocaleDateString('en-US', {
          month: 'short',
          day: 'numeric',
          year: 'numeric',
          hour: '2-digit',
          minute: '2-digit',
          hour12: true
        });
      } catch (e) {
        console.error('Error formatting date:', e);
        return dateString; // Return as is if error
      }
    },
    
    // Get appropriate icon for exam type
    getExamIcon(examType) {
      if (!examType) return 'fas fa-file-alt';
      
      const examLower = examType.toLowerCase();
      
      if (examLower.includes('lsat')) return 'fas fa-balance-scale';
      if (examLower.includes('nat')) return 'fas fa-graduation-cap';
      if (examLower.includes('eat')) return 'fas fa-pencil-alt';
      if (examLower.includes('cet')) return 'fas fa-university';
      if (examLower.includes('let')) return 'fas fa-chalkboard-teacher';
      if (examLower.includes('nle')) return 'fas fa-user-nurse';
      if (examLower.includes('cle')) return 'fas fa-gavel';
      if (examLower.includes('cpe')) return 'fas fa-user-md';
      
      // Default icon
      return 'fas fa-file-alt';
    }  },
  created() {
    // Generate default years immediately during component creation
    this.generateDefaultYears();
    
    // Ensure a year is always selected (default to current year)
    const currentYear = new Date().getFullYear().toString();
    
    // Explicitly set the selected year 
    this.selectedYear = currentYear;
    
    console.log('Created hook - selected year set to:', this.selectedYear);
  },
    async mounted() {
    console.log('Component mounting, current year:', new Date().getFullYear());
    
    // Set default years immediately for quick rendering
    this.generateDefaultYears();
    
    // Double check the DOM immediately 
    this.logYearOptions('Initial mount');
    
    try {
      // Try to fetch data from API (but already have defaults)
      await this.fetchAvailableYears();
      await this.fetchRecentImports();
    } catch (error) {
      console.error('Error during data fetch:', error);
    }
    
    // Force a component update to ensure the view refreshes
    this.$forceUpdate();
    console.log('Component fully initialized');
    
    // Double check the DOM after a delay to ensure rendering is complete
    setTimeout(() => {
      this.logYearOptions('After 1s delay');
    }, 1000);
  },
  
  // Add watch to detect changes in the availableYears array
  watch: {
    availableYears: {
      handler(newVal) {
        console.log('availableYears changed:', newVal);
        this.$nextTick(() => {
          this.checkYearOptions();
        });
      },
      deep: true
    }
  }
}
</script>