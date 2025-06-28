import { defineStore } from 'pinia';

export const useAuthStore = defineStore('auth', {
  state: () => ({
    token: localStorage.getItem('jwt_token') || null,
    user: JSON.parse(localStorage.getItem('user')) || null,
    isAuthenticated: !!localStorage.getItem('jwt_token')
  }),
  
  actions: {
    setToken(token) {
      this.token = token;
      this.isAuthenticated = true;
      localStorage.setItem('jwt_token', token);
    },
    
    setUser(user) {
      this.user = user;
      localStorage.setItem('user', JSON.stringify(user));
    },
    
    logout() {
      this.token = null;
      this.user = null;
      this.isAuthenticated = false;
      localStorage.removeItem('jwt_token');
      localStorage.removeItem('user');
    },
    
    clearAuth() {
      this.logout();
    }
  },
  
  getters: {
    getUser: (state) => state.user,
    getToken: (state) => state.token,
    isLoggedIn: (state) => state.isAuthenticated
  }
}); 