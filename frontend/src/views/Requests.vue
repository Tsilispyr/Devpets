<template>
  <div>
    <h2>Αιτήσεις Υιοθεσίας</h2>
    <button v-if="hasRole('ROLE_ADMIN') || hasRole('ROLE_SHELTER')" @click="showForm = true">Νέα Αίτηση</button>
    <form v-if="showForm" @submit.prevent="createRequest">
      <input v-model="newRequest.name" placeholder="Όνομα" required />
      <input v-model="newRequest.type" placeholder="Είδος" required />
      <select v-model="newRequest.gender" required>
        <option value="Male">Αρσενικό</option>
        <option value="Female">Θηλυκό</option>
      </select>
      <input v-model="newRequest.age" type="number" min="0" placeholder="Ηλικία" required />
      <button type="submit">Υποβολή</button>
      <button type="button" @click="showForm = false">Άκυρο</button>
    </form>
    <table v-if="requests.length > 0" class="table">
      <thead>
        <tr>
          <th>Όνομα</th>
          <th>Είδος</th>
          <th>Φύλο</th>
          <th>Ηλικία</th>
          <th>Ενέργειες</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="r in requests" :key="r.id">
          <td>{{ r.name }}</td>
          <td>{{ r.type }}</td>
          <td>{{ r.gender }}</td>
          <td>{{ r.age }}</td>
          <td>
            <router-link :to="`/requests/${r.id}`" class="btn">Λεπτομέρειες</router-link>
            <button v-if="hasRole('ROLE_ADMIN')" @click="adminApprove(r.id)">Admin Approve</button>
            <button v-if="hasRole('ROLE_DOCTOR') || hasRole('ROLE_ADMIN')" @click="doctorApprove(r.id)">Doctor Approve</button>
            <button @click="deleteRequest(r.id)">Διαγραφή</button>
          </td>
        </tr>
      </tbody>
    </table>
    <div v-else>Καμία αίτηση βρέθηκε.</div>
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
    return {
      showForm: false,
      newRequest: { name: '', type: '', gender: 'Male', age: 0 },
      requests: []
    }
  },
  mounted() {
    fetch('http://localhost:8080/api/requests', {
      headers: { Authorization: `Bearer ${localStorage.getItem('jwt_token')}` }
    })
      .then(r => r.json())
      .then(data => (this.requests = data))
      .catch(() => alert('Σφάλμα ανάκτησης αιτήσεων'))
  },
  methods: {
    async createRequest() {
      await fetch('http://localhost:8080/api/requests', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          Authorization: `Bearer ${localStorage.getItem('jwt_token')}`
        },
        body: JSON.stringify(this.newRequest)
      });
      this.showForm = false;
      this.newRequest = { name: '', type: '', gender: 'Male', age: 0 };
      this.reload();
    },
    adminApprove(id) {
      fetch(`http://localhost:8080/api/requests/Approve/${id}`, {
        method: 'POST',
        headers: { Authorization: `Bearer ${localStorage.getItem('jwt_token')}` }
      })
        .then(() => this.reload())
        .catch(() => alert('Σφάλμα admin έγκρισης'))
    },
    doctorApprove(id) {
      fetch(`http://localhost:8080/api/requests/ApproveD/${id}`, {
        method: 'POST',
        headers: { Authorization: `Bearer ${localStorage.getItem('jwt_token')}` }
      })
        .then(() => this.reload())
        .catch(() => alert('Σφάλμα doctor έγκρισης'))
    },
    deleteRequest(id) {
      fetch(`http://localhost:8080/api/requests/${id}`, {
        method: 'DELETE',
        headers: { Authorization: `Bearer ${localStorage.getItem('jwt_token')}` }
      })
        .then(response => {
          if (!response.ok) {
            throw new Error('Delete failed');
          }
          this.reload();
        })
        .catch(() => {
          alert('Σφάλμα διαγραφής');
        });
    },
    reload() {
      fetch('http://localhost:8080/api/requests', {
        headers: { Authorization: `Bearer ${localStorage.getItem('jwt_token')}` }
      })
        .then(r => {
          if (!r.ok) throw new Error('Failed to fetch requests');
          return r.json();
        })
        .then(data => {
          this.requests = data;
        })
        .catch(() => {
          this.requests = [];
        });
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
