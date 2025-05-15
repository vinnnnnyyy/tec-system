import { defineStore } from 'pinia'
import axios from '../plugins/axios.js'

// Import the API URL from the environment

export const usePrograms = defineStore('programs', {
  state: () => ({
    programs: [],
    loading: false,
    error: null
  }),

  actions: {
    async fetchPrograms() {
      this.loading = true
      this.error = null
      try {
        const response = await axios.get('api/programs/')
        this.programs = response.data
      } catch (error) {
        this.error = error.response?.data?.message || 'Failed to fetch programs'
        throw error
      } finally {
        this.loading = false
      }
    },

    async createProgram(programData) {
      this.loading = true
      this.error = null
      try {
        const response = await axios.post('api/programs/', programData)
        this.programs.push(response.data)
        return response.data
      } catch (error) {
        this.error = error.response?.data?.message || 'Failed to create program'
        throw error
      } finally {
        this.loading = false
      }
    },

    async updateProgram(programData) {
      this.loading = true
      this.error = null
      try {
        const response = await axios.put(`api/programs/${programData.id}/`, programData)
        const index = this.programs.findIndex(p => p.id === programData.id)
        if (index !== -1) {
          this.programs[index] = response.data
        }
        return response.data
      } catch (error) {
        this.error = error.response?.data?.message || 'Failed to update program'
        throw error
      } finally {
        this.loading = false
      }
    },

    async deleteProgram(programId) {
      this.loading = true
      this.error = null
      try {
        await axios.delete(`api/programs/${programId}/`)
        this.programs = this.programs.filter(p => p.id !== programId)
      } catch (error) {
        this.error = error.response?.data?.message || 'Failed to delete program'
        throw error
      } finally {
        this.loading = false
      }
    }
  }
}) 