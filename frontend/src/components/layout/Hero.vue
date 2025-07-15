<template>
  <section class="hero-section relative min-h-[60vh] sm:min-h-[70vh] md:min-h-[calc(100vh-64px)] w-full flex items-center overflow-hidden isolate bg-gradient-to-br from-gray-900 via-gray-800 to-gray-900">
    <!-- Background Image Layer -->
    <div 
      class="absolute inset-0 bg-cover bg-center image-background transform scale-105 transition-transform duration-[2s] bg-gradient-to-br from-gray-900 via-gray-800 to-gray-900"
      style="background-image: url('https://i.ytimg.com/vi/JoimFFEafbE/maxresdefault.jpg');"
    ></div>
    
    <!-- Enhanced Overlay with multiple layers -->
    <div class="absolute inset-0 bg-gradient-to-br from-black/70 via-black/50 to-transparent backdrop-blur-sm"></div>
    <div class="absolute inset-0 bg-gradient-to-t from-black/60 via-transparent to-transparent"></div>
    
    <!-- Content container -->
    <div class="w-full relative z-10 px-4 sm:px-6 md:px-12 lg:px-16 py-8 sm:py-12">
      <div class="container mx-auto">
        <div class="flex flex-col md:flex-row items-center justify-between gap-8 md:gap-12 max-w-[2000px] mx-auto">
          <!-- Left side text content -->
          <div class="text-white w-full md:w-1/2 text-center md:text-left fade-in-left">
            <div class="md:inline-block">
              <span class="text-crimson-300 bg-white/10 backdrop-blur-lg px-4 py-1.5 rounded-full uppercase tracking-wider text-sm font-semibold mb-4 block">
                Western Mindanao State University
              </span>
            </div>
            
            <h1 class="text-4xl sm:text-5xl md:text-6xl font-extrabold text-white mb-6 leading-tight">
              Your Journey to 
              <span class="text-transparent bg-clip-text bg-gradient-to-r from-crimson-300 to-pink-300 relative inline-block">
                Success
                <span class="absolute -bottom-1 left-0 w-full h-1 bg-gradient-to-r from-crimson-300 to-pink-300 opacity-50 rounded-full"></span>
              </span>
              <br class="hidden sm:block" />
              Starts Here
            </h1>
            
            <p class="text-lg sm:text-xl text-gray-200 max-w-xl mb-8 leading-relaxed">
              Schedule your exams with ease and take the first step towards your academic goals. Our streamlined process ensures a smooth and efficient experience.
            </p>
            
            <div class="flex flex-col sm:flex-row gap-4 sm:gap-6 justify-center md:justify-start">
              <router-link 
                to="/schedule" 
                class="group inline-flex items-center gap-3 px-8 py-4 bg-gradient-to-r from-crimson-600 to-crimson-700 text-white rounded-xl font-semibold hover:from-crimson-700 hover:to-crimson-800 transition-all duration-300 transform hover:scale-105 shadow-lg hover:shadow-xl"
              >
                <span>Schedule Now</span>
                <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 transition-transform duration-300 group-hover:translate-x-1" viewBox="0 0 20 20" fill="currentColor">
                  <path fill-rule="evenodd" d="M10.293 5.293a1 1 0 011.414 0l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414-1.414L12.586 11H5a1 1 0 110-2h7.586l-2.293-2.293a1 1 0 010-1.414z" clip-rule="evenodd" />
                </svg>
              </router-link>
              
              <a 
                href="#features" 
                class="inline-flex items-center gap-2 px-6 py-4 bg-white/10 backdrop-blur text-white rounded-xl font-semibold hover:bg-white/20 transition-all duration-300"
              >
                <span>Learn More</span>
                <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 transition-transform duration-300 group-hover:translate-y-1" viewBox="0 0 20 20" fill="currentColor">
                  <path fill-rule="evenodd" d="M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z" clip-rule="evenodd" />
                </svg>
              </a>
            </div>
          </div>

          <!-- Right side logo/image with enhanced effects -->
          <div 
            class="w-full md:w-1/2 mt-10 md:mt-0 fade-in-right group logo-container perspective"
            @mousemove="handleMouseMove"
            @mouseleave="resetTilt"
          >
            <div 
              class="relative flex justify-center items-center transition-transform duration-300 ease-out" 
              :style="logoStyle"
            >
              <!-- Enhanced glow effect -->
              <div class="absolute w-64 h-64 md:w-80 md:h-80 bg-gradient-radial from-white/20 via-white/10 to-transparent rounded-full animate-slow-glow blur-2xl"></div>
              <div class="absolute w-48 h-48 md:w-64 md:h-64 bg-gradient-radial from-crimson-500/20 via-crimson-500/10 to-transparent rounded-full animate-slow-pulse blur-xl"></div>
              
            <img 
              src="../../assets/images/wmsu-logo.png" 
                alt="WMSU Logo" 
                class="relative z-10 rounded-lg w-[80%] sm:w-[70%] md:w-[85%] mx-auto h-auto transform transition-transform duration-500 group-hover:scale-105 floating drop-shadow-2xl"
            >
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<script>
import { ref, computed } from 'vue';

export default {
  name: 'Hero',
  setup() {
    const logoTilt = ref({ x: 0, y: 0 });

    const logoStyle = computed(() => ({
      transform: `rotateY(${logoTilt.value.x}deg) rotateX(${logoTilt.value.y}deg)`,
    }));

    const handleMouseMove = (event) => {
      const rect = event.currentTarget.getBoundingClientRect();
      const x = event.clientX - rect.left; // x position within the element.
      const y = event.clientY - rect.top;  // y position within the element.
      
      const centerX = rect.width / 2;
      const centerY = rect.height / 2;
      
      const rotateX = ((y - centerY) / centerY) * -5; // Max rotation 5 degrees
      const rotateY = ((x - centerX) / centerX) * 5;  // Max rotation 5 degrees
      
      logoTilt.value = { x: rotateY, y: rotateX };
    };

    const resetTilt = () => {
      logoTilt.value = { x: 0, y: 0 };
    };

    return {
      logoTilt,
      logoStyle,
      handleMouseMove,
      resetTilt,
    };
  },
  data() {
    return {
      isSmallScreen: false
    }
  },
  mounted() {
    console.log('Hero component mounted successfully');
    this.checkScreenSize();
    window.addEventListener('resize', this.checkScreenSize);
  },
  beforeUnmount() {
    window.removeEventListener('resize', this.checkScreenSize);
  },
  methods: {
    checkScreenSize() {
      this.isSmallScreen = window.innerWidth < 400;
    }
  }
}
</script>

<script setup>
// If you need to add any reactive data or methods, you can add them here
</script>

<style scoped>
.hero-section {
  isolation: isolate;
}

section {
  min-height: 60vh;
  min-height: 60dvh;
}

@media (min-width: 768px) {
  section {
    min-height: calc(100vh - 64px);
    min-height: calc(100dvh - 64px);
  }
}

.image-background {
  transition: background-image 0.5s ease-in-out;
}

/* Enhanced Glow Animation */
@keyframes slowGlow {
  0% { transform: scale(0.95); opacity: 0.4; }
  50% { transform: scale(1.05); opacity: 0.6; }
  100% { transform: scale(0.95); opacity: 0.4; }
}

@keyframes slowPulse {
  0% { transform: scale(0.98); opacity: 0.3; }
  50% { transform: scale(1.02); opacity: 0.5; }
  100% { transform: scale(0.98); opacity: 0.3; }
}

.animate-slow-glow {
  animation: slowGlow 5s ease-in-out infinite;
}

.animate-slow-pulse {
  animation: slowPulse 4s ease-in-out infinite;
  animation-delay: -2s;
}

/* Background radial gradient */
.bg-gradient-radial {
  background-image: radial-gradient(circle, var(--tw-gradient-stops));
}

/* Gradient text support */
.bg-clip-text {
  -webkit-background-clip: text;
  background-clip: text;
}

/* Enhanced Animations */
.fade-in-left {
  animation: fadeInLeft 1s ease-out forwards;
  opacity: 0;
}

.fade-in-right {
  animation: fadeInRight 1s ease-out 0.3s forwards;
  opacity: 0;
}

@keyframes fadeInLeft {
  from {
    opacity: 0;
    transform: translateX(-30px);
  }
  to {
    opacity: 1;
    transform: translateX(0);
  }
}

@keyframes fadeInRight {
  from {
    opacity: 0;
    transform: translateX(30px);
  }
  to {
    opacity: 1;
    transform: translateX(0);
  }
}

.floating {
  animation: floating 4s ease-in-out infinite;
}

@keyframes floating {
  0% { transform: translateY(0px); }
  50% { transform: translateY(-12px); }
  100% { transform: translateY(0px); }
}

/* Perspective for 3D tilt */
.perspective {
  perspective: 1000px;
}

.logo-container {
  transition: transform 0.4s ease-out;
}

/* Responsive Typography */
@media (max-width: 360px) {
  h1 {
    font-size: 2rem;
    line-height: 1.3;
  }
  
  p {
    font-size: 1rem;
  }
}

@media (max-height: 500px) and (orientation: landscape) {
  section {
    min-height: 100vh;
    padding: 2rem 0;
  }
  
  .flex-col {
    flex-direction: row;
  }
}

/* Enhanced drop shadow for logo */
.drop-shadow-2xl {
  filter: drop-shadow(0 25px 25px rgb(0 0 0 / 0.15));
}
</style> 