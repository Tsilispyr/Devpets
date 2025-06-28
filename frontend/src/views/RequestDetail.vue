<template>
  <div v-if="request">
    <h2>Λεπτομέρειες Αίτησης</h2>
    <p><strong>Όνομα:</strong> {{ request.name }}</p>
    <p><strong>Είδος:</strong> {{ request.type }}</p>
    <p><strong>Φύλο:</strong> {{ request.gender }}</p>
    <p><strong>Ηλικία:</strong> {{ request.age }}</p>
    <router-link to="/requests">Επιστροφή στη λίστα</router-link>
  </div>
  <div v-else>
    <p>Φόρτωση στοιχείων αίτησης...</p>
  </div>
</template>
<script>
import api from '../api';
export default {
  data() {
    return {
      request: null
    };
  },
  async mounted() {
    const id = this.$route.params.id;
    try {
      const res = await api.get(`/requests/${id}`);
      this.request = res.data;
    } catch (e) {
      this.request = null;
    }
  }
};
</script> 