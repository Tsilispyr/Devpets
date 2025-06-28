<template>
  <div>
    <h2>Users</h2>
    <ul>
      <li v-for="user in users" :key="user.id">
        {{ user.username }} - {{ user.email }} - {{ user.roles.map(r => r.name || r).join(', ') }}
        <select v-model="selectedRole[user.id]">
          <option disabled value="">Add role...</option>
          <option v-for="role in roles" :key="role.id" :value="role.id">{{ role.name }}</option>
        </select>
        <button @click="addRole(user.id)">Add Role</button>
        <button @click="removeRole(user.id)">Remove Role</button>
        <button @click="editUser(user)">Edit</button>
      </li>
    </ul>
    <UserForm v-if="selectedUser" :user="selectedUser" @saved="updateUser" />
  </div>
</template>
<script>
import api from '../api';
import UserForm from './UserForm.vue';
export default {
  components: { UserForm },
  data() {
    return {
      users: [],
      selectedUser: null,
      roles: [
        { id: 1, name: 'ROLE_ADMIN' },
        { id: 2, name: 'ROLE_USER' },
        { id: 3, name: 'ROLE_DOCTOR' },
        { id: 4, name: 'ROLE_SHELTER' }
      ],
      selectedRole: {}
    };
  },
  async mounted() { this.fetchUsers(); },
  methods: {
    async fetchUsers() {
      const res = await api.get('/users');
      this.users = res.data;
    },
    editUser(user) { this.selectedUser = user; },
    async addRole(userId) {
      const roleId = this.selectedRole[userId];
      if (!roleId) return;
      await api.post(`/user/role/add/${userId}/${roleId}`);
      await this.fetchUsers();
    },
    async removeRole(userId) {
      const roleId = this.selectedRole[userId];
      if (!roleId) return;
      // Check if user has the role
      const user = this.users.find(u => u.id === userId);
      if (!user || !user.roles.some(r => (r.id || r) == roleId)) return;
      await api.post(`/user/role/delete/${userId}/${roleId}`);
      await this.fetchUsers();
    },
    async updateUser(user) {
      await api.post(`/user/${user.id}`, user);
      this.selectedUser = null;
      await this.fetchUsers();
    }
  }
}
</script> 