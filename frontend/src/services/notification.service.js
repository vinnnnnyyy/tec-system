import api from '../api/index.js'

class NotificationService {
  // Get all notifications for the current user
  async getNotifications() {
    try {
      const response = await api.get('/api/notifications/')
      return response.data
    } catch (error) {
      console.error('Error fetching notifications:', error)
      throw error
    }
  }

  // Get unread notifications count
  async getUnreadCount() {
    try {
      const response = await api.get('/api/notifications/unread-count/')
      return response.data.count
    } catch (error) {
      console.error('Error fetching unread count:', error)
      throw error
    }
  }

  // Mark a specific notification as read
  async markAsRead(notificationId) {
    try {
      const response = await api.post(`/api/notifications/${notificationId}/mark-read/`)
      return response.data
    } catch (error) {
      console.error('Error marking notification as read:', error)
      throw error
    }
  }

  // Mark all notifications as read
  async markAllAsRead() {
    try {
      const response = await api.post('/api/notifications/mark-all-read/')
      return response.data
    } catch (error) {
      console.error('Error marking all notifications as read:', error)
      throw error
    }
  }

  // Create a new notification (for admin use)
  async createNotification(notificationData) {
    try {
      const response = await api.post('/api/notifications/', notificationData)
      return response.data
    } catch (error) {
      console.error('Error creating notification:', error)
      throw error
    }
  }
}

export default new NotificationService()
