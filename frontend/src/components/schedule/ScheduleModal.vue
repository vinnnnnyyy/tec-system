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
          currentStep === 3 ? 'max-w-sm md:max-w-5xl lg:max-w-6xl xl:max-w-7xl max-h-[95vh]' : 'max-w-sm md:max-w-4xl lg:max-w-5xl max-h-[92vh]'
        ]">
          <div class="flex justify-between items-center mb-6">
            <h3 class="text-xl md:text-2xl font-bold text-gray-900 flex items-center gap-3">
              <div class="w-10 h-10 rounded-lg bg-crimson-100 flex items-center justify-center">
                <i class="fas fa-calendar-alt text-xl text-crimson-600"></i>
              </div>
              {{ program?.name || 'Schedule an Appointment' }} - Step {{ currentStep }} of 3
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

                      <!-- Barangay -->
                      <div class="space-y-2">
                        <label for="barangay" class="block text-sm font-medium text-gray-700 mb-1.5">Barangay</label>
                        <div class="relative">
                          <input 
                            id="barangay"
                            v-model="formData.barangay"
                            @input="handleTextInput('barangay')"
                            @blur="markAsTouched('barangay'); validateBarangay()"
                            type="text"
                            list="barangay-list"
                            :class="['w-full px-4 py-2.5 border rounded-lg text-base transition-all shadow-sm focus:ring-2 focus:ring-offset-0', getInputClasses('barangay')]"
                            placeholder="Enter your Barangay"
                            autocomplete="off"
                          />
                          <div v-if="isFieldValid('barangay')" class="absolute inset-y-0 right-3 flex items-center text-green-500 animate-fadeIn">
                            <i class="fas fa-check-circle"></i>
                          </div>
                        </div>
                        <datalist id="barangay-list">
                          <option v-for="barangay in philippineBarangays" :key="barangay" :value="barangay">{{ barangay }}</option>
                        </datalist>
                        <p v-if="isFieldInvalid('barangay')" class="text-sm text-red-600 mt-1 error-text">
                          {{ validationErrors.barangay }}
                        </p>
                      </div>

                      <!-- City -->
                      <div class="space-y-2">
                        <label for="city" class="block text-sm font-medium text-gray-700 mb-1.5">City/Municipality</label>
                        <div class="relative">
                          <input 
                            id="city"
                            v-model="formData.city"
                            @input="handleTextInput('city')"
                            @blur="markAsTouched('city'); validateCity()"
                            type="text"
                            list="city-list"
                            :class="['w-full px-4 py-2.5 border rounded-lg text-base transition-all shadow-sm focus:ring-2 focus:ring-offset-0', getInputClasses('city')]"
                            placeholder="Enter your City/Municipality"
                            autocomplete="off"
                          />
                          <div v-if="isFieldValid('city')" class="absolute inset-y-0 right-3 flex items-center text-green-500 animate-fadeIn">
                            <i class="fas fa-check-circle"></i>
                          </div>
                        </div>
                        <datalist id="city-list">
                          <option v-for="city in philippineCities" :key="city" :value="city">{{ city }}</option>
                        </datalist>
                        <p v-if="isFieldInvalid('city')" class="text-sm text-red-600 mt-1 error-text">
                          {{ validationErrors.city }}
                        </p>
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
                              />
                            </div>
                          </div>
                          
                          <div class="space-y-2">
                            <label for="seniorGraduatingSchoolAddress" class="block text-sm font-medium text-gray-700">School Address</label>
                            <div class="relative">
                              <input 
                                id="seniorGraduatingSchoolAddress"
                                v-model="formData.seniorGraduating.schoolAddress"
                                @input="handleTextInput('seniorGraduatingSchoolAddress', 'seniorGraduating.schoolAddress')"
                                @blur="validateApplicantType()"
                                type="text"
                                class="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500/50 focus:border-crimson-500 text-base transition-all shadow-sm"
                                placeholder="Enter your school address"
                              />
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
                              />
                            </div>
                          </div>
                          
                          <div class="space-y-2">
                            <label for="seniorGraduateSchoolAddress" class="block text-sm font-medium text-gray-700">School Address</label>
                            <div class="relative">
                              <input 
                                id="seniorGraduateSchoolAddress"
                                v-model="formData.seniorGraduate.schoolAddress"
                                @input="handleTextInput('seniorGraduateSchoolAddress', 'seniorGraduate.schoolAddress')"
                                @blur="validateApplicantType()"
                                type="text"
                                class="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500/50 focus:border-crimson-500 text-base transition-all shadow-sm"
                                placeholder="Enter your school address"
                              />
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
                              />
                            </div>
                          </div>
                          
                          <div class="space-y-2">
                            <label for="collegeSchoolAddress" class="block text-sm font-medium text-gray-700">School Address</label>
                            <div class="relative">
                              <input 
                                id="collegeSchoolAddress"
                                v-model="formData.college.schoolAddress"
                                @input="handleTextInput('collegeSchoolAddress', 'college.schoolAddress')"
                                @blur="validateApplicantType()"
                                type="text"
                                class="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500/50 focus:border-crimson-500 text-base transition-all shadow-sm"
                                placeholder="Enter your college/university address"
                              />
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

                <!-- STEP 3: Schedule Details Section (Spans 2 columns on LG) -->
                <div v-if="currentStep === 3" class="lg:col-span-2">
                  <div class="space-y-6 bg-white rounded-xl p-6 md:p-8 border border-gray-200 shadow-sm">
                    <div class="flex items-center gap-3 text-lg font-semibold text-gray-900 mb-4 pb-3 border-b border-gray-200">
                      <div class="w-8 h-8 rounded-lg bg-crimson-100 flex items-center justify-center">
                        <i class="fas fa-calendar-alt text-crimson-500"></i>
                      </div>
                      <h4>Schedule Details</h4>
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
                  v-if="currentStep < 3"
                  @click="nextStep"
                  class="flex-1 bg-crimson-500 text-white px-6 py-3 rounded-lg hover:bg-crimson-600 transition-all text-base font-medium flex items-center justify-center gap-2 order-3 sm:order-none sm:ml-auto"
                >
                  Next
                  <i class="fas fa-arrow-right"></i>
                </button>
                
                <button 
                  type="submit"
                  v-if="currentStep === 3"
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
import { ref, computed, watch, onMounted, onUnmounted } from 'vue'
import ApplicationFormStore from '../../services/ApplicationFormStore'
import AuthService from '../../services/auth.service'

export default {
  name: 'ScheduleModal',
  components: {
    CustomCalendar
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
    const showCalendar = ref(false);
    const dateError = ref('');
    const currentStep = ref(1); // To manage the current step of the form

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
      preferredDate: false
    });
    
    const formData = ref({
      preferredDate: '',
      timeSlot: '',
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
      }
    });
    
    // Philippine Barangays (Common barangays across different cities/municipalities)
    const philippineBarangays = ref([
      'Poblacion', 'San Jose', 'San Antonio', 'San Juan', 'Santa Maria', 'Santo Niño', 'Barangay 1', 'Barangay 2', 
      'Barangay 3', 'Barangay 4', 'Barangay 5', 'Barangay 6', 'Barangay 7', 'Barangay 8', 'Barangay 9', 'Barangay 10',
      'Bagong Silang', 'Bagong Pag-asa', 'Bagong Buhay', 'Malate', 'Ermita', 'Intramuros', 'Binondo', 'Quiapo',
      'Sampaloc', 'Santa Cruz', 'San Miguel', 'Tondo', 'San Nicolas', 'Manila', 'Makati', 'Mandaluyong', 'Marikina',
      'Pasig', 'Quezon City', 'Caloocan', 'Malabon', 'Navotas', 'Valenzuela', 'Las Piñas', 'Makati', 'Muntinlupa',
      'Parañaque', 'Pasay', 'Pateros', 'Taguig', 'Antipolo', 'Bacoor', 'Biñan', 'Cabuyao', 'Calamba', 'Carmona',
      'Dasmariñas', 'General Trias', 'Imus', 'Kawit', 'Laguna', 'Lipa', 'Los Baños', 'Lucena', 'Majayjay', 'Naic',
      'Noveleta', 'Rosario', 'San Pablo', 'Santa Rosa', 'Silang', 'Tagaytay', 'Talisay', 'Tanauan', 'Trece Martires',
      'Alicia', 'Angono', 'Baras', 'Binangonan', 'Cainta', 'Cardona', 'Jalajala', 'Morong', 'Pililla', 'Rodriguez',
      'San Mateo', 'Tanay', 'Teresa', 'Taytay', 'Barangka', 'Bayan-Bayanan', 'Concepcion', 'Dagat-Dagatan', 'Longos',
      'Maysilo', 'Panghulo', 'Potrero', 'Sangandaan', 'Tonsuya', 'Tubigan', 'Bagbaguin', 'Bagong Barrio', 'Bignay',
      'Bisig', 'Canumay East', 'Canumay West', 'Coloong', 'Dalandanan', 'Gen. T. de Leon', 'Isla', 'Karuhatan',
      'Lawang Bato', 'Lingunan', 'Mabolo', 'Malanday', 'Malinta', 'Mapulang Lupa', 'Marulas', 'Maysan', 'Palasan',
      'Parada', 'Pariancillo Villa', 'Paso de Blas', 'Poblacion', 'Polo', 'Punturin', 'Rincon', 'Tagalag', 'Ugong',
      'Viente Reales', 'Wawang Pulo', 'Arkong Bato', 'Bagbag', 'Balangkas', 'Bignay', 'Canumay', 'Catmon', 'Coloong',
      'Dalandanan', 'Fish Port', 'Hulong Duhat', 'Isla', 'Longos', 'Maysilo', 'Muzon', 'Panghulo', 'Poblacion',
      'Potrero', 'Rincon', 'Sangandaan', 'Tonsuya', 'Tanza', 'Tubigan', 'Ugong Norte', 'Ugong Sur',
      
      // Region 9 (Zamboanga Peninsula) - Comprehensive barangay list
      // Zamboanga City barangays
      'Ayala', 'Baliwasan', 'Boalan', 'Bolong', 'Buenavista', 'Bunguiao', 'Busay', 'Cabaluay', 'Cabatangan', 'Cacao',
      'Calabasa', 'Calarian', 'Camino Nuevo', 'Campo Islam', 'Canelar', 'Capisan', 'Caputian', 'Cawit', 'Culianan',
      'Curuan', 'Divisoria', 'Dulian', 'Guisao', 'Guiwan', 'La Paz', 'Labuan', 'Lamisahan', 'Landang Gua', 'Landang Laum',
      'Lapakan', 'Latuan', 'Limaong', 'Limpapa', 'Lubigan', 'Lumayang', 'Lunzuran', 'Maasin', 'Malagutay', 'Manicahan',
      'Mariki', 'Mercedes', 'Muti', 'Pamucutan', 'Pangapuyan', 'Pasonanca', 'Patalon', 'Putik', 'Quiniput', 'Rio Hondo',
      'Salaan', 'San Jose Cawa', 'San Jose Gusu', 'San Roque', 'Sangali', 'Santa Barbara', 'Santa Catalina', 'Santa Maria',
      'Sinubung', 'Sinunoc', 'Suterville', 'Tagasilay', 'Taguiti', 'Talabaan', 'Taluksangay', 'Talon-Talon', 'Tictapul',
      'Tigbalabag', 'Tolosa', 'Tumaga', 'Tumitus', 'Victoria', 'Vitali', 'Yakan Village', 'Zambowood',
      
      // Pagadian City barangays
      'Balangasan', 'Balintawak', 'Banale', 'Banga', 'Bomba', 'Bogo', 'Bulatok', 'Canaway', 'Danlugan', 'Datagan',
      'Gatas', 'Gubac', 'Kagawasan', 'Kawit', 'Lacanan', 'Lala', 'Lenienza', 'Lizon Valley', 'Lower Sibatang',
      'Macasing', 'Muricay', 'Napolan', 'Palpalan', 'San Francisco', 'San Pedro', 'Santiago', 'Santo Niño', 'Tiguma',
      'Tuyoron', 'Upper Sibatang', 'White Beach',
      
      // Dipolog City barangays
      'Barra', 'Biasong', 'Central', 'Cogon', 'Dicayas', 'Diwan', 'Estaka', 'Galas', 'Gulayon', 'Lugdungan',
      'Miputak', 'Napo', 'Olingan', 'Pag-asa', 'Pangabuan', 'Santa Isabel', 'Sicayab', 'Sinaman', 'Sta. Filomena',
      'Turno', 'Unhawan',
      
      // Dapitan City barangays
      'Aliguay', 'Ba-ao', 'Bagacay', 'Bagting', 'Barcelona', 'Baylimango', 'Burgos', 'Carang', 'Cawa-Cawa',
      'Dawo', 'Dapitan', 'Derilon', 'Liboron', 'Masidlakon', 'Opao', 'Polo', 'Potol', 'San Nicolas', 'San Pedro',
      'San Vicente', 'Santa Cruz', 'Siayan', 'Sulangon', 'Talisay', 'Tomasa', 'Tulawan', 'Vila',
      
      // Isabela City barangays
      'Baluno', 'Binuangan', 'Cabunbata', 'Calvario', 'Isabela Proper', 'Kaumpurnah', 'Kumalarang', 'Lampinigan',
      'Lukbuton', 'Malamawi', 'Maluso', 'Marang-Marang', 'Menzi', 'Panigayan', 'Santa Barbara', 'Small Kalamansig',
      'Sumagdang', 'Tabuk', 'Tabiawan', 'Tampalan'
    ].sort());
    
    // Philippine Cities and Municipalities (Major cities and municipalities)
    const philippineCities = ref([
      // National Capital Region (NCR)
      'Manila', 'Quezon City', 'Makati', 'Pasig', 'Taguig', 'Marikina', 'Mandaluyong', 'San Juan', 'Muntinlupa',
      'Las Piñas', 'Parañaque', 'Pasay', 'Caloocan', 'Malabon', 'Navotas', 'Valenzuela', 'Pateros',

      // Region I (Ilocos Region)
      'Dagupan', 'San Carlos', 'Alaminos', 'Urdaneta', 'Laoag', 'Batac', 'Candon', 'Vigan', 'Agoo', 'Bauang',
      'Naguilian', 'San Fernando', 'San Juan', 'Alaminos', 'Bolinao', 'Bugallon', 'Calasiao', 'Dasol', 'Infanta',
      'Labrador', 'Lingayen', 'Mabini', 'Malasiqui', 'Manaoag', 'Mangaldan', 'Mangatarem', 'Mapandan', 'Natividad',
      
      // Region II (Cagayan Valley)
      'Tuguegarao', 'Cauayan', 'Ilagan', 'Santiago', 'Tabuk', 'Lamut', 'Bayombong', 'Solano',
      
      // Region III (Central Luzon)
      'San Jose del Monte', 'Malolos', 'Meycauayan', 'Marilao', 'Bocaue', 'Balagtas', 'Guiguinto', 'Hagonoy',
      'Paombong', 'Pulilan', 'Calumpit', 'Plaridel', 'San Rafael', 'Angat', 'Bustos', 'San Ildefonso', 'San Miguel',
      'Doña Remedios Trinidad', 'Norzagaray', 'Santa Maria', 'Pandi', 'Obando', 'Bulakan', 'San Jose', 'Balanga',
      'Dinalupihan', 'Hermosa', 'Limay', 'Mariveles', 'Morong', 'Orani', 'Orion', 'Pilar', 'Samal', 'Bagac',
      'Abucay', 'Olongapo', 'Subic', 'Castillejos', 'San Antonio', 'San Felipe', 'San Marcelino', 'San Narciso',
      'Botolan', 'Cabangan', 'Candelaria', 'Iba', 'Masinloc', 'Palauig', 'Santa Cruz', 'Angeles', 'San Fernando',
      'Mabalacat', 'Porac', 'Floridablanca', 'Guagua', 'Lubao', 'Sasmuan', 'Macabebe', 'Masantol', 'Mexico',
      'Santa Ana', 'Arayat', 'Candaba', 'San Luis', 'San Simon', 'Santo Tomas', 'Bacolor', 'Minalin', 'Cabanatuan',
      'Gapan', 'San Jose', 'Palayan', 'Muñoz', 'Talavera', 'Aliaga', 'Bongabon', 'Cabiao', 'Carranglan', 'Cuyapo',
      'Gabaldon', 'General Mamerto Natividad', 'General Tinio', 'Guimba', 'Jaen', 'Laur', 'Licab', 'Llanera',
      'Lupao', 'Nampicuan', 'Pantabangan', 'Peñaranda', 'Quezon', 'Rizal', 'San Antonio', 'San Isidro', 'San Leonardo',
      'Santa Rosa', 'Santo Domingo', 'Zaragoza', 'Tarlac', 'Concepcion', 'Capas', 'Bamban', 'Camiling', 'Gerona',
      'La Paz', 'Paniqui', 'Moncada', 'San Carlos', 'San Jose', 'Santa Ignacia', 'Victoria', 'Ramos', 'Mayantoc',
      'San Clemente', 'Pura', 'Anao', 'San Manuel',
      
      // Region IV-A (CALABARZON)
      'Antipolo', 'Bacoor', 'Biñan', 'Cabuyao', 'Calamba', 'Carmona', 'Dasmariñas', 'General Trias', 'Imus',
      'Kawit', 'Laguna', 'Lipa', 'Los Baños', 'Lucena', 'Majayjay', 'Naic', 'Noveleta', 'Rosario', 'San Pablo',
      'Santa Rosa', 'Silang', 'Tagaytay', 'Talisay', 'Tanauan', 'Trece Martires', 'Cavite City', 'Tagaytay',
      'Bacoor', 'Imus', 'Dasmariñas', 'Carmona', 'General Trias', 'Trece Martires', 'Cavite City', 'Kawit',
      'Noveleta', 'Rosario', 'Tanza', 'Naic', 'Maragondon', 'Ternate', 'Magallanes', 'Alfonso', 'Amadeo',
      'General Emilio Aguinaldo', 'Indang', 'Mendez', 'Silang', 'Tagaytay', 'Calamba', 'Biñan', 'Santa Rosa',
      'Cabuyao', 'San Pablo', 'Tanauan', 'Lipa', 'Santo Tomas', 'Alaminos', 'Batangas City', 'Lemery', 'Taal',
      'Cuenca', 'Ibaan', 'Taysan', 'Lobo', 'Batangas', 'Bauan', 'San Pascual', 'Tingloy', 'Calatagan', 'Balayan',
      'Calaca', 'Laurel', 'Agoncillo', 'Malvar', 'Mataasnakahoy', 'Padre Garcia', 'Rosario', 'San Jose', 'San Juan',
      'San Luis', 'Santa Teresita', 'Talisay', 'Tuy', 'Nasugbu', 'Lian', 'Calatagan', 'Lemery', 'Taal', 'San Nicolas',
      'Sta. Teresita', 'Mabini', 'Lucena', 'Tayabas', 'Sariaya', 'Candelaria', 'Dolores', 'Tiaong', 'San Antonio',
      'Lucban', 'Sampaloc', 'Padre Burgos', 'Quezon', 'Pagbilao', 'Atimonan', 'Plaridel', 'Gumaca', 'Lopez',
      'Calauag', 'Guinayangan', 'Tagkawayan', 'Buenavista', 'Catanauan', 'General Luna', 'Macalelon', 'Mulanay',
      'San Andres', 'San Francisco', 'San Narciso', 'Unisan', 'Agdangan', 'Alabat', 'Perez', 'Pitogo', 'Cainta',
      'Taytay', 'Angono', 'Binangonan', 'Cardona', 'Morong', 'Baras', 'Tanay', 'Pililla', 'Jalajala', 'Rodriguez',
      'San Mateo', 'Teresa',
      
      // Region IV-B (MIMAROPA)
      'Puerto Princesa', 'Calapan', 'Mamburao', 'Boac', 'Romblon', 'Odiongan',
      
      // Region V (Bicol Region)
      'Naga', 'Iriga', 'Legazpi', 'Ligao', 'Tabaco', 'Masbate', 'Sorsogon', 'Virac',
      
      // Region VI (Western Visayas)
      'Iloilo City', 'Bacolod', 'Roxas', 'Kalibo', 'San Jose de Buenavista', 'Boracay',
      
      // Region VII (Central Visayas)
      'Cebu City', 'Mandaue', 'Lapu-Lapu', 'Talisay', 'Toledo', 'Danao', 'Carcar', 'Bogo', 'Dumaguete', 'Bais',
      'Bayawan', 'Canlaon', 'Guihulngan', 'Tanjay', 'Tagbilaran', 'Ubay',
      
      // Region VIII (Eastern Visayas)
      'Tacloban', 'Ormoc', 'Baybay', 'Maasin', 'Calbayog', 'Catbalogan', 'Borongan',
      
      // Region IX (Zamboanga Peninsula)  
      'Zamboanga City', 'Pagadian', 'Dipolog', 'Dapitan', 'Isabela',
      
      // Region X (Northern Mindanao)
      'Cagayan de Oro', 'Iligan', 'Butuan', 'Malaybalay', 'Valencia', 'Oroquieta', 'Ozamiz', 'Tangub', 'Tubod',
      'Gingoog', 'Balingoan', 'Jasaan', 'Villanueva', 'Tagoloan', 'Laguindingan', 'Gitagum', 'Medina', 'Salay',
      'Binuangan', 'Catarman', 'Guinsiliban', 'Mahinog', 'Mambajao', 'Sagay',
      
      // Region XI (Davao Region)
      'Davao City', 'Tagum', 'Panabo', 'Samal', 'Digos', 'Mati',
      
      // Region XII (SOCCSKSARGEN)
      'General Santos', 'Koronadal', 'Tacurong', 'Kidapawan', 'Cotabato City', 'Surallah',
      
      // Region XIII (Caraga)
      'Butuan', 'Surigao City', 'Tandag', 'Bislig', 'Bayugan',
      
      // Cordillera Administrative Region (CAR)
      'Baguio', 'Tabuk', 'Lamut', 'Bontoc', 'Sagada', 'Mayoyao', 'Lagawe',
      
      // Autonomous Region in Muslim Mindanao (ARMM) - now BARMM
      'Cotabato City', 'Marawi', 'Lamitan', 'Jolo', 'Bongao'
    ].sort());
    
    // Common Citizenships (Philippines and International)
    const citizenshipOptions = ref([
      // Southeast Asian Countries
      'Filipino', 'Philippine', 'Indonesian', 'Malaysian', 'Singaporean', 'Thai', 'Vietnamese', 'Cambodian', 
      'Laotian', 'Bruneian', 'Myanmar', 'Burmese',
      
      // East Asian Countries
      'Chinese', 'Japanese', 'Korean', 'South Korean', 'North Korean', 'Taiwanese', 'Mongolian', 'Hong Kong',
      
      // South Asian Countries  
      'Indian', 'Pakistani', 'Bangladeshi', 'Sri Lankan', 'Nepalese', 'Bhutanese', 'Maldivian', 'Afghan',
      
      // Middle Eastern Countries
      'Saudi Arabian', 'Emirati', 'Qatari', 'Kuwaiti', 'Bahraini', 'Omani', 'Yemeni', 'Jordanian', 'Lebanese',
      'Syrian', 'Iraqi', 'Iranian', 'Turkish', 'Israeli', 'Palestinian',
      
      // European Countries
      'British', 'English', 'Scottish', 'Welsh', 'Irish', 'French', 'German', 'Italian', 'Spanish', 'Portuguese',
      'Dutch', 'Belgian', 'Swiss', 'Austrian', 'Swedish', 'Norwegian', 'Danish', 'Finnish', 'Polish', 'Czech',
      'Slovak', 'Hungarian', 'Romanian', 'Bulgarian', 'Croatian', 'Serbian', 'Bosnian', 'Montenegrin', 'Albanian',
      'Greek', 'Cypriot', 'Maltese', 'Luxembourgish', 'Estonian', 'Latvian', 'Lithuanian', 'Slovenian', 'Ukrainian',
      'Belarusian', 'Moldovan', 'Russian',
      
      // North American Countries
      'American', 'Canadian', 'Mexican', 'Guatemalan', 'Belizean', 'Salvadoran', 'Honduran', 'Nicaraguan',
      'Costa Rican', 'Panamanian',
      
      // South American Countries
      'Brazilian', 'Argentine', 'Chilean', 'Peruvian', 'Colombian', 'Venezuelan', 'Ecuadorian', 'Bolivian',
      'Paraguayan', 'Uruguayan', 'Guyanese', 'Surinamese',
      
      // African Countries
      'South African', 'Egyptian', 'Moroccan', 'Algerian', 'Tunisian', 'Libyan', 'Nigerian', 'Ghanaian',
      'Kenyan', 'Ethiopian', 'Sudanese', 'Ugandan', 'Tanzanian', 'Rwandan', 'Burundian', 'Congolese',
      'Zambian', 'Zimbabwean', 'Botswanan', 'Namibian', 'Malawian', 'Mozambican', 'Madagascan', 'Mauritian',
      'Seychellois', 'Senegalese', 'Malian', 'Burkinabe', 'Ivorian', 'Gabonese', 'Cameroonian', 'Chadian',
      
      // Oceania Countries
      'Australian', 'New Zealand', 'Fijian', 'Samoan', 'Tongan', 'Papua New Guinean', 'Solomon Islander',
      'Vanuatuan', 'Palauan', 'Marshallese', 'Micronesian', 'Nauruan', 'Kiribati', 'Tuvaluan',
      
      // Caribbean Countries
      'Jamaican', 'Cuban', 'Dominican', 'Haitian', 'Puerto Rican', 'Trinidadian', 'Tobagonian', 'Barbadian',
      'Bahamian', 'Antiguan', 'Barbudan', 'Saint Lucian', 'Grenadian', 'Saint Vincentian', 'Grenadine',
      
      // Additional Common Terms
      'Dual Citizen', 'Stateless', 'Refugee', 'Asylum Seeker'
    ].sort());
    
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
    
    // Handle text input with auto-uppercase and real-time validation
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
      
      // Convert to uppercase for name and address fields
      const fieldsToUppercase = [
        'lastName', 'firstName', 'middleName', 
        'streetPurok', 'barangay', 'city', 'citizenship',
        'seniorGraduatingSchoolName', 'seniorGraduatingSchoolAddress',
        'seniorGraduateSchoolName', 'seniorGraduateSchoolAddress',
        'collegeSchoolName', 'collegeSchoolAddress'
      ];
      
      if (fieldsToUppercase.includes(fieldName)) {
        target[finalKey] = currentValue.toUpperCase();
      }
      
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
          // For nested fields like school names/addresses
          if (fieldName.includes('School')) {
            validateApplicantType();
          }
          break;
      }
    };
    
    // Computed property for birth years (100 years back from current year)
    const birthYears = computed(() => {
      const currentYear = new Date().getFullYear();
      return Array.from({ length: 100 }, (_, i) => currentYear - i);
    });
    
    // Computed property for filtered barangays (for better performance)
    const filteredBarangays = computed(() => {
      return philippineBarangays.value;
    });
    
    // Computed property for filtered cities (for better performance)
    const filteredCities = computed(() => {
      return philippineCities.value;
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
        validationErrors.value.middleName = 'Middle name seems too short';
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
      dateError.value = '';
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
    
    // Watch for modal open/close
    watch(() => props.modelValue, (newVal) => {
      if (newVal && props.program?.id) {
        fetchData();
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
          }
        };
        dateError.value = '';
        validationErrors.value = {
          lastName: '',
          firstName: '',
          middleName: '',
          contactNumber: '',
          email: '',
          schoolName: '',
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
      console.log('philippineBarangays length:', philippineBarangays.value.length);
      console.log('philippineCities length:', philippineCities.value.length);
      console.log('citizenshipOptions length:', citizenshipOptions.value.length);
      console.log('First 5 barangays:', philippineBarangays.value.slice(0, 5));
      console.log('First 5 cities:', philippineCities.value.slice(0, 5));
      console.log('First 5 citizenships:', citizenshipOptions.value.slice(0, 5));
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
      
      // Add a slight delay before closing the calendar for better UX
      setTimeout(() => {
        showCalendar.value = false;
      }, 500); // Increased delay for better reliability
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
        const firstErrorElement = document.querySelector('.error-text');
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
      const isStep3Valid = validateDateTime();


      if (!isStep1Valid || !isStep2Valid || !isStep3Valid) {
        // Find the first field with an error and scroll to it
        const firstErrorElement = document.querySelector('.error-text:not(:empty)');
        if (firstErrorElement) {
          firstErrorElement.scrollIntoView({ behavior: 'smooth', block: 'center' });
        }
        
        // Show a notification about missing fields
        const notification = document.createElement('div');
        notification.className = 'fixed top-4 right-4 bg-red-100 border-l-4 border-red-500 text-red-700 p-4 rounded shadow-md z-[100] animate-fade-in'; // Increased z-index
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
          full_name: `${formData.value.lastName}, ${formData.value.firstName} ${formData.value.middleName}`,
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
        if (currentStep.value < 3) {
          currentStep.value++;
        }
      }
    };

    const prevStep = () => {
      if (currentStep.value > 1) {
        currentStep.value--;
      }
    };

    const validateCurrentStep = () => {
      let isValid = true;
      // Mark relevant fields as touched for current step
      if (currentStep.value === 1) {
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

        isValid = validateLastName() &&
                  validateFirstName() &&
                  validateMiddleName() && // Include in validation chain
                  validateContactNumber() &&
                  validateEmail() &&
                  validateBirthDate() &&
                  validateGender() &&
                  validateStreetPurok() &&
                  validateBarangay() &&
                  validateCity() &&
                  validateCitizenship() &&
                  validateAge(); // Also validate age, as it depends on birthdate
      } else if (currentStep.value === 2) {
        touchedFields.value.applicantType = true; // Assuming this covers all applicant type interactions
        // Mark WMSUCET experience fields as touched if necessary
        isValid = validateWmsucetExperience() && validateApplicantType();
      } else if (currentStep.value === 3) {
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
         // Show a notification about missing fields for the current step
        const notification = document.createElement('div');
        notification.className = 'fixed top-4 right-4 bg-red-100 border-l-4 border-red-500 text-red-700 p-4 rounded shadow-md z-[100] animate-fade-in'; // Increased z-index
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
        
        setTimeout(() => {
          if (document.body.contains(notification)) {
            notification.remove();
          }
        }, 5000);
      }
      return isValid;
    };
    
    return {
      loading,
      error,
      apiData,
      formData,
      dateError,
      showCalendar,
      isFormValid,
      isMorningAvailable,
      isAfternoonAvailable,
      validationErrors,
      birthYears,
      philippineBarangays,
      philippineCities,
      citizenshipOptions,
      testSessions,
      filteredBarangays,
      filteredCities,
      fetchData,
      formatDate,
      selectTimeSlot,
      validateForm,
      submitForm,
      close,
      closeCalendarWithDelay,
      markAsTouched,
      touchedFields,
      isFieldValid,
      isFieldInvalid,
      getInputClasses,
      handleTextInput,
      calculateAndSetAge,
      currentStep,
      nextStep,
      prevStep,
      validateCurrentStep,
      // Add all validation functions
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
      validateDateTime
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
