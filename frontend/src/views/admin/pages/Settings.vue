<template>
  <main class="flex-1 overflow-y-auto">
    <!-- Page Header -->
    <header class="bg-white shadow-sm">
      <div class="flex justify-between items-center px-6 py-4">
        <h1 class="text-2xl font-bold text-gray-800">Settings</h1>
        <button @click="saveChanges" class="bg-crimson-600 text-white px-4 py-2 rounded-lg hover:bg-crimson-700 transition-colors flex items-center space-x-2">
          <i class="fas fa-save"></i>
          <span>Save Changes</span>
        </button>
      </div>
    </header>

    <!-- Settings Content -->
    <div class="p-6">
      <!-- Settings Navigation -->
      <div class="bg-white rounded-xl shadow-sm p-4 mb-6 border border-gray-100">
        <nav class="flex flex-wrap gap-2">
          <button 
            v-for="section in sections" 
            :key="section.id"
            @click="switchSection(section.id)"
            :class="[
              'px-4 py-2 rounded-lg text-sm font-medium flex items-center',
              activeSection === section.id 
                ? 'bg-crimson-600 text-white' 
                : 'text-gray-600 hover:bg-crimson-300'
            ]"
          >
            <i :class="[section.icon, 'mr-2']"></i>
            {{ section.name }}
          </button>
        </nav>
      </div>

      <!-- Settings Sections -->
      <div class="space-y-6">
        <!-- General Settings -->
        <div v-show="activeSection === 'general'" class="bg-white rounded-xl shadow-sm border border-gray-100 p-6">
          <h2 class="text-lg font-semibold mb-4">General Settings</h2>
          <div class="space-y-6">
            <!-- Institution Information -->
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Institution Name</label>
                <input 
                  v-model="settings.institutionName"
                  type="text" 
                  class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-crimson-500"
                >
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Contact Email</label>
                <input 
                  v-model="settings.contactEmail"
                  type="email" 
                  class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-crimson-500"
                >
              </div>
            </div>

            <!-- Business Hours -->
            <div class="border-t pt-6">
              <h3 class="text-sm font-medium text-gray-700 mb-4">Business Hours</h3>
              <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                  <label class="block text-xs text-gray-500 mb-1">Opening Time</label>
                  <input 
                    v-model="settings.openingTime"
                    type="time" 
                    class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-crimson-500"
                  >
                </div>
                <div>
                  <label class="block text-xs text-gray-500 mb-1">Closing Time</label>
                  <input 
                    v-model="settings.closingTime"
                    type="time" 
                    class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-crimson-500"
                  >
                </div>
              </div>
            </div>

            <!-- System Preferences -->
            <div class="border-t pt-6">
              <h3 class="text-sm font-medium text-gray-700 mb-4">System Preferences</h3>
              <div class="space-y-4">
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-1">Time Zone</label>
                  <select 
                    v-model="settings.timezone"
                    class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-crimson-500"
                  >
                    <option v-for="tz in timezones" :key="tz.value" :value="tz.value">
                      {{ tz.label }}
                    </option>
                  </select>
                </div>
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-1">Date Format</label>
                  <select 
                    v-model="settings.dateFormat"
                    class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-crimson-500"
                  >
                    <option v-for="format in dateFormats" :key="format.value" :value="format.value">
                      {{ format.label }}
                    </option>
                  </select>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Users Section -->
        <div v-show="activeSection === 'users'" class="bg-white rounded-xl shadow-sm border border-gray-100 p-6">
          <div class="flex justify-between items-center mb-4">
            <h2 class="text-lg font-semibold">Users & Permissions</h2>
            <button @click="openAddUserModal" class="bg-crimson-600 text-white px-4 py-2 rounded-lg hover:bg-crimson-700 transition-colors flex items-center space-x-2">
              <i class="fas fa-plus"></i>
              <span>Add User</span>
            </button>
          </div>

          <!-- Search Bar -->
          <div v-if="users.length > 0" class="mb-6 bg-white p-4 rounded-lg border border-gray-200">
            <div class="relative max-w-md">
              <input 
                v-model="userSearchQuery" 
                type="text" 
                placeholder="Search users by name, email, or role..." 
                class="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-crimson-500"
              >
              <i class="fas fa-search absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400"></i>
              <button 
                v-if="userSearchQuery" 
                @click="userSearchQuery = ''" 
                class="absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-400 hover:text-crimson-600"
              >
                <i class="fas fa-times"></i>
              </button>
            </div>
          </div>
          
          <!-- Users Table -->
          <div class="overflow-x-auto">
            <!-- Loading state -->
            <div v-if="isLoadingUsers" class="flex justify-center py-8">
              <div class="animate-spin rounded-full h-8 w-8 border-b-2 border-crimson-600"></div>
            </div>
            
            <!-- Users table -->
            <table v-else-if="filteredUsers.length > 0" class="w-full">
              <thead class="bg-gray-50">
                <tr>
                  <th v-for="header in userTableHeaders" 
                      :key="header"
                      class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase"
                  >
                    {{ header }}
                  </th>
                </tr>
              </thead>
              <tbody class="divide-y divide-gray-100">
                <tr v-for="user in filteredUsers" :key="user.id">
                  <td class="px-4 py-3">
                    <div class="flex items-center">
                      <div class="w-8 h-8 rounded-full bg-gray-200 flex items-center justify-center mr-3">
                        <i class="fas fa-user text-gray-500"></i>
                      </div>
                      <div>
                        <div class="text-sm font-medium text-gray-900">{{ user.name }}</div>
                        <div class="text-sm text-gray-500">{{ user.email }}</div>
                      </div>
                    </div>
                  </td>
                  <td class="px-4 py-3 text-sm text-gray-500">{{ user.role }}</td>
                  <td class="px-4 py-3">
                    <span :class="getStatusClass(user.status)">
                      {{ user.status }}
                    </span>
                  </td>
                  <td class="px-4 py-3 text-sm text-gray-500">{{ user.lastLogin }}</td>
                  <td class="px-4 py-3">
                    <div class="flex space-x-2">
                      <button @click="editUser(user)" class="text-gray-400 hover:text-crimson-600">
                        <i class="fas fa-edit"></i>
                      </button>
                      <button @click="deleteUser(user.id)" class="text-gray-400 hover:text-crimson-600">
                        <i class="fas fa-trash"></i>
                      </button>
                    </div>
                  </td>
                </tr>
              </tbody>
            </table>
            
            <!-- Empty state -->
            <div v-else class="text-center py-8">
              <div class="text-gray-500">
                <i class="fas fa-users text-4xl mb-2"></i>
                <p class="text-lg" v-if="userSearchQuery">No users found matching "{{ userSearchQuery }}"</p>
                <p class="text-lg" v-else>No users found</p>
                <p class="text-sm" v-if="userSearchQuery">Try adjusting your search criteria</p>
                <p class="text-sm" v-else>Click "Add User" to create the first user</p>
                <button 
                  v-if="userSearchQuery" 
                  @click="userSearchQuery = ''" 
                  class="mt-3 inline-flex items-center px-3 py-1 bg-gray-200 hover:bg-gray-300 text-gray-700 rounded-lg text-sm"
                >
                  <i class="fas fa-times mr-2"></i> Clear Search
                </button>
              </div>
            </div>
          </div>
        </div>

        <!-- Notifications Section -->
        <div v-show="activeSection === 'notifications'" class="bg-white rounded-xl shadow-sm border border-gray-100 p-6">
          <h2 class="text-lg font-semibold mb-6">Notification Settings for Applicants</h2>
          
          <!-- Loading state for notification settings -->
          <div v-if="!notificationSettings" class="flex justify-center py-8">
            <div class="animate-spin rounded-full h-8 w-8 border-b-2 border-crimson-600"></div>
          </div>
          
          <div v-else class="space-y-8">
            <!-- Email Notification Settings -->
            <div class="border-b border-gray-200 pb-6">
              <h3 class="text-md font-semibold text-gray-800 mb-4 flex items-center">
                <i class="fas fa-envelope text-crimson-600 mr-2"></i>
                Email Notifications
              </h3>
              <p class="text-sm text-gray-600 mb-4">Configure automatic email notifications sent to applicants during their application process.</p>
              
              <div class="space-y-4">
                <!-- Application Confirmation -->
                <div class="flex items-center justify-between p-4 bg-gray-50 rounded-lg">
                  <div>
                    <h4 class="font-medium text-gray-800">Application Confirmation</h4>
                    <p class="text-sm text-gray-600">Send confirmation email when applicant successfully submits their application</p>
                  </div>
                  <label class="relative inline-flex items-center cursor-pointer">
                    <input v-model="notificationSettings.email.applicationConfirmation" type="checkbox" class="sr-only peer">
                    <div class="w-11 h-6 bg-gray-200 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-crimson-300 rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-crimson-600"></div>
                  </label>
                </div>

                <!-- Appointment Scheduled -->
                <div class="flex items-center justify-between p-4 bg-gray-50 rounded-lg">
                  <div>
                    <h4 class="font-medium text-gray-800">Appointment Scheduled</h4>
                    <p class="text-sm text-gray-600">Notify applicants when their exam appointment is scheduled</p>
                  </div>
                  <label class="relative inline-flex items-center cursor-pointer">
                    <input v-model="notificationSettings.email.appointmentScheduled" type="checkbox" class="sr-only peer">
                    <div class="w-11 h-6 bg-gray-200 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-crimson-300 rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-crimson-600"></div>
                  </label>
                </div>

                <!-- Appointment Reminders -->
                <div class="flex items-center justify-between p-4 bg-gray-50 rounded-lg">
                  <div>
                    <h4 class="font-medium text-gray-800">Appointment Reminders</h4>
                    <p class="text-sm text-gray-600">Send reminder emails before scheduled exam dates</p>
                  </div>
                  <label class="relative inline-flex items-center cursor-pointer">
                    <input v-model="notificationSettings.email.appointmentReminders" type="checkbox" class="sr-only peer">
                    <div class="w-11 h-6 bg-gray-200 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-crimson-300 rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-crimson-600"></div>
                  </label>
                </div>

                <!-- Results Available -->
                <div class="flex items-center justify-between p-4 bg-gray-50 rounded-lg">
                  <div>
                    <h4 class="font-medium text-gray-800">Exam Results Available</h4>
                    <p class="text-sm text-gray-600">Notify applicants when their exam results are ready</p>
                  </div>
                  <label class="relative inline-flex items-center cursor-pointer">
                    <input v-model="notificationSettings.email.resultsAvailable" type="checkbox" class="sr-only peer">
                    <div class="w-11 h-6 bg-gray-200 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-crimson-300 rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-crimson-600"></div>
                  </label>
                </div>

                <!-- Status Updates -->
                <div class="flex items-center justify-between p-4 bg-gray-50 rounded-lg">
                  <div>
                    <h4 class="font-medium text-gray-800">Application Status Updates</h4>
                    <p class="text-sm text-gray-600">Send notifications when application status changes (approved, rejected, etc.)</p>
                  </div>
                  <label class="relative inline-flex items-center cursor-pointer">
                    <input v-model="notificationSettings.email.statusUpdates" type="checkbox" class="sr-only peer">
                    <div class="w-11 h-6 bg-gray-200 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-crimson-300 rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-crimson-600"></div>
                  </label>
                </div>
              </div>
            </div>

            <!-- Notification Timing Settings -->
            <div class="border-b border-gray-200 pb-6">
              <h3 class="text-md font-semibold text-gray-800 mb-4 flex items-center">
                <i class="fas fa-clock text-crimson-600 mr-2"></i>
                Notification Timing
              </h3>
              <p class="text-sm text-gray-600 mb-4">Configure when notifications should be sent to applicants.</p>
              
              <div class="grid grid-cols-1 gap-6">
                <!-- Email Reminder Timing -->
                <div class="space-y-3">
                  <label class="block text-sm font-medium text-gray-700">Email Reminder Timing</label>
                  <div class="space-y-2">
                    <label class="flex items-center">
                      <input v-model="notificationSettings.timing.emailReminder" value="24h" type="radio" class="w-4 h-4 text-crimson-600 bg-gray-100 border-gray-300 focus:ring-crimson-500">
                      <span class="ml-2 text-sm text-gray-700">24 hours before exam</span>
                    </label>
                    <label class="flex items-center">
                      <input v-model="notificationSettings.timing.emailReminder" value="48h" type="radio" class="w-4 h-4 text-crimson-600 bg-gray-100 border-gray-300 focus:ring-crimson-500">
                      <span class="ml-2 text-sm text-gray-700">48 hours before exam</span>
                    </label>
                    <label class="flex items-center">
                      <input v-model="notificationSettings.timing.emailReminder" value="72h" type="radio" class="w-4 h-4 text-crimson-600 bg-gray-100 border-gray-300 focus:ring-crimson-500">
                      <span class="ml-2 text-sm text-gray-700">3 days before exam</span>
                    </label>
                  </div>
                </div>
              </div>
            </div>

            <!-- Template Settings -->
            <div>
              <h3 class="text-md font-semibold text-gray-800 mb-4 flex items-center">
                <i class="fas fa-file-alt text-crimson-600 mr-2"></i>
                Message Templates
              </h3>
              <p class="text-sm text-gray-600 mb-4">Customize notification message templates for applicants.</p>
              
              <div class="space-y-6">
                <!-- Email Subject Templates -->
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-2">Email Subject Line Templates</label>
                  <div class="space-y-3">
                    <div>
                      <label class="block text-xs font-medium text-gray-600 mb-1">Application Confirmation</label>
                      <input 
                        v-model="notificationSettings.templates.emailSubjects.confirmation"
                        type="text" 
                        class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-crimson-500 text-sm"
                        placeholder="Your WMSU-CET Application has been received"
                      >
                    </div>
                    <div>
                      <label class="block text-xs font-medium text-gray-600 mb-1">Appointment Reminder</label>
                      <input 
                        v-model="notificationSettings.templates.emailSubjects.reminder"
                        type="text" 
                        class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-crimson-500 text-sm"
                        placeholder="Reminder: Your WMSU-CET exam is tomorrow"
                      >
                    </div>
                    <div>
                      <label class="block text-xs font-medium text-gray-600 mb-1">Results Available</label>
                      <input 
                        v-model="notificationSettings.templates.emailSubjects.results"
                        type="text" 
                        class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-crimson-500 text-sm"
                        placeholder="Your WMSU-CET Results are now available"
                      >
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- Save Button -->
          <div class="mt-8 pt-6 border-t border-gray-200">
            <div class="flex justify-end">
              <button 
                @click="saveNotificationSettings" 
                :disabled="isLoading"
                class="bg-crimson-600 text-white px-6 py-2 rounded-lg hover:bg-crimson-700 transition-colors flex items-center space-x-2"
              >
                <i v-if="isLoading" class="fas fa-spinner fa-spin"></i>
                <i v-else class="fas fa-save"></i>
                <span>{{ isLoading ? 'Saving...' : 'Save Notification Settings' }}</span>
              </button>
            </div>
          </div>
        </div>

        <!-- Content Management -->
        <div v-show="activeSection === 'content'" class="bg-white rounded-xl shadow-sm border border-gray-100 p-6">
          <!-- Content Category Tabs -->
          <div class="mb-6 border-b border-gray-200">
            <nav class="flex -mb-px">
              <button 
                @click="activeContentCategory = 'faq'" 
                class="py-2 px-4 border-b-2 font-medium text-sm focus:outline-none"
                :class="activeContentCategory === 'faq' 
                  ? 'border-crimson-500 text-crimson-600' 
                  : 'border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300'"
              >
                <i class="fas fa-question-circle mr-2"></i>
                FAQs
              </button>
              <button 
                @click="activeContentCategory = 'announcements'" 
                class="ml-8 py-2 px-4 border-b-2 font-medium text-sm focus:outline-none"
                :class="activeContentCategory === 'announcements' 
                  ? 'border-crimson-500 text-crimson-600' 
                  : 'border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300'"
              >
                <i class="fas fa-bullhorn mr-2"></i>
                Announcements
              </button>
            </nav>
          </div>

          <div class="space-y-8">
            <!-- FAQ Management -->
            <div v-show="activeContentCategory === 'faq'">
              <div class="flex justify-between items-center mb-6">
                <div>
                  <h2 class="text-xl font-semibold text-gray-800">FAQ Management</h2>
                  <p class="text-sm text-gray-500 mt-1">Manage frequently asked questions and categories</p>
                </div>
                <div class="flex space-x-3">
                  <button @click="addNewFAQ" class="bg-crimson-600 text-white px-4 py-2 rounded-lg hover:bg-crimson-700 transition-colors flex items-center space-x-2">
                    <i class="fas fa-plus"></i>
                    <span>Add FAQ</span>
                  </button>
                  <button @click="saveFaqChanges" 
                          :disabled="isLoadingFaqs"
                          :class="{'bg-green-600 hover:bg-green-700': true, 'bg-green-400 cursor-not-allowed': isLoadingFaqs}"
                          class="text-white px-4 py-2 rounded-lg transition-colors flex items-center space-x-2">
                    <i :class="isLoadingFaqs ? 'fas fa-spinner fa-spin' : 'fas fa-save'"></i>
                    <span>{{ isLoadingFaqs ? 'Saving...' : 'Save Changes' }}</span>
                  </button>
                </div>
              </div>

              <!-- Loading State -->
              <div v-if="isLoadingFaqs" class="text-center py-12">
                <div class="inline-flex items-center justify-center">
                  <i class="fas fa-spinner fa-spin text-2xl text-crimson-600"></i>
                </div>
                <p class="text-gray-500 mt-2">Loading FAQs...</p>
              </div>

              <!-- Search and Filter Bar -->
              <div v-if="faqs.length > 0" class="mb-6 bg-white p-4 rounded-lg border border-gray-200 flex flex-wrap gap-4">
                <!-- Search Box -->
                <div class="flex-1 min-w-[250px]">
                  <div class="relative">
                    <input 
                      v-model="faqSearchQuery" 
                      type="text" 
                      placeholder="Search FAQs..." 
                      class="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-crimson-500"
                    >
                    <i class="fas fa-search absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400"></i>
                    <button 
                      v-if="faqSearchQuery" 
                      @click="faqSearchQuery = ''" 
                      class="absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-400 hover:text-crimson-600"
                    >
                      <i class="fas fa-times"></i>
                    </button>
                  </div>
                </div>
                
                <!-- Category Filter -->
                <div class="min-w-[200px]">
                  <select 
                    v-model="faqCategoryFilter" 
                    class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-crimson-500"
                  >
                    <option value="all">All Categories</option>
                    <option v-for="category in faqCategories" :key="category" :value="category">
                      {{ category }}
                    </option>
                  </select>
                </div>
                
                <!-- Status Filter -->
                <div class="min-w-[200px]">
                  <select 
                    v-model="faqStatusFilter" 
                    class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-crimson-500"
                  >
                    <option value="all">All Status</option>
                    <option value="active">Active</option>
                    <option value="inactive">Inactive</option>
                  </select>
                </div>
                
                <!-- Reset Filters -->
                <button 
                  @click="resetFaqFilters" 
                  class="px-4 py-2 border border-gray-300 rounded-lg hover:bg-gray-50 text-gray-600 flex items-center space-x-2"
                >
                  <i class="fas fa-sync-alt"></i>
                  <span>Reset</span>
                </button>
              </div>

              <!-- FAQ Categories -->
              <div class="mb-8 bg-gray-50 p-4 rounded-lg border border-gray-200">
                <h3 class="text-sm font-medium text-gray-700 mb-3">FAQ Categories</h3>
                <div class="flex flex-wrap gap-2">
                  <span v-for="category in faqCategories" 
                        :key="category"
                        class="px-3 py-1.5 bg-white border border-gray-200 text-gray-700 rounded-full text-sm flex items-center shadow-sm">
                    {{ category }}
                    <button @click="removeCategory(category)" class="ml-2 text-gray-400 hover:text-crimson-600">
                      <i class="fas fa-times"></i>
                    </button>
                  </span>
                  <button @click="addNewCategory" class="px-3 py-1.5 border border-dashed border-gray-300 rounded-full text-sm text-gray-600 hover:bg-white hover:border-gray-400 transition-colors">
                    <i class="fas fa-plus text-xs mr-1"></i> Add Category
                  </button>
                </div>
              </div>

              <!-- Empty State -->
              <div v-if="!isLoadingFaqs && faqs.length === 0" class="text-center py-12 bg-white rounded-lg border border-gray-200 shadow-sm">
                <div class="inline-flex items-center justify-center w-16 h-16 rounded-full bg-gray-100 text-gray-400 mb-4">
                  <i class="fas fa-question-circle text-xl"></i>
                </div>
                <h3 class="text-lg font-medium text-gray-800 mb-2">No FAQs Yet</h3>
                <p class="text-gray-500 max-w-md mx-auto mb-6">
                  Create your first FAQ to help users find answers to common questions.
                </p>
                <button @click="addNewFAQ" class="bg-crimson-600 text-white px-4 py-2 rounded-lg hover:bg-crimson-700 transition-colors flex items-center space-x-2 mx-auto">
                  <i class="fas fa-plus"></i>
                  <span>Create First FAQ</span>
                </button>
              </div>

              <!-- FAQ Items -->
              <div v-if="!isLoadingFaqs && faqs.length > 0" class="space-y-4">
                <div v-for="(faq, index) in paginatedFaqs" 
                     :key="index"
                     class="border border-gray-200 rounded-lg bg-white shadow-sm hover:shadow-md transition-shadow">
                  
                  <!-- FAQ Header -->
                  <div class="p-4 border-b border-gray-100 flex justify-between items-center">
                    <div class="flex items-center space-x-4">
                      <!-- Category Badge -->
                      <span class="inline-block px-3 py-1 text-sm font-medium rounded-full bg-blue-100 text-blue-800">
                        {{ faq.category }}
                      </span>
                      
                      <!-- Status -->
                      <div class="flex items-center">
                        <div class="relative inline-block w-10 mr-2 align-middle select-none">
                          <input type="checkbox" 
                              :id="`faq-active-${index}`"
                              v-model="faq.is_active" 
                              class="toggle-checkbox absolute block w-6 h-6 rounded-full bg-white border-4 appearance-none cursor-pointer"
                          />
                          <label :for="`faq-active-${index}`" 
                                class="toggle-label block overflow-hidden h-6 rounded-full bg-gray-300 cursor-pointer"></label>
                        </div>
                        <span class="text-sm text-gray-600">{{ faq.is_active ? 'Active' : 'Inactive' }}</span>
                      </div>
                    </div>
                    
                    <!-- Actions -->
                    <div class="flex items-center space-x-2">
                      <button @click="previewFAQ(faq)" 
                              class="text-gray-400 hover:text-blue-600 p-1.5 rounded-full hover:bg-blue-50 transition-colors"
                              title="Preview">
                        <i class="fas fa-eye"></i>
                      </button>
                      <button @click="duplicateFAQ(index)" 
                              class="text-gray-400 hover:text-indigo-600 p-1.5 rounded-full hover:bg-indigo-50 transition-colors"
                              title="Duplicate">
                        <i class="fas fa-copy"></i>
                      </button>
                      <button @click="confirmDeleteFAQ(index)" 
                              class="text-gray-400 hover:text-crimson-600 p-1.5 rounded-full hover:bg-crimson-50 transition-colors"
                              title="Delete">
                        <i class="fas fa-trash"></i>
                      </button>
                    </div>
                  </div>
                  
                  <!-- FAQ Content -->
                  <div class="p-4 faq-form">
                    <div class="mb-4">
                      <div class="flex flex-wrap gap-4 mb-4">
                        <!-- Category and Icon Selection -->
                        <div class="w-full md:w-auto">
                          <label class="block text-sm font-medium text-gray-700 mb-1">Category</label>
                          <select v-model="faq.category" 
                                  class="w-full md:w-48 px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-crimson-500 bg-white">
                            <option v-for="category in faqCategories" 
                                    :key="category" 
                                    :value="category">
                              {{ category }}
                            </option>
                          </select>
                        </div>
                        
                        <div class="w-full md:w-auto">
                          <label class="block text-sm font-medium text-gray-700 mb-1">Icon</label>
                          <select v-model="faq.icon" 
                                  class="w-full md:w-48 px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-crimson-500 bg-white">
                            <option value="fas fa-question">Question</option>
                            <option value="fas fa-info-circle">Info</option>
                            <option value="fas fa-exclamation-circle">Important</option>
                            <option value="fas fa-lightbulb">Tip</option>
                          </select>
                        </div>
                      </div>
                      
                      <!-- Question -->
                      <div class="mb-4">
                        <label class="block text-sm font-medium text-gray-700 mb-1">
                          Question
                          <span v-if="!faq.question || !faq.question.trim()" class="text-red-500 text-xs ml-1">*Required</span>
                        </label>
                        <input type="text" 
                               v-model="faq.question" 
                               placeholder="Enter question"
                               class="w-full px-3 py-2 border rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-crimson-500"
                               :class="!faq.question || !faq.question.trim() ? 'border-red-300 bg-red-50' : 'border-gray-300'">
                      </div>
                      
                      <!-- Answer -->
                      <div class="mb-4">
                        <div class="flex justify-between items-center mb-1">
                          <label class="block text-sm font-medium text-gray-700">
                            Answer
                            <span v-if="!faq.answer || !faq.answer.trim()" class="text-red-500 text-xs ml-1">*Required</span>
                          </label>
                          <span class="text-xs text-gray-500" :class="{ 'text-amber-500': isAnswerNearLimit(faq.answer), 'text-red-500': isAnswerOverLimit(faq.answer) }">
                            {{ faq.answer ? faq.answer.length : 0 }}/1000 characters
                          </span>
                        </div>
                        <textarea v-model.trim="faq.answer" 
                                 rows="3" 
                                 placeholder="Enter answer"
                                 @input="autoResizeTextarea($event)"
                                 class="w-full px-3 py-2 border rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-crimson-500"
                                 :class="{ 
                                   'border-amber-400': isAnswerNearLimit(faq.answer), 
                                   'border-red-500': isAnswerOverLimit(faq.answer),
                                   'border-red-300 bg-red-50': !faq.answer || !faq.answer.trim(),
                                   'border-gray-300': faq.answer && faq.answer.trim() && !isAnswerNearLimit(faq.answer) && !isAnswerOverLimit(faq.answer)
                                 }"></textarea>
                      </div>
                    </div>
                  </div>
                </div>
                
                <!-- FAQ Pagination -->
                <div class="mt-6">
                  <AdminPagination
                    :model-value="faqCurrentPage"
                    :items-per-page="parseInt(faqPageSize)"
                    :total-items="filteredFaqs.length"
                    @update:model-value="faqCurrentPage = $event"
                  />
                </div>
              </div>
              
              <!-- "Add Another" button when list is not empty -->
              <div v-if="faqs.length > 0" class="mt-6 text-center">
                <button @click="addNewFAQ" 
                        class="inline-flex items-center px-4 py-2 border border-dashed border-gray-300 rounded-lg text-crimson-600 hover:bg-crimson-50 hover:border-crimson-200 transition-colors">
                  <i class="fas fa-plus mr-2"></i>
                  Add Another FAQ
                </button>
              </div>
            </div>

            <!-- Announcements Management -->
            <div v-show="activeContentCategory === 'announcements'" class="pt-0">
              <div class="flex justify-between items-center mb-6">
                <div>
                  <h2 class="text-xl font-semibold text-gray-800">Announcements</h2>
                  <p class="text-sm text-gray-500 mt-1">Manage announcements and notifications</p>
                </div>
                <div class="flex space-x-3">
                <button @click="addNewAnnouncement" class="bg-crimson-600 text-white px-4 py-2 rounded-lg hover:bg-crimson-700 transition-colors flex items-center space-x-2">
                  <i class="fas fa-plus"></i>
                  <span>Add Announcement</span>
                  </button>
                  <button @click="saveAnnouncementChanges" 
                          :disabled="isLoadingAnnouncements || !hasAnnouncementChanges"
                          :class="{'bg-green-600 hover:bg-green-700': hasAnnouncementChanges, 'bg-green-400 cursor-not-allowed': !hasAnnouncementChanges || isLoadingAnnouncements}"
                          class="text-white px-4 py-2 rounded-lg transition-colors flex items-center space-x-2">
                    <i :class="isLoadingAnnouncements ? 'fas fa-spinner fa-spin' : 'fas fa-save'"></i>
                    <span>{{ isLoadingAnnouncements ? 'Saving...' : 'Save Changes' }}</span>
                  </button>
                </div>
              </div>

              <!-- Search and Filter Bar -->
              <div v-if="announcements.length > 0" class="mb-6 bg-white p-4 rounded-lg border border-gray-200 flex flex-wrap gap-4">
                <!-- Search Box -->
                <div class="flex-1 min-w-[250px]">
                  <div class="relative">
                    <input 
                      v-model="searchQuery" 
                      type="text" 
                      placeholder="Search announcements..." 
                      class="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-crimson-500"
                    >
                    <i class="fas fa-search absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400"></i>
                    <button 
                      v-if="searchQuery" 
                      @click="searchQuery = ''" 
                      class="absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-400 hover:text-crimson-600"
                    >
                      <i class="fas fa-times"></i>
                    </button>
                  </div>
                </div>
                
                <!-- Type Filter -->
                <div class="min-w-[200px]">
                  <select 
                    v-model="typeFilter" 
                    class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-crimson-500"
                  >
                    <option value="all">All Types</option>
                    <option value="New">New</option>
                    <option value="Update">Update</option>
                    <option value="Resource">Resource</option>
                    <option value="Event">Event</option>
                    <option value="Passers">Passers</option>
                  </select>
                </div>
                
                <!-- Status Filter -->
                <div class="min-w-[200px]">
                  <select 
                    v-model="statusFilter" 
                    class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-crimson-500"
                  >
                    <option value="all">All Status</option>
                    <option value="active">Active</option>
                    <option value="inactive">Inactive</option>
                  </select>
                </div>
                
                <!-- Reset Filters -->
                <button 
                  @click="resetFilters" 
                  class="px-4 py-2 border border-gray-300 rounded-lg hover:bg-gray-50 text-gray-600 flex items-center space-x-2"
                >
                  <i class="fas fa-sync-alt"></i>
                  <span>Reset</span>
                </button>
              </div>

              <!-- Loading State -->
              <div v-if="announcementStore.loading" class="text-center py-12">
                <div class="inline-flex items-center justify-center">
                  <i class="fas fa-spinner fa-spin text-2xl text-crimson-600"></i>
                </div>
                <p class="text-gray-500 mt-2">Loading Announcements...</p>
              </div>

              <!-- Empty State -->
              <div v-else-if="announcements.length === 0" class="text-center py-12 bg-white rounded-lg border border-gray-200 shadow-sm">
                <div class="inline-flex items-center justify-center w-16 h-16 rounded-full bg-gray-100 text-gray-400 mb-4">
                  <i class="fas fa-bullhorn text-xl"></i>
                </div>
                <h3 class="text-lg font-medium text-gray-800 mb-2">No Announcements Yet</h3>
                <p class="text-gray-500 max-w-md mx-auto mb-6">
                  Create your first announcement to notify users about important updates, events, or resources.
                </p>
                <button @click="addNewAnnouncement" class="bg-crimson-600 text-white px-4 py-2 rounded-lg hover:bg-crimson-700 transition-colors flex items-center space-x-2 mx-auto">
                  <i class="fas fa-plus"></i>
                  <span>Create First Announcement</span>
                </button>
              </div>

              <!-- Announcements List -->
              <div v-else class="space-y-6">
                <!-- Card for each announcement -->
                <div v-for="(announcement, index) in paginatedAnnouncements" 
                     :key="index"
                     class="border border-gray-200 rounded-lg bg-white shadow-sm hover:shadow-md transition-shadow">
                  
                  <!-- Announcement Header -->
                  <div class="p-4 border-b border-gray-100 flex justify-between items-center">
                          <div class="flex items-center space-x-4">
                      <!-- Type Badge -->
                      <span :class="getAnnouncementTypeClass(announcement.type)" 
                            class="inline-block px-3 py-1 text-sm font-medium rounded-full">
                        {{ announcement.type }}
                      </span>
                      
                      <!-- Status -->
                      <div class="flex items-center">
                        <div class="relative inline-block w-10 mr-2 align-middle select-none">
                            <input type="checkbox" 
                                 :id="`active-${index}`"
                                   v-model="announcement.active" 
                                 class="toggle-checkbox absolute block w-6 h-6 rounded-full bg-white border-4 appearance-none cursor-pointer"
                                 />
                          <label :for="`active-${index}`" 
                                 class="toggle-label block overflow-hidden h-6 rounded-full bg-gray-300 cursor-pointer"></label>
                        </div>
                        <span class="text-sm text-gray-600">{{ announcement.active ? 'Active' : 'Inactive' }}</span>
                      </div>
                    </div>
                    
                    <!-- Actions -->
                    <div class="flex items-center space-x-2">
                      <button @click="previewAnnouncement(announcement)" 
                              class="text-gray-400 hover:text-blue-600 p-1.5 rounded-full hover:bg-blue-50 transition-colors"
                              title="Preview">
                        <i class="fas fa-eye"></i>
                      </button>
                      <button @click="duplicateAnnouncement(getCurrentIndex(index))" 
                              class="text-gray-400 hover:text-indigo-600 p-1.5 rounded-full hover:bg-indigo-50 transition-colors"
                              title="Duplicate">
                        <i class="fas fa-copy"></i>
                      </button>
                      <button @click="confirmDeleteAnnouncement(getCurrentIndex(index))" 
                              class="text-gray-400 hover:text-crimson-600 p-1.5 rounded-full hover:bg-crimson-50 transition-colors"
                              title="Delete">
                        <i class="fas fa-trash"></i>
                      </button>
                    </div>
                  </div>
                  
                  <!-- Announcement Content -->
                  <div class="p-4 announcement-form">
                    <div class="mb-4">
                      <div class="flex flex-wrap gap-4 mb-4">
                        <!-- Type and Icon Selection -->
                        <div class="w-full md:w-auto">
                          <label class="block text-sm font-medium text-gray-700 mb-1">Type</label>
                          <select v-model="announcement.type" 
                                  class="w-full md:w-48 px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-crimson-500 bg-white">
                            <option value="New">New</option>
                            <option value="Update">Update</option>
                            <option value="Resource">Resource</option>
                            <option value="Event">Event</option>
                            <option value="Passers">Passers</option>
                            </select>
                          </div>
                        
                        <div class="w-full md:w-auto">
                          <label class="block text-sm font-medium text-gray-700 mb-1">Icon</label>
                          <select v-model="announcement.icon" 
                                  class="w-full md:w-48 px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-crimson-500 bg-white">
                            <option value="fas fa-bell">Bell</option>
                            <option value="fas fa-info-circle">Info</option>
                            <option value="fas fa-exclamation-circle">Alert</option>
                            <option value="fas fa-book-open">Book</option>
                            <option value="fas fa-calendar-alt">Calendar</option>
                            <option value="fas fa-building">Building</option>
                            <option value="fas fa-globe-americas">Globe</option>
                            <option value="fas fa-file-pdf">PDF</option>
                            <option value="fas fa-microphone">Microphone</option>
                            <option value="fas fa-tools">Tools</option>
                          </select>
                        </div>
                        
                        <div class="w-full md:w-auto">
                          <label class="block text-sm font-medium text-gray-700 mb-1">Date</label>
                          <input type="date" 
                                 v-model="announcement.date" 
                                 class="w-full md:w-auto px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-crimson-500">
                        </div>
                      </div>
                      
                      <!-- Title -->
                      <div class="mb-4">
                        <label class="block text-sm font-medium text-gray-700 mb-1">Title</label>
                        <input type="text" 
                               v-model="announcement.title" 
                               placeholder="Enter announcement title"
                               class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-crimson-500">
                      </div>
                      
                      <!-- Content -->
                      <div class="mb-4">
                        <div class="flex justify-between items-center mb-1">
                          <label class="block text-sm font-medium text-gray-700">Content</label>
                          <span class="text-xs text-gray-500" :class="{ 'text-amber-500': isContentNearLimit(announcement.content), 'text-red-500': isContentOverLimit(announcement.content) }">
                            {{ announcement.content ? announcement.content.length : 0 }}/500 characters
                          </span>
                        </div>
                        <textarea v-model.trim="announcement.content" 
                                 rows="3" 
                                 placeholder="Enter announcement content"
                                 @input="autoResizeTextarea($event)"
                                 class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-crimson-500"
                                 :class="{ 'border-amber-400': isContentNearLimit(announcement.content), 'border-red-500': isContentOverLimit(announcement.content) }"></textarea>
                      </div>
                      
                      <!-- Image URL or Upload -->
                      <div class="mb-4">
                        <label class="block text-sm font-medium text-gray-700 mb-2">Announcement Image</label>
                        <div class="space-y-3">
                          <!-- URL Input -->
                          <div>
                            <label class="block text-xs font-medium text-gray-600 mb-1">Image URL</label>
                            <input type="url" 
                                  v-model="announcement.image" 
                                  placeholder="https://example.com/image.jpg"
                                  class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-crimson-500 text-sm">
                          </div>
                          
                          <!-- File Upload Alternative -->
                          <div class="text-center">
                            <div class="text-xs text-gray-500 mb-2">OR</div>
                            <div class="border-2 border-dashed border-gray-300 rounded-lg p-4 hover:border-crimson-400 transition-colors">
                              <div class="space-y-2">
                                <i class="fas fa-cloud-upload-alt text-2xl text-gray-400"></i>
                                <div>
                                  <label class="cursor-pointer text-crimson-600 hover:text-crimson-700 font-medium text-sm">
                                    <span>Upload an image</span>
                                    <input type="file" 
                                           accept="image/*" 
                                           class="hidden" 
                                           @change="handleImageUpload($event, getCurrentIndex(index))">
                                  </label>
                                </div>
                                <p class="text-xs text-gray-500">JPG, PNG, GIF up to 5MB</p>
                              </div>
                            </div>
                          </div>
                          
                          <!-- Image Preview -->
                          <div v-if="announcement.image && announcement.image.trim()" class="mt-3">
                            <div class="relative inline-block">
                              <img :src="announcement.image" 
                                   alt="Announcement image preview" 
                                   class="max-w-xs h-32 object-cover rounded-lg border border-gray-200 shadow-sm"
                                   @error="$event.target.style.display = 'none'"
                                   @load="$event.target.style.display = 'block'">
                              <button type="button" 
                                      @click="announcement.image = ''"
                                      class="absolute -top-2 -right-2 bg-red-500 text-white rounded-full w-6 h-6 flex items-center justify-center text-xs hover:bg-red-600 transition-colors">
                                <i class="fas fa-times"></i>
                              </button>
                            </div>
                          </div>
                        </div>
                      </div>
                      
                      <!-- Author and Link -->
                      <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                        <div>
                          <label class="block text-sm font-medium text-gray-700 mb-1">Author</label>
                          <input type="text" 
                                v-model="announcement.author" 
                                placeholder="Enter author name"
                                class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-crimson-500">
                        </div>
                        <div>
                          <label class="block text-sm font-medium text-gray-700 mb-1">Link (Optional)</label>
                          <input type="text" 
                                v-model="announcement.link" 
                                placeholder="https://example.com/page"
                                class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-crimson-500">
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
                
                <!-- Pagination Controls -->
                <div class="mt-6">
                  <AdminPagination
                    :model-value="currentPage"
                    :items-per-page="parseInt(pageSize)"
                    :total-items="filteredAnnouncements.length"
                    @update:model-value="currentPage = $event"
                  />
                </div>
              </div>
              
              <!-- "Add Another" button when list is not empty -->
              <div v-if="announcements.length > 0" class="mt-6 text-center">
                <button @click="addNewAnnouncement" 
                        class="inline-flex items-center px-4 py-2 border border-dashed border-gray-300 rounded-lg text-crimson-600 hover:bg-crimson-50 hover:border-crimson-200 transition-colors">
                  <i class="fas fa-plus mr-2"></i>
                  Add Another Announcement
                </button>
              </div>
            </div>
          </div>
        </div>

        <!-- Security Section -->
        <div v-show="activeSection === 'security'" class="bg-white rounded-xl shadow-sm border border-gray-100 p-6">
          <h2 class="text-lg font-semibold mb-6">Security Settings</h2>
          
          <div class="space-y-8">
            <!-- Password Management -->
            <div class="border-b border-gray-200 pb-6">
              <h3 class="text-md font-semibold text-gray-800 mb-4 flex items-center">
                <i class="fas fa-key text-crimson-600 mr-2"></i>
                Password Management
              </h3>
              <p class="text-sm text-gray-600 mb-4">Manage your account password and security settings.</p>
              
              <div class="space-y-4">
                <div class="bg-gray-50 p-4 rounded-lg">
                  <h4 class="font-medium text-gray-800 mb-2">Change Password</h4>
                  <p class="text-sm text-gray-600 mb-3">Update your account password for enhanced security.</p>
                  <button @click="openPasswordModal" class="bg-crimson-600 text-white px-4 py-2 rounded-lg hover:bg-crimson-700 transition-colors text-sm">
                    Change Password
                  </button>
                </div>
                
                <div class="bg-gray-50 p-4 rounded-lg">
                  <h4 class="font-medium text-gray-800 mb-2">Password Strength Requirements</h4>
                  <ul class="text-sm text-gray-600 space-y-1">
                    <li class="flex items-center"><i class="fas fa-check text-green-500 mr-2"></i>At least 8 characters long</li>
                    <li class="flex items-center"><i class="fas fa-check text-green-500 mr-2"></i>Contains uppercase and lowercase letters</li>
                    <li class="flex items-center"><i class="fas fa-check text-green-500 mr-2"></i>Includes at least one number</li>
                    <li class="flex items-center"><i class="fas fa-check text-green-500 mr-2"></i>Contains special characters</li>
                  </ul>
                </div>
              </div>
            </div>

            <!-- Session Management -->
            <div class="border-b border-gray-200 pb-6">
              <h3 class="text-md font-semibold text-gray-800 mb-4 flex items-center">
                <i class="fas fa-clock text-crimson-600 mr-2"></i>
                Session Management
              </h3>
              <p class="text-sm text-gray-600 mb-4">Monitor and manage your active login sessions.</p>
              
              <div class="space-y-4">
                <!-- Session Timeout Settings -->
                <div class="bg-gray-50 p-4 rounded-lg">
                  <h4 class="font-medium text-gray-800 mb-2">Session Timeout</h4>
                  <p class="text-sm text-gray-600 mb-3">Automatically log out after period of inactivity</p>
                  <select 
                    v-model="securitySettings.sessionTimeout" 
                    @change="saveSecuritySettings"
                    class="w-full max-w-xs px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-crimson-500"
                  >
                    <option value="30">30 minutes</option>
                    <option value="60">1 hour</option>
                    <option value="120">2 hours</option>
                    <option value="240">4 hours</option>
                    <option value="480">8 hours</option>
                  </select>
                </div>
                
                <!-- Active Sessions -->
                <div class="bg-gray-50 p-4 rounded-lg">
                  <div class="flex justify-between items-center mb-3">
                    <h4 class="font-medium text-gray-800 flex items-center">
                      <i class="fas fa-map-marker-alt text-crimson-600 mr-2"></i>
                      Active Sessions
                    </h4>
                    <button 
                      @click="logoutAllOtherSessions"
                      :disabled="isLoadingSessions"
                      class="bg-red-600 text-white px-3 py-1.5 rounded-lg hover:bg-red-700 transition-colors text-sm flex items-center"
                    >
                      <i v-if="isLoadingSessions" class="fas fa-spinner fa-spin mr-2"></i>
                      Log out of all other devices
                    </button>
                  </div>
                  <p class="text-sm text-gray-600 mb-4">Currently logged-in sessions across different devices and locations.</p>
                  
                  <!-- Loading State -->
                  <div v-if="isLoadingSessions" class="text-center py-8">
                    <div class="inline-flex items-center">
                      <i class="fas fa-spinner fa-spin text-gray-400 mr-2"></i>
                      <span class="text-gray-500">Loading sessions...</span>
                    </div>
                  </div>
                  
                  <!-- Sessions Table -->
                  <div v-else class="overflow-x-auto">
                    <table class="w-full text-sm">
                      <thead class="bg-gray-100">
                        <tr>
                          <th class="px-3 py-2 text-left text-xs font-medium text-gray-500 uppercase">Device</th>
                          <th class="px-3 py-2 text-left text-xs font-medium text-gray-500 uppercase">IP Address</th>
                          <th class="px-3 py-2 text-left text-xs font-medium text-gray-500 uppercase">Location</th>
                          <th class="px-3 py-2 text-left text-xs font-medium text-gray-500 uppercase">Last Active</th>
                          <th class="px-3 py-2 text-left text-xs font-medium text-gray-500 uppercase">Status</th>
                          <th class="px-3 py-2 text-left text-xs font-medium text-gray-500 uppercase">Action</th>
                        </tr>
                      </thead>
                      <tbody class="divide-y divide-gray-200">
                        <tr v-for="session in activeSessions" :key="session.id" :class="session.is_current ? 'bg-green-50' : ''">
                          <td class="px-3 py-2">
                            <div class="flex items-center">
                              <i :class="getDeviceIcon(session.device)" class="mr-2"></i>
                              <span :class="session.is_current ? 'font-medium' : ''">{{ session.device }}</span>
                              <span v-if="session.is_current" class="ml-2 px-2 py-0.5 bg-green-100 text-green-700 text-xs rounded-full">Current</span>
                            </div>
                          </td>
                          <td class="px-3 py-2 text-gray-600">{{ session.ip_address }}</td>
                          <td class="px-3 py-2 text-gray-600">{{ session.location }}</td>
                          <td class="px-3 py-2 text-gray-600">{{ formatLastActive(session.last_active) }}</td>
                          <td class="px-3 py-2">
                            <span :class="getSessionStatusClass(session.status)" class="px-2 py-1 text-xs rounded-full">
                              {{ session.status }}
                            </span>
                          </td>
                          <td class="px-3 py-2">
                            <button 
                              v-if="!session.is_current"
                              @click="terminateSession(session.id)"
                              class="text-red-600 hover:text-red-700 text-xs"
                            >
                              Terminate
                            </button>
                            <span v-else class="text-gray-400 text-xs">Current session</span>
                          </td>
                        </tr>
                      </tbody>
                    </table>
                  </div>
                </div>
              </div>
            </div>

            <!-- Login Activity Logs -->
            <div class="border-b border-gray-200 pb-6">
              <h3 class="text-md font-semibold text-gray-800 mb-4 flex items-center">
                <i class="fas fa-scroll text-crimson-600 mr-2"></i>
                Login Activity Logs
              </h3>
              <p class="text-sm text-gray-600 mb-4">Review recent login attempts and security events.</p>
              
              <div class="bg-gray-50 p-4 rounded-lg">
                <div class="flex justify-between items-center mb-4">
                  <h4 class="font-medium text-gray-800">Recent Login Activity</h4>
                  <button 
                    @click="exportLoginLogs"
                    :disabled="isLoadingLogs"
                    class="text-crimson-600 hover:text-crimson-700 text-sm flex items-center"
                  >
                    <i v-if="isLoadingLogs" class="fas fa-spinner fa-spin mr-1"></i>
                    <i v-else class="fas fa-download mr-1"></i>
                    Export Logs
                  </button>
                </div>
                
                <!-- Loading State -->
                <div v-if="isLoadingLogs" class="text-center py-8">
                  <div class="inline-flex items-center">
                    <i class="fas fa-spinner fa-spin text-gray-400 mr-2"></i>
                    <span class="text-gray-500">Loading activity logs...</span>
                  </div>
                </div>
                
                <!-- Activity Table -->
                <div v-else class="overflow-x-auto">
                  <table class="w-full text-sm">
                    <thead class="bg-gray-100">
                      <tr>
                        <th class="px-3 py-2 text-left text-xs font-medium text-gray-500 uppercase">Date & Time</th>
                        <th class="px-3 py-2 text-left text-xs font-medium text-gray-500 uppercase">IP Address</th>
                        <th class="px-3 py-2 text-left text-xs font-medium text-gray-500 uppercase">Location</th>
                        <th class="px-3 py-2 text-left text-xs font-medium text-gray-500 uppercase">Device</th>
                        <th class="px-3 py-2 text-left text-xs font-medium text-gray-500 uppercase">Status</th>
                      </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-200">
                      <tr v-for="log in paginatedLoginLogs" :key="log.id">
                        <td class="px-3 py-2 text-gray-600">{{ formatDateTime(log.timestamp) }}</td>
                        <td class="px-3 py-2 text-gray-600">{{ log.ip_address }}</td>
                        <td class="px-3 py-2 text-gray-600">{{ log.location }}</td>
                        <td class="px-3 py-2 text-gray-600">{{ log.device }}</td>
                        <td class="px-3 py-2">
                          <span :class="getLoginStatusClass(log.status)" class="px-2 py-1 text-xs rounded-full">
                            {{ log.status }}
                          </span>
                        </td>
                      </tr>
                      <tr v-if="loginLogs.length === 0">
                        <td colspan="5" class="px-3 py-8 text-center text-gray-500">
                          No login activity found
                        </td>
                      </tr>
                    </tbody>
                  </table>
                </div>
                
                <!-- Pagination for logs -->
                <div v-if="loginLogs.length > 0" class="mt-4 flex justify-between items-center">
                  <span class="text-sm text-gray-600">
                    Showing {{ ((loginLogsCurrentPage - 1) * loginLogsPageSize) + 1 }}-{{ Math.min(loginLogsCurrentPage * loginLogsPageSize, loginLogs.length) }} of {{ loginLogs.length }} entries
                  </span>
                  <div class="flex space-x-2">
                    <button 
                      @click="previousLoginLogsPage"
                      :disabled="loginLogsCurrentPage === 1"
                      class="px-3 py-1 border border-gray-300 rounded text-sm hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed"
                    >
                      Previous
                    </button>
                    <button 
                      @click="nextLoginLogsPage"
                      :disabled="loginLogsCurrentPage === totalLoginLogsPages"
                      class="px-3 py-1 border border-gray-300 rounded text-sm hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed"
                    >
                      Next
                    </button>
                  </div>
                </div>
              </div>
            </div>

            <!-- Account Recovery Settings -->
            <div>
              <h3 class="text-md font-semibold text-gray-800 mb-4 flex items-center">
                <i class="fas fa-life-ring text-crimson-600 mr-2"></i>
                Account Recovery Settings
              </h3>
              <p class="text-sm text-gray-600 mb-4">Configure account recovery options and security measures.</p>
              
              <div class="space-y-4">
                <!-- Recovery Email -->
                <div class="bg-gray-50 p-4 rounded-lg">
                  <h4 class="font-medium text-gray-800 mb-2">Recovery Email</h4>
                  <p class="text-sm text-gray-600 mb-3">Set or update the email address used for account recovery.</p>
                  <div class="flex flex-col sm:flex-row gap-3">
                    <input 
                      v-model="securitySettings.recoveryEmail"
                      type="email" 
                      placeholder="recovery@example.com" 
                      class="flex-1 px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-crimson-500"
                    >
                    <button 
                      @click="updateRecoveryEmail"
                      :disabled="isLoadingRecovery"
                      class="bg-crimson-600 text-white px-4 py-2 rounded-lg hover:bg-crimson-700 transition-colors text-sm flex items-center"
                    >
                      <i v-if="isLoadingRecovery" class="fas fa-spinner fa-spin mr-2"></i>
                      Update Email
                    </button>
                  </div>
                </div>

                <!-- Security Questions -->
                <div class="bg-gray-50 p-4 rounded-lg">
                  <h4 class="font-medium text-gray-800 mb-2">Security Questions</h4>
                  <p class="text-sm text-gray-600 mb-3">Set up security questions for additional account verification.</p>
                  <div class="space-y-3">
                    <div>
                      <label class="block text-sm font-medium text-gray-700 mb-1">Question 1</label>
                      <select 
                        v-model="securitySettings.securityQuestion1"
                        class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-crimson-500"
                      >
                        <option value="">Select a security question</option>
                        <option value="pet">What was the name of your first pet?</option>
                        <option value="school">What was the name of your elementary school?</option>
                        <option value="city">In what city were you born?</option>
                        <option value="mother">What is your mother's maiden name?</option>
                      </select>
                    </div>
                    <div>
                      <label class="block text-sm font-medium text-gray-700 mb-1">Answer</label>
                      <input 
                        v-model="securitySettings.securityAnswer1"
                        type="password" 
                        placeholder="Your answer" 
                        class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-crimson-500"
                      >
                    </div>
                  </div>
                  <button 
                    @click="saveSecurityQuestions"
                    :disabled="isLoadingRecovery"
                    class="mt-3 bg-crimson-600 text-white px-4 py-2 rounded-lg hover:bg-crimson-700 transition-colors text-sm flex items-center"
                  >
                    <i v-if="isLoadingRecovery" class="fas fa-spinner fa-spin mr-2"></i>
                    Save Security Questions
                  </button>
                </div>

                <!-- Account Lockout Settings -->
                <div class="bg-gray-50 p-4 rounded-lg">
                  <h4 class="font-medium text-gray-800 mb-2">Account Lockout Settings</h4>
                  <p class="text-sm text-gray-600 mb-3">Configure automatic account lockout after failed login attempts.</p>
                  <div class="space-y-4">
                    <div class="flex items-center justify-between">
                      <div>
                        <span class="text-sm font-medium text-gray-700">Enable Account Lockout</span>
                        <p class="text-xs text-gray-500">Automatically lock account after multiple failed attempts</p>
                      </div>
                      <label class="relative inline-flex items-center cursor-pointer">
                        <input 
                          v-model="securitySettings.accountLockoutEnabled"
                          @change="saveSecuritySettings"
                          type="checkbox" 
                          class="sr-only peer"
                        >
                        <div class="w-11 h-6 bg-gray-200 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-crimson-300 rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-crimson-600"></div>
                      </label>
                    </div>
                    
                    <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                      <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Failed Attempts Threshold</label>
                        <select 
                          v-model="securitySettings.failedAttemptsThreshold"
                          @change="saveSecuritySettings"
                          class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-crimson-500"
                        >
                          <option value="3">3 attempts</option>
                          <option value="5">5 attempts</option>
                          <option value="10">10 attempts</option>
                        </select>
                      </div>
                      <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Lockout Duration</label>
                        <select 
                          v-model="securitySettings.lockoutDuration"
                          @change="saveSecuritySettings"
                          class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-crimson-500"
                        >
                          <option value="15">15 minutes</option>
                          <option value="30">30 minutes</option>
                          <option value="60">1 hour</option>
                          <option value="1440">24 hours</option>
                        </select>
                      </div>
                    </div>
                  </div>
                  <button 
                    @click="saveSecuritySettings"
                    :disabled="isLoadingRecovery"
                    class="mt-3 bg-crimson-600 text-white px-4 py-2 rounded-lg hover:bg-crimson-700 transition-colors text-sm flex items-center"
                  >
                    <i v-if="isLoadingRecovery" class="fas fa-spinner fa-spin mr-2"></i>
                    Save Lockout Settings
                  </button>
                </div>
              </div>
            </div>
          </div>

          <!-- Save Button -->
          <div class="mt-8 pt-6 border-t border-gray-200">
            <div class="flex justify-end">
              <button 
                @click="saveSecuritySettings"
                :disabled="isLoadingRecovery"
                class="bg-crimson-600 text-white px-6 py-2 rounded-lg hover:bg-crimson-700 transition-colors flex items-center space-x-2"
              >
                <i v-if="isLoadingRecovery" class="fas fa-spinner fa-spin"></i>
                <i v-else class="fas fa-save"></i>
                <span>Save Security Settings</span>
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- User Management Modal -->
    <div v-if="showUserModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
      <div class="bg-white rounded-xl shadow-lg w-full max-w-lg p-6">
        <div class="flex justify-between items-center mb-6">
          <h3 class="text-lg font-semibold">{{ editingUser ? 'Edit User' : 'Add New User' }}</h3>
          <button @click="closeUserModal" class="text-gray-400 hover:text-gray-600">
            <i class="fas fa-times"></i>
          </button>
        </div>

        <form @submit.prevent="saveUser" class="space-y-4">
          <div class="grid grid-cols-2 gap-4">
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">First Name</label>
              <input 
                v-model="userForm.first_name"
                type="text" 
                required
                class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-crimson-500"
              >
            </div>
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Last Name</label>
              <input 
                v-model="userForm.last_name"
                type="text" 
                required
                class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-crimson-500"
              >
            </div>
          </div>

          <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">Email</label>
            <input 
              v-model="userForm.email"
              type="email" 
              required
              class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-crimson-500"
            >
          </div>

          <div v-if="!editingUser">
            <label class="block text-sm font-medium text-gray-700 mb-1">Password</label>
            <input 
              v-model="userForm.password"
              type="password" 
              :required="!editingUser"
              class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-crimson-500"
            >
          </div>

          <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">Role</label>
            <select 
              v-model="userForm.role"
              class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-crimson-500"
            >
              <option value="User">User</option>
              <option value="Admin">Admin</option>
            </select>
          </div>

          <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">Status</label>
            <select 
              v-model="userForm.status"
              class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-crimson-500"
            >
              <option value="Active">Active</option>
              <option value="Inactive">Inactive</option>
            </select>
          </div>

          <div class="flex justify-end space-x-3 pt-4">
            <button 
              type="button"
              @click="closeUserModal"
              class="px-4 py-2 text-sm font-medium text-gray-700 bg-gray-100 rounded-lg hover:bg-gray-200"
            >
              Cancel
            </button>
            <button 
              type="submit"
              :disabled="isLoading"
              class="px-4 py-2 text-sm font-medium text-white bg-crimson-600 rounded-lg hover:bg-crimson-700 flex items-center"
            >
              <i v-if="isLoading" class="fas fa-spinner fa-spin mr-2"></i>
              {{ editingUser ? 'Update' : 'Add' }} User
            </button>
          </div>
        </form>
      </div>
    </div>

    <!-- Delete Confirmation Modal -->
    <div v-if="showDeleteModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
      <div class="bg-white rounded-xl shadow-lg w-full max-w-md p-6">
        <div class="text-center">
          <i class="fas fa-exclamation-triangle text-4xl text-red-500 mb-4"></i>
          <h3 class="text-lg font-semibold mb-2">Confirm Delete</h3>
          <p class="text-gray-600 mb-6">Are you sure you want to delete this user? This action cannot be undone.</p>
          
          <div class="flex justify-center space-x-3">
            <button 
              @click="cancelDelete"
              class="px-4 py-2 text-sm font-medium text-gray-700 bg-gray-100 rounded-lg hover:bg-gray-200"
            >
              Cancel
            </button>
            <button 
              @click="confirmDelete"
              :disabled="isLoading"
              class="px-4 py-2 text-sm font-medium text-white bg-red-600 rounded-lg hover:bg-red-700 flex items-center"
            >
              <i v-if="isLoading" class="fas fa-spinner fa-spin mr-2"></i>
              Delete User
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Announcement Preview Modal -->
    <div v-if="previewAnnouncementModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
      <div class="bg-white rounded-xl shadow-lg max-w-xl w-full max-h-[90vh] overflow-y-auto">
        <div class="sticky top-0 bg-white p-4 border-b border-gray-100 flex justify-between items-center z-10">
          <h3 class="text-lg font-semibold">Announcement Preview</h3>
          <button @click="previewAnnouncementModal = false" class="text-gray-400 hover:text-gray-600 p-1.5 rounded-full hover:bg-gray-100">
            <i class="fas fa-times"></i>
          </button>
        </div>
        
        <div class="p-4">
          <div class="bg-white rounded-xl shadow-sm border border-gray-100 overflow-hidden mb-4">
            <div class="p-4">
              <div class="flex items-start justify-between mb-4">
                <span 
                  :class="getAnnouncementTypeClass(previewData.type)" 
                  class="inline-block px-3 py-1 text-sm font-medium rounded-full">
                  {{ previewData.type }}
                </span>
                <span class="text-gray-400 text-sm">{{ formatDate(previewData.date) }}</span>
              </div>
              
              <h3 class="text-xl font-bold text-gray-900 mb-3 flex items-center">
                <i :class="[previewData.icon, 'mr-3 text-crimson-600']"></i>
                {{ previewData.title || 'Untitled Announcement' }}
              </h3>
              
              <!-- Preview Image Display -->
              <div v-if="previewData.image" class="mb-4">
                <div class="relative overflow-hidden rounded-lg border border-gray-200 bg-gray-100 shadow-sm">
                  <img :src="previewData.image" 
                       :alt="previewData.title || 'Announcement image'" 
                       class="w-full max-h-64 object-cover"
                       @error="$event.target.parentElement.style.display = 'none'"
                       @load="$event.target.parentElement.classList.remove('bg-gray-100')">
                </div>
              </div>
              
              <p class="text-gray-600 mb-5 whitespace-pre-wrap">{{ previewData.content || 'No content provided.' }}</p>
              
              <div class="flex justify-between items-center pt-4 border-t border-gray-100">
                <div class="flex items-center text-sm text-gray-500">
                  <i class="far fa-user mr-2"></i>
                  <span>{{ previewData.author || 'Admin Team' }}</span>
                </div>
                
                <button 
                  v-if="previewData.link" 
                  class="text-crimson-600 hover:text-crimson-700 font-medium text-sm flex items-center"
                >
                  Learn More
                  <i class="fas fa-arrow-right ml-2"></i>
                </button>
              </div>
            </div>
          </div>
          
          <div class="text-center text-sm text-gray-500">
            <p class="mb-2">This is how the announcement will appear to users.</p>
            <p v-if="!previewData.active" class="text-amber-500">
              <i class="fas fa-exclamation-triangle mr-1"></i>
              This announcement is currently inactive and won't be visible to users.
            </p>
          </div>
        </div>
        
        <div class="bg-gray-50 p-4 flex justify-end">
          <button 
            @click="previewAnnouncementModal = false"
            class="px-4 py-2 bg-gray-200 text-gray-700 rounded-lg hover:bg-gray-300 transition-colors"
          >
            Close Preview
          </button>
        </div>
      </div>
    </div>
    
    <!-- Delete Confirmation Modal for Announcements -->
    <div v-if="showDeleteAnnouncementModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
      <div class="bg-white rounded-xl shadow-lg w-full max-w-md p-6">
        <div class="text-center">
          <i class="fas fa-exclamation-triangle text-4xl text-red-500 mb-4"></i>
          <h3 class="text-lg font-semibold mb-2">Confirm Delete</h3>
          <p class="text-gray-600 mb-6">Are you sure you want to delete this announcement? This action cannot be undone.</p>
          
          <div class="flex justify-center space-x-3">
            <button 
              @click="showDeleteAnnouncementModal = false"
              class="px-4 py-2 text-sm font-medium text-gray-700 bg-gray-100 rounded-lg hover:bg-gray-200"
            >
              Cancel
            </button>
            <button 
              @click="deleteAnnouncement"
              :disabled="isDeleting"
              class="px-4 py-2 text-sm font-medium text-white bg-red-600 rounded-lg hover:bg-red-700 flex items-center"
            >
              <i v-if="isDeleting" class="fas fa-spinner fa-spin mr-2"></i>
              Delete Announcement
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Change Password Modal -->
    <div v-if="showPasswordModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
      <div class="bg-white rounded-xl shadow-lg w-full max-w-md p-6">
        <div class="flex justify-between items-center mb-6">
          <h3 class="text-lg font-semibold">Change Password</h3>
          <button @click="closePasswordModal" class="text-gray-400 hover:text-gray-600">
            <i class="fas fa-times"></i>
          </button>
        </div>

        <form @submit.prevent="changePassword" class="space-y-4">
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">Current Password</label>
            <input 
              v-model="passwordForm.currentPassword"
              type="password" 
              required
              class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-crimson-500"
            >
          </div>

          <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">New Password</label>
            <input 
              v-model="passwordForm.newPassword"
              type="password" 
              required
              @input="validatePassword"
              class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-crimson-500"
            >
            <!-- Password Requirements -->
            <div class="mt-2 space-y-1">
              <div class="flex items-center text-xs">
                <i :class="passwordValidation.length ? 'fas fa-check text-green-500' : 'fas fa-times text-red-500'" class="mr-2"></i>
                <span :class="passwordValidation.length ? 'text-green-600' : 'text-red-600'">At least 8 characters</span>
              </div>
              <div class="flex items-center text-xs">
                <i :class="passwordValidation.uppercase ? 'fas fa-check text-green-500' : 'fas fa-times text-red-500'" class="mr-2"></i>
                <span :class="passwordValidation.uppercase ? 'text-green-600' : 'text-red-600'">Contains uppercase letter</span>
              </div>
              <div class="flex items-center text-xs">
                <i :class="passwordValidation.lowercase ? 'fas fa-check text-green-500' : 'fas fa-times text-red-500'" class="mr-2"></i>
                <span :class="passwordValidation.lowercase ? 'text-green-600' : 'text-red-600'">Contains lowercase letter</span>
              </div>
              <div class="flex items-center text-xs">
                <i :class="passwordValidation.number ? 'fas fa-check text-green-500' : 'fas fa-times text-red-500'" class="mr-2"></i>
                <span :class="passwordValidation.number ? 'text-green-600' : 'text-red-600'">Contains number</span>
              </div>
              <div class="flex items-center text-xs">
                <i :class="passwordValidation.special ? 'fas fa-check text-green-500' : 'fas fa-times text-red-500'" class="mr-2"></i>
                <span :class="passwordValidation.special ? 'text-green-600' : 'text-red-600'">Contains special character</span>
              </div>
            </div>
          </div>

          <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">Confirm New Password</label>
            <input 
              v-model="passwordForm.confirmPassword"
              type="password" 
              required
              class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-crimson-500"
            >
            <div v-if="passwordForm.confirmPassword && passwordForm.newPassword !== passwordForm.confirmPassword" class="mt-1 text-xs text-red-600">
              Passwords do not match
            </div>
          </div>

          <div class="flex justify-end space-x-3 pt-4">
            <button 
              type="button"
              @click="closePasswordModal"
              class="px-4 py-2 text-sm font-medium text-gray-700 bg-gray-100 rounded-lg hover:bg-gray-200"
            >
              Cancel
            </button>
            <button 
              type="submit"
              :disabled="isLoadingPassword || !isPasswordValid"
              class="px-4 py-2 text-sm font-medium text-white bg-crimson-600 rounded-lg hover:bg-crimson-700 flex items-center"
            >
              <i v-if="isLoadingPassword" class="fas fa-spinner fa-spin mr-2"></i>
              Change Password
            </button>
          </div>
        </form>
      </div>
    </div>

  </main>
</template>

<script>
import { ref, reactive, onMounted, watch, computed } from 'vue'
import axiosInstance from '../../../services/axios.interceptor'
import { useAnnouncementStore } from '../../../stores/announcement'
import AdminPagination from '../components/AdminPagination.vue'

// Define the API endpoint without duplicating base URL since axios interceptor handles it
const API_ENDPOINT = '/api/';  

export default {
  name: 'Settings',
  components: {
    AdminPagination
  },
  setup() {
    // Import and initialize the announcement store
    const announcementStore = useAnnouncementStore()
    
    const activeSection = ref('general')
    
    const sections = [
      { id: 'general', name: 'General', icon: 'fas fa-cog' },
      { id: 'security', name: 'Security', icon: 'fas fa-shield-alt' },
      { id: 'notifications', name: 'Notifications', icon: 'fas fa-bell' },
      { id: 'users', name: 'Users', icon: 'fas fa-users' },
      { id: 'content', name: 'Content', icon: 'fas fa-edit' }
    ]

    const settings = reactive({
      institutionName: 'ExamScheduler Institute',
      contactEmail: 'contact@examscheduler.com',
      openingTime: '09:00',
      closingTime: '18:00',
      timezone: 'UTC+8',
      dateFormat: 'MM/DD/YYYY'
    })

    // Notification settings for applicants
    const notificationSettings = reactive({
      email: {
        applicationConfirmation: true,
        appointmentScheduled: true,
        appointmentReminders: true,
        resultsAvailable: true,
        statusUpdates: true
      },
      sms: {
        reminders: false,
        emergencyNotifications: true
      },
      timing: {
        emailReminder: '24h',
        smsReminder: '2h'
      },
      templates: {
        emailSubjects: {
          confirmation: 'Your WMSU-CET Application has been received',
          reminder: 'Reminder: Your WMSU-CET exam is tomorrow',
          results: 'Your WMSU-CET Results are now available'
        },
        sms: {
          reminder: 'Hi {name}, this is a reminder that your WMSU-CET exam is scheduled for {date} at {time}. Please arrive 30 minutes early. Good luck!',
          emergency: 'URGENT: Your WMSU-CET exam scheduled for {date} has been {status}. Please check your email for more details or contact us immediately.'
        }
      }
    })

    const timezones = [
      { value: 'UTC+8', label: 'UTC+8 (Asia/Manila)' },
      { value: 'UTC-8', label: 'UTC-8 (Pacific Time)' },
      { value: 'UTC-5', label: 'UTC-5 (Eastern Time)' },
      { value: 'UTC+0', label: 'UTC+0 (GMT)' }
    ]

    const dateFormats = [
      { value: 'MM/DD/YYYY', label: 'MM/DD/YYYY' },
      { value: 'DD/MM/YYYY', label: 'DD/MM/YYYY' },
      { value: 'YYYY-MM-DD', label: 'YYYY-MM-DD' }
    ]

    const userTableHeaders = ['User', 'Role', 'Status', 'Last Login', 'Actions']

    const users = ref([])
    const isLoadingUsers = ref(false)

    // Fetch users from the API
    const fetchUsers = async () => {
      isLoadingUsers.value = true
      try {
        console.log('Fetching users from:', API_ENDPOINT + 'admin/users/')
        const response = await axiosInstance.get(API_ENDPOINT + 'admin/users/');
        console.log('Users response:', response.data)
        users.value = response.data;
      } catch (error) {
        console.error('Failed to fetch users:', error);
        console.error('Error details:', error.response?.data);
        if (error.response?.status === 403) {
          console.error('Access denied - user may not have admin privileges');
        }
      } finally {
        isLoadingUsers.value = false
      }
    }

    // Call fetchUsers when the component is mounted
    // (Consolidated onMounted hook - see bottom of setup function)

    const getStatusClass = (status) => {
      return 'px-2 py-1 text-xs font-semibold rounded-full ' + 
        (status === 'Active' ? 'bg-green-100 text-green-800' : 'bg-gray-100 text-gray-800')
    }

    const saveChanges = async () => {
      try {
        // Save general settings (if in general section)
        if (activeSection.value === 'general') {
          await axiosInstance.put(API_ENDPOINT + 'settings/', settings)
        }
        
        // Save notification settings (if in notifications section)
        if (activeSection.value === 'notifications') {
          await saveNotificationSettings()
          return // Don't show the generic success message, saveNotificationSettings has its own
        }
        
        // Save FAQ changes (if in content section and FAQ tab)
        if (activeSection.value === 'content' && activeContentCategory.value === 'faq') {
          // Check for validation errors before saving
          const invalidFaqs = faqs.value.filter(faq => {
            const errors = validateFaq(faq)
            return errors.length > 0
          })
          
          if (invalidFaqs.length > 0) {
            // Show a more detailed validation message
            const errorDetails = invalidFaqs.map((faq, index) => {
              const errors = validateFaq(faq)
              const faqNumber = faqs.value.indexOf(faq) + 1
              return `FAQ ${faqNumber}: ${errors.join(', ')}`
            }).join('\n')
            
            alert(`Please fix the following validation errors:\n\n${errorDetails}\n\nAll fields marked with * are required.`)
            return
          }
          
          await saveFaqChanges()
          return // Don't show the generic success message, saveFaqChanges has its own
        }
        
        alert('Changes saved successfully')
      } catch (error) {
        console.error('Failed to save changes:', error)
        const errorMessage = error.response?.data?.detail || error.message || 'Failed to save changes'
        alert(`Error: ${errorMessage}`)
      }
    }

    const showUserModal = ref(false)
    const showDeleteModal = ref(false)
    const editingUser = ref(null)
    const userToDelete = ref(null)
    const isLoading = ref(false)

    const userForm = reactive({
      first_name: '',
      last_name: '',
      email: '',
      password: '',
      role: 'User',
      status: 'Active'
    })

    const resetUserForm = () => {
      userForm.first_name = ''
      userForm.last_name = ''
      userForm.email = ''
      userForm.password = ''
      userForm.role = 'User'
      userForm.status = 'Active'
      editingUser.value = null
    }

    const openAddUserModal = () => {
      resetUserForm()
      showUserModal.value = true
    }

    const editUser = (user) => {
      editingUser.value = user
      userForm.first_name = user.name.split(' ')[0]
      userForm.last_name = user.name.split(' ').slice(1).join(' ')
      userForm.email = user.email
      userForm.role = user.role
      userForm.status = user.status
      showUserModal.value = true
    }

    const closeUserModal = () => {
      showUserModal.value = false
      resetUserForm()
    }

    const saveUser = async () => {
      isLoading.value = true
      try {
        const userData = {
          username: userForm.email,
          email: userForm.email,
          first_name: userForm.first_name,
          last_name: userForm.last_name,
          is_staff: userForm.role === 'Admin',
          is_active: userForm.status === 'Active'
        }

        if (!editingUser.value) {
          // Adding new user
          userData.password = userForm.password
          await axiosInstance.post(API_ENDPOINT + 'admin/users/', userData)
        } else {
          // Updating existing user
          await axiosInstance.put(API_ENDPOINT + `admin/users/${editingUser.value.id}/update/`, userData)
        }

        await fetchUsers()
        closeUserModal()
      } catch (error) {
        console.error('Failed to save user:', error)
        alert(error.response?.data?.detail || 'Failed to save user')
      } finally {
        isLoading.value = false
      }
    }

    const deleteUser = (userId) => {
      userToDelete.value = userId
      showDeleteModal.value = true
    }

    const cancelDelete = () => {
      userToDelete.value = null
      showDeleteModal.value = false
    }

    const confirmDelete = async () => {
      isLoading.value = true
      try {
        await axiosInstance.delete(`${API_ENDPOINT}admin/users/${userToDelete.value}/`)
        await fetchUsers()
        cancelDelete()
      } catch (error) {
        console.error('Failed to delete user:', error)
        alert(error.response?.data?.detail || 'Failed to delete user')
      } finally {
        isLoading.value = false
      }
    }

    // Notification Settings Functions
    const fetchNotificationSettings = async () => {
      try {
        const response = await axiosInstance.get(API_ENDPOINT + 'admin/notification-settings/')
        if (response.data) {
          // Merge the fetched settings with default values
          Object.assign(notificationSettings, {
            ...notificationSettings,
            ...response.data
          })
        }
      } catch (error) {
        console.error('Failed to fetch notification settings:', error)
        // Keep default values if fetch fails
      }
    }

    const saveNotificationSettings = async () => {
      try {
        await axiosInstance.put(API_ENDPOINT + 'admin/notification-settings/', notificationSettings)
        alert('Notification settings saved successfully')
      } catch (error) {
        console.error('Failed to save notification settings:', error)
        const errorMessage = error.response?.data?.detail || 'Failed to save notification settings'
        alert(`Error: ${errorMessage}`)
        throw error
      }
    }

    // Security Settings
    const securitySettings = reactive({
      sessionTimeout: 60,
      recoveryEmail: '',
      securityQuestion1: '',
      securityAnswer1: '',
      accountLockoutEnabled: true,
      failedAttemptsThreshold: 5,
      lockoutDuration: 30
    })

    const activeSessions = ref([])
    const loginLogs = ref([])
    const isLoadingSessions = ref(false)
    const isLoadingLogs = ref(false)
    const isLoadingRecovery = ref(false)

    // Password Management
    const showPasswordModal = ref(false)
    const isLoadingPassword = ref(false)
    const passwordForm = reactive({
      currentPassword: '',
      newPassword: '',
      confirmPassword: ''
    })

    const passwordValidation = reactive({
      length: false,
      uppercase: false,
      lowercase: false,
      number: false,
      special: false
    })

    const validatePassword = () => {
      const password = passwordForm.newPassword
      passwordValidation.length = password.length >= 8
      passwordValidation.uppercase = /[A-Z]/.test(password)
      passwordValidation.lowercase = /[a-z]/.test(password)
      passwordValidation.number = /\d/.test(password)
      passwordValidation.special = /[!@#$%^&*(),.?":{}|<>]/.test(password)
    }

    const isPasswordValid = computed(() => {
      return passwordForm.newPassword && 
             passwordForm.confirmPassword && 
             passwordForm.newPassword === passwordForm.confirmPassword &&
             passwordValidation.length &&
             passwordValidation.uppercase &&
             passwordValidation.lowercase &&
             passwordValidation.number &&
             passwordValidation.special
    })

    const openPasswordModal = () => {
      passwordForm.currentPassword = ''
      passwordForm.newPassword = ''
      passwordForm.confirmPassword = ''
      showPasswordModal.value = true
    }

    const closePasswordModal = () => {
      showPasswordModal.value = false
      passwordForm.currentPassword = ''
      passwordForm.newPassword = ''
      passwordForm.confirmPassword = ''
    }

    const changePassword = async () => {
      if (!isPasswordValid.value) {
        alert('Please ensure your password meets all requirements and matches the confirmation.')
        return
      }

      isLoadingPassword.value = true
      try {
        await axiosInstance.post(API_ENDPOINT + 'auth/change-password/', {
          current_password: passwordForm.currentPassword,
          new_password: passwordForm.newPassword
        })
        alert('Password changed successfully')
        closePasswordModal()
      } catch (error) {
        console.error('Failed to change password:', error)
        const errorMessage = error.response?.data?.detail || 
                           error.response?.data?.current_password?.[0] ||
                           error.response?.data?.new_password?.[0] ||
                           'Failed to change password'
        alert(`Error: ${errorMessage}`)
      } finally {
        isLoadingPassword.value = false
      }
    }

    // Session Management
    const fetchActiveSessions = async () => {
      isLoadingSessions.value = true
      try {
        const response = await axiosInstance.get(API_ENDPOINT + 'auth/active-sessions/')
        activeSessions.value = response.data || []
      } catch (error) {
        console.error('Failed to fetch active sessions:', error)
        // Add mock data for development
        activeSessions.value = [
          {
            id: 1,
            device: 'Chrome/Windows',
            ip_address: '192.168.1.10',
            location: 'Zamboanga, Philippines',
            last_active: new Date(),
            status: 'Active',
            is_current: true
          },
          {
            id: 2,
            device: 'Safari/iPhone',
            ip_address: '192.168.1.25',
            location: 'Zamboanga, Philippines',
            last_active: new Date(Date.now() - 2 * 60 * 60 * 1000),
            status: 'Idle',
            is_current: false
          }
        ]
      } finally {
        isLoadingSessions.value = false
      }
    }

    const getDeviceIcon = (device) => {
      if (device.toLowerCase().includes('iphone') || device.toLowerCase().includes('mobile')) {
        return 'fas fa-mobile-alt text-green-500'
      } else if (device.toLowerCase().includes('chrome')) {
        return 'fas fa-desktop text-blue-500'
      } else if (device.toLowerCase().includes('safari')) {
        return 'fas fa-desktop text-gray-500'
      } else if (device.toLowerCase().includes('firefox')) {
        return 'fas fa-desktop text-orange-500'
      }
      return 'fas fa-desktop text-gray-500'
    }

    const getSessionStatusClass = (status) => {
      switch (status?.toLowerCase()) {
        case 'active':
          return 'bg-green-100 text-green-700'
        case 'idle':
          return 'bg-yellow-100 text-yellow-700'
        case 'expired':
          return 'bg-red-100 text-red-700'
        default:
          return 'bg-gray-100 text-gray-700'
      }
    }

    const formatLastActive = (timestamp) => {
      if (!timestamp) return 'Unknown'
      const date = new Date(timestamp)
      const now = new Date()
      const diffMs = now - date
      const diffMins = Math.floor(diffMs / 60000)
      const diffHours = Math.floor(diffMins / 60)
      const diffDays = Math.floor(diffHours / 24)

      if (diffMins < 1) return 'Just now'
      if (diffMins < 60) return `${diffMins} minute${diffMins > 1 ? 's' : ''} ago`
      if (diffHours < 24) return `${diffHours} hour${diffHours > 1 ? 's' : ''} ago`
      return `${diffDays} day${diffDays > 1 ? 's' : ''} ago`
    }

    const terminateSession = async (sessionId) => {
      if (!confirm('Are you sure you want to terminate this session?')) return

      try {
        await axiosInstance.post(API_ENDPOINT + `auth/terminate-session/${sessionId}/`)
        await fetchActiveSessions()
        alert('Session terminated successfully')
      } catch (error) {
        console.error('Failed to terminate session:', error)
        alert('Failed to terminate session')
      }
    }

    const logoutAllOtherSessions = async () => {
      if (!confirm('Are you sure you want to log out of all other devices? This will end all other active sessions.')) return

      isLoadingSessions.value = true
      try {
        await axiosInstance.post(API_ENDPOINT + 'auth/logout-all-other-sessions/')
        await fetchActiveSessions()
        alert('All other sessions have been terminated')
      } catch (error) {
        console.error('Failed to logout all other sessions:', error)
        alert('Failed to logout all other sessions')
      } finally {
        isLoadingSessions.value = false
      }
    }

    // Login Activity Logs
    const loginLogsCurrentPage = ref(1)
    const loginLogsPageSize = ref(10)

    const fetchLoginLogs = async () => {
      isLoadingLogs.value = true
      try {
        const response = await axiosInstance.get(API_ENDPOINT + 'auth/login-logs/')
        loginLogs.value = response.data || []
      } catch (error) {
        console.error('Failed to fetch login logs:', error)
        // Add mock data for development
        loginLogs.value = [
          {
            id: 1,
            timestamp: '2025-07-23T09:15:00Z',
            ip_address: '192.168.1.10',
            location: 'Zamboanga, Philippines',
            device: 'Chrome/Windows',
            status: 'Success'
          },
          {
            id: 2,
            timestamp: '2025-07-22T20:30:00Z',
            ip_address: '192.168.1.25',
            location: 'Zamboanga, Philippines',
            device: 'Safari/iPhone',
            status: 'Success'
          },
          {
            id: 3,
            timestamp: '2025-07-21T14:45:00Z',
            ip_address: '203.177.45.12',
            location: 'Manila, Philippines',
            device: 'Firefox/Windows',
            status: 'Failed'
          },
          {
            id: 4,
            timestamp: '2025-07-20T11:20:00Z',
            ip_address: '192.168.1.10',
            location: 'Zamboanga, Philippines',
            device: 'Chrome/Windows',
            status: 'Success'
          },
          {
            id: 5,
            timestamp: '2025-07-17T07:15:00Z',
            ip_address: '192.168.1.10',
            location: 'Zamboanga, Philippines',
            device: 'Chrome/Windows',
            status: 'Success'
          }
        ]
      } finally {
        isLoadingLogs.value = false
      }
    }

    const paginatedLoginLogs = computed(() => {
      const start = (loginLogsCurrentPage.value - 1) * loginLogsPageSize.value
      const end = start + loginLogsPageSize.value
      return loginLogs.value.slice(start, end)
    })

    const totalLoginLogsPages = computed(() => {
      return Math.ceil(loginLogs.value.length / loginLogsPageSize.value)
    })

    const previousLoginLogsPage = () => {
      if (loginLogsCurrentPage.value > 1) {
        loginLogsCurrentPage.value--
      }
    }

    const nextLoginLogsPage = () => {
      if (loginLogsCurrentPage.value < totalLoginLogsPages.value) {
        loginLogsCurrentPage.value++
      }
    }

    const formatDateTime = (timestamp) => {
      if (!timestamp) return 'Unknown'
      return new Date(timestamp).toLocaleString('en-US', {
        year: 'numeric',
        month: 'long',
        day: 'numeric',
        hour: '2-digit',
        minute: '2-digit'
      })
    }

    const getLoginStatusClass = (status) => {
      switch (status?.toLowerCase()) {
        case 'success':
          return 'bg-green-100 text-green-700'
        case 'failed':
          return 'bg-red-100 text-red-700'
        case 'blocked':
          return 'bg-orange-100 text-orange-700'
        default:
          return 'bg-gray-100 text-gray-700'
      }
    }

    const exportLoginLogs = async () => {
      isLoadingLogs.value = true
      try {
        const response = await axiosInstance.get(API_ENDPOINT + 'auth/export-login-logs/', {
          responseType: 'blob'
        })
        
        const blob = new Blob([response.data], { type: 'text/csv' })
        const url = window.URL.createObjectURL(blob)
        const link = document.createElement('a')
        link.href = url
        link.download = `login-logs-${new Date().toISOString().split('T')[0]}.csv`
        document.body.appendChild(link)
        link.click()
        document.body.removeChild(link)
        window.URL.revokeObjectURL(url)
      } catch (error) {
        console.error('Failed to export login logs:', error)
        alert('Failed to export login logs')
      } finally {
        isLoadingLogs.value = false
      }
    }

    // Security Settings Functions
    const fetchSecuritySettings = async () => {
      try {
        const response = await axiosInstance.get(API_ENDPOINT + 'auth/security-settings/')
        if (response.data) {
          Object.assign(securitySettings, response.data)
        }
      } catch (error) {
        console.error('Failed to fetch security settings:', error)
      }
    }

    const saveSecuritySettings = async () => {
      isLoadingRecovery.value = true
      try {
        await axiosInstance.put(API_ENDPOINT + 'auth/security-settings/', securitySettings)
        alert('Security settings saved successfully')
      } catch (error) {
        console.error('Failed to save security settings:', error)
        alert('Failed to save security settings')
      } finally {
        isLoadingRecovery.value = false
      }
    }

    const updateRecoveryEmail = async () => {
      if (!securitySettings.recoveryEmail) {
        alert('Please enter a recovery email address')
        return
      }

      isLoadingRecovery.value = true
      try {
        await axiosInstance.put(API_ENDPOINT + 'auth/recovery-email/', {
          recovery_email: securitySettings.recoveryEmail
        })
        alert('Recovery email updated successfully')
      } catch (error) {
        console.error('Failed to update recovery email:', error)
        alert('Failed to update recovery email')
      } finally {
        isLoadingRecovery.value = false
      }
    }

    const saveSecurityQuestions = async () => {
      if (!securitySettings.securityQuestion1 || !securitySettings.securityAnswer1) {
        alert('Please select a security question and provide an answer')
        return
      }

      isLoadingRecovery.value = true
      try {
        await axiosInstance.put(API_ENDPOINT + 'auth/security-questions/', {
          question1: securitySettings.securityQuestion1,
          answer1: securitySettings.securityAnswer1
        })
        alert('Security questions saved successfully')
      } catch (error) {
        console.error('Failed to save security questions:', error)
        alert('Failed to save security questions')
      } finally {
        isLoadingRecovery.value = false
      }
    }

    const faqCategories = ref(['General', 'Scheduling', 'Requirements', 'Payment'])
    const faqs = ref([])
    const isLoadingFaqs = ref(false)

    // Fetch FAQs from the API
    const fetchFaqs = async () => {
      isLoadingFaqs.value = true
      try {
        const response = await axiosInstance.get(API_ENDPOINT + 'admin/faqs/')
        // Handle both array and object responses
        const faqData = Array.isArray(response.data) ? response.data : (response.data.results || []);
        faqs.value = faqData.map((faq, index) => ({
          ...faq,
          is_active: faq.is_active !== undefined ? faq.is_active : false,
          icon: faq.icon || 'fas fa-question',
          order: faq.order !== undefined ? faq.order : index,
          category: faq.category || 'General'
        }));
      } catch (error) {
        console.error('Failed to fetch FAQs:', error);
        // Use toast for more user-friendly error messages
        if (error.response?.status === 403) {
          alert('You do not have permission to view FAQs');
        } else {
          alert('Failed to fetch FAQs. Please try again later.');
        }
      } finally {
        isLoadingFaqs.value = false;
      }
    }

    // Save FAQ changes
    const saveFaqChanges = async () => {
      try {
        // Validate all FAQs first
        const validationResults = faqs.value.map((faq, index) => ({
          index,
          faq,
          errors: validateFaq(faq)
        }))

        // Filter out FAQs with validation errors
        const validFaqs = validationResults.filter(result => result.errors.length === 0)
        const invalidFaqs = validationResults.filter(result => result.errors.length > 0)

        // Show validation errors if any
        if (invalidFaqs.length > 0) {
          const errorMessages = invalidFaqs.map(result => 
            `FAQ ${result.index + 1}: ${result.errors.join(', ')}`
          ).join('\n')
          alert(`Please fix the following errors before saving:\n\n${errorMessages}`)
          return
        }

        // Filter out empty FAQs (no question and no answer)
        const faqsToSave = validFaqs.filter(result => 
          result.faq.question && result.faq.question.trim() && 
          result.faq.answer && result.faq.answer.trim()
        )

        if (faqsToSave.length === 0) {
          alert('No valid FAQs to save. Please add some content.')
          return
        }

        const promises = faqsToSave.map(async (result) => {
          const faq = result.faq
          const faqData = {
            question: faq.question.trim(),
            answer: faq.answer.trim(),
            category: (faq.category || 'General').trim(),
            icon: (faq.icon || 'fas fa-question').trim(),
            is_active: Boolean(faq.is_active),
            order: parseInt(faq.order) || 0
          }

          try {
            if (faq.id) {
              // Update existing FAQ
              return await axiosInstance.put(API_ENDPOINT + `admin/faqs/${faq.id}/`, faqData)
            } else {
              // Create new FAQ
              return await axiosInstance.post(API_ENDPOINT + 'admin/faqs/', faqData)
            }
          } catch (error) {
            console.error(`Failed to save FAQ "${faq.question}":`, error.response?.data || error)
            throw new Error(`Failed to save FAQ "${faq.question}": ${error.response?.data?.detail || error.message}`)
          }
        })

        await Promise.all(promises)
        await fetchFaqs() // Refresh the FAQ list
        alert(`Successfully saved ${faqsToSave.length} FAQ(s)`)
      } catch (error) {
        console.error('Failed to save FAQ changes:', error)
        const errorMessage = error.message || 
                           error.response?.data?.detail || 
                           error.response?.data?.question?.[0] || 
                           error.response?.data?.answer?.[0] || 
                           'Failed to save FAQ changes. Please check all fields are filled correctly.'
        alert(errorMessage)
        throw error
      }
    }

    // Add new FAQ
    const addNewFAQ = () => {
      const newOrder = Math.max(...faqs.value.map(faq => faq.order || 0), -1) + 1
      faqs.value.push({
        category: faqCategories.value[0] || 'General',
        is_active: true,
        question: '',
        answer: '',
        icon: 'fas fa-question',
        order: newOrder
      })
    }

    // Remove FAQ
    const removeFAQ = async (index) => {
      if (!confirm('Are you sure you want to delete this FAQ?')) {
        return
      }

      const faq = faqs.value[index]
      if (faq.id) {
        try {
          await axiosInstance.delete(API_ENDPOINT + `admin/faqs/${faq.id}/`)
          faqs.value.splice(index, 1)
          // Update order of remaining FAQs
          faqs.value.forEach((f, i) => {
            f.order = i
          })
          alert('FAQ deleted successfully')
        } catch (error) {
          console.error('Failed to delete FAQ:', error)
          const errorMessage = error.response?.data?.detail || 'Failed to delete FAQ'
          alert(errorMessage)
        }
      } else {
        faqs.value.splice(index, 1)
        // Update order of remaining FAQs
        faqs.value.forEach((f, i) => {
          f.order = i
        })
      }
    }

    // Move FAQ up or down
    const moveFAQ = async (index, direction) => {
      if (direction === 'up' && index > 0) {
        [faqs.value[index], faqs.value[index - 1]] = [faqs.value[index - 1], faqs.value[index]]
      } else if (direction === 'down' && index < faqs.value.length - 1) {
        [faqs.value[index], faqs.value[index + 1]] = [faqs.value[index + 1], faqs.value[index]]
      }
      
      // Update order values
      faqs.value.forEach((faq, i) => {
        faq.order = i
      })
    }

    // Add new category
    const addNewCategory = () => {
      const category = prompt('Enter new category name:')
      if (category && !faqCategories.value.includes(category)) {
        faqCategories.value.push(category)
      }
    }

    // Remove category
    const removeCategory = (category) => {
      const index = faqCategories.value.indexOf(category)
      if (index > -1) {
        if (faqs.value.some(faq => faq.category === category)) {
          if (confirm(`There are FAQs using this category. Moving them to 'General' category. Continue?`)) {
            faqs.value.forEach(faq => {
              if (faq.category === category) {
                faq.category = 'General'
              }
            })
            faqCategories.value.splice(index, 1)
          }
        } else {
          faqCategories.value.splice(index, 1)
        }
      }
    }

    // Call fetchFaqs when the component is mounted
    // (Consolidated onMounted hook - see bottom of setup function)

    const announcements = computed(() => {
      return announcementStore.announcements.map(announcement => ({
        ...announcement,
        active: announcement.is_active,
        priority: 'Normal', // Default since we don't have priority in our model
        date: announcement.date || new Date().toISOString().split('T')[0]
      }))
    })
    
    const isLoadingAnnouncements = computed(() => announcementStore.loading)
    const hasAnnouncementChanges = ref(false)
    const originalAnnouncementState = ref("")

    const autoResizeTextarea = (event) => {
      const textarea = event.target;
      textarea.style.height = "auto";
      const newHeight = textarea.scrollHeight;
      textarea.style.height = Math.min(newHeight + 4, 300) + "px";
      
      // Add scrolling for content that exceeds max height
      if (newHeight > 300) {
        textarea.style.overflowY = "auto";
      } else {
        textarea.style.overflowY = "hidden";
      }
      
      // If this is part of the announcement form, mark as changed
      if (textarea.closest('.announcement-form')) {
        hasAnnouncementChanges.value = true;
      }
    };
    
    // Resize textareas after announcements are loaded
    const resizeAllTextareas = () => {
      setTimeout(() => {
        const textareas = document.querySelectorAll('textarea')
        textareas.forEach(textarea => {
          // Reset height to auto to get the correct scrollHeight
          textarea.style.height = 'auto'
          
          // Set the height to scrollHeight + border width
          const newHeight = textarea.scrollHeight
          textarea.style.height = `${newHeight}px`
          
          // Cap the maximum height
          if (newHeight > 300) {
            textarea.style.height = '300px'
            textarea.style.overflowY = 'auto'
          } else {
            textarea.style.overflowY = 'hidden'
          }
        })
      }, 100)
    }
    
    // Modified fetchAnnouncements to use the store
    const fetchAnnouncements = async () => {
      try {
        await announcementStore.fetchAnnouncements()
        // Store the original state for change detection
        originalAnnouncementState.value = JSON.stringify(announcements.value)
        hasAnnouncementChanges.value = false
        resizeAllTextareas()
      } catch (error) {
        console.error('Failed to fetch announcements:', error)
        alert('Failed to fetch announcements')
      }
    }

    // Save announcement changes
    const saveAnnouncementChanges = async () => {
      if (!hasAnnouncementChanges.value) return

      announcementStore.loading = true
      try {
        // Validate announcements before saving
        const validAnnouncements = announcements.value.filter(announcement => {
          return announcement.title && announcement.title.trim() && 
                 announcement.content && announcement.content.trim()
        })

        if (validAnnouncements.length === 0) {
          alert('Please add title and content to the announcements before saving.')
          return
        }

        const promises = validAnnouncements.map(async (announcement) => {
          const announcementData = {
            title: announcement.title.trim(),
            content: announcement.content.trim(),
            type: announcement.type || 'New',
            is_active: announcement.active || announcement.is_active,
            icon: announcement.icon || 'fas fa-bell',
            author: announcement.author || 'Admin Team',
            link: announcement.link || null,
            image_url: announcement.image || null  // Send image URL in image_url field
          }

          // Don't send date field for new announcements - let the backend set it with auto_now_add
          if (announcement.id) {
            // Update existing announcement - include date if it exists
            if (announcement.date) {
              announcementData.date = announcement.date
            }
            return axiosInstance.put(API_ENDPOINT + `announcements/${announcement.id}/`, announcementData)
          } else {
            // Create new announcement - don't send date field
            return axiosInstance.post(API_ENDPOINT + 'announcements/', announcementData)
          }
        })

        await Promise.all(promises)
        
        // Remove announcements that don't have title or content from the local array
        announcementStore.announcements = announcementStore.announcements.filter(announcement => {
          return announcement.title && announcement.title.trim() && 
                 announcement.content && announcement.content.trim()
        })
        
        await fetchAnnouncements() // Refresh the announcements list
        hasAnnouncementChanges.value = false
        alert('Announcement changes saved successfully')
      } catch (error) {
        console.error('Failed to save announcement changes:', error)
        console.error('Error response:', error.response?.data)
        console.error('Error status:', error.response?.status)
        
        let errorMessage = 'Failed to save announcement changes'
        if (error.response?.data) {
          if (typeof error.response.data === 'string') {
            errorMessage += ': ' + error.response.data
          } else if (error.response.data.detail) {
            errorMessage += ': ' + error.response.data.detail
          } else if (error.response.data.title) {
            errorMessage += ': Title - ' + error.response.data.title[0]
          } else if (error.response.data.content) {
            errorMessage += ': Content - ' + error.response.data.content[0]
          } else {
            errorMessage += ': ' + JSON.stringify(error.response.data)
          }
        }
        alert(errorMessage)
        throw error
      } finally {
        announcementStore.loading = false
      }
    }

    // Watch for changes in announcements
    watch(announcements, () => {
      checkForChanges()
    }, { deep: true })
    
    const checkForChanges = () => {
      const currentState = JSON.stringify(announcements.value)
      hasAnnouncementChanges.value = currentState !== originalAnnouncementState.value
    }

    const addNewAnnouncement = () => {
      const newAnnouncement = {
        active: true,
        is_active: true,
        type: 'New',
        icon: 'fas fa-bell',
        title: '',
        content: '',
        author: 'Admin Team',
        link: null,
        image: null
      }
      announcementStore.announcements.push(newAnnouncement)
      hasAnnouncementChanges.value = true
    }

    const previewAnnouncementModal = ref(false)
    const previewData = ref(null)

    const previewAnnouncement = (announcement) => {
      previewData.value = { ...announcement }
      previewAnnouncementModal.value = true
    }

    const duplicateAnnouncement = (index) => {
      const announcement = announcements.value[index]
      announcementStore.announcements.push({
        ...announcement,
        id: null,
        is_active: true,
        active: true,
        type: 'New',
        date: new Date().toISOString().split('T')[0]
      })
    }

    // Handle image file upload
    const handleImageUpload = async (event, announcementIndex) => {
      const file = event.target.files[0]
      if (!file) return

      // Validate file type
      if (!file.type.startsWith('image/')) {
        alert('Please select a valid image file (JPG, PNG, GIF)')
        return
      }

      // Validate file size (5MB limit)
      const maxSize = 5 * 1024 * 1024 // 5MB
      if (file.size > maxSize) {
        alert('Image file size must be less than 5MB')
        return
      }

      try {
        // Upload file to backend
        const formData = new FormData()
        formData.append('image', file)

        const response = await axiosInstance.post(API_ENDPOINT + 'announcements/upload-image/', formData, {
          headers: {
            'Content-Type': 'multipart/form-data'
          }
        })

        // Use the returned image URL
        const announcement = announcements.value[announcementIndex]
        if (announcement) {
          announcement.image = response.data.image_url
          hasAnnouncementChanges.value = true
        }
      } catch (error) {
        console.error('Error uploading image:', error)
        const errorMessage = error.response?.data?.detail || error.response?.data?.error || 'Failed to upload image. Please try again.'
        alert(errorMessage)
      }

      // Clear the file input
      event.target.value = ''
    }

    const showDeleteAnnouncementModal = ref(false)
    const isDeleting = ref(false)
    const announcementToDeleteIndex = ref(null)

    const confirmDeleteAnnouncement = (index) => {
      const announcement = announcements.value[index]
      previewData.value = announcement
      announcementToDeleteIndex.value = index
      showDeleteAnnouncementModal.value = true
    }

    const removeAnnouncement = async (index) => {
      const announcement = announcements.value[index]
      if (announcement.id) {
        isDeleting.value = true
        try {
          await axiosInstance.delete(API_ENDPOINT + `announcements/${announcement.id}/`)
          announcementStore.announcements.splice(index, 1)
        } catch (error) {
          console.error('Failed to delete announcement:', error)
          alert('Failed to delete announcement')
        } finally {
          isDeleting.value = false
        }
      } else {
        announcementStore.announcements.splice(index, 1)
      }
    }

    const deleteAnnouncement = async () => {
      if (announcementToDeleteIndex.value !== null) {
        await removeAnnouncement(announcementToDeleteIndex.value)
        showDeleteAnnouncementModal.value = false
        announcementToDeleteIndex.value = null
      }
    }

    const getAnnouncementTypeClass = (type) => {
      const typeClasses = {
        New: 'bg-green-100 text-green-800',
        Update: 'bg-blue-100 text-blue-800',
        Resource: 'bg-purple-100 text-purple-800',
        Event: 'bg-yellow-100 text-yellow-800',
        Passers: 'bg-pink-100 text-pink-800'
      }
      return typeClasses[type] || 'bg-gray-100 text-gray-800'
    }

    const isContentNearLimit = (content) => {
      return content && content.length >= 450 && content.length < 500
    }

    const isContentOverLimit = (content) => {
      return content && content.length >= 500
    }

    const formatDate = (date) => {
      const formattedDate = new Date(date).toLocaleDateString('en-US', {
        year: 'numeric',
        month: 'long',
        day: 'numeric'
      })
      return formattedDate
    }

    const switchSection = (sectionId) => {
      console.log('Switching to section:', sectionId)
      activeSection.value = sectionId
      
      // Fetch data when switching to users section
      if (sectionId === 'users') {
        fetchUsers()
      }
      
      // Fetch data when switching to notifications section
      if (sectionId === 'notifications') {
        fetchNotificationSettings()
      }
      
      // Fetch data when switching to content section
      if (sectionId === 'content') {
        // Initialize the content tab based on which tab was previously selected,
        // or default to FAQ if none selected
        if (!activeContentCategory.value) {
          activeContentCategory.value = 'faq'
        }
        
        // Fetch appropriate data based on active content category
        if (activeContentCategory.value === 'faq') {
          fetchFaqs()
        } else if (activeContentCategory.value === 'announcements') {
          fetchAnnouncements()
        }
      }
    }

    const searchQuery = ref('')
    const userSearchQuery = ref('')
    const typeFilter = ref('all')
    const statusFilter = ref('all')
    const activeContentCategory = ref('faq')
    
    // Announcements pagination
    const currentPage = ref(1)
    const pageSize = ref(10)
    
    // FAQ pagination
    const faqCurrentPage = ref(1)
    const faqPageSize = ref(10)

    // Add watcher for content category changes
    watch(activeContentCategory, (newCategory) => {
      if (activeSection.value === 'content') {
        if (newCategory === 'faq' && faqs.value.length === 0) {
          fetchFaqs()
        } else if (newCategory === 'announcements' && announcements.value.length === 0) {
          fetchAnnouncements()
        }
      }
    })

    const resetFilters = () => {
      searchQuery.value = ''
      typeFilter.value = 'all'
      statusFilter.value = 'all'
    }

    // Filter users based on search query
    const filteredUsers = computed(() => {
      let filtered = [...users.value]
      
      // Apply search filter
      if (userSearchQuery.value.trim()) {
        const query = userSearchQuery.value.toLowerCase().trim()
        filtered = filtered.filter(user => 
          user.name?.toLowerCase().includes(query) ||
          user.email?.toLowerCase().includes(query) ||
          user.role?.toLowerCase().includes(query)
        )
      }
      
      return filtered
    })

    // Filter announcements based on search and filters
    const filteredAnnouncements = computed(() => {
      let filtered = [...announcements.value]
      
      // Apply search filter
      if (searchQuery.value.trim()) {
        const query = searchQuery.value.toLowerCase().trim()
        filtered = filtered.filter(announcement => 
          (announcement.title && announcement.title.toLowerCase().includes(query)) ||
          (announcement.content && announcement.content.toLowerCase().includes(query)) ||
          (announcement.author && announcement.author.toLowerCase().includes(query)) ||
          (announcement.type && announcement.type.toLowerCase().includes(query))
        )
      }
      
      // Apply type filter
      if (typeFilter.value !== 'all') {
        filtered = filtered.filter(announcement => announcement.type === typeFilter.value)
      }
      
      // Apply status filter
      if (statusFilter.value !== 'all') {
        const isActive = statusFilter.value === 'active'
        filtered = filtered.filter(announcement => announcement.active === isActive)
      }
      
      return filtered
    })

    const paginatedAnnouncements = computed(() => {
      const startIndex = (currentPage.value - 1) * parseInt(pageSize.value)
      const endIndex = startIndex + parseInt(pageSize.value)
      return filteredAnnouncements.value.slice(startIndex, endIndex)
    })

    const paginatedFaqs = computed(() => {
      const startIndex = (faqCurrentPage.value - 1) * parseInt(faqPageSize.value)
      const endIndex = startIndex + parseInt(faqPageSize.value)
      return faqs.value.slice(startIndex, endIndex)
    })

    const getCurrentIndex = (index) => {
      return (currentPage.value - 1) * parseInt(pageSize.value) + index
    }

    const validateAnnouncementContent = (content) => {
      if (!content || content.trim().length === 0) {
        return { valid: false, message: 'Announcement content cannot be empty' };
      }
      
      if (content.length > 2000) {
        return { valid: false, message: 'Announcement content cannot exceed 2000 characters' };
      }
      
      // Check for potentially broken HTML or odd characters
      const suspiciousPatterns = [
        /<[^>]*$/,  // Unclosed HTML tag
        /\u0000/    // Null byte character
      ];
      
      for (const pattern of suspiciousPatterns) {
        if (pattern.test(content)) {
          return { valid: false, message: 'Content contains invalid characters or formatting' };
        }
      }
      
      return { valid: true };
    };
    
    const saveAnnouncement = async () => {
      // Validate content before saving
      const validation = validateAnnouncementContent(selectedAnnouncement.value.content);
      if (!validation.valid) {
        errorMessage.value = validation.message;
        return;
      }
      
      // ... existing code ...
    }

    const faqSearchQuery = ref('')
    const faqCategoryFilter = ref('all')
    const faqStatusFilter = ref('all')
    const resetFaqFilters = () => {
      faqSearchQuery.value = ''
      faqCategoryFilter.value = 'all'
      faqStatusFilter.value = 'all'
    }

    const filteredFaqs = computed(() => {
      let filtered = [...faqs.value]
      
      // Apply search filter
      if (faqSearchQuery.value.trim()) {
        const query = faqSearchQuery.value.toLowerCase().trim()
        filtered = filtered.filter(faq => 
          (faq.question && faq.question.toLowerCase().includes(query)) ||
          (faq.answer && faq.answer.toLowerCase().includes(query)) ||
          (faq.category && faq.category.toLowerCase().includes(query))
        )
      }
      
      // Apply category filter
      if (faqCategoryFilter.value !== 'all') {
        filtered = filtered.filter(faq => faq.category === faqCategoryFilter.value)
      }
      
      // Apply status filter
      if (faqStatusFilter.value !== 'all') {
        const isActive = faqStatusFilter.value === 'active'
        filtered = filtered.filter(faq => faq.is_active === isActive)
      }
      
      return filtered
    })

    const previewFAQModal = ref(false)
    const previewFAQData = ref(null)
    const previewFAQ = (faq) => {
      previewFAQData.value = { ...faq }
      previewFAQModal.value = true
    }

    const duplicateFAQ = (index) => {
      const faq = faqs.value[index]
      faqs.value.push({
        ...faq,
        id: null,
        is_active: true,
        order: faqs.value.length
      })
    }

    const showDeleteFAQModal = ref(false)
    const isDeletingFAQ = ref(false)
    const faqToDeleteIndex = ref(null)
    const confirmDeleteFAQ = (index) => {
      const faq = faqs.value[index]
      previewFAQData.value = faq
      faqToDeleteIndex.value = index
      showDeleteFAQModal.value = true
    }

    const deleteFAQ = async () => {
      if (faqToDeleteIndex.value !== null) {
        await removeFAQ(faqToDeleteIndex.value)
        showDeleteFAQModal.value = false
        faqToDeleteIndex.value = null
      }
    }

    const isAnswerNearLimit = (answer) => {
      return answer && answer.length >= 900 && answer.length < 1000
    }

    const isAnswerOverLimit = (answer) => {
      return answer && answer.length >= 1000
    }

    // Validate FAQ data before saving
    const validateFaq = (faq) => {
      const errors = []
      
      if (!faq.question || !faq.question.trim()) {
        errors.push('Question is required')
      }
      
      if (!faq.answer || !faq.answer.trim()) {
        errors.push('Answer is required')
      }
      
      if (!faq.category || !faq.category.trim()) {
        errors.push('Category is required')
      } else if (faq.category.length > 100) {
        errors.push('Category must be 100 characters or less')
      }
      
      if (faq.icon && faq.icon.length > 50) {
        errors.push('Icon class must be 50 characters or less')
      }
      
      return errors
    }

    // Check if there are any validation errors before saving
    const hasValidationErrors = computed(() => {
      return faqs.value.some(faq => {
        const errors = validateFaq(faq)
        return errors.length > 0
      })
    })

    // Consolidated onMounted hook - fetch all initial data
    onMounted(() => {
      console.log('Settings component mounted, fetching initial data...')
      fetchUsers()
      fetchFaqs()
      fetchAnnouncements()
      fetchSecuritySettings()
      fetchActiveSessions()
      fetchLoginLogs()
    })

    return {
      activeSection,
      sections,
      settings,
      timezones,
      dateFormats,
      userTableHeaders,
      users,
      userSearchQuery,
      filteredUsers,
      isLoadingUsers,
      getStatusClass,
      saveChanges,
      showUserModal,
      showDeleteModal,
      editingUser,
      userForm,
      isLoading,
      openAddUserModal,
      editUser,
      closeUserModal,
      saveUser,
      deleteUser,
      cancelDelete,
      confirmDelete,
      faqCategories,
      faqs,
      isLoadingFaqs,
      addNewFAQ,
      removeFAQ,
      moveFAQ,
      addNewCategory,
      removeCategory,
      saveFaqChanges,
      announcements,
      isLoadingAnnouncements,
      addNewAnnouncement,
      removeAnnouncement,
      saveAnnouncementChanges,
      switchSection,
      autoResizeTextarea,
      previewAnnouncementModal,
      previewData,
      previewAnnouncement,
      duplicateAnnouncement,
      handleImageUpload,
      showDeleteAnnouncementModal,
      isDeleting,
      deleteAnnouncement,
      hasAnnouncementChanges,
      getAnnouncementTypeClass,
      isContentNearLimit,
      isContentOverLimit,
      formatDate,
      confirmDeleteAnnouncement,
      announcementToDeleteIndex,
      announcementStore,
      searchQuery,
      typeFilter,
      statusFilter,
      resetFilters,
      activeContentCategory,
      currentPage,
      pageSize,
      faqCurrentPage,
      faqPageSize,
      filteredAnnouncements,
      paginatedAnnouncements,
      paginatedFaqs,
      getCurrentIndex,
      validateAnnouncementContent,
      saveAnnouncement,
      faqSearchQuery,
      faqCategoryFilter,
      faqStatusFilter,
      resetFaqFilters,
      filteredFaqs,
      previewFAQModal,
      previewFAQData,
      previewFAQ,
      duplicateFAQ,
      showDeleteFAQModal,
      isDeletingFAQ,
      faqToDeleteIndex,
      confirmDeleteFAQ,
      deleteFAQ,
      isAnswerNearLimit,
      isAnswerOverLimit,
      validateFaq,
      hasValidationErrors,
      // Notification settings
      notificationSettings,
      fetchNotificationSettings,
      saveNotificationSettings,
      // Security settings
      securitySettings,
      activeSessions,
      loginLogs,
      isLoadingSessions,
      isLoadingLogs,
      isLoadingRecovery,
      showPasswordModal,
      isLoadingPassword,
      passwordForm,
      passwordValidation,
      isPasswordValid,
      openPasswordModal,
      closePasswordModal,
      changePassword,
      validatePassword,
      fetchActiveSessions,
      getDeviceIcon,
      getSessionStatusClass,
      formatLastActive,
      terminateSession,
      logoutAllOtherSessions,
      loginLogsCurrentPage,
      loginLogsPageSize,
      fetchLoginLogs,
      paginatedLoginLogs,
      totalLoginLogsPages,
      previousLoginLogsPage,
      nextLoginLogsPage,
      formatDateTime,
      getLoginStatusClass,
      exportLoginLogs,
      fetchSecuritySettings,
      saveSecuritySettings,
      updateRecoveryEmail,
      saveSecurityQuestions
    }
  }
}
</script> 

<style>
/* Toggle switch styles */
.toggle-checkbox:checked {
  right: 0;
  border-color: #db2777;
}
.toggle-checkbox:checked + .toggle-label {
  background-color: #db2777;
}
.toggle-checkbox {
  right: 0;
  transition: all 0.3s;
}
.toggle-label {
  transition: all 0.3s;
}

/* Content character count styles */
.text-amber-500 {
  color: #f59e0b;
}
.text-red-500 {
  color: #ef4444;
}
.border-amber-400 {
  border-color: #fbbf24;
}
.border-red-500 {
  border-color: #ef4444;
}

/* Animation for added elements */
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

.animate-fade-in {
  animation: fadeIn 0.3s ease-out forwards;
}

/* Card hover effects */
.card-hover {
  transition: all 0.3s ease;
}
.card-hover:hover {
  transform: translateY(-2px);
  box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
}
</style>