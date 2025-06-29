<template>
  <nav 
    :class="[
      'sticky top-0 z-50 transition-all duration-300',
      'shadow-md bg-white/95 backdrop-blur-md'
    ]"
  >
    <div class="container px-4 mx-auto">
      <div class="flex justify-between items-center py-3">
        <!-- Logo section -->
        <router-link 
          to="/" 
          :class="[
            'flex items-center space-x-3 text-xl font-bold transition-colors duration-300',
            'text-gray-800 hover:text-crimson-600'
          ]"
          @click="closeMobileMenu">
          <img src="../assets/images/wmsu-logo.png" alt="Logo" class="h-10 w-auto md:h-12">
          <span class="text-lg md:text-xl">Testing & Evaluation Center</span>
        </router-link>    
    
        <!-- Mobile menu button -->
        <button 
          @click="toggleMobileMenu"
          class="md:hidden flex items-center p-2 rounded-lg transition-colors duration-300 focus:outline-none focus:ring-2 focus:ring-inset"
          :class="[
            'text-gray-700 hover:bg-gray-100 focus:ring-crimson-400'
          ]"
          aria-label="Toggle menu"
          :aria-expanded="isMobileMenuOpen">
          <div class="hamburger-icon w-6 h-5 relative">
            <span 
              class="hamburger-line absolute h-0.5 w-full transition-all duration-300 ease-in-out left-0"
              :class="[
                'bg-gray-700',
                { 'rotate-45 top-2.5': isMobileMenuOpen, 'top-0': !isMobileMenuOpen }
              ]"
            ></span>
            <span 
              class="hamburger-line absolute h-0.5 w-full transition-all duration-300 ease-in-out left-0"
              :class="[
                'bg-gray-700',
                { 'opacity-0 translate-x-full': isMobileMenuOpen, 'opacity-100 top-2.5': !isMobileMenuOpen }
              ]"
            ></span>
            <span 
              class="hamburger-line absolute h-0.5 w-full transition-all duration-300 ease-in-out left-0"
              :class="[
                'bg-gray-700',
                { '-rotate-45 top-2.5': isMobileMenuOpen, 'top-5': !isMobileMenuOpen }
              ]"
            ></span>
          </div>
        </button>
        
        <!-- Desktop menu -->
        <div class="hidden md:flex items-center space-x-8">
          <!-- Navigation links -->
          <div 
            class="flex space-x-1 lg:space-x-2 text-gray-700"
          >
            <router-link 
              v-for="(item, index) in navigationItems"
              :key="index"
              :to="item.path"
              class="px-3 py-2 rounded-md text-sm font-medium transition-all duration-300 flex items-center gap-1.5 hover:bg-crimson-50 hover:text-crimson-600 hover:scale-[1.02] active:scale-[0.98]"
              :class="{
                'bg-crimson-100 text-crimson-700': isCurrentRoute(item.path)
              }"              @click.native="refreshPageIfSame(item.path)">
              <font-awesome-icon :icon="item.icon" />
              <span>{{ item.name }}</span>
            </router-link>
          </div>
          
          <!-- Account buttons -->
          <div class="flex items-center space-x-3">
            <!-- Show these buttons when logged in -->
            <template v-if="isAuthenticated">
              <router-link 
                to="/profile" 
                class="flex items-center gap-2 px-4 py-2 rounded-md text-sm font-medium border transition-all duration-300 border-gray-300 text-gray-700 hover:bg-gray-50 hover:text-crimson-600 hover:border-crimson-200 hover:shadow-md hover:scale-[1.02] active:scale-[0.98]"
              >                <font-awesome-icon :icon="['fas', 'user']" />
                <span>Profile</span>
              </router-link>
              <a 
                @click.prevent="initiateLogout" 
                href="#" 
                class="flex items-center gap-2 px-4 py-2 rounded-md text-sm font-medium transition-all duration-300 cursor-pointer border bg-crimson-600 text-white border-transparent hover:bg-crimson-700 hover:shadow-lg hover:scale-[1.02] active:scale-[0.98] active:bg-crimson-800"
              >
                <font-awesome-icon :icon="['fas', 'sign-out-alt']" />
                <span>Logout</span>
              </a>
            </template>
            
            <!-- Show these buttons when logged out -->
            <template v-else>
              <router-link 
                to="/login" 
                class="flex items-center gap-2 px-4 py-2 rounded-md text-sm font-medium border transition-all duration-300 border-gray-300 text-gray-700 hover:bg-gray-50 hover:text-crimson-600 hover:border-crimson-200 hover:shadow-md hover:scale-[1.02] active:scale-[0.98]"
              >                <font-awesome-icon :icon="['fas', 'sign-in-alt']" />
                <span>Login</span>
              </router-link>
              <router-link 
                to="/signup" 
                class="flex items-center gap-2 px-4 py-2 rounded-md text-sm font-medium transition-all duration-300 border bg-crimson-600 text-white border-transparent hover:bg-crimson-700 hover:shadow-lg hover:scale-[1.02] active:scale-[0.98] active:bg-crimson-800"
              >                <font-awesome-icon :icon="['fas', 'user-plus']" />
                <span>Register</span>
              </router-link>
            </template>
          </div>
        </div>
      </div>
      
      <!-- Mobile Menu -->
      <Transition
        enter-active-class="transition-all duration-300 ease-out origin-top"
        enter-from-class="opacity-0 scale-y-95"
        enter-to-class="opacity-100 scale-y-100"
        leave-active-class="transition-all duration-200 ease-in origin-top"
        leave-from-class="opacity-100 scale-y-100"
        leave-to-class="opacity-0 scale-y-95"
      >
        <div 
          v-if="isMobileMenuOpen" 
          class="md:hidden pb-4 border-t border-gray-200"
        >
          <div class="flex flex-col space-y-1 pt-3 px-2">
            <router-link 
              v-for="(item, index) in navigationItems"
              :key="index"
              :to="item.path"
              class="flex items-center gap-3 px-3 py-3 rounded-md text-base font-medium transition-all duration-300"
              :class="isCurrentRoute(item.path) 
                ? 'bg-crimson-100 text-crimson-700' 
                : 'text-gray-700 hover:bg-crimson-50 hover:text-crimson-600 hover:scale-[1.02] active:scale-[0.98]'"
              @click="refreshPageIfSame(item.path); closeMobileMenu()">
              <font-awesome-icon :icon="item.icon" class="w-5 h-5" />
              <span>{{ item.name }}</span>
            </router-link>
          </div>
          
          <!-- Mobile account buttons -->
          <div class="mt-4 pt-4 border-t border-gray-200 px-2 space-y-2">
            <!-- Show these buttons when logged in (mobile) -->
            <template v-if="isAuthenticated">
              <router-link 
                to="/profile" 
                @click="closeMobileMenu" 
                class="flex items-center gap-3 px-3 py-3 rounded-md text-base font-medium text-gray-700 hover:bg-gray-50 hover:text-crimson-600 hover:shadow-md hover:scale-[1.02] active:scale-[0.98] transition-all duration-300"
              >
                <font-awesome-icon :icon="['fas', 'user']" class="w-5 h-5" />
                <span>Profile</span>
              </router-link>
              <a 
                @click="logoutAndClose" 
                href="#" 
                class="flex items-center gap-3 px-3 py-3 rounded-md text-base font-medium text-gray-700 hover:bg-gray-50 hover:text-crimson-600 hover:shadow-md hover:scale-[1.02] active:scale-[0.98] transition-all duration-300"
              >
                <font-awesome-icon :icon="['fas', 'sign-out-alt']" class="w-5 h-5" />
                <span>Logout</span>
              </a>
            </template>
            
            <!-- Show these buttons when logged out (mobile) -->
            <template v-else>
              <router-link 
                to="/login" 
                @click="closeMobileMenu" 
                class="flex items-center gap-3 px-3 py-3 rounded-md text-base font-medium text-gray-700 hover:bg-gray-50 hover:text-crimson-600 hover:shadow-md hover:scale-[1.02] active:scale-[0.98] transition-all duration-300"
              >
                <font-awesome-icon :icon="['fas', 'sign-in-alt']" class="w-5 h-5" />
                <span>Login</span>
              </router-link>
              <router-link 
                to="/signup" 
                @click="closeMobileMenu" 
                class="w-full flex items-center justify-center gap-3 px-3 py-3 rounded-md text-base font-medium bg-crimson-600 text-white hover:bg-crimson-700 hover:shadow-lg hover:scale-[1.02] active:scale-[0.98] active:bg-crimson-800 transition-all duration-300 mt-2"
              >
                <font-awesome-icon :icon="['fas', 'user-plus']" class="w-5 h-5" />
                <span>Register</span>
              </router-link>
            </template>
          </div>
        </div>
      </Transition>
    </div>
    
    <!-- Logout Confirmation Modal -->
    <Modal
      :show="showLogoutModal"
      title="Confirm Logout"
      message="Are you sure you want to log out of your account?"
      type="warning"
      confirm-text="Yes, Log Out"
      cancel-text="Cancel"
      :icon="['fas', 'sign-out-alt']"
      @confirm="confirmLogout"
      @close="showLogoutModal = false"
    />
  </nav>
</template>

<script>
import { ref, onMounted, onUnmounted, computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import AuthService from '../services/auth.service'
import { userStore } from '../store/user'
import { useToast } from '../composables/useToast'
import Modal from './Modal.vue'

export default {
  name: 'Navbar',
  components: {
    Modal
  },
  setup() {
    const route = useRoute()
    const router = useRouter()
    const isMobileMenuOpen = ref(false)
    const isAuthenticated = ref(false)
    const { toasts, showToast } = useToast()
    const showLogoutModal = ref(false)
    
    // Check authentication status on component mount
    const checkAuth = () => {
      isAuthenticated.value = !!AuthService.getCurrentUser()    }

    // Navigation items data
    const navigationItems = [
      { name: 'Home', path: '/', icon: ['fas', 'home'] },
      { name: 'Schedule', path: '/schedule', icon: ['fas', 'calendar-alt'] },
      { name: 'Announcements', path: '/announcements', icon: ['fas', 'bullhorn']},
      { name: 'Exam Passers', path: '/results', icon: ['fas', 'award']},
      { name: 'Exam Scores', path: '/scores', icon: ['fas', 'graduation-cap']},
      { name: 'FAQ', path: '/faq', icon: ['fas', 'question-circle'] }
    ]

    const toggleMobileMenu = () => {
      isMobileMenuOpen.value = !isMobileMenuOpen.value
      // Prevent body scroll when mobile menu is open
      document.body.style.overflow = isMobileMenuOpen.value ? 'hidden' : ''
    }

    const closeMobileMenu = () => {
      if (isMobileMenuOpen.value) {
        isMobileMenuOpen.value = false
        document.body.style.overflow = ''
      }
    }

    const isCurrentRoute = (path) => {
      // Handle base path '/' specifically if needed
      if (path === '/') return route.path === '/'
      return route.path.startsWith(path)
    }
    
    const initiateLogout = () => {
      showLogoutModal.value = true
    }
    
    const confirmLogout = () => {
      showLogoutModal.value = false
      AuthService.logout()
      checkAuth() // Update auth state immediately
      // Redirect to home with logout success indicator
      router.push({ path: '/', query: { logout: 'success' } }).catch(() => {});
      closeMobileMenu()
    }
    
    const logoutAndClose = () => {
      initiateLogout()
    }

    const refreshPageIfSame = (path) => {
      if (route.path === path) {
        router.go(0) // Consider if a full page refresh is desired or just state update
      }
    }

    // Close mobile menu when clicking outside
    const handleClickOutside = (event) => {
      const nav = document.querySelector('nav')
      if (isMobileMenuOpen.value && nav && !nav.contains(event.target)) {
        closeMobileMenu()
      }
    }

    // Close mobile menu on route change & check auth
    const handleRouteChange = () => {
      closeMobileMenu()
      checkAuth()
    }

    // Close mobile menu when screen size changes to desktop
    const handleResize = () => {
      if (window.innerWidth >= 768 && isMobileMenuOpen.value) {
        closeMobileMenu()
      }
    }

    onMounted(() => {
      checkAuth() // Initial auth check
      document.addEventListener('click', handleClickOutside)
      window.addEventListener('resize', handleResize)
      router.afterEach(handleRouteChange) // Use router hook for route changes
    })

    onUnmounted(() => {
      document.removeEventListener('click', handleClickOutside)
      window.removeEventListener('resize', handleResize)
      // Clean up body overflow style if component is destroyed with menu open
      document.body.style.overflow = '' 
    })

    return {
      isMobileMenuOpen,
      isAuthenticated,
      navigationItems,
      toggleMobileMenu,
      closeMobileMenu,
      isCurrentRoute,
      logoutAndClose,
      refreshPageIfSame,
      showToast,
      toasts,
      initiateLogout,
      confirmLogout,
      showLogoutModal,
    }
  }
}
</script>

<style scoped>
/* Add specific styles if needed, like custom hamburger animation details */
/* Base styles for hamburger line are applied via Tailwind */
</style>
