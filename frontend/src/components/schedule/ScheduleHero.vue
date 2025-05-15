<template>
  <section class="relative min-h-[600px] flex items-center py-20 sm:py-28 md:py-32 overflow-hidden">
    <!-- Background image -->
    <div 
      class="absolute inset-0 bg-cover bg-center bg-no-repeat transform scale-105 transition-transform duration-[2s]"
      :style="{ backgroundImage: `url('https://i.ytimg.com/vi/JoimFFEafbE/maxresdefault.jpg')` }"
    ></div>
    
    <!-- Enhanced Overlay with multiple layers -->
    <div class="absolute inset-0 bg-gradient-to-br from-black/70 via-black/50 to-transparent backdrop-blur-sm"></div>
    <div class="absolute inset-0 bg-gradient-to-t from-black/60 via-transparent to-transparent"></div>
    
    <!-- Content -->
    <div class="container mx-auto px-4 relative z-10">
      <div class="max-w-7xl mx-auto">
        <div class="max-w-2xl">
          <!-- Main Content -->
          <div class="text-left animate-fade-in-up">
            <div class="inline-block">
              <span class="text-crimson-300 bg-white/10 backdrop-blur-lg px-4 py-1.5 rounded-full uppercase tracking-wider text-sm font-semibold mb-4 block">
                Schedule Your Visit
              </span>
            </div>
            
            <h1 class="text-4xl sm:text-5xl md:text-6xl font-extrabold text-white mb-6 leading-tight">
              Book Your <span class="text-transparent bg-clip-text bg-gradient-to-r from-crimson-300 to-pink-300">Application</span> Appointment
            </h1>
            
            <p class="text-lg sm:text-xl text-gray-200 max-w-xl mb-8 leading-relaxed">
              Find and secure your preferred time slot to submit your application form. Our streamlined process ensures a smooth and efficient experience.
            </p>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<script>
export default {
  name: 'ScheduleHero'
}
</script>

<style scoped>
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

.animate-fade-in-up {
  animation: fadeInUp 0.6s ease-out forwards;
}

/* Ensure consistent background handling */
.bg-cover {
  background-size: cover;
}
.bg-center {
  background-position: center;
}
.bg-no-repeat {
  background-repeat: no-repeat;
}

/* Gradient text support */
.bg-clip-text {
  -webkit-background-clip: text;
  background-clip: text;
}
</style> 