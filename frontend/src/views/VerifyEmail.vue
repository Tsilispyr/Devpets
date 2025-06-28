<template>
  <div class="verify-email">
    <div v-if="loading" class="loading">
      <h2>Επαλήθευση Email...</h2>
      <p>Παρακαλώ περιμένετε...</p>
    </div>
    
    <div v-else-if="success" class="success">
      <h2>✅ Επιτυχής Επαλήθευση!</h2>
      <p>{{ message }}</p>
      <router-link to="/login" class="btn-login">Μετάβαση στη Σύνδεση</router-link>
    </div>
    
    <div v-else-if="error" class="error">
      <h2>❌ Σφάλμα Επαλήθευσης</h2>
      <p>{{ error }}</p>
      <router-link to="/register" class="btn-register">Εγγραφή Ξανά</router-link>
    </div>
  </div>
</template>

<script>
import api from '../api';

export default {
  data() {
    return {
      loading: true,
      success: false,
      error: '',
      message: ''
    };
  },
  
  async mounted() {
    const token = this.$route.query.token;
    
    if (!token) {
      this.error = 'Δεν βρέθηκε token επαλήθευσης';
      this.loading = false;
      return;
    }
    
    try {
      const response = await api.get(`/auth/verify-email?token=${token}`);
      this.message = response.data.message;
      this.success = true;
    } catch (e) {
      console.error('Verification error:', e);
      this.error = e.response?.data?.error || 'Η επαλήθευση απέτυχε';
    } finally {
      this.loading = false;
    }
  }
};
</script>

<style scoped>
.verify-email {
  max-width: 500px;
  margin: 4rem auto;
  padding: 2rem;
  text-align: center;
  border-radius: 8px;
  background: #fafafa;
  box-shadow: 0 2px 10px rgba(0,0,0,0.1);
}

.loading {
  color: #666;
}

.success {
  color: #0a0;
}

.error {
  color: #b00;
}

h2 {
  margin-bottom: 1rem;
  font-size: 1.5rem;
}

p {
  margin-bottom: 2rem;
  font-size: 1.1rem;
}

.btn-login, .btn-register {
  display: inline-block;
  padding: 0.75rem 1.5rem;
  background: #007bff;
  color: white;
  text-decoration: none;
  border-radius: 4px;
  transition: background-color 0.3s;
}

.btn-login:hover, .btn-register:hover {
  background: #0056b3;
}

.btn-register {
  background: #28a745;
}

.btn-register:hover {
  background: #1e7e34;
}
</style> 