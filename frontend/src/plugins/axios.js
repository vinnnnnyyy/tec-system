import axios from 'axios'

const API_URL = import.meta.env.VITE_API_URL;

const instance = axios.create({
  baseURL: API_URL,
  headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  },
  withCredentials: false,
  timeout: 15000 // Add timeout of 15 seconds
})

// Request interceptor
instance.interceptors.request.use(
  config => {
    // Add CSRF token if available
    const csrfToken = document.cookie.split('; ')
      .find(row => row.startsWith('csrftoken='))
      ?.split('=')[1]
    
    if (csrfToken) {
      config.headers['X-CSRFToken'] = csrfToken
    }

    // Ensure URL ends with trailing slash for Django
    if (config.url && !config.url.endsWith('/') && !config.url.includes('?')) {
      config.url += '/'
    }

    const token = localStorage.getItem('access_token')
    if (token) {
      config.headers['Authorization'] = `Bearer ${token}`
    }

    return config
  },
  error => {
    console.error('Request error:', error)
    return Promise.reject(error)
  }
)

// Response interceptor
instance.interceptors.response.use(
  response => response,
  error => {
    if (error.response) {
      console.error('API Error Response:', {
        status: error.response.status,
        data: error.response.data,
        url: error.config.url,
        method: error.config.method
      })

      // Handle specific error cases
      switch (error.response.status) {
        case 500:
          console.error('Server error:', error.response.data)
          break
        case 403:
          console.error('Permission denied:', error.response.data)
          break
        case 401:
          console.error('Unauthorized:', error.response.data)
          // Handle authentication error (e.g., redirect to login)
          break
      }
    } else if (error.request) {
      console.error('No response received:', error.request)
    } else {
      console.error('Error setting up request:', error.message)
    }

    return Promise.reject(error)
  }
)

export default instance 
