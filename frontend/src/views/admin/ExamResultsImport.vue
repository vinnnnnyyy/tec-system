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
              <div class="border-2 border-dashed border-gray-300 rounded-xl p-8 text-center hover:border-crimson-500 transition-colors duration-200">
                <div class="space-y-4">
                  <div class="w-16 h-16 mx-auto bg-crimson-50 rounded-full flex items-center justify-center">
                    <i class="fas fa-file-upload text-2xl text-crimson-600"></i>
                  </div>
                  <div>
                    <p class="text-sm text-gray-600">Drag and drop your file here, or</p>
                    <label class="mt-2 inline-flex items-center px-4 py-2 bg-crimson-600 text-white rounded-lg hover:bg-crimson-700 transition-colors duration-200 cursor-pointer">
                      <i class="fas fa-folder-open mr-2"></i>
                      Browse Files
                      <input type="file" class="hidden" accept=".csv,.xlsx,.xls">
                    </label>
                    <p class="mt-2 text-xs text-gray-500">Supported formats: CSV, Excel (.xlsx, .xls)</p>
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
                <select class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-crimson-500">
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
              </div>

              <!-- File Format Settings -->
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">File Format Settings</label>
                <div class="space-y-4">
                  <div class="flex items-center space-x-4">
                    <div class="flex-1">
                      <label class="block text-sm text-gray-600 mb-1">Column for Application Number</label>
                      <select class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-crimson-500">
                        <option value="">Select column</option>
                        <option value="A">Column A</option>
                        <option value="B">Column B</option>
                        <option value="C">Column C</option>
                      </select>
                    </div>
                    <div class="flex-1">
                      <label class="block text-sm text-gray-600 mb-1">Column for Full Name</label>
                      <select class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-crimson-500">
                        <option value="">Select column</option>
                        <option value="A">Column A</option>
                        <option value="B">Column B</option>
                        <option value="C">Column C</option>
                      </select>
                    </div>
                  </div>
                  <div class="flex items-center space-x-4">
                    <div class="flex-1">
                      <label class="block text-sm text-gray-600 mb-1">Column for School</label>
                      <select class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-crimson-500">
                        <option value="">Select column</option>
                        <option value="A">Column A</option>
                        <option value="B">Column B</option>
                        <option value="C">Column C</option>
                      </select>
                    </div>
                    <div class="flex-1">
                      <label class="block text-sm text-gray-600 mb-1">Column for Score (Optional)</label>
                      <select class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-crimson-500">
                        <option value="">Select column</option>
                        <option value="A">Column A</option>
                        <option value="B">Column B</option>
                        <option value="C">Column C</option>
                      </select>
                    </div>
                  </div>
                </div>
              </div>

              <!-- Import Button -->
              <div class="pt-4">
                <button class="w-full px-6 py-3 bg-crimson-600 text-white rounded-lg hover:bg-crimson-700 transition-colors duration-200 flex items-center justify-center space-x-2">
                  <i class="fas fa-upload"></i>
                  <span>Start Import</span>
                </button>
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
          </div>

          <!-- Recent Imports -->
          <div class="bg-white rounded-xl shadow-lg p-6">
            <h2 class="text-xl font-semibold text-gray-900 mb-4">Recent Imports</h2>
            <div class="space-y-4">
              <div v-for="(import_, index) in recentImports" :key="index" 
                   class="p-4 bg-gray-50 rounded-lg">
                <div class="flex items-center justify-between mb-2">
                  <span class="text-sm font-medium text-gray-900">{{ import_.examType }}</span>
                  <span class="text-xs text-gray-500">{{ import_.date }}</span>
                </div>
                <div class="flex items-center space-x-4 text-sm">
                  <span class="text-green-600">
                    <i class="fas fa-check-circle mr-1"></i>
                    {{ import_.successful }}
                  </span>
                  <span class="text-red-600">
                    <i class="fas fa-times-circle mr-1"></i>
                    {{ import_.failed }}
                  </span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'ExamResultsImport',
  data() {
    return {
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
  }
}
</script> 