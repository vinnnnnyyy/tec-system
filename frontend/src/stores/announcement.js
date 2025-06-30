import { defineStore } from 'pinia'
import axios from 'axios'

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
        const API_URL = import.meta.env.VITE_API_URL || 'http://127.0.0.1:8000'
        const response = await axios.get(`${API_URL}/api/announcements/`)
        this.announcements = response.data.results || response.data
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