<template>
  <div class="bg-gray-50 min-h-screen">
    <!-- Header Banner -->
    <section class="relative min-h-[500px] flex items-center py-20 sm:py-28 md:py-32 overflow-hidden">
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
                  Help Center
                </span>
              </div>
              
              <h1 class="text-4xl sm:text-5xl md:text-6xl font-extrabold text-white mb-6 leading-tight">
                Frequently Asked <span class="text-transparent bg-clip-text bg-gradient-to-r from-crimson-300 to-pink-300">Questions</span>
              </h1>
              
              <p class="text-lg sm:text-xl text-gray-200 max-w-xl mb-8 leading-relaxed">
                Find answers to common questions about our exam scheduling system and application process
              </p>
            </div>
          </div>
        </div>
      </div>
    </section>
    
    <div class="max-w-5xl mx-auto px-4 py-12">
      <!-- Search bar -->
      <div class="mb-8">
        <div class="relative max-w-xl mx-auto">
          <input
            v-model="searchQuery"
            type="text"
            placeholder="Search for questions or answers..."
            class="w-full px-4 py-3 pl-12 bg-white border border-gray-200 rounded-xl focus:ring-2 focus:ring-crimson-500 focus:border-crimson-500 shadow-sm"
          />
          <i class="fas fa-search absolute left-4 top-1/2 transform -translate-y-1/2 text-gray-400"></i>
          <button 
            v-if="searchQuery" 
            @click="searchQuery = ''" 
            class="absolute right-4 top-1/2 transform -translate-y-1/2 text-gray-400 hover:text-crimson-600"
          >
            <i class="fas fa-times"></i>
          </button>
        </div>
      </div>
      
      <!-- Category Tabs - Updated to pill style -->
      <div class="mb-10">
        <div class="flex flex-wrap gap-2 justify-center mb-6">
          <button
            v-for="(category, index) in categories"
            :key="index"
            @click="activeCategory = category.id"
            class="px-4 py-2 rounded-full text-sm font-medium transition-colors flex items-center"
            :class="[
              activeCategory === category.id 
                ? getCategoryActiveClass(category.id)
                : 'bg-white text-gray-600 hover:bg-gray-100 border border-gray-200'
            ]"
          >
            <i :class="['mr-2', category.icon]"></i>
            {{ category.name }}
          </button>
        </div>
      </div>
      
      <!-- Loading state -->
      <div v-if="isLoading" class="text-center py-16 animate-fade-in">
        <div class="inline-flex items-center justify-center w-16 h-16 rounded-full bg-gray-100 text-crimson-600 mb-4">
          <i class="fas fa-spinner fa-spin text-2xl"></i>
        </div>
        <h3 class="text-xl font-medium text-gray-800 mb-2">Loading FAQs...</h3>
        <p class="text-gray-500 max-w-md mx-auto">Please wait while we fetch the latest frequently asked questions.</p>
      </div>
      
      <!-- Error state -->
      <div v-else-if="error" class="text-center py-16 bg-white rounded-xl shadow-sm border border-gray-100 animate-fade-in">
        <div class="inline-flex items-center justify-center w-16 h-16 rounded-full bg-red-100 text-red-600 mb-4">
          <i class="fas fa-exclamation-triangle text-xl"></i>
        </div>
        <h3 class="text-xl font-medium text-gray-800 mb-2">Something went wrong</h3>
        <p class="text-gray-500 max-w-md mx-auto mb-6">{{ error }}</p>
        <button 
          @click="fetchFaqs" 
          class="inline-flex items-center px-4 py-2 bg-crimson-600 hover:bg-crimson-700 text-white rounded-lg text-sm"
        >
          <i class="fas fa-sync-alt mr-2"></i> Try Again
        </button>
      </div>
      
      <!-- FAQ Items -->
      <div v-else-if="filteredFaqs.length > 0" class="animate-fade-in">
        <div class="space-y-5 max-w-3xl mx-auto">
          <div 
            v-for="(faq, index) in filteredFaqs" 
            :key="faq.id" 
            class="bg-white rounded-xl shadow-md overflow-hidden border border-gray-100 transition-all duration-300 hover:shadow-lg faq-card"
            :class="[
              `faq-card-${index % 3 + 1}`,
              { 'faq-expanded': activeFaqId === faq.id }
            ]"
            @click="toggleFaq(faq.id)"
          >
            <div 
              class="w-full flex justify-between items-center p-6 text-left focus:outline-none cursor-pointer group"
            >
              <div class="flex items-center">
                <div class="mr-4 flex-shrink-0 w-10 h-10 rounded-xl flex items-center justify-center shadow-sm"
                     :class="getFaqIconClass(faq.category, index)">
                  <i :class="[faq.icon || getCategoryIcon(faq.category, index), 'text-sm']"></i>
                </div>
                <h3 class="text-lg font-semibold group-hover:text-crimson-600 transition-colors duration-300" 
                    :class="{'text-crimson-600': activeFaqId === faq.id}">
                  {{ faq.question }}
                </h3>
              </div>
              <span class="ml-4 flex-shrink-0 text-gray-400 group-hover:text-crimson-600 transition-colors duration-300">
                <i class="fas fa-chevron-down transform group-hover:rotate-180 transition-transform duration-300"
                   :class="{'rotate-180': activeFaqId === faq.id}"></i>
              </span>
            </div>
            
            <!-- Answer panel with max-height animation -->
            <div class="overflow-hidden transition-all duration-300 px-6"
                 :class="{'max-h-0': activeFaqId !== faq.id, 'max-h-[500px]': activeFaqId === faq.id}">
              <div class="py-5 border-t border-gray-100">
                <div class="prose prose-crimson max-w-none text-gray-600" v-html="faq.answer"></div>
                
                <div v-if="faq.helpfulLinks && faq.helpfulLinks.length > 0" class="mt-4 pt-4 border-t border-gray-100">
                  <p class="text-sm font-medium text-gray-600 mb-2">Helpful Resources:</p>
                  <div class="flex flex-wrap gap-2">
                    <a 
                      v-for="(link, linkIndex) in faq.helpfulLinks" 
                      :key="linkIndex" 
                      :href="link.url" 
                      class="inline-flex items-center px-3 py-1 rounded-full text-sm bg-gray-100 text-gray-700 hover:bg-crimson-50 hover:text-crimson-600 transition-colors duration-200"
                    >
                      <i :class="['mr-1 text-xs', link.icon]"></i>
                      {{ link.text }}
                    </a>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
        
        <!-- "View more" button styled like in Home.vue -->
        <div class="text-center mt-12" v-if="filteredFaqs.length > 6 && activeCategory === 'all' && !searchQuery">
          <button
            @click="loadMoreFaqs"
            class="inline-flex items-center gap-2 px-6 py-3 bg-white text-gray-700 rounded-lg font-medium shadow-sm hover:bg-gray-50 transition-all duration-300 transform hover:-translate-y-1 border border-gray-200 group"
          >
            <span>Load More FAQs</span>
            <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 text-gray-500 group-hover:text-gray-700 transform group-hover:translate-y-1 transition-all duration-300" viewBox="0 0 20 20" fill="currentColor">
              <path fill-rule="evenodd" d="M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z" clip-rule="evenodd" />
            </svg>
          </button>
        </div>
      </div>
      
      <!-- No Results Message -->
      <div v-else class="text-center py-16 bg-white rounded-xl shadow-sm border border-gray-100 animate-fade-in">
        <div class="inline-flex items-center justify-center w-16 h-16 rounded-full bg-gray-100 text-gray-400 mb-4">
          <i class="fas fa-search text-xl"></i>
        </div>
        <h3 class="text-xl font-medium text-gray-800 mb-2">No results found</h3>
        <p class="text-gray-500 max-w-md mx-auto" v-if="searchQuery">
          We couldn't find any questions matching "{{ searchQuery }}". Try using different keywords or browse categories.
        </p>
        <p class="text-gray-500 max-w-md mx-auto" v-else>
          No FAQs available for this category. Please try another category.
        </p>
        <div class="mt-6 flex flex-wrap gap-3 justify-center">
          <button 
            v-if="searchQuery" 
            @click="searchQuery = ''" 
            class="inline-flex items-center px-4 py-2 bg-gray-200 hover:bg-gray-300 text-gray-700 rounded-lg text-sm"
          >
            <i class="fas fa-times mr-2"></i> Clear Search
          </button>
          <button 
            v-if="activeCategory !== 'all'" 
            @click="activeCategory = 'all'" 
            class="inline-flex items-center px-4 py-2 bg-crimson-600 hover:bg-crimson-700 text-white rounded-lg text-sm"
          >
            <i class="fas fa-th-large mr-2"></i> Show All FAQs
          </button>
        </div>
      </div>
      
      <!-- Back to top button -->
      <div class="fixed bottom-8 right-8" v-if="showBackToTop">
        <button
          @click="scrollToTop"
          class="w-12 h-12 bg-crimson-600 text-white rounded-full shadow-lg flex items-center justify-center hover:bg-crimson-700 transition-colors"
        >
          <i class="fas fa-arrow-up"></i>
        </button>
      </div>
    </div>
  </div>
</template>

<script>
import { ref, computed, onMounted, onUnmounted } from 'vue'
import axiosInstance from '../services/axios.interceptor'

const API_URL = import.meta.env.VITE_API_URL;
const API_ENDPOINT = `${API_URL}api/`;

export default {
  name: 'FAQ',
  setup() {
    const searchQuery = ref('')
    const activeCategory = ref('all')
    const activeFaqId = ref(null)
    const isLoading = ref(true)
    const error = ref(null)
    const faqs = ref([])
    const showBackToTop = ref(false)
    
    const categories = [
      { id: 'all', name: 'All Questions', icon: 'fas fa-th-large' },
      { id: 'General', name: 'General', icon: 'fas fa-info-circle' },
      { id: 'Scheduling', name: 'Scheduling', icon: 'fas fa-calendar-alt' },
      { id: 'Requirements', name: 'Requirements', icon: 'fas fa-clipboard-list' },
      { id: 'Payment', name: 'Payment', icon: 'fas fa-credit-card' },
      { id: 'Technical', name: 'Technical', icon: 'fas fa-cog' }
    ]
    
    const filteredFaqs = computed(() => {
      let results = faqs.value;
      
      // Filter by category
      if (activeCategory.value !== 'all') {
        results = results.filter(faq => faq.category === activeCategory.value);
      }
      
      // Filter by search query
      if (searchQuery.value.trim()) {
        const query = searchQuery.value.toLowerCase().trim();
        results = results.filter(faq => 
          faq.question.toLowerCase().includes(query) || 
          faq.answer.toLowerCase().includes(query)
        );
      }
      
      // Limit by visible count when not searching or filtering by category
      if (activeCategory.value === 'all' && !searchQuery.value.trim()) {
        return results.slice(0, visibleFaqCount.value);
      }
      
      return results;
    })
    
    const toggleFaq = (id) => {
      if (activeFaqId.value === id) {
        activeFaqId.value = null;
      } else {
        activeFaqId.value = id;
      }
    }
    
    const fetchFaqs = async () => {
      isLoading.value = true;
      error.value = null;
      
      try {
        const response = await axiosInstance.get(API_ENDPOINT + 'admin/faqs/');
        faqs.value = response.data.filter(faq => faq.is_active).map(faq => {
          // Add helpful links for some FAQs as an example
          if (faq.category === 'Scheduling') {
            faq.helpfulLinks = [
              { text: 'Scheduling Guide', url: '#', icon: 'fas fa-book' },
              { text: 'Calendar', url: '#', icon: 'fas fa-calendar' }
            ];
          }
          return faq;
        });
      } catch (err) {
        console.error('Failed to fetch FAQs:', err);
        error.value = 'Failed to load FAQs. Please try again later.';
      } finally {
        isLoading.value = false;
      }
    }
    
    const getCategoryActiveClass = (categoryId) => {
      const classes = {
        'all': 'bg-crimson-600 text-white',
        'General': 'bg-blue-600 text-white',
        'Scheduling': 'bg-green-600 text-white',
        'Requirements': 'bg-purple-600 text-white',
        'Payment': 'bg-amber-600 text-white',
        'Technical': 'bg-gray-700 text-white'
      }
      return classes[categoryId] || 'bg-crimson-600 text-white';
    }
    
    const scrollToTop = () => {
      window.scrollTo({
        top: 0,
        behavior: 'smooth'
      });
    }
    
    const handleScroll = () => {
      showBackToTop.value = window.scrollY > 500;
    }
    
    const getCategoryIcon = (category, index) => {
      const icons = {
        'General': 'fas fa-info-circle',
        'Scheduling': 'fas fa-calendar-alt',
        'Requirements': 'fas fa-clipboard-list',
        'Payment': 'fas fa-credit-card',
        'Technical': 'fas fa-cog'
      }
      
      // Default icons if category doesn't match
      const defaultIcons = [
        'fas fa-question',
        'fas fa-id-card',
        'fas fa-lightbulb'
      ]
      
      return icons[category] || defaultIcons[index % defaultIcons.length]
    }
    
    const getFaqIconClass = (category, index) => {
      // Background colors for different categories
      const bgClasses = {
        'General': 'bg-crimson-100 text-crimson-600 group-hover:bg-crimson-50',
        'Scheduling': 'bg-blue-100 text-blue-600 group-hover:bg-blue-50',
        'Requirements': 'bg-purple-100 text-purple-600 group-hover:bg-purple-50',
        'Payment': 'bg-green-100 text-green-600 group-hover:bg-green-50',
        'Technical': 'bg-amber-100 text-amber-600 group-hover:bg-amber-50'
      }
      
      // Default colors for when category doesn't match
      const defaultClasses = [
        'bg-crimson-100 text-crimson-600 group-hover:bg-crimson-50',
        'bg-blue-100 text-blue-600 group-hover:bg-blue-50',
        'bg-green-100 text-green-600 group-hover:bg-green-50'
      ]
      
      return bgClasses[category] || defaultClasses[index % defaultClasses.length]
    }
    
    const visibleFaqCount = ref(6)
    const loadMoreFaqs = () => {
      visibleFaqCount.value += 6
    }
    
    onMounted(() => {
      fetchFaqs();
      window.addEventListener('scroll', handleScroll);
    })
    
    onUnmounted(() => {
      window.removeEventListener('scroll', handleScroll);
    })
    
    return {
      searchQuery,
      activeCategory,
      activeFaqId,
      categories,
      faqs,
      filteredFaqs,
      isLoading,
      error,
      showBackToTop,
      toggleFaq,
      fetchFaqs,
      getCategoryActiveClass,
      scrollToTop,
      getCategoryIcon,
      getFaqIconClass,
      loadMoreFaqs
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

@keyframes fadeIn {
  from {
    opacity: 0;
  }
  to {
    opacity: 1;
  }
}

.animate-fade-in-up {
  animation: fadeInUp 0.6s ease-out forwards;
}

.animate-fade-in {
  animation: fadeIn 0.4s ease-out forwards;
}

/* FAQ card animations from Home.vue */
.faq-card {
  animation: fadeIn 0.6s ease-out forwards;
  cursor: pointer;
  position: relative;
  overflow: hidden;
}

.faq-card:after {
  content: '';
  position: absolute;
  top: 0;
  right: 0;
  width: 5px;
  height: 0;
  transition: height 0.3s ease;
}

.faq-card-1:after {
  background: linear-gradient(to bottom, #dc2626, #ef4444);
}

.faq-card-2:after {
  background: linear-gradient(to bottom, #2563eb, #3b82f6);
}

.faq-card-3:after {
  background: linear-gradient(to bottom, #16a34a, #22c55e);
}

.faq-card:hover:after {
  height: 100%;
}

.faq-card-1 {
  animation-delay: 0.2s;
}

.faq-card-2 {
  animation-delay: 0.4s;
}

.faq-card-3 {
  animation-delay: 0.6s;
}

/* Ensure consistent background handling */
.bg-cover {
  background-size: cover;
}
.bg-center {
  background-position: center;
}
.bg-no-repeat {
  background-repeat: no-repeat;
}

/* Gradient text support */
.bg-clip-text {
  -webkit-background-clip: text;
  background-clip: text;
}

/* Styling for accordions */
.prose p {
  margin-bottom: 1rem;
}
.prose strong {
  font-weight: 600;
  color: #111827;
}
.prose a {
  color: #dc2626;
  text-decoration: none;
}
.prose a:hover {
  text-decoration: underline;
}
.prose ol, .prose ul {
  margin-bottom: 1rem;
}

/* Make filter tabs responsive */
@media (max-width: 640px) {
  .flex.flex-wrap.gap-2.justify-center button {
    margin-bottom: 0.5rem;
    padding: 0.5rem 0.75rem;
    font-size: 0.75rem;
  }
  
  /* Adjust card styles for mobile */
  .faq-card h3 {
    font-size: 1rem;
  }
  
  .faq-card .mr-4 {
    margin-right: 0.75rem;
  }
  
  .w-10.h-10 {
    width: 2rem;
    height: 2rem;
  }
}
</style> 