<template>
  <section id="features" class="py-12 sm:py-16 md:py-20 bg-gradient-to-b from-white to-gray-50">
    <div class="container mx-auto px-4 sm:px-6 lg:px-8">
      <div class="text-center mb-8 sm:mb-12">
        <span class="text-crimson-600 uppercase tracking-wider text-xs sm:text-sm font-semibold">Stay Updated</span>
        <h2 class="text-2xl sm:text-3xl md:text-4xl font-bold mt-2 text-gray-900">Latest Announcements</h2>
        <p class="text-gray-600 text-sm sm:text-base max-w-2xl mx-auto mt-2">Stay informed with the latest updates, news, and resources</p>
      </div>
      
      <div v-if="loading" class="text-center py-8">
        <div class="inline-flex items-center justify-center">
          <i class="fas fa-spinner fa-spin text-xl text-crimson-600"></i>
        </div>
        <p class="text-gray-500 mt-2">Loading announcements...</p>
      </div>

      <div v-else-if="error" class="text-center py-8 text-red-500">
        <p>{{ error }}</p>
      </div>
      
      <div v-else class="grid grid-cols-1 md:grid-cols-3 gap-6 max-w-6xl mx-auto">
        <div 
          v-for="(announcement, index) in announcements" 
          :key="announcement.id" 
          class="bg-white rounded-xl shadow-sm hover:shadow-md transition-all duration-300 p-6 border border-gray-100 transform hover:-translate-y-1 overflow-hidden relative group"
          :class="[
            'announcement-card',
            `announcement-card-${index + 1}`
          ]"
        >
          <!-- Card accent color at top -->
          <div 
            :class="getAccentClass(announcement.type)" 
            class="absolute top-0 left-0 right-0 h-1.5 transform origin-left transition-transform duration-500 group-hover:scale-x-100"
          ></div>
          
          <!-- Icon with background -->
          <div class="mb-4 flex justify-between items-start">
            <span 
              :class="getTagClass(announcement.type)" 
              class="inline-block px-3 py-1 text-xs font-medium rounded-full"
            >
              {{ announcement.type }}
            </span>
            <div 
              :class="getIconBgClass(announcement.type)"
              class="w-10 h-10 rounded-full flex items-center justify-center text-white"
            >
              <i :class="announcement.icon"></i>
            </div>
          </div>
          
          <!-- Content -->
          <h3 class="text-lg font-bold text-gray-900 mb-3 group-hover:text-crimson-600 transition-colors duration-300">
            {{ announcement.title }}
          </h3>
          
          <!-- Announcement Image -->
          <div v-if="getImageUrl(announcement)" class="mb-3">
            <div class="relative overflow-hidden rounded-lg border border-gray-200 bg-gray-100 aspect-video cursor-pointer group-image" 
                 @click="openModal(announcement)">
              <img :src="getImageUrl(announcement)" 
                   :alt="announcement.title" 
                   class="w-full h-full object-cover object-center transition-transform duration-300 group-hover:scale-105"
                   @error="handleImageError($event, announcement)"
                   @load="handleImageLoad($event, announcement)">
              <!-- Zoom Icon Overlay -->
              <div class="absolute inset-0 flex items-center justify-center opacity-0 group-hover:opacity-100 transition-opacity duration-300 bg-black/30">
                <div class="bg-white/90 backdrop-blur-sm rounded-full p-2 shadow-lg">
                  <i class="fas fa-search-plus text-gray-800 text-lg"></i>
                </div>
              </div>
            </div>
          </div>
          
          <div>
            <p class="text-gray-600 text-sm mb-4 line-clamp-3">
              {{ announcement.content }}
            </p>
            
            <div class="flex items-center mt-1">
              <button 
                @click.stop="openModal(announcement)" 
                class="text-crimson-600 hover:text-crimson-700 text-xs font-medium flex items-center"
              >
                <i class="fas fa-external-link-alt mr-1"></i> Pop out
              </button>
            </div>
          </div>
          
          <!-- Footer -->
          <div class="flex justify-between items-center mt-4 pt-4 border-t border-gray-100">
            <span class="text-gray-400 text-xs">{{ formatDate(announcement.date) }}</span>
            
            <div class="flex items-center">
              <span class="text-gray-500 text-xs mr-1">{{ announcement.author }}</span>
            </div>
          </div>
        </div>
      </div>
      
      <div class="text-center mt-8">
        <button 
          @click="navigateToAnnouncements" 
          class="inline-flex items-center px-4 py-2 bg-crimson-600 hover:bg-crimson-700 text-white rounded-lg transition-colors text-sm font-medium"
        >
          View All Announcements
          <i class="fas fa-arrow-right ml-2"></i>
        </button>
      </div>
    </div>
  </section>
  
  <!-- Announcement Modal for full content -->
  <Transition name="modal">
    <div v-if="showModal" class="fixed inset-0 z-50 overflow-y-auto" aria-labelledby="modal-title" role="dialog" aria-modal="true">
      <div class="flex items-center justify-center min-h-screen pt-4 px-4 pb-20 text-center sm:block sm:p-0">
        <!-- Background overlay with fade transition -->
        <Transition name="fade">
          <div class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity" aria-hidden="true" @click="closeModal"></div>
        </Transition>

        <!-- Modal panel with slide and fade transition -->
        <div class="inline-block align-bottom bg-white rounded-xl text-left overflow-hidden shadow-xl transform transition-all sm:my-8 sm:align-middle sm:max-w-3xl sm:w-full"
            @click.stop
            :class="{ 'translate-y-0 opacity-100 scale-100': showModal, 'translate-y-4 opacity-0 scale-95': !showModal }"
            style="transition: all 0.3s ease-out;">
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
                <span :class="getTagClass(selectedAnnouncement.type)" class="inline-block px-3 py-1 text-xs font-medium rounded-full">
                  {{ selectedAnnouncement.type }}
                </span>
                <span class="text-gray-400 text-sm">{{ formatDate(selectedAnnouncement.date) }}</span>
              </div>
              
              <h3 class="text-xl font-bold text-gray-900 mb-4 flex items-center">
                <i :class="[selectedAnnouncement.icon, 'mr-3 text-crimson-600']"></i>
                {{ selectedAnnouncement.title }}
              </h3>
              
              <!-- Modal Image Display -->
              <div v-if="getImageUrl(selectedAnnouncement)" class="mb-4">
                <div class="relative overflow-hidden rounded-lg border border-gray-200 bg-gray-100">
                  <img :src="getImageUrl(selectedAnnouncement)" 
                       :alt="selectedAnnouncement.title" 
                       class="w-full h-auto max-h-[60vh] object-contain object-center"
                       @error="handleImageError($event, selectedAnnouncement)"
                       @load="handleImageLoad($event, selectedAnnouncement)">
                </div>
              </div>
              
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
  </Transition>
</template>

<script>
import { onMounted, ref, computed } from 'vue'
import { useRouter } from 'vue-router'
import { useAnnouncementStore } from '../stores/announcement'

export default {
  name: 'Announcements',
  props: {
    announcement: {
      type: Object,
      default: null
    }
  },
  setup(props) {
    const router = useRouter()
    const announcementStore = useAnnouncementStore()
    const showModal = ref(false)
    const selectedAnnouncement = ref({})
    
    // Use a computed property to get announcements from the store
    // but limit to 3 for the homepage
    const announcements = computed(() => {
      return props.announcement 
        ? [props.announcement] 
        : announcementStore.announcements.slice(0, 3)
    })
    
    // Compute loading and error states from the store
    const loading = computed(() => announcementStore.loading)
    const error = computed(() => announcementStore.error)
    
    const getTagClass = (type) => {
      const classes = {
        'New': 'bg-green-100 text-green-800',
        'Update': 'bg-blue-100 text-blue-800',
        'Resource': 'bg-purple-100 text-purple-800',
        'Event': 'bg-amber-100 text-amber-800'
      }
      return classes[type] || 'bg-gray-100 text-gray-800'
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
    
    const getAccentClass = (type) => {
      const classes = {
        'New': 'bg-green-500 scale-x-0',
        'Update': 'bg-blue-500 scale-x-0',
        'Resource': 'bg-purple-500 scale-x-0',
        'Event': 'bg-amber-500 scale-x-0'
      }
      return classes[type] || 'bg-gray-500 scale-x-0'
    }
    
    const navigateToAnnouncements = () => {
      router.push('/announcements')
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
    
    const getImageUrl = (announcement) => {
      if (!announcement.image && !announcement.image_url && !announcement.image_display) {
        return null
      }
      
      // Priority: image_display (from serializer) > image_url (external) > image (filename)
      const imageUrl = announcement.image_display || announcement.image_url || announcement.image
      
      // If it's already a full URL, return as is
      if (imageUrl && (imageUrl.startsWith('http://') || imageUrl.startsWith('https://'))) {
        return imageUrl
      }
      
      // If it's a relative path, construct the full URL using PythonAnywhere domain
      const baseUrl = 'https://wmsutec.pythonanywhere.com'
      
      // Handle different possible image path formats
      if (imageUrl) {
        // If it starts with '/', it's already a proper path
        if (imageUrl.startsWith('/')) {
          return `${baseUrl}${imageUrl}`
        }
        // If it starts with 'media/', add a leading slash
        if (imageUrl.startsWith('media/')) {
          return `${baseUrl}/${imageUrl}`
        }
        // If it doesn't start with 'media/', assume it's in the announcements folder
        return `${baseUrl}/media/announcements/${imageUrl}`
      }
      
      return null
    }
    
    const handleImageError = (event, announcement) => {
      console.error('Image failed to load for announcement:', announcement.title)
      console.error('Failed URL:', event.target.src)
      console.error('Raw image data:', {
        image_display: announcement.image_display,
        image_url: announcement.image_url,
        image: announcement.image
      })
      
      // Try alternative URLs if the first one fails
      const currentSrc = event.target.src
      const imageUrl = announcement.image_display || announcement.image_url || announcement.image
      
      if (imageUrl && !currentSrc.includes('/media/announcements/')) {
        // Try the announcements folder path
        const alternativeUrl = `https://wmsutec.pythonanywhere.com/media/announcements/${imageUrl}`
        if (currentSrc !== alternativeUrl) {
          console.log('Trying alternative URL:', alternativeUrl)
          event.target.src = alternativeUrl
          return
        }
      }
      
      // If all attempts fail, hide the image
      event.target.style.display = 'none'
      console.error('All image URL attempts failed for:', announcement.title)
    }
    
    const handleImageLoad = (event, announcement) => {
      console.log('Image loaded successfully for announcement:', announcement.title, 'URL:', event.target.src)
      event.target.style.display = 'block'
    }
    
    onMounted(() => {
      // Only fetch if we're not passed an announcement prop
      // and announcements aren't already loaded
      if (!props.announcement && announcementStore.announcements.length === 0) {
        announcementStore.fetchAnnouncements()
      }
      
      // Debug: Log announcements data
      console.log('Announcements component mounted. Current announcements:', announcementStore.announcements)
      
      // Debug: Log image URLs for each announcement
      announcementStore.announcements.forEach((announcement, index) => {
        console.log(`Announcement ${index + 1} (${announcement.title}):`)
        console.log('  - image_display:', announcement.image_display)
        console.log('  - image_url:', announcement.image_url)
        console.log('  - image:', announcement.image)
        console.log('  - final URL:', getImageUrl(announcement))
      })
    })
    
    return {
      announcements,
      loading,
      error,
      getTagClass,
      getIconBgClass,
      getAccentClass,
      navigateToAnnouncements,
      formatDate,
      showModal,
      selectedAnnouncement,
      openModal,
      closeModal,
      getModalAccentClass,
      getImageUrl,
      handleImageError,
      handleImageLoad
    }
  }
}
</script>

<style scoped>
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

@media (max-width: 768px) {
  .announcement-card {
    margin-bottom: 1rem;
  }
}

.line-clamp-3 {
  display: -webkit-box;
  -webkit-line-clamp: 3;
  line-clamp: 3;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

/* Add these styles for the animations */
.modal-enter-active,
.modal-leave-active {
  transition: opacity 0.3s ease;
}

.modal-enter-from,
.modal-leave-to {
  opacity: 0;
}

.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.2s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}

/* Smooth transition for expand/collapse */
.announcement-content {
  transition: max-height 0.3s ease-out, opacity 0.3s ease;
  overflow: hidden;
}

.announcement-modal-content {
  max-height: 60vh;
  overflow-y: auto;
  padding: 1rem;
  white-space: pre-wrap;
  word-break: break-word;
}

.announcement-content {
  white-space: pre-wrap;
  word-break: break-word;
}

/* Responsive image aspect ratios */
.aspect-video {
  aspect-ratio: 16 / 9;
}

/* Responsive breakpoints for image containers */
@media (max-width: 640px) {
  .aspect-video {
    aspect-ratio: 4 / 3;
  }
}

@media (min-width: 1024px) {
  .aspect-video {
    aspect-ratio: 16 / 10;
  }
}

/* Ensure images scale properly within their containers */
img {
  max-width: 100%;
  height: auto;
}

/* Responsive modal adjustments */
@media (max-width: 640px) {
  .max-h-\[60vh\] {
    max-height: 50vh;
  }
}

/* Image hover effects for clickable images */
.group-image {
  transition: all 0.3s ease;
}

.group-image:hover {
  transform: translateY(-2px);
  box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.1), 0 8px 10px -6px rgba(0, 0, 0, 0.1);
}

.group-image img {
  transition: transform 0.3s ease;
}

.group-image:hover img {
  transform: scale(1.05);
}

/* Enhanced zoom icon styling */
.group-image .fa-search-plus {
  transition: transform 0.2s ease;
}

.group-image:hover .fa-search-plus {
  transform: scale(1.1);
}
</style> 