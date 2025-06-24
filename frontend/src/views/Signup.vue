<template>
  <div class="relative min-h-screen overflow-hidden">
    <!-- Background image with subtle zoom animation -->
    <div 
      class="fixed inset-0 bg-cover bg-center bg-no-repeat animate-subtle-zoom"
      :style="{ backgroundImage: `url('https://i.ytimg.com/vi/JoimFFEafbE/maxresdefault.jpg')` }"
    ></div>
    
    <!-- Enhanced overlay with stronger blur -->
    <div class="fixed inset-0 bg-gradient-to-b from-black/40 via-black/50 to-black/60 backdrop-blur-md"></div>
    
    <!-- Content -->
    <div class="relative min-h-screen flex flex-col justify-center py-12 sm:px-6 lg:px-8 px-4 z-10">
      <!-- Branding Header with animation -->
      <div class="sm:mx-auto sm:w-full sm:max-w-md mb-4 sm:mb-6 animate-fade-in-up">
        <div class="flex justify-center mb-4 transform hover:scale-105 transition-transform duration-300">
          <img src="../assets/images/wmsu-logo.png" alt="WMSU Logo" class="h-20 w-auto sm:h-24 drop-shadow-2xl">
        </div>
        <h2 class="text-center text-2xl sm:text-3xl font-extrabold text-white drop-shadow-lg">Create a new account</h2>
        <p class="mt-2 sm:mt-3 text-center text-sm text-gray-200 drop-shadow">
          Or
          <router-link to="/login" class="font-medium text-crimson-400 hover:text-crimson-300 transition-colors duration-200 hover:underline">
            sign in to your existing account
          </router-link>
        </p>
      </div>

      <!-- Signup Form Section -->
      <div class="sm:mx-auto sm:w-full sm:max-w-md animate-fade-in-up" style="animation-delay: 150ms;">
        <div class="bg-white/90 backdrop-blur-xl py-8 px-4 sm:px-10 shadow-2xl rounded-xl border border-white/20 hover:shadow-crimson-600/10 transition-shadow duration-300">
          <!-- Error Message -->
          <div v-if="error" class="rounded-lg bg-red-50/90 p-4 mb-6 border-l-4 border-red-500 animate-fade-in">
            <div class="flex">
              <div class="flex-shrink-0">
                <font-awesome-icon icon="exclamation-circle" class="h-5 w-5 text-red-500" aria-hidden="true" />
              </div>
              <div class="ml-3">
                <h3 class="text-sm font-medium text-red-800">{{ error }}</h3>
              </div>
            </div>
          </div>

          <form @submit.prevent="handleSignup" class="space-y-6">
            <!-- Name Fields - Responsive layout -->
            <div class="grid grid-cols-1 gap-3 sm:gap-5 sm:grid-cols-2">
              <!-- First Name -->
              <div class="group">
                <label for="firstName" class="block text-sm font-medium text-gray-700 group-hover:text-gray-900 transition-colors duration-200">First Name</label>
                <div class="relative mt-1">
                  <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                    <font-awesome-icon icon="user" class="h-5 w-5 text-gray-400 group-hover:text-crimson-500 transition-colors duration-200" />
                  </div>
                  <input
                    id="firstName"
                    v-model="firstName"
                    type="text"
                    required
                    class="block w-full pl-10 pr-3 py-2.5 border border-gray-300 rounded-lg shadow-sm focus:outline-none focus:ring-2 focus:ring-crimson-500 focus:border-transparent sm:text-sm bg-white/90 hover:bg-white transition-colors duration-200"
                    placeholder="First Name"
                  />
                </div>
              </div>

              <!-- Last Name -->
              <div class="group">
                <label for="lastName" class="block text-sm font-medium text-gray-700 group-hover:text-gray-900 transition-colors duration-200">Last Name</label>
                <div class="relative mt-1">
                  <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                    <font-awesome-icon icon="user" class="h-5 w-5 text-gray-400 group-hover:text-crimson-500 transition-colors duration-200" />
                  </div>
                  <input
                    id="lastName"
                    v-model="lastName"
                    type="text"
                    required
                    class="block w-full pl-10 pr-3 py-2.5 border border-gray-300 rounded-lg shadow-sm focus:outline-none focus:ring-2 focus:ring-crimson-500 focus:border-transparent sm:text-sm bg-white/90 hover:bg-white transition-colors duration-200"
                    placeholder="Last Name"
                  />
                </div>
              </div>
            </div>

            <!-- Email Address -->
            <div class="group">
              <label for="email" class="block text-sm font-medium text-gray-700 group-hover:text-gray-900 transition-colors duration-200">Email</label>
              <div class="relative mt-1">
                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                  <font-awesome-icon icon="envelope" class="h-5 w-5 text-gray-400 group-hover:text-crimson-500 transition-colors duration-200" />
                </div>
                <input
                  id="email"
                  v-model="email"
                  type="email"
                  autocomplete="email"
                  required
                  :disabled="otpSent"
                  class="block w-full pl-10 pr-3 py-2.5 border border-gray-300 rounded-lg shadow-sm focus:outline-none focus:ring-2 focus:ring-crimson-500 focus:border-transparent sm:text-sm bg-white/90 hover:bg-white transition-colors duration-200"
                  placeholder="Email address"
                />
                <button 
                  v-if="!otpSent && !otpVerified"
                  type="button"
                  @click="requestOTP"
                  :disabled="otpSending || !email"
                  class="absolute inset-y-0 right-0 px-3 py-2 text-sm text-crimson-600 hover:text-crimson-800 font-medium focus:outline-none transition-colors duration-200"
                >
                  {{ otpSending ? 'Sending...' : 'Send OTP' }}
                </button>
              </div>
            </div>

            <!-- OTP Verification Section -->
            <div class="group" v-if="showOtpInput">
              <label for="otpCode" class="block text-sm font-medium text-gray-700 group-hover:text-gray-900 transition-colors duration-200">
                OTP Code <span class="text-xs text-gray-500">(Expires in {{ formattedOtpTimer }})</span>
              </label>
              <div class="relative mt-1">
                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                  <font-awesome-icon icon="key" class="h-5 w-5 text-gray-400 group-hover:text-crimson-500 transition-colors duration-200" />
                </div>
                <input
                  id="otpCode"
                  v-model="otpCode"
                  type="text"
                  :disabled="otpVerified"
                  class="block w-full pl-10 pr-3 py-2.5 border border-gray-300 rounded-lg shadow-sm focus:outline-none focus:ring-2 focus:ring-crimson-500 focus:border-transparent sm:text-sm bg-white/90 hover:bg-white transition-colors duration-200"
                  placeholder="Enter OTP from email"
                  maxlength="6"
                />
                <button 
                  v-if="!otpVerified && otpSent"
                  type="button"
                  @click="verifyOTP"
                  :disabled="otpVerifying || !otpCode"
                  class="absolute inset-y-0 right-0 px-3 py-2 text-sm text-crimson-600 hover:text-crimson-800 font-medium focus:outline-none transition-colors duration-200"
                >
                  {{ otpVerifying ? 'Verifying...' : 'Verify' }}
                </button>
                <div v-if="otpVerified" class="absolute inset-y-0 right-0 px-3 py-2 flex items-center">
                  <font-awesome-icon icon="check-circle" class="h-5 w-5 text-green-500" />
                </div>
              </div>
              <p class="mt-1 text-xs text-gray-500">
                <button 
                  type="button" 
                  @click="requestOTP" 
                  :disabled="otpTimer > 0 || otpSending" 
                  class="text-crimson-600 hover:text-crimson-800 font-medium focus:outline-none"
                >
                  Resend OTP
                </button>
                <span v-if="otpTimer > 0"> (available in {{ formattedOtpTimer }})</span>
              </p>
            </div>

            <!-- Password with visibility toggle -->
            <div class="group">
              <label for="password" class="block text-sm font-medium text-gray-700 group-hover:text-gray-900 transition-colors duration-200">Password</label>
              <div class="relative mt-1">
                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                  <font-awesome-icon icon="lock" class="h-5 w-5 text-gray-400 group-hover:text-crimson-500 transition-colors duration-200" />
                </div>
                <input
                  id="password"
                  v-model="password"
                  :type="showPassword ? 'text' : 'password'"
                  autocomplete="new-password"
                  required
                  class="block w-full pl-10 pr-10 py-2.5 border border-gray-300 rounded-lg shadow-sm focus:outline-none focus:ring-2 focus:ring-crimson-500 focus:border-transparent sm:text-sm bg-white/90 hover:bg-white transition-colors duration-200"
                  placeholder="Create password"
                />
                <button 
                  type="button"
                  @click="togglePasswordVisibility"
                  class="absolute inset-y-0 right-0 px-3 py-2 flex items-center focus:outline-none hover:text-crimson-500 transition-colors duration-200"
                >
                  <font-awesome-icon :icon="showPassword ? 'eye-slash' : 'eye'" class="h-5 w-5 text-gray-400" />
                </button>
              </div>
            </div>

            <!-- Confirm Password with visibility toggle -->
            <div class="group">
              <label for="confirmPassword" class="block text-sm font-medium text-gray-700 group-hover:text-gray-900 transition-colors duration-200">Confirm Password</label>
              <div class="relative mt-1">
                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                  <font-awesome-icon icon="lock" class="h-5 w-5 text-gray-400 group-hover:text-crimson-500 transition-colors duration-200" />
                </div>
                <input
                  id="confirmPassword"
                  v-model="confirmPassword"
                  :type="showConfirmPassword ? 'text' : 'password'"
                  autocomplete="new-password"
                  required
                  class="block w-full pl-10 pr-10 py-2.5 border border-gray-300 rounded-lg shadow-sm focus:outline-none focus:ring-2 focus:ring-crimson-500 focus:border-transparent sm:text-sm bg-white/90 hover:bg-white transition-colors duration-200"
                  placeholder="Confirm password"
                />
                <button 
                  type="button"
                  @click="toggleConfirmPasswordVisibility"
                  class="absolute inset-y-0 right-0 px-3 py-2 flex items-center focus:outline-none hover:text-crimson-500 transition-colors duration-200"
                >
                  <font-awesome-icon :icon="showConfirmPassword ? 'eye-slash' : 'eye'" class="h-5 w-5 text-gray-400" />
                </button>
              </div>
            </div>

            <!-- Terms and Conditions -->
            <div class="flex items-start py-1 sm:py-2">
              <div class="flex items-center h-5">
                <input
                  id="terms"
                  v-model="agreeToTerms"
                  name="terms"
                  type="checkbox"
                  required
                  class="h-4 w-4 text-crimson-600 focus:ring-crimson-500 border-gray-300 rounded transition-colors duration-200"
                />
              </div>
              <div class="ml-3 text-sm">
                <label for="terms" class="font-medium text-gray-800 hover:text-gray-900 transition-colors duration-200">
                  I agree to the <a href="#" class="text-crimson-600 hover:text-crimson-700 underline">Terms and Conditions</a>
                </label>
              </div>
            </div>

            <!-- Sign up Button -->
            <div>
              <button 
                type="submit" 
                class="w-full flex justify-center py-2.5 px-4 border border-transparent rounded-lg shadow-sm text-sm font-medium text-white bg-gradient-to-r from-crimson-600 to-crimson-700 hover:from-crimson-700 hover:to-crimson-800 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-crimson-500 transform hover:scale-[1.02] transition-all duration-200"
                :disabled="loading"
              >
                <div class="flex items-center">
                  <span v-if="loading" class="animate-spin mr-2"><font-awesome-icon icon="circle-notch" /></span>
                  <font-awesome-icon icon="user-plus" class="mr-2 flex items-center" v-if="!loading" />
                  {{ !otpSent ? 'Continue with OTP' : (!otpVerified ? 'Verify OTP' : 'Create account') }}
                </div>
              </button>
            </div>

            <div class="relative my-4 sm:my-6">
              <div class="absolute inset-0 flex items-center">
                <div class="w-full border-t border-gray-300"></div>
              </div>
              <div class="relative flex justify-center text-xs sm:text-sm">
                <span class="px-2 bg-white/80 text-gray-600 rounded-full">Or continue with</span>
              </div>
            </div>

            <!-- Google Signup -->
            <div>
              <button
                type="button"
                id="googleSignUp"
                @click="googleSignup"
                class="w-full flex items-center justify-center px-4 py-2 sm:py-2.5 border border-gray-300 rounded-md shadow-sm text-sm font-medium text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-crimson-500 transition duration-200"
              >
                <img
                  class="h-4 w-4 sm:h-5 sm:w-5 mr-2"
                  src="https://www.svgrepo.com/show/475656/google-color.svg"
                  alt="Google logo"
                />
                Sign up with Google
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'
import { ref, computed, onUnmounted } from 'vue'
import { useRouter } from 'vue-router'
import AuthService from '../services/auth.service'
import { useToast } from '../composables/useToast'

export default {
  name: 'SignupView',
  components: {
    FontAwesomeIcon
  },
  setup() {
    const router = useRouter()
    const { showToast } = useToast()
    const firstName = ref('')
    const lastName = ref('')
    const email = ref('')
    const password = ref('')
    const confirmPassword = ref('')
    const agreeToTerms = ref(false)
    const error = ref('')
    const loading = ref(false)
    const showPassword = ref(false)
    const showConfirmPassword = ref(false)
    
    // OTP related states
    const otpCode = ref('')
    const otpSent = ref(false)
    const otpVerified = ref(false)
    const otpSending = ref(false)
    const otpVerifying = ref(false)
    const showOtpInput = ref(false)
    const otpTimer = ref(0)
    const otpTimerInterval = ref(null)

    const togglePasswordVisibility = () => {
      showPassword.value = !showPassword.value
    }

    const toggleConfirmPasswordVisibility = () => {
      showConfirmPassword.value = !showConfirmPassword.value
    }

    // Request OTP to be sent to the user's email
    const requestOTP = async () => {
      if (!email.value) {
        error.value = 'Please enter your email address'
        return
      }

      try {
        otpSending.value = true
        error.value = ''
        
        await AuthService.requestOTP(email.value)
        
        otpSent.value = true
        showOtpInput.value = true
        
        // Start a 10-minute countdown timer
        otpTimer.value = 10 * 60 // 10 minutes in seconds
        startOtpTimer()
        
        showToast('OTP sent successfully! Please check your email.', 'success')
      } catch (err) {
        error.value = err.message || 'Failed to send OTP. Please try again.'
      } finally {
        otpSending.value = false
      }
    }

    // Start the OTP countdown timer
    const startOtpTimer = () => {
      clearInterval(otpTimerInterval.value)
      
      otpTimerInterval.value = setInterval(() => {
        if (otpTimer.value > 0) {
          otpTimer.value--
        } else {
          clearInterval(otpTimerInterval.value)
          // OTP has expired
          showToast('OTP has expired. Please request a new one.', 'error')
          otpSent.value = false
        }
      }, 1000)
    }

    // Format the OTP timer as mm:ss
    const formattedOtpTimer = computed(() => {
      const minutes = Math.floor(otpTimer.value / 60)
      const seconds = otpTimer.value % 60
      return `${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`
    })

    // Verify the OTP entered by the user
    const verifyOTP = async () => {
      if (!otpCode.value) {
        error.value = 'Please enter the OTP code'
        return
      }

      try {
        otpVerifying.value = true
        error.value = ''
        
        await AuthService.verifyOTP(email.value, otpCode.value)
        
        otpVerified.value = true
        clearInterval(otpTimerInterval.value)
        
        showToast('Email verified successfully!', 'success')
      } catch (err) {
        error.value = err.message || 'Invalid or expired OTP. Please try again.'
      } finally {
        otpVerifying.value = false
      }
    }

    // Handle the form submission
    const handleSignup = async () => {
      try {
        // Reset error message
        error.value = ''
        
        // Validate inputs
        if (!firstName.value || !lastName.value || !email.value || !password.value) {
          error.value = 'Please fill in all fields'
          return
        }
        
        if (password.value !== confirmPassword.value) {
          error.value = 'Passwords do not match'
          return
        }
        
        if (!agreeToTerms.value) {
          error.value = 'You must agree to the Terms and Conditions'
          return
        }
        
        // If OTP not yet requested, request it now
        if (!otpSent.value) {
          await requestOTP()
          return
        }
        
        // If OTP not yet verified, verify it now
        if (!otpVerified.value) {
          await verifyOTP()
          return
        }
        
        // If OTP is verified, proceed with registration
        loading.value = true
        
        const response = await AuthService.registerWithOTP(
          firstName.value,
          lastName.value,
          email.value,
          password.value,
          otpCode.value
        )
        
        // Registration successful, show success message and redirect
        showToast('Account created successfully!', 'success')
        router.push('/schedule')
      } catch (err) {
        console.error('Signup error:', err)
        error.value = err.message || 'Registration failed. Please try again.'
      } finally {
        loading.value = false
      }
    }

    const googleSignup = () => {
      error.value = 'Google signup is not yet implemented'
    }
    
    // Clean up timer on component unmount
    onUnmounted(() => {
      clearInterval(otpTimerInterval.value)
    })

    return {
      firstName,
      lastName,
      email,
      password,
      confirmPassword,
      agreeToTerms,
      error,
      loading,
      showPassword,
      showConfirmPassword,
      togglePasswordVisibility,
      toggleConfirmPasswordVisibility,
      handleSignup,
      googleSignup,
      
      // OTP related
      otpCode,
      otpSent,
      otpVerified,
      otpSending,
      otpVerifying,
      showOtpInput,
      otpTimer,
      formattedOtpTimer,
      requestOTP,
      verifyOTP
    }
  }
}
</script>

<style scoped>
.bg-cover {
  background-size: cover;
}
.bg-center {
  background-position: center;
}
.bg-no-repeat {
  background-repeat: no-repeat;
}

.drop-shadow-md {
  filter: drop-shadow(0 4px 3px rgb(0 0 0 / 0.07)) drop-shadow(0 2px 2px rgb(0 0 0 / 0.06));
}
.drop-shadow {
  filter: drop-shadow(0 1px 1px rgb(0 0 0 / 0.05));
}

/* Add a simple fade-in animation for error and success messages */
@keyframes fadeIn {
  from { opacity: 0; transform: translateY(-10px); }
  to { opacity: 1; transform: translateY(0); }
}

.animate-fade-in {
  animation: fadeIn 0.3s ease-in-out;
}

/* Add responsive font size utility if needed */
@media (max-width: 640px) {
  .text-responsive {
    font-size: 0.875rem;
  }
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

/* Responsive utilities */
@media (max-width: 640px) {
  .toast-container {
    width: calc(100% - 2rem);
    right: 1rem;
  }
}

/* Add these new styles */
.fixed {
  position: fixed;
}
.relative {
  position: relative;
}
.z-10 {
  z-index: 10;
}
</style>