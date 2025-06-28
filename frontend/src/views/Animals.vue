<template>
  <div>
    <h2>Διαθέσιμα Ζώα</h2>
    <router-link v-if="hasRole('ROLE_ADMIN') || hasRole('ROLE_SHELTER')" to="/animals/add" class="btn">Προσθήκη Ζώου</router-link>
    <div v-if="animals.length === 0">Κανένα ζώο διαθέσιμο.</div>
    <ul v-else>
      <li v-for="a in animals" :key="a.id" class="animal-card">
        <h3>{{ a.name }}</h3>
        <p>Είδος: {{ a.type }}</p>
        <p>Φύλο: {{ a.gender }}</p>
        <p>Ηλικία: {{ a.age }}</p>
        <router-link :to="`/animals/${a.id}`" class="btn">Λεπτομέρειες</router-link>
        <button @click="requestAnimal(a.id)" v-if="a.req === 0">Αίτηση Υιοθεσίας</button>
        <template v-if="a.req === 1 && (hasRole('ROLE_ADMIN') || hasRole('ROLE_SHELTER'))">
          <button @click="approveAnimal(a.id)">Έγκριση</button>
          <button @click="denyAnimal(a.id)">Απόρριψη</button>
        </template>
        <button @click="deleteAnimal(a.id)" v-if="hasRole('ROLE_ADMIN')">Διαγραφή</button>
      </li>
    </ul>
  </div>
</template>

<script>
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
  data() {
    return { animals: [] }
  },
  mounted() {
    fetch('http://localhost:8080/api/animals', {
      headers: { Authorization: `Bearer ${localStorage.getItem('jwt_token')}` }
    })
      .then(r => r.json())
      .then(data => (this.animals = data))
      .catch(() => alert('Σφάλμα ανάκτησης ζώων'))
  },
  methods: {
    async requestAnimal(id) {
      await fetch(`http://localhost:8080/api/animals/Request/${id}`, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
          Authorization: `Bearer ${localStorage.getItem('jwt_token')}`
        }
      });
      alert('Αίτηση υποβλήθηκε');
      this.reload();
    },
    async approveAnimal(id) {
      await fetch(`http://localhost:8080/api/animals/${id}/accept-adoption`, {
        method: 'POST',
        headers: { Authorization: `Bearer ${localStorage.getItem('jwt_token')}` }
      });
      this.reload();
    },
    async denyAnimal(id) {
      await fetch(`http://localhost:8080/api/animals/Deny/${id}`, {
        method: 'PUT',
        headers: { Authorization: `Bearer ${localStorage.getItem('jwt_token')}` }
      });
      this.reload();
    },
    async deleteAnimal(id) {
      await fetch(`http://localhost:8080/api/animals/${id}`, {
        method: 'DELETE',
        headers: { Authorization: `Bearer ${localStorage.getItem('jwt_token')}` }
      });
      this.reload();
    },
    reload() {
      fetch('http://localhost:8080/api/animals', {
        headers: { Authorization: `Bearer ${localStorage.getItem('jwt_token')}` }
      })
        .then(r => r.json())
        .then(data => (this.animals = data))
        .catch(() => (this.animals = []));
    },
    hasRole(role) {
      const token = localStorage.getItem('jwt_token');
      const payload = parseJwt(token);
      const roles = payload.roles ? payload.roles.map(r => r.name ? r.name.toLowerCase() : r.toLowerCase()) : [];
      return roles.includes(role.toLowerCase());
    }
  }
}
</script>

<style scoped>
.animal-card {
  border: 1px solid #ccc;
  padding: 10px;
  margin-bottom: 15px;
  border-radius: 8px;
}
</style>
