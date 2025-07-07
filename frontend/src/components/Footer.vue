  <template>
  <footer class="relative bg-gradient-to-b from-gray-900 to-[#8B0000] text-gray-300 py-16 overflow-hidden">
    <!-- Background WMSU Logo Pattern -->
    <div 
      class="absolute inset-0 z-0 opacity-[0.08] bg-repeat bg-center transform rotate-12 scale-125"
      style="background-image: url('/src/assets/images/wmsu-logo.png'); background-size: 300px 300px;"
    ></div>
    <!-- Subtle Gradient Overlay -->
    <div class="absolute inset-0 z-1 bg-gradient-to-t via-gray-900/85 to-gray-900/80"></div>

    <div class="container mx-auto px-4 relative z-10">
      <!-- Main Footer Content -->
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-10 md:gap-12">
        
        <!-- Brand Section -->
        <div class="md:col-span-2 lg:col-span-1">
          <div class="flex items-center mb-4 transform hover:scale-105 transition-transform duration-300">
            <img src="/public/images/wmsu-logo.png" alt="WMSU Logo" class="h-12 w-auto mr-3">
            <h3 class="text-2xl font-bold text-white">WMSU TEC</h3>
          </div>
          <p class="text-sm leading-relaxed mb-6 text-gray-300">
           The Testing Evaluation Center (TEC) provides scheduling services for various WMSU application processes.
          </p>
          <!-- Social Media Icons -->
          <div class="flex space-x-5">
            <a href="#" aria-label="Facebook" class="text-gray-300 hover:text-crimson-400 hover:scale-110 transition-all duration-300">
              <i class="fab fa-facebook-f text-xl"></i>
            </a>
            <a href="#" aria-label="Twitter" class="text-gray-300 hover:text-crimson-400 hover:scale-110 transition-all duration-300">
              <i class="fab fa-twitter text-xl"></i>
            </a>
            <a href="#" aria-label="Instagram" class="text-gray-300 hover:text-crimson-400 hover:scale-110 transition-all duration-300">
              <i class="fab fa-instagram text-xl"></i>
            </a>
            <a href="#" aria-label="LinkedIn" class="text-gray-300 hover:text-crimson-400 hover:scale-110 transition-all duration-300">
              <i class="fab fa-linkedin-in text-xl"></i>
            </a>
          </div>
        </div>

        <!-- Quick Links -->
        <div>
          <h4 class="font-bold text-lg mb-5 text-white uppercase tracking-wider border-b-2 border-crimson-500 pb-2 inline-block">Quick Links</h4>
          <ul class="space-y-3 text-sm">
            <li>
              <router-link to="/" class="hover:text-crimson-400 transition-colors duration-300 flex items-center gap-2 group">
                <i class="fas fa-home w-4 text-center opacity-70 group-hover:opacity-100"></i> Home
              </router-link>
            </li>
            <li>
              <router-link to="/schedule" class="hover:text-crimson-400 transition-colors duration-300 flex items-center gap-2 group">
                <i class="fas fa-calendar-alt w-4 text-center opacity-70 group-hover:opacity-100"></i> Schedule
              </router-link>
            </li>
            <li>
              <router-link to="/requirements" class="hover:text-crimson-400 transition-colors duration-300 flex items-center gap-2 group">
                 <i class="fas fa-list-check w-4 text-center opacity-70 group-hover:opacity-100"></i> Requirements
              </router-link>
            </li>
            <li>
              <router-link to="/faq" class="hover:text-crimson-400 transition-colors duration-300 flex items-center gap-2 group">
                <i class="fas fa-question-circle w-4 text-center opacity-70 group-hover:opacity-100"></i> FAQ
              </router-link>
            </li>
          </ul>
        </div>

        <!-- Resources -->
        <div>
          <h4 class="font-bold text-lg mb-5 text-white uppercase tracking-wider border-b-2 border-crimson-500 pb-2 inline-block">Resources</h4>
          <ul class="space-y-3 text-sm">
             <li><a href="#" class="hover:text-crimson-400 transition-colors duration-300">WMSU Main Website</a></li>
             <li><a href="#" class="hover:text-crimson-400 transition-colors duration-300">Admission Portal</a></li>
             <li><a href="#" class="hover:text-crimson-400 transition-colors duration-300">Student Handbook</a></li>
             <li><a href="#" class="hover:text-crimson-400 transition-colors duration-300">Privacy Policy</a></li>
          </ul>
        </div>

        <!-- Contact Info -->
        <div>
          <h4 class="font-bold text-lg mb-5 text-white uppercase tracking-wider border-b-2 border-crimson-500 pb-2 inline-block">Contact Us</h4>
          <ul class="space-y-4 text-sm">
            <li class="flex items-start gap-3 group hover:text-crimson-400 transition-colors duration-300">
              <i class="fas fa-map-marker-alt text-crimson-400 mt-1 w-4 text-center group-hover:scale-110 transition-transform duration-300"></i>
              <span>Normal Rd, Baliwasan, Zamboanga City, 7000 Zamboanga del Sur</span>
            </li>
            <li class="flex items-start gap-3 group hover:text-crimson-400 transition-colors duration-300">
              <i class="fas fa-phone text-crimson-400 mt-1 w-4 text-center group-hover:scale-110 transition-transform duration-300"></i>
              <span>(062) 991 1040</span>
            </li>
            <li class="flex items-start gap-3 group hover:text-crimson-400 transition-colors duration-300">
              <i class="fas fa-envelope text-crimson-400 mt-1 w-4 text-center group-hover:scale-110 transition-transform duration-300"></i>
              <span>tec@wmsu.edu.ph</span>
            </li>
          </ul>
        </div>
      </div>

      <!-- Footer Bottom -->
      <div class="border-t border-crimson-800/30 mt-12 pt-8 text-sm text-gray-400 flex flex-col sm:flex-row justify-between items-center gap-4">
        <p class="hover:text-crimson-400 transition-colors duration-300">&copy; {{ currentYear }} Western Mindanao State University - Testing Evaluation Center. All rights reserved.</p>
        <div class="flex items-center gap-2 group">
          <span class="group-hover:text-crimson-400 transition-colors duration-300">Powered by WMSU</span>
          <img src="/src/assets/images/wmsu-logo.png" alt="WMSU Logo" class="h-6 w-auto opacity-70 group-hover:opacity-100 transition-opacity duration-300">
        </div>
      </div>
    </div>
  </footer>
</template>

<script>
export default {
  name: 'Footer',
  computed: {
    currentYear() {
      return new Date().getFullYear()
    }
  }
}
</script>

<style scoped>
footer {
  box-shadow: 0 -10px 30px rgba(139, 0, 0, 0.2);
}

footer a {
  transition: all 0.3s ease-in-out;
}

footer a:hover {
  transform: translateX(5px);
}
</style> 