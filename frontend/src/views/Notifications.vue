<template>
  <div class="container mx-auto px-4 py-8">
    <div class="max-w-4xl mx-auto">
      <div class="bg-white rounded-lg shadow-md p-6">
        <div class="flex items-center justify-between mb-6">
          <h1 class="text-3xl font-bold text-gray-900">
            <i class="fas fa-bell mr-3 text-blue-600"></i>
            Notifications
          </h1>
          <button 
            @click="markAllAsRead"
            class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors"
            :disabled="unreadCount === 0"
          >
            Mark All as Read
          </button>
        </div>

        <!-- Filter Tabs -->
        <div class="flex border-b border-gray-200 mb-6">
          <button
            v-for="filter in filters"
            :key="filter.key"
            @click="activeFilter = filter.key"
            :class="[
              'px-4 py-2 font-medium text-sm border-b-2 transition-colors',
              activeFilter === filter.key
                ? 'border-blue-500 text-blue-600'
                : 'border-transparent text-gray-500 hover:text-gray-700'
            ]"
          >
            {{ filter.label }}
            <span v-if="filter.count > 0" class="ml-2 px-2 py-1 text-xs bg-gray-100 rounded-full">
              {{ filter.count }}
            </span>
          </button>
        </div>

        <!-- Notifications List -->
        <div v-if="filteredNotifications.length > 0" class="space-y-4">
          <div
            v-for="notification in filteredNotifications"
            :key="notification.id"
            :class="[
              'flex items-start p-4 rounded-lg border transition-all cursor-pointer',
              !notification.read
                ? 'bg-blue-50 border-blue-200 hover:bg-blue-100'
                : 'bg-gray-50 border-gray-200 hover:bg-gray-100'
            ]"
            @click="markAsRead(notification)"
          >
            <!-- Icon -->
            <div :class="[
              'flex-shrink-0 w-10 h-10 rounded-full flex items-center justify-center mr-4',
              getNotificationIconClass(notification.type)
            ]">
              <i :class="getNotificationIcon(notification.type)"></i>
            </div>

            <!-- Content -->
            <div class="flex-1 min-w-0">
              <div class="flex items-center justify-between">
                <h3 class="text-sm font-medium text-gray-900 truncate">
                  {{ notification.title }}
                </h3>
                <div class="flex items-center ml-4">
                  <span class="text-xs text-gray-500">
                    {{ formatDate(notification.created_at) }}
                  </span>
                  <div 
                    v-if="!notification.read"
                    class="ml-2 w-2 h-2 bg-blue-600 rounded-full"
                  ></div>
                </div>
              </div>
              <p class="mt-1 text-sm text-gray-600">
                {{ notification.message }}
              </p>
              <div v-if="notification.action_url" class="mt-2">
                <button 
                  @click.stop="handleAction(notification)"
                  class="text-sm text-blue-600 hover:text-blue-800 font-medium"
                >
                  {{ notification.action_text || 'View Details' }}
                </button>
              </div>
            </div>
          </div>
        </div>

        <!-- Empty State -->
        <div v-else class="text-center py-12">
          <i class="fas fa-bell-slash text-4xl text-gray-300 mb-4"></i>
          <h3 class="text-lg font-medium text-gray-900 mb-2">No notifications</h3>
          <p class="text-gray-500">
            {{ activeFilter === 'all' ? 'You have no notifications yet.' : `No ${activeFilter} notifications.` }}
          </p>
        </div>

        <!-- Pagination -->
        <div v-if="totalPages > 1" class="mt-8 flex items-center justify-between">
          <div class="text-sm text-gray-700">
            Showing {{ ((currentPage - 1) * perPage) + 1 }} to {{ Math.min(currentPage * perPage, totalNotifications) }} of {{ totalNotifications }} notifications
          </div>
          <div class="flex space-x-2">
            <button
              @click="currentPage--"
              :disabled="currentPage === 1"
              class="px-3 py-2 text-sm border border-gray-300 rounded-md hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed"
            >
              Previous
            </button>
            <button
              v-for="page in visiblePages"
              :key="page"
              @click="currentPage = page"
              :class="[
                'px-3 py-2 text-sm border rounded-md',
                page === currentPage
                  ? 'bg-blue-600 text-white border-blue-600'
                  : 'border-gray-300 hover:bg-gray-50'
              ]"
            >
              {{ page }}
            </button>
            <button
              @click="currentPage++"
              :disabled="currentPage === totalPages"
              class="px-3 py-2 text-sm border border-gray-300 rounded-md hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed"
            >
              Next
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'Notifications',
  data() {
    return {
      activeFilter: 'all',
      currentPage: 1,
      perPage: 10,
      notifications: [
        // Mock data - replace with actual API calls
        {
          id: 1,
          type: 'appointment',
          title: 'Appointment Confirmed',
          message: 'Your appointment for December 20, 2024 at 2:00 PM has been confirmed.',
          created_at: '2024-12-19T10:30:00Z',
          read: false,
          action_url: '/schedule',
          action_text: 'View Schedule'
        },
        {
          id: 2,
          type: 'announcement',
          title: 'New Announcement',
          message: 'Important update regarding examination schedules.',
          created_at: '2024-12-18T14:15:00Z',
          read: false,
          action_url: '/announcements',
          action_text: 'Read More'
        },
        {
          id: 3,
          type: 'system',
          title: 'System Maintenance',
          message: 'Scheduled maintenance will occur on December 22, 2024 from 2:00 AM to 4:00 AM.',
          created_at: '2024-12-17T09:00:00Z',
          read: true
        },
        {
          id: 4,
          type: 'reminder',
          title: 'Appointment Reminder',
          message: 'Don\'t forget your appointment tomorrow at 10:00 AM.',
          created_at: '2024-12-16T16:45:00Z',
          read: true,
          action_url: '/schedule',
          action_text: 'View Details'
        },
        {
          id: 5,
          type: 'appointment',
          title: 'Appointment Cancelled',
          message: 'Your appointment for December 15, 2024 has been cancelled. Please reschedule.',
          created_at: '2024-12-15T11:20:00Z',
          read: true,
          action_url: '/schedule',
          action_text: 'Reschedule'
        }
      ]
    }
  },
  computed: {
    filters() {
      const counts = this.notifications.reduce((acc, notification) => {
        acc[notification.type] = (acc[notification.type] || 0) + 1
        return acc
      }, {})

      return [
        { key: 'all', label: 'All', count: this.notifications.length },
        { key: 'appointment', label: 'Appointments', count: counts.appointment || 0 },
        { key: 'announcement', label: 'Announcements', count: counts.announcement || 0 },
        { key: 'system', label: 'System', count: counts.system || 0 },
        { key: 'reminder', label: 'Reminders', count: counts.reminder || 0 }
      ]
    },
    filteredNotifications() {
      let filtered = this.activeFilter === 'all' 
        ? this.notifications 
        : this.notifications.filter(n => n.type === this.activeFilter)
      
      // Sort by date (newest first) and read status
      filtered = filtered.sort((a, b) => {
        if (a.read !== b.read) {
          return a.read ? 1 : -1
        }
        return new Date(b.created_at) - new Date(a.created_at)
      })
      
      // Pagination
      const start = (this.currentPage - 1) * this.perPage
      const end = start + this.perPage
      return filtered.slice(start, end)
    },
    totalNotifications() {
      return this.activeFilter === 'all' 
        ? this.notifications.length 
        : this.notifications.filter(n => n.type === this.activeFilter).length
    },
    totalPages() {
      return Math.ceil(this.totalNotifications / this.perPage)
    },
    visiblePages() {
      const pages = []
      const start = Math.max(1, this.currentPage - 2)
      const end = Math.min(this.totalPages, this.currentPage + 2)
      
      for (let i = start; i <= end; i++) {
        pages.push(i)
      }
      return pages
    },
    unreadCount() {
      return this.notifications.filter(n => !n.read).length
    }
  },
  methods: {
    markAsRead(notification) {
      if (!notification.read) {
        notification.read = true
        // TODO: Make API call to mark as read
        // this.$api.markNotificationAsRead(notification.id)
      }
      
      if (notification.action_url) {
        this.$router.push(notification.action_url)
      }
    },
    markAllAsRead() {
      this.notifications.forEach(notification => {
        notification.read = true
      })
      // TODO: Make API call to mark all as read
      // this.$api.markAllNotificationsAsRead()
    },
    handleAction(notification) {
      this.markAsRead(notification)
    },
    getNotificationIcon(type) {
      const icons = {
        appointment: 'fas fa-calendar-alt',
        announcement: 'fas fa-bullhorn',
        system: 'fas fa-cog',
        reminder: 'fas fa-clock',
        default: 'fas fa-bell'
      }
      return icons[type] || icons.default
    },
    getNotificationIconClass(type) {
      const classes = {
        appointment: 'bg-green-100 text-green-600',
        announcement: 'bg-blue-100 text-blue-600',
        system: 'bg-gray-100 text-gray-600',
        reminder: 'bg-yellow-100 text-yellow-600',
        default: 'bg-gray-100 text-gray-600'
      }
      return classes[type] || classes.default
    },
    formatDate(dateString) {
      const date = new Date(dateString)
      const now = new Date()
      const diffTime = Math.abs(now - date)
      const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24))
      
      if (diffDays === 1) {
        return 'Yesterday'
      } else if (diffDays < 7) {
        return `${diffDays} days ago`
      } else {
        return date.toLocaleDateString()
      }
    }
  },
  watch: {
    activeFilter() {
      this.currentPage = 1
    }
  }
}
</script>

<style scoped>
/* Additional custom styles if needed */
</style>
