<template>
  <div>
    <h2>Adoption Requests</h2>
    <ul>
      <li v-for="req in adoptionRequests" :key="req.id">
        {{ req.animalName }} - {{ req.status }}
        <button v-if="canApprove" @click="approve(req.id)">Approve</button>
      </li>
    </ul>
  </div>
</template>
<script>
import api from '../api';
export default {
  data() { return { adoptionRequests: [] }; },
  computed: {
    canApprove() {
      // Parse JWT from localStorage
      const token = localStorage.getItem('jwt_token');
      if (!token) return false;
      try {
        const payload = JSON.parse(atob(token.split('.')[1]));
        const roles = (payload.roles || []).map(r => r.toUpperCase().replace('ROLE_', ''));
        return roles.includes('ADMIN') || roles.includes('SHELTER');
      } catch {
        return false;
      }
    }
  },
  async mounted() {
    const res = await api.get('/adoptions/pending');
    this.adoptionRequests = res.data;
  },
  methods: {
    async approve(id) {
      await api.post(`/adoptions/${id}/approve`);
      this.adoptionRequests = this.adoptionRequests.filter(r => r.id !== id);
    }
  }
}
</script> 