<template>
  <div>
    <h2>Προσθήκη Ζώου</h2>
    <form @submit.prevent="addAnimal">
      <div>
        <label>Όνομα:</label>
        <input v-model="animal.name" required />
      </div>
      <div>
        <label>Είδος:</label>
        <input v-model="animal.type" required />
      </div>
      <div>
        <label>Φύλο:</label>
        <select v-model="animal.gender" required>
          <option value="Male">Αρσενικό</option>
          <option value="Female">Θηλυκό</option>
        </select>
      </div>
      <div>
        <label>Ηλικία:</label>
        <input v-model="animal.age" type="number" min="0" required />
      </div>
      <button type="submit">Προσθήκη</button>
      <button type="button" @click="$router.back()">Ακύρωση</button>
    </form>
  </div>
</template>

<script>
export default {
  data() {
    return {
      animal: { name: '', type: '', gender: 'Male', age: 0 }
    }
  },
  methods: {
    addAnimal() {
      fetch('http://localhost:8080/api/animals', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          Authorization: `Bearer ${localStorage.getItem('jwt_token')}`
        },
        body: JSON.stringify(this.animal)
      })
        .then(r => {
          if (!r.ok) throw new Error('Σφάλμα προσθήκης ζώου')
          this.$router.push('/animals')
        })
        .catch(() => alert('Σφάλμα προσθήκης ζώου'))
    }
  }
}
</script> 