<template>
  <div class="min-h-screen flex flex-col">
    <Navbar v-if="!hideNavbar" />
    <main :class="{ 'flex-grow': !hideNavbar }">
      <router-view />
    </main>
    <Footer v-if="!hideNavbar" />
    <Toast />
  </div>
</template>

<script>
import Navbar from './components/layout/Navbar.vue'
import Footer from './components/Footer.vue'
import Toast from './components/Toast.vue'

export default {
  name: 'App',
  components: {
    Navbar,
    Footer,
    Toast
  },
  computed: {
    hideNavbar() {
      return this.$route.path.startsWith('/admin') || 
             this.$route.path === '/login' ||
             this.$route.path === '/signup'
    }
  }
}
</script>

<style>
@import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap');

body {
  font-family: 'Inter', sans-serif;
}
</style> 