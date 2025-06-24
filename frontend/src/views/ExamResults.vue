<template>
  <div class="min-h-screen bg-gray-50">
    <!-- Header Banner -->
    <section class="relative min-h-[600px] flex items-center py-20 sm:py-28 md:py-32 mb-10 overflow-hidden">
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
                  Examination Results
                </span>
              </div>
              
              <h1 class="text-4xl sm:text-5xl md:text-6xl font-extrabold text-white mb-6 leading-tight">
                List of <span class="text-transparent bg-clip-text bg-gradient-to-r from-crimson-300 to-pink-300">Successful</span> Examinees
              </h1>
              
              <p class="text-lg sm:text-xl text-gray-200 max-w-xl mb-8 leading-relaxed">
                Congratulations to all successful examinees! Select an examination type below to view the complete list of passers.
              </p>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- Exam Type Tabs -->
    <div class="container mx-auto px-4 mb-8 relative z-20">
      <div class="bg-white rounded-xl shadow-lg p-3">
        <!-- Loading State -->
        <div v-if="loading" class="text-center py-4">
          <div class="inline-block animate-spin rounded-full h-8 w-8 border-4 border-crimson-600 border-t-transparent"></div>
          <p class="mt-2 text-gray-600">Loading program codes...</p>
        </div>
        
        <!-- Error State -->
        <div v-else-if="error" class="bg-red-50 border border-red-200 rounded-lg p-4 mb-4">
          <div class="flex items-center">
            <i class="fas fa-exclamation-circle text-red-500 mr-2"></i>
            <p class="text-red-700">{{ error }}</p>
          </div>
        </div>
        
        <!-- Exam Types -->
        <div v-else class="flex flex-wrap gap-2 justify-center">
          <button 
            v-for="exam in examTypes" 
            :key="exam.value" 
            @click="selectedExamType = exam.value"
            class="relative px-4 py-2 rounded-lg text-sm font-medium flex items-center gap-2 transition-all duration-300 min-w-[140px] justify-center group overflow-hidden"
            :class="selectedExamType === exam.value ? 
              'bg-crimson-600 text-white shadow-sm' : 
              'bg-gray-50 text-gray-700 hover:bg-gray-100'"
          >
            <div class="absolute inset-0 bg-gradient-to-r from-crimson-600 to-crimson-700 opacity-0 group-hover:opacity-100 transition-opacity duration-300"></div>
            <i :class="[exam.icon, 'text-base relative z-10', selectedExamType === exam.value ? 'text-white' : 'text-crimson-600 group-hover:text-white']"></i>
            <span class="relative z-10">{{ exam.label }}</span>
            <div class="absolute inset-0 border border-crimson-600 rounded-lg opacity-0 group-hover:opacity-100 transition-opacity duration-300"></div>
          </button>
        </div>
      </div>
    </div>

    <div class="container mx-auto px-4 mb-12">
      <div class="bg-white rounded-xl shadow-lg overflow-hidden border border-gray-200">
        <!-- Header with stats -->
        <div class="px-6 py-6 bg-gradient-to-r from-crimson-600 to-crimson-700">
          <div class="flex flex-col md:flex-row justify-between items-center gap-4">
            <div>              <h2 class="text-2xl font-bold text-white flex items-center">
                <i :class="[getExamTypeIcon(selectedExamType), 'mr-3 text-crimson-200']"></i>
                {{ selectedExamType }} Examination Passers {{ selectedYear ? '(' + selectedYear + ')' : '' }}
              </h2>
              <p class="text-crimson-100 mt-1">Congratulations to all successful examinees!</p>
            </div>
            <div class="flex gap-4">
              <div class="bg-white/10 backdrop-blur-sm rounded-lg px-4 py-2 text-center">
                <div class="text-2xl font-bold text-white">{{ filteredPassers.length }}</div>
                <div class="text-xs text-crimson-100 uppercase tracking-wider">Total Passers</div>
              </div>
              <!-- Add refresh button -->
              <button 
                @click="refreshFromAPI" 
                class="bg-white/10 backdrop-blur-sm rounded-lg px-4 py-2 text-center hover:bg-white/20 transition-colors flex items-center gap-2"
                :disabled="loading"
              >
                <i class="fas fa-sync-alt" :class="{ 'animate-spin': loading }"></i>
                <span class="text-xs text-crimson-100 uppercase tracking-wider">Refresh Data</span>
              </button>
            </div>
          </div>
        </div>

        <!-- Search and Filter Bar -->
        <div class="p-6 border-b border-gray-200 bg-gray-50/50">
          <div class="flex flex-col lg:flex-row gap-6">
            <!-- Search Box -->
            <div class="flex-1">
              <label class="block text-sm font-medium text-gray-700 mb-2">Search Passers</label>
              <div class="relative">
                <input
                  v-model="searchQuery"
                  type="text"
                  placeholder="Search by name, school, or application number..."
                  class="w-full pl-11 pr-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-crimson-500 focus:border-crimson-500 shadow-sm"
                >
                <i class="fas fa-search absolute left-4 top-1/2 transform -translate-y-1/2 text-gray-400"></i>
              </div>
            </div>
              <!-- Filters Group -->
            <div class="flex flex-col sm:flex-row gap-4 lg:w-auto">
              <!-- Year Filter -->
              <div class="min-w-[140px]">
                <label class="block text-sm font-medium text-gray-700 mb-2">Filter by Year</label>
                <select
                  v-model="selectedYear"
                  class="w-full border border-gray-300 rounded-lg px-3 py-3 focus:ring-2 focus:ring-crimson-500 focus:border-crimson-500 shadow-sm"
                >
                  <option value="">All Years</option>
                  <option v-for="year in availableYears" :key="year" :value="year">{{ year }}</option>
                </select>
              </div>
              
              <!-- Records per page -->
              <div class="min-w-[140px]">
                <label class="block text-sm font-medium text-gray-700 mb-2">Records per page</label>
                <select 
                  v-model="itemsPerPage" 
                  class="w-full border border-gray-300 rounded-lg px-3 py-3 focus:ring-2 focus:ring-crimson-500 focus:border-crimson-500 shadow-sm"
                >
                  <option value="10">10 records</option>
                  <option value="25">25 records</option>
                  <option value="50">50 records</option>
                  <option value="100">100 records</option>
                </select>
              </div>
            </div>
          </div>

          <!-- Alphabet Filter -->
          <div class="mt-6">
            <label class="block text-sm font-medium text-gray-700 mb-3">Filter by First Letter</label>
            <div class="flex flex-wrap gap-1">
              <button 
                @click="selectedLetter = null" 
                class="min-w-[36px] h-9 rounded-md flex items-center justify-center text-sm font-medium transition-all duration-200"
                :class="selectedLetter === null ? 
                  'bg-crimson-600 text-white shadow-sm' : 
                  'bg-white text-gray-700 border border-gray-300 hover:bg-gray-50'"
              >
                All
              </button>
              <button 
                v-for="letter in alphabet" 
                :key="letter" 
                @click="selectedLetter = letter"
                class="min-w-[36px] h-9 rounded-md flex items-center justify-center text-sm font-medium transition-all duration-200"
                :class="selectedLetter === letter ? 
                  'bg-crimson-600 text-white shadow-sm' : 
                  'bg-white text-gray-700 border border-gray-300 hover:bg-gray-50'"
              >
                {{ letter }}
              </button>
            </div>
          </div>
        </div>

        <!-- Results Table -->
        <div class="overflow-x-auto">
          <table class="min-w-full divide-y divide-gray-200">
            <thead class="bg-gray-50">
              <tr>
                <th class="px-6 py-4 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  NO
                </th>
                <th class="px-6 py-4 text-left text-xs font-medium text-gray-500 uppercase tracking-wider cursor-pointer select-none group"
                    @click="sortBy('appNo')">
                  <div class="flex items-center">
                    Application No.
                    <i :class="[getSortIcon('appNo'), 'ml-1 group-hover:opacity-100', sortColumn === 'appNo' ? 'opacity-100' : 'opacity-0']"></i>
                  </div>
                </th>
                <th class="px-6 py-4 text-left text-xs font-medium text-gray-500 uppercase tracking-wider cursor-pointer select-none group"
                    @click="sortBy('name')">
                  <div class="flex items-center">
                    Name
                    <i :class="[getSortIcon('name'), 'ml-1 group-hover:opacity-100', sortColumn === 'name' ? 'opacity-100' : 'opacity-0']"></i>
                  </div>
                </th>
                <th class="px-6 py-4 text-left text-xs font-medium text-gray-500 uppercase tracking-wider cursor-pointer select-none group"
                    @click="sortBy('school')">
                  <div class="flex items-center">
                    School
                    <i :class="[getSortIcon('school'), 'ml-1 group-hover:opacity-100', sortColumn === 'school' ? 'opacity-100' : 'opacity-0']"></i>
                  </div>
                </th>
              </tr>
            </thead>
            <tbody class="bg-white divide-y divide-gray-200">
              <tr v-for="(passer, index) in paginatedAndFilteredPassers" :key="passer.id || index" 
                  class="hover:bg-gray-50 transition-colors duration-150">
                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                  {{ passer.no || (currentPage - 1) * itemsPerPage + index + 1 }}
                </td>
                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                  {{ passer.appNo }}
                </td>
                <td class="px-6 py-4 whitespace-nowrap">
                  <div class="text-sm font-medium text-gray-900">{{ passer.name }}</div>
                </td>
                <td class="px-6 py-4 whitespace-nowrap">
                  <div class="text-sm text-gray-500">{{ passer.school }}</div>
                </td>
              </tr>
            </tbody>
          </table>
        </div>

        <!-- No Results Message -->
        <div v-if="paginatedAndFilteredPassers.length === 0" class="text-center py-12">
          <div class="inline-flex items-center justify-center w-16 h-16 rounded-full bg-gray-100 text-gray-400 mb-4">
            <i class="fas fa-search text-xl"></i>
          </div>
          <h3 class="text-lg font-medium text-gray-900 mb-2">No results found</h3>
          <p class="text-gray-500 max-w-sm mx-auto">
            Try adjusting your search or filter criteria to find what you're looking for.
          </p>
        </div>

        <!-- Pagination Controls -->
        <div class="px-6 py-4 bg-gray-50 border-t border-gray-200">
          <div class="flex flex-col sm:flex-row justify-between items-center gap-4">
            <div class="text-sm text-gray-700">
              Showing <span class="font-medium">{{ paginationInfo.from }}</span> to <span class="font-medium">{{ paginationInfo.to }}</span> of <span class="font-medium">{{ filteredPassers.length }}</span> results
            </div>
            <div class="flex items-center gap-2">
              <button
                @click="currentPage = 1"
                :disabled="currentPage === 1"
                class="px-3 py-1 rounded border transition-colors duration-200"
                :class="currentPage === 1 ? 'bg-gray-100 text-gray-400 cursor-not-allowed' : 'bg-white text-gray-700 hover:bg-gray-50'"
              >
                <i class="fas fa-angle-double-left"></i>
              </button>
              <button
                @click="currentPage--"
                :disabled="currentPage === 1"
                class="px-3 py-1 rounded border transition-colors duration-200"
                :class="currentPage === 1 ? 'bg-gray-100 text-gray-400 cursor-not-allowed' : 'bg-white text-gray-700 hover:bg-gray-50'"
              >
                <i class="fas fa-angle-left"></i>
              </button>
              
              <div class="flex items-center gap-1">
                <template v-for="page in displayedPages" :key="page">
                  <button
                    v-if="page !== '...'"
                    @click="currentPage = page"
                    class="px-3 py-1 rounded border transition-colors duration-200"
                    :class="currentPage === page ? 'bg-crimson-600 text-white border-crimson-600 shadow-sm' : 'bg-white text-gray-700 hover:bg-gray-50'"
                  >
                    {{ page }}
                  </button>
                  <span v-else class="px-2 text-gray-400">...</span>
                </template>
              </div>

              <button
                @click="currentPage++"
                :disabled="currentPage === totalPages"
                class="px-3 py-1 rounded border transition-colors duration-200"
                :class="currentPage === totalPages ? 'bg-gray-100 text-gray-400 cursor-not-allowed' : 'bg-white text-gray-700 hover:bg-gray-50'"
              >
                <i class="fas fa-angle-right"></i>
              </button>
              <button
                @click="currentPage = totalPages"
                :disabled="currentPage === totalPages"
                class="px-3 py-1 rounded border transition-colors duration-200"
                :class="currentPage === totalPages ? 'bg-gray-100 text-gray-400 cursor-not-allowed' : 'bg-white text-gray-700 hover:bg-gray-50'"
              >
                <i class="fas fa-angle-double-right"></i>
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
  name: 'ExamResults',
  data() {
    return {
      searchQuery: '',
      currentPage: 1,
      itemsPerPage: 25,
      sortColumn: 'appNo',
      sortDirection: 'asc',      selectedLetter: null,
      selectedExamType: '',
      selectedYear: '',
      availableYears: [], // Will be populated from API
      loading: false,
      error: null,
      alphabet: ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'],
      examTypes: [], // Will be populated from backend
      defaultIcons: {
        'LSAT': 'fas fa-balance-scale',
        'NAT': 'fas fa-graduation-cap',
        'EAT': 'fas fa-pencil-alt',
        'CET': 'fas fa-university',
        'LET': 'fas fa-chalkboard-teacher',
        'NLE': 'fas fa-user-nurse',
        'CLE': 'fas fa-gavel',
        'CPE': 'fas fa-user-md'
      },
      examPassers: [] // This will be populated from the API
    }
  },  computed: {
    filteredPassers() {
      let filtered = [...this.examPassers];
      
      // Apply exam type filter
      if (this.selectedExamType) {
        filtered = filtered.filter(passer => 
          passer.examType === this.selectedExamType
        );
      }      // Apply year filter
      if (this.selectedYear) {
        filtered = filtered.filter(passer => 
          passer.year === this.selectedYear
        );
      }
      
      // Apply letter filter
      if (this.selectedLetter) {
        filtered = filtered.filter(passer => 
          passer.name.charAt(0).toUpperCase() === this.selectedLetter
        );
      }
      
      // Apply search filter
      if (this.searchQuery.trim()) {
        const query = this.searchQuery.toLowerCase().trim();
        filtered = filtered.filter(passer => 
          passer.name.toLowerCase().includes(query) ||
          passer.school.toLowerCase().includes(query) ||
          passer.appNo.toLowerCase().includes(query)
        );
      }
      
      // Apply sorting
      filtered.sort((a, b) => {
        const aVal = a[this.sortColumn].toLowerCase();
        const bVal = b[this.sortColumn].toLowerCase();
        
        if (this.sortDirection === 'asc') {
          return aVal.localeCompare(bVal);
        } else {
          return bVal.localeCompare(aVal);
        }
      });
      
      return filtered;
    },
    
    paginatedAndFilteredPassers() {
      const start = (this.currentPage - 1) * this.itemsPerPage;
      const end = start + this.itemsPerPage;
      return this.filteredPassers.slice(start, end);
    },
    
    totalPages() {
      return Math.ceil(this.filteredPassers.length / this.itemsPerPage);
    },
    
    displayedPages() {
      const pages = [];
      const totalPages = this.totalPages;
      const current = this.currentPage;
      
      if (totalPages <= 7) {
        for (let i = 1; i <= totalPages; i++) {
          pages.push(i);
        }
      } else {
        pages.push(1);
        if (current > 3) {
          pages.push('...');
        }
        
        for (let i = Math.max(2, current - 1); i <= Math.min(current + 1, totalPages - 1); i++) {
          pages.push(i);
        }
        
        if (current < totalPages - 2) {
          pages.push('...');
        }
        pages.push(totalPages);
      }
      
      return pages;
    },
    
    paginationInfo() {
      const total = this.filteredPassers.length;
      const from = total === 0 ? 0 : (this.currentPage - 1) * this.itemsPerPage + 1;
      const to = Math.min(from + this.itemsPerPage - 1, total);
      
      return {
        from,
        to,
        total
      };
    }
  },
  methods: {    // Add method to load exam results from API
    async fetchExamResults(examType = null, forceRefresh = false) {
      this.loading = true;
      this.error = null;
      
      try {
        // Use the API URL from environment variables or fallback to localhost
        const apiUrl = import.meta.env.VITE_API_URL || 'http://localhost:8000';
        
        // Build the URL with query parameters
        let url = `${apiUrl}api/admin/results/`;
        const params = new URLSearchParams();
        
        if (examType) {
          params.append('exam_type', examType);
        }
        
        if (this.selectedYear) {
          params.append('exam_year', this.selectedYear);
        }
        
        // Add the parameters to the URL if there are any
        if (params.toString()) {
          url += `?${params.toString()}`;
        }
          
        const response = await axios.get(url);
        
        if (response.data && Array.isArray(response.data)) {
          this.examPassers = response.data;
          
          // If exam type was provided, select it
          if (examType) {
            this.selectedExamType = examType;
          }
          
          console.log('Loaded exam results from API:', this.examPassers);
        } else {
          console.error('Unexpected response format:', response.data);
          this.error = 'Invalid response format from server';
        }
      } catch (error) {
        console.error('Error fetching exam results:', error);
        this.error = 'Error fetching exam results. Please try again later.';
      } finally {
        this.loading = false;
      }
    },
    
    async fetchProgramCodes() {
      this.loading = true;
      this.error = null;
      try {
        // Use the API URL from environment variables or fallback to localhost
        const apiUrl = import.meta.env.VITE_API_URL || 'http://localhost:8000';
        const response = await axios.get(`${apiUrl}api/programs/`);
        console.log('API Response:', response.data); // Debug log
        
        if (response.data && Array.isArray(response.data)) {
          this.examTypes = response.data.map(program => ({
            value: program.code,
            label: `${program.code} - ${program.name}`,
            icon: this.getProgramIcon(program.code),
            activeClass: 'bg-crimson-600 text-white'
          }));
          
          // Set default selected exam type if available and not already set from imported data
          if (this.examTypes.length > 0 && !this.selectedExamType) {
            this.selectedExamType = this.examTypes[0].value;
            // Load results for the selected exam type
            this.fetchExamResults(this.selectedExamType);
          }
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
      }
    },
    
    // Fetch available exam years from API
    async fetchAvailableYears() {
      try {
        const apiUrl = import.meta.env.VITE_API_URL || 'http://localhost:8000';
        const response = await axios.get(`${apiUrl}/api/exam-years/`);
        
        if (response.data && Array.isArray(response.data)) {
          this.availableYears = response.data;
          
          // If no years are returned, generate some default ones
          if (this.availableYears.length === 0) {
            const currentYear = new Date().getFullYear();
            for (let year = currentYear; year >= currentYear - 5; year--) {
              this.availableYears.push(year.toString());
            }
          }
        }
      } catch (error) {
        console.error('Error fetching available years:', error);
        // Fallback to generating years if API fails
        const currentYear = new Date().getFullYear();
        this.availableYears = [];
        for (let year = currentYear; year >= currentYear - 5; year--) {
          this.availableYears.push(year.toString());
        }
      }
    },
    
    getProgramIcon(code) {
      return this.defaultIcons[code] || 'fas fa-file-alt';
    },
    
    sortBy(column) {
      if (this.sortColumn === column) {
        this.sortDirection = this.sortDirection === 'asc' ? 'desc' : 'asc';
      } else {
        this.sortColumn = column;
        this.sortDirection = 'asc';
      }
    },
    
    getSortIcon(column) {
      if (this.sortColumn !== column) {
        return 'fas fa-sort';
      }
      return this.sortDirection === 'asc' ? 'fas fa-sort-up' : 'fas fa-sort-down';
    },
    
    getExamTypeIcon(type) {
      // First try to find the icon in the examTypes array
      const examType = this.examTypes.find(exam => exam.value === type);
      if (examType && examType.icon) {
        return examType.icon;
      }
      
      // Fallback to defaultIcons
      return this.defaultIcons[type] || 'fas fa-file-alt';
    },
    
    refreshFromAPI() {
      // Force refresh from API rather than using localStorage
      this.fetchExamResults(this.selectedExamType, true);
    }
  },  created() {
    // Fetch results from the API
    this.fetchExamResults();
    
    // Then fetch program codes
    this.fetchProgramCodes();
      // Fetch available exam years from the API
    this.fetchAvailableYears();
  },watch: {
    searchQuery() {
      this.currentPage = 1;
    },
    itemsPerPage() {
      this.currentPage = 1;
    },    selectedLetter() {
      this.currentPage = 1;
    },
    selectedYear() {
      this.currentPage = 1;
      // Fetch new results when the year filter changes
      this.fetchExamResults(this.selectedExamType);
      // Fetch new results when the year filter changes
      this.fetchExamResults(this.selectedExamType);
    },
    selectedExamType(newValue, oldValue) {
      if (newValue !== oldValue) {
        this.currentPage = 1;
        this.selectedLetter = null; // Reset letter filter when changing exam type
        // Fetch new results based on the selected exam type
        this.fetchExamResults(newValue);
      }
    }
  }
}
</script>

<style scoped>
@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.animate-fade-in-up {
  animation: fadeInUp 0.6s ease-out forwards;
}

/* Add smooth transitions */
.transition-all {
  transition-property: all;
  transition-timing-function: cubic-bezier(0.4, 0, 0.2, 1);
  transition-duration: 150ms;
}

/* Improve button hover states */
button:not(:disabled):hover {
  transform: translateY(-1px);
}

/* Add subtle hover effect to table rows */
tr:hover td {
  background-color: rgba(249, 250, 251, 0.5);
}

/* Add shadow to exam type tabs on hover */
.exam-type-tab:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
}
</style>