<template>
  <div>
    <!-- Modal Backdrop with transition -->
    <transition name="fade">
      <div v-if="modelValue"
           class="fixed inset-0 bg-black bg-opacity-50"
           @click="close">
      </div>
    </transition>

    <!-- Modal Content with transition -->
    <transition name="modal"> 
      <div v-if="modelValue"
           class="fixed inset-0 items-center justify-center z-50 flex">
        <div :class="[
          'bg-white p-6 md:p-8 lg:p-10 rounded-xl shadow-xl w-full mx-2 md:mx-auto my-2 md:my-4 overflow-y-auto',
          currentStep === 5 ? 'max-w-sm md:max-w-5xl lg:max-w-6xl xl:max-w-7xl max-h-[95vh]' : 'max-w-sm md:max-w-4xl lg:max-w-5xl max-h-[92vh]'
        ]">
          <div class="flex justify-between items-center mb-6">
            <h3 class="text-xl md:text-2xl font-bold text-gray-900 flex items-center gap-3">
              <div class="w-10 h-10 rounded-lg bg-crimson-100 flex items-center justify-center">
                <i class="fas fa-calendar-alt text-xl text-crimson-600"></i>
              </div>
              {{ program?.name || 'Schedule an Appointment' }} - Step {{ currentStep }} of 5
            </h3>
            <button @click="close" class="text-gray-400 hover:text-gray-500 p-2 hover:bg-gray-100 rounded-lg transition-all">
              <i class="fas fa-times text-xl"></i>
            </button>
          </div>
          
          <div v-if="loading" class="flex justify-center py-16">
            <div class="w-12 h-12 rounded-full border-4 border-crimson-200 border-t-crimson-600 animate-spin"></div>
          </div>

          <div v-else-if="error" class="rounded-md bg-red-50 p-4 my-4">
            <div class="flex">
              <div class="flex-shrink-0">
                <i class="fas fa-exclamation-triangle text-red-500"></i>
              </div>
              <div class="ml-3">
                <h3 class="text-sm font-medium text-red-800">Error</h3>
                <div class="mt-2 text-sm text-red-700">{{ error }}</div>
              </div>
            </div>
          </div>
          
          <div v-else>
            <form @submit.prevent="submitForm" class="space-y-8">
              <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 md:gap-8 lg:gap-10">
                <!-- STEP 1: PERSONAL INFO (Column 1 on LG) -->
                <div v-if="currentStep === 1">
                  <!-- Duplicate Registration Warning -->
                  <div v-if="!checkDuplicateRegistration()" class="mb-6 p-4 bg-yellow-50 border-l-4 border-yellow-500 rounded-md shadow-sm">
                    <div class="flex">
                      <div class="flex-shrink-0">
                        <i class="fas fa-ban text-yellow-600 mr-3"></i>
                      </div>
                      <div>
                        <h5 class="font-semibold text-yellow-800">Registration Not Allowed</h5>
                        <p class="text-sm text-yellow-700 mt-1">
                          You already have an existing appointment for <strong>{{ props.program?.name || 'this program' }}</strong>. Each student can only register once per exam program. If you need to make changes, please cancel your existing appointment first.
                        </p>
                      </div>
                    </div>
                  </div>
                  
                  <!-- Personal Information Section Card -->
                  <div class="space-y-6 bg-white rounded-xl p-6 border border-gray-200 shadow-sm">
                    <div class="flex items-center gap-3 text-lg font-semibold text-gray-900 mb-4 pb-3 border-b border-gray-200">
                      <div class="w-8 h-8 rounded-lg bg-crimson-100 flex items-center justify-center">
                        <i class="fas fa-user-circle text-crimson-500"></i>
                      </div>
                      <h4>Personal Information</h4>
                    </div>
                    
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-x-6 gap-y-5">
                      <!-- Last Name -->
                      <div class="space-y-2">
                        <label for="lastName" class="block text-sm font-medium text-gray-700 mb-1.5">Last Name</label>
                        <div class="relative">
                          <input 
                            id="lastName"
                            v-model="formData.lastName"
                            @input="handleTextInput('lastName')"
                            @blur="markAsTouched('lastName'); validateLastName()"
                            type="text"
                            :class="['w-full px-4 py-2.5 border rounded-lg text-base transition-all shadow-sm focus:ring-2 focus:ring-offset-0', getInputClasses('lastName')]"
                            placeholder="Enter your last name"
                          />
                          <div v-if="isFieldValid('lastName')" class="absolute inset-y-0 right-3 flex items-center text-green-500 animate-fadeIn">
                            <i class="fas fa-check-circle"></i>
                          </div>
                        </div>
                        <p v-if="isFieldInvalid('lastName')" class="text-sm text-red-600 mt-1 error-text">
                          {{ validationErrors.lastName }}
                        </p>
                      </div>
                      
                      <!-- First Name -->
                      <div class="space-y-2">
                        <label for="firstName" class="block text-sm font-medium text-gray-700 mb-1.5">First Name</label>
                        <div class="relative">
                          <input 
                            id="firstName"
                            v-model="formData.firstName"
                            @input="handleTextInput('firstName')"
                            @blur="markAsTouched('firstName'); validateFirstName()"
                            type="text"
                            :class="['w-full px-4 py-2.5 border rounded-lg text-base transition-all shadow-sm focus:ring-2 focus:ring-offset-0', getInputClasses('firstName')]"
                            placeholder="Enter your first name"
                          />
                          <div v-if="isFieldValid('firstName')" class="absolute inset-y-0 right-3 flex items-center text-green-500 animate-fadeIn">
                            <i class="fas fa-check-circle"></i>
                          </div>
                        </div>
                        <p v-if="isFieldInvalid('firstName')" class="text-sm text-red-600 mt-1 error-text">
                          {{ validationErrors.firstName }}
                        </p>
                      </div>
                      
                      <!-- Middle Name -->
                      <div class="space-y-2">
                        <label for="middleName" class="block text-sm font-medium text-gray-700 mb-1.5">Middle Name</label>
                        <div class="relative">
                          <input 
                            id="middleName"
                            v-model="formData.middleName"
                            @input="handleTextInput('middleName')"
                            @blur="markAsTouched('middleName'); validateMiddleName()"
                            type="text"
                            :class="['w-full px-4 py-2.5 border rounded-lg text-base transition-all shadow-sm focus:ring-2 focus:ring-offset-0', getInputClasses('middleName')]"
                            placeholder="Enter your middle name (Optional)"
                          />
                          <div v-if="isFieldValid('middleName')" class="absolute inset-y-0 right-3 flex items-center text-green-500 animate-fadeIn">
                            <i class="fas fa-check-circle"></i>
                          </div>
                        </div>
                        <p v-if="isFieldInvalid('middleName')" class="text-sm text-red-600 mt-1 error-text">
                          {{ validationErrors.middleName }}
                        </p>
                      </div>
                      
                      <!-- Contact Number -->
                      <div class="space-y-2">
                        <label for="contactNumber" class="block text-sm font-medium text-gray-700 mb-1.5">Contact Number</label>
                        <div class="relative">
                          <input 
                            id="contactNumber"
                            v-model="formData.contactNumber"
                            @input="markAsTouched('contactNumber'); validateContactNumber()"
                            @blur="markAsTouched('contactNumber'); validateContactNumber()"
                            type="tel"
                            :class="['w-full px-4 py-2.5 border rounded-lg text-base transition-all shadow-sm focus:ring-2 focus:ring-offset-0', getInputClasses('contactNumber')]"
                            placeholder="e.g., +63 9XX XXX XXXX"
                          />
                          <div v-if="isFieldValid('contactNumber')" class="absolute inset-y-0 right-3 flex items-center text-green-500 animate-fadeIn">
                            <i class="fas fa-check-circle"></i>
                          </div>
                        </div>
                        <p v-if="isFieldInvalid('contactNumber')" class="text-sm text-red-600 mt-1 error-text">
                          {{ validationErrors.contactNumber }}
                        </p>
                      </div>
                      
                      <!-- Email Address -->
                      <div class="space-y-2 md:col-span-2">
                        <label for="email" class="block text-sm font-medium text-gray-700 mb-1.5">Email Address</label>
                        <div class="relative">
                          <input 
                            id="email"
                            v-model="formData.email"
                            @input="markAsTouched('email'); validateEmail()"
                            @blur="markAsTouched('email'); validateEmail()"
                            type="email"
                            :class="['w-full px-4 py-2.5 border rounded-lg bg-gray-100 text-base transition-all shadow-sm focus:ring-2 focus:ring-offset-0', getInputClasses('email')]"
                            readonly
                          />
                          <div v-if="isFieldValid('email')" class="absolute inset-y-0 right-3 flex items-center text-green-500 animate-fadeIn">
                            <i class="fas fa-check-circle"></i>
                          </div>
                        </div>
                        <p class="text-xs text-gray-500">This email is linked to your account.</p>
                        <p v-if="isFieldInvalid('email')" class="text-sm text-red-600 mt-1 error-text">
                          {{ validationErrors.email }}
                        </p>
                      </div>
                      
                      <!-- Birth Date -->
                      <div class="space-y-2 md:col-span-full">
                        <label class="block text-sm font-medium text-gray-700 mb-1.5">Birth Date</label>
                        <div class="grid grid-cols-3 gap-3">
                          <div>
                            <select 
                              v-model="formData.birthMonth"
                              @blur="markAsTouched('birthMonth'); validateBirthDate()"
                              :class="['w-full px-4 py-2.5 border rounded-lg text-base transition-all shadow-sm', 
                                touchedFields.birthMonth && validationErrors.birthDate ? 'border-red-500 focus:ring-red-500/50' : 'border-gray-300 focus:ring-crimson-500/50 focus:border-crimson-500']"
                            >
                              <option value="" disabled>Month</option>
                              <option v-for="i in 12" :key="`month-${i}`" :value="String(i).padStart(2, '0')">
                                {{ new Date(0, i-1).toLocaleString('default', { month: 'long' }) }}
                              </option>
                            </select>
                          </div>
                          <div>
                            <select 
                              v-model="formData.birthDay"
                              @blur="markAsTouched('birthDay'); validateBirthDate()"
                              :class="['w-full px-4 py-2.5 border rounded-lg text-base transition-all shadow-sm', 
                                touchedFields.birthDay && validationErrors.birthDate ? 'border-red-500 focus:ring-red-500/50' : 'border-gray-300 focus:ring-crimson-500/50 focus:border-crimson-500']"
                            >
                              <option value="" disabled>Day</option>
                              <option v-for="i in 31" :key="`day-${i}`" :value="String(i).padStart(2, '0')">{{ i }}</option>
                            </select>
                          </div>
                          <div>
                            <select 
                              v-model="formData.birthYear"
                              @blur="markAsTouched('birthYear'); validateBirthDate()"
                              :class="['w-full px-4 py-2.5 border rounded-lg text-base transition-all shadow-sm', 
                                touchedFields.birthYear && validationErrors.birthDate ? 'border-red-500 focus:ring-red-500/50' : 'border-gray-300 focus:ring-crimson-500/50 focus:border-crimson-500']"
                            >
                              <option value="" disabled>Year</option>
                              <option v-for="year in birthYears" :key="`year-${year}`" :value="String(year)">{{ year }}</option>
                            </select>
                          </div>
                        </div>
                        <p v-if="touchedFields.birthMonth && validationErrors.birthDate" class="text-sm text-red-600 mt-1 error-text">
                          {{ validationErrors.birthDate }}
                        </p>
                      </div>
                      
                      <!-- Gender -->
                      <div class="space-y-2 md:col-span-full">
                        <label class="block text-sm font-medium text-gray-700 mb-1.5">Gender</label>
                        <div class="flex flex-col sm:flex-row space-y-3 sm:space-y-0 sm:space-x-6 mt-2">
                          <label class="inline-flex items-center hover:bg-gray-50 p-2 rounded-lg transition-colors cursor-pointer">
                            <input 
                              type="radio" 
                              v-model="formData.gender" 
                              value="male"
                              @change="markAsTouched('gender'); validateGender()"
                              class="form-radio text-crimson-600 focus:ring-crimson-500 h-5 w-5 border-gray-300"
                            >
                            <span class="ml-2 text-gray-700 text-base">Male</span>
                          </label>
                          <label class="inline-flex items-center hover:bg-gray-50 p-2 rounded-lg transition-colors cursor-pointer">
                            <input 
                              type="radio" 
                              v-model="formData.gender" 
                              value="female"
                              @change="markAsTouched('gender'); validateGender()"
                              class="form-radio text-crimson-600 focus:ring-crimson-500 h-5 w-5 border-gray-300"
                            >
                            <span class="ml-2 text-gray-700 text-base">Female</span>
                          </label>
                        </div>
                        <p v-if="touchedFields.gender && validationErrors.gender" class="text-sm text-red-600 mt-1 error-text">
                          {{ validationErrors.gender }}
                        </p>
                      </div>
                    </div>
                  </div>
                </div>

                <!-- STEP 1: ADDITIONAL INFO (Column 2 on LG) -->
                <div v-if="currentStep === 1">
                  <!-- Additional Information Section Card -->
                  <div class="space-y-6 bg-white rounded-xl p-6 border border-gray-200 shadow-sm">
                    <div class="flex items-center gap-3 text-lg font-semibold text-gray-900 mb-4 pb-3 border-b border-gray-200">
                      <div class="w-8 h-8 rounded-lg bg-crimson-100 flex items-center justify-center">
                        <i class="fas fa-info-circle text-crimson-500"></i>
                      </div>
                      <h4>Additional Information</h4>
                    </div>
                    
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-x-6 gap-y-5">
                      <!-- Display Calculated Age (Readonly) -->
                      <div class="space-y-2">
                        <label for="calculatedAge" class="block text-sm font-medium text-gray-700 mb-1.5">Age</label>
                        <input 
                          id="calculatedAge"
                          :value="formData.age" 
                          type="text"
                          class="w-full px-4 py-2.5 border border-gray-200 rounded-lg bg-gray-50 text-base transition-all focus:ring-0 focus:border-gray-300 shadow-sm"
                          readonly
                          placeholder="Age (auto-calculated)"
                        />
                         <p v-if="validationErrors.age" class="text-sm text-red-600 mt-1 error-text">
                          {{ validationErrors.age }}
                        </p>
                      </div>
                      
                      <!-- Street/Purok -->
                      <div class="space-y-2">
                        <label for="streetPurok" class="block text-sm font-medium text-gray-700 mb-1.5">Street/Purok</label>
                        <div class="relative">
                          <input 
                            id="streetPurok"
                            v-model="formData.streetPurok"
                            @input="handleTextInput('streetPurok')"
                            @blur="markAsTouched('streetPurok'); validateStreetPurok()"
                            type="text"
                            :class="['w-full px-4 py-2.5 border rounded-lg text-base transition-all shadow-sm focus:ring-2 focus:ring-offset-0', getInputClasses('streetPurok')]"
                            placeholder="Enter your Street/Purok"
                          />
                          <div v-if="isFieldValid('streetPurok')" class="absolute inset-y-0 right-3 flex items-center text-green-500 animate-fadeIn">
                            <i class="fas fa-check-circle"></i>
                          </div>
                        </div>
                        <p v-if="isFieldInvalid('streetPurok')" class="text-sm text-red-600 mt-1 error-text">
                          {{ validationErrors.streetPurok }}
                        </p>
                      </div>

                      <!-- Location Dropdowns Component -->
                      <div class="md:col-span-2">
                        <LocationDropdowns 
                          v-model="locationData"
                          @change="onLocationChange"
                          :show-debug="false"
                        />
                      </div>
                      
                      <!-- Citizenship -->
                      <div class="space-y-2">
                        <label for="citizenship" class="block text-sm font-medium text-gray-700 mb-1.5">Citizenship</label>
                        <div class="relative">
                          <input 
                            id="citizenship"
                            v-model="formData.citizenship"
                            @input="handleTextInput('citizenship')"
                            @blur="markAsTouched('citizenship'); validateCitizenship()"
                            type="text"
                            list="citizenship-list"
                            :class="['w-full px-4 py-2.5 border rounded-lg text-base transition-all shadow-sm focus:ring-2 focus:ring-offset-0', getInputClasses('citizenship')]"
                            placeholder="e.g., Filipino"
                            autocomplete="off"
                          />
                          <div v-if="isFieldValid('citizenship')" class="absolute inset-y-0 right-3 flex items-center text-green-500 animate-fadeIn">
                            <i class="fas fa-check-circle"></i>
                          </div>
                        </div>
                        <datalist id="citizenship-list">
                          <option v-for="citizenship in citizenshipOptions" :key="citizenship" :value="citizenship">{{ citizenship }}</option>
                        </datalist>
                        <p v-if="isFieldInvalid('citizenship')" class="text-sm text-red-600 mt-1 error-text">
                          {{ validationErrors.citizenship }}
                        </p>
                      </div>
                      
                      <!-- High School Code -->
                      <div class="space-y-2 md:col-span-full">
                        <label for="highSchoolCode" class="block text-sm font-medium text-gray-700 mb-1.5">High School Code (if known)</label>
                        <input 
                          id="highSchoolCode"
                          v-model="formData.highSchoolCode"
                          type="text"
                          class="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500/50 focus:border-crimson-500 text-base transition-all shadow-sm"
                          placeholder="Optional"
                        />
                      </div>
                    </div>
                  </div>
                </div>

                <!-- STEP 2: EDUCATION/WMSUCET (Spans 2 columns on LG) -->
                <div v-if="currentStep === 2" class="space-y-8 lg:col-span-2">
                  <!-- WMSUCET Experience Section -->
                  <div class="space-y-6 bg-white rounded-xl p-6 border border-gray-200 shadow-sm">
                    <div class="flex items-center gap-3 text-lg font-semibold text-gray-900 mb-4 pb-3 border-b border-gray-200">
                      <div class="w-8 h-8 rounded-lg bg-crimson-100 flex items-center justify-center">
                        <i class="fas fa-history text-crimson-500"></i>
                      </div>
                      <h4>WMSUCET Experience</h4>
                    </div>
                    
                    <div class="grid grid-cols-1 gap-x-6 gap-y-5">
                      <div class="space-y-2">
                        <label class="block text-sm font-medium text-gray-700 mb-2">Is this your first time to take the WMSUCET?</label>
                        <div class="flex flex-col sm:flex-row space-y-3 sm:space-y-0 sm:space-x-6 mt-2">
                          <label class="inline-flex items-center hover:bg-gray-50 p-2 rounded-lg transition-colors cursor-pointer">
                            <input 
                              type="radio" 
                              v-model="formData.wmsucetExperience.firstTime" 
                              :value="true"
                              @change="formData.wmsucetExperience.notFirstTime = false; validateWmsucetExperience()"
                              class="form-radio text-crimson-600 focus:ring-crimson-500 h-5 w-5 border-gray-300"
                            >
                            <span class="ml-2 text-gray-700 text-base">Yes</span>
                          </label>
                          <label class="inline-flex items-center hover:bg-gray-50 p-2 rounded-lg transition-colors cursor-pointer">
                            <input 
                              type="radio" 
                              v-model="formData.wmsucetExperience.notFirstTime" 
                              :value="true"
                              @change="formData.wmsucetExperience.firstTime = false; validateWmsucetExperience()"
                              class="form-radio text-crimson-600 focus:ring-crimson-500 h-5 w-5 border-gray-300"
                            >
                            <span class="ml-2 text-gray-700 text-base">No</span>
                          </label>
                        </div>
                        <p v-if="validationErrors.wmsucetExperience" class="text-sm text-red-600 mt-1 error-text">
                          {{ validationErrors.wmsucetExperience }}
                        </p>
                      </div>
                      
                      <!-- Show only if not first time -->
                      <div v-if="formData.wmsucetExperience.notFirstTime" class="space-y-2 animate-fadeIn">
                        <label for="timesTaken" class="block text-sm font-medium text-gray-700 mb-1.5">How many times have you already taken it?</label>
                        <div class="relative">
                          <input 
                            id="timesTaken"
                            v-model="formData.wmsucetExperience.timesTaken"
                            @blur="validateWmsucetExperience()"
                            type="number"
                            min="1"
                            max="10"
                            class="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500/50 focus:border-crimson-500 text-base transition-all shadow-sm"
                            placeholder="Number of times"
                          />
                        </div>
                      </div>
                    </div>
                  </div>
                  
                  <!-- Applicant Type Section -->
                  <div class="space-y-6 bg-white rounded-xl p-6 border border-gray-200 shadow-sm">
                    <div class="flex items-center gap-3 text-lg font-semibold text-gray-900 mb-4 pb-3 border-b border-gray-200">
                      <div class="w-8 h-8 rounded-lg bg-crimson-100 flex items-center justify-center">
                        <i class="fas fa-graduation-cap text-crimson-500"></i>
                      </div>
                      <h4>Applicant Type</h4>
                    </div>
                    
                    <div class="grid grid-cols-1 gap-x-6 gap-y-5">
                      <div class="space-y-2">
                        <label class="block text-sm font-medium text-gray-700 mb-1.5">Select Type</label>
                        <select 
                          id="applicantType"
                          v-model="formData.applicantType"
                          @change="markAsTouched('applicantType'); validateApplicantType()"
                          :class="['w-full px-4 py-2.5 border rounded-lg text-base transition-all shadow-sm',
                            touchedFields.applicantType && validationErrors.applicantType ? 
                            'border-red-500 focus:ring-red-500/50' : 
                            'border-gray-300 focus:ring-crimson-500/50 focus:border-crimson-500']"
                        >
                          <option value="" disabled>Select your applicant type</option>
                          <option value="senior_high_graduating">Senior High School Graduating Student</option>
                          <option value="senior_high_graduate">Senior High School Graduate</option>
                          <option value="college">College Student</option>
                        </select>
                        <p v-if="touchedFields.applicantType && validationErrors.applicantType" class="text-sm text-red-600 mt-1 error-text">
                          {{ validationErrors.applicantType }}
                        </p>
                      </div>
                      
                      <!-- Senior High School Graduating fields -->
                      <div v-if="formData.applicantType === 'senior_high_graduating'" class="p-4 bg-blue-50 rounded-xl border border-blue-200 space-y-5 md:col-span-full animate-fadeIn">
                        <h5 class="font-medium text-base text-crimson-600">Senior High School Details</h5>
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-x-6 gap-y-5">
                          <div class="space-y-2">
                            <label for="seniorGraduatingSchoolName" class="block text-sm font-medium text-gray-700">School Name</label>
                            <div class="relative">
                              <input 
                                id="seniorGraduatingSchoolName"
                                v-model="formData.seniorGraduating.schoolName"
                                @input="handleTextInput('seniorGraduatingSchoolName', 'seniorGraduating.schoolName')"
                                @blur="validateApplicantType()"
                                type="text"
                                class="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500/50 focus:border-crimson-500 text-base transition-all shadow-sm"
                                placeholder="Enter your school name"
                                list="zamboanga-schools-list"
                              />
                              <datalist id="zamboanga-schools-list">
                                <option v-for="school in zamboanganSchools" :key="school" :value="school">{{ school }}</option>
                              </datalist>
                            </div>
                          </div>
                          
                          <div class="space-y-2">
                            <label for="seniorGraduatingSchoolAddress" class="block text-sm font-medium text-gray-700">School Address</label>
                            <div class="relative">
                              <input 
                                id="seniorGraduatingSchoolAddress"
                                v-model="formData.seniorGraduating.schoolAddress"
                                @input="handleAddressInput('seniorGraduatingSchoolAddress', 'seniorGraduating.schoolAddress')"
                                @focus="showAddressSuggestions('seniorGraduatingSchoolAddress')"
                                @blur="hideAddressSuggestions('seniorGraduatingSchoolAddress')"
                                type="text"
                                class="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500/50 focus:border-crimson-500 text-base transition-all shadow-sm"
                                placeholder="Enter your school address"
                                autocomplete="off"
                              />
                              <!-- Address Suggestions Dropdown -->
                              <div v-if="addressSuggestions.seniorGraduatingSchoolAddress.show && addressSuggestions.seniorGraduatingSchoolAddress.results.length > 0"
                                   class="absolute z-50 w-full mt-1 bg-white border border-gray-300 rounded-lg shadow-lg max-h-60 overflow-y-auto">
                                <div v-for="(suggestion, index) in addressSuggestions.seniorGraduatingSchoolAddress.results" 
                                     :key="index"
                                     @mousedown="selectAddressSuggestion('seniorGraduatingSchoolAddress', suggestion)"
                                     class="px-4 py-2 hover:bg-gray-100 cursor-pointer border-b border-gray-100 last:border-b-0">
                                  <div class="text-sm font-medium text-gray-900">{{ suggestion.display_name }}</div>
                                  <div class="text-xs text-gray-500">{{ suggestion.type }}</div>
                                </div>
                              </div>
                              <!-- Loading indicator -->
                              <div v-if="addressSuggestions.seniorGraduatingSchoolAddress.loading"
                                   class="absolute inset-y-0 right-3 flex items-center">
                                <div class="w-4 h-4 border-2 border-gray-300 border-t-crimson-500 rounded-full animate-spin"></div>
                              </div>
                            </div>
                          </div>
                          
                          <div class="space-y-2 md:col-span-2">
                            <label for="seniorGraduatingGraduationDate" class="block text-sm font-medium text-gray-700">Expected Graduation Date</label>
                            <input 
                              id="seniorGraduatingGraduationDate"
                              v-model="formData.seniorGraduating.graduationDate"
                              @blur="validateApplicantType()"
                              type="date"
                              class="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500/50 focus:border-crimson-500 text-base transition-all shadow-sm"
                            />
                          </div>
                        </div>
                      </div>
                      
                      <!-- Senior High School Graduate fields -->
                      <div v-if="formData.applicantType === 'senior_high_graduate'" class="p-4 bg-blue-50 rounded-xl border border-blue-200 space-y-5 md:col-span-full animate-fadeIn">
                        <h5 class="font-medium text-base text-crimson-600">Senior High School Graduate Details</h5>
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-x-6 gap-y-5">
                          <div class="space-y-2">
                            <label for="seniorGraduateSchoolName" class="block text-sm font-medium text-gray-700">School Graduated From</label>
                            <div class="relative">
                              <input 
                                id="seniorGraduateSchoolName"
                                v-model="formData.seniorGraduate.schoolName"
                                @input="handleTextInput('seniorGraduateSchoolName', 'seniorGraduate.schoolName')"
                                @blur="validateApplicantType()"
                                type="text"
                                class="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500/50 focus:border-crimson-500 text-base transition-all shadow-sm"
                                placeholder="Enter your school name"
                                list="zamboanga-schools-list-graduate"
                              />
                              <datalist id="zamboanga-schools-list-graduate">
                                <option v-for="school in zamboanganSchools" :key="school" :value="school">{{ school }}</option>
                              </datalist>
                            </div>
                          </div>
                          
                          <div class="space-y-2">
                            <label for="seniorGraduateSchoolAddress" class="block text-sm font-medium text-gray-700">School Address</label>
                            <div class="relative">
                              <input 
                                id="seniorGraduateSchoolAddress"
                                v-model="formData.seniorGraduate.schoolAddress"
                                @input="handleAddressInput('seniorGraduateSchoolAddress', 'seniorGraduate.schoolAddress')"
                                @focus="showAddressSuggestions('seniorGraduateSchoolAddress')"
                                @blur="hideAddressSuggestions('seniorGraduateSchoolAddress')"
                                type="text"
                                class="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500/50 focus:border-crimson-500 text-base transition-all shadow-sm"
                                placeholder="Enter your school address"
                                autocomplete="off"
                              />
                              <!-- Address Suggestions Dropdown -->
                              <div v-if="addressSuggestions.seniorGraduateSchoolAddress.show && addressSuggestions.seniorGraduateSchoolAddress.results.length > 0"
                                   class="absolute z-50 w-full mt-1 bg-white border border-gray-300 rounded-lg shadow-lg max-h-60 overflow-y-auto">
                                <div v-for="(suggestion, index) in addressSuggestions.seniorGraduateSchoolAddress.results" 
                                     :key="index"
                                     @mousedown="selectAddressSuggestion('seniorGraduateSchoolAddress', suggestion)"
                                     class="px-4 py-2 hover:bg-gray-100 cursor-pointer border-b border-gray-100 last:border-b-0">
                                  <div class="text-sm font-medium text-gray-900">{{ suggestion.display_name }}</div>
                                  <div class="text-xs text-gray-500">{{ suggestion.type }}</div>
                                </div>
                              </div>
                              <!-- Loading indicator -->
                              <div v-if="addressSuggestions.seniorGraduateSchoolAddress.loading"
                                   class="absolute inset-y-0 right-3 flex items-center">
                                <div class="w-4 h-4 border-2 border-gray-300 border-t-crimson-500 rounded-full animate-spin"></div>
                              </div>
                            </div>
                          </div>
                          
                          <div class="space-y-2 md:col-span-2">
                            <label for="seniorGraduateGraduationDate" class="block text-sm font-medium text-gray-700">Graduation Date</label>
                            <input 
                              id="seniorGraduateGraduationDate"
                              v-model="formData.seniorGraduate.graduationDate"
                              @blur="validateApplicantType()"
                              type="date"
                              class="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500/50 focus:border-crimson-500 text-base transition-all shadow-sm"
                            />
                          </div>
                        </div>
                      </div>
                      
                      <!-- College Student fields -->
                      <div v-if="formData.applicantType === 'college'" class="p-4 bg-blue-50 rounded-xl border border-blue-200 space-y-5 md:col-span-full animate-fadeIn">
                        <h5 class="font-medium text-base text-crimson-600">College Details</h5>
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-x-6 gap-y-5">
                          <div class="space-y-2">
                            <label for="collegeSchoolName" class="block text-sm font-medium text-gray-700">School enrolled in/last attended</label>
                            <div class="relative">
                              <input 
                                id="collegeSchoolName"
                                v-model="formData.college.schoolName"
                                @input="handleTextInput('collegeSchoolName', 'college.schoolName')"
                                @blur="validateApplicantType()"
                                type="text"
                                class="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500/50 focus:border-crimson-500 text-base transition-all shadow-sm"
                                placeholder="Enter your college/university name"
                                list="zamboanga-schools-list-college"
                              />
                              <datalist id="zamboanga-schools-list-college">
                                <option v-for="school in zamboanganSchools" :key="school" :value="school">{{ school }}</option>
                              </datalist>
                            </div>
                          </div>
                          
                          <div class="space-y-2">
                            <label for="collegeSchoolAddress" class="block text-sm font-medium text-gray-700">School Address</label>
                            <div class="relative">
                              <input 
                                id="collegeSchoolAddress"
                                v-model="formData.college.schoolAddress"
                                @input="handleAddressInput('collegeSchoolAddress', 'college.schoolAddress')"
                                @focus="showAddressSuggestions('collegeSchoolAddress')"
                                @blur="hideAddressSuggestions('collegeSchoolAddress')"
                                type="text"
                                class="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500/50 focus:border-crimson-500 text-base transition-all shadow-sm"
                                placeholder="Enter your college/university address"
                                autocomplete="off"
                              />
                              <!-- Address Suggestions Dropdown -->
                              <div v-if="addressSuggestions.collegeSchoolAddress.show && addressSuggestions.collegeSchoolAddress.results.length > 0"
                                   class="absolute z-50 w-full mt-1 bg-white border border-gray-300 rounded-lg shadow-lg max-h-60 overflow-y-auto">
                                <div v-for="(suggestion, index) in addressSuggestions.collegeSchoolAddress.results" 
                                     :key="index"
                                     @mousedown="selectAddressSuggestion('collegeSchoolAddress', suggestion)"
                                     class="px-4 py-2 hover:bg-gray-100 cursor-pointer border-b border-gray-100 last:border-b-0">
                                  <div class="text-sm font-medium text-gray-900">{{ suggestion.display_name }}</div>
                                  <div class="text-xs text-gray-500">{{ suggestion.type }}</div>
                                </div>
                              </div>
                              <!-- Loading indicator -->
                              <div v-if="addressSuggestions.collegeSchoolAddress.loading"
                                   class="absolute inset-y-0 right-3 flex items-center">
                                <div class="w-4 h-4 border-2 border-gray-300 border-t-crimson-500 rounded-full animate-spin"></div>
                              </div>
                            </div>
                          </div>
                          
                          <div class="space-y-2 md:col-span-2">
                            <label for="collegeCourse" class="block text-sm font-medium text-gray-700">Course</label>
                            <div class="relative">
                              <input 
                                id="collegeCourse"
                                v-model="formData.college.course"
                                @blur="validateApplicantType()"
                                type="text"
                                class="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500/50 focus:border-crimson-500 text-base transition-all shadow-sm"
                                placeholder="e.g., BS Computer Science"
                              />
                            </div>
                          </div>
                          
                          <div class="space-y-2 md:col-span-2">
                            <label class="block text-sm font-medium text-gray-700 mb-1.5">College Type</label>
                            <div class="space-y-3 mt-2">
                              <label class="flex items-center hover:bg-gray-50 p-2 rounded-lg transition-colors cursor-pointer">
                                <input 
                                  type="radio" 
                                  v-model="formData.college.collegeType" 
                                  value="wmsu_main"
                                  @change="validateApplicantType()"
                                  class="form-radio text-crimson-600 focus:ring-crimson-500 h-5 w-5 border-gray-300"
                                >
                                <span class="ml-2 text-gray-700 text-base">WMSU Main Campus (currently enrolled)</span>
                              </label>
                              <label class="flex items-center hover:bg-gray-50 p-2 rounded-lg transition-colors cursor-pointer">
                                <input 
                                  type="radio" 
                                  v-model="formData.college.collegeType" 
                                  value="wmsu_external"
                                  @change="validateApplicantType()"
                                  class="form-radio text-crimson-600 focus:ring-crimson-500 h-5 w-5 border-gray-300"
                                >
                                <span class="ml-2 text-gray-700 text-base">WMSU External Studies Unit</span>
                              </label>
                              <label class="flex items-center hover:bg-gray-50 p-2 rounded-lg transition-colors cursor-pointer">
                                <input 
                                  type="radio" 
                                  v-model="formData.college.collegeType" 
                                  value="non_wmsu"
                                  @change="validateApplicantType()"
                                  class="form-radio text-crimson-600 focus:ring-crimson-500 h-5 w-5 border-gray-300"
                                >
                                <span class="ml-2 text-gray-700 text-base">Non-WMSU (Transferee)</span>
                              </label>
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>

                <!-- STEP 3: Course Choices & Additional Information (Spans 2 columns on LG) -->
                <div v-if="currentStep === 3" class="space-y-8 lg:col-span-2">
                  <!-- Course Choices Section -->
                  <div class="space-y-6 bg-white rounded-xl p-6 border border-gray-200 shadow-sm">
                    <div class="flex items-center gap-3 text-lg font-semibold text-gray-900 mb-4 pb-3 border-b border-gray-200">
                      <div class="w-8 h-8 rounded-lg bg-crimson-100 flex items-center justify-center">
                        <i class="fas fa-graduation-cap text-crimson-500"></i>
                      </div>
                      <h4>Course to take up (Choose from the list of WMSU Campuses and undergraduate degree programs/courses offered by WMSU posted in your school's bulletin board.)</h4>
                    </div>
                    
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-x-6 gap-y-5">
                      <!-- 1st Choice -->
                      <div class="space-y-2">
                        <label for="firstChoiceCourse" class="block text-sm font-medium text-gray-700 mb-1.5">1st Choice:</label>
                        <input 
                          id="firstChoiceCourse"
                          v-model="formData.courseChoices.firstChoice"
                          type="text"
                          list="wmsu-courses-list-first"
                          class="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500/50 focus:border-crimson-500 text-base transition-all shadow-sm"
                          placeholder="Enter your first choice course"
                          autocomplete="off"
                        />
                        <datalist id="wmsu-courses-list-first">
                          <option v-for="course in wmsucourses" :key="course" :value="course">{{ course }}</option>
                        </datalist>
                      </div>
                      
                      <div class="space-y-2">
                        <label for="firstChoiceCampus" class="block text-sm font-medium text-gray-700 mb-1.5">Campus:</label>
                        <select 
                          id="firstChoiceCampus"
                          v-model="formData.courseChoices.firstChoiceCampus"
                          class="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500/50 focus:border-crimson-500 text-base transition-all shadow-sm"
                        >
                          <option value="">Select a campus</option>
                          <option v-for="campus in campusOptions" :key="campus" :value="campus">
                            {{ campus }}
                          </option>
                        </select>
                      </div>
                      
                      <!-- 2nd Choice -->
                      <div class="space-y-2">
                        <label for="secondChoiceCourse" class="block text-sm font-medium text-gray-700 mb-1.5">2nd Choice:</label>
                        <input 
                          id="secondChoiceCourse"
                          v-model="formData.courseChoices.secondChoice"
                          type="text"
                          list="wmsu-courses-list-second"
                          class="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500/50 focus:border-crimson-500 text-base transition-all shadow-sm"
                          placeholder="Enter your second choice course"
                          autocomplete="off"
                        />
                        <datalist id="wmsu-courses-list-second">
                          <option v-for="course in wmsucourses" :key="course" :value="course">{{ course }}</option>
                        </datalist>
                      </div>
                      
                      <div class="space-y-2">
                        <label for="secondChoiceCampus" class="block text-sm font-medium text-gray-700 mb-1.5">Campus:</label>
                        <select 
                          id="secondChoiceCampus"
                          v-model="formData.courseChoices.secondChoiceCampus"
                          class="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500/50 focus:border-crimson-500 text-base transition-all shadow-sm"
                        >
                          <option value="">Select a campus</option>
                          <option v-for="campus in campusOptions" :key="campus" :value="campus">
                            {{ campus }}
                          </option>
                        </select>
                      </div>
                      
                      <!-- 3rd Choice -->
                      <div class="space-y-2">
                        <label for="thirdChoiceCourse" class="block text-sm font-medium text-gray-700 mb-1.5">3rd Choice:</label>
                        <input 
                          id="thirdChoiceCourse"
                          v-model="formData.courseChoices.thirdChoice"
                          type="text"
                          list="wmsu-courses-list-third"
                          class="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500/50 focus:border-crimson-500 text-base transition-all shadow-sm"
                          placeholder="Enter your third choice course"
                          autocomplete="off"
                        />
                        <datalist id="wmsu-courses-list-third">
                          <option v-for="course in wmsucourses" :key="course" :value="course">{{ course }}</option>
                        </datalist>
                      </div>
                      
                      <div class="space-y-2">
                        <label for="thirdChoiceCampus" class="block text-sm font-medium text-gray-700 mb-1.5">Campus:</label>
                        <select 
                          id="thirdChoiceCampus"
                          v-model="formData.courseChoices.thirdChoiceCampus"
                          class="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500/50 focus:border-crimson-500 text-base transition-all shadow-sm"
                        >
                          <option value="">Select a campus</option>
                          <option v-for="campus in campusOptions" :key="campus" :value="campus">
                            {{ campus }}
                          </option>
                        </select>
                      </div>
                    </div>
                  </div>

                  <!-- Socio Economic Data Section -->
                  <div class="space-y-6 bg-white rounded-xl p-6 border border-gray-200 shadow-sm">
                    <div class="flex items-center gap-3 text-lg font-semibold text-gray-900 mb-4 pb-3 border-b border-gray-200">
                      <div class="w-8 h-8 rounded-lg bg-crimson-100 flex items-center justify-center">
                        <i class="fas fa-users text-crimson-500"></i>
                      </div>
                      <h4>Socio Economic Data: Furnish all required information. Under the column "Highest Educational Attainment" indicate the educational level actually completed (eg. Grade III, Third year high school, High School Graduate, Second Year, College Graduate, etc)</h4>
                    </div>
                    
                    <!-- Responsive Card Layout -->
                    <div class="space-y-6">
                      <!-- Father Information Card -->
                      <div class="bg-blue-50 border border-blue-200 rounded-lg p-5">
                        <h5 class="font-semibold text-blue-800 mb-4 flex items-center">
                          <i class="fas fa-male mr-2"></i>
                          Father's Information
                        </h5>
                        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                          <div class="space-y-2">
                            <label class="block text-sm font-medium text-gray-700">Citizenship</label>
                            <input 
                              v-model="formData.socioEconomic.father.citizenship"
                              type="text"
                              list="citizenship-options-father"
                              class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500/50 focus:border-crimson-500 text-sm transition-all"
                              placeholder="e.g., Filipino"
                              autocomplete="off"
                            />
                            <datalist id="citizenship-options-father">
                              <option v-for="citizenship in citizenshipOptions" :key="citizenship" :value="citizenship">{{ citizenship }}</option>
                            </datalist>
                          </div>
                          <div class="space-y-2">
                            <label class="block text-sm font-medium text-gray-700">Highest Educational Attainment</label>
                            <input 
                              v-model="formData.socioEconomic.father.education"
                              type="text"
                              list="education-options-father"
                              class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500/50 focus:border-crimson-500 text-sm transition-all"
                              placeholder="e.g., High School Graduate, College Graduate"
                              autocomplete="off"
                            />
                            <datalist id="education-options-father">
                              <option v-for="education in educationalAttainmentOptions" :key="education" :value="education">{{ education }}</option>
                            </datalist>
                          </div>
                          <div class="space-y-2">
                            <label class="block text-sm font-medium text-gray-700">Work/Occupation</label>
                            <input 
                              v-model="formData.socioEconomic.father.occupation"
                              type="text"
                              list="occupation-options-father"
                              class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500/50 focus:border-crimson-500 text-sm transition-all"
                              placeholder="e.g., Teacher, Farmer, Engineer"
                              autocomplete="off"
                            />
                            <datalist id="occupation-options-father">
                              <option v-for="occupation in occupationOptions" :key="occupation" :value="occupation">{{ occupation }}</option>
                            </datalist>
                          </div>
                          <div class="space-y-2 md:col-span-2 lg:col-span-1">
                            <label class="block text-sm font-medium text-gray-700">Employer/Place of Work</label>
                            <input 
                              v-model="formData.socioEconomic.father.employer"
                              type="text"
                              class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500/50 focus:border-crimson-500 text-sm transition-all"
                              placeholder="e.g., Company name, School name"
                            />
                          </div>
                          <div class="space-y-2 md:col-span-2 lg:col-span-1">
                            <label class="block text-sm font-medium text-gray-700">Monthly Income/Salary</label>
                            <input 
                              v-model="formData.socioEconomic.father.income"
                              type="text"
                              class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500/50 focus:border-crimson-500 text-sm transition-all"
                              placeholder="e.g., ₱15,000, ₱25,000"
                            />
                          </div>
                        </div>
                      </div>

                      <!-- Mother Information Card -->
                      <div class="bg-pink-50 border border-pink-200 rounded-lg p-5">
                        <h5 class="font-semibold text-pink-800 mb-4 flex items-center">
                          <i class="fas fa-female mr-2"></i>
                          Mother's Information
                        </h5>
                        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                          <div class="space-y-2">
                            <label class="block text-sm font-medium text-gray-700">Citizenship</label>
                            <input 
                              v-model="formData.socioEconomic.mother.citizenship"
                              type="text"
                              list="citizenship-options-mother"
                              class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500/50 focus:border-crimson-500 text-sm transition-all"
                              placeholder="e.g., Filipino"
                              autocomplete="off"
                            />
                            <datalist id="citizenship-options-mother">
                              <option v-for="citizenship in citizenshipOptions" :key="citizenship" :value="citizenship">{{ citizenship }}</option>
                            </datalist>
                          </div>
                          <div class="space-y-2">
                            <label class="block text-sm font-medium text-gray-700">Highest Educational Attainment</label>
                            <input 
                              v-model="formData.socioEconomic.mother.education"
                              type="text"
                              list="education-options-mother"
                              class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500/50 focus:border-crimson-500 text-sm transition-all"
                              placeholder="e.g., High School Graduate, College Graduate"
                              autocomplete="off"
                            />
                            <datalist id="education-options-mother">
                              <option v-for="education in educationalAttainmentOptions" :key="education" :value="education">{{ education }}</option>
                            </datalist>
                          </div>
                          <div class="space-y-2">
                            <label class="block text-sm font-medium text-gray-700">Work/Occupation</label>
                            <input 
                              v-model="formData.socioEconomic.mother.occupation"
                              type="text"
                              list="occupation-options-mother"
                              class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500/50 focus:border-crimson-500 text-sm transition-all"
                              placeholder="e.g., Housewife, Nurse, Business Owner"
                              autocomplete="off"
                            />
                            <datalist id="occupation-options-mother">
                              <option v-for="occupation in occupationOptions" :key="occupation" :value="occupation">{{ occupation }}</option>
                            </datalist>
                          </div>
                          <div class="space-y-2 md:col-span-2 lg:col-span-1">
                            <label class="block text-sm font-medium text-gray-700">Employer/Place of Work</label>
                            <input 
                              v-model="formData.socioEconomic.mother.employer"
                              type="text"
                              class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500/50 focus:border-crimson-500 text-sm transition-all"
                              placeholder="e.g., Hospital name, Own business"
                            />
                          </div>
                          <div class="space-y-2 md:col-span-2 lg:col-span-1">
                            <label class="block text-sm font-medium text-gray-700">Monthly Income/Salary</label>
                            <input 
                              v-model="formData.socioEconomic.mother.income"
                              type="text"
                              class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500/50 focus:border-crimson-500 text-sm transition-all"
                              placeholder="e.g., ₱12,000, ₱20,000"
                            />
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>

                  <!-- Additional Questions Section -->
                  <div class="space-y-6 bg-white rounded-xl p-6 border border-gray-200 shadow-sm">
                    <div class="flex items-center gap-3 text-lg font-semibold text-gray-900 mb-4 pb-3 border-b border-gray-200">
                      <div class="w-8 h-8 rounded-lg bg-crimson-100 flex items-center justify-center">
                        <i class="fas fa-question-circle text-crimson-500"></i>
                      </div>
                      <h4>Additional Information</h4>
                    </div>
                    
                    <div class="space-y-6">
                      <!-- Physical Disability Question -->
                      <div class="space-y-3">
                        <label class="block text-sm font-medium text-gray-700">Do you have a physical disability or condition that requires special attention or would make it difficult for you to take a regular test?</label>
                        <div class="flex flex-col sm:flex-row space-y-3 sm:space-y-0 sm:space-x-6">
                          <label class="inline-flex items-center hover:bg-gray-50 p-2 rounded-lg transition-colors cursor-pointer">
                            <input 
                              type="radio" 
                              v-model="formData.additionalInfo.hasDisability" 
                              :value="false"
                              class="form-radio text-crimson-600 focus:ring-crimson-500 h-5 w-5 border-gray-300"
                            >
                            <span class="ml-2 text-gray-700 text-base">No</span>
                          </label>
                          <label class="inline-flex items-center hover:bg-gray-50 p-2 rounded-lg transition-colors cursor-pointer">
                            <input 
                              type="radio" 
                              v-model="formData.additionalInfo.hasDisability" 
                              :value="true"
                              class="form-radio text-crimson-600 focus:ring-crimson-500 h-5 w-5 border-gray-300"
                            >
                            <span class="ml-2 text-gray-700 text-base">Yes (If yes, please submit a medical certificate/documentation of disability together with this form.)</span>
                          </label>
                        </div>
                        
                        <!-- Disability Description -->
                        <div v-if="formData.additionalInfo.hasDisability" class="mt-3">
                          <textarea 
                            v-model="formData.additionalInfo.disabilityDescription"
                            class="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500/50 focus:border-crimson-500 text-base transition-all shadow-sm"
                            rows="3"
                            placeholder="Please describe your disability or special attention needed"
                          ></textarea>
                        </div>
                      </div>

                      <!-- Computer Usage Question -->
                      <div class="space-y-3">
                        <label class="block text-sm font-medium text-gray-700">Do you know how to use a computer?</label>
                        <div class="flex flex-col sm:flex-row space-y-3 sm:space-y-0 sm:space-x-6">
                          <label class="inline-flex items-center hover:bg-gray-50 p-2 rounded-lg transition-colors cursor-pointer">
                            <input 
                              type="radio" 
                              v-model="formData.additionalInfo.knowsComputer" 
                              :value="false"
                              class="form-radio text-crimson-600 focus:ring-crimson-500 h-5 w-5 border-gray-300"
                            >
                            <span class="ml-2 text-gray-700 text-base">No</span>
                          </label>
                          <label class="inline-flex items-center hover:bg-gray-50 p-2 rounded-lg transition-colors cursor-pointer">
                            <input 
                              type="radio" 
                              v-model="formData.additionalInfo.knowsComputer" 
                              :value="true"
                              class="form-radio text-crimson-600 focus:ring-crimson-500 h-5 w-5 border-gray-300"
                            >
                            <span class="ml-2 text-gray-700 text-base">Yes</span>
                          </label>
                        </div>
                      </div>

                      <!-- Indigenous Peoples Group Question -->
                      <div class="space-y-3">
                        <label class="block text-sm font-medium text-gray-700">Are you a member of an Indigenous Peoples Group (IPG)?</label>
                        <div class="flex flex-col sm:flex-row space-y-3 sm:space-y-0 sm:space-x-6">
                          <label class="inline-flex items-center hover:bg-gray-50 p-2 rounded-lg transition-colors cursor-pointer">
                            <input 
                              type="radio" 
                              v-model="formData.additionalInfo.isIndigenous" 
                              :value="false"
                              class="form-radio text-crimson-600 focus:ring-crimson-500 h-5 w-5 border-gray-300"
                            >
                            <span class="ml-2 text-gray-700 text-base">No</span>
                          </label>
                          <label class="inline-flex items-center hover:bg-gray-50 p-2 rounded-lg transition-colors cursor-pointer">
                            <input 
                              type="radio" 
                              v-model="formData.additionalInfo.isIndigenous" 
                              :value="true"
                              class="form-radio text-crimson-600 focus:ring-crimson-500 h-5 w-5 border-gray-300"
                            >
                            <span class="ml-2 text-gray-700 text-base">Yes</span>
                          </label>
                        </div>
                        
                        <!-- Indigenous Group Specification -->
                        <div v-if="formData.additionalInfo.isIndigenous" class="mt-3">
                          <input 
                            v-model="formData.additionalInfo.indigenousGroup"
                            type="text"
                            class="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500/50 focus:border-crimson-500 text-base transition-all shadow-sm"
                            placeholder="Please specify the Indigenous Peoples Group"
                          />
                        </div>
                      </div>

                      <!-- Religious Affiliation Question -->
                      <div class="space-y-3">
                        <label class="block text-sm font-medium text-gray-700">Religious affiliation:</label>
                        <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
                          <label class="inline-flex items-center hover:bg-gray-50 p-2 rounded-lg transition-colors cursor-pointer">
                            <input 
                              type="radio" 
                              v-model="formData.additionalInfo.religion" 
                              value="roman_catholic"
                              class="form-radio text-crimson-600 focus:ring-crimson-500 h-5 w-5 border-gray-300"
                            >
                            <span class="ml-2 text-gray-700 text-base">Roman Catholic</span>
                          </label>
                          <label class="inline-flex items-center hover:bg-gray-50 p-2 rounded-lg transition-colors cursor-pointer">
                            <input 
                              type="radio" 
                              v-model="formData.additionalInfo.religion" 
                              value="protestant"
                              class="form-radio text-crimson-600 focus:ring-crimson-500 h-5 w-5 border-gray-300"
                            >
                            <span class="ml-2 text-gray-700 text-base">Protestant</span>
                          </label>
                          <label class="inline-flex items-center hover:bg-gray-50 p-2 rounded-lg transition-colors cursor-pointer">
                            <input 
                              type="radio" 
                              v-model="formData.additionalInfo.religion" 
                              value="islam"
                              class="form-radio text-crimson-600 focus:ring-crimson-500 h-5 w-5 border-gray-300"
                            >
                            <span class="ml-2 text-gray-700 text-base">Islam</span>
                          </label>
                          <label class="inline-flex items-center hover:bg-gray-50 p-2 rounded-lg transition-colors cursor-pointer">
                            <input 
                              type="radio" 
                              v-model="formData.additionalInfo.religion" 
                              value="others"
                              class="form-radio text-crimson-600 focus:ring-crimson-500 h-5 w-5 border-gray-300"
                            >
                            <span class="ml-2 text-gray-700 text-base">Others</span>
                          </label>
                        </div>
                        
                        <!-- Religion Others Specification -->
                        <div v-if="formData.additionalInfo.religion === 'others'" class="mt-3">
                          <input 
                            v-model="formData.additionalInfo.religionOthers"
                            type="text"
                            class="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500/50 focus:border-crimson-500 text-base transition-all shadow-sm"
                            placeholder="Please specify your religion"
                          />
                        </div>
                      </div>
                    </div>
                  </div>
                </div>

                <!-- STEP 4: Review Details Section (Spans 2 columns on LG) -->
                <div v-if="currentStep === 4" class="lg:col-span-2">
                  <div class="space-y-6 bg-white rounded-xl p-6 md:p-8 border border-gray-200 shadow-sm">
                    <div class="flex items-center gap-3 text-lg font-semibold text-gray-900 mb-4 pb-3 border-b border-gray-200">
                      <div class="w-8 h-8 rounded-lg bg-crimson-100 flex items-center justify-center">
                        <i class="fas fa-clipboard-check text-crimson-500"></i>
                      </div>
                      <h4>Review Your Information</h4>
                    </div>
                    
                    <p class="text-gray-600 mb-6">Please review all the information you've entered before scheduling your appointment.</p>
                    
                    <!-- Personal Information Review -->
                    <div class="bg-gray-50 rounded-lg p-4 mb-6">
                      <h5 class="font-semibold text-gray-900 mb-3 flex items-center gap-2">
                        <i class="fas fa-user text-blue-500"></i>
                        Personal Information
                      </h5>
                      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4 text-sm">
                        <div><span class="font-medium">Name:</span> {{ formData.firstName }} {{ formData.middleName }} {{ formData.lastName }}</div>
                        <div><span class="font-medium">Email:</span> {{ formData.email }}</div>
                        <div><span class="font-medium">Contact:</span> {{ formData.contactNumber }}</div>
                        <div><span class="font-medium">Birth Date:</span> {{ formData.birthMonth }}/{{ formData.birthDay }}/{{ formData.birthYear }}</div>
                        <div><span class="font-medium">Age:</span> {{ formData.age }}</div>
                        <div><span class="font-medium">Gender:</span> {{ formData.gender }}</div>
                        <div><span class="font-medium">Address:</span> {{ formData.streetPurok }}, {{ formData.barangay }}, {{ formData.city }}</div>
                        <div><span class="font-medium">Citizenship:</span> {{ formData.citizenship }}</div>
                      </div>
                    </div>

                    <!-- Educational Background Review -->
                    <div class="bg-gray-50 rounded-lg p-4 mb-6">
                      <h5 class="font-semibold text-gray-900 mb-3 flex items-center gap-2">
                        <i class="fas fa-graduation-cap text-green-500"></i>
                        Educational Background
                      </h5>
                      <div class="grid grid-cols-1 md:grid-cols-2 gap-4 text-sm">
                        <div><span class="font-medium">Applicant Type:</span> 
                          {{ formData.applicantType === 'senior_high_graduating' ? 'Senior High School Graduating Student' :
                             formData.applicantType === 'senior_high_graduate' ? 'Senior High School Graduate' :
                             formData.applicantType === 'college' ? 'College Student' : formData.applicantType }}
                        </div>
                        <div><span class="font-medium">WMSUCET Experience:</span> 
                          {{ formData.wmsucetExperience.firstTime ? 'First Time' : `${formData.wmsucetExperience.timesTaken} times taken` }}
                        </div>
                        
                        <!-- Applicant Type Specific Details -->
                        <template v-if="formData.applicantType === 'senior_high_graduating'">
                          <div><span class="font-medium">School:</span> {{ formData.seniorGraduating.schoolName }}</div>
                          <div><span class="font-medium">School Address:</span> {{ formData.seniorGraduating.schoolAddress }}</div>
                          <div><span class="font-medium">Expected Graduation:</span> {{ formData.seniorGraduating.graduationDate }}</div>
                        </template>
                        
                        <template v-if="formData.applicantType === 'senior_high_graduate'">
                          <div><span class="font-medium">School:</span> {{ formData.seniorGraduate.schoolName }}</div>
                          <div><span class="font-medium">School Address:</span> {{ formData.seniorGraduate.schoolAddress }}</div>
                          <div><span class="font-medium">Graduation Date:</span> {{ formData.seniorGraduate.graduationDate }}</div>
                        </template>
                        
                        <template v-if="formData.applicantType === 'college'">
                          <div><span class="font-medium">School:</span> {{ formData.college.schoolName }}</div>
                          <div><span class="font-medium">School Address:</span> {{ formData.college.schoolAddress }}</div>
                          <div><span class="font-medium">Course:</span> {{ formData.college.course }}</div>
                          <div><span class="font-medium">College Type:</span> {{ formData.college.collegeType }}</div>
                        </template>
                      </div>
                    </div>

                    <!-- Course Choices Review -->
                    <div class="bg-gray-50 rounded-lg p-4 mb-6">
                      <h5 class="font-semibold text-gray-900 mb-3 flex items-center gap-2">
                        <i class="fas fa-list-ol text-purple-500"></i>
                        Course Choices
                      </h5>
                      <div class="grid grid-cols-1 md:grid-cols-3 gap-4 text-sm">
                        <div class="bg-white p-3 rounded border">
                          <div class="font-medium text-purple-600 mb-1">1st Choice</div>
                          <div>{{ formData.courseChoices?.firstChoice || 'Not specified' }}</div>
                          <div class="text-xs text-gray-500 mt-1">{{ formData.courseChoices?.firstChoiceCampus || 'No campus specified' }}</div>
                        </div>
                        <div class="bg-white p-3 rounded border">
                          <div class="font-medium text-purple-600 mb-1">2nd Choice</div>
                          <div>{{ formData.courseChoices?.secondChoice || 'Not specified' }}</div>
                          <div class="text-xs text-gray-500 mt-1">{{ formData.courseChoices?.secondChoiceCampus || 'No campus specified' }}</div>
                        </div>
                        <div class="bg-white p-3 rounded border">
                          <div class="font-medium text-purple-600 mb-1">3rd Choice</div>
                          <div>{{ formData.courseChoices?.thirdChoice || 'Not specified' }}</div>
                          <div class="text-xs text-gray-500 mt-1">{{ formData.courseChoices?.thirdChoiceCampus || 'No campus specified' }}</div>
                        </div>
                      </div>
                    </div>

                    <!-- Socio-Economic Information Review -->
                    <div class="bg-gray-50 rounded-lg p-4 mb-6">
                      <h5 class="font-semibold text-gray-900 mb-3 flex items-center gap-2">
                        <i class="fas fa-users text-orange-500"></i>
                        Family Information
                      </h5>
                      <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <!-- Father's Information -->
                        <div class="bg-white p-3 rounded border">
                          <div class="font-medium text-blue-600 mb-2">Father's Information</div>
                          <div class="space-y-1 text-sm">
                            <div><span class="font-medium">Citizenship:</span> {{ formData.socioEconomic?.father?.citizenship || 'Not specified' }}</div>
                            <div><span class="font-medium">Education:</span> {{ formData.socioEconomic?.father?.education || 'Not specified' }}</div>
                            <div><span class="font-medium">Occupation:</span> {{ formData.socioEconomic?.father?.occupation || 'Not specified' }}</div>
                            <div><span class="font-medium">Employer:</span> {{ formData.socioEconomic?.father?.employer || 'Not specified' }}</div>
                            <div><span class="font-medium">Income:</span> {{ formData.socioEconomic?.father?.income || 'Not specified' }}</div>
                          </div>
                        </div>
                        
                        <!-- Mother's Information -->
                        <div class="bg-white p-3 rounded border">
                          <div class="font-medium text-pink-600 mb-2">Mother's Information</div>
                          <div class="space-y-1 text-sm">
                            <div><span class="font-medium">Citizenship:</span> {{ formData.socioEconomic?.mother?.citizenship || 'Not specified' }}</div>
                            <div><span class="font-medium">Education:</span> {{ formData.socioEconomic?.mother?.education || 'Not specified' }}</div>
                            <div><span class="font-medium">Occupation:</span> {{ formData.socioEconomic?.mother?.occupation || 'Not specified' }}</div>
                            <div><span class="font-medium">Employer:</span> {{ formData.socioEconomic?.mother?.employer || 'Not specified' }}</div>
                            <div><span class="font-medium">Income:</span> {{ formData.socioEconomic?.mother?.income || 'Not specified' }}</div>
                          </div>
                        </div>
                      </div>
                    </div>

                    <!-- Additional Information Review -->
                    <div class="bg-gray-50 rounded-lg p-4 mb-6">
                      <h5 class="font-semibold text-gray-900 mb-3 flex items-center gap-2">
                        <i class="fas fa-info-circle text-indigo-500"></i>
                        Additional Information
                      </h5>
                      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4 text-sm">
                        <div><span class="font-medium">Physical Disability:</span> {{ formData.additionalInfo?.hasDisability ? 'Yes' : 'No' }}</div>
                        <div v-if="formData.additionalInfo?.hasDisability"><span class="font-medium">Disability Description:</span> {{ formData.additionalInfo?.disabilityDescription || 'Not specified' }}</div>
                        <div><span class="font-medium">Computer Knowledge:</span> {{ formData.additionalInfo?.knowsComputer ? 'Yes' : 'No' }}</div>
                        <div><span class="font-medium">Indigenous Group:</span> {{ formData.additionalInfo?.isIndigenous ? 'Yes' : 'No' }}</div>
                        <div v-if="formData.additionalInfo?.isIndigenous"><span class="font-medium">Indigenous Group:</span> {{ formData.additionalInfo?.indigenousGroup || 'Not specified' }}</div>
                        <div><span class="font-medium">Religion:</span> 
                          {{ formData.additionalInfo?.religion === 'roman_catholic' ? 'Roman Catholic' :
                             formData.additionalInfo?.religion === 'protestant' ? 'Protestant' :
                             formData.additionalInfo?.religion === 'islam' ? 'Islam' :
                             formData.additionalInfo?.religion === 'others' ? (formData.additionalInfo?.religionOthers || 'Others') :
                             'Not specified' }}
                        </div>
                      </div>
                    </div>

                    <!-- Edit Information Notice -->
                    <div class="bg-blue-50 border border-blue-200 rounded-lg p-4">
                      <div class="flex items-start gap-3">
                        <i class="fas fa-info-circle text-blue-500 mt-1"></i>
                        <div>
                          <h6 class="font-medium text-blue-900">Need to make changes?</h6>
                          <p class="text-sm text-blue-700 mt-1">
                            Use the "Previous" button below to go back and edit any information. Once you proceed to schedule your appointment, this information will be submitted.
                          </p>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>

                <!-- STEP 5: Schedule Details Section (Spans 2 columns on LG) -->
                <div v-if="currentStep === 5" class="lg:col-span-2">
                  <div class="space-y-6 bg-white rounded-xl p-6 md:p-8 border border-gray-200 shadow-sm">
                    <div class="flex items-center gap-3 text-lg font-semibold text-gray-900 mb-4 pb-3 border-b border-gray-200">
                      <div class="w-8 h-8 rounded-lg bg-crimson-100 flex items-center justify-center">
                        <i class="fas fa-calendar-alt text-crimson-500"></i>
                      </div>
                      <h4>Registration Schedule Details</h4>
                    </div>
                    
                    <div class="grid grid-cols-1 gap-x-6 gap-y-6">
                      <!-- Preferred Date -->
                      <div class="space-y-3">
                        <label class="block text-sm font-medium text-gray-700">Preferred Date</label>
                        <div class="relative">
                          <!-- Calendar container with increased height -->
                          <div v-if="showCalendar" class="absolute top-full left-0 right-0 mt-2 bg-white shadow-2xl rounded-xl z-10 p-4 md:p-6 border border-gray-200 min-h-[500px] md:min-h-[600px]" @click.stop>
                            <CustomCalendar 
                              v-model="formData.preferredDate"
                              v-model:timeSlotValue="formData.timeSlot"
                              :dateAvailability="dateAvailability"
                              :testSessions="testSessions"
                              @time-slot-selected="closeCalendarWithDelay"
                            />
                          </div>
                          
                          <!-- Date display field with larger size -->
                          <div 
                            @click="showCalendar = !showCalendar; markAsTouched('preferredDate')"
                            :class="[
                              'w-full px-5 py-4 border rounded-xl flex justify-between items-center cursor-pointer transition-all text-lg font-medium',
                              touchedFields.preferredDate && dateError ? 'border-red-500' : 'border-gray-300 hover:border-crimson-500 hover:shadow-md'
                            ]"
                            data-calendar-trigger
                          >
                            <span v-if="formData.preferredDate" class="text-gray-900">{{ formatDate(formData.preferredDate) }}</span>
                            <span v-else class="text-gray-400">Select a date</span>
                            <i class="fas fa-calendar-alt text-gray-400 text-xl"></i>
                          </div>
                        </div>
                        <p v-if="touchedFields.preferredDate && dateError" class="text-sm text-red-600 mt-2 error-text">
                          {{ dateError }}
                        </p>
                        <p class="text-sm text-gray-500 mt-2">
                          Note: Today's date, past dates, and Sundays are not available for scheduling.
                        </p>
                      </div>
                      
                      <!-- Time Slot Selection with larger buttons -->
                      <div v-if="formData.preferredDate" class="space-y-3">
                        <label class="block text-sm font-medium text-gray-700">Time Slot</label>
                        
                        <div class="flex flex-col sm:flex-row gap-4 mt-4">
                          <button 
                            type="button"
                            @click="selectTimeSlot('morning'); markAsTouched('timeSlot')"
                            :disabled="!isMorningAvailable"
                            :class="[
                              'px-6 py-4 rounded-xl flex items-center justify-center transition-all flex-1 text-lg font-medium',
                              formData.timeSlot === 'morning' 
                                ? 'bg-gradient-to-r from-crimson-500 to-crimson-600 text-white shadow-lg transform scale-105' 
                                : 'bg-white border-2 border-gray-300 text-gray-700 hover:bg-gray-50 hover:border-crimson-300 shadow-md',
                              !isMorningAvailable ? 'opacity-50 cursor-not-allowed' : '',
                              touchedFields.timeSlot && dateError && !formData.timeSlot ? 'border-red-500' : ''
                            ]"
                          >
                            <i class="fas fa-sun mr-3 text-yellow-500 text-xl"></i>
                            <div class="text-center">
                              <div class="font-semibold">Morning</div>
                              <div class="text-sm opacity-80">(8:00 AM - 12:00 PM)</div>
                              <div v-if="!isMorningAvailable" class="text-xs mt-1 text-red-400">(Full)</div>
                            </div>
                          </button>
                          
                          <button 
                            type="button"
                            @click="selectTimeSlot('afternoon'); markAsTouched('timeSlot')"
                            :disabled="!isAfternoonAvailable"
                            :class="[
                              'px-6 py-4 rounded-xl flex items-center justify-center transition-all flex-1 text-lg font-medium',
                              formData.timeSlot === 'afternoon' 
                                ? 'bg-gradient-to-r from-crimson-500 to-crimson-600 text-white shadow-lg transform scale-105' 
                                : 'bg-white border-2 border-gray-300 text-gray-700 hover:bg-gray-50 hover:border-crimson-300 shadow-md',
                              !isAfternoonAvailable ? 'opacity-50 cursor-not-allowed' : '',
                              touchedFields.timeSlot && dateError && !formData.timeSlot ? 'border-red-500' : ''
                            ]"
                          >
                            <i class="fas fa-moon mr-3 text-blue-400 text-xl"></i>
                            <div class="text-center">
                              <div class="font-semibold">Afternoon</div>
                              <div class="text-sm opacity-80">(1:00 PM - 5:00 PM)</div>
                              <div v-if="!isAfternoonAvailable" class="text-xs mt-1 text-red-400">(Full)</div>
                            </div>
                          </button>
                        </div>
                      </div>
                      
                      <!-- Test Center Selection -->
                      <div v-if="formData.timeSlot" class="space-y-3">
                        <label class="block text-sm font-medium text-gray-700">Preferred Test Center</label>
                        <p class="text-sm text-gray-500 mb-4">
                          Select your preferred test center. Room availability is shown for your selected time slot.
                        </p>
                        
                        <div v-if="loadingTestCenters" class="flex justify-center py-8">
                          <div class="animate-spin rounded-full h-8 w-8 border-4 border-gray-300 border-t-crimson-600"></div>
                        </div>
                        
                        <div v-else-if="testCenters.length === 0" class="text-center py-8 text-gray-500">
                          <i class="fas fa-building text-4xl mb-3"></i>
                          <p>No test centers available at the moment.</p>
                        </div>
                        
                        <div v-else class="grid grid-cols-1 gap-4">
                          <div v-for="center in testCenters" :key="center.id"
                            @click="selectTestCenter(center); markAsTouched('testCenter')"
                            :class="[
                              'border rounded-xl p-4 cursor-pointer transition-all duration-200 hover:shadow-md',
                              formData.testCenter === center.id 
                                ? 'border-crimson-500 bg-crimson-50 shadow-md' 
                                : 'border-gray-300 hover:border-crimson-300',
                              touchedFields.testCenter && validationErrors.testCenter ? 'border-red-500' : ''
                            ]"
                          >
                            <div class="flex items-start justify-between">
                              <div class="flex-1">
                                <div class="flex items-center gap-3 mb-2">
                                  <div :class="[
                                    'w-4 h-4 rounded-full border-2 flex items-center justify-center transition-all',
                                    formData.testCenter === center.id 
                                      ? 'border-crimson-500 bg-crimson-500' 
                                      : 'border-gray-300'
                                  ]">
                                    <div v-if="formData.testCenter === center.id" class="w-2 h-2 bg-white rounded-full"></div>
                                  </div>
                                  <h4 class="font-semibold text-gray-900">{{ center.name }}</h4>
                                  <span class="text-sm text-gray-500 bg-gray-100 px-2 py-1 rounded">{{ center.code }}</span>
                                </div>
                                
                                <p v-if="center.address" class="text-sm text-gray-600 mb-3 ml-7">{{ center.address }}</p>
                                
                                <div class="ml-7">
                                  <div class="flex items-center gap-2 mb-2">
                                    <i class="fas fa-door-open text-crimson-500"></i>
                                    <span class="text-sm font-medium text-gray-700">Available Rooms for {{ formData.timeSlot === 'morning' ? 'Morning' : 'Afternoon' }}:</span>
                                  </div>
                                  
                                  <div v-if="getRoomsForCenter(center.id, formData.timeSlot).length === 0" 
                                    class="text-sm text-red-600 flex items-center gap-2">
                                    <i class="fas fa-exclamation-triangle"></i>
                                    <span>No rooms available for this time slot</span>
                                  </div>
                                  
                                  <div v-else class="grid grid-cols-2 sm:grid-cols-3 gap-2">
                                    <div v-for="room in getRoomsForCenter(center.id, formData.timeSlot)" :key="room.id"
                                      :class="[
                                        'text-xs p-2 rounded border',
                                        room.available_capacity > 0 
                                          ? 'bg-green-50 border-green-200 text-green-800' 
                                          : 'bg-red-50 border-red-200 text-red-800'
                                      ]"
                                    >
                                      <div class="font-medium">{{ room.name }}</div>
                                      <div class="flex items-center gap-1 mt-1">
                                        <i :class="[
                                          'fas fa-users text-xs',
                                          room.available_capacity > 0 ? 'text-green-600' : 'text-red-600'
                                        ]"></i>
                                        <span>{{ room.available_capacity }}/{{ room.capacity }}</span>
                                      </div>
                                    </div>
                                  </div>
                                </div>
                              </div>
                            </div>
                          </div>
                        </div>
                        
                        <p v-if="touchedFields.testCenter && validationErrors.testCenter" class="text-sm text-red-600 mt-2 error-text">
                          {{ validationErrors.testCenter }}
                        </p>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
              
              <!-- Form buttons -->
              <div class="flex flex-col sm:flex-row gap-4 pt-6 border-t border-gray-200">
                <button 
                  type="button" 
                  @click="close" 
                  class="bg-gray-100 text-gray-700 px-6 py-3 rounded-lg hover:bg-gray-200 transition-all text-base font-medium flex items-center justify-center gap-2 order-1 sm:order-none"
                >
                  <i class="fas fa-times"></i>
                  Cancel
                </button>

                <button 
                  type="button" 
                  v-if="currentStep > 1"
                  @click="prevStep"
                  class="bg-gray-200 text-gray-800 px-6 py-3 rounded-lg hover:bg-gray-300 transition-all text-base font-medium flex items-center justify-center gap-2 order-2 sm:order-none"
                >
                  <i class="fas fa-arrow-left"></i>
                  Previous
                </button>

                <button 
                  type="button" 
                  v-if="currentStep < 5"
                  @click="nextStep"
                  :disabled="currentStep === 1 && !checkDuplicateRegistration()"
                  :class="[
                    'flex-1 text-white px-6 py-3 rounded-lg transition-all text-base font-medium flex items-center justify-center gap-2 order-3 sm:order-none sm:ml-auto',
                    (currentStep === 1 && !checkDuplicateRegistration()) 
                      ? 'bg-gray-400 cursor-not-allowed' 
                      : 'bg-crimson-500 hover:bg-crimson-600'
                  ]"
                >
                  <span v-if="currentStep === 4">Review & Continue</span>
                  <span v-else>Next</span>
                  <i class="fas fa-arrow-right"></i>
                </button>
                
                <button 
                  type="submit"
                  v-if="currentStep === 5"
                  class="flex-1 bg-gradient-to-r from-crimson-600 to-crimson-700 text-white px-6 py-3 rounded-lg hover:from-crimson-700 hover:to-crimson-800 transition-all text-base font-medium shadow-sm flex items-center justify-center gap-2 order-3 sm:order-none sm:ml-auto"
                  :disabled="loading"
                >
                  <i class="fas fa-calendar-check"></i>
                  Schedule Appointment
                </button>
              </div>
            </form>
          </div>
        </div>
      </div>
    </transition>
  </div>
</template>

<script>
import axios from '../../plugins/axios'
import CustomCalendar from './CustomCalendar.vue'
import LocationDropdowns from '../common/LocationDropdowns.vue'
import { ref, computed, watch, onMounted, onUnmounted } from 'vue'
import ApplicationFormStore from '../../services/ApplicationFormStore'
import AuthService from '../../services/auth.service'
import { useToast } from '../../composables/useToast'
import { philippineBarangays as barangaysData, philippineCities as citiesData, citizenshipOptions as citizenshipsData } from '../../data/philippineData'
import { allZamboanganSchoolsFull } from '../../data/schoolData'

export default {
  name: 'ScheduleModal',
  components: {
    CustomCalendar,
    LocationDropdowns
  },
  props: {
    modelValue: {
      type: Boolean,
      default: false
    },
    program: {
      type: Object,
      default: () => ({})
    },
    dateAvailability: {
      type: Object,
      default: () => ({})
    }
  },
  emits: ['update:modelValue', 'submit'],
  setup(props, { emit }) {
    const loading = ref(false);
    const error = ref(null);
    const apiData = ref(null);
    const testSessions = ref([]);
    const testCenters = ref([]);
    const testRooms = ref([]);
    const loadingTestCenters = ref(false);
    const showCalendar = ref(false);
    const dateError = ref('');
    const userAppointments = ref([]);
    const currentStep = ref(1); // To manage the current step of the form
    const totalSteps = 5; // Total number of steps in the form
    const isSubmitting = ref(false); // Track form submission state
    const showNotification = ref(false); // Track notification display state
    const notificationMessage = ref(''); // Notification message content
    const notificationType = ref('info'); // Notification type (info, warning, error, success)

    const validationErrors = ref({
      lastName: '',
      firstName: '',
      middleName: '',
      contactNumber: '',
      email: '',
      schoolName: '',
      birthDate: '',
      gender: '',
      streetPurok: '',
      barangay: '',
      city: '',
      citizenship: '',
      wmsucetExperience: '',
      applicantType: '',
      testCenter: '',
      age: '' // Added age here
    });
    
    // Add a touched state to track which fields have been interacted with
    const touchedFields = ref({
      lastName: false,
      firstName: false,
      middleName: false,
      contactNumber: false,
      email: false,
      birthMonth: false,
      birthDay: false,
      birthYear: false,
      gender: false,
      streetPurok: false, 
      barangay: false,    
      city: false,        
      citizenship: false,
      highSchoolCode: false,
      applicantType: false,
      timeSlot: false,
      preferredDate: false,
      testCenter: false
    });
    
    const formData = ref({
      preferredDate: '',
      timeSlot: '',
      testCenter: '',
      lastName: '',
      firstName: '',
      middleName: '',
      contactNumber: '',
      email: '',
      schoolName: '',
      birthMonth: '',
      birthDay: '',
      birthYear: '',
      gender: '',
      age: '',
      streetPurok: '',
      region: '',
      province: '',
      barangay: '',
      city: '',
      citizenship: '',
      highSchoolCode: '',
      wmsucetExperience: {
        firstTime: true,
        notFirstTime: false,
        timesTaken: ''
      },
      applicantType: '',
      seniorGraduating: {
        schoolName: '',
        schoolAddress: '',
        graduationDate: ''
      },
      seniorGraduate: {
        schoolName: '',
        schoolAddress: '',
        graduationDate: ''
      },
      college: {
        schoolName: '',
        schoolAddress: '',
        course: '',
        collegeType: ''
      },
      // Course choices and campus information
      courseChoices: {
        firstChoice: '',
        firstChoiceCampus: '',
        secondChoice: '',
        secondChoiceCampus: '',
        thirdChoice: '',
        thirdChoiceCampus: ''
      },
      // Socio-economic data
      socioEconomic: {
        father: {
          citizenship: '',
          education: '',
          occupation: '',
          employer: '',
          income: ''
        },
        mother: {
          citizenship: '',
          education: '',
          occupation: '',
          employer: '',
          income: ''
        }
      },
      // Additional information
      additionalInfo: {
        hasDisability: false,
        disabilityDescription: '',
        knowsComputer: false,
        isIndigenous: false,
        indigenousGroup: '',
        religion: '',
        religionOthers: ''
      }
    });
    
    // Convert imported arrays to reactive refs
    const philippineBarangays = ref(barangaysData);
    const philippineCities = ref(citiesData);
    const citizenshipOptions = ref(citizenshipsData);
    const zamboanganSchools = ref(allZamboanganSchoolsFull);
    
    // WMSU Campus options for course choices
    const campusOptions = ref([
      'WMSU Main Campus',
      'WMSU ESU - Alicia (Zamboanga Sibugay)',
      'WMSU ESU - Aurora (Zamboanga del Sur)',
      'WMSU ESU - Curuan (Zamboanga City) – autonomous campus',
      'WMSU ESU - Malangas (Zamboanga Sibugay) – autonomous campus',
      'WMSU ESU - Diplahan (Zamboanga Sibugay)',
      'WMSU ESU - Imelda (Zamboanga Sibugay)',
      'WMSU ESU - Ipil (Zamboanga Sibugay)',
      'WMSU ESU - Mabuhay (Zamboanga Sibugay)',
      'WMSU ESU - Molave (Zamboanga del Sur)',
      'WMSU ESU - Naga (Zamboanga Sibugay)',
      'WMSU ESU - Olutanga (Zamboanga Sibugay)',
      'WMSU ESU - Pagadian City (Zamboanga del Sur)',
      'WMSU ESU - Siay (Zamboanga Sibugay)',
      'WMSU ESU - Tungawan (Zamboanga Sibugay)',
      'San Ramon Campus (Zamboanga City) – satellite campus',
      'Curuan Campus (Zamboanga City) – autonomous campus',
      'Malangas Campus (Zamboanga Sibugay) – autonomous campus'
    ]);

    // WMSU Undergraduate Programs data
    const wmsucourses = ref([
      // College of Architecture
      'BS Architecture (Specializations: Housing, Planning, Construction Technology, Architectural Design)',
      
      // College of Agriculture
      'BS Agriculture (majors: Crop Science, Animal Science, Soil Science, Entomology, Horticulture)',
      'BS Agricultural Engineering',
      'Diploma in Agricultural Technology / BAT ladder-course',
      
      // College of Forestry & Environmental Studies
      'BS Forestry',
      
      // College of Engineering
      'BS Civil Engineering',
      'BS Mechanical Engineering',
      'BS Electrical Engineering',
      'BS Computer Engineering',
      'BS Environmental Engineering',
      'BS Geodetic Engineering',
      
      // College of Computing Studies
      'BS Computer Science',
      'BS Information Technology',
      'Associate In Computer Technology: Networking',
      'Associate In Computer Technology: Application Development',
      
      // College of Science & Mathematics
      'BS Chemistry',
      'BS Biology',
      'BS Mathematics',
      'BS Physics',
      'BS Statistics',
      
      // College of Nursing
      'BS Nursing',
      
      // College of Home Economics
      'BS Home Economics Education',
      
      // College of Social Work & Community Development
      'BS Social Work',
      
      // College of Criminal Justice Education
      'BS Criminology',
      
      // College of Teacher Education
      'BEED (majors: Guidance & Counseling, Pre‑School, English, Work Education, Filipino, Math, MAPE, Science & Health, Social Studies, Special Education)',
      'BSED (majors: English, PEHM, Filipino, Math, Physics, Biology, Social Studies, Values Education, Chemistry, General Science)',
      
      // College of Liberal Arts
      'BA English',
      'BA Political Science',
      'BA Mass Communication (Journalism & Broadcasting)',
      'BA Social Studies',
      'BA Filipino',
      'BS Economics',
      'BS Psychology',
      
      // College of Asian & Islamic Studies
      'BS Islamic Studies',
      'BA Asian Studies (Southeast Asian focus; including Philippine/Korean history & culture)',
      
      // College of Physical Education
      'BPE (Physical Education)',
      
      // College of Nutrition & Dietetics
      'BS Nutrition & Dietetics',
      
      // College of Sports Science & Physical Education
      'Undergrad in Physical Education',
      
      // College of Public Administration & Development Studies
      'BS Community Development (BSCD)',
      
      // College of Law
      'Bachelor of Laws (with specialization in Islamic Jurisprudence)'
    ]);

    // Socio-Economic Data Options
    const educationalAttainmentOptions = ref([
      'No Formal Education',
      'Elementary Graduate',
      'Elementary Undergraduate',
      'High School Graduate', 
      'High School Undergraduate',
      'Senior High School Graduate',
      'Senior High School Undergraduate',
      'Vocational Graduate',
      'Vocational Undergraduate',
      'College Graduate',
      'College Undergraduate',
      'Masteral Graduate',
      'Masteral Undergraduate',
      'Doctoral Graduate',
      'Doctoral Undergraduate'
    ]);

    const occupationOptions = ref([
      // Professional/Technical
      'Teacher',
      'Engineer',
      'Doctor',
      'Nurse',
      'Lawyer',
      'Accountant',
      'Architect',
      'Social Worker',
      'Police Officer',
      'Military Personnel',
      'Government Employee',
      
      // Business/Service
      'Business Owner',
      'Manager',
      'Sales Representative',
      'Cashier',
      'Security Guard',
      'Driver',
      'Mechanic',
      'Electrician',
      'Plumber',
      'Carpenter',
      
      // Agriculture/Fishing
      'Farmer',
      'Fisherman',
      'Agricultural Worker',
      
      // Labor/Service
      'Construction Worker',
      'Factory Worker',
      'Domestic Helper',
      'Cook',
      'Vendor',
      'Jeepney Driver',
      'Tricycle Driver',
      
      // Others
      'Self-Employed',
      'Housewife/Househusband',
      'Retired',
      'Unemployed',
      'Student',
      'Overseas Filipino Worker (OFW)',
      'Others'
    ]);
    
    // Location data for the new LocationDropdowns component
    const locationData = ref({
      region: '',
      province: '',
      city: '',
      barangay: ''
    });
    
    // Address autocomplete state
    const addressSuggestions = ref({
      seniorGraduatingSchoolAddress: {
        show: false,
        loading: false,
        results: []
      },
      seniorGraduateSchoolAddress: {
        show: false,
        loading: false,
        results: []
      },
      collegeSchoolAddress: {
        show: false,
        loading: false,
        results: []
      }
    });
    
    // Debounce timer for address search
    let addressSearchTimeout = null;
    
    // Function to mark field as touched
    const markAsTouched = (fieldName) => {
      touchedFields.value[fieldName] = true;
    };
    
    // Check if a field is valid
    const isFieldValid = (fieldName) => {
      return touchedFields.value[fieldName] && !validationErrors.value[fieldName];
    };
    
    // Check if a field is invalid
    const isFieldInvalid = (fieldName) => {
      return touchedFields.value[fieldName] && validationErrors.value[fieldName];
    };
    
    // Get input style classes based on validation state
    const getInputClasses = (fieldName) => {
      return {
        'border-green-500 focus:border-green-500 focus:ring-green-500/50': isFieldValid(fieldName),
        'border-red-500 focus:border-red-500 focus:ring-red-500/50': isFieldInvalid(fieldName),
        'border-gray-300 focus:ring-crimson-500/50 focus:border-crimson-500': !touchedFields.value[fieldName]
      };
    };
    
    // Handle text input with real-time validation and auto-uppercase for key fields
    const handleTextInput = (fieldName, modelPath = null) => {
      const actualPath = modelPath || fieldName;
      const keys = actualPath.split('.');
      let target = formData.value;
      
      // Navigate to the correct nested object
      for (let i = 0; i < keys.length - 1; i++) {
        target = target[keys[i]];
      }
      
      const finalKey = keys[keys.length - 1];
      const currentValue = target[finalKey];
      
      // Convert to uppercase for key fields used in CSV score import matching
      // This ensures consistent data format for score import/matching
      const fieldsToUppercase = [
        'lastName', 'firstName', 'middleName',  // Name fields for score matching
        'streetPurok', 'barangay', 'city', 'citizenship',  // Address fields
        'seniorGraduatingSchoolName', 'seniorGraduateSchoolName', 'collegeSchoolName',  // School name fields for score matching
        'seniorGraduatingSchoolAddress', 'seniorGraduateSchoolAddress', 'collegeSchoolAddress'  // School address fields
      ];
      
      if (fieldsToUppercase.includes(fieldName)) {
        target[finalKey] = currentValue.toUpperCase();
      }
      // For other fields, keep the original case
      
      // Mark field as touched for real-time validation
      markAsTouched(fieldName);
      
      // Perform real-time validation based on field type
      switch(fieldName) {
        case 'lastName':
          validateLastName();
          break;
        case 'firstName':
          validateFirstName();
          break;
        case 'middleName':
          validateMiddleName();
          break;
        case 'contactNumber':
          validateContactNumber();
          break;
        case 'email':
          validateEmail();
          break;
        case 'streetPurok':
          validateStreetPurok();
          break;
        case 'barangay':
          validateBarangay();
          break;
        case 'city':
          validateCity();
          break;
        case 'citizenship':
          validateCitizenship();
          break;
        default:
          // For nested fields, trigger parent validation
          if (fieldName.includes('seniorGraduating') || fieldName.includes('seniorGraduate') || fieldName.includes('college')) {
            validateApplicantType();
          }
          break;
      }
    };
    
    // Address autocomplete functions
    const handleAddressInput = (fieldName, modelPath) => {
      // Get the current input value
      const keys = modelPath.split('.');
      let target = formData.value;
      for (let i = 0; i < keys.length - 1; i++) {
        target = target[keys[i]];
      }
      const finalKey = keys[keys.length - 1];
      const currentValue = target[finalKey];
      
      // Apply auto-capitalization for school address fields
      const fieldsToUppercase = [
        'seniorGraduatingSchoolAddress', 'seniorGraduateSchoolAddress', 'collegeSchoolAddress'
      ];
      
      if (fieldsToUppercase.includes(fieldName)) {
        target[finalKey] = currentValue.toUpperCase();
      }
      
      // Mark field as touched for validation
      markAsTouched(fieldName);
      
      // Trigger validation
      validateApplicantType();
      
      // Get the updated input value after capitalization
      const inputValue = target[finalKey];
      
      // Debounce the address search
      if (addressSearchTimeout) {
        clearTimeout(addressSearchTimeout);
      }
      
      // Don't search for very short queries
      if (!inputValue || inputValue.length < 3) {
        addressSuggestions.value[fieldName].results = [];
        addressSuggestions.value[fieldName].show = false;
        return;
      }
      
      addressSearchTimeout = setTimeout(() => {
        searchAddresses(fieldName, inputValue);
      }, 300); // 300ms debounce
    };
    
    const searchAddresses = async (fieldName, query) => {
      if (!query || query.length < 3) return;
      
      addressSuggestions.value[fieldName].loading = true;
      
      try {
        // Use OpenStreetMap Nominatim API
        const response = await fetch(
          `https://nominatim.openstreetmap.org/search?` +
          `q=${encodeURIComponent(query)}&` +
          `format=json&` +
          `addressdetails=1&` +
          `limit=8&` +
          `countrycodes=ph&` + // Limit to Philippines
          `accept-language=en`
        );
        
        if (!response.ok) throw new Error('Address search failed');
        
        const results = await response.json();
        
        // Filter and format results for better relevance
        const filteredResults = results
          .filter(result => {
            // Prefer results that are likely to be educational institutions or their addresses
            const displayName = result.display_name.toLowerCase();
            const type = result.type?.toLowerCase() || '';
            const categoryClass = result.class?.toLowerCase() || '';
            
            // Include educational institutions, addresses, and places
            return (
              displayName.includes('school') ||
              displayName.includes('university') ||
              displayName.includes('college') ||
              displayName.includes('institute') ||
              type.includes('education') ||
              categoryClass.includes('amenity') ||
              type.includes('house') ||
              type.includes('road') ||
              type.includes('suburb') ||
              type.includes('city') ||
              type.includes('town') ||
              type.includes('village') ||
              type.includes('administrative')
            );
          })
          .map(result => ({
            display_name: result.display_name,
            type: result.type || 'address',
            importance: result.importance || 0
          }))
          .sort((a, b) => {
            // Prioritize educational institutions
            const aIsSchool = a.display_name.toLowerCase().includes('school') ||
                            a.display_name.toLowerCase().includes('university') ||
                            a.display_name.toLowerCase().includes('college');
            const bIsSchool = b.display_name.toLowerCase().includes('school') ||
                            b.display_name.toLowerCase().includes('university') ||
                            b.display_name.toLowerCase().includes('college');
            
            if (aIsSchool && !bIsSchool) return -1;
            if (!aIsSchool && bIsSchool) return 1;
            
            // Then sort by importance
            return (b.importance || 0) - (a.importance || 0);
          });
        
        addressSuggestions.value[fieldName].results = filteredResults;
        addressSuggestions.value[fieldName].show = filteredResults.length > 0;
        
      } catch (error) {
        console.error('Address search error:', error);
        addressSuggestions.value[fieldName].results = [];
        addressSuggestions.value[fieldName].show = false;
      } finally {
        addressSuggestions.value[fieldName].loading = false;
      }
    };
    
    const selectAddressSuggestion = (fieldName, suggestion) => {
      // Determine the model path based on field name
      let modelPath;
      if (fieldName === 'seniorGraduatingSchoolAddress') {
        modelPath = 'seniorGraduating.schoolAddress';
      } else if (fieldName === 'seniorGraduateSchoolAddress') {
        modelPath = 'seniorGraduate.schoolAddress';
      } else if (fieldName === 'collegeSchoolAddress') {
        modelPath = 'college.schoolAddress';
      }
      
      // Set the selected address with auto-capitalization
      const keys = modelPath.split('.');
      let target = formData.value;
      for (let i = 0; i < keys.length - 1; i++) {
        target = target[keys[i]];
      }
      const finalKey = keys[keys.length - 1];
      
      // Apply auto-capitalization to the selected suggestion
      const fieldsToUppercase = [
        'seniorGraduatingSchoolAddress', 'seniorGraduateSchoolAddress', 'collegeSchoolAddress'
      ];
      
      if (fieldsToUppercase.includes(fieldName)) {
        target[finalKey] = suggestion.display_name.toUpperCase();
      } else {
        target[finalKey] = suggestion.display_name;
      }
      
      // Hide suggestions
      addressSuggestions.value[fieldName].show = false;
      addressSuggestions.value[fieldName].results = [];
      
      // Trigger validation
      validateApplicantType();
    };
    
    const showAddressSuggestions = (fieldName) => {
      // Show suggestions if we have results
      if (addressSuggestions.value[fieldName].results.length > 0) {
        addressSuggestions.value[fieldName].show = true;
      }
    };
    
    const hideAddressSuggestions = (fieldName) => {
      // Delay hiding to allow for selection
      setTimeout(() => {
        addressSuggestions.value[fieldName].show = false;
      }, 150);
    };
    
    // Handle location changes from LocationDropdowns component
    const onLocationChange = (locationData) => {
      // Update the formData with the new location data
      formData.value.region = locationData.region;
      formData.value.province = locationData.province;
      formData.value.city = locationData.city;
      formData.value.barangay = locationData.barangay;
      
      // Mark location fields as touched for validation
      markAsTouched('region');
      markAsTouched('province');
      markAsTouched('city');
      markAsTouched('barangay');
      
      // Trigger validation for location fields
      validateBarangay();
      validateCity();
    };
    
    // Computed property for birth years (100 years back from current year)
    const birthYears = computed(() => {
      const currentYear = new Date().getFullYear();
      return Array.from({ length: 100 }, (_, i) => currentYear - i);
    });
    
    // Computed property to check if the form is valid
    const isFormValid = computed(() => {
      // Base fields that are always required
      const baseFieldsValid = 
        formData.value.preferredDate && 
        formData.value.timeSlot &&
        formData.value.lastName && 
        formData.value.firstName && 
        // formData.value.middleName && // Middle name can be optional
        formData.value.contactNumber && 
        formData.value.email &&
        formData.value.birthMonth &&
        formData.value.birthDay &&
        formData.value.birthYear &&
        formData.value.gender &&
        formData.value.age &&
        formData.value.streetPurok &&
        formData.value.barangay &&
        formData.value.city &&
        formData.value.citizenship &&
        formData.value.applicantType;
        
      // Validate age separately if needed or ensure it's calculated.
      const ageValid = formData.value.age && parseInt(formData.value.age) > 0;

      if (!baseFieldsValid || !ageValid) {
        return false;
      }
      
      // Check applicant type specific fields
      if (formData.value.applicantType === 'senior_high_graduating') {
        const sHighValid = 
          formData.value.seniorGraduating.schoolName && 
          formData.value.seniorGraduating.schoolAddress && 
          formData.value.seniorGraduating.graduationDate;
        return sHighValid;
      } else if (formData.value.applicantType === 'senior_high_graduate') {
        const sGradValid = 
          formData.value.seniorGraduate.schoolName && 
          formData.value.seniorGraduate.schoolAddress && 
          formData.value.seniorGraduate.graduationDate;
        return sGradValid;
      } else if (formData.value.applicantType === 'college') {
        const collegeValid = 
          formData.value.college.schoolName && 
          formData.value.college.schoolAddress && 
          formData.value.college.course &&
          formData.value.college.collegeType;
        return collegeValid;
      }
      
      return false;
    });
    
    // Calculate if morning time slot is available
    const isMorningAvailable = computed(() => {
      if (!formData.value.preferredDate) return false;
      
      const dateInfo = props.dateAvailability[formData.value.preferredDate];
      return dateInfo?.morning_available ?? false;
    });
    
    // Calculate if afternoon time slot is available
    const isAfternoonAvailable = computed(() => {
      if (!formData.value.preferredDate) return false;
      
      const dateInfo = props.dateAvailability[formData.value.preferredDate];
      return dateInfo?.afternoon_available ?? false;
    });
    
    // Validate last name
    const validateLastName = () => {
      if (!formData.value.lastName.trim()) {
        validationErrors.value.lastName = 'Last name is required';
        return false;
      } else if (formData.value.lastName.trim().length < 2) { // Adjusted min length
        validationErrors.value.lastName = 'Last name must be at least 2 characters';
        return false;
      } else {
        validationErrors.value.lastName = '';
        return true;
      }
    };
    
    // Validate first name
    const validateFirstName = () => {
      if (!formData.value.firstName.trim()) {
        validationErrors.value.firstName = 'First name is required';
        return false;
      } else if (formData.value.firstName.trim().length < 2) { // Adjusted min length
        validationErrors.value.firstName = 'First name must be at least 2 characters';
        return false;
      } else {
        validationErrors.value.firstName = '';
        return true;
      }
    };
    
    // Validate middle name
    const validateMiddleName = () => {
      // Middle name is optional, so no error if empty.
      // If provided, it can have a min length, e.g., 1 character if not just an initial.
      if (formData.value.middleName.trim() && formData.value.middleName.trim().length < 1) {
        validationErrors.value.middleName = 'Middle name seems to short';
        return false; // Or true if partial validation is acceptable for optional fields
      }
      validationErrors.value.middleName = '';
      return true;
    };
    
    // Validate contact number
    const validateContactNumber = () => {
      if (!formData.value.contactNumber.trim()) {
        validationErrors.value.contactNumber = 'Contact number is required';
        return false;
      } else if (!/^[0-9+\-\s()]{7,15}$/.test(formData.value.contactNumber.trim())) {
        validationErrors.value.contactNumber = 'Please enter a valid phone number';
        return false;
      } else {
        validationErrors.value.contactNumber = '';
        return true;
      }
    };
    
    // Validate email
    const validateEmail = () => {
      if (!formData.value.email.trim()) {
        validationErrors.value.email = 'Email address is required';
        return false;
      } else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(formData.value.email.trim())) {
        validationErrors.value.email = 'Please enter a valid email address';
        return false;
      } else {
        validationErrors.value.email = '';
        return true;
      }
    };
    
    // Validate birth date
    const validateBirthDate = () => {
      if (!formData.value.birthMonth || !formData.value.birthDay || !formData.value.birthYear) {
        validationErrors.value.birthDate = 'Complete birth date is required';
        return false;
      } else {
        // Check if the birth date is valid
        const birthDate = new Date(
          parseInt(formData.value.birthYear),
          parseInt(formData.value.birthMonth) - 1,
          parseInt(formData.value.birthDay)
        );
        
        if (birthDate.toString() === 'Invalid Date' || 
            birthDate.getMonth() !== parseInt(formData.value.birthMonth) - 1 ||
            birthDate.getDate() !== parseInt(formData.value.birthDay)) {
          validationErrors.value.birthDate = 'Please enter a valid date';
          return false;
        } else {
          validationErrors.value.birthDate = '';
          return true;
        }
      }
    };
    
    // Validate age
    const validateAge = () => {
      if (!formData.value.age) {
        validationErrors.value.age = 'Age is required (auto-calculated from birth date)';
        return false;
      } else if (isNaN(parseInt(formData.value.age)) || parseInt(formData.value.age) <= 0) {
        validationErrors.value.age = 'Enter a valid birth date to calculate age.';
        return false;
      } else if (parseInt(formData.value.age) < 10) { // Example: Minimum age
        validationErrors.value.age = 'Applicant must be at least 10 years old.';
        return false;
      }
      validationErrors.value.age = '';
      return true;
    };
    
    // Validate gender
    const validateGender = () => {
      if (!formData.value.gender) {
        validationErrors.value.gender = 'Gender is required';
        return false;
      } else {
        validationErrors.value.gender = '';
        return true;
      }
    };
    
    // Validate street/purok
    const validateStreetPurok = () => {
      if (!formData.value.streetPurok.trim()) {
        validationErrors.value.streetPurok = 'Street/Purok is required';
        return false;
      } else if (formData.value.streetPurok.trim().length < 3) {
        validationErrors.value.streetPurok = 'Street/Purok must be at least 3 characters';
        return false;
      } else {
        validationErrors.value.streetPurok = '';
        return true;
      }
    };
    
    // Validate barangay
    const validateBarangay = () => {
      if (!formData.value.barangay.trim()) {
        validationErrors.value.barangay = 'Barangay is required';
        return false;
      } else if (formData.value.barangay.trim().length < 3) {
        validationErrors.value.barangay = 'Barangay must be at least 3 characters';
        return false;
      } else {
        validationErrors.value.barangay = '';
        return true;
      }
    };
    
    // Validate city
    const validateCity = () => {
      if (!formData.value.city.trim()) {
        validationErrors.value.city = 'City/Municipality is required';
        return false;
      } else if (formData.value.city.trim().length < 3) {
        validationErrors.value.city = 'City/Municipality must be at least 3 characters';
        return false;
      } else {
        validationErrors.value.city = '';
        return true;
      }
    };
    
    // Validate citizenship
    const validateCitizenship = () => {
      if (!formData.value.citizenship.trim()) {
        validationErrors.value.citizenship = 'Citizenship is required';
        return false;
      } else if (formData.value.citizenship.trim().length < 3) {
        validationErrors.value.citizenship = 'Citizenship must be at least 3 characters';
        return false;
      } else {
        validationErrors.value.citizenship = '';
        return true;
      }
    };
    
    // Validate WMSUCET experience
    const validateWmsucetExperience = () => {
      if (!formData.value.wmsucetExperience.firstTime && !formData.value.wmsucetExperience.notFirstTime) {
        validationErrors.value.wmsucetExperience = 'Please select if this is your first time taking the WMSUCET';
        return false;
      } else if (formData.value.wmsucetExperience.notFirstTime && !formData.value.wmsucetExperience.timesTaken) {
        validationErrors.value.wmsucetExperience = 'Please indicate how many times you have taken the WMSUCET';
        return false;
      } else {
        validationErrors.value.wmsucetExperience = '';
        return true;
      }
    };
    
    // Validate applicant type
    const validateApplicantType = () => {
      if (!formData.value.applicantType) {
        validationErrors.value.applicantType = 'Please select your applicant type';
        return false;
      } else {
        // Validate fields based on applicant type
        if (formData.value.applicantType === 'senior_high_graduating') {
          if (!formData.value.seniorGraduating.schoolName.trim()) {
            validationErrors.value.applicantType = 'School name is required';
            return false;
          } else if (!formData.value.seniorGraduating.schoolAddress.trim()) {
            validationErrors.value.applicantType = 'School address is required';
            return false;
          } else if (!formData.value.seniorGraduating.graduationDate.trim()) {
            validationErrors.value.applicantType = 'Expected graduation date is required';
            return false;
          }
        } else if (formData.value.applicantType === 'senior_high_graduate') {
          if (!formData.value.seniorGraduate.schoolName.trim()) {
            validationErrors.value.applicantType = 'School name is required';
            return false;
          } else if (!formData.value.seniorGraduate.schoolAddress.trim()) {
            validationErrors.value.applicantType = 'School address is required';
            return false;
          } else if (!formData.value.seniorGraduate.graduationDate.trim()) {
            validationErrors.value.applicantType = 'Graduation date is required';
            return false;
          }
        } else if (formData.value.applicantType === 'college') {
          if (!formData.value.college.schoolName.trim()) {
            validationErrors.value.applicantType = 'School name is required';
            return false;
          } else if (!formData.value.college.schoolAddress.trim()) {
            validationErrors.value.applicantType = 'School address is required';
            return false;
          } else if (!formData.value.college.course.trim()) {
            validationErrors.value.applicantType = 'Course is required';
            return false;
          } else if (!formData.value.college.collegeType) {
            validationErrors.value.applicantType = 'College type is required';
            return false;
          }
        }
        validationErrors.value.applicantType = '';
        return true;
      }
    };
    
    // Validate course choices and socio-economic data
    const validateCourseChoicesAndSocioEconomic = () => {
      let isValid = true;
      
      // Safety check - ensure data structures exist
      if (!formData.value.courseChoices || !formData.value.socioEconomic || !formData.value.additionalInfo) {
        return true; // Skip validation if structures don't exist yet
      }
      
      // Course choices validation
      if (!formData.value.courseChoices?.firstChoice || !formData.value.courseChoices.firstChoice.trim()) {
        validationErrors.value.firstChoice = 'First choice course is required';
        isValid = false;
      } else {
        validationErrors.value.firstChoice = '';
      }
      
      if (!formData.value.courseChoices?.firstChoiceCampus || !formData.value.courseChoices.firstChoiceCampus.trim()) {
        validationErrors.value.firstChoiceCampus = 'Campus for first choice is required';
        isValid = false;
      } else {
        validationErrors.value.firstChoiceCampus = '';
      }
      
      if (!formData.value.courseChoices?.secondChoice || !formData.value.courseChoices.secondChoice.trim()) {
        validationErrors.value.secondChoice = 'Second choice course is required';
        isValid = false;
      } else {
        validationErrors.value.secondChoice = '';
      }
      
      if (!formData.value.courseChoices?.secondChoiceCampus || !formData.value.courseChoices.secondChoiceCampus.trim()) {
        validationErrors.value.secondChoiceCampus = 'Campus for second choice is required';
        isValid = false;
      } else {
        validationErrors.value.secondChoiceCampus = '';
      }
      
      // Socio-economic validation - Father
      if (!formData.value.socioEconomic?.father?.citizenship || !formData.value.socioEconomic.father.citizenship.trim()) {
        validationErrors.value.fatherCitizenship = "Father's citizenship is required";
        isValid = false;
      } else {
        validationErrors.value.fatherCitizenship = '';
      }
      
      if (!formData.value.socioEconomic?.father?.education || !formData.value.socioEconomic.father.education.trim()) {
        validationErrors.value.fatherEducation = "Father's education is required";
        isValid = false;
      } else {
        validationErrors.value.fatherEducation = '';
      }
      
      if (!formData.value.socioEconomic?.father?.occupation || !formData.value.socioEconomic.father.occupation.trim()) {
        validationErrors.value.fatherOccupation = "Father's occupation is required";
        isValid = false;
      } else {
        validationErrors.value.fatherOccupation = '';
      }
      
      // Socio-economic validation - Mother
      if (!formData.value.socioEconomic?.mother?.citizenship || !formData.value.socioEconomic.mother.citizenship.trim()) {
        validationErrors.value.motherCitizenship = "Mother's citizenship is required";
        isValid = false;
      } else {
        validationErrors.value.motherCitizenship = '';
      }
      
      if (!formData.value.socioEconomic?.mother?.education || !formData.value.socioEconomic.mother.education.trim()) {
        validationErrors.value.motherEducation = "Mother's education is required";
        isValid = false;
      } else {
        validationErrors.value.motherEducation = '';
      }
      
      if (!formData.value.socioEconomic?.mother?.occupation || !formData.value.socioEconomic.mother.occupation.trim()) {
        validationErrors.value.motherOccupation = "Mother's occupation is required";
        isValid = false;
      } else {
        validationErrors.value.motherOccupation = '';
      }
      
      // Additional information validation
      if (formData.value.additionalInfo?.hasDisability === null || formData.value.additionalInfo?.hasDisability === undefined) {
        validationErrors.value.hasDisability = "Please select whether you have any disability";
        isValid = false;
      } else {
        validationErrors.value.hasDisability = '';
      }
      
      if (formData.value.additionalInfo?.knowsComputer === null || formData.value.additionalInfo?.knowsComputer === undefined) {
        validationErrors.value.knowsComputer = "Please select whether you know how to use a computer";
        isValid = false;
      } else {
        validationErrors.value.knowsComputer = '';
      }
      
      if (formData.value.additionalInfo?.isIndigenous === null || formData.value.additionalInfo?.isIndigenous === undefined) {
        validationErrors.value.isIndigenous = "Please select whether you belong to an indigenous group";
        isValid = false;
      } else {
        validationErrors.value.isIndigenous = '';
      }
      
      if (!formData.value.additionalInfo?.religion || !formData.value.additionalInfo.religion.trim()) {
        validationErrors.value.religion = "Religious affiliation is required";
        isValid = false;
      } else {
        validationErrors.value.religion = '';
      }
      
      return isValid;
    };
    
    // Validate date and time slot
    const validateDateTime = () => {
      if (!formData.value.preferredDate) {
        dateError.value = 'Please select a date for your appointment';
        return false;
      }
      if (!formData.value.timeSlot) { // Ensure time slot is also selected
        dateError.value = 'Please select a time slot for your appointment';
        return false;
      }
      if (!formData.value.testCenter) {
        validationErrors.value.testCenter = 'Please select a test center for your appointment';
        return false;
      }
      
      dateError.value = '';
      validationErrors.value.testCenter = '';
      return true;
    };
    
    // Set up watchers for real-time validation
    watch(() => formData.value.lastName, () => {
      if (touchedFields.value.lastName) validateLastName();
    });
    
    watch(() => formData.value.firstName, () => {
      if (touchedFields.value.firstName) validateFirstName();
    });
    
    watch(() => formData.value.middleName, () => {
      if (touchedFields.value.middleName) validateMiddleName();
    });
    
    watch(() => formData.value.contactNumber, () => {
      if (touchedFields.value.contactNumber) validateContactNumber();
    });
    
    watch(() => formData.value.email, () => {
      if (touchedFields.value.email) validateEmail();
    });
    
    watch(() => formData.value.streetPurok, () => {
      if (touchedFields.value.streetPurok) validateStreetPurok();
    });
    
    watch(() => formData.value.barangay, () => {
      if (touchedFields.value.barangay) validateBarangay();
    });
    
    watch(() => formData.value.city, () => {
      if (touchedFields.value.city) validateCity();
    });
    
    watch(() => formData.value.citizenship, () => {
      if (touchedFields.value.citizenship) validateCitizenship();
    });
    
    watch(() => formData.value.gender, () => {
      if (touchedFields.value.gender) validateGender();
    });
    
    watch([ // Watch for changes in any birth date field
      () => formData.value.birthMonth,
      () => formData.value.birthDay,
      () => formData.value.birthYear
    ], () => {
      calculateAndSetAge();
      if (touchedFields.value.birthMonth || touchedFields.value.birthDay || touchedFields.value.birthYear) {
        touchedFields.value.birthMonth = true; // Keep these for birth date validation UX
        touchedFields.value.birthDay = true;
        touchedFields.value.birthYear = true;
        validateBirthDate(); // Validate the date itself
      }
    });
    
    watch([
      () => formData.value.wmsucetExperience.firstTime,
      () => formData.value.wmsucetExperience.notFirstTime,
      () => formData.value.wmsucetExperience.timesTaken
    ], () => {
      validateWmsucetExperience();
    });
    
    watch(() => formData.value.applicantType, (newVal) => {
      touchedFields.value.applicantType = true;
      validateApplicantType();
    });
    
    // Update validation when specific applicant type fields change
    watch(() => formData.value.seniorGraduating, () => {
      if (formData.value.applicantType === 'senior_high_graduating') validateApplicantType();
    }, { deep: true });
    
    watch(() => formData.value.seniorGraduate, () => {
      if (formData.value.applicantType === 'senior_high_graduate') validateApplicantType();
    }, { deep: true });
    
    watch(() => formData.value.college, () => {
      if (formData.value.applicantType === 'college') validateApplicantType();
    }, { deep: true });
    
    watch([
      () => formData.value.preferredDate,
      () => formData.value.timeSlot
    ], () => {
      touchedFields.value.preferredDate = true;
      touchedFields.value.timeSlot = true;
      validateDateTime();
    });
    
    // fetchData is now moved above the watch statement
    
    // Fetch user appointments to check for duplicates
    const fetchUserAppointments = async () => {
      try {
        const response = await axios.get('/api/appointments/');
        userAppointments.value = response.data;
        console.log('User appointments loaded:', userAppointments.value);
      } catch (err) {
        console.error('Error fetching user appointments:', err);
        // Don't set error.value here to avoid blocking the main flow
      }
    };
    
    // Watch for modal open/close
    watch(() => props.modelValue, (newVal) => {
      if (newVal && props.program?.id) {
        fetchData();
        fetchUserAppointments(); // Fetch user appointments to check for duplicates
      }
      
      // Reset the form data when modal is opened
      if (newVal) {
        // Get current user data
        const currentUser = AuthService.getCurrentUser();
        const userEmail = currentUser?.email || '';
        
        formData.value = {
          preferredDate: '',
          timeSlot: '',
          lastName: '',
          firstName: '',
          middleName: '',
          contactNumber: '',
          email: userEmail, // Pre-populate with user's email
          schoolName: '',
          birthMonth: '',
          birthDay: '',
          birthYear: '',
          gender: '',
          age: '',
          streetPurok: '',
          barangay: '',
          city: '',
          citizenship: '',
          highSchoolCode: '',
          wmsucetExperience: {
            firstTime: true,
            notFirstTime: false,
            timesTaken: ''
          },
          applicantType: '',
          seniorGraduating: {
            schoolName: '',
            schoolAddress: '',
            graduationDate: ''
          },
          seniorGraduate: {
            schoolName: '',
            schoolAddress: '',
            graduationDate: ''
          },
          college: {
            schoolName: '',
            schoolAddress: '',
            course: '',
            collegeType: ''
          },
          // Course choices and campus information
          courseChoices: {
            firstChoice: '',
            firstChoiceCampus: '',
            secondChoice: '',
            secondChoiceCampus: '',
            thirdChoice: '',
            thirdChoiceCampus: ''
          },
          // Socio-economic data
          socioEconomic: {
            father: {
              citizenship: '',
              education: '',
              occupation: '',
              employer: '',
              income: ''
            },
            mother: {
              citizenship: '',
              education: '',
              occupation: '',
              employer: '',
              income: ''
            }
          },
          // Additional information
          additionalInfo: {
            hasDisability: false,
            disabilityDescription: '',
            knowsComputer: false,
            isIndigenous: false,
            indigenousGroup: '',
            religion: '',
            religionOthers: ''
          }
        };
        dateError.value = '';
        validationErrors.value = {
          lastName: '',
          firstName: '',
          middleName: '',
          contactNumber: '',
          email: '',
          birthDate: '',
          gender: '',
          age: '',
          streetPurok: '',
          barangay: '',
          city: '',
          citizenship: '',
          wmsucetExperience: '',
          applicantType: ''
        };
        
        // Reset touched fields
        Object.keys(touchedFields.value).forEach(key => {
          touchedFields.value[key] = false;
        });
      }
      
      // Close calendar when modal is closed
      if (!newVal) {
        showCalendar.value = false;
      }
    }, { immediate: true });
    
    // Close calendar when clicking outside
    const handleClickOutside = (event) => {
      const calendarContainer = document.querySelector('.calendar-container');
      const calendarTrigger = document.querySelector('[data-calendar-trigger]');
      
      if (calendarContainer && !calendarContainer.contains(event.target) && 
          calendarTrigger && !calendarTrigger.contains(event.target)) {
        showCalendar.value = false;
      }
    };
    
    // Add and remove event listeners for calendar
    watch(() => showCalendar.value, (isOpen) => {
      if (isOpen) {
        document.addEventListener('click', handleClickOutside);
      } else {
        document.removeEventListener('click', handleClickOutside);
      }
    });
    
    // Clean up event listeners when component is unmounted or modal closes
    onUnmounted(() => {
      document.removeEventListener('click', handleClickOutside);
    });
    
    // Add debugging on mount
    onMounted(() => {
      console.log('ScheduleModal mounted');
      console.log('formData:', formData.value);
      console.log('courseChoices:', formData.value?.courseChoices);
      console.log('socioEconomic:', formData.value?.socioEconomic);
      console.log('additionalInfo:', formData.value?.additionalInfo);
      
      // Ensure formData nested objects are properly initialized
      if (!formData.value.courseChoices) {
        formData.value.courseChoices = {
          firstChoice: '',
          firstChoiceCampus: '',
          secondChoice: '',
          secondChoiceCampus: '',
          thirdChoice: '',
          thirdChoiceCampus: ''
        };
      }
      
      if (!formData.value.socioEconomic) {
        formData.value.socioEconomic = {
          father: {
            citizenship: '',
            education: '',
            occupation: '',
            employer: '',
            income: ''
          },
          mother: {
            citizenship: '',
            education: '',
            occupation: '',
            employer: '',
            income: ''
          }
        };
      }
      
      if (!formData.value.additionalInfo) {
        formData.value.additionalInfo = {
          hasDisability: false,
          disabilityDescription: '',
          knowsComputer: false,
          isIndigenous: false,
          indigenousGroup: '',
          religion: '',
          religionOthers: ''
        };
      }
      
      console.log('philippineBarangays length:', philippineBarangays.value.length);
      console.log('philippineCities length:', philippineCities.value.length);
      console.log('citizenshipOptions length:', citizenshipOptions.value.length);
      console.log('zamboanganSchools length:', zamboanganSchools.value.length);
      console.log('First 5 barangays:', philippineBarangays.value.slice(0, 5));
      console.log('First 5 cities:', philippineCities.value.slice(0, 5));
      console.log('First 5 citizenships:', citizenshipOptions.value.slice(0, 5));
      console.log('First 5 Zamboangan schools:', zamboanganSchools.value.slice(0, 5));
    });
    
    // Add cleanup for when the modal is closed
    watch(() => props.modelValue, (newVal) => {
      if (!newVal) {
        document.removeEventListener('click', handleClickOutside);
      }
    });
    
    // Add watchers to update schoolName based on applicant type
    watch(() => formData.value.seniorGraduating.schoolName, (newVal) => {
      if (formData.value.applicantType === 'senior_high_graduating' && newVal) {
        formData.value.schoolName = newVal;
      }
    });
    
    watch(() => formData.value.seniorGraduate.schoolName, (newVal) => {
      if (formData.value.applicantType === 'senior_high_graduate' && newVal) {
        formData.value.schoolName = newVal;
      }
    });
    
    watch(() => formData.value.college.schoolName, (newVal) => {
      if (formData.value.applicantType === 'college' && newVal) {
        formData.value.schoolName = newVal;
      }
    });
    
    // Also watch for applicant type changes to update schoolName accordingly
    watch(() => formData.value.applicantType, (newType) => {
      if (newType === 'senior_high_graduating' && formData.value.seniorGraduating.schoolName) {
        formData.value.schoolName = formData.value.seniorGraduating.schoolName;
      } else if (newType === 'senior_high_graduate' && formData.value.seniorGraduate.schoolName) {
        formData.value.schoolName = formData.value.seniorGraduate.schoolName;
      } else if (newType === 'college' && formData.value.college.schoolName) {
        formData.value.schoolName = formData.value.college.schoolName;
      }
    });
    
    // Format date for display
    const formatDate = (dateString) => {
      if (!dateString) return 'Not selected';
      const options = { year: 'numeric', month: 'long', day: 'numeric' };
      return new Date(dateString).toLocaleDateString('en-US', options);
    };
    
    // Time slot selection with validation
    const selectTimeSlot = (slot) => {
      const dateInfo = props.dateAvailability[formData.value.preferredDate];
      if (!dateInfo) return;
      
      const isAvailable = slot === 'morning' 
        ? dateInfo.morning_available 
        : dateInfo.afternoon_available;
      
      if (!isAvailable) {
        dateError.value = `The ${slot} session for this date is fully booked. Please select another time slot.`;
        return;
      }
      
      formData.value.timeSlot = slot;
      dateError.value = '';
      
      // Reset test center selection when time slot changes
      formData.value.testCenter = '';
      validationErrors.value.testCenter = '';
      
      console.log('🕒 Time slot selected:', slot);
      console.log('📅 Current date:', formData.value.preferredDate);
      console.log('🔄 About to fetch test centers...');
      
      // Fetch test centers and rooms when time slot is selected
      fetchTestCenters();
      
      // Add a slight delay before closing the calendar for better UX
      setTimeout(() => {
        showCalendar.value = false;
      }, 500); // Increased delay for better reliability
    };
    
    // Test Center selection
    const selectTestCenter = (center) => {
      formData.value.testCenter = center.id;
      validationErrors.value.testCenter = '';
    };
    
    // Fetch test centers
    const fetchTestCenters = async () => {
      loadingTestCenters.value = true;
      try {
        console.log('🔄 Fetching test centers...');
        console.log('📍 Current step:', currentStep.value);
        console.log('📅 Selected date:', formData.value.preferredDate);
        console.log('⏰ Selected time slot:', formData.value.timeSlot);
        
        const response = await axios.get('/api/test-centers/');
        console.log('✅ Test centers response status:', response.status);
        console.log('📊 Test centers response data:', response.data);
        console.log('📈 Number of test centers:', response.data.length);
        
        testCenters.value = response.data;
        
        if (response.data.length > 0) {
          console.log('🎯 Test centers loaded successfully:', testCenters.value);
        } else {
          console.warn('⚠️ API returned empty array for test centers');
        }
        
        // Also fetch test rooms for room availability
        await fetchTestRooms();
      } catch (error) {
        console.error('❌ Error fetching test centers:', error);
        console.error('🔍 Error status:', error.response?.status);
        console.error('📝 Error details:', error.response?.data);
        console.error('🌐 Error message:', error.message);
        testCenters.value = [];
        
        // Show user-friendly error message
        showToast('Error loading test centers. Please try again.', 'error');
      } finally {
        loadingTestCenters.value = false;
        console.log('🏁 fetchTestCenters completed. testCenters.value.length:', testCenters.value.length);
      }
    };
    
    // Fetch test rooms
    const fetchTestRooms = async () => {
      try {
        console.log('Fetching test rooms...');
        const response = await axios.get('/api/admin/test-rooms/');
        console.log('Test rooms response:', response.data);
        testRooms.value = response.data;
      } catch (error) {
        console.error('Error fetching test rooms:', error);
        console.error('Error details:', error.response?.data);
        testRooms.value = [];
      }
    };
    
    // Get rooms for a specific test center and time slot
    const getRoomsForCenter = (centerId, timeSlot) => {
      return testRooms.value.filter(room => 
        room.test_center === centerId && room.time_slot === timeSlot && room.is_active
      );
    };
    
    // Add watcher to close calendar when time slot changes, as a backup
    watch(() => formData.value.timeSlot, (newVal) => {
      if (newVal && showCalendar.value) {
        // Add a delay for better user experience
        setTimeout(() => {
          showCalendar.value = false;
        }, 500);
      }
    });
    
    // Validate form data
    const validateForm = () => {
      // Mark all fields as touched to show validation errors
      Object.keys(touchedFields.value).forEach(key => {
        touchedFields.value[key] = true;
      });
      
      // Run all validation functions
      const validationResults = [
        validateLastName(),
        validateFirstName(),
        validateMiddleName(),
        validateContactNumber(),
        validateEmail(),
        validateBirthDate(),
        validateGender(),
        validateStreetPurok(),
        validateBarangay(),
        validateCity(),
        validateCitizenship(),
        validateWmsucetExperience(),
        validateApplicantType(),
        validateDateTime()
      ];
      
      const isValid = validationResults.every(result => result);
      
      if (!isValid) {
        // Find the first field with an error and scroll to it
        const firstErrorElement = document.querySelector('.error-text:not(:empty)');
        if (firstErrorElement) {
          firstErrorElement.scrollIntoView({ behavior: 'smooth', block: 'center' });
        }
        
        // Show a notification about missing fields
        const notification = document.createElement('div');
        notification.className = 'fixed top-4 right-4 bg-red-100 border-l-4 border-red-500 text-red-700 p-4 rounded shadow-md z-50 animate-fade-in';
        notification.innerHTML = `
          <div class="flex items-center">
            <div class="flex-shrink-0">
              <i class="fas fa-exclamation-circle text-red-500 mr-2"></i>
            </div>
            <div>Please complete all required fields before submitting.</div>
            <button class="ml-4 text-red-500 hover:text-red-700" onclick="this.parentElement.parentElement.remove()">
              <i class="fas fa-times"></i>
            </button>
          </div>
        `;
        document.body.appendChild(notification);
        
        // Remove the notification after 5 seconds
        setTimeout(() => {
          if (document.body.contains(notification)) {
            notification.remove();
          }
        }, 5000);
        
        return false;
      }
      
      return true;
    };
    
    // Fetch program details
    const fetchData = async () => {
      if (!props.program?.id) return;
      
      loading.value = true;
      error.value = null;
      
      try {
        const url = `/api/programs/${props.program.id}/`;
        
        const response = await axios.get(url);
        
        // Check if modal was closed during API call
        if (!props.modelValue) return;
        
        // Check if response is HTML instead of JSON
        const contentType = response.headers['content-type'] || '';
        if (contentType.includes('text/html')) {
          console.error('Unexpected response format: HTML received instead of JSON', response.data);
          error.value = 'Received HTML response instead of JSON. The API might be misconfigured.';
          return;
        }
        
        // Process your data
        apiData.value = response.data;
        
        // Also fetch test sessions for highlighting exam dates
        await fetchTestSessions();
        
        // Fetch user's existing appointments
        await fetchUserAppointments();
        
      } catch (err) {
        // Check if modal was closed during API call
        if (!props.modelValue) return;
        
        console.error('Error fetching data:', err);
        
        // Check if the error response is HTML
        if (err.response && err.response.data && typeof err.response.data === 'string' && 
            err.response.data.includes('<!DOCTYPE html>')) {
          error.value = 'API returned HTML instead of JSON. This may be due to a server misconfiguration.';
          console.error('Unexpected response format:', err.response.data);
        } else {
          error.value = err.message || 'Error fetching data';
        }
      } finally {
        loading.value = false;
      }
    };
    
    // fetchUserAppointments is now defined above the watch statement

    // Fetch test sessions for highlighting exam dates
    const fetchTestSessions = async () => {
      try {
        console.log('🔄 Fetching test sessions...');
        
        // Try different endpoints to find the working one
        const endpoints = [
          '/api/public/test-sessions/',  // New public endpoint (no auth required)
          '/api/public/test-sessions',   // Without trailing slash
          '/api/admin/test-sessions/',   // Admin endpoint (auth required)
          '/api/test-sessions/',         // Generic endpoint
          '/admin/test-sessions/',       // Admin endpoint alt
          '/test-sessions/'             // Basic endpoint
        ];
        
        let response = null;
        let workingEndpoint = null;
        
        for (const endpoint of endpoints) {
          try {
            console.log(`🔍 Trying endpoint: ${endpoint}`);
            response = await axios.get(endpoint);
            workingEndpoint = endpoint;
            console.log(`✅ Success with endpoint: ${endpoint}`);
            break;
          } catch (err) {
            console.log(`❌ Failed endpoint: ${endpoint}`, err.response?.status || err.message);
            continue;
          }
        }
        
        if (!response) {
          console.warn('⚠️ No test sessions endpoint available - calendar highlighting will be disabled');
          testSessions.value = [];
          return;
        }
        
        testSessions.value = response.data;
        console.log('✅ Test sessions loaded:', testSessions.value);
        console.log('📊 Test sessions count:', testSessions.value.length);
        console.log('🌐 Working endpoint:', workingEndpoint);
        
        // Log individual test sessions for debugging
        testSessions.value.forEach((session, index) => {
          console.log(`📋 Session ${index + 1}:`, {
            id: session.id,
            exam_type: session.exam_type,
            exam_date: session.exam_date,
            registration_start: session.registration_start_date,
            registration_end: session.registration_end_date,
            status: session.status,
            raw: session
          });
        });
        
        // Test the date formatting
        const today = new Date();
        const todayStr = formatDateForApi(today);
        console.log('🗓️ Today formatted:', todayStr);
        
        // Check if today matches any exam dates
        const todayExams = testSessions.value.filter(session => session.exam_date === todayStr);
        console.log('📅 Exams today:', todayExams);
        
        // Check if today is in any registration period
        const todayRegistrations = testSessions.value.filter(session => {
          const regStart = new Date(session.registration_start_date);
          const regEnd = new Date(session.registration_end_date);
          const currentDate = new Date(todayStr);
          return currentDate >= regStart && currentDate <= regEnd;
        });
        console.log('🟢 Registration periods active today:', todayRegistrations);
        
        // Test specific dates from your test sessions
        const testDates = ['2025-06-29', '2025-07-29', '2025-07-21', '2025-06-27'];
        testDates.forEach(dateStr => {
          const exams = testSessions.value.filter(session => session.exam_date === dateStr);
          const registrations = testSessions.value.filter(session => {
            const regStart = new Date(session.registration_start_date);
            const regEnd = new Date(session.registration_end_date);
            const currentDate = new Date(dateStr);
            return currentDate >= regStart && currentDate <= regEnd;
          });
          console.log(`🎯 ${dateStr} - Exams: ${exams.length}, Registrations: ${registrations.length}`);
        });
        
      } catch (err) {
        console.error('❌ Error fetching test sessions:', err);
        console.error('📝 Error details:', err.response?.data || err.message);
        console.error('🔍 Full error:', err);
        // Don't throw error, just set empty array so calendar still works
        testSessions.value = [];
      }
    };

    // Helper function to format dates for API (moved up for use in fetchTestSessions)
    const formatDateForApi = (date) => {
      const year = date.getFullYear();
      const month = String(date.getMonth() + 1).padStart(2, '0');
      const day = String(date.getDate()).padStart(2, '0');
      return `${year}-${month}-${day}`;
    };
    
    // Form submission
    const submitForm = () => {
      // Mark all fields as touched to show validation errors
      Object.keys(touchedFields.value).forEach(key => {
        touchedFields.value[key] = true;
      });
      
      // Run all validation functions
      const isStep1Valid = validateLastName() && validateFirstName() && validateMiddleName() && validateContactNumber() && validateEmail() && validateBirthDate() && validateAge() && validateGender() && validateStreetPurok() && validateBarangay() && validateCity() && validateCitizenship();
      const isStep2Valid = validateWmsucetExperience() && validateApplicantType();
      const isStep3Valid = validateCourseChoicesAndSocioEconomic();
      const isStep5Valid = validateDateTime();


      if (!isStep1Valid || !isStep2Valid || !isStep3Valid || !isStep5Valid) {
        // Find the first field with an error and scroll to it
        const firstErrorElement = document.querySelector('.error-text:not(:empty)');
        if (firstErrorElement) {
          firstErrorElement.scrollIntoView({ behavior: 'smooth', block: 'center' });
        }
        
        // Show a notification about missing fields
        const notification = document.createElement('div');
        notification.className = 'fixed top-4 right-4 bg-red-100 border-l-4 border-red-500 text-red-700 p-4 rounded shadow-md z-50 animate-fade-in';
        notification.innerHTML = `
          <div class="flex items-center">
            <div class="flex-shrink-0">
              <i class="fas fa-exclamation-circle text-red-500 mr-2"></i>
            </div>
            <div>Please complete all required fields for this step.</div>
            <button class="ml-4 text-red-500 hover:text-red-700" onclick="this.parentElement.parentElement.remove()">
              <i class="fas fa-times"></i>
            </button>
          </div>
        `;
        document.body.appendChild(notification);
        
        // Remove the notification after 5 seconds
        setTimeout(() => {
          if (document.body.contains(notification)) {
            notification.remove();
          }
        }, 5000);
        
        return;
      }
      
      try {
        const homeAddressString = `${formData.value.streetPurok}, ${formData.value.barangay}, ${formData.value.city}`.trim();
        const applicationData = {
          // Personal info
          full_name: `${formData.value.lastName}, ${formData.value.firstName} ${formData.value.middleName}`.trim(),
          last_name: formData.value.lastName.trim(),
          first_name: formData.value.firstName.trim(),
          middle_name: formData.value.middleName.trim(),
          contact_number: formData.value.contactNumber,
          email: formData.value.email,
          birth_month: formData.value.birthMonth,
          birth_day: formData.value.birthDay,
          birth_year: formData.value.birthYear,
          gender: formData.value.gender,
          age: parseInt(formData.value.age),
          home_address: homeAddressString, // Combined address
          street_purok: formData.value.streetPurok, // Added
          barangay: formData.value.barangay,       // Added
          city: formData.value.city,             // Added
          citizenship: formData.value.citizenship,
          high_school_code: formData.value.highSchoolCode || '',
          
          // WMSUCET experience
          is_first_time: formData.value.wmsucetExperience.firstTime,
          times_taken: formData.value.wmsucetExperience.notFirstTime ? parseInt(formData.value.wmsucetExperience.timesTaken) || 0 : 0,
          
          // Applicant type
          applicant_type: formData.value.applicantType,
          
          // Course choices and campus information
          first_choice_course: formData.value.courseChoices.firstChoice,
          first_choice_campus: formData.value.courseChoices.firstChoiceCampus,
          second_choice_course: formData.value.courseChoices.secondChoice,
          second_choice_campus: formData.value.courseChoices.secondChoiceCampus,
          third_choice_course: formData.value.courseChoices.thirdChoice,
          third_choice_campus: formData.value.courseChoices.thirdChoiceCampus,
          
          // Socio-economic data - Father information
          father_citizenship: formData.value.socioEconomic.father.citizenship,
          father_education: formData.value.socioEconomic.father.education,
          father_work_occupation: formData.value.socioEconomic.father.occupation,
          father_employer: formData.value.socioEconomic.father.employer,
          father_monthly_income: formData.value.socioEconomic.father.income,
          
          // Socio-economic data - Mother information
          mother_citizenship: formData.value.socioEconomic.mother.citizenship,
          mother_education: formData.value.socioEconomic.mother.education,
          mother_work_occupation: formData.value.socioEconomic.mother.occupation,
          mother_employer: formData.value.socioEconomic.mother.employer,
          mother_monthly_income: formData.value.socioEconomic.mother.income,
          
          // Physical disability information
          has_physical_disability: formData.value.additionalInfo.hasDisability,
          disability_description: formData.value.additionalInfo.disabilityDescription,
          
          // Computer usage knowledge
          knows_computer_usage: formData.value.additionalInfo.knowsComputer,
          
          // Indigenous Peoples Group membership
          is_indigenous_member: formData.value.additionalInfo.isIndigenous,
          indigenous_group_specify: formData.value.additionalInfo.indigenousGroup,
          
          // Religious affiliation
          religious_affiliation: formData.value.additionalInfo.religion,
          religious_affiliation_others: formData.value.additionalInfo.religionOthers,
          
          // School info - will be populated based on applicant type
          school_name: formData.value.schoolName || '',
          school_address: '', // This might need updating if school address is also separated
          school_graduation_date: '',
          college_level: '',
          college_course: '',
          college_type: '',
          
          // Appointment details
          program: props.program?.id,
          preferred_date: formData.value.preferredDate,
          time_slot: formData.value.timeSlot,
          test_center: formData.value.testCenter,
        };
        
        // Set school-related fields based on applicant type (remains the same)
        if (formData.value.applicantType === 'senior_high_graduating') {
          applicationData.school_name = formData.value.seniorGraduating.schoolName;
          applicationData.school_address = formData.value.seniorGraduating.schoolAddress;
          applicationData.school_graduation_date = formData.value.seniorGraduating.graduationDate;
        } else if (formData.value.applicantType === 'senior_high_graduate') {
          applicationData.school_name = formData.value.seniorGraduate.schoolName;
          applicationData.school_address = formData.value.seniorGraduate.schoolAddress;
          applicationData.school_graduation_date = formData.value.seniorGraduate.graduationDate;
        } else if (formData.value.applicantType === 'college') {
          applicationData.school_name = formData.value.college.schoolName;
          applicationData.school_address = formData.value.college.schoolAddress;
          applicationData.college_course = formData.value.college.course;
          applicationData.college_type = formData.value.college.collegeType;
        }
        
        ApplicationFormStore.setFormData({
          fullName: `${formData.value.lastName}, ${formData.value.firstName} ${formData.value.middleName}`,
          contactNumber: formData.value.contactNumber,
          email: formData.value.email,
          schoolName: formData.value.applicantType === 'senior_high_graduating' ? formData.value.seniorGraduating.schoolName : 
                     formData.value.applicantType === 'senior_high_graduate' ? formData.value.seniorGraduate.schoolName :
                     formData.value.applicantType === 'college' ? formData.value.college.schoolName : '',
          birthMonth: formData.value.birthMonth,
          birthDay: formData.value.birthDay,
          birthYear: formData.value.birthYear,
          gender: { 
            male: formData.value.gender === 'male', 
            female: formData.value.gender === 'female' 
          },
          age: formData.value.age,
          homeAddress: homeAddressString, // Combined address
          streetPurok: formData.value.streetPurok, // Added
          barangay: formData.value.barangay,    // Added
          city: formData.value.city,            // Added
          citizenship: formData.value.citizenship,
          highSchoolCode: formData.value.highSchoolCode,
          wmsucetExperience: formData.value.wmsucetExperience,
          applicantType: formData.value.applicantType,
          seniorGraduating: formData.value.applicantType === 'senior_high_graduating' ? formData.value.seniorGraduating : null,
          seniorGraduate: formData.value.applicantType === 'senior_high_graduate' ? formData.value.seniorGraduate : null,
          college: formData.value.applicantType === 'college' ? formData.value.college : null,
          programName: props.program?.name,
          programId: props.program?.id,
          preferredDate: formData.value.preferredDate,
          timeSlot: formData.value.timeSlot,
          serverModel: applicationData
        });

        ApplicationFormStore.setHasSubmittedData(true);
        
        const emitData = {
          fullName: `${formData.value.lastName}, ${formData.value.firstName} ${formData.value.middleName}`,
          contactNumber: formData.value.contactNumber,
          email: formData.value.email,
          preferredDate: formData.value.preferredDate,
          timeSlot: formData.value.timeSlot,
          birthMonth: formData.value.birthMonth,
          birthDay: formData.value.birthDay,
          birthYear: formData.value.birthYear,
          gender: formData.value.gender,
          age: formData.value.age,
          homeAddress: homeAddressString, // Combined address
          streetPurok: formData.value.streetPurok, // Added
          barangay: formData.value.barangay,    // Added
          city: formData.value.city,            // Added
          citizenship: formData.value.citizenship,
          highSchoolCode: formData.value.highSchoolCode,
          applicantType: formData.value.applicantType,
          wmsucetExperience: formData.value.wmsucetExperience,
          seniorGraduating: formData.value.applicantType === 'senior_high_graduating' ? formData.value.seniorGraduating : null,
          seniorGraduate: formData.value.applicantType === 'senior_high_graduate' ? formData.value.seniorGraduate : null,
          college: formData.value.applicantType === 'college' ? formData.value.college : null,
          serverModel: applicationData
        };
        
        emit('submit', emitData);
        close();
      } catch (error) {
        console.error('Error during form submission:', error);
        alert('An error occurred while submitting the form. Please try again.');
      }
    };
    
    // Close modal
    const close = () => {
      emit('update:modelValue', false);
    };
    
    // Add a new method to close the calendar with a delay
    const closeCalendarWithDelay = () => {
      setTimeout(() => {
        showCalendar.value = false;
      }, 500); // Delay to give user feedback that their selection was made
    };
    
    // Define the date range - from today to 6 months ahead
    const today = new Date();
    const endDate = new Date(today);
    endDate.setMonth(today.getMonth() + 6); // Look 6 months ahead
    
    const calculateAndSetAge = () => {
      const { birthMonth, birthDay, birthYear } = formData.value;
      if (birthMonth && birthDay && birthYear) {
        const today = new Date();
        const birthDate = new Date(parseInt(birthYear), parseInt(birthMonth) - 1, parseInt(birthDay));
        
        if (isNaN(birthDate.getTime())) { // Check for invalid date object
          formData.value.age = ''; // Clear age if date is invalid
          validationErrors.value.age = 'Invalid birth date entered.';
          return;
        }

        let age = today.getFullYear() - birthDate.getFullYear();
        const monthDiff = today.getMonth() - birthDate.getMonth();
        if (monthDiff < 0 || (monthDiff === 0 && today.getDate() < birthDate.getDate())) {
          age--;
        }
        formData.value.age = age >= 0 ? String(age) : '';
        validateAge(); // Validate the calculated age
      } else {
        formData.value.age = ''; // Clear age if any part of birth date is missing
      }
    };

    const nextStep = () => {
      if (validateCurrentStep()) {
        if (currentStep.value < 5) {
          currentStep.value++;
        }
      }
    };

    const prevStep = () => {
      if (currentStep.value > 1) {
        currentStep.value--;
      }
    };

    // Check if user already has an appointment for this program
    const checkDuplicateRegistration = () => {
      if (!props.program?.id) return true; // No program selected, no need to validate
      
      // Check if the user already has an appointment for this program
      const programId = props.program.id;
      const hasExistingAppointment = userAppointments.value.some(appointment => {
        // Check if appointment is for the current program and not cancelled or claimed
        return (
          appointment.program === programId && 
          appointment.status !== 'cancelled' &&
          appointment.status !== 'claimed'
        );
      });
      
      if (hasExistingAppointment) {
        error.value = `duplicate_registration`;
        return false;
      }
      
      // Clear any duplicate registration error if there's no conflict
      if (error.value === 'duplicate_registration') {
        error.value = null;
      }
      
      return true;
    };

    const validateCurrentStep = () => {
      let isValid = true;
      // Mark relevant fields as touched for current step
      if (currentStep.value === 1) {
        // First check if the user already has an appointment for this program
        if (!checkDuplicateRegistration()) {
          return false;
        }
        
        touchedFields.value.lastName = true;
        touchedFields.value.firstName = true;
        touchedFields.value.middleName = true; // Mark as touched even if optional
        touchedFields.value.contactNumber = true;
        touchedFields.value.email = true;
        touchedFields.value.birthMonth = true;
        touchedFields.value.birthDay = true;
        touchedFields.value.birthYear = true;
        touchedFields.value.gender = true;
        touchedFields.value.streetPurok = true;
        touchedFields.value.barangay = true;
        touchedFields.value.city = true;
        touchedFields.value.citizenship = true;

        // Calculate age first if birth date fields are filled
        if (formData.value.birthMonth && formData.value.birthDay && formData.value.birthYear) {
          calculateAndSetAge();
        }

        // Calculate age first if birth date fields are filled
        if (formData.value.birthMonth && formData.value.birthDay && formData.value.birthYear) {
          calculateAndSetAge();
        }

        // Validate all Step 1 fields
        const lastNameValid = validateLastName();
        const firstNameValid = validateFirstName();
        const middleNameValid = validateMiddleName();
        const contactValid = validateContactNumber();
        const emailValid = validateEmail();
        const birthDateValid = validateBirthDate();
        const ageValid = validateAge();
        const genderValid = validateGender();
        const streetValid = validateStreetPurok();
        const barangayValid = validateBarangay();
        const cityValid = validateCity();
        const citizenshipValid = validateCitizenship();

        isValid = lastNameValid &&
                  firstNameValid &&
                  middleNameValid &&
                  contactValid &&
                  emailValid &&
                  birthDateValid &&
                  ageValid &&
                  genderValid &&
                  streetValid &&
                  barangayValid &&
                  cityValid &&
                  citizenshipValid;

        // Debug logging to help identify which field is failing
        if (!isValid) {
          console.log('Step 1 validation failed. Field validation results:', {
            lastNameValid,
            firstNameValid,
            middleNameValid,
            contactValid,
            emailValid,
            birthDateValid,
            ageValid,
            genderValid,
            streetValid,
            barangayValid,
            cityValid,
            citizenshipValid
          });
          console.log('Current form data:', {
            lastName: formData.value.lastName,
            firstName: formData.value.firstName,
            middleName: formData.value.middleName,
            contactNumber: formData.value.contactNumber,
            email: formData.value.email,
            birthMonth: formData.value.birthMonth,
            birthDay: formData.value.birthDay,
            birthYear: formData.value.birthYear,
            age: formData.value.age,
            gender: formData.value.gender,
            streetPurok: formData.value.streetPurok,
            barangay: formData.value.barangay,
            city: formData.value.city,
            citizenship: formData.value.citizenship
          });
          console.log('Validation errors:', validationErrors.value);
        }
      } else if (currentStep.value === 2) {
        touchedFields.value.applicantType = true; // Assuming this covers all applicant type interactions
        // Mark WMSUCET experience fields as touched if necessary
        isValid = validateWmsucetExperience() && validateApplicantType();
      } else if (currentStep.value === 3) {
        // Validate the new fields for course choices and socio-economic data
        isValid = validateCourseChoicesAndSocioEconomic();
      } else if (currentStep.value === 4) {
        // Step 4 is the review step - no additional validation needed since all data has been validated in previous steps
        isValid = true;
      } else if (currentStep.value === 5) {
        touchedFields.value.preferredDate = true;
        touchedFields.value.timeSlot = true;
        isValid = validateDateTime();
      }

      if (!isValid) {
        // Find the first field with an error and scroll to it
        const firstErrorElement = document.querySelector('.error-text:not(:empty)');
        if (firstErrorElement) {
          firstErrorElement.scrollIntoView({ behavior: 'smooth', block: 'center' });
        }
        
        // Use the toast composable for notifications
        const { showToast } = useToast();
        
        // Customize message based on the error type
        let notificationMessage = 'Please complete all required fields for this step.';
        let notificationType = 'error';
        
        // Check if it's a duplicate registration error
        if (error.value === 'duplicate_registration') {
          notificationMessage = `Registration Not Allowed: You already have an existing appointment for ${props.program?.name || 'this program'}. Each student can only register once per exam program.`;
          // Use 'warning' type for the duplicate registration to make it stand out differently
          notificationType = 'warning';
        }
        
        showToast(notificationMessage, notificationType, 6000);
      }
      return isValid;
    };
    
    // Safe access computed properties to prevent undefined errors
    const safeFormData = computed(() => {
      return {
        ...formData.value,
        courseChoices: formData.value?.courseChoices || {
          firstChoice: '',
          firstChoiceCampus: '',
          secondChoice: '',
          secondChoiceCampus: '',
          thirdChoice: '',
          thirdChoiceCampus: ''
        },
        socioEconomic: formData.value?.socioEconomic || {
          father: {
            citizenship: '',
            education: '',
            occupation: '',
            employer: '',
            income: ''
          },
          mother: {
            citizenship: '',
            education: '',
            occupation: '',
            employer: '',
            income: ''
          }
        },
        additionalInfo: formData.value?.additionalInfo || {
          hasDisability: false,
          disabilityDescription: '',
          knowsComputer: false,
          isIndigenous: false,
          indigenousGroup: '',
          religion: '',
          religionOthers: ''
        }
      }
    });

    // Clear notification function
    const clearNotification = () => {
      showNotification.value = false;
      notificationMessage.value = '';
      notificationType.value = 'info';
    };

    // Return all reactive references and functions for the template
    return {
      // Data refs
      formData,
      currentStep,
      totalSteps,
      validationErrors,
      isSubmitting,
      showNotification,
      notificationMessage,
      notificationType,
      locationData,
      addressSuggestions,
      philippineBarangays,
      philippineCities,
      citizenshipOptions,
      zamboanganSchools,
      campusOptions,
      wmsucourses,
      educationalAttainmentOptions,
      occupationOptions,
      loading,
      error,
      apiData,
      testSessions,
      testCenters,
      testRooms,
      loadingTestCenters,
      showCalendar,
      dateError,
      userAppointments,
      touchedFields,
      
      // Functions for form handling
      markAsTouched,
      isFieldValid,
      isFieldInvalid,
      getInputClasses,
      handleTextInput,
      handleAddressInput,
      searchAddresses,
      selectAddressSuggestion,
      showAddressSuggestions,
      hideAddressSuggestions,
      onLocationChange,
      
      // Validation functions
      validateLastName,
      validateFirstName,
      validateMiddleName,
      validateContactNumber,
      validateEmail,
      validateBirthDate,
      validateAge,
      validateGender,
      validateStreetPurok,
      validateBarangay,
      validateCity,
      validateCitizenship,
      validateWmsucetExperience,
      validateApplicantType,
      validateCourseChoicesAndSocioEconomic,
      validateDateTime,
      validateCurrentStep,
      
      // Computed properties
      birthYears,
      isFormValid,
      isMorningAvailable,
      isAfternoonAvailable,
      safeFormData,
      
      // Navigation functions
      nextStep,
      prevStep,
      
      // Form submission
      submitForm,
      close,
      
      // Date and time functions
      formatDate,
      selectTimeSlot,
      selectTestCenter,
      closeCalendarWithDelay,
      calculateAndSetAge,
      
      // Test center functions
      fetchTestCenters,
      fetchTestRooms,
      getRoomsForCenter,
      
      // Utility functions
      checkDuplicateRegistration,
      clearNotification,
      fetchData,
      fetchTestSessions,
      fetchUserAppointments,
      formatDateForApi
    };
  }
}
</script>

<style scoped>
/* Fade animation for backdrop */
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.3s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}

/* Modal animation */
.modal-enter-active,
.modal-leave-active {
  transition: all 0.3s ease;
}

.modal-enter-from,
.modal-leave-to {
  opacity: 0;
  transform: translateY(-30px);
}

.modal-enter-to,
.modal-leave-from {
  opacity: 1;
  transform: translateY(0);
}

/* Notification animation */
@keyframes fade-in {
  from { opacity: 0; transform: translateY(-20px); }
  to { opacity: 1; transform: translateY(0); }
}

.animate-fade-in {
  animation: fade-in 0.3s ease forwards;
}

/* Scrollbar styling */
.overflow-y-auto {
  scrollbar-width: thin;
  scrollbar-color: #E4E4E7 #ffffff;
}

.overflow-y-auto::-webkit-scrollbar {
  width: 6px;
}

.overflow-y-auto::-webkit-scrollbar-track {
  background: #ffffff;
}

.overflow-y-auto::-webkit-scrollbar-thumb {
  background-color: #E4E4E7;
  border-radius: 3px;
}

/* Radio button styling */
.form-radio {
  @apply border-gray-300;
}

.form-radio:checked {
  background-image: url("data:image/svg+xml,%3csvg viewBox='0 0 16 16' fill='white' xmlns='http://www.w3.org/2000/svg'%3e%3ccircle cx='8' cy='8' r='3'/%3e%3c/svg%3e");
}

/* Calendar container */
.calendar-container {
  @apply bg-white rounded-lg shadow-lg border border-gray-200;
  @apply p-4 max-h-[500px] overflow-y-auto;
}

/* Form Sections */
.section-card {
  @apply bg-white rounded-lg shadow-sm border border-gray-200 p-6 mb-6;
  @apply hover:shadow-md;
  transition: all 0.25s ease-in-out;
}

.section-title {
  @apply text-lg font-semibold text-crimson-700 mb-4 pb-2 border-b border-gray-200;
}

/* Form Groups */
.form-group {
  @apply space-y-1;
}

/* Form Controls */
input[type="text"],
input[type="email"],
input[type="tel"],
input[type="number"],
textarea {
  @apply w-full px-4 py-2.5 border rounded-lg;
  transition: all 0.2s ease;
}

select {
  transition: all 0.2s ease;
}

.select-control {
  @apply w-full px-3 py-2.5 border border-gray-300 rounded-lg;
  @apply appearance-none bg-white;
  @apply focus:ring-2 focus:ring-crimson-500 focus:border-crimson-500;
  @apply pr-8;
  background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 20 20'%3e%3cpath stroke='%236b7280' stroke-linecap='round' stroke-linejoin='round' stroke-width='1.5' d='M6 8l4 4 4-4'/%3e%3c/svg%3e");
  background-position: right 0.5rem center;
  background-repeat: no-repeat;
  background-size: 1.5em 1.5em;
}

input[type="radio"],
input[type="checkbox"] {
  @apply w-4 h-4 text-crimson-600 border-gray-300 focus:ring-crimson-500;
}

/* Date picker field */
.date-picker-field {
  @apply w-full px-4 py-2.5 border border-gray-300 rounded-lg text-base cursor-pointer;
  @apply flex justify-between items-center;
  @apply focus:ring-2 focus:ring-crimson-500 focus:border-crimson-500;
  transition: all 0.2s ease;
}

/* Time slot buttons */
.time-slot-btn {
  @apply px-4 py-2.5 rounded-md text-sm;
  @apply flex items-center border;
  transition: all 0.25s ease;
}

.time-slot-btn-active {
  @apply bg-crimson-600 text-white border-crimson-600;
}

.time-slot-btn-inactive {
  @apply bg-white text-gray-700 border-gray-300;
}

/* Labels */
label {
  @apply block text-sm font-medium text-gray-700 mb-1.5;
}

/* Buttons */
.btn {
  @apply px-4 py-2.5 rounded-lg font-medium;
  @apply flex items-center justify-center;
  transition: all 0.25s ease;
}

.btn-primary {
  @apply bg-crimson-600 text-white hover:bg-crimson-700 focus:ring-2 focus:ring-crimson-500 focus:ring-offset-2;
  @apply shadow-sm hover:shadow;
}

.btn-secondary {
  @apply border border-gray-300 text-gray-700 hover:bg-gray-50 focus:ring-2 focus:ring-gray-500 focus:ring-offset-2;
}

/* Text styles */
.error-text {
  @apply text-red-500 text-sm mt-1;
  animation: fadeIn 0.3s ease-in-out;
}

@keyframes fadeIn {
  from { opacity: 0; transform: translateY(-5px); }
  to { opacity: 1; transform: translateY(0); }
}

.info-text {
  @apply text-xs text-gray-500 mt-1.5;
}

/* Loading Spinner */
.spinner {
  @apply animate-spin rounded-full border-4 border-gray-300;
  @apply border-t-crimson-600 h-12 w-12;
}

/* Responsive Design */
@media (max-width: 640px) {
  .section-card {
    @apply p-4;
  }
}

/* Custom Scrollbar */
::-webkit-scrollbar {
  width: 6px;
}

::-webkit-scrollbar-track {
  @apply bg-gray-100 rounded-full;
}

::-webkit-scrollbar-thumb {
  @apply bg-gray-400 rounded-full;
}

::-webkit-scrollbar-thumb:hover {
  @apply bg-gray-500;
}

/* Improve input focus effects */
input:focus, select:focus, textarea:focus {
  @apply outline-none ring-2 ring-opacity-50;
  transition: all 0.2s ease;
}

/* Add subtle animation to the progress steps */
.flex flex-col items-center {
  transition: all 0.3s ease;
}

.flex flex-col items-center:hover {
  @apply transform scale-105;
}

/* WMSU colors and branding */
.wmsu-accent {
  @apply text-crimson-700;
}

.wmsu-bg {
  @apply bg-crimson-700;
}

/* Date input styling */
.date-input {
  @apply w-full px-4 py-2.5 border border-gray-300 rounded-lg;
  @apply focus:ring-2 focus:ring-crimson-500 focus:border-crimson-500;
  @apply bg-white text-gray-900;
  transition: all 0.2s ease;
}

/* Validation Styling */
.input-valid {
  @apply border-green-500 focus:border-green-500 focus:ring-green-500;
}

.input-invalid {
  @apply border-red-500 focus:border-red-500 focus:ring-red-500;
}

.valid-icon {
  opacity: 0;
  transform: scale(0.8);
  transition: all 0.3s ease;
}

.valid-icon-visible {
  opacity: 1;
  transform: scale(1);
}

/* Check icon animation */
.fa-check-circle {
  animation: scaleIn 0.2s ease-in-out;
}

@keyframes scaleIn {
  from { transform: scale(0); }
  to { transform: scale(1); }
}

/* Error message animation */
.error-text {
  overflow: hidden;
  max-height: 0;
  transition: max-height 0.3s ease, opacity 0.3s ease, margin 0.3s ease;
  opacity: 0;
  margin-top: 0;
}

.error-text-visible {
  max-height: 50px;
  opacity: 1;
  margin-top: 0.25rem;
}

/* Form field transitions */
input, select, textarea {
  transition: border-color 0.2s ease, box-shadow 0.2s ease, background-color 0.2s ease;
}

/* Tooltip styles */
.tooltip {
  position: relative;
  display: inline-block;
}

.tooltip .tooltip-text {
  visibility: hidden;
  width: 200px;
  background-color: #333;
  color: #fff;
  text-align: center;
  border-radius: 6px;
  padding: 5px;
  position: absolute;
  z-index: 1;
  bottom: 125%;
  left: 50%;
  margin-left: -100px;
  opacity: 0;
  transition: opacity 0.3s;
}

.tooltip:hover .tooltip-text {
  visibility: visible;
  opacity: 1;
}

.tooltip .tooltip-text::after {
  content: "";
  position: absolute;
  top: 100%;
  left: 50%;
  margin-left: -5px;
  border-width: 5px;
  border-style: solid;
  border-color: #333 transparent transparent transparent;
}

/* Add a transition for step changes */
.step-content-enter-active,
.step-content-leave-active {
  transition: opacity 0.5s ease, transform 0.5s ease;
}
.step-content-enter-from {
  opacity: 0;
  transform: translateX(30px); /* Enter from right */
}
.step-content-leave-to {
  opacity: 0;
  transform: translateX(-30px); /* Leave to left */
}

/* Ensure notification appears above modal content */
.fixed.top-4.right-4.z-50 {
  z-index: 1050; /* Higher than modal's z-index if modal is 50 */
}
</style>
