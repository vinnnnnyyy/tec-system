<template>
  <div class="min-h-screen bg-gray-50 py-4">
    <div class="container mx-auto px-4 max-w-7xl">
      <!-- Header Section -->
      <div class="mb-4">
        <div class="flex items-center space-x-3">
          <div class="p-2 bg-crimson-100 rounded-lg">
            <i class="fas fa-file-import text-2xl text-crimson-600"></i>
          </div>
          <div>
            <h1 class="text-2xl font-bold text-gray-900">Admin: Import Exam Results</h1>
            <p class="text-sm text-gray-600">Upload and import examination results for public release. Results will be available for public search by application number.</p>
          </div>
        </div>
      </div>

      <!-- Error message with login button -->
      <div v-if="error" class="bg-red-50 border border-red-200 rounded-lg p-4 mb-4">
        <div class="flex flex-col sm:flex-row sm:items-center gap-3">
          <div class="flex items-center">
            <i class="fas fa-exclamation-circle text-red-500 mr-2"></i>
            <p class="text-red-700">{{ error }}</p>
          </div>
          <a href="/admin/login" class="inline-flex items-center px-4 py-2 bg-crimson-600 text-white rounded-lg text-sm hover:bg-crimson-700 transition-colors">
            <i class="fas fa-sign-in-alt mr-2"></i>
            Go to Login
          </a>
        </div>
      </div>

      <!-- Main Content -->
      <div class="grid grid-cols-1 lg:grid-cols-12 gap-4">
        <!-- Upload Section -->
        <div class="lg:col-span-8">
          <div class="bg-white rounded-lg shadow p-4">
            <div class="mb-4">
              <div class="flex items-center justify-between mb-2">
                <h2 class="text-lg font-semibold text-gray-900">Upload Results File</h2>
                <span class="text-sm px-2 py-1 bg-blue-50 text-blue-700 rounded-full">Step 1 of 2</span>
              </div>
              <p class="text-sm text-gray-600 mb-3">Upload your CSV or Excel file containing the exam results</p>
              
              <!-- File Upload Area -->
              <div class="border-2 border-dashed border-gray-300 rounded-lg p-6 text-center hover:border-crimson-500 transition-all duration-200 cursor-pointer"
                   @dragover.prevent="dragover = true"
                   @dragleave.prevent="dragover = false"
                   @drop.prevent="onFileDrop"
                   :class="{ 'border-crimson-500 bg-crimson-50/30': dragover }"
                   @click="$refs.fileInput.click()">
                <div class="space-y-3">
                  <div class="w-16 h-16 mx-auto bg-crimson-50 rounded-full flex items-center justify-center transform transition-transform duration-200"
                       :class="{ 'scale-110': dragover }">
                    <i class="fas fa-file-upload text-2xl text-crimson-600"></i>
                  </div>
                  <div>
                    <p class="text-sm text-gray-600">Drag and drop your file here, or</p>
                    <label class="mt-2 inline-flex items-center px-4 py-2 bg-crimson-600 text-white rounded-lg hover:bg-crimson-700 transition-colors duration-200 cursor-pointer text-sm">
                      <i class="fas fa-folder-open mr-2"></i>
                      Browse Files
                      <input ref="fileInput" type="file" class="hidden" accept=".csv,.xlsx,.xls" @change="onFileSelect">
                    </label>
                    <p class="mt-2 text-sm text-gray-500">Supported formats: CSV, Excel (.xlsx, .xls)</p>
                  </div>
                </div>
              </div>
              
              <!-- File preview if selected -->
              <div v-if="selectedFile" class="mt-3 p-3 bg-gray-50 rounded-lg flex items-center justify-between animate-fade-in">
                <div class="flex items-center space-x-3">
                  <div class="w-10 h-10 bg-green-50 rounded-lg flex items-center justify-center">
                    <i class="fas fa-file-excel text-green-600 text-xl"></i>
                  </div>
                  <div>
                    <p class="font-medium text-sm text-gray-900">{{ selectedFile.name }}</p>
                    <p class="text-sm text-gray-500">{{ formatFileSize(selectedFile.size) }}</p>
                  </div>
                </div>
                <button @click.stop="selectedFile = null" 
                        class="p-2 text-gray-500 hover:text-crimson-600 hover:bg-gray-100 rounded-lg transition-colors duration-200">
                  <i class="fas fa-times"></i>
                </button>
              </div>
            </div>

            <!-- Import Settings -->
            <div class="space-y-4">
              <div class="flex items-center justify-between">
                <h3 class="text-base font-semibold text-gray-900">Import Settings</h3>
                <span class="text-sm px-2 py-1 bg-blue-50 text-blue-700 rounded-full">Step 2 of 2</span>
              </div>
              
              <!-- Exam Type Selection -->
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Select Exam Type</label>
                <select v-model="selectedExamType" 
                        class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-crimson-500 transition-colors duration-200 text-sm">
                  <option value="">Choose an exam type</option>
                  <option v-for="exam in examTypes" :key="exam.value" :value="exam.value">{{ exam.label }}</option>
                </select>
              </div>
              
              <!-- Exam Year Selection -->
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Select Exam Year</label>
                <select v-model="selectedExamYear" 
                        class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-crimson-500 transition-colors duration-200 text-sm">
                  <option value="">Choose an exam year</option>
                  <option v-for="year in sortedAvailableYears" :key="year" :value="year">{{ year }}</option>
                </select>
              </div>

              <!-- Import Button -->
              <div class="pt-2">
                <button 
                  @click="startImport"
                  :disabled="!isReadyToImport"
                  :class="[
                    'w-full px-4 py-2.5 rounded-lg flex items-center justify-center space-x-2 transition-all duration-200 text-sm',
                    isReadyToImport 
                      ? 'bg-crimson-600 text-white hover:bg-crimson-700 hover:shadow-md' 
                      : 'bg-gray-300 text-gray-500 cursor-not-allowed'
                  ]">
                  <i class="fas fa-upload"></i>
                  <span>Start Import</span>
                </button>
              </div>
            </div>
          </div>
        </div>

        <!-- Import History & Guidelines -->
        <div class="lg:col-span-4 space-y-4">
          <!-- Import Guidelines -->
          <div class="bg-white rounded-lg shadow p-4">
            <div class="flex items-center space-x-3 mb-3">
              <div class="p-2 bg-crimson-100 rounded-lg">
                <i class="fas fa-info-circle text-crimson-600 text-lg"></i>
              </div>
              <h2 class="text-base font-semibold text-gray-900">Import Guidelines</h2>
            </div>
            <div class="space-y-3">
              <div class="flex items-start space-x-3">
                <div class="w-6 h-6 rounded-full bg-crimson-100 flex items-center justify-center flex-shrink-0 mt-0.5">
                  <i class="fas fa-list text-crimson-600 text-sm"></i>
                </div>
                <p class="text-sm text-gray-600">CSV columns must be in this exact order: NO, APP_NO, NAME, SCHOOL</p>
              </div>
              <div class="flex items-start space-x-3">
                <div class="w-6 h-6 rounded-full bg-crimson-100 flex items-center justify-center flex-shrink-0 mt-0.5">
                  <i class="fas fa-user text-crimson-600 text-sm"></i>
                </div>
                <p class="text-sm text-gray-600">Use the simple format: NO (serial number), APP_NO (application number), NAME (full name), SCHOOL (school name)</p>
              </div>
              <div class="flex items-start space-x-3">
                <div class="w-6 h-6 rounded-full bg-crimson-100 flex items-center justify-center flex-shrink-0 mt-0.5">
                  <i class="fas fa-check-circle text-crimson-600 text-sm"></i>
                </div>
                <p class="text-sm text-gray-600">Results will be stored for public viewing and lookup by application number</p>
              </div>
              <div class="flex items-start space-x-3">
                <div class="w-6 h-6 rounded-full bg-crimson-100 flex items-center justify-center flex-shrink-0 mt-0.5">
                  <i class="fas fa-calendar text-crimson-600 text-sm"></i>
                </div>
                <p class="text-sm text-gray-600">This is for importing exam results (pass/fail status) for public release, not detailed scores with test parts and OAPR</p>
              </div>
              <div class="flex items-start space-x-3">
                <div class="w-6 h-6 rounded-full bg-crimson-100 flex items-center justify-center flex-shrink-0 mt-0.5">
                  <i class="fas fa-exclamation-triangle text-crimson-600 text-sm"></i>
                </div>
                <p class="text-sm text-gray-600">Maximum file size: 10MB</p>
              </div>
            </div>
          </div>

          <!-- Recent Imports -->
          <div class="bg-white rounded-lg shadow p-4">
            <div class="flex items-center justify-between mb-3">
              <div class="flex items-center space-x-3">
                <div class="p-2 bg-crimson-100 rounded-lg">
                  <i class="fas fa-history text-crimson-600 text-lg"></i>
                </div>
                <h2 class="text-base font-semibold text-gray-900">Recent Imports</h2>
              </div>
              <button class="text-sm text-blue-600 hover:text-blue-800">View All</button>
            </div>
            <div class="space-y-2">
              <div v-for="(import_, index) in recentImports" :key="index" 
                   class="p-3 bg-gray-50 rounded-lg hover:bg-gray-100 transition-colors duration-200">
                <div class="flex items-center justify-between">
                  <span class="text-sm font-medium text-gray-900">{{ import_.examType }}</span>
                  <span class="text-sm text-gray-500">{{ import_.date }}</span>
                </div>
                <div class="flex items-center space-x-3 text-sm mt-1">
                  <span class="text-green-600 bg-green-50 px-2 py-1 rounded-full">
                    <i class="fas fa-check-circle mr-1"></i>
                    {{ import_.successful }}
                  </span>
                  <span class="text-red-600 bg-red-50 px-2 py-1 rounded-full">
                    <i class="fas fa-times-circle mr-1"></i>
                    {{ import_.failed }}
                  </span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Add loading state -->
      <div v-if="loading" class="text-center py-4">
        <div class="inline-block animate-spin rounded-full h-8 w-8 border-4 border-crimson-600 border-t-transparent"></div>
        <p class="mt-2 text-gray-600">Loading program codes...</p>
      </div>
    </div>
  </div>
</template>

<script>
import axiosInstance from '../../../services/axios.interceptor';
import { useToast } from '../../../composables/useToast';

export default {
  name: 'ExamResultsImport',
  setup() {
    const { showToast } = useToast();
    return { showToast };
  },  data() {
    return {
      dragover: false,
      selectedFile: null,
      selectedExamType: '',
      selectedExamYear: new Date().getFullYear().toString(), // Default to current year
      examTypes: [], // Will be populated from backend
      loading: false,
      error: null,
      recentImports: [
        {
          examType: 'LSAT Exam',
          date: '2024-03-15 14:30',
          successful: 150,
          failed: 3
        },
        {
          examType: 'NAT Exam',
          date: '2024-03-14 16:45',
          successful: 200,
          failed: 5
        },
        {
          examType: 'EAT Exam',
          date: '2024-03-13 09:15',
          successful: 180,
          failed: 2
        }
      ]
    }
  },  computed: {
    isReadyToImport() {
      return this.selectedFile && this.selectedExamType && this.selectedExamYear;
    },
    
    // Static year range from 2015 to 2035
    sortedAvailableYears() {
      return [
        '2035', '2034', '2033', '2032', '2031', '2030', '2029', '2028', '2027', '2026',
        '2025', '2024', '2023', '2022', '2021', '2020', '2019', '2018', '2017', '2016', '2015'
      ];
    }
  },
  methods: {
    async checkAuthStatus() {
      const token = localStorage.getItem('token') || 
                   localStorage.getItem('access_token') || 
                   localStorage.getItem('authToken');
      
      if (!token) {
        this.error = 'You must be logged in to import exam results. Please log in to your admin account first.';
        return false;
      }
      
      try {
        // Use axiosInstance which handles authentication and API URL
        await axiosInstance.get('/api/admin/test-sessions/');
        return true;
      } catch (error) {
        console.error('Auth error:', error);
        if (error.response && error.response.status === 401) {
          this.error = 'Your session has expired. Please log in again.';
          // Clear invalid tokens
          localStorage.removeItem('token');
          localStorage.removeItem('access_token');
          localStorage.removeItem('authToken');
        } else {
          this.error = 'Authentication error. Please try logging in again.';
        }
        return false;
      }
    },
    async fetchProgramCodes() {
      this.loading = true;
      this.error = null;
      try {
        // Use the axios interceptor which handles API URL and authentication
        const response = await axiosInstance.get('/api/programs/');
        console.log('API Response:', response.data); // Debug log
        
        // Check if response.data is an array
        if (Array.isArray(response.data)) {
          this.examTypes = response.data.map(program => ({
            value: program.code,
            label: `${program.code} - ${program.name}`
          }));
        } else if (response.data.results && Array.isArray(response.data.results)) {
          // Handle paginated response
          this.examTypes = response.data.results.map(program => ({
            value: program.code,
            label: `${program.code} - ${program.name}`
          }));
        } else {
          console.error('Unexpected response format:', response.data);
          this.error = 'Invalid response format from server';
        }
      } catch (error) {
        console.error('Error fetching program codes:', error);
        if (error.response) {
          // The request was made and the server responded with a status code
          // that falls out of the range of 2xx
          console.error('Error response:', error.response.data);
          console.error('Error status:', error.response.status);
          this.error = `Server error: ${error.response.status} - ${error.response.data.error || 'Unknown error'}`;
        } else if (error.request) {
          // The request was made but no response was received
          console.error('No response received:', error.request);
          this.error = 'No response from server. Please check if the backend server is running.';
        } else {
          // Something happened in setting up the request that triggered an Error
          console.error('Error setting up request:', error.message);
          this.error = 'Error setting up request. Please try again.';
        }
      } finally {
        this.loading = false;
      }    },    
    // Dummy implementation to prevent errors from old references
    fetchAvailableYears() {
      console.log('Using static year range instead of API call');
      return Promise.resolve([]);
    },
    onFileSelect(event) {
      const file = event.target.files[0];
      if (file) {
        this.validateAndSetFile(file);
      }
    },
    onFileDrop(event) {
      this.dragover = false;
      const file = event.dataTransfer.files[0];
      if (file) {
        this.validateAndSetFile(file);
      }
    },
    validateAndSetFile(file) {
      // Check file type
      const validTypes = ['.csv', '.xlsx', '.xls'];
      const fileExtension = '.' + file.name.split('.').pop().toLowerCase();
      
      if (!validTypes.includes(fileExtension)) {
        alert('Invalid file type. Please upload a CSV or Excel file.');
        return;
      }
      
      // Check file size (10MB limit)
      const maxSize = 10 * 1024 * 1024; // 10MB in bytes
      if (file.size > maxSize) {
        alert('File is too large. Maximum size is 10MB.');
        return;
      }
      
      this.selectedFile = file;
    },
    formatFileSize(bytes) {
      if (bytes < 1024) {
        return bytes + ' B';
      } else if (bytes < 1024 * 1024) {
        return (bytes / 1024).toFixed(2) + ' KB';
      } else {
        return (bytes / (1024 * 1024)).toFixed(2) + ' MB';
      }
    },
    
    async startImport() {
      if (!this.isReadyToImport) {
        return;
      }
      
      this.loading = true;
      this.error = null;
      
      // Verify authentication first
      const isAuthenticated = await this.checkAuthStatus();
      if (!isAuthenticated) {
        this.loading = false;
        return;
      }
      
      try {
        // Create FormData for file upload
        const formData = new FormData();
        formData.append('file', this.selectedFile);
        formData.append('examType', this.selectedExamType);
        formData.append('year', this.selectedExamYear);
        
        // Debug logging
        console.log('Sending import request with:');
        console.log('- File:', this.selectedFile.name);
        console.log('- Exam Type:', this.selectedExamType);
        console.log('- Year:', this.selectedExamYear);
        
        // Send to the exam results import API endpoint (NOT scores import)
        const response = await axiosInstance.post(
          '/api/admin/results/import/',
          formData,
          {
            headers: {
              'Content-Type': 'multipart/form-data'
            }
          }
        );
        
        console.log('Import response:', response.data);
        
        if (response.data.success) {
          // Add to recent imports
          const newImport = {
            examType: `${this.selectedExamType} (${this.selectedExamYear})`,
            date: new Date().toLocaleString(),
            successful: response.data.created_count || response.data.count,
            failed: 0
          };
          
          this.recentImports.unshift(newImport);
          
          this.showToast(`Successfully imported ${response.data.created_count || response.data.count} records.`, 'success');
          
          // Reset form
          this.selectedFile = null;
          this.selectedExamType = '';
          this.selectedExamYear = new Date().getFullYear().toString();
        } else {
          this.error = response.data.error || 'Import failed';
          this.showToast(this.error, 'error');
        }
        
      } catch (error) {
        console.error('Error during import:', error);
        this.error = error.response?.data?.error || 'Error processing file';
        this.showToast(this.error, 'error');
      } finally {
        this.loading = false;
      }
    }
  },  created() {
    // Fetch program codes
    this.fetchProgramCodes();
  },
  mounted() {
    // Check for authentication when component mounts
    this.checkAuthStatus();
  }
}
</script>

<style scoped>
.animate-fade-in {
  animation: fadeIn 0.3s ease-in-out;
}

@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(-10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}
</style>