<template>
  <div>
    <h3>{{ user && user.id ? 'Edit User' : 'Create User' }}</h3>
    <form @submit.prevent="save">
      <div>
        <label>Username:</label>
        <input v-model="form.username" required />
      </div>
      <div>
        <label>Email:</label>
        <input v-model="form.email" type="email" required />
      </div>
      <button type="submit">Save</button>
    </form>
  </div>
</template>

<script>
export default {
  props: ['user'],
  data() {
    return {
      form: {
        username: this.user?.username || '',
        email: this.user?.email || ''
      }
    };
  },
  methods: {
    save() {
      // Only update username and email
      const updatedUser = {
        ...this.user,
        username: this.form.username,
        email: this.form.email
      };
      this.$emit('saved', updatedUser);
    }
  }
}
</script> 