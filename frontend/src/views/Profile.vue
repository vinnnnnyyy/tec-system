<template>
  <div class="min-h-screen bg-gradient-to-br from-gray-50 via-white to-blue-50">
    
    <div class="relative container mx-auto px-3 sm:px-6 lg:px-8 py-6 sm:py-8 lg:py-12">
      <div class="max-w-5xl mx-auto space-y-6 sm:space-y-8">
        
        <!-- Enhanced Profile Header Card -->
        <div class="bg-white rounded-2xl sm:rounded-3xl shadow-lg sm:shadow-xl overflow-hidden transform transition-all duration-500 hover:shadow-2xl border border-gray-100">
          <!-- Header Gradient with Animation -->
          <div class="bg-gradient-to-r from-crimson-600 via-crimson-700 to-red-600 px-6 sm:px-8 py-6 sm:py-8 relative overflow-hidden">
            <!-- Animated Background Elements -->
            <div class="absolute inset-0 bg-gradient-to-r from-crimson-500/20 to-red-500/20 animate-pulse"></div>
            <div class="absolute top-0 right-0 w-32 h-32 bg-white/10 rounded-full -translate-y-16 translate-x-16"></div>
            <div class="absolute bottom-0 left-0 w-24 h-24 bg-white/5 rounded-full translate-y-12 -translate-x-12"></div>
            
            <div class="relative flex items-center justify-between">
              <div class="space-y-2">
                <h1 class="text-2xl sm:text-3xl lg:text-4xl font-bold text-white tracking-tight">Student Profile</h1>
                <p class="text-crimson-100 text-sm sm:text-base opacity-90">Manage your test appointments and scores</p>
              </div>
              <div class="bg-white/10 backdrop-blur-sm rounded-2xl p-4 sm:p-5 shadow-lg">
                <i class="fas fa-graduation-cap text-white text-2xl sm:text-3xl"></i>
              </div>
            </div>
          </div>
          
          <!-- Profile Information -->
          <div class="p-6 sm:p-8 lg:p-10">
            <div class="flex flex-col sm:flex-row items-start sm:items-center space-y-6 sm:space-y-0 sm:space-x-8">
              <!-- Enhanced Avatar -->
              <div class="relative">
                <div class="w-20 h-20 sm:w-24 sm:h-24 lg:w-28 lg:h-28 rounded-2xl sm:rounded-3xl bg-gradient-to-br from-crimson-100 via-pink-50 to-red-50 flex items-center justify-center shadow-lg ring-4 ring-white ring-offset-2 ring-offset-gray-50">
                  <i class="fas fa-user text-crimson-600 text-2xl sm:text-3xl lg:text-4xl"></i>
                </div>
                <!-- Status Indicator -->
                <div class="absolute -bottom-1 -right-1 w-6 h-6 bg-green-500 rounded-full border-3 border-white shadow-md flex items-center justify-center">
                  <i class="fas fa-check text-white text-xs"></i>
                </div>
              </div>
              
              <!-- User Details -->
              <div class="flex-1 space-y-3 sm:space-y-4">
                <div>
                  <h2 class="text-2xl sm:text-3xl lg:text-4xl font-bold text-gray-900 mb-2">
                    {{ userProfile?.full_name || 'Student' }}
                  </h2>
                  <div class="flex flex-col sm:flex-row sm:items-center space-y-2 sm:space-y-0 sm:space-x-6 text-gray-600">
                    <div class="flex items-center space-x-2">
                      <div class="w-8 h-8 bg-blue-100 rounded-lg flex items-center justify-center">
                        <i class="fas fa-envelope text-blue-600 text-sm"></i>
                      </div>
                      <p class="text-sm sm:text-base font-medium truncate max-w-[280px] sm:max-w-none">
                        {{ userProfile?.email }}
                      </p>
                    </div>
                    <div v-if="userProfile?.student_id" class="flex items-center space-x-2">
                      <div class="w-8 h-8 bg-green-100 rounded-lg flex items-center justify-center">
                        <i class="fas fa-id-card text-green-600 text-sm"></i>
                      </div>
                      <p class="text-sm sm:text-base font-medium">
                        ID: {{ userProfile.student_id }}
                      </p>
                    </div>
                  </div>
                </div>
                
                <!-- Quick Stats -->
                <div class="grid grid-cols-2 sm:grid-cols-3 gap-4 pt-4 border-t border-gray-100">
                  <div class="text-center">
                    <div class="text-2xl font-bold text-crimson-600">{{ appointments.length }}</div>
                    <div class="text-xs text-gray-500 font-medium">Total Exams</div>
                  </div>
                  <div class="text-center">
                    <div class="text-2xl font-bold text-green-600">
                      {{ appointments.filter(a => a.status === 'approved').length }}
                    </div>
                    <div class="text-xs text-gray-500 font-medium">Approved</div>
                  </div>
                  <div class="text-center col-span-2 sm:col-span-1">
                    <div class="text-2xl font-bold text-blue-600">
                      {{ appointments.filter(a => a.exam_score).length }}
                    </div>
                    <div class="text-xs text-gray-500 font-medium">With Scores</div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
        
        <!-- Enhanced Exam Results Section -->
        <div class="bg-white rounded-2xl sm:rounded-3xl shadow-lg sm:shadow-xl overflow-hidden border border-gray-100">
          <!-- Section Header -->
          <div class="bg-gradient-to-r from-gray-50 to-blue-50 px-6 sm:px-8 py-6 sm:py-8 border-b border-gray-200">
            <div class="flex items-center justify-between">
              <div class="flex items-center space-x-4">
                <div class="w-12 h-12 bg-gradient-to-br from-blue-500 to-indigo-600 rounded-xl flex items-center justify-center shadow-lg">
                  <i class="fas fa-chart-line text-white text-xl"></i>
                </div>
                <div>
                  <h2 class="text-xl sm:text-2xl lg:text-3xl font-bold text-gray-900">Exam Results</h2>
                  <p class="text-gray-600 text-sm sm:text-base">Track your test performance and appointments</p>
                </div>
              </div>
              
              <!-- Results Summary Badge -->
              <div class="bg-white rounded-xl px-4 py-3 shadow-md border border-gray-200">
                <div class="text-center">
                  <div class="text-lg font-bold text-gray-900">{{ appointments.length }}</div>
                  <div class="text-xs text-gray-500 font-medium">
                    {{ appointments.length === 1 ? 'Exam' : 'Exams' }}
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- Enhanced Loading State -->
          <div v-if="loading" class="p-12 sm:p-16 flex flex-col items-center justify-center space-y-4">
            <div class="relative">
              <div class="animate-spin rounded-full h-16 w-16 sm:h-20 sm:w-20 border-4 border-gray-200"></div>
              <div class="animate-spin rounded-full h-16 w-16 sm:h-20 sm:w-20 border-t-4 border-crimson-600 absolute top-0 left-0"></div>
            </div>
            <div class="text-center space-y-2">
              <p class="text-gray-600 font-medium">Loading your exam results...</p>
              <p class="text-gray-400 text-sm">Please wait while we fetch your data</p>
            </div>
          </div>
          
          <!-- Enhanced Empty State -->
          <div v-else-if="!hasAppointments" class="p-12 sm:p-16 text-center">
            <div class="space-y-6">
              <div class="w-20 h-20 sm:w-24 sm:h-24 mx-auto rounded-full bg-gradient-to-br from-gray-100 to-gray-200 flex items-center justify-center shadow-inner">
                <i class="fas fa-file-alt text-gray-400 text-3xl sm:text-4xl"></i>
              </div>
              <div class="space-y-3">
                <h3 class="text-xl sm:text-2xl font-bold text-gray-700">No Exam Records Found</h3>
                <p class="text-gray-500 text-sm sm:text-base max-w-md mx-auto">
                  You haven't taken any exams yet. Your exam appointments and results will appear here once you schedule and complete your tests.
                </p>
              </div>
              <!-- Call to Action -->
              <div class="pt-4">
                <button class="inline-flex items-center px-6 py-3 bg-crimson-600 text-white rounded-xl hover:bg-crimson-700 transition-all duration-200 font-medium shadow-lg hover:shadow-xl transform hover:-translate-y-1">
                  <i class="fas fa-plus mr-2"></i>
                  Schedule an Exam
                </button>
              </div>
            </div>
          </div>
          
          <!-- Loading State -->
          <div v-if="loading" class="p-8 sm:p-12 flex justify-center">
            <div class="animate-spin rounded-full h-10 w-10 sm:h-12 sm:w-12 border-4 border-crimson-100 border-t-crimson-600"></div>
          </div>
          
          <!-- Empty State -->
          <div v-else-if="!hasAppointments" class="p-8 sm:p-12 text-center">
            <div class="space-y-3 sm:space-y-4">
              <div class="w-14 h-14 sm:w-16 sm:h-16 mx-auto rounded-full bg-gray-100 flex items-center justify-center">
                <i class="fas fa-file-alt text-gray-400 text-xl sm:text-2xl"></i>
              </div>
              <div class="space-y-1 sm:space-y-2">
                <p class="text-gray-600 font-medium">No Exam Records Found</p>
                <p class="text-gray-400 text-xs sm:text-sm">Your exam appointments will appear here</p>
              </div>
            </div>
          </div>
          
          <!-- Enhanced Exam List -->
          <div v-else class="p-6 sm:p-8 space-y-6">
            <div v-for="appointment in appointments" 
                 :key="appointment.id" 
                 class="group bg-white rounded-2xl border-2 border-gray-100 hover:border-crimson-200 transition-all duration-300 hover:shadow-xl transform hover:-translate-y-1 overflow-hidden">
              
              <!-- Appointment Card Content -->
              <div class="p-6 sm:p-8 space-y-6">
                <!-- Enhanced Header -->
                <div class="flex flex-col lg:flex-row lg:justify-between lg:items-start gap-4">
                  <div class="space-y-3 flex-1">
                    <div class="flex items-start justify-between">
                      <h3 class="text-xl sm:text-2xl font-bold text-gray-900 group-hover:text-crimson-600 transition-colors duration-200">
                        {{ appointment.program_name }}
                      </h3>
                      <span class="ml-4 px-4 py-2 text-sm font-semibold rounded-full transform hover:scale-105 transition-all duration-200 shadow-md"
                            :class="getStatusClass(appointment.status)">
                        {{ appointment.status.charAt(0).toUpperCase() + appointment.status.slice(1) }}
                      </span>
                    </div>
                    
                    <!-- Enhanced Date/Time Display -->
                    <div class="flex flex-wrap items-center gap-4 text-gray-600">
                      <div class="flex items-center space-x-2 bg-gray-50 rounded-lg px-3 py-2">
                        <div class="w-8 h-8 bg-blue-100 rounded-lg flex items-center justify-center">
                          <i class="fas fa-calendar text-blue-600 text-sm"></i>
                        </div>
                        <div>
                          <div class="text-xs text-gray-500 font-medium">Date</div>
                          <div class="text-sm font-semibold">{{ formatDate(appointment.preferred_date) }}</div>
                        </div>
                      </div>
                      
                      <div class="flex items-center space-x-2 bg-gray-50 rounded-lg px-3 py-2">
                        <div class="w-8 h-8 bg-green-100 rounded-lg flex items-center justify-center">
                          <i class="fas fa-clock text-green-600 text-sm"></i>
                        </div>
                        <div>
                          <div class="text-xs text-gray-500 font-medium">Time</div>
                          <div class="text-sm font-semibold">{{ getTimeSlotDisplay(appointment) }}</div>
                        </div>
                      </div>
                      
                      <div v-if="appointment.id" class="flex items-center space-x-2 bg-gray-50 rounded-lg px-3 py-2">
                        <div class="w-8 h-8 bg-purple-100 rounded-lg flex items-center justify-center">
                          <i class="fas fa-hashtag text-purple-600 text-sm"></i>
                        </div>
                        <div>
                          <div class="text-xs text-gray-500 font-medium">ID</div>
                          <div class="text-sm font-semibold">{{ appointment.id }}</div>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>

                <!-- Enhanced Score Section -->
                <div v-if="(appointment.status === 'submitted' || appointment.status === 'approved') && appointment.exam_score" 
                     class="bg-gradient-to-br from-gray-50 to-blue-50 rounded-2xl p-6 sm:p-8 border border-gray-200 space-y-6">
                  
                  <!-- Score Header -->
                  <div class="flex justify-between items-start">
                    <div class="space-y-2">
                      <h4 class="text-lg sm:text-xl font-bold text-gray-800 flex items-center">
                        <div class="w-8 h-8 bg-blue-500 rounded-lg flex items-center justify-center mr-3">
                          <i class="fas fa-chart-bar text-white text-sm"></i>
                        </div>
                        Overall Ability Percentile Rank
                      </h4>
                      <p class="text-sm text-gray-600">Your performance score</p>
                    </div>
                    <div class="text-center">
                      <div class="text-4xl sm:text-5xl font-bold text-blue-600 mb-1">
                        {{ appointment.exam_score.oapr || appointment.exam_score.score }}
                      </div>
                      <div class="text-xs text-gray-500 font-medium">Percentile</div>
                    </div>
                  </div>

                  <!-- Score Details Toggle -->
                  <Transition name="detailed-scores">
                    <div v-if="detailedScores" class="relative bg-white rounded-xl p-6 border border-gray-200 shadow-sm">
                      <button @click="closeDetailedScores" 
                              title="Close detailed scores"
                              class="absolute -right-3 -top-3 w-8 h-8 flex items-center justify-center rounded-full bg-red-500 hover:bg-red-600 text-white shadow-lg transition-all duration-200 z-10 focus:outline-none focus:ring-2 focus:ring-red-200">
                        <i class="fas fa-times text-sm"></i>
                      </button>
                      <StudentScoreCard :exam-score="detailedScores" 
                                       :model-info="scoreModelInfo" />
                    </div>
                  </Transition>
                  
                  <div v-if="!detailedScores" class="text-center">
                    <button @click="fetchDetailedScores" 
                            class="inline-flex items-center px-6 py-3 bg-blue-600 text-white rounded-xl hover:bg-blue-700 transition-all duration-200 font-medium shadow-md hover:shadow-lg transform hover:-translate-y-1">
                      <i class="fas fa-chart-bar mr-2"></i>
                      View Detailed Scores
                    </button>
                  </div>

                  <!-- Score Notes -->
                  <div v-if="appointment.exam_score.notes" 
                       class="bg-white rounded-xl p-4 border border-blue-200">
                    <div class="flex items-start space-x-3">
                      <div class="w-8 h-8 bg-amber-100 rounded-lg flex items-center justify-center flex-shrink-0">
                        <i class="fas fa-comment-alt text-amber-600 text-sm"></i>
                      </div>
                      <div>
                        <h5 class="font-semibold text-gray-800 text-sm mb-1">Additional Notes</h5>
                        <p class="text-sm text-gray-600">{{ appointment.exam_score.notes }}</p>
                      </div>
                    </div>
                  </div>

                  <!-- Score Import Info -->
                  <div class="flex items-center justify-between text-xs text-gray-500 bg-white rounded-lg p-3 border border-gray-200">
                    <div class="flex items-center space-x-2">
                      <i class="fas fa-clock"></i>
                      <span>Score imported on {{ formatDateTime(appointment.exam_score.created_at) }}</span>
                    </div>
                    <div class="flex items-center space-x-1">
                      <div class="w-2 h-2 bg-green-500 rounded-full"></div>
                      <span class="font-medium">Verified</span>
                    </div>
                  </div>
                  
                  <!-- Enhanced Information about score release -->
                  <div class="bg-gradient-to-r from-blue-50 to-indigo-50 border-2 border-blue-200 rounded-2xl p-6">
                    <div class="flex items-start space-x-4">
                      <div class="w-12 h-12 bg-blue-500 rounded-xl flex items-center justify-center flex-shrink-0">
                        <i class="fas fa-info-circle text-white text-lg"></i>
                      </div>
                      <div class="space-y-3">
                        <h5 class="font-bold text-blue-800 text-lg">Official Score Report</h5>
                        <p class="text-sm text-blue-700 leading-relaxed">
                          If your scores are officially released, you must visit <strong>WMSU-TEC at Campus B of Western Mindanao State University</strong> to obtain your official score report.
                        </p>
                        <div class="bg-white rounded-lg p-3 border border-blue-200">
                          <div class="flex items-center space-x-2 text-blue-700">
                            <i class="fas fa-map-marker-alt text-blue-500"></i>
                            <span class="text-sm font-medium">Western Mindanao State University - Campus B</span>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>

                <!-- Enhanced Other States -->
                <div v-else class="space-y-8">
                  <!-- Pending Score State -->
                  <div v-if="appointment.status !== 'submitted' && appointment.status !== 'approved' && appointment.exam_score"
                       class="bg-gradient-to-br from-amber-50 to-yellow-50 rounded-2xl p-8 border-2 border-amber-200 text-center">
                    <div class="w-16 h-16 bg-amber-100 rounded-full flex items-center justify-center mx-auto mb-4 shadow-lg">
                      <i class="fas fa-lock text-amber-600 text-2xl"></i>
                    </div>
                    <h4 class="text-lg font-semibold text-amber-800 mb-2">Score Locked</h4>
                    <p class="text-sm text-amber-700">Score will be available once application is submitted</p>
                  </div>
                  
                  <!-- Approved Without Score State -->
                  <div v-else-if="appointment.status === 'approved' && !appointment.exam_score"
                       class="bg-gradient-to-br from-green-50 to-emerald-50 rounded-2xl p-8 border-2 border-green-200">
                    
                    <!-- Enhanced Status Header -->
                    <div class="text-center mb-8">
                      <div class="relative inline-flex items-center justify-center w-24 h-24 bg-gradient-to-br from-green-400 to-emerald-500 rounded-full mb-6 shadow-xl">
                        <i class="fas fa-check-circle text-white text-4xl"></i>
                        <!-- Pulsing ring animation -->
                        <div class="absolute inset-0 rounded-full border-4 border-green-300 animate-ping opacity-75"></div>
                      </div>
                      <div class="space-y-3">
                        <h4 class="text-2xl font-bold text-green-800">Application Approved!</h4>
                        <p class="text-gray-700 text-base leading-relaxed max-w-md mx-auto">
                          Congratulations! Your examination has been scheduled. Your score results are being processed.
                        </p>
                        <div class="inline-flex items-center px-4 py-2 bg-green-100 text-green-800 rounded-full text-sm font-semibold shadow-md">
                          <div class="w-2 h-2 bg-green-500 rounded-full mr-2 animate-pulse"></div>
                          Processing Results
                        </div>
                      </div>
                    </div>
                    
                    <!-- Enhanced Action Buttons -->
                    <div class="space-y-6">
                      
                      <!-- Primary Action: Download Form -->
                      <div class="bg-gradient-to-r from-crimson-500 to-red-500 rounded-2xl p-6 shadow-lg">
                        <div class="flex items-start space-x-4 mb-4">
                          <div class="flex-shrink-0 w-12 h-12 bg-white rounded-xl flex items-center justify-center shadow-md">
                            <i class="fas fa-file-pdf text-crimson-600 text-xl"></i>
                          </div>
                          <div class="flex-1 text-white">
                            <h5 class="font-bold text-lg mb-2">Required: Application Form</h5>
                            <p class="text-crimson-100 text-sm leading-relaxed">
                              Download and print your personalized application form. This document is mandatory for your exam day.
                            </p>
                          </div>
                        </div>
                        <button 
                          @click="downloadApplicationForm(appointment)" 
                          :disabled="isGeneratingPdf"
                          class="w-full bg-white hover:bg-gray-50 disabled:bg-gray-200 text-crimson-600 py-4 px-6 rounded-xl flex items-center justify-center transition-all duration-300 text-base font-bold shadow-lg hover:shadow-xl transform hover:-translate-y-1 disabled:transform-none disabled:cursor-not-allowed"
                          aria-label="Download Application Form"
                        >
                          <div class="flex items-center space-x-3">
                            <i :class="isGeneratingPdf ? 'fas fa-spinner fa-spin' : 'fas fa-download'" class="text-lg"></i>
                            <span>{{ isGeneratingPdf ? 'Generating PDF...' : 'Download Application Form' }}</span>
                          </div>
                        </button>
                      </div>
                      
                      <!-- Secondary Actions Grid -->
                      <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                        
                        <!-- View Scores Button -->
                        <div class="bg-white rounded-2xl p-6 border-2 border-blue-200 hover:border-blue-300 transition-all duration-200 shadow-md hover:shadow-lg">
                          <div class="text-center space-y-4">
                            <div class="w-12 h-12 bg-blue-100 rounded-xl flex items-center justify-center mx-auto">
                              <i class="fas fa-chart-bar text-blue-600 text-lg"></i>
                            </div>
                            <div>
                              <h5 class="font-semibold text-gray-800 text-sm mb-1">Check Scores</h5>
                              <p class="text-gray-600 text-xs mb-3">View your exam results if available</p>
                            </div>
                            <button 
                              @click="fetchScoresForAppointment(appointment)" 
                              :disabled="loadingScores"
                              class="w-full bg-blue-600 hover:bg-blue-700 disabled:bg-blue-400 text-white py-2 px-4 rounded-lg flex items-center justify-center transition-all duration-200 text-sm font-medium shadow-md hover:shadow-lg transform hover:-translate-y-0.5 disabled:transform-none"
                            >
                              <i v-if="loadingScores" class="fas fa-spinner fa-spin mr-2"></i>
                              <i v-else class="fas fa-eye mr-2"></i>
                              <span>{{ loadingScores ? 'Loading...' : 'View Scores' }}</span>
                            </button>
                          </div>
                        </div>
                        
                        <!-- Secure Search Button -->
                        <div class="bg-white rounded-2xl p-6 border-2 border-indigo-200 hover:border-indigo-300 transition-all duration-200 shadow-md hover:shadow-lg">
                          <div class="text-center space-y-4">
                            <div class="w-12 h-12 bg-indigo-100 rounded-xl flex items-center justify-center mx-auto">
                              <i class="fas fa-shield-alt text-indigo-600 text-lg"></i>
                            </div>
                            <div>
                              <h5 class="font-semibold text-gray-800 text-sm mb-1">Secure Search</h5>
                              <p class="text-gray-600 text-xs mb-3">Search for released scores</p>
                            </div>
                            <button 
                              @click="showSecureSearchModal"
                              class="w-full bg-indigo-600 hover:bg-indigo-700 text-white py-2 px-4 rounded-lg flex items-center justify-center transition-all duration-200 text-sm font-medium shadow-md hover:shadow-lg transform hover:-translate-y-0.5"
                            >
                              <i class="fas fa-search mr-2"></i>
                              <span>Search</span>
                            </button>
                          </div>
                        </div>
                      </div>
                    </div>
                    
                    <!-- Enhanced Information Cards -->
                    <div class="mt-8 space-y-4">
                      <!-- Exam Preparation Card -->
                      <div class="bg-gradient-to-br from-blue-50 to-indigo-50 border border-blue-200 rounded-xl p-4">
                        <div class="flex items-start space-x-3">
                          <div class="flex-shrink-0 w-8 h-8 bg-blue-100 rounded-lg flex items-center justify-center">
                            <i class="fas fa-clipboard-list text-blue-600 text-sm"></i>
                          </div>
                          <div class="flex-1">
                            <h5 class="font-semibold text-blue-800 text-sm mb-2">Exam Day Checklist</h5>
                            <ul class="text-xs text-blue-700 space-y-1">
                              <li class="flex items-center">
                                <i class="fas fa-check text-blue-500 text-xs mr-2 flex-shrink-0"></i>
                                <span>Arrive 30 minutes before scheduled time</span>
                              </li>
                              <li class="flex items-center">
                                <i class="fas fa-check text-blue-500 text-xs mr-2 flex-shrink-0"></i>
                                <span>Bring printed application form</span>
                              </li>
                              <li class="flex items-center">
                                <i class="fas fa-check text-blue-500 text-xs mr-2 flex-shrink-0"></i>
                                <span>Valid ID and examination materials</span>
                              </li>
                              <li class="flex items-center">
                                <i class="fas fa-check text-blue-500 text-xs mr-2 flex-shrink-0"></i>
                                <span>#2 pencils and calculator (if required)</span>
                              </li>
                            </ul>
                          </div>
                        </div>
                      </div>
                      
                      <!-- Help Card -->
                      <div class="bg-gradient-to-br from-amber-50 to-yellow-50 border border-amber-200 rounded-xl p-4">
                        <div class="flex items-start space-x-3">
                          <div class="flex-shrink-0 w-8 h-8 bg-amber-100 rounded-lg flex items-center justify-center">
                            <i class="fas fa-question-circle text-amber-600 text-sm"></i>
                          </div>
                          <div class="flex-1">
                            <h5 class="font-semibold text-amber-800 text-sm mb-1">Need Help?</h5>
                            <p class="text-xs text-amber-700 mb-2">
                              Can't find your scores or having issues? Use the secure search feature or contact support.
                            </p>
                            <div class="text-xs text-amber-600">
                              <i class="fas fa-phone mr-1"></i>
                              Contact: Testing & Evaluation Center
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                  <div v-else-if="(appointment.status === 'submitted') && !appointment.exam_score">
                    <div class="text-center mb-6">
                      <div class="inline-flex items-center justify-center w-16 h-16 bg-gradient-to-br from-blue-100 to-indigo-100 rounded-full mb-3 shadow-md">
                        <i class="fas fa-hourglass-half text-blue-600 text-2xl"></i>
                      </div>
                      <div class="space-y-1">
                        <h4 class="text-lg font-semibold text-blue-700">Application Submitted</h4>
                        <p class="text-sm text-gray-600">Your score is being processed</p>
                      </div>
                    </div>
                    
                    <!-- Alternative search option for submitted appointments -->
                    <div class="bg-gradient-to-br from-blue-50 to-indigo-50 border border-blue-200 rounded-xl p-4">
                      <div class="flex items-start space-x-3">
                        <div class="flex-shrink-0 w-8 h-8 bg-blue-100 rounded-lg flex items-center justify-center">
                          <i class="fas fa-search text-blue-600 text-sm"></i>
                        </div>
                        <div class="flex-1">
                          <h5 class="font-semibold text-blue-800 text-sm mb-1">Search for Released Scores</h5>
                          <p class="text-xs text-blue-700 mb-3">
                            If your scores have been released, you can search for them using our secure search feature.
                          </p>
                          <button 
                            @click="showSecureSearchModal"
                            class="inline-flex items-center px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-all duration-200 text-sm font-medium shadow-sm hover:shadow-md transform hover:-translate-y-0.5"
                          >
                            <i class="fas fa-shield-alt mr-2"></i>
                            <span>Secure Search</span>
                          </button>
                        </div>
                      </div>
                    </div>
                  </div>
                  <div v-else>
                    <div class="text-center">
                      <div class="inline-flex items-center justify-center w-16 h-16 bg-gradient-to-br from-gray-100 to-gray-200 rounded-full mb-3 shadow-md">
                        <i class="fas fa-calendar-check text-gray-400 text-2xl"></i>
                      </div>
                      <div class="space-y-1">
                        <h4 class="text-lg font-semibold text-gray-600">Exam Pending</h4>
                        <p class="text-sm text-gray-500">Complete your exam and submit your application to receive your score</p>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Secure Search Password Modal -->
    <div v-if="showSecureSearchVerification" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
      <div class="bg-white rounded-lg shadow-xl w-full max-w-md">
        <div class="p-6">
          <div class="flex items-center justify-between mb-4">
            <h3 class="text-lg font-semibold text-gray-900">Secure Search Access</h3>
            <button @click="closeSecureSearchModal" class="text-gray-400 hover:text-gray-600">
              <i class="fas fa-times"></i>
            </button>
          </div>
          
          <div class="mb-4">
            <p class="text-sm text-gray-600 mb-4">
              Please enter your account password to access the secure exam scores search.
            </p>
            
            <div class="space-y-4">
              <div>
                <label for="securePassword" class="block text-sm font-medium text-gray-700 mb-1">Password</label>
                <div class="relative">
                  <input
                    id="securePassword"
                    v-model="secureSearchForm.password"
                    :type="secureSearchForm.showPassword ? 'text' : 'password'"
                    class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-crimson-500"
                    placeholder="Enter your password"
                    @keyup.enter="verifyPasswordAndSearch"
                  >
                  <button
                    type="button"
                    @click="secureSearchForm.showPassword = !secureSearchForm.showPassword"
                    class="absolute inset-y-0 right-0 px-3 py-2 flex items-center focus:outline-none hover:text-crimson-500 transition-colors duration-200"
                  >
                    <i :class="secureSearchForm.showPassword ? 'fas fa-eye-slash' : 'fas fa-eye'" class="h-4 w-4 text-gray-400"></i>
                  </button>
                </div>
              </div>
              
              <div v-if="secureSearchForm.error" class="p-3 bg-red-50 text-red-700 rounded-lg border border-red-200 flex items-start gap-2">
                <i class="fas fa-exclamation-circle mt-1 text-red-500 flex-shrink-0"></i>
                <p class="text-sm">{{ secureSearchForm.error }}</p>
              </div>
            </div>
          </div>
          
          <div class="flex justify-end space-x-3">
            <button 
              @click="closeSecureSearchModal"
              class="px-4 py-2 text-gray-700 bg-gray-100 rounded-lg hover:bg-gray-200 transition-colors duration-200"
            >
              Cancel
            </button>
            <button 
              @click="verifyPasswordAndSearch"
              :disabled="secureSearchForm.loading || !secureSearchForm.password"
              class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors duration-200 disabled:bg-gray-300 disabled:cursor-not-allowed flex items-center"
            >
              <i v-if="secureSearchForm.loading" class="fas fa-spinner fa-spin mr-2"></i>
              <i v-else class="fas fa-search mr-2"></i>
              {{ secureSearchForm.loading ? 'Verifying...' : 'Search Scores' }}
            </button>
          </div>
        </div>
      </div>
    </div>

  </div>
</template>

<script>
import axios from '@/plugins/axios.js'
import { useToast } from '../composables/useToast'
import StudentScoreCard from '../components/StudentScoreCard.vue'

export default {
  name: 'StudentProfile',
  components: {
    StudentScoreCard
  },
  setup() {
    const { showToast } = useToast()
    return { showToast }
  },
  data() {
    return {
      userProfile: null,
      appointments: [],
      loading: true,
      error: null,
      detailedScores: null,
      scoreModelInfo: null,
      loadingScores: false,
      isGeneratingPdf: false,
      showSecureSearchVerification: false,
      secureSearchForm: {
        password: '',
        showPassword: false,
        loading: false,
        error: ''
      }
    }
  },
  computed: {
    hasAppointments() {
      return this.appointments && this.appointments.length > 0
    }
  },
  created() {
    this.fetchUserProfile()
    this.fetchAppointments()
  },
  mounted() {
    // Check for download form URL parameter
    const urlParams = new URLSearchParams(window.location.search);
    const downloadFormId = urlParams.get('download_form');
    
    if (downloadFormId) {
      // Wait for appointments to load, then trigger download
      this.$nextTick(() => {
        setTimeout(() => {
          const appointment = this.appointments.find(app => app.id == downloadFormId);
          if (appointment && appointment.status === 'approved') {
            this.downloadApplicationForm(appointment);
          }
        }, 1000); // Wait 1 second for data to load
      });
    }
  },
  methods: {
    async fetchUserProfile() {
      try {
        const apiUrl = import.meta.env.VITE_API_URL || 'http://127.0.0.1:8000';
        const response = await axios.get(`${apiUrl}/api/profile/`)
        this.userProfile = response.data
      } catch (error) {
        console.error('Error fetching user profile:', error)
        this.showToast('Failed to load user profile', 'error')
      }
    },
    async fetchAppointments() {
      this.loading = true
      try {
        const response = await axios.get('/api/appointments/')
        this.appointments = response.data
      } catch (error) {
        console.error('Error fetching appointments:', error)
        this.error = 'Failed to load appointments'
        this.showToast('Failed to load appointment data', 'error')
      } finally {
        this.loading = false
      }
    },
    formatDate(dateString) {
      return new Date(dateString).toLocaleDateString('en-US', {
        year: 'numeric',
        month: 'short',
        day: 'numeric'
      })
    },
    formatDateTime(dateTimeString) {
      // Use a shorter format on mobile screens
      const options = window.innerWidth < 640 ? 
        {
          year: 'numeric',
          month: 'short',
          day: 'numeric',
          hour: '2-digit',
          minute: '2-digit'
        } : 
        {
          year: 'numeric',
          month: 'short',
          day: 'numeric',
          hour: '2-digit',
          minute: '2-digit'
        };
      
      return new Date(dateTimeString).toLocaleString('en-US', options)
    },
    getStatusClass(status) {
      const classes = {
        pending: 'bg-yellow-100 text-yellow-800',
        approved: 'bg-green-100 text-green-800',
        rejected: 'bg-red-100 text-red-800',
        submitted: 'bg-blue-100 text-blue-800',
        rescheduled: 'bg-purple-100 text-purple-800'
      }
      return classes[status] || ''
    },
    getScoreBarClass(score) {
      if (score >= 80) return 'bg-green-500';
      if (score >= 60) return 'bg-yellow-500';
      return 'bg-red-500';
    },
    async fetchDetailedScores() {
      try {
        // Instead of making a separate API call, use the appointment data we already have
        const appointmentsWithScores = this.appointments.filter(
          appointment => (appointment.status === 'submitted' || appointment.status === 'approved') && appointment.exam_score
        );
        
        if (appointmentsWithScores.length === 0) {
          this.showToast('No exam scores found for your account', 'warning');
          return;
        }
        
        // Get the most recent appointment with a score
        const sortedAppointments = [...appointmentsWithScores].sort(
          (a, b) => new Date(b.exam_score.created_at) - new Date(a.exam_score.created_at)
        );
        
        const latestAppointment = sortedAppointments[0];
        
        // If we already have the full score object, use it directly
        if (latestAppointment.exam_score.part1 || latestAppointment.exam_score.part2) {
          this.detailedScores = latestAppointment.exam_score;
          return;
        }
        
        // Otherwise, we need to fetch additional details for this score
        // Try to fetch more details for this specific exam score if needed
        const scoreId = latestAppointment.exam_score.id;
        try {
          const response = await axios.get(`/api/appointments/${latestAppointment.id}/`);
          if (response.data && response.data.exam_score) {
            this.detailedScores = response.data.exam_score;
          } else {
            // If we can't get more details, use what we have
            this.detailedScores = {
              id: scoreId,
              app_no: latestAppointment.application_number || `A-${latestAppointment.id}`,
              name: this.userProfile?.full_name || 'Student',
              school: this.userProfile?.school_name || '',
              exam_type: latestAppointment.program || 'COLLEGE',
              score: latestAppointment.exam_score.score,
              exam_date: latestAppointment.preferred_date,
              created_at: latestAppointment.exam_score.created_at
            };
          }
        } catch (detailError) {
          console.error('Error fetching appointment details:', detailError);
          // Use the basic data we already have
          this.detailedScores = latestAppointment.exam_score;
        }
      } catch (error) {
        console.error('Error processing detailed scores:', error);
        this.showToast('Failed to process exam score data', 'error');
      }
    },
    closeDetailedScores() {
      this.detailedScores = null;
    },
    getTimeSlotDisplay(appointment) {
      // Use assigned test time slot if available, otherwise use the original time slot
      const timeSlot = appointment.assigned_test_time_slot || appointment.time_slot;
      
      // Format the time slot nicely
      if (timeSlot === 'morning') {
        return 'Morning';
      } else if (timeSlot === 'afternoon') {
        return 'Afternoon';
      }
      return timeSlot || 'Not specified';
    },
    
    async fetchScoresForAppointment(appointment) {
      this.loadingScores = true;
      
      try {
        // Try to fetch scores for the specific appointment
        const apiUrl = import.meta.env.VITE_API_URL || 'http://127.0.0.1:8000';
        const response = await axios.get(`${apiUrl}/api/appointments/${appointment.id}/scores/`);
        
        if (response.data) {
          // Successfully retrieved scores
          this.showToast('Scores retrieved successfully!', 'success');
          
          // Update the appointment with the score data
          const appointmentIndex = this.appointments.findIndex(
            app => app.id === appointment.id
          );
          
          if (appointmentIndex !== -1) {
            this.appointments[appointmentIndex].exam_score = response.data;
            // Force reactivity update
            this.$forceUpdate();
          }
        } else {
          this.showToast('No scores available yet. Please try again later.', 'warning');
        }
      } catch (error) {
        console.error('Error fetching scores:', error);
        if (error.response?.status === 404) {
          this.showToast('No scores found for this appointment yet.', 'warning');
        } else {
          this.showToast('Failed to retrieve scores. Please try again.', 'error');
        }
      } finally {
        this.loadingScores = false;
      }
    },
    
    showSecureSearchModal() {
      this.showSecureSearchVerification = true;
      this.secureSearchForm.password = '';
      this.secureSearchForm.error = '';
      this.secureSearchForm.loading = false;
    },
    
    async downloadApplicationForm(appointment) {
      if (!appointment || this.isGeneratingPdf) {
        console.warn('Cannot download form: No appointment data or PDF generation already in progress.');
        return;
      }
      
      try {
        this.isGeneratingPdf = true;
        this.showToast('Generating application form PDF...', 'info');
        
        // Import ApplicationForm component dynamically
        const { default: ApplicationForm } = await import('@/components/ApplicationForm.vue');
        
        // Create a Vue instance with the ApplicationForm component
        const { createApp } = await import('vue');
        
        // Prepare form data from appointment
        const formData = {
          appointmentId: appointment.id,
          fullName: appointment.full_name,
          email: appointment.email,
          birthMonth: appointment.birth_month,
          birthDay: appointment.birth_day,
          birthYear: appointment.birth_year,
          gender: {
            male: appointment.gender === 'Male',
            female: appointment.gender === 'Female'
          },
          age: appointment.age,
          homeAddress: appointment.home_address,
          citizenship: appointment.citizenship,
          contactNumber: appointment.contact_number,
          programName: appointment.program?.name || 'College Entrance Test',
          preferredDate: appointment.created_at,
          applicantType: appointment.applicant_type,
          schoolName: appointment.school_name,
          wmsucetExperience: {
            firstTime: appointment.is_first_time_taking_test,
            notFirstTime: !appointment.is_first_time_taking_test,
            timesTaken: appointment.times_taken_test || ''
          },
          highSchoolCode: appointment.high_school_code || '',
          // Test details
          test_date: appointment.test_session?.exam_date,
          test_center: appointment.test_center?.name,
          test_center_code: appointment.test_center?.id,
          room_number: appointment.test_room?.name || appointment.test_room?.room_code,
          room_code: appointment.test_room?.room_code,
          time_slot: appointment.assigned_test_time_slot || appointment.time_slot
        };
        
        // Create a temporary container for the form
        const tempContainer = document.createElement('div');
        tempContainer.style.position = 'absolute';
        tempContainer.style.left = '-9999px';
        tempContainer.style.top = '-9999px';
        tempContainer.style.width = '8.5in';
        tempContainer.style.height = '14in';
        document.body.appendChild(tempContainer);
        
        // Create Vue app instance
        const app = createApp(ApplicationForm, {
          appointmentData: formData,
          outputPdfOnly: true,
          startDownload: true
        });
        
        // Handle PDF generation complete event
        app.config.globalProperties.$emit = (event, data) => {
          if (event === 'pdf-generation-complete') {
            this.isGeneratingPdf = false;
            document.body.removeChild(tempContainer);
            
            if (data.success) {
              this.showToast('Application form downloaded successfully!', 'success');
            } else {
              this.showToast('Failed to generate PDF. Please try again.', 'error');
              console.error('PDF generation failed:', data.error);
            }
          }
        };
        
        // Mount the app
        const instance = app.mount(tempContainer);
        
        // Fallback timeout in case PDF generation fails
        setTimeout(() => {
          if (this.isGeneratingPdf) {
            this.isGeneratingPdf = false;
            if (document.body.contains(tempContainer)) {
              document.body.removeChild(tempContainer);
            }
            this.showToast('PDF generation timed out. Please try again.', 'error');
          }
        }, 30000); // 30 second timeout
        
      } catch (error) {
        console.error('Error downloading application form:', error);
        this.isGeneratingPdf = false;
        this.showToast('Failed to download application form. Please try again.', 'error');
      }
    },
    
    closeSecureSearchModal() {
      this.showSecureSearchVerification = false;
      this.secureSearchForm.password = '';
      this.secureSearchForm.error = '';
      this.secureSearchForm.loading = false;
    },
    
    async verifyPasswordAndSearch() {
      if (!this.secureSearchForm.password) {
        this.secureSearchForm.error = 'Please enter your password';
        return;
      }
      
      this.secureSearchForm.loading = true;
      this.secureSearchForm.error = '';
      
      try {
        // Verify password with backend
        const apiUrl = import.meta.env.VITE_API_URL || 'http://127.0.0.1:8000';
        const verifyResponse = await axios.post(`${apiUrl}/api/verify-password/`, {
          password: this.secureSearchForm.password
        });
        
        if (verifyResponse.data.valid) {
          // Password is correct, redirect to the secure search page
          this.showToast('Password verified! Redirecting to secure search...', 'success');
          this.closeSecureSearchModal();
          
          // Navigate to the secure search page
          this.$router.push('/scores');
        } else {
          this.secureSearchForm.error = 'Invalid password. Please try again.';
        }
      } catch (error) {
        console.error('Error verifying password:', error);
        if (error.response?.status === 401) {
          this.secureSearchForm.error = 'Invalid password. Please try again.';
        } else {
          this.secureSearchForm.error = 'Authentication failed. Please try again.';
        }
      } finally {
        this.secureSearchForm.loading = false;
      }
    }
  }
}
</script>

<style scoped>
/* Enhanced animations */
.score-bar {
  transition: width 1.5s cubic-bezier(0.4, 0, 0.2, 1);
}

/* Improved status badges */
.bg-yellow-100, .bg-green-100, .bg-red-100, .bg-blue-100, .bg-purple-100 {
  opacity: 0.9;
  transition: opacity 0.2s ease;
}

.bg-yellow-100:hover, .bg-green-100:hover, .bg-red-100:hover, .bg-blue-100:hover, .bg-purple-100:hover {
  opacity: 1;
}

/* Card hover effects */
.hover\:shadow-xl:hover {
  transform: translateY(-2px);
}

/* Loading spinner animation */
@keyframes spin {
  to {
    transform: rotate(360deg);
  }
}

/* Score bar animation */
@keyframes expandWidth {
  from {
    width: 0;
  }
  to {
    width: var(--score-width);
  }
}

/* Score details transitions */
.detailed-scores-enter-active, 
.detailed-scores-leave-active {
  transition: all 0.3s ease-out;
}
.detailed-scores-enter-from, 
.detailed-scores-leave-to {
  opacity: 0;
  transform: translateY(-20px);
}

/* Extra small text size for very small screens */
.text-2xs {
  font-size: 0.65rem;
  line-height: 1rem;
}

/* Additional responsive adjustments for very small screens */
@media (max-width: 360px) {
  .container {
    padding-left: 0.5rem;
    padding-right: 0.5rem;
  }
  
  .p-4 {
    padding: 0.75rem;
  }
  
  .text-base {
    font-size: 0.875rem;
  }
  
  .text-xl {
    font-size: 1.125rem;
  }
}

/* Enhanced hover effects and transitions */
.group:hover .group-hover\:text-crimson-600 {
  color: #dc2626;
}

/* Enhanced card animations */
.transform.hover\:-translate-y-1:hover {
  transform: translateY(-0.25rem);
}

/* Pulsing animation for status indicators */
@keyframes pulse-slow {
  0%, 100% {
    opacity: 1;
  }
  50% {
    opacity: 0.5;
  }
}

.animate-pulse-slow {
  animation: pulse-slow 2s cubic-bezier(0.4, 0, 0.6, 1) infinite;
}

/* Enhanced gradient backgrounds */
.bg-gradient-shimmer {
  background: linear-gradient(135deg, #f3f4f6 0%, #e5e7eb 25%, #f9fafb 50%, #e5e7eb 75%, #f3f4f6 100%);
  background-size: 400% 400%;
  animation: shimmer 3s ease-in-out infinite;
}

@keyframes shimmer {
  0% {
    background-position: 0% 50%;
  }
  50% {
    background-position: 100% 50%;
  }
  100% {
    background-position: 0% 50%;
  }
}

/* Enhanced focus styles for accessibility */
button:focus,
.focus\:ring-2:focus {
  outline: 2px solid transparent;
  outline-offset: 2px;
  box-shadow: 0 0 0 2px #dc2626, 0 0 0 4px rgba(220, 38, 38, 0.1);
}

/* Mobile-first responsive improvements */
@media (max-width: 640px) {
  .container {
    padding-left: 1rem;
    padding-right: 1rem;
  }
  
  .space-y-6 > * + * {
    margin-top: 1.5rem;
  }
  
  .text-4xl {
    font-size: 2rem;
  }
  
  .text-3xl {
    font-size: 1.5rem;
  }
}

/* Improved print styles */
@media print {
  .no-print {
    display: none !important;
  }
  
  .print-friendly {
    background: white !important;
    color: black !important;
    box-shadow: none !important;
  }
}
</style>