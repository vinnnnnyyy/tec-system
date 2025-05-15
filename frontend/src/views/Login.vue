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
        <h2 class="text-center text-2xl sm:text-3xl font-extrabold text-white drop-shadow-lg">Sign in to your account</h2>
        <p class="mt-2 sm:mt-3 text-center text-sm text-gray-200 drop-shadow">
          Or
          <router-link to="/signup" class="font-medium text-crimson-400 hover:text-crimson-300 transition-colors duration-200 hover:underline">
            create a new account
          </router-link>
        </p>
      </div>

      <!-- Login Form Section -->
      <div class="sm:mx-auto sm:w-full sm:max-w-md animate-fade-in-up" style="animation-delay: 150ms;">
        <div class="bg-white/90 backdrop-blur-xl py-8 px-4 sm:px-10 shadow-2xl rounded-xl border border-white/20 hover:shadow-crimson-600/10 transition-shadow duration-300">
          <!-- Error message display -->
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
          
          <form @submit.prevent="handleLogin" class="space-y-6">
            <!-- Email input -->
            <div class="group">
              <label for="email" class="block text-sm font-medium text-gray-700 group-hover:text-gray-900 transition-colors duration-200">Email address</label>
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
                  class="block w-full pl-10 pr-3 py-2.5 border border-gray-300 rounded-lg shadow-sm focus:outline-none focus:ring-2 focus:ring-crimson-500 focus:border-transparent sm:text-sm bg-white/90 hover:bg-white transition-colors duration-200"
                  placeholder="Email address"
                />
              </div>
            </div>

            <!-- Password input with visibility toggle -->
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
                  autocomplete="current-password"
                  required
                  class="block w-full pl-10 pr-10 py-2.5 border border-gray-300 rounded-lg shadow-sm focus:outline-none focus:ring-2 focus:ring-crimson-500 focus:border-transparent sm:text-sm bg-white/90 hover:bg-white transition-colors duration-200"
                  placeholder="Password"
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

            <div class="flex items-center justify-between flex-wrap sm:flex-nowrap gap-2">
              <div class="flex items-center">
                <input
                  id="remember-me"
                  v-model="rememberMe"
                  name="remember-me"
                  type="checkbox"
                  class="h-4 w-4 text-crimson-600 focus:ring-crimson-500 border-gray-300 rounded transition-colors duration-200"
                />
                <label for="remember-me" class="ml-2 block text-sm text-gray-700 hover:text-gray-900 transition-colors duration-200">
                  Remember me
                </label>
              </div>

              <div class="text-sm">
                <a href="#" class="font-medium text-crimson-600 hover:text-crimson-500 transition-colors duration-200 hover:underline">
                  Forgot password?
                </a>
              </div>
            </div>

            <div>
              <button 
                type="submit" 
                class="w-full flex justify-center items-center py-2.5 px-4 border border-transparent rounded-lg shadow-sm text-sm font-medium text-white bg-gradient-to-r from-crimson-600 to-crimson-700 hover:from-crimson-700 hover:to-crimson-800 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-crimson-500 transform hover:scale-[1.02] transition-all duration-200"
                :disabled="loading"
              >
                <span v-if="loading" class="animate-spin mr-2">
                  <font-awesome-icon icon="circle-notch" />
                </span>
                <span v-else class="mr-2">
                  <font-awesome-icon icon="sign-in-alt" />
                </span>
                {{ loading ? 'Signing in...' : 'Sign in' }}
              </button>
            </div>

            <div class="relative my-6">
              <div class="absolute inset-0 flex items-center">
                <div class="w-full border-t border-gray-300"></div>
              </div>
              <div class="relative flex justify-center text-sm">
                <span class="px-4 py-1 bg-white/80 text-gray-600 rounded-full border border-gray-200">Or continue with</span>
              </div>
            </div>

            <div>
              <button
                type="button"
                id="googleSignIn"
                @click="googleLogin"
                class="w-full flex items-center justify-center px-4 py-2.5 border border-gray-300 rounded-lg shadow-sm text-sm font-medium text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-crimson-500 transform hover:scale-[1.02] transition-all duration-200"
              >
                <img
                  class="h-5 w-5 mr-2"
                  src="https://www.svgrepo.com/show/475656/google-color.svg"
                  alt="Google logo"
                />
                Sign in with Google
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { ref, onMounted } from 'vue';
import { useRouter, useRoute } from 'vue-router';
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome';
import { faSignInAlt, faExclamationCircle, faLock, faEye, faEyeSlash, faCheckCircle, faTimes } from '@fortawesome/free-solid-svg-icons';
import { library } from '@fortawesome/fontawesome-svg-core';
import AuthService from '../services/auth.service';
import { useToast } from '../composables/useToast';

library.add(faSignInAlt, faExclamationCircle, faLock, faEye, faEyeSlash, faCheckCircle, faTimes);

export default {
  name: 'LoginView',
  components: {
    FontAwesomeIcon
  },
  setup() {
    const router = useRouter();
    const route = useRoute();
    const { showToast } = useToast();
    
    const email = ref('');
    const password = ref('');
    const rememberMe = ref(false);
    const error = ref('');
    const loading = ref(false);
    const showPassword = ref(false);

    const togglePasswordVisibility = () => {
      showPassword.value = !showPassword.value;
    };

    const handleLogin = async () => {
      if (!email.value || !password.value) {
        error.value = 'Please enter both email and password';
        return;
      }

      loading.value = true;
      error.value = '';

      try {
        const response = await AuthService.login(email.value, password.value);
        
        // Show toast on successful login
        showToast('Successfully logged in! Welcome back.', 'success');
        
        // Redirect based on user role
        if (AuthService.isAdmin()) {
          router.push('/admin/dashboard');
        } else {
          // Redirect to intended page or default page
          const redirectPath = route.query.redirect || '/schedule';
          router.push(redirectPath);
        }
      } catch (err) {
        error.value = err.response?.data?.detail || 'Login failed. Please check your credentials.';
      } finally {
        loading.value = false;
      }
    };

    const googleLogin = () => {
      // TODO: Implement Google OAuth login
      console.log('Google login clicked');
    };

    onMounted(() => {
      // Check if registeredEmail exists in the query (redirect from signup)
      if (route.query.registered === 'success') {
        // Show success toast using the centralized system
        showToast('Registration successful! You can now sign in.', 'success');
        
        // Clean up URL
        router.replace({ 
          path: route.path,
          query: { ...route.query, registered: undefined }
        });
      }
    });

    return {
      email,
      password,
      rememberMe,
      error,
      loading,
      showPassword,
      togglePasswordVisibility,
      handleLogin,
      googleLogin,
      showToast
    };
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

/* Enhanced animations */
@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes subtleZoom {
  from {
    transform: scale(1);
  }
  to {
    transform: scale(1.1);
  }
}

.animate-fade-in-up {
  animation: fadeInUp 0.6s ease-out forwards;
}

.animate-subtle-zoom {
  animation: subtleZoom 20s ease-out forwards;
}

/* Enhanced shadows */
.drop-shadow-2xl {
  filter: drop-shadow(0 25px 25px rgb(0 0 0 / 0.15));
}

.drop-shadow-lg {
  filter: drop-shadow(0 10px 10px rgb(0 0 0 / 0.1));
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

/* Add animations for toast notifications */
@keyframes fadeIn {
  from { opacity: 0; transform: translateY(-10px); }
  to { opacity: 1; transform: translateY(0); }
}

.animate-fade-in {
  animation: fadeIn 0.3s ease-in-out;
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
  animation: shrink 5s linear forwards;
}

/* Responsive utilities */
@media (max-width: 640px) {
  .toast-container {
    width: calc(100% - 2rem);
    right: 1rem;
  }
}
</style> 