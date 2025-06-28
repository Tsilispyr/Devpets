<template>
  <div>
    <h2>Pending Requests</h2>
    <ul>
      <li v-for="req in requests" :key="req.id">
        {{ req.animalName }} - {{ req.status }}
        <button v-if="canApprove" @click="approve(req.id)">Approve</button>
      </li>
    </ul>
  </div>
</template>
<script>
import api from '../api';
export default {
  data() { return { requests: [] }; },
  computed: {
    canApprove() {
      // Parse JWT from localStorage
      const token = localStorage.getItem('jwt_token');
      if (!token) return false;
      try {
        const payload = JSON.parse(atob(token.split('.')[1]));
        const roles = (payload.roles || []).map(r => r.toUpperCase().replace('ROLE_', ''));
        return roles.includes('ADMIN') || roles.includes('DOCTOR') || roles.includes('SHELTER');
      } catch {
        return false;
      }
    }
  },
  async mounted() {
    const res = await api.get('/requests/pending');
    this.requests = res.data;
  },
  methods: {
    async approve(id) {
      await api.post(`/requests/${id}/approve`);
      this.requests = this.requests.filter(r => r.id !== id);
    }
  }
}
</script> 