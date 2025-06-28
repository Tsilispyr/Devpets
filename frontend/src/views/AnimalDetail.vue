<template>
  <div v-if="animal">
    <h2>Λεπτομέρειες Ζώου</h2>
    <p><strong>Όνομα:</strong> {{ animal.name }}</p>
    <p><strong>Είδος:</strong> {{ animal.type }}</p>
    <p><strong>Φύλο:</strong> {{ animal.gender }}</p>
    <p><strong>Ηλικία:</strong> {{ animal.age }}</p>
    <router-link to="/animals">Επιστροφή στη λίστα</router-link>
  </div>
  <div v-else>
    <p>Φόρτωση στοιχείων ζώου...</p>
  </div>
</template>
<script>
import api from '../api';
export default {
  data() {
    return {
      animal: null
    };
  },
  async mounted() {
    const id = this.$route.params.id;
    try {
      const res = await api.get(`/animals/${id}`);
      this.animal = res.data;
    } catch (e) {
      this.animal = null;
    }
  }
};
</script> 