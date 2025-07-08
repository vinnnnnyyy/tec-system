import { defineStore } from 'pinia'
import axiosInstance from '../services/axios.interceptor'

export const useAnnouncementStore = defineStore('announcement', {
  state: () => ({
    announcements: [],
    loading: false,
    error: null
  }),
  
  actions: {
    async fetchAnnouncements() {
      this.loading = true
      this.error = null
      
      try {
        const response = await axiosInstance.get('/api/announcements/')
        this.announcements = response.data.results || response.data
        console.log('Fetched announcements:', this.announcements) // Debug log
      } catch (err) {
        console.error('Error fetching announcements:', err)
        this.error = 'Failed to load announcements'
        throw err
      } finally {
        this.loading = false
      }
    },
    
    clearAnnouncements() {
      this.announcements = []
    }
  },
  
  getters: {
    getAnnouncementById: (state) => (id) => {
      return state.announcements.find(announcement => announcement.id === id)
    },
    
    getFilteredAnnouncements: (state) => (type) => {
      if (!type || type === 'all') {
        return state.announcements
      }
      return state.announcements.filter(announcement => announcement.type === type)
    }
  }
})