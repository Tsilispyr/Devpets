<template>
  <header class="navbar">
    <h1>🐾 Pet Adoption App</h1>
    <nav class="nav-links">
      <template v-if="authStore.isLoggedIn">
        <span class="user-info">
          Είστε συνδεδεμένος ως <b>{{ username }}</b> (<b>{{ mainRole }}</b>)
        </span>
        <router-link to="/">Αρχική</router-link>
        <router-link to="/animals">Ζώα</router-link>
        <router-link to="/requests" v-if="hasRole('ADMIN') || hasRole('USER') || hasRole('DOCTOR') || hasRole('SHELTER')">Αιτήσεις</router-link>
        <router-link to="/users" v-if="hasRole('ADMIN')">Χρήστες</router-link>
        <button @click="logout">Logout</button>
      </template>
      <template v-else>
        <router-link to="/register">Register</router-link>
        <router-link to="/login">Login</router-link>
      </template>
    </nav>
  </header>
</template>

<script>
import { useAuthStore } from '../stores/auth';

function parseJwt(token) {
  if (!token) return {};
  try {
    const base64Url = token.split('.')[1];
    const base64 = base64Url.replace(/-/g, '+').replace(/_/g, '/');
    const jsonPayload = decodeURIComponent(atob(base64).split('').map(function(c) {
      return '%' + ('00' + c.charCodeAt(0).toString(16)).slice(-2);
    }).join(''));
    return JSON.parse(jsonPayload);
  } catch (e) {
    return {};
  }
}

export default {
  setup() {
    const authStore = useAuthStore();
    return { authStore };
  },
  
  data() {
    return {
      payload: {}
    };
  },
  
  computed: {
    roles() {
      return this.payload.roles ? this.payload.roles.map(r => r.name || r) : [];
    },
    username() {
      return this.payload.sub || this.payload.username || this.payload.email || 'Χρήστης';
    },
    mainRole() {
      const priority = ['ADMIN', 'DOCTOR', 'SHELTER', 'USER'];
      for (const p of priority) {
        if (this.roles.map(r => r.toUpperCase()).includes(p)) return p;
      }
      return this.roles[0] || '-';
    }
  },
  
  methods: {
    logout() {
      this.authStore.logout();
      this.payload = {};
      this.$router.push('/login');
    },
    hasRole(role) {
      return this.roles
        .map(r => r.toUpperCase().replace('ROLE_', ''))
        .includes(role.toUpperCase().replace('ROLE_', ''));
    }
  },
  
  watch: {
    'authStore.token': {
      immediate: true,
      handler(newToken) {
        if (newToken) {
          this.payload = parseJwt(newToken);
        } else {
          this.payload = {};
        }
      }
    }
  }
}
</script>

<style scoped>
.navbar {
  background: #333;
  color: white;
  padding: 1rem;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.nav-links {
  display: flex;
  gap: 1rem;
  align-items: center;
}

.nav-links a {
  color: white;
  text-decoration: none;
  padding: 0.5rem 1rem;
  border-radius: 4px;
  transition: background-color 0.3s;
}

.nav-links a:hover {
  background: #555;
}

.user-info {
  margin-right: 1rem;
  font-size: 0.9rem;
}

button {
  background: #dc3545;
  color: white;
  border: none;
  padding: 0.5rem 1rem;
  border-radius: 4px;
  cursor: pointer;
}

button:hover {
  background: #c82333;
}
</style> 