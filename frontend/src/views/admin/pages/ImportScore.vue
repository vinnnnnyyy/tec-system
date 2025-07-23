<template>
  <div class="min-h-screen bg-gray-50 py-4">
    <div class="container mx-auto px-4 max-w-7xl">
      <!-- Header Section -->
      <div class="mb-4">
        <div class="flex items-center space-x-3">
          <div class="p-2 bg-crimson-100 rounded-lg">
            <i class="fas fa-file-contract text-2xl text-crimson-600"></i>
          </div>
          <div>
            <h1 class="text-2xl font-bold text-gray-900">Admin: Import Exam Scores</h1>
            <p class="text-sm text-gray-600">Upload and import individual examination scores for different exam types. Scores will be available to registered users.</p>
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

      <!-- Tab Navigation -->
      <div class="mb-6">
        <div class="border-b border-gray-200">
          <nav class="-mb-px flex space-x-8">
            <button 
              @click="activeTab = 'import'"
              :class="[
                'py-2 px-1 border-b-2 font-medium text-sm',
                activeTab === 'import' 
                  ? 'border-crimson-500 text-crimson-600' 
                  : 'border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300'
              ]"
            >
              <i class="fas fa-upload mr-2"></i>
              Import Scores
            </button>
            <button 
              @click="activeTab = 'unmatched'"
              :class="[
                'py-2 px-1 border-b-2 font-medium text-sm',
                activeTab === 'unmatched' 
                  ? 'border-crimson-500 text-crimson-600' 
                  : 'border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300'
              ]"
            >
              <i class="fas fa-exclamation-triangle mr-2"></i>
              Unmatched Scores
              <span v-if="unmatchedScores.length > 0" class="ml-2 inline-flex items-center justify-center px-2 py-1 text-xs font-bold leading-none text-red-100 bg-red-600 rounded-full">
                {{ unmatchedScores.length }}
              </span>
            </button>
          </nav>
        </div>
      </div>

      <!-- Main Content Tabs -->
      <div v-show="activeTab === 'import'">
        <!-- Import Tab Content -->
      <div class="grid grid-cols-1 lg:grid-cols-12 gap-4">
        <!-- Upload Section -->
        <div class="lg:col-span-8">
          <div class="bg-white rounded-lg shadow p-4">
            <div class="mb-4">
              <div class="flex items-center justify-between mb-2">
                <h2 class="text-lg font-semibold text-gray-900">Upload Score File</h2>
                <span class="text-sm px-2 py-1 bg-blue-50 text-blue-700 rounded-full">Step 1 of 2</span>
              </div>
              <p class="text-sm text-gray-600 mb-3">Upload your CSV or Excel file containing the exam scores</p>
              
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
                        class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-crimson-500 transition-colors duration-200 text-sm"
                        @change="updateSelectedProgramId">
                  <option value="">Choose an exam type</option>
                  <option v-for="exam in examTypes" :key="exam.value" :value="exam.value">{{ exam.label }}</option>
                </select>
                <p v-if="selectedProgramId" class="mt-1 text-xs text-green-600">
                  <i class="fas fa-check-circle mr-1"></i>
                  Program ID: {{ selectedProgramId }} (Will be used to match appointments)
                </p>
                <p v-else-if="selectedExamType" class="mt-1 text-xs text-amber-600">
                  <i class="fas fa-exclamation-circle mr-1"></i>
                  No program ID found for this exam type. Matching might be less accurate.
                </p>
              </div>

              <!-- Exam Year Selection -->
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Select Exam Year</label>
                <select v-model="selectedExamYear" 
                        class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-crimson-500 transition-colors duration-200 text-sm">
                  <option value="">Choose an exam year</option>
                  <option v-for="year in availableYears" :key="year" :value="year">{{ year }}</option>
                </select>              </div>
              
              <!-- Validation Message -->
              <div v-if="!isReadyToImport && missingFields.length > 0" 
                   class="text-amber-600 text-sm py-1 flex items-center">
                <i class="fas fa-exclamation-circle mr-1"></i>
                {{ validationMessage }}
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
                  <i class="fas fa-info text-crimson-600 text-sm"></i>
                </div>
                <p class="text-sm text-gray-600">Your file should include all test part scores and identifiers (name fields, school, and app_no are required)</p>
              </div>
              <div class="flex items-start space-x-3">
                <div class="w-6 h-6 rounded-full bg-crimson-100 flex items-center justify-center flex-shrink-0 mt-0.5">
                  <i class="fas fa-table text-crimson-600 text-sm"></i>
                </div>
                <p class="text-sm text-gray-600">CSV columns: app_no, lastname, firstname, middlename, school, date, part1, part2, part3, part4, part5, oapr</p>
              </div>
              <div class="flex items-start space-x-3">
                <div class="w-6 h-6 rounded-full bg-crimson-100 flex items-center justify-center flex-shrink-0 mt-0.5">
                  <i class="fas fa-font text-crimson-600 text-sm"></i>
                </div>
                <p class="text-sm text-gray-600">All text data in columns (lastname, firstname, middlename, school) must be CAPITALIZED for easy parsing</p>
              </div>
              
              <!-- Sample CSV Format -->
              <div class="rounded-md bg-gray-50 p-3 border border-gray-200 text-xs font-mono overflow-x-auto whitespace-nowrap">
                app_no,lastname,firstname,middlename,school,date,part1,part2,part3,part4,part5,oapr<br>
                123-456,DOE,JOHN,ANTONIO,SAMPLE SCHOOL,2023-10-15,85,92,88,95,90,90<br>
                789-012,SMITH,JANE,MARIE,TEST ACADEMY,2023-10-15,92,88,90,87,94,92
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
                <h2 class="text-base font-semibold text-gray-900">Recent Score Imports</h2>
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
      </div>

      <!-- Unmatched Scores Tab Content -->
      <div v-show="activeTab === 'unmatched'">
        <div class="bg-white rounded-lg shadow p-6">
          <div class="flex items-center justify-between mb-6">
            <div>
              <h2 class="text-xl font-bold text-gray-900">Unmatched Scores</h2>
              <p class="text-sm text-gray-600 mt-1">Scores that couldn't be automatically matched to student applications</p>
            </div>
            <div class="flex items-center space-x-3">
              <button @click="refreshUnmatchedScores" 
                      class="px-4 py-2 text-sm bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors">
                <i class="fas fa-sync-alt mr-2"></i>
                Refresh
              </button>
              <button @click="exportUnmatchedScores" 
                      :disabled="unmatchedScores.length === 0"
                      class="px-4 py-2 text-sm bg-gray-600 text-white rounded-lg hover:bg-gray-700 transition-colors disabled:bg-gray-300 disabled:cursor-not-allowed">
                <i class="fas fa-download mr-2"></i>
                Export CSV
              </button>
            </div>
          </div>

          <!-- Search and Filter -->
          <div class="mb-6 bg-gray-50 p-4 rounded-lg">
            <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Search by Name</label>
                <input v-model="searchQuery" 
                       type="text" 
                       placeholder="Search by name or app number..." 
                       class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-crimson-500">
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Filter by Exam Type</label>
                <select v-model="filterExamType" 
                        class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-crimson-500">
                  <option value="">All Exam Types</option>
                  <option v-for="type in uniqueExamTypes" :key="type" :value="type">{{ type }}</option>
                </select>
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Filter by Year</label>
                <select v-model="filterYear" 
                        class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-crimson-500">
                  <option value="">All Years</option>
                  <option v-for="year in uniqueYears" :key="year" :value="year">{{ year }}</option>
                </select>
              </div>
            </div>
          </div>

          <!-- Statistics -->
          <div class="grid grid-cols-1 md:grid-cols-4 gap-4 mb-6">
            <div class="bg-blue-50 p-4 rounded-lg">
              <div class="flex items-center">
                <div class="p-2 bg-blue-100 rounded-lg">
                  <i class="fas fa-list text-blue-600"></i>
                </div>
                <div class="ml-3">
                  <p class="text-sm font-medium text-blue-800">Total Unmatched</p>
                  <p class="text-lg font-bold text-blue-900">{{ filteredUnmatchedScores.length }}</p>
                </div>
              </div>
            </div>
            <div class="bg-yellow-50 p-4 rounded-lg">
              <div class="flex items-center">
                <div class="p-2 bg-yellow-100 rounded-lg">
                  <i class="fas fa-user-check text-yellow-600"></i>
                </div>
                <div class="ml-3">
                  <p class="text-sm font-medium text-yellow-800">Manually Matched</p>
                  <p class="text-lg font-bold text-yellow-900">{{ manuallyMatchedCount }}</p>
                </div>
              </div>
            </div>
            <div class="bg-green-50 p-4 rounded-lg">
              <div class="flex items-center">
                <div class="p-2 bg-green-100 rounded-lg">
                  <i class="fas fa-check-circle text-green-600"></i>
                </div>
                <div class="ml-3">
                  <p class="text-sm font-medium text-green-800">Successfully Matched</p>
                  <p class="text-lg font-bold text-green-900">{{ successfullyMatchedCount }}</p>
                </div>
              </div>
            </div>
            <div class="bg-red-50 p-4 rounded-lg">
              <div class="flex items-center">
                <div class="p-2 bg-red-100 rounded-lg">
                  <i class="fas fa-exclamation-triangle text-red-600"></i>
                </div>
                <div class="ml-3">
                  <p class="text-sm font-medium text-red-800">Pending Match</p>
                  <p class="text-lg font-bold text-red-900">{{ pendingMatchCount }}</p>
                </div>
              </div>
            </div>
          </div>

          <!-- Unmatched Scores Table -->
          <div v-if="filteredUnmatchedScores.length > 0" class="overflow-x-auto">
            <table class="w-full border border-gray-200 rounded-lg overflow-hidden">
              <thead class="bg-gray-50">
                <tr>
                  <th class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">App No</th>
                  <th class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Name</th>
                  <th class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">School</th>
                  <th class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Exam Type</th>
                  <th class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Year</th>
                  <th class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Overall Score</th>
                  <th class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Status</th>
                  <th class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Actions</th>
                </tr>
              </thead>
              <tbody class="divide-y divide-gray-200">
                <tr v-for="score in paginatedUnmatchedScores" :key="score.id" class="hover:bg-gray-50">
                  <td class="px-4 py-3 text-sm font-medium text-gray-900">{{ score.app_no || 'N/A' }}</td>
                  <td class="px-4 py-3 text-sm text-gray-900">{{ score.name || 'N/A' }}</td>
                  <td class="px-4 py-3 text-sm text-gray-900">{{ score.school || 'N/A' }}</td>
                  <td class="px-4 py-3 text-sm text-gray-900">{{ score.exam_type || 'N/A' }}</td>
                  <td class="px-4 py-3 text-sm text-gray-900">{{ score.year || 'N/A' }}</td>
                  <td class="px-4 py-3 text-sm text-gray-900">{{ score.score || 'N/A' }}</td>
                  <td class="px-4 py-3 text-sm">
                    <span v-if="score.appointment_id" class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-green-100 text-green-800">
                      <i class="fas fa-check-circle mr-1"></i>
                      Matched
                    </span>
                    <span v-else class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-red-100 text-red-800">
                      <i class="fas fa-exclamation-triangle mr-1"></i>
                      Unmatched
                    </span>
                  </td>
                  <td class="px-4 py-3 text-sm">
                    <div class="flex items-center space-x-2">
                      <button @click="openManualMatchModal(score)" 
                              class="text-blue-600 hover:text-blue-800 bg-blue-50 hover:bg-blue-100 px-2 py-1 rounded text-xs transition-colors">
                        <i class="fas fa-link mr-1"></i>
                        Match
                      </button>
                      <button @click="viewScoreDetails(score)" 
                              class="text-gray-600 hover:text-gray-800 bg-gray-50 hover:bg-gray-100 px-2 py-1 rounded text-xs transition-colors">
                        <i class="fas fa-eye mr-1"></i>
                        View
                      </button>
                    </div>
                  </td>
                </tr>
              </tbody>
            </table>

            <!-- Pagination -->
            <div class="flex items-center justify-between px-4 py-3 bg-white border-t border-gray-200">
              <div class="flex-1 flex justify-between sm:hidden">
                <button @click="previousPage" 
                        :disabled="currentPage === 1"
                        class="relative inline-flex items-center px-4 py-2 border border-gray-300 text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50 disabled:bg-gray-100 disabled:cursor-not-allowed">
                  Previous
                </button>
                <button @click="nextPage" 
                        :disabled="currentPage === totalPages"
                        class="ml-3 relative inline-flex items-center px-4 py-2 border border-gray-300 text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50 disabled:bg-gray-100 disabled:cursor-not-allowed">
                  Next
                </button>
              </div>
              <div class="hidden sm:flex-1 sm:flex sm:items-center sm:justify-between">
                <div>
                  <p class="text-sm text-gray-700">
                    Showing
                    <span class="font-medium">{{ startIndex + 1 }}</span>
                    to
                    <span class="font-medium">{{ Math.min(endIndex, filteredUnmatchedScores.length) }}</span>
                    of
                    <span class="font-medium">{{ filteredUnmatchedScores.length }}</span>
                    results
                  </p>
                </div>
                <div>
                  <nav class="relative z-0 inline-flex rounded-md shadow-sm -space-x-px">
                    <button @click="previousPage" 
                            :disabled="currentPage === 1"
                            class="relative inline-flex items-center px-2 py-2 rounded-l-md border border-gray-300 bg-white text-sm font-medium text-gray-500 hover:bg-gray-50 disabled:bg-gray-100 disabled:cursor-not-allowed">
                      <i class="fas fa-chevron-left"></i>
                    </button>
                    <button v-for="page in visiblePages" 
                            :key="page"
                            @click="goToPage(page)"
                            :class="[
                              'relative inline-flex items-center px-4 py-2 border text-sm font-medium',
                              page === currentPage 
                                ? 'z-10 bg-crimson-50 border-crimson-500 text-crimson-600'
                                : 'bg-white border-gray-300 text-gray-500 hover:bg-gray-50'
                            ]">
                      {{ page }}
                    </button>
                    <button @click="nextPage" 
                            :disabled="currentPage === totalPages"
                            class="relative inline-flex items-center px-2 py-2 rounded-r-md border border-gray-300 bg-white text-sm font-medium text-gray-500 hover:bg-gray-50 disabled:bg-gray-100 disabled:cursor-not-allowed">
                      <i class="fas fa-chevron-right"></i>
                    </button>
                  </nav>
                </div>
              </div>
            </div>
          </div>

          <!-- Empty State -->
          <div v-else class="text-center py-12">
            <div class="w-24 h-24 mx-auto bg-gray-100 rounded-full flex items-center justify-center mb-4">
              <i class="fas fa-check-circle text-4xl text-green-500"></i>
            </div>
            <h3 class="text-lg font-medium text-gray-900 mb-2">No Unmatched Scores</h3>
            <p class="text-gray-500 mb-4">All imported scores have been successfully matched to student applications.</p>
          </div>
        </div>
      </div>
      
      <!-- Add loading state -->
      <div v-if="loading" class="text-center py-4">
        <div class="inline-block animate-spin rounded-full h-8 w-8 border-4 border-crimson-600 border-t-transparent"></div>
        <p class="mt-2 text-gray-600">Loading program codes...</p>
      </div>
    </div>
    
    <!-- Manual Match Modal -->
    <div v-if="showManualMatchModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
      <div class="bg-white rounded-xl shadow-xl w-full max-w-4xl mx-4 max-h-[90vh] overflow-y-auto">
        <div class="p-6">
          <div class="flex justify-between items-center mb-6">
            <div>
              <h3 class="text-lg font-bold text-gray-900">Manual Score Matching</h3>
              <p class="text-sm text-gray-600 mt-1">Match this score to a student appointment</p>
            </div>
            <button @click="showManualMatchModal = false" 
                    class="text-gray-400 hover:text-gray-600 p-2">
              <i class="fas fa-times text-xl"></i>
            </button>
          </div>
          
          <!-- Score Information -->
          <div v-if="selectedScoreForMatching" class="bg-gray-50 p-4 rounded-lg mb-6">
            <h4 class="font-medium text-gray-900 mb-3">Score Information</h4>
            <div class="grid grid-cols-2 md:grid-cols-4 gap-4 text-sm">
              <div>
                <span class="text-gray-600">App No:</span>
                <p class="font-medium">{{ selectedScoreForMatching.app_no || 'N/A' }}</p>
              </div>
              <div>
                <span class="text-gray-600">Name:</span>
                <p class="font-medium">{{ selectedScoreForMatching.name || 'N/A' }}</p>
              </div>
              <div>
                <span class="text-gray-600">School:</span>
                <p class="font-medium">{{ selectedScoreForMatching.school || 'N/A' }}</p>
              </div>
              <div>
                <span class="text-gray-600">Score:</span>
                <p class="font-medium">{{ selectedScoreForMatching.score || 'N/A' }}</p>
              </div>
            </div>
          </div>
          
          <!-- Candidate Appointments -->
          <div>
            <h4 class="font-medium text-gray-900 mb-3">Candidate Appointments</h4>
            <div v-if="candidateAppointments.length > 0" class="space-y-3">
              <div v-for="appointment in candidateAppointments" 
                   :key="appointment.id"
                   class="border border-gray-200 rounded-lg p-4 hover:border-crimson-300 transition-colors">
                <div class="flex justify-between items-start">
                  <div class="flex-1">
                    <div class="grid grid-cols-2 md:grid-cols-4 gap-4 text-sm">
                      <div>
                        <span class="text-gray-600">Name:</span>
                        <p class="font-medium">{{ appointment.full_name }}</p>
                      </div>
                      <div>
                        <span class="text-gray-600">Email:</span>
                        <p class="font-medium">{{ appointment.email }}</p>
                      </div>
                      <div>
                        <span class="text-gray-600">School:</span>
                        <p class="font-medium">{{ appointment.school_name || 'N/A' }}</p>
                      </div>
                      <div>
                        <span class="text-gray-600">Program:</span>
                        <p class="font-medium">{{ appointment.program_name }}</p>
                      </div>
                    </div>
                    <div class="mt-2 flex items-center space-x-4 text-xs text-gray-500">
                      <span>Status: {{ appointment.status }}</span>
                      <span>Date: {{ appointment.preferred_date }}</span>
                      <span>Contact: {{ appointment.contact_number }}</span>
                    </div>
                  </div>
                  <button @click="manualMatchScore(appointment.id)"
                          class="ml-4 px-4 py-2 bg-crimson-600 text-white rounded-lg hover:bg-crimson-700 transition-colors text-sm">
                    <i class="fas fa-link mr-2"></i>
                    Match
                  </button>
                </div>
              </div>
            </div>
            <div v-else class="text-center py-8 text-gray-500">
              <i class="fas fa-search text-4xl mb-4"></i>
              <p>No matching appointments found</p>
              <p class="text-sm">Try adjusting the search criteria or create a new appointment</p>
            </div>
          </div>
          
          <!-- Modal Actions -->
          <div class="flex justify-end space-x-3 mt-6 pt-6 border-t border-gray-200">
            <button @click="showManualMatchModal = false"
                    class="px-4 py-2 text-gray-700 border border-gray-300 rounded-lg hover:bg-gray-50 transition-colors">
              Cancel
            </button>
          </div>
        </div>
      </div>
    </div>
    
    <!-- Score Details Modal -->
    <div v-if="showScoreDetailsModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
      <div class="bg-white rounded-xl shadow-xl w-full max-w-4xl mx-4 max-h-[90vh] overflow-y-auto">
        <div class="p-6">
          <div class="flex justify-between items-center mb-6">
            <div>
              <h3 class="text-lg font-bold text-gray-900">Score Details</h3>
              <p class="text-sm text-gray-600 mt-1">Detailed information about this exam score</p>
            </div>
            <button @click="showScoreDetailsModal = false" 
                    class="text-gray-400 hover:text-gray-600 p-2">
              <i class="fas fa-times text-xl"></i>
            </button>
          </div>
          
          <!-- Score Information -->
          <div v-if="selectedScoreForDetails" class="space-y-6">
            <!-- Basic Information -->
            <div class="bg-gray-50 p-4 rounded-lg">
              <h4 class="font-medium text-gray-900 mb-3">Basic Information</h4>
              <div class="grid grid-cols-2 md:grid-cols-3 gap-4 text-sm">
                <div>
                  <span class="text-gray-600">Application Number:</span>
                  <p class="font-medium">{{ selectedScoreForDetails.app_no || 'N/A' }}</p>
                </div>
                <div>
                  <span class="text-gray-600">Student Name:</span>
                  <p class="font-medium">{{ selectedScoreForDetails.name || 'N/A' }}</p>
                </div>
                <div>
                  <span class="text-gray-600">School:</span>
                  <p class="font-medium">{{ selectedScoreForDetails.school || 'N/A' }}</p>
                </div>
                <div>
                  <span class="text-gray-600">Exam Type:</span>
                  <p class="font-medium">{{ selectedScoreForDetails.exam_type || 'N/A' }}</p>
                </div>
                <div>
                  <span class="text-gray-600">Exam Year:</span>
                  <p class="font-medium">{{ selectedScoreForDetails.year || 'N/A' }}</p>
                </div>
                <div>
                  <span class="text-gray-600">Exam Date:</span>
                  <p class="font-medium">{{ formatDate(selectedScoreForDetails.exam_date) || 'N/A' }}</p>
                </div>
              </div>
            </div>

            <!-- Overall Score -->
            <div class="bg-blue-50 p-4 rounded-lg">
              <h4 class="font-medium text-blue-900 mb-3">Overall Performance</h4>
              <div class="grid grid-cols-2 gap-4">
                <div class="text-center">
                  <div class="text-3xl font-bold text-blue-600">{{ selectedScoreForDetails.score || 'N/A' }}</div>
                  <p class="text-sm text-blue-800">Overall Score</p>
                </div>
                <div class="text-center">
                  <div class="text-3xl font-bold text-blue-600">{{ selectedScoreForDetails.oapr || 'N/A' }}</div>
                  <p class="text-sm text-blue-800">Overall Ability Percentile Rank</p>
                </div>
              </div>
            </div>

            <!-- Test Parts Breakdown -->
            <div class="bg-white border border-gray-200 p-4 rounded-lg">
              <h4 class="font-medium text-gray-900 mb-3">Test Parts Breakdown</h4>
              <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                <div class="bg-gradient-to-r from-red-50 to-red-100 p-3 rounded-lg">
                  <div class="flex items-center justify-between">
                    <div>
                      <p class="text-sm font-medium text-red-800">Part 1</p>
                      <p class="text-xs text-red-600">English Proficiency</p>
                    </div>
                    <div class="text-2xl font-bold text-red-700">{{ selectedScoreForDetails.part1 || 'N/A' }}</div>
                  </div>
                </div>
                <div class="bg-gradient-to-r from-orange-50 to-orange-100 p-3 rounded-lg">
                  <div class="flex items-center justify-between">
                    <div>
                      <p class="text-sm font-medium text-orange-800">Part 2</p>
                      <p class="text-xs text-orange-600">Reading Comprehension</p>
                    </div>
                    <div class="text-2xl font-bold text-orange-700">{{ selectedScoreForDetails.part2 || 'N/A' }}</div>
                  </div>
                </div>
                <div class="bg-gradient-to-r from-green-50 to-green-100 p-3 rounded-lg">
                  <div class="flex items-center justify-between">
                    <div>
                      <p class="text-sm font-medium text-green-800">Part 3</p>
                      <p class="text-xs text-green-600">Science Process Skills</p>
                    </div>
                    <div class="text-2xl font-bold text-green-700">{{ selectedScoreForDetails.part3 || 'N/A' }}</div>
                  </div>
                </div>
                <div class="bg-gradient-to-r from-purple-50 to-purple-100 p-3 rounded-lg">
                  <div class="flex items-center justify-between">
                    <div>
                      <p class="text-sm font-medium text-purple-800">Part 4</p>
                      <p class="text-xs text-purple-600">Quantitative Skills</p>
                    </div>
                    <div class="text-2xl font-bold text-purple-700">{{ selectedScoreForDetails.part4 || 'N/A' }}</div>
                  </div>
                </div>
                <div class="bg-gradient-to-r from-indigo-50 to-indigo-100 p-3 rounded-lg">
                  <div class="flex items-center justify-between">
                    <div>
                      <p class="text-sm font-medium text-indigo-800">Part 5</p>
                      <p class="text-xs text-indigo-600">Abstract Thinking Skills</p>
                    </div>
                    <div class="text-2xl font-bold text-indigo-700">{{ selectedScoreForDetails.part5 || 'N/A' }}</div>
                  </div>
                </div>
              </div>
            </div>

            <!-- Matching Status -->
            <div class="bg-gray-50 p-4 rounded-lg">
              <h4 class="font-medium text-gray-900 mb-3">Matching Status</h4>
              <div class="flex items-center space-x-4">
                <div v-if="selectedScoreForDetails.appointment_id" class="flex items-center space-x-2">
                  <div class="w-3 h-3 bg-green-500 rounded-full"></div>
                  <span class="text-sm text-green-700 font-medium">Matched to Appointment</span>
                  <span class="text-xs text-gray-500">(ID: {{ selectedScoreForDetails.appointment_id }})</span>
                </div>
                <div v-else class="flex items-center space-x-2">
                  <div class="w-3 h-3 bg-red-500 rounded-full"></div>
                  <span class="text-sm text-red-700 font-medium">Unmatched</span>
                  <span class="text-xs text-gray-500">Needs manual matching</span>
                </div>
              </div>
            </div>

            <!-- Import Information -->
            <div class="bg-gray-50 p-4 rounded-lg">
              <h4 class="font-medium text-gray-900 mb-3">Import Information</h4>
              <div class="grid grid-cols-2 gap-4 text-sm">
                <div>
                  <span class="text-gray-600">Score ID:</span>
                  <p class="font-medium">{{ selectedScoreForDetails.id || 'N/A' }}</p>
                </div>
                <div>
                  <span class="text-gray-600">Created At:</span>
                  <p class="font-medium">{{ formatDateTime(selectedScoreForDetails.created_at) || 'N/A' }}</p>
                </div>
              </div>
            </div>
          </div>
          
          <!-- Modal Actions -->
          <div class="flex justify-end space-x-3 mt-6 pt-6 border-t border-gray-200">
            <button v-if="!selectedScoreForDetails.appointment_id" 
                    @click="openManualMatchFromDetails()"
                    class="px-4 py-2 bg-crimson-600 text-white rounded-lg hover:bg-crimson-700 transition-colors">
              <i class="fas fa-link mr-2"></i>
              Match to Appointment
            </button>
            <button @click="showScoreDetailsModal = false"
                    class="px-4 py-2 text-gray-700 border border-gray-300 rounded-lg hover:bg-gray-50 transition-colors">
              Close
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import { useToast } from '../../../composables/useToast';

export default {
  name: 'ImportScore',
  setup() {
    const { showToast } = useToast();
    return { showToast };
  },
  data() {
    return {
      // Tab management
      activeTab: 'import',
      
      // Existing import functionality
      dragover: false,
      selectedFile: null,
      selectedExamType: '',
      selectedExamYear: '',
      selectedProgramId: null, // Store the program ID associated with the selected exam type
      examTypes: [], // Will be populated from backend with program ID mapping
      programMapping: {}, // Map from exam type code to program ID
      availableYears: [], // Will be populated based on the current year
      loading: false,
      error: null,
      sessionId: null, // Will store session ID if passed from TestSessionManagement
      
      // Unmatched scores functionality
      unmatchedScores: [],
      searchQuery: '',
      filterExamType: '',
      filterYear: '',
      currentPage: 1,
      itemsPerPage: 10,
      showManualMatchModal: false,
      showScoreDetailsModal: false,
      selectedScoreForMatching: null,
      selectedScoreForDetails: null,
      candidateAppointments: [],
      loadingUnmatched: false,
      
      recentImports: [
        {
          examType: 'LSAT Exam',
          date: '2024-03-15 14:30',
          successful: 120,
          failed: 2
        },
        {
          examType: 'NAT Exam',
          date: '2024-03-14 16:45',
          successful: 180,
          failed: 3
        },
        {
          examType: 'EAT Exam',
          date: '2024-03-13 09:15',
          successful: 150,
          failed: 1
        }
      ]
    }
  },  computed: {
    // Existing computed properties
    isReadyToImport() {
      return this.selectedFile && this.selectedExamType && this.selectedExamYear;
    },
    missingFields() {
      const missing = [];
      if (!this.selectedFile) missing.push('CSV or Excel file');
      if (!this.selectedExamType) missing.push('exam type');
      if (!this.selectedExamYear) missing.push('exam year');
      return missing;
    },
    validationMessage() {
      if (this.missingFields.length > 0) {
        return `Please select ${this.missingFields.join(' and ')} before importing.`;
      }
      return '';
    },
    
    // Unmatched scores computed properties
    filteredUnmatchedScores() {
      let filtered = [...this.unmatchedScores];
      
      // Search filter
      if (this.searchQuery) {
        const query = this.searchQuery.toLowerCase();
        filtered = filtered.filter(score => 
          (score.name || '').toLowerCase().includes(query) ||
          (score.app_no || '').toLowerCase().includes(query) ||
          (score.school || '').toLowerCase().includes(query)
        );
      }
      
      // Exam type filter
      if (this.filterExamType) {
        filtered = filtered.filter(score => score.exam_type === this.filterExamType);
      }
      
      // Year filter
      if (this.filterYear) {
        filtered = filtered.filter(score => score.year === this.filterYear);
      }
      
      return filtered;
    },
    
    uniqueExamTypes() {
      return [...new Set(this.unmatchedScores.map(score => score.exam_type).filter(Boolean))];
    },
    
    uniqueYears() {
      return [...new Set(this.unmatchedScores.map(score => score.year).filter(Boolean))];
    },
    
    totalPages() {
      return Math.ceil(this.filteredUnmatchedScores.length / this.itemsPerPage);
    },
    
    startIndex() {
      return (this.currentPage - 1) * this.itemsPerPage;
    },
    
    endIndex() {
      return this.startIndex + this.itemsPerPage;
    },
    
    paginatedUnmatchedScores() {
      return this.filteredUnmatchedScores.slice(this.startIndex, this.endIndex);
    },
    
    visiblePages() {
      const pages = [];
      const maxVisible = 5;
      let start = Math.max(1, this.currentPage - Math.floor(maxVisible / 2));
      let end = Math.min(this.totalPages, start + maxVisible - 1);
      
      if (end - start < maxVisible - 1) {
        start = Math.max(1, end - maxVisible + 1);
      }
      
      for (let i = start; i <= end; i++) {
        pages.push(i);
      }
      
      return pages;
    },
    
    manuallyMatchedCount() {
      return this.unmatchedScores.filter(score => score.manually_matched).length;
    },
    
    successfullyMatchedCount() {
      return this.unmatchedScores.filter(score => score.appointment_id).length;
    },
    
    pendingMatchCount() {
      return this.unmatchedScores.filter(score => !score.appointment_id).length;
    }
  },
  methods: {
    async checkAuthStatus() {
      const token = localStorage.getItem('token') || 
                   localStorage.getItem('access_token') || 
                   localStorage.getItem('authToken');
      
      if (!token) {
        this.error = 'You must be logged in to import exam scores. Please log in to your admin account first.';
        return false;
      }
      
      try {
        // Try to access a protected endpoint to verify token is valid
        const apiUrl = import.meta.env.VITE_API_URL || 'http://127.0.0.1:8000';
        const apiUrlWithoutTrailingSlash = apiUrl.endsWith('/') ? apiUrl.slice(0, -1) : apiUrl;
        
        // Just return true for now since we have a token
        // The actual API call validation can be done when making the import request
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
    },    async fetchProgramCodes() {
      this.loading = true;
      this.error = null;
      
      try {
        // Use a dynamic API URL based on environment
        const apiUrl = import.meta.env.VITE_API_URL || 'http://localhost:8000';
        const apiUrlWithoutTrailingSlash = apiUrl.endsWith('/') ? apiUrl.slice(0, -1) : apiUrl;
        
        console.log(`Fetching programs from ${apiUrlWithoutTrailingSlash}/api/programs/`);
        
        // Try different possible API endpoints
        let response = null;
        let lastError = null;
        
        try {
          response = await axios.get(`${apiUrlWithoutTrailingSlash}/api/programs/`);
        } catch (error) {
          console.log('First attempt failed:', error);
          lastError = error;
          
          try {
            // Try without /api/ prefix as fallback
            response = await axios.get(`${apiUrlWithoutTrailingSlash}/programs/`);
          } catch (error) {
            console.log('Second attempt failed:', error);
            lastError = error;
          }
        }
        
        if (!response) {
          throw lastError || new Error('Failed to fetch program codes');
        }
        
        console.log('API Response:', response.data); // Debug log
        
        // Process the API response
        if (Array.isArray(response.data)) {
          // Store both code and program ID
          this.examTypes = response.data.map(program => ({
            value: program.code,
            label: `${program.code} - ${program.name}`,
            programId: program.id
          }));
          
          // Create mapping from exam type code to program ID
          this.programMapping = {};
          response.data.forEach(program => {
            this.programMapping[program.code] = program.id;
            console.log(`Mapped ${program.code} to program ID ${program.id}`);
          });
        } else if (response.data.results && Array.isArray(response.data.results)) {
          // Handle paginated response
          this.examTypes = response.data.results.map(program => ({
            value: program.code,
            label: `${program.code} - ${program.name}`,
            programId: program.id
          }));
          
          // Create mapping from exam type code to program ID
          this.programMapping = {};
          response.data.results.forEach(program => {
            this.programMapping[program.code] = program.id;
            console.log(`Mapped ${program.code} to program ID ${program.id}`);
          });
        } else {
          console.error('Unexpected response format:', response.data);
          
          // Fallback to static exam types if API response format is unexpected
          this.examTypes = [
            { value: 'CET', label: 'CET - College Entrance Test', programId: null },
            { value: 'NAT', label: 'NAT - National Achievement Test', programId: null },
            { value: 'LSAT', label: 'LSAT - Law School Admission Test', programId: null },
            { value: 'EAT', label: 'EAT - Engineering Aptitude Test', programId: null },
            { value: 'MAT', label: 'MAT - Medical Admission Test', programId: null }
          ];
          
          this.error = 'Warning: Using default exam types. Server returned invalid format.';
        }
        
        // If we have a selected exam type, update the program ID
        if (this.selectedExamType) {
          this.updateSelectedProgramId();
        }
      } catch (error) {
        console.error('Error fetching program codes:', error);
        
        // Set appropriate error message
        if (error.response) {
          console.error('Error response:', error.response.data);
          console.error('Error status:', error.response.status);
          this.error = `Server error: ${error.response.status} - ${error.response.data.error || 'Unknown error'}`;
        } else if (error.request) {
          console.error('No response received:', error.request);
          this.error = 'No response from server. Using default exam types.';
        } else {
          console.error('Error setting up request:', error.message);
          this.error = 'Error setting up request. Using default exam types.';
        }
        
        // Fallback to static exam types
        this.examTypes = [
          { value: 'CET', label: 'CET - College Entrance Test', programId: null },
          { value: 'NAT', label: 'NAT - National Achievement Test', programId: null },
          { value: 'LSAT', label: 'LSAT - Law School Admission Test', programId: null },
          { value: 'EAT', label: 'EAT - Engineering Aptitude Test', programId: null },
          { value: 'MAT', label: 'MAT - Medical Admission Test', programId: null }
        ];
      } finally {
        this.loading = false;
      }
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
    updateSelectedProgramId() {
      // Reset the program ID if no exam type is selected
      if (!this.selectedExamType) {
        this.selectedProgramId = null;
        return;
      }
      
      console.log('Updating program ID for exam type:', this.selectedExamType);
      console.log('Program mapping:', this.programMapping);
      console.log('Exam types:', this.examTypes);
      
      // Try to find the program ID from the mapping first
      if (this.programMapping && this.programMapping[this.selectedExamType]) {
        this.selectedProgramId = this.programMapping[this.selectedExamType];
        console.log(`Selected exam type: ${this.selectedExamType}, mapped to program ID: ${this.selectedProgramId}`);
        return;
      }
      
      // If not found in the mapping, look directly in the examTypes array
      const matchingExam = this.examTypes.find(exam => exam.value === this.selectedExamType);
      if (matchingExam && matchingExam.programId) {
        this.selectedProgramId = matchingExam.programId;
        console.log(`Found program ID ${this.selectedProgramId} directly from examTypes array`);
        return;
      }
      
      // If still not found, log a warning and set to null
      console.warn(`Could not find program ID for exam type: ${this.selectedExamType}`);
      this.selectedProgramId = null;
      
      // If we couldn't find a program ID, try to fetch programs again
      if (!this.selectedProgramId) {
        console.log('No program ID found, trying to fetch programs again...');
        this.fetchProgramCodes();
      }
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
      
      // Send data to backend API
      const apiUrl = import.meta.env.VITE_API_URL || 'http://localhost:8000';
      const apiUrlWithoutTrailingSlash = apiUrl.endsWith('/') ? apiUrl.slice(0, -1) : apiUrl;
      const token = localStorage.getItem('token') || 
                   localStorage.getItem('access_token') || 
                   localStorage.getItem('authToken');
      
      // Create FormData to upload the file
      const formData = new FormData();
      formData.append('file', this.selectedFile);
      formData.append('examType', this.selectedExamType);
      formData.append('examYear', this.selectedExamYear);
      
      // Add program_id if available
      if (this.selectedProgramId) {
        // Make sure it's a string - the Django REST framework expects string values in FormData
        formData.append('program_id', String(this.selectedProgramId));
        console.log(`Including program_id ${this.selectedProgramId} in import request`);
      } else {
        // Warning message but continue with import
        console.warn('No program ID available for the selected exam type. Scores may not be properly categorized.');
        this.showToast('Warning: No program ID found for the selected exam type. Scores may not be properly categorized.', 'warning');
      }
      
      // Add file structure information for the backend
      const fileStructure = 'app_no,lastname,firstname,middlename,school,date,part1,part2,part3,part4,part5,oapr';
      formData.append('file_structure', fileStructure); 
      formData.append('has_headers', 'true');
      
      // Debug the form data
      for (let [key, value] of formData.entries()) {
        console.log(`${key}: ${key === 'file' ? value.name : value}`);
      }
      
      console.log('Sending import with structure:', fileStructure);
      
      try {
        // Try multiple URLs in sequence - from most specific to most general
        const urls = [
          `${apiUrlWithoutTrailingSlash}/api/appointments/import-scores/`,
          `${apiUrlWithoutTrailingSlash}/api/admin/import-scores/`,
          `${apiUrlWithoutTrailingSlash}/api/import-scores/`,
          `${apiUrlWithoutTrailingSlash}/api/score-import/`
        ];
        
        console.log(`Trying multiple URL endpoints for score import...`);
        
        // Get the most up-to-date token
        let accessToken = localStorage.getItem('access_token') || 
                         localStorage.getItem('token') || 
                         localStorage.getItem('authToken');
        
        // Check if token needs Bearer prefix
        if (accessToken && !accessToken.startsWith('Bearer ')) {
          accessToken = `Bearer ${accessToken}`;
        }
        
        console.log('Using authorization: ', accessToken ? 'Token present' : 'No token');
        
        // Try each URL until one works
        let response = null;
        let lastError = null;
        
        for (const url of urls) {
          try {
            console.log(`Trying URL: ${url}`);
            response = await axios.post(
              url, 
              formData,
              {
                headers: {
                  'Authorization': accessToken || '',
                  'Content-Type': 'multipart/form-data'
                },
                withCredentials: true
              }
            );
            console.log(`Success with URL: ${url}`, response.data);
            break; // Exit the loop if successful
          } catch (error) {
            console.error(`Failed with URL ${url}:`, error);
            console.log('Error response:', error.response?.data);
            lastError = error;
            // Continue to next URL
          }
        }
        
        // If none of the URLs worked, throw the last error
        if (!response) {
          if (lastError && lastError.response && lastError.response.status === 403) {
            this.error = 'You do not have permission to import scores. Please log in with an admin account.';
            this.showToast(this.error, 'error');
            throw new Error('Authorization required');
          } else {
            throw lastError || new Error('All API endpoints failed');
          }
        }
        
        // If we reach here, we have a successful response
        
        console.log('Data successfully sent to API:', response.data);
        
        // Add to recent imports
        const newImport = {
          examType: this.selectedExamType,
          date: new Date().toLocaleString(),
          successful: response.data.matched + response.data.updated,
          failed: response.data.unmatched
        };
        
        this.recentImports.unshift(newImport);
        
        this.showToast(`Successfully imported ${response.data.matched} score records. ${response.data.unmatched} records were unmatched.`, 'success');
        
        // Refresh unmatched scores after import
        if (response.data.unmatched > 0) {
          this.refreshUnmatchedScores();
        }
        
      } catch (apiError) {
        console.error('API storage failed:', apiError);
        
        // More detailed error message
        let errorMessage = 'Failed to save score data to the server';
        
        if (apiError.response?.data) {
          if (typeof apiError.response.data === 'string') {
            errorMessage += ': ' + apiError.response.data;
          } else if (apiError.response.data.error) {
            errorMessage += ': ' + apiError.response.data.error;
          } else if (apiError.response.data.detail) {
            errorMessage += ': ' + apiError.response.data.detail;
          }
        } else if (apiError.message) {
          errorMessage += ': ' + apiError.message;
        }
        
        this.error = errorMessage;
        this.showToast(errorMessage, 'error');
      } finally {
        this.loading = false;
      }
    },

    async fetchUnmatchedScores() {
      this.loadingUnmatched = true;
      try {
        const apiUrl = import.meta.env.VITE_API_URL || 'http://localhost:8000';
        const apiUrlWithoutTrailingSlash = apiUrl.endsWith('/') ? apiUrl.slice(0, -1) : apiUrl;
        const token = localStorage.getItem('token') || 
                     localStorage.getItem('access_token') || 
                     localStorage.getItem('authToken');
        
        const response = await axios.get(`${apiUrlWithoutTrailingSlash}/api/unmatched-scores/`, {
          headers: {
            'Authorization': token?.startsWith('Bearer ') ? token : `Bearer ${token}`,
            'Content-Type': 'application/json'
          }
        });
        
        this.unmatchedScores = response.data;
      } catch (error) {
        console.error('Failed to fetch unmatched scores:', error);
        this.showToast('Failed to load unmatched scores', 'error');
      } finally {
        this.loadingUnmatched = false;
      }
    },
    
    refreshUnmatchedScores() {
      this.fetchUnmatchedScores();
    },
    
    async exportUnmatchedScores() {
      if (this.unmatchedScores.length === 0) return;
      
      try {
        const csvContent = this.generateCSVContent(this.filteredUnmatchedScores);
        const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' });
        const link = document.createElement('a');
        const url = URL.createObjectURL(blob);
        link.setAttribute('href', url);
        link.setAttribute('download', `unmatched_scores_${new Date().toISOString().split('T')[0]}.csv`);
        link.style.visibility = 'hidden';
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
        
        this.showToast('Unmatched scores exported successfully', 'success');
      } catch (error) {
        console.error('Export failed:', error);
        this.showToast('Failed to export unmatched scores', 'error');
      }
    },
    
    generateCSVContent(scores) {
      const headers = ['App No', 'Name', 'School', 'Exam Type', 'Year', 'Score', 'Part1', 'Part2', 'Part3', 'Part4', 'Part5', 'OAPR', 'Status'];
      const rows = scores.map(score => [
        score.app_no || '',
        score.name || '',
        score.school || '',
        score.exam_type || '',
        score.year || '',
        score.score || '',
        score.part1 || '',
        score.part2 || '',
        score.part3 || '',
        score.part4 || '',
        score.part5 || '',
        score.oapr || '',
        score.appointment_id ? 'Matched' : 'Unmatched'
      ]);
      
      return [headers, ...rows].map(row => 
        row.map(field => `"${field}"`).join(',')
      ).join('\n');
    },
    
    async openManualMatchModal(score) {
      this.selectedScoreForMatching = score;
      await this.fetchCandidateAppointments(score);
      this.showManualMatchModal = true;
    },
    
    async fetchCandidateAppointments(score) {
      try {
        const apiUrl = import.meta.env.VITE_API_URL || 'http://localhost:8000';
        const apiUrlWithoutTrailingSlash = apiUrl.endsWith('/') ? apiUrl.slice(0, -1) : apiUrl;
        const token = localStorage.getItem('token') || 
                     localStorage.getItem('access_token') || 
                     localStorage.getItem('authToken');
        
        // Search for appointments that might match this score
        const searchParams = new URLSearchParams();
        if (score.name) searchParams.append('name', score.name);
        if (score.app_no) searchParams.append('app_no', score.app_no);
        if (score.exam_type) searchParams.append('exam_type', score.exam_type);
        
        const response = await axios.get(`${apiUrlWithoutTrailingSlash}/api/candidate-appointments/?${searchParams}`, {
          headers: {
            'Authorization': token?.startsWith('Bearer ') ? token : `Bearer ${token}`,
            'Content-Type': 'application/json'
          }
        });
        
        this.candidateAppointments = response.data;
      } catch (error) {
        console.error('Failed to fetch candidate appointments:', error);
        this.candidateAppointments = [];
      }
    },
    
    async manualMatchScore(appointmentId) {
      try {
        const apiUrl = import.meta.env.VITE_API_URL || 'http://localhost:8000';
        const apiUrlWithoutTrailingSlash = apiUrl.endsWith('/') ? apiUrl.slice(0, -1) : apiUrl;
        const token = localStorage.getItem('token') || 
                     localStorage.getItem('access_token') || 
                     localStorage.getItem('authToken');
        
        await axios.post(`${apiUrlWithoutTrailingSlash}/api/manual-match-score/`, {
          score_id: this.selectedScoreForMatching.id,
          appointment_id: appointmentId
        }, {
          headers: {
            'Authorization': token?.startsWith('Bearer ') ? token : `Bearer ${token}`,
            'Content-Type': 'application/json'
          }
        });
        
        this.showToast('Score successfully matched to appointment', 'success');
        this.showManualMatchModal = false;
        this.refreshUnmatchedScores();
      } catch (error) {
        console.error('Failed to match score:', error);
        this.showToast('Failed to match score to appointment', 'error');
      }
    },
    
    viewScoreDetails(score) {
      this.selectedScoreForDetails = score;
      this.showScoreDetailsModal = true;
    },
    
    openManualMatchFromDetails() {
      // Close the details modal and open the match modal
      this.showScoreDetailsModal = false;
      this.selectedScoreForMatching = this.selectedScoreForDetails;
      this.fetchCandidateAppointments(this.selectedScoreForDetails);
      this.showManualMatchModal = true;
    },
    
    formatDate(dateString) {
      if (!dateString) return 'N/A';
      try {
        return new Date(dateString).toLocaleDateString();
      } catch (error) {
        return 'Invalid Date';
      }
    },
    
    formatDateTime(dateString) {
      if (!dateString) return 'N/A';
      try {
        return new Date(dateString).toLocaleString();
      } catch (error) {
        return 'Invalid Date';
      }
    },
    
    // Pagination methods
    previousPage() {
      if (this.currentPage > 1) {
        this.currentPage--;
      }
    },
    
    nextPage() {
      if (this.currentPage < this.totalPages) {
        this.currentPage++;
      }
    },
    
    goToPage(page) {
      this.currentPage = page;
    }
  },  created() {
    this.fetchProgramCodes();
    
    // Generate available years (current year down to 2020)
    const currentYear = new Date().getFullYear();
    for (let year = currentYear; year >= 2020; year--) {
      this.availableYears.push(year);
    }
    
    // Check for session ID and exam type in the URL query parameters
    const sessionId = this.$route.query.sessionId;
    const examType = this.$route.query.examType;
    
    if (sessionId) {
      console.log(`Import page loaded with sessionId: ${sessionId}, examType: ${examType}`);
      
      // If exam type was provided, pre-select it
      if (examType) {
        this.selectedExamType = examType;
      }
      
      // Store the session ID for use during import
      this.sessionId = sessionId;
    }
  },
  created() {
    this.fetchProgramCodes();
    
    // Generate available years (current year down to 2020)
    const currentYear = new Date().getFullYear();
    for (let year = currentYear; year >= 2020; year--) {
      this.availableYears.push(year);
    }
    
    // Check for session ID and exam type in the URL query parameters
    const sessionId = this.$route.query.sessionId;
    const examType = this.$route.query.examType;
    
    if (sessionId) {
      console.log(`Import page loaded with sessionId: ${sessionId}, examType: ${examType}`);
      
      // If exam type was provided, pre-select it
      if (examType) {
        this.selectedExamType = examType;
      }
      
      // Store the session ID for use during import
      this.sessionId = sessionId;
    }
  },
  
  mounted() {
    // Check for authentication when component mounts
    this.checkAuthStatus();
    
    // Fetch unmatched scores on component mount
    this.fetchUnmatchedScores();
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