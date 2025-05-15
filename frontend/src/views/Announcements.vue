<template>
  <div class="min-h-screen bg-gray-50">
    <!-- Header Banner -->
    <section class="relative min-h-[600px] flex items-center py-20 sm:py-28 md:py-32 overflow-hidden">
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
                  Latest Updates
                </span>
              </div>
              
              <h1 class="text-4xl sm:text-5xl md:text-6xl font-extrabold text-white mb-6 leading-tight">
                Stay Informed with Our <span class="text-transparent bg-clip-text bg-gradient-to-r from-crimson-300 to-pink-300">Latest</span> Announcements
              </h1>
              
              <p class="text-lg sm:text-xl text-gray-200 max-w-xl mb-8 leading-relaxed">
                Get the latest news, updates, and important information about our testing and evaluation services.
              </p>
            </div>
          </div>
        </div>
      </div>
    </section>
    
    <!-- Filter Tabs -->
    <div class="container mx-auto px-4 py-12">
      <div class="mb-8 flex flex-wrap gap-2 align-center justify-center">
        <button 
          @click="activeFilter = 'all'" 
          class="px-4 py-2 rounded-full text-sm font-medium transition-colors"
          :class="activeFilter === 'all' 
            ? 'bg-crimson-600 text-white' 
            : 'bg-white text-gray-600 hover:bg-gray-100 border border-gray-200'"
        >
          All
        </button>
        <button 
          v-for="type in announcementTypes.filter(t => t.value !== 'Passers')" 
          :key="type.value"
          @click="activeFilter = type.value" 
          class="px-4 py-2 rounded-full text-sm font-medium transition-colors flex items-center"
          :class="activeFilter === type.value 
            ? type.activeClass
            : 'bg-white text-gray-600 hover:bg-gray-100 border border-gray-200'"
        >
          <i :class="[type.icon, 'mr-2']"></i>
          {{ type.label }}
        </button>
      </div>
      
      <!-- Announcements Grid -->
      <div v-if="announcementStore.loading" class="flex justify-center py-12">
        <div class="animate-spin rounded-full h-12 w-12 border-t-2 border-b-2 border-blue-500"></div>
      </div>
      
      <div v-else-if="announcementStore.error" class="bg-red-50 border-l-4 border-red-400 p-4 mb-6">
        <div class="flex">
          <div class="flex-shrink-0">
            <svg class="h-5 w-5 text-red-400" fill="currentColor" viewBox="0 0 20 20">
              <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd" />
            </svg>
          </div>
          <div class="ml-3">
            <p class="text-sm text-red-700">{{ announcementStore.error }}</p>
          </div>
        </div>
      </div>
      
      <div v-else>
        <div v-if="filteredAnnouncements.length === 0" class="text-center py-12 bg-gray-50 rounded-lg">
          <svg class="mx-auto h-12 w-12 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2" />
          </svg>
          <h3 class="mt-2 text-sm font-medium text-gray-900">No announcements</h3>
          <p class="mt-1 text-sm text-gray-500" v-if="searchQuery">
            We couldn't find any announcements matching "{{ searchQuery }}".
          </p>
          <p class="mt-1 text-sm text-gray-500" v-else-if="activeFilter !== 'all'">
            There are no announcements in the "{{ activeFilter }}" category.
          </p>
          <p class="mt-1 text-sm text-gray-500" v-else>
            There are no announcements available at this time.
          </p>
          <button 
            v-if="searchQuery || activeFilter !== 'all'"
            @click="resetFilters" 
            class="mt-4 text-crimson-600 font-medium hover:text-crimson-700 inline-flex items-center"
          >
            <i class="fas fa-times mr-2"></i> Clear filters
          </button>
        </div>
        
        <TransitionGroup 
          name="list" 
          tag="div" 
          class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6"
        >
          <div 
            v-for="(announcement, index) in filteredAnnouncements" 
            :key="announcement.id"
            class="bg-white rounded-xl shadow-sm hover:shadow-md transition-all duration-300 p-6 border border-gray-100 transform hover:-translate-y-1 overflow-hidden relative group h-full flex flex-col announcement-card"
            :class="`announcement-card-${index % 3 + 1}`"
          >
            <!-- Card accent color at top -->
            <div 
              :class="getAccentColorClass(announcement.type)" 
              class="absolute top-0 left-0 right-0 h-1.5 transform origin-left transition-transform duration-500 group-hover:scale-x-100"
            ></div>
            
            <!-- Content -->
            <div class="flex items-start justify-between mb-4">
              <span :class="getTagClass(announcement.type)" class="inline-block px-3 py-1 text-sm font-medium rounded-full">
                {{ announcement.type }}
              </span>
              <div 
                :class="getIconBgClass(announcement.type)"
                class="w-10 h-10 rounded-full flex items-center justify-center text-white"
              >
                <i :class="announcement.icon"></i>
              </div>
            </div>
            
            <h3 class="text-lg font-bold text-gray-900 mb-3 group-hover:text-crimson-600 transition-colors duration-300">
              {{ announcement.title }}
            </h3>
            
            <div class="flex-grow">
              <p class="text-gray-600 text-sm mb-4 line-clamp-3">
                {{ announcement.content }}
              </p>
              
              <div class="flex items-center mt-1">
                <button 
                  @click="openModal(announcement)" 
                  class="text-crimson-600 hover:text-crimson-700 text-sm font-medium flex items-center"
                >
                  <i class="fas fa-external-link-alt mr-1"></i> View full announcement
                </button>
              </div>
            </div>
            
            <!-- Footer -->
            <div class="flex justify-between items-center mt-4 pt-4 border-t border-gray-100">
              <span class="text-gray-400 text-xs">{{ formatDate(announcement.date) }}</span>
              
              <div class="flex items-center">
                <span class="text-gray-500 text-xs mr-1">{{ announcement.author || 'Admin Team' }}</span>
              </div>
            </div>
          </div>
        </TransitionGroup>
      </div>
    </div>
  </div>
  
  <!-- Announcement Modal for full content -->
  <div v-if="showModal" class="fixed inset-0 z-50 overflow-y-auto" aria-labelledby="modal-title" role="dialog" aria-modal="true">
    <div class="flex items-center justify-center min-h-screen pt-4 px-4 pb-20 text-center sm:block sm:p-0">
      <!-- Background overlay -->
      <div class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity" aria-hidden="true" @click="closeModal"></div>

      <!-- Modal panel -->
      <div class="inline-block align-bottom bg-white rounded-xl text-left overflow-hidden shadow-xl transform transition-all sm:my-8 sm:align-middle sm:max-w-3xl sm:w-full"
           @click.stop>
        <div class="relative">
          <!-- Accent color at top -->
          <div :class="getModalAccentClass(selectedAnnouncement.type)" class="absolute top-0 left-0 right-0 h-1.5"></div>
          
          <!-- Close button -->
          <button @click="closeModal" class="absolute top-4 right-4 text-gray-400 hover:text-gray-500 focus:outline-none z-10">
            <i class="fas fa-times text-lg"></i>
          </button>
          
          <!-- Content -->
          <div class="bg-white px-6 pt-8 pb-6">
            <div class="flex items-start justify-between mb-4">
              <span :class="getTagClass(selectedAnnouncement.type)" class="inline-block px-3 py-1 text-sm font-medium rounded-full">
                {{ selectedAnnouncement.type }}
              </span>
              <span class="text-gray-400 text-sm">{{ formatDate(selectedAnnouncement.date) }}</span>
            </div>
            
            <h3 class="text-xl font-bold text-gray-900 mb-4 flex items-center">
              <i :class="[selectedAnnouncement.icon, 'mr-3 text-crimson-600']"></i>
              {{ selectedAnnouncement.title }}
            </h3>
            
            <div class="prose prose-crimson max-w-none mb-4">
              <p class="text-gray-600 whitespace-pre-wrap">{{ selectedAnnouncement.content }}</p>
            </div>
            
            <div class="flex justify-between items-center pt-4 border-t border-gray-100">
              <div class="flex items-center text-sm text-gray-500">
                <i class="far fa-user mr-2"></i>
                <span>{{ selectedAnnouncement.author || 'Admin Team' }}</span>
              </div>
              
              <a 
                v-if="selectedAnnouncement.link" 
                :href="selectedAnnouncement.link"
                target="_blank"
                class="text-crimson-600 hover:text-crimson-700 font-medium text-sm flex items-center"
              >
                Learn More
                <i class="fas fa-arrow-right ml-2"></i>
              </a>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { onMounted, ref, computed, onBeforeUnmount } from 'vue'
import axios from 'axios'
import { useRouter } from 'vue-router'
import AnnouncementComponent from '../components/Announcements.vue'
import { useAnnouncementStore } from '../stores/announcement'

export default {
  name: 'Announcements',
  components: {
    AnnouncementComponent
  },
  setup() {
    const router = useRouter()
    const searchQuery = ref('')
    const activeFilter = ref('all')
    const showModal = ref(false)
    const selectedAnnouncement = ref({})
    
    const announcementStore = useAnnouncementStore()
    
    const announcementTypes = [
      { value: 'New', label: 'New', icon: 'fas fa-bell', activeClass: 'bg-green-600 text-white' },
      { value: 'Update', label: 'Updates', icon: 'fas fa-sync-alt', activeClass: 'bg-blue-600 text-white' },
      { value: 'Resource', label: 'Resources', icon: 'fas fa-book-open', activeClass: 'bg-purple-600 text-white' },
      { value: 'Event', label: 'Events', icon: 'fas fa-calendar-alt', activeClass: 'bg-amber-600 text-white' },
    ]
    
    const filteredAnnouncements = computed(() => {
      if (!announcementStore.announcements) return []
      
      let results = [...announcementStore.announcements]
      
      // Filter by category
      if (activeFilter.value !== 'all') {
        results = results.filter(a => a.type === activeFilter.value)
      }
      
      // Filter by search query
      if (searchQuery.value.trim()) {
        const query = searchQuery.value.toLowerCase().trim()
        results = results.filter(a => 
          a.title?.toLowerCase().includes(query) || 
          a.content?.toLowerCase().includes(query) ||
          a.type?.toLowerCase().includes(query)
        )
      }
      
      return results
    })
    
    const getTagClass = (type) => {
      const classes = {
        'New': 'bg-green-100 text-green-800',
        'Update': 'bg-blue-100 text-blue-800',
        'Resource': 'bg-purple-100 text-purple-800',
        'Event': 'bg-amber-100 text-amber-800'
      }
      return classes[type] || 'bg-gray-100 text-gray-800'
    }
    
    const resetFilters = () => {
      searchQuery.value = ''
      activeFilter.value = 'all'
    }
    
    const navigateTo = (link) => {
      if (link) {
        router.push(link)
      }
    }
    
    const formatDate = (dateString) => {
      if (!dateString) return ''
      const date = new Date(dateString)
      return date.toLocaleDateString('en-US', { 
        month: 'short', 
        day: 'numeric', 
        year: 'numeric' 
      })
    }
    
    const openModal = (announcement) => {
      selectedAnnouncement.value = announcement
      showModal.value = true
      // Prevent body scrolling when modal is open
      document.body.style.overflow = 'hidden'
    }
    
    const closeModal = () => {
      showModal.value = false
      // Restore body scrolling when modal is closed
      document.body.style.overflow = 'auto'
    }
    
    const getModalAccentClass = (type) => {
      const classes = {
        'New': 'bg-green-500',
        'Update': 'bg-blue-500',
        'Resource': 'bg-purple-500',
        'Event': 'bg-amber-500'
      }
      return classes[type] || 'bg-gray-500'
    }
    
    const getAccentColorClass = (type) => {
      const classes = {
        'New': 'bg-green-500 scale-x-0',
        'Update': 'bg-blue-500 scale-x-0',
        'Resource': 'bg-purple-500 scale-x-0',
        'Event': 'bg-amber-500 scale-x-0'
      }
      return classes[type] || 'bg-gray-500 scale-x-0'
    }
    
    const getIconBgClass = (type) => {
      const classes = {
        'New': 'bg-green-500',
        'Update': 'bg-blue-500',
        'Resource': 'bg-purple-500',
        'Event': 'bg-amber-500'
      }
      return classes[type] || 'bg-gray-500'
    }
    
    onMounted(() => {
      // Fetch announcements if not already loaded
      if (announcementStore.announcements.length === 0) {
        announcementStore.fetchAnnouncements()
      }
    })
    
    onBeforeUnmount(() => {
      // Clean up resources when component is unmounted
      resetFilters()
    })
    
    return {
      searchQuery,
      activeFilter,
      announcementTypes,
      filteredAnnouncements,
      getTagClass,
      resetFilters,
      navigateTo,
      formatDate,
      showModal,
      selectedAnnouncement,
      openModal,
      closeModal,
      getModalAccentClass,
      getAccentColorClass,
      getIconBgClass,
      announcementStore
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

/* Text truncation for announcements */
.line-clamp-3 {
  display: -webkit-box;
  -webkit-line-clamp: 3;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

/* List transition animations */
.list-enter-active,
.list-leave-active {
  transition: all 0.5s ease;
}
.list-enter-from,
.list-leave-to {
  opacity: 0;
  transform: translateY(30px);
}

/* Add card animation styles like in Announcements.vue component */
.announcement-card {
  animation: fadeInUp 0.6s both;
  height: 100%;
  display: flex;
  flex-direction: column;
}

.announcement-card-1 {
  animation-delay: 0.1s;
}

.announcement-card-2 {
  animation-delay: 0.3s;
}

.announcement-card-3 {
  animation-delay: 0.5s;
}
</style> 