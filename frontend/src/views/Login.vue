<template>
  <div class="login">
    <h2>Login</h2>
    <form @submit.prevent="login">
      <input v-model="username" placeholder="Username" required />
      <input v-model="password" type="password" placeholder="Password" required />
      <button type="submit" :disabled="loading">
        {{ loading ? 'Σύνδεση...' : 'Login' }}
      </button>
    </form>
    <div v-if="error" class="error">{{ error }}</div>
    <div v-if="success" class="success">{{ success }}</div>
    <div class="links">
      <router-link to="/register">Δεν έχετε λογαριασμό; Εγγραφείτε</router-link>
    </div>
  </div>
</template>

<script>
import api from '../api';
import { useAuthStore } from '../stores/auth';

export default {
  data() {
    return {
      username: '',
      password: '',
      error: '',
      success: '',
      loading: false
    };
  },
  methods: {
    async login() {
      this.error = '';
      this.success = '';
      this.loading = true;
      
      try {
        const res = await api.post('/auth/login', {
          username: this.username,
          password: this.password
        });
        
        const token = res.data.token;
        const authStore = useAuthStore();
        authStore.setToken(token);
        authStore.setUser(res.data.user);
        
        this.success = 'Επιτυχής σύνδεση!';
        setTimeout(() => {
          this.$router.push('/');
        }, 1000);
        
      } catch (e) {
        console.error('Login error:', e);
        this.error = e.response?.data?.error || 'Λάθος username ή password';
      } finally {
        this.loading = false;
      }
    }
  }
};
</script>

<style scoped>
.login {
  max-width: 400px;
  margin: 2rem auto;
  padding: 2rem;
  border: 1px solid #ccc;
  border-radius: 8px;
  background: #fafafa;
}

.error {
  color: #b00;
  margin-top: 1rem;
  padding: 0.5rem;
  background: #ffe6e6;
  border-radius: 4px;
}

.success {
  color: #0a0;
  margin-top: 1rem;
  padding: 0.5rem;
  background: #e6ffe6;
  border-radius: 4px;
}

input {
  width: 100%;
  padding: 0.5rem;
  margin: 0.5rem 0;
  border: 1px solid #ccc;
  border-radius: 4px;
}

button {
  width: 100%;
  padding: 0.75rem;
  background: #007bff;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  margin-top: 1rem;
}

button:hover:not(:disabled) {
  background: #0056b3;
}

button:disabled {
  background: #ccc;
  cursor: not-allowed;
}

.links {
  margin-top: 1rem;
  text-align: center;
}

.links a {
  color: #007bff;
  text-decoration: none;
}

.links a:hover {
  text-decoration: underline;
}
</style> 