<template>
  <div class="flex h-screen bg-gray-100">
    <!-- Enhanced Sidebar -->
    <aside class="w-72 bg-gradient-to-b from-crimson-800 to-crimson-900 text-white flex flex-col h-full shadow-xl">
      <!-- Logo and Brand Section -->
      <div class="p-6 border-b border-crimson-700/30">
        <div class="flex items-center space-x-3">
          <img src="../../../assets/images/wmsu-logo.png" alt="Logo" class="h-12 w-auto filter drop-shadow-lg">
          <div class="space-y-1">
            <h1 class="text-lg font-bold leading-tight">Testing Evaluation</h1>
            <p class="text-sm text-crimson-200">Center Portal</p>
          </div>
        </div>
      </div>
      
      <!-- Navigation Sections -->
      <div class="flex-1 overflow-y-auto py-6 px-4">
        <!-- Main Section -->
        <div class="mb-8">
          <p class="text-xs uppercase text-crimson-300 font-semibold mb-3 px-3 tracking-wider">Main</p>
          <nav class="space-y-1">
            <router-link to="/admin/dashboard" 
              class="flex items-center space-x-3 px-4 py-3 rounded-xl transition-all duration-200 group"
              :class="[
                $route.path === '/admin/dashboard' 
                  ? 'bg-white/10 text-white shadow-lg' 
                  : 'text-crimson-100 hover:bg-white/5'
              ]"
              @click.native="refreshPageIfSame('/admin/dashboard')">
              <div class="w-5 h-5 flex items-center justify-center">
                <i class="fas fa-tachometer-alt"></i>
              </div>
              <span class="font-medium">Dashboard</span>
              <div v-if="$route.path === '/admin/dashboard'" 
                   class="ml-auto w-1.5 h-1.5 rounded-full bg-white"></div>
            </router-link>
          </nav>
        </div>
        
        <!-- Scheduling Section -->
        <div class="mb-8">
          <p class="text-xs uppercase text-crimson-300 font-semibold mb-3 px-3 tracking-wider">Scheduling</p>
          <nav class="space-y-1">
            <router-link v-for="(item, index) in schedulingItems" 
              :key="index"
              :to="item.path"
              class="flex items-center space-x-3 px-4 py-3 rounded-xl transition-all duration-200 group"
              :class="[
                $route.path === item.path 
                  ? 'bg-white/10 text-white shadow-lg' 
                  : 'text-crimson-100 hover:bg-white/5'
              ]"
              @click.native="refreshPageIfSame(item.path)">
              <div class="w-5 h-5 flex items-center justify-center">
                <i :class="item.icon"></i>
              </div>
              <span class="font-medium">{{ item.name }}</span>
              <div v-if="$route.path === item.path" 
                   class="ml-auto w-1.5 h-1.5 rounded-full bg-white"></div>
            </router-link>
          </nav>
        </div>
        
        <!-- Results Section -->
        <div class="mb-8">
          <p class="text-xs uppercase text-crimson-300 font-semibold mb-3 px-3 tracking-wider">Results</p>
          <nav class="space-y-1">
            <router-link to="/admin/results/import"
              class="flex items-center space-x-3 px-4 py-3 rounded-xl transition-all duration-200 group"
              :class="[
                $route.path === '/admin/results/import' 
                  ? 'bg-white/10 text-white shadow-lg' 
                  : 'text-crimson-100 hover:bg-white/5'
              ]">
              <div class="w-5 h-5 flex items-center justify-center">
                <i class="fas fa-file-import"></i>
              </div>
              <span class="font-medium">Import Results</span>
              <div v-if="$route.path === '/admin/results/import'" 
                   class="ml-auto w-1.5 h-1.5 rounded-full bg-white"></div>
            </router-link>
            
            <router-link to="/admin/results/import-score"
              class="flex items-center space-x-3 px-4 py-3 rounded-xl transition-all duration-200 group"
              :class="[
                $route.path === '/admin/results/import-score' 
                  ? 'bg-white/10 text-white shadow-lg' 
                  : 'text-crimson-100 hover:bg-white/5'
              ]">
              <div class="w-5 h-5 flex items-center justify-center">
                <i class="fas fa-file-contract"></i>
              </div>
              <span class="font-medium">Import Score</span>
              <div v-if="$route.path === '/admin/results/import-score'" 
                   class="ml-auto w-1.5 h-1.5 rounded-full bg-white"></div>
            </router-link>
            
            <router-link to="/admin/reports"
              class="flex items-center space-x-3 px-4 py-3 rounded-xl transition-all duration-200 group"
              :class="[
                $route.path === '/admin/reports' 
                  ? 'bg-white/10 text-white shadow-lg' 
                  : 'text-crimson-100 hover:bg-white/5'
              ]">
              <div class="w-5 h-5 flex items-center justify-center">
                <i class="fas fa-chart-bar"></i>
              </div>
              <span class="font-medium">Reports & Statistics</span>
              <div v-if="$route.path === '/admin/reports'" 
                   class="ml-auto w-1.5 h-1.5 rounded-full bg-white"></div>
            </router-link>
          </nav>
        </div>
        
        <!-- User Section -->
        <div class="mb-8">
          <p class="text-xs uppercase text-crimson-300 font-semibold mb-3 px-3 tracking-wider">User</p>
          <nav class="space-y-1">
            <router-link to="/admin/settings"
              class="flex items-center space-x-3 px-4 py-3 rounded-xl transition-all duration-200 group"
              :class="[
                $route.path === '/admin/settings' 
                  ? 'bg-white/10 text-white shadow-lg' 
                  : 'text-crimson-100 hover:bg-white/5'
              ]">
              <div class="w-5 h-5 flex items-center justify-center">
                <i class="fas fa-cog"></i>
              </div>
              <span class="font-medium">Settings</span>
              <div v-if="$route.path === '/admin/settings'" 
                   class="ml-auto w-1.5 h-1.5 rounded-full bg-white"></div>
            </router-link>
            
            <button @click="handleLogout" 
              class="w-full flex items-center space-x-3 px-4 py-3 rounded-xl transition-all duration-200 text-left text-crimson-100 hover:bg-white/5">
              <div class="w-5 h-5 flex items-center justify-center">
                <i class="fas fa-sign-out-alt"></i>
              </div>
              <span class="font-medium">Logout</span>
            </button>
          </nav>
        </div>
      </div>
      
      <!-- Enhanced User Profile Section -->
      <div class="p-4 mx-4 mb-4 rounded-xl bg-white/5 backdrop-blur-sm border border-white/10">
        <div class="flex items-center space-x-3">
          <div class="w-12 h-12 rounded-xl bg-gradient-to-br from-white/10 to-white/5 flex items-center justify-center text-white shadow-inner">
            <i class="fas fa-user text-lg"></i>
          </div>
          <div class="flex-1 min-w-0">
            <p class="text-sm font-medium text-white truncate">
              {{ user.first_name }} {{ user.last_name }}
            </p>
            <p class="text-xs text-crimson-200 truncate">{{ user.email }}</p>
          </div>
          <button @click="handleLogout" 
                  class="w-8 h-8 flex items-center justify-center rounded-lg hover:bg-white/10 text-crimson-200 hover:text-white transition-colors">
            <i class="fas fa-sign-out-alt"></i>
          </button>
        </div>
      </div>
    </aside>

    <!-- Main Content -->
    <div class="flex-1 flex flex-col overflow-hidden">
      <main class="flex-1 overflow-y-auto bg-gray-50">
        <router-view></router-view>
      </main>
    </div>

    <!-- Logout Modal -->
    <Modal
      :show="showLogoutModal"
      title="Confirm Logout"
      message="Are you sure you want to log out of your admin account?"
      type="warning"
      confirm-text="Yes, Log Out"
      cancel-text="Cancel"
      :icon="['fas', 'sign-out-alt']"
      @confirm="confirmLogout"
      @close="showLogoutModal = false"
    />
  </div>
</template>

<script>
import AuthService from '../../../services/auth.service';
import { useRouter } from 'vue-router';
import { ref } from 'vue';
import { useToast } from '../../../composables/useToast';
import Modal from '../../../components/Modal.vue';

export default {
  name: 'AdminLayout',
  components: {
    Modal
  },
  setup() {
    const router = useRouter();
    const { showToast } = useToast();
    const user = ref(AuthService.getCurrentUser());
    const showLogoutModal = ref(false);
    
    const schedulingItems = [
      { 
        name: 'Appointments', 
        path: '/admin/appointments', 
        icon: 'fas fa-calendar' 
      },
      { 
        name: 'Programs', 
        path: '/admin/program', 
        icon: 'fas fa-book' 
      },
      { 
        name: 'Test Sessions', 
        path: '/admin/test-sessions', 
        icon: 'fas fa-clipboard-check' 
      }
    ];
    
    const handleLogout = () => {
      showLogoutModal.value = true;
    };
    
    const confirmLogout = () => {
      showLogoutModal.value = false;
      AuthService.logout();
      router.push('/?logout=success');
    };
    
    const refreshPageIfSame = (path) => {
      if (router.currentRoute.value.path === path) {
        router.go(0);
      }
    };
    
    return {
      handleLogout,
      confirmLogout,
      user,
      showLogoutModal,
      refreshPageIfSame,
      schedulingItems
    };
  }
}
</script>

<style scoped>
/* Smooth scrolling for sidebar */
.overflow-y-auto {
  scrollbar-width: thin;
  scrollbar-color: rgba(255, 255, 255, 0.1) transparent;
}

.overflow-y-auto::-webkit-scrollbar {
  width: 4px;
}

.overflow-y-auto::-webkit-scrollbar-track {
  background: transparent;
}

.overflow-y-auto::-webkit-scrollbar-thumb {
  background-color: rgba(255, 255, 255, 0.1);
  border-radius: 20px;
}

/* Active link indicator animation */
.router-link-active .rounded-full {
  animation: pulse 2s cubic-bezier(0.4, 0, 0.6, 1) infinite;
}

@keyframes pulse {
  0%, 100% {
    opacity: 1;
  }
  50% {
    opacity: .5;
  }
}

/* Hover animations */
.group:hover {
  transform: translateX(4px);
  transition: transform 0.2s ease-out;
}

/* Logo shadow effect */
.filter.drop-shadow-lg {
  filter: drop-shadow(0 4px 6px rgba(0, 0, 0, 0.1));
}
</style>