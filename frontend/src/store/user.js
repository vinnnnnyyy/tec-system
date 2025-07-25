import { reactive } from 'vue';

export const userStore = reactive({
  user: null,
  setUser(user) {
    this.user = user;
  },
  clearUser() {
    this.user = null;
  }
}); 