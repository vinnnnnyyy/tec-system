<template>
  <div class="min-h-screen">
    <!-- Custom toasts removed - using global toast system -->
    
    <main>
      <!-- Hero Section with responsive logo visibility -->
      <div class="relative overflow-hidden">
        <!-- Responsive blob positioning -->
        <div class="absolute -top-10 -right-10 w-48 h-48 sm:w-72 sm:h-72 bg-crimson-200 rounded-full filter blur-3xl opacity-20 animate-blob"></div>
        <div class="absolute top-20 -left-20 w-48 h-48 sm:w-72 sm:h-72 bg-blue-200 rounded-full filter blur-3xl opacity-20 animate-blob animation-delay-2000"></div>
        <div class="absolute -bottom-20 left-10 sm:left-40 w-48 h-48 sm:w-72 sm:h-72 bg-pink-200 rounded-full filter blur-3xl opacity-20 animate-blob animation-delay-4000"></div>
        
        <!-- Hero section - inline -->
        <section class="hero-section relative min-h-[60vh] sm:min-h-[70vh] md:min-h-[calc(100vh-64px)] w-full flex items-center overflow-hidden isolate bg-gradient-to-br from-gray-900 via-gray-800 to-gray-900" style="background-color: #1f2937;">
          <!-- Background Image Layer -->
          <div 
            class="absolute inset-0 bg-cover bg-center image-background transform scale-105 transition-transform duration-[2s] bg-gradient-to-br from-gray-900 via-gray-800 to-gray-900"
            style="background-image: url('https://i.ytimg.com/vi/JoimFFEafbE/maxresdefault.jpg');"
          ></div>
          
          <!-- Enhanced Overlay with multiple layers -->
          <div class="absolute inset-0 bg-gradient-to-br from-black/70 via-black/50 to-transparent backdrop-blur-sm"></div>
          <div class="absolute inset-0 bg-gradient-to-t from-black/60 via-transparent to-transparent"></div>
          
          <!-- Content container -->
          <div class="w-full relative z-10 px-4 sm:px-6 md:px-12 lg:px-16 py-8 sm:py-12">
            <div class="container mx-auto">
              <div class="flex flex-col md:flex-row items-center justify-between gap-8 md:gap-12 max-w-[2000px] mx-auto">
                <!-- Left side text content -->
                <div class="text-white w-full md:w-1/2 text-center md:text-left fade-in-left">
                  <div class="md:inline-block">
                    <span class="text-crimson-300 bg-white/10 backdrop-blur-lg px-4 py-1.5 rounded-full uppercase tracking-wider text-sm font-semibold mb-4 block">
                      Western Mindanao State University
                    </span>
                  </div>
                  
                  <h1 class="text-4xl sm:text-5xl md:text-6xl font-extrabold text-white mb-6 leading-tight">
                    Your Journey to 
                    <span class="text-transparent bg-clip-text bg-gradient-to-r from-crimson-300 to-pink-300 relative inline-block">
                      Success
                      <span class="absolute -bottom-1 left-0 w-full h-1 bg-gradient-to-r from-crimson-300 to-pink-300 opacity-50 rounded-full"></span>
                    </span>
                    <br class="hidden sm:block" />
                    Starts Here
                  </h1>
                  
                  <p class="text-lg sm:text-xl text-gray-200 max-w-xl mb-8 leading-relaxed">
                    Schedule your exams with ease and take the first step towards your academic goals. Our streamlined process ensures a smooth and efficient experience.
                  </p>
                  
                  <div class="flex flex-col sm:flex-row gap-4 sm:gap-6 justify-center md:justify-start">
                    <router-link 
                      to="/schedule" 
                      class="group inline-flex items-center gap-3 px-8 py-4 bg-gradient-to-r from-crimson-600 to-crimson-700 text-white rounded-xl font-semibold hover:from-crimson-700 hover:to-crimson-800 transition-all duration-300 transform hover:scale-105 shadow-lg hover:shadow-xl"
                    >
                      <span>Schedule Now</span>
                      <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 transition-transform duration-300 group-hover:translate-x-1" viewBox="0 0 20 20" fill="currentColor">
                        <path fill-rule="evenodd" d="M10.293 5.293a1 1 0 011.414 0l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414-1.414L12.586 11H5a1 1 0 110-2h7.586l-2.293-2.293a1 1 0 010-1.414z" clip-rule="evenodd" />
                      </svg>
                    </router-link>
                    
                    <a 
                      href="#features" 
                      class="inline-flex items-center gap-2 px-6 py-4 bg-white/10 backdrop-blur text-white rounded-xl font-semibold hover:bg-white/20 transition-all duration-300"
                    >
                      <span>Learn More</span>
                      <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 transition-transform duration-300 group-hover:translate-y-1" viewBox="0 0 20 20" fill="currentColor">
                        <path fill-rule="evenodd" d="M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z" clip-rule="evenodd" />
                      </svg>
                    </a>
                  </div>
                </div>

                <!-- Right side logo/image with enhanced effects -->
                <div 
                  class="w-full md:w-1/2 mt-10 md:mt-0 fade-in-right group logo-container perspective"
                  @mousemove="handleMouseMove"
                  @mouseleave="resetTilt"
                >
                  <div 
                    class="relative flex justify-center items-center transition-transform duration-300 ease-out" 
                    :style="logoStyle"
                  >
                    <!-- Enhanced glow effect -->
                    <div class="absolute w-64 h-64 md:w-80 md:h-80 bg-gradient-radial from-white/20 via-white/10 to-transparent rounded-full animate-slow-glow blur-2xl"></div>
                    <div class="absolute w-48 h-48 md:w-64 md:h-64 bg-gradient-radial from-crimson-500/20 via-crimson-500/10 to-transparent rounded-full animate-slow-pulse blur-xl"></div>
                    
                    <img 
                      src="../assets/images/wmsu-logo.png" 
                      alt="WMSU Logo" 
                      class="relative z-10 rounded-lg w-[80%] sm:w-[70%] md:w-[85%] mx-auto h-auto transform transition-transform duration-500 group-hover:scale-105 floating drop-shadow-2xl"
                    >
                  </div>
                </div>
              </div>
            </div>
          </div>
        </section>
      </div>
      <!-- Announcements with improved styling -->
      <Announcements />

      <!-- About Testing and Evaluation Center Section -->
      <section class="py-16 sm:py-20 md:py-24 bg-gradient-to-b from-white to-gray-50 overflow-hidden relative">
        <!-- Background decorations -->
        <div class="absolute top-0 left-0 w-full h-20 bg-gradient-to-b from-gray-50 to-transparent"></div>
        <div class="absolute -right-40 top-40 w-96 h-96 bg-crimson-50 rounded-full opacity-60 blur-3xl"></div>
        <div class="absolute -left-20 bottom-20 w-80 h-80 bg-blue-50 rounded-full opacity-50 blur-3xl"></div>
        
        <div class="container mx-auto px-4 sm:px-6 lg:px-8 relative z-10">
          <div class="text-center mb-16">
            <span class="inline-block px-4 py-1.5 bg-crimson-50 text-crimson-600 rounded-full text-xs font-semibold tracking-wider mb-3 shadow-sm transform hover:scale-105 transition-transform duration-300">ABOUT US</span>
            <h2 class="text-2xl sm:text-3xl md:text-4xl font-bold mt-2 bg-clip-text text-transparent bg-gradient-to-r from-crimson-600 to-crimson-800">Testing and Evaluation Center</h2>
            <div class="w-20 h-1 bg-gradient-to-r from-crimson-500 to-crimson-300 mx-auto my-6 rounded-full"></div>
            <p class="text-gray-600 text-sm sm:text-base max-w-2xl mx-auto">Dedicated to excellence in assessment and certification</p>
          </div>
          
          <div class="grid grid-cols-1 md:grid-cols-2 gap-12 items-center">
            <!-- Left column: Image with enhanced styling -->
            <div class="transform transition-all duration-500 hover:scale-105 group">
              <div class="rounded-2xl overflow-hidden shadow-xl bg-white p-8 border border-gray-100 relative backdrop-blur-sm bg-white/80">
                <!-- Decorative dots -->
                <div class="absolute top-4 right-4 flex space-x-1.5">
                  <div class="w-2 h-2 rounded-full bg-crimson-400"></div>
                  <div class="w-2 h-2 rounded-full bg-amber-400"></div>
                  <div class="w-2 h-2 rounded-full bg-green-400"></div>
                </div>
                
                <!-- Logo container with subtle animation -->
                <div class="flex items-center justify-center overflow-hidden p-4">
                  <img 
                    src="../assets/images/wmsu-logo.png" 
                    alt="WMSU Testing Center Logo"
                    class="max-w-full max-h-[280px] object-contain filter drop-shadow-md transform transition-all duration-700 group-hover:scale-110"
                  >
                </div>
                
                <!-- Caption -->
                <div class="text-center mt-6 text-sm text-gray-500 font-medium">Western Mindanao State University</div>
              </div>
            </div>
            
            <!-- Right column: Text content with improved layout -->
            <div class="space-y-8">
              <h3 class="text-xl sm:text-2xl font-bold text-gray-800 relative">
                <span class="relative z-10">Excellence in Assessment</span>
                <span class="absolute -z-10 bottom-0 left-0 w-full h-3 bg-crimson-100 opacity-70"></span>
              </h3>
              
              <p class="text-gray-600 leading-relaxed">The Testing and Evaluation Center is a state-of-the-art facility dedicated to providing accurate, reliable, and secure testing services for various certifications, academic evaluations, and professional qualifications.</p>
              
              <div class="space-y-6">
                <!-- Feature 1 -->
                <div class="flex items-start p-4 rounded-xl bg-white shadow-sm border border-gray-50 hover:shadow-md transition-all duration-300 transform hover:-translate-y-1">
                  <div class="flex-shrink-0 w-12 h-12 rounded-xl bg-gradient-to-br from-crimson-500 to-crimson-600 flex items-center justify-center text-white mr-5 shadow-md">
                    <i class="fas fa-award"></i>
                  </div>
                  <div>
                    <h4 class="font-semibold text-gray-800">Certified Professionals</h4>
                    <p class="text-gray-600 mt-1">Our center is staffed with highly trained and certified professionals who ensure the highest standards in testing.</p>
                  </div>
                </div>
                
                <!-- Feature 2 -->
                <div class="flex items-start p-4 rounded-xl bg-white shadow-sm border border-gray-50 hover:shadow-md transition-all duration-300 transform hover:-translate-y-1">
                  <div class="flex-shrink-0 w-12 h-12 rounded-xl bg-gradient-to-br from-blue-500 to-blue-600 flex items-center justify-center text-white mr-5 shadow-md">
                    <i class="fas fa-desktop"></i>
                  </div>
                  <div>
                    <h4 class="font-semibold text-gray-800">Modern Facilities</h4>
                    <p class="text-gray-600 mt-1">Equipped with the latest technology and comfortable testing environments to ensure optimal performance.</p>
                  </div>
                </div>
                
                <!-- Feature 3 -->
                <div class="flex items-start p-4 rounded-xl bg-white shadow-sm border border-gray-50 hover:shadow-md transition-all duration-300 transform hover:-translate-y-1">
                  <div class="flex-shrink-0 w-12 h-12 rounded-xl bg-gradient-to-br from-green-500 to-green-600 flex items-center justify-center text-white mr-5 shadow-md">
                    <i class="fas fa-lock"></i>
                  </div>
                  <div>
                    <h4 class="font-semibold text-gray-800">Secure Environment</h4>
                    <p class="text-gray-600 mt-1">We maintain the highest security standards to ensure test integrity and data protection.</p>
                  </div>
                </div>
              </div>
              
              <router-link to="/about" class="inline-flex items-center px-6 py-3 bg-gradient-to-r from-crimson-600 to-crimson-700 text-white rounded-lg font-medium hover:from-crimson-700 hover:to-crimson-800 transition-all duration-300 shadow-md hover:shadow-lg transform hover:-translate-y-0.5 group">
                <span>Learn More</span>
                <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 ml-2 transform group-hover:translate-x-1 transition-transform duration-300" viewBox="0 0 20 20" fill="currentColor">
                  <path fill-rule="evenodd" d="M10.293 5.293a1 1 0 011.414 0l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414-1.414L12.586 11H5a1 1 0 110-2h7.586l-2.293-2.293a1 1 0 010-1.414z" clip-rule="evenodd" />
                </svg>
              </router-link>
            </div>
          </div>
        </div>
      </section>

      <!-- Enhanced FAQ Preview Section -->
      <section class="py-16 sm:py-20 md:py-24 bg-gradient-to-b from-gray-50 to-gray-100 relative overflow-hidden">
        <!-- Background decorations -->
        <div class="absolute top-40 -right-20 w-80 h-80 bg-crimson-50 rounded-full opacity-30 blur-3xl"></div>
        <div class="absolute bottom-20 -left-40 w-80 h-80 bg-blue-50 rounded-full opacity-30 blur-3xl"></div>
        
        <div class="container mx-auto px-4 sm:px-6 lg:px-8 relative z-10">
          <div class="text-center mb-16">
            <span class="inline-block px-4 py-1.5 bg-blue-50 text-blue-600 rounded-full text-xs font-semibold tracking-wider mb-3 shadow-sm transform hover:scale-105 transition-transform duration-300">FAQ</span>
            <h2 class="text-2xl sm:text-3xl md:text-4xl font-bold mt-2 bg-clip-text text-transparent bg-gradient-to-r from-gray-800 to-gray-600">Frequently Asked Questions</h2>
            <div class="w-20 h-1 bg-gradient-to-r from-blue-500 to-blue-300 mx-auto my-6 rounded-full"></div>
            <p class="text-gray-600 text-sm sm:text-base max-w-2xl mx-auto">Find quick answers to common questions about our platform</p>
          </div>
          
          <div class="max-w-3xl mx-auto">
            <!-- Loading state -->
            <div v-if="isLoadingFaqs" class="text-center py-12">
              <div class="inline-flex items-center justify-center">
                <i class="fas fa-spinner fa-spin text-xl text-blue-600"></i>
              </div>
              <p class="text-gray-500 mt-2">Loading FAQs...</p>
            </div>
            
            <!-- Error state -->
            <div v-else-if="faqLoadError" class="text-center py-12">
              <p class="text-red-500">{{ faqLoadError }}</p>
            </div>
            
            <!-- FAQ items -->
            <div v-else class="space-y-5">
              <!-- Dynamic FAQs -->
              <div 
                v-for="(faq, index) in previewFaqs" 
                :key="faq.id" 
                class="bg-white rounded-xl shadow-md overflow-hidden border border-gray-100 transition-all duration-300 hover:shadow-lg hover:border-crimson-100 faq-card"
                :class="`faq-card-${index + 1}`"
                @click="togglePreviewFaq(faq.id)"
              >
                <button class="w-full flex justify-between items-center p-6 text-left group">
                  <div class="flex items-center">
                    <div class="mr-4 flex-shrink-0 w-10 h-10 rounded-xl" 
                         :class="getFaqIconClass(faq.category, index)">
                      <i :class="[faq.icon || 'fas fa-question', 'text-sm']"></i>
                    </div>
                    <h3 class="text-lg font-semibold group-hover:text-crimson-600 transition-colors duration-300"
                        :class="{'text-crimson-600': expandedFaqId === faq.id}">
                      {{ faq.question }}
                    </h3>
                  </div>
                  <span class="ml-4 flex-shrink-0 text-gray-400 group-hover:text-crimson-600 transition-colors duration-300">
                    <i class="fas fa-chevron-down transform group-hover:rotate-180 transition-transform duration-300"
                       :class="{'rotate-180': expandedFaqId === faq.id}"></i>
                  </span>
                </button>
                
                <!-- Answer panel (can be toggled with actual functionality) -->
                <div 
                  class="transition-all duration-300 px-6 overflow-hidden"
                  :class="{'max-h-0': expandedFaqId !== faq.id, 'max-h-[300px]': expandedFaqId === faq.id}"
                >
                  <div class="py-5 border-t border-gray-100">
                    <p class="text-gray-600" v-html="faq.answer"></p>
                  </div>
                </div>
              </div>
            </div>
            
            <div class="text-center mt-12">
              <router-link 
                to="/faq" 
                class="inline-flex items-center gap-2 px-6 py-3 bg-white text-gray-700 rounded-lg font-medium shadow-sm hover:bg-gray-50 transition-all duration-300 transform hover:-translate-y-1 border border-gray-200 group"
              >
                <span>View All FAQ</span>
                <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 text-gray-500 group-hover:text-gray-700 transform group-hover:translate-x-1 transition-all duration-300" viewBox="0 0 20 20" fill="currentColor">
                  <path fill-rule="evenodd" d="M10.293 5.293a1 1 0 011.414 0l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414-1.414L12.586 11H5a1 1 0 110-2h7.586l-2.293-2.293a1 1 0 010-1.414z" clip-rule="evenodd" />
                </svg>
              </router-link>
            </div>
          </div>
        </div>
      </section>
    </main>
  </div>  
</template>

<script>
import { ref, computed } from 'vue'
import Navbar from '../components/layout/Navbar.vue'
import Announcements from '../components/Announcements.vue'
import AuthService from '../services/auth.service'
import { useToast } from '../composables/useToast'
import axiosInstance from '../services/axios.interceptor'
import { useAnnouncementStore } from '../stores/announcement'

const API_URL = import.meta.env.VITE_API_URL || 'http://127.0.0.1:8000';
const API_ENDPOINT = `${API_URL}/api/`;

export default {
  name: 'Home',
  components: {
    Navbar,
    Announcements,
  },
  setup() {
    const { showToast } = useToast()
    
    // Hero component functionality
    const logoTilt = ref({ x: 0, y: 0 });

    const logoStyle = computed(() => ({
      transform: `rotateY(${logoTilt.value.x}deg) rotateX(${logoTilt.value.y}deg)`,
    }));

    const handleMouseMove = (event) => {
      const rect = event.currentTarget.getBoundingClientRect();
      const x = event.clientX - rect.left;
      const y = event.clientY - rect.top;
      
      const centerX = rect.width / 2;
      const centerY = rect.height / 2;
      
      const rotateX = ((y - centerY) / centerY) * -5;
      const rotateY = ((x - centerX) / centerX) * 5;
      
      logoTilt.value = { x: rotateY, y: rotateX };
    };

    const resetTilt = () => {
      logoTilt.value = { x: 0, y: 0 };
    };
    
    return { 
      showToast,
      logoTilt,
      logoStyle,
      handleMouseMove,
      resetTilt
    }
  },
  data() {
    return {
      isAuthenticated: false,
      showLogoutNotification: false,
      toastShown: false,
      showLoginNotification: false,
      loginToastShown: false,
      isLoadingFaqs: true,
      faqLoadError: null,
      previewFaqs: [],
      expandedFaqId: null,
      announcementStore: useAnnouncementStore(),
      // Hero component data
      isSmallScreen: false
    }
  },
  created() {
    // Check if user is already authenticated
    this.isAuthenticated = !!AuthService.getCurrentUser();
    
    // Check if redirected after logout
    if (this.$route.query.logout === 'success') {
      this.showToast('You have been successfully logged out.');
      // Clean up the URL query parameter
      this.$router.replace({ 
        path: this.$route.path,
        query: { ...this.$route.query, logout: undefined }
      });
    }
    
    // Check if redirected after login
    if (this.$route.query.login_success === 'true') {
      this.showToast('You have been successfully logged in.');
      // Clean up the URL query parameter
      this.$router.replace({ 
        path: this.$route.path,
        query: { ...this.$route.query, login_success: undefined }
      });
    }
    
    // Fetch FAQs for preview section
    this.fetchPreviewFaqs();

    // Fetch announcements data
    this.fetchAnnouncements();
  },
  mounted() {
    // Hero component mounted functionality
    console.log('Hero section mounted successfully');
    this.checkScreenSize();
    window.addEventListener('resize', this.checkScreenSize);
  },
  beforeUnmount() {
    // Hero component cleanup
    window.removeEventListener('resize', this.checkScreenSize);
  },
  methods: {
    checkAuth() {
      return !!AuthService.getCurrentUser();
    },
    togglePreviewFaq(id) {
      this.expandedFaqId = this.expandedFaqId === id ? null : id;
    },
    async fetchPreviewFaqs() {
      this.isLoadingFaqs = true;
      this.faqLoadError = null;
      
      try {
        const response = await axiosInstance.get(API_ENDPOINT + 'admin/faqs/');
        // Get active FAQs and limit to 3 for preview
        this.previewFaqs = response.data
          .filter(faq => faq.is_active)
          .slice(0, 3);
      } catch (err) {
        console.error('Failed to fetch FAQs:', err);
        this.faqLoadError = 'Failed to load FAQ preview';
      } finally {
        this.isLoadingFaqs = false;
      }
    },
    async fetchAnnouncements() {
      try {
        await this.announcementStore.fetchAnnouncements();
      } catch (error) {
        console.error('Error fetching announcements:', error);
      }
    },
    getFaqIconClass(category, index) {
      // Map categories to appropriate classes
      const categoryClasses = {
        'General': 'bg-crimson-100 text-crimson-600 flex items-center justify-center shadow-sm',
        'Scheduling': 'bg-blue-100 text-blue-600 flex items-center justify-center shadow-sm',
        'Requirements': 'bg-purple-100 text-purple-600 flex items-center justify-center shadow-sm',
        'Payment': 'bg-green-100 text-green-600 flex items-center justify-center shadow-sm',
        'Technical': 'bg-amber-100 text-amber-600 flex items-center justify-center shadow-sm'
      };
      
      // Default classes based on position for consistent coloring
      const defaultClasses = [
        'bg-crimson-100 text-crimson-600 flex items-center justify-center shadow-sm',
        'bg-blue-100 text-blue-600 flex items-center justify-center shadow-sm',
        'bg-green-100 text-green-600 flex items-center justify-center shadow-sm'
      ];
      
      return categoryClasses[category] || defaultClasses[index % defaultClasses.length];
    },
    // Hero component methods
    checkScreenSize() {
      this.isSmallScreen = window.innerWidth < 400;
    }
  }
}
</script>

<style scoped>
/* Hero Section Styles */
.hero-section {
  isolation: isolate;
}

.hero-section section {
  min-height: 60vh;
  min-height: 60dvh;
}

@media (min-width: 768px) {
  .hero-section section {
    min-height: calc(100vh - 64px);
    min-height: calc(100dvh - 64px);
  }
}

.image-background {
  transition: background-image 0.5s ease-in-out;
}

/* Enhanced Glow Animation */
@keyframes slowGlow {
  0% { transform: scale(0.95); opacity: 0.4; }
  50% { transform: scale(1.05); opacity: 0.6; }
  100% { transform: scale(0.95); opacity: 0.4; }
}

@keyframes slowPulse {
  0% { transform: scale(0.98); opacity: 0.3; }
  50% { transform: scale(1.02); opacity: 0.5; }
  100% { transform: scale(0.98); opacity: 0.3; }
}

.animate-slow-glow {
  animation: slowGlow 5s ease-in-out infinite;
}

.animate-slow-pulse {
  animation: slowPulse 4s ease-in-out infinite;
  animation-delay: -2s;
}

/* Background radial gradient */
.bg-gradient-radial {
  background-image: radial-gradient(circle, var(--tw-gradient-stops));
}

/* Gradient text support */
.bg-clip-text {
  -webkit-background-clip: text;
  background-clip: text;
}

/* Enhanced Animations */
.fade-in-left {
  animation: fadeInLeft 1s ease-out forwards;
  opacity: 0;
}

.fade-in-right {
  animation: fadeInRight 1s ease-out 0.3s forwards;
  opacity: 0;
}

@keyframes fadeInLeft {
  from {
    opacity: 0;
    transform: translateX(-30px);
  }
  to {
    opacity: 1;
    transform: translateX(0);
  }
}

@keyframes fadeInRight {
  from {
    opacity: 0;
    transform: translateX(30px);
  }
  to {
    opacity: 1;
    transform: translateX(0);
  }
}

.floating {
  animation: floating 4s ease-in-out infinite;
}

@keyframes floating {
  0% { transform: translateY(0px); }
  50% { transform: translateY(-12px); }
  100% { transform: translateY(0px); }
}

/* Perspective for 3D tilt */
.perspective {
  perspective: 1000px;
}

.logo-container {
  transition: transform 0.4s ease-out;
}

/* Enhanced drop shadow for logo */
.drop-shadow-2xl {
  filter: drop-shadow(0 25px 25px rgb(0 0 0 / 0.15));
}

/* Animation for blob effects */
@keyframes blob {
  0% {
    transform: translate(0px, 0px) scale(1);
  }
  33% {
    transform: translate(30px, -50px) scale(1.1);
  }
  66% {
    transform: translate(-20px, 20px) scale(0.9);
  }
  100% {
    transform: translate(0px, 0px) scale(1);
  }
}

.animate-blob {
  animation: blob 7s infinite;
  will-change: transform;
}

.animation-delay-2000 {
  animation-delay: 2s;
}

.animation-delay-4000 {
  animation-delay: 4s;
}

/* Toast progress bar animation */
@keyframes shrink {
  from { width: 100%; }
  to { width: 0%; }
}

.toast-progress-bar {
  height: 3px;
  background-color: #10B981;
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  animation: shrink 5s linear forwards;
}

/* Fade in animation for elements */
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

/* Animated gradient */
@keyframes gradientShift {
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

.animate-gradient {
  background-size: 200% 200%;
  animation: gradientShift 2s ease infinite;
}

/* Responsive adjustments for smaller screens */
@media (max-width: 640px) {
  .container {
    padding-left: 1rem;
    padding-right: 1rem;
  }

  .animate-blob {
    animation-duration: 10s; /* Slightly slower animation on mobile */
  }
}

/* Better small screen support - keep Hero visible but adjust layout */
@media (max-width: 400px) {
  /* Ensure Hero section is always visible */
  .hide-logo-small {
    display: block !important;
  }
  
  /* Adjust typography for better fit on very small screens */
  .hide-logo-small :deep(h1) {
    font-size: 1.75rem !important;
    line-height: 1.3 !important;
  }
  
  .hide-logo-small :deep(p) {
    font-size: 0.9375rem !important;
    margin-top: 0.75rem !important;
    margin-bottom: 1.25rem !important;
  }
  
  /* Make buttons stack vertically on very small screens */
  .hide-logo-small :deep(.flex-col) {
    flex-direction: column !important;
  }
  
  /* Reduce logo size on very small screens */
  .hide-logo-small :deep(.logo-container img) {
    width: 60% !important;
  }
  
  /* Hero responsive typography */
  .hero-section h1 {
    font-size: 2rem;
    line-height: 1.3;
  }
  
  .hero-section p {
    font-size: 1rem;
  }
}

/* Add better small screen support */
@media (max-width: 375px) {
  .text-2xl {
    font-size: 1.25rem;
  }
  
  .text-xl {
    font-size: 1.125rem;
  }
}

@media (max-height: 500px) and (orientation: landscape) {
  .hero-section section {
    min-height: 100vh;
    padding: 2rem 0;
  }
  
  .hero-section .flex-col {
    flex-direction: row;
  }
}

/* Add support for tall mobile screens */
@media (min-height: 800px) {
  .min-h-screen {
    min-height: 100vh;
    min-height: 100dvh;
  }
}

/* FAQ card animations */
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

.faq-card:hover .faq-answer {
  max-height: 200px;
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

/* Section headings */
h2.text-transparent {
  font-weight: 800;
  letter-spacing: -0.5px;
}

/* Subtle floating animation for image container */
@keyframes float {
  0% {
    transform: translateY(0px);
  }
  50% {
    transform: translateY(-5px);
  }
  100% {
    transform: translateY(0px);
  }
}

.rounded-2xl.overflow-hidden {
  animation: float 5s ease-in-out infinite;
  box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.05), 
              0 8px 10px -6px rgba(0, 0, 0, 0.02);
  transition: all 0.3s ease;
}

.rounded-2xl.overflow-hidden:hover {
  box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 
              0 10px 10px -5px rgba(0, 0, 0, 0.04);
}

/* Button hover effects */
.bg-gradient-to-r {
  background-size: 200% auto;
  transition: all 0.5s ease;
}

.bg-gradient-to-r:hover {
  background-position: right center;
}

/* Feature card hover effects */
.flex.items-start.p-4 {
  transition: all 0.3s ease;
}

.flex.items-start.p-4:hover {
  transform: translateY(-5px);
  box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 
              0 4px 6px -2px rgba(0, 0, 0, 0.05);
}

/* Decorative dots animation */
@keyframes pulse {
  0% {
    transform: scale(1);
    opacity: 0.8;
  }
  50% {
    transform: scale(1.1);
    opacity: 1;
  }
  100% {
    transform: scale(1);
    opacity: 0.8;
  }
}

.absolute.top-4.right-4 .rounded-full:nth-child(1) {
  animation: pulse 2s infinite;
}

.absolute.top-4.right-4 .rounded-full:nth-child(2) {
  animation: pulse 2s infinite 0.6s;
}

.absolute.top-4.right-4 .rounded-full:nth-child(3) {
  animation: pulse 2s infinite 1.2s;
}
</style>