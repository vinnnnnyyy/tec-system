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
            <!-- Notifications (show for all users, but different behavior for authenticated vs unauthenticated) -->
            <div class="relative" ref="notificationRef">
              <button
                @click.stop="toggleNotifications"
                class="notification-bell-button relative p-2 text-gray-600 hover:text-crimson-600 hover:bg-crimson-50 rounded-full transition-all duration-300 focus:outline-none focus:ring-2 focus:ring-crimson-500"
                :class="{ 'text-crimson-600 bg-crimson-50': showNotifications }"
              >
                <font-awesome-icon :icon="['fas', 'bell']" class="w-5 h-5" />
                <!-- Notification badge -->
                <span
                  v-if="unreadNotificationsCount > 0"
                  class="absolute -top-1 -right-1 bg-red-500 text-white text-xs rounded-full h-5 w-5 flex items-center justify-center font-medium animate-pulse"
                >
                  {{ unreadNotificationsCount > 99 ? '99+' : unreadNotificationsCount }}
                </span>
              </button>
              
              <!-- Notifications Dropdown -->
              <Transition
                enter-active-class="transition-all duration-200 ease-out"
                enter-from-class="opacity-0 scale-95 translate-y-1"
                enter-to-class="opacity-100 scale-100 translate-y-0"
                leave-active-class="transition-all duration-150 ease-in"
                leave-from-class="opacity-100 scale-100 translate-y-0"
                leave-to-class="opacity-0 scale-95 translate-y-1"
              >
                <div
                  v-if="showNotifications"
                  ref="notificationDropdownRef"
                  class="absolute right-0 mt-2 w-80 bg-white rounded-lg shadow-lg border border-gray-200 z-50 max-h-96 overflow-hidden notifications-dropdown"
                  @click.stop
                >
                  <!-- Dropdown Header -->
                  <div class="px-4 py-3 border-b border-gray-200 bg-gray-50">
                    <div class="flex items-center justify-between">
                      <h3 class="text-sm font-semibold text-gray-900">Notifications</h3>
                      <button
                        v-if="unreadNotificationsCount > 0"
                        @click="markAllAsRead"
                        class="text-xs text-crimson-600 hover:text-crimson-700 font-medium"
                      >
                        Mark all read
                      </button>
                    </div>
                  </div>
                  
                  <!-- Notifications List -->
                  <div class="max-h-80 overflow-y-auto">
                    <div v-if="notifications.length === 0" class="px-4 py-8 text-center text-gray-500">
                      <font-awesome-icon :icon="['fas', 'bell-slash']" class="w-8 h-8 mx-auto mb-2 text-gray-300" />
                      <p class="text-sm">No notifications yet</p>
                    </div>
                    
                    <div v-else>
                      <div
                        v-for="notification in notifications"
                        :key="notification.id"
                        class="px-4 py-3 border-b border-gray-100 hover:bg-gray-50 cursor-pointer transition-colors duration-200"
                        :class="{ 'bg-blue-50': !notification.is_read }"
                        @click="handleNotificationClick(notification)"
                      >
                        <div class="flex items-start space-x-3">
                          <div class="flex-shrink-0">
                            <div
                              class="w-8 h-8 rounded-full flex items-center justify-center"
                              :class="getNotificationIconClass(notification.type)"
                            >
                              <font-awesome-icon :icon="getNotificationIcon(notification.type)" class="w-4 h-4" />
                            </div>
                          </div>
                          <div class="flex-1 min-w-0">
                            <p class="text-sm font-medium text-gray-900" :class="{ 'font-semibold': !notification.is_read }">
                              {{ notification.title }}
                            </p>
                            <p class="text-sm text-gray-600 mt-1 line-clamp-2">
                              {{ notification.message }}
                            </p>
                            <p class="text-xs text-gray-400 mt-1">
                              {{ notification.time_ago || formatNotificationTime(notification.created_at) }}
                            </p>
                          </div>
                          <div v-if="!notification.is_read" class="flex-shrink-0">
                            <div class="w-2 h-2 bg-blue-500 rounded-full"></div>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                  
                  <!-- View All Link -->
                  <div v-if="notifications.length > 0" class="px-4 py-3 border-t border-gray-200 bg-gray-50">
                    <button
                      @click="closeNotifications"
                      class="text-sm text-crimson-600 hover:text-crimson-700 font-medium"
                    >
                      Close notifications
                    </button>
                  </div>
                </div>
              </Transition>
            </div>

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
import NotificationService from '../services/notification.service'
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
    const showNotifications = ref(false)
    const notifications = ref([])
    const unreadNotificationsCount = ref(0)
    const notificationRef = ref(null)
    const notificationDropdownRef = ref(null)
    const notificationPollingInterval = ref(null)
    
    // Check authentication status on component mount
    const checkAuth = () => {
      const wasAuthenticated = isAuthenticated.value
      isAuthenticated.value = !!AuthService.getCurrentUser()
      
      // Fetch notifications when user logs in or when component loads
      if (!wasAuthenticated && isAuthenticated.value) {
        fetchNotifications()
        startNotificationPolling()
      }
      
      // Clear personal notifications when user logs out, but keep global ones
      if (wasAuthenticated && !isAuthenticated.value) {
        // Fetch notifications again to get only global notifications
        fetchNotifications()
      }
    }

    // Navigation items data
    const navigationItems = [
      { name: 'Home', path: '/', icon: ['fas', 'home'] },
      { name: 'Schedule', path: '/schedule', icon: ['fas', 'calendar-alt'] },
      { name: 'Announcements', path: '/announcements', icon: ['fas', 'bullhorn']},
      { name: 'Exam Passers', path: '/results', icon: ['fas', 'award']},
      // { name: 'Exam Scores', path: '/scores', icon: ['fas', 'graduation-cap']}, // Hidden
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

    // Notification functions
    const toggleNotifications = () => {
      showNotifications.value = !showNotifications.value
      if (showNotifications.value) {
        // Always fetch fresh notifications when opening the dropdown
        fetchNotifications()
      }
    }

    const closeNotifications = () => {
      showNotifications.value = false
    }

    const fetchNotifications = async () => {
      try {
        console.log('Fetching notifications...')
        const response = await NotificationService.getNotifications()
        console.log('Notifications response:', response)
        
        notifications.value = response.results || response
        unreadNotificationsCount.value = notifications.value.filter(n => !n.is_read).length
        
        console.log(`Loaded ${notifications.value.length} notifications, ${unreadNotificationsCount.value} unread`)
      } catch (error) {
        console.error('Error fetching notifications:', error)
        console.error('Error details:', error.response?.data || error.message)
        // Fallback to empty array on error
        notifications.value = []
        unreadNotificationsCount.value = 0
      }
    }

    // Polling functions for real-time notifications
    const startNotificationPolling = () => {
      if (notificationPollingInterval.value) {
        clearInterval(notificationPollingInterval.value)
      }
      
      // Poll for new notifications every 30 seconds (for all users)
      notificationPollingInterval.value = setInterval(() => {
        fetchNotifications()
      }, 30000) // 30 seconds
    }

    const stopNotificationPolling = () => {
      if (notificationPollingInterval.value) {
        clearInterval(notificationPollingInterval.value)
        notificationPollingInterval.value = null
      }
    }

    const markAllAsRead = async () => {
      try {
        await NotificationService.markAllAsRead()
        
        // Update local state
        notifications.value.forEach(notification => {
          notification.is_read = true
        })
        unreadNotificationsCount.value = 0
        
        showToast('All notifications marked as read', 'success')
      } catch (error) {
        console.error('Error marking notifications as read:', error)
        showToast('Failed to mark notifications as read', 'error')
      }
    }

    const handleNotificationClick = async (notification) => {
      try {
        // Mark as read if not already read
        if (!notification.is_read) {
          await NotificationService.markAsRead(notification.id)
          
          // Update local state
          notification.is_read = true
          unreadNotificationsCount.value = Math.max(0, unreadNotificationsCount.value - 1)
        }

        // Handle navigation based on notification type or link
        closeNotifications()
        
        if (notification.link) {
          // Use the notification's link if provided
          router.push(notification.link)
        } else {
          // Fallback navigation based on type
          switch (notification.type) {
            case 'appointment':
              router.push('/profile')
              break
            case 'exam':
              router.push('/scores')
              break
            case 'announcement':
              router.push('/announcements')
              break
            default:
              // Do nothing or show notification details
              break
          }
        }
      } catch (error) {
        console.error('Error handling notification click:', error)
        showToast('Error processing notification', 'error')
      }
    }

    const getNotificationIcon = (type) => {
      const icons = {
        appointment: ['fas', 'calendar-alt'],
        exam: ['fas', 'graduation-cap'],
        announcement: ['fas', 'bullhorn'],
        system: ['fas', 'cog'],
        default: ['fas', 'info-circle']
      }
      return icons[type] || icons.default
    }

    const getNotificationIconClass = (type) => {
      const classes = {
        appointment: 'bg-blue-100 text-blue-600',
        exam: 'bg-green-100 text-green-600',
        announcement: 'bg-amber-100 text-amber-600',
        system: 'bg-gray-100 text-gray-600',
        default: 'bg-gray-100 text-gray-600'
      }
      return classes[type] || classes.default
    }

    const formatNotificationTime = (timestamp) => {
      const now = new Date()
      const time = new Date(timestamp)
      const diffInSeconds = Math.floor((now - time) / 1000)
      
      if (diffInSeconds < 60) {
        return 'Just now'
      } else if (diffInSeconds < 3600) {
        const minutes = Math.floor(diffInSeconds / 60)
        return `${minutes}m ago`
      } else if (diffInSeconds < 86400) {
        const hours = Math.floor(diffInSeconds / 3600)
        return `${hours}h ago`
      } else if (diffInSeconds < 604800) {
        const days = Math.floor(diffInSeconds / 86400)
        return `${days}d ago`
      } else {
        return time.toLocaleDateString()
      }
    }

    // Close mobile menu when clicking outside
    const handleClickOutside = (event) => {
      const nav = document.querySelector('nav')
      if (isMobileMenuOpen.value && nav && !nav.contains(event.target)) {
        closeMobileMenu()
      }
      
      // Close notifications dropdown when clicking outside
      if (showNotifications.value && 
          notificationRef.value && 
          !notificationRef.value.contains(event.target)) {
        closeNotifications()
      }
    }

    // Close mobile menu on route change & check auth
    const handleRouteChange = () => {
      closeMobileMenu()
      closeNotifications()
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
      
      // Always start polling for notifications (for global notifications)
      fetchNotifications()
      startNotificationPolling()
      
      document.addEventListener('click', handleClickOutside)
      window.addEventListener('resize', handleResize)
      router.afterEach(handleRouteChange) // Use router hook for route changes
    })

    onUnmounted(() => {
      stopNotificationPolling() // Stop polling when component unmounts
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
      // Notification properties and methods
      showNotifications,
      notifications,
      unreadNotificationsCount,
      notificationRef,
      notificationDropdownRef,
      toggleNotifications,
      closeNotifications,
      fetchNotifications,
      startNotificationPolling,
      stopNotificationPolling,
      markAllAsRead,
      handleNotificationClick,
      getNotificationIcon,
      getNotificationIconClass,
      formatNotificationTime
    }
  }
}
</script>

<style scoped>
/* Add specific styles if needed, like custom hamburger animation details */
/* Base styles for hamburger line are applied via Tailwind */

/* Line clamp utility for notification text */
.line-clamp-2 {
  display: -webkit-box;
  -webkit-line-clamp: 2;
  line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

/* Custom notification badge pulse animation */
@keyframes notification-pulse {
  0%, 100% {
    transform: scale(1);
  }
  50% {
    transform: scale(1.1);
  }
}

.animate-pulse {
  animation: notification-pulse 2s infinite;
}

/* Notification dropdown scrollbar styling */
.notifications-dropdown .max-h-80::-webkit-scrollbar {
  width: 6px;
}

.notifications-dropdown .max-h-80::-webkit-scrollbar-track {
  background: #f1f1f1;
  border-radius: 3px;
}

.notifications-dropdown .max-h-80::-webkit-scrollbar-thumb {
  background: #c1c1c1;
  border-radius: 3px;
}

.notifications-dropdown .max-h-80::-webkit-scrollbar-thumb:hover {
  background: #a8a8a8;
}
</style>
