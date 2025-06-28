<template>
  <div>
    <h2>Admin Dashboard</h2>
    <RequestList />
    <UserList />
    <AnimalList />
  </div>
</template>
<script>
import RequestList from '../components/RequestList.vue';
import UserList from '../components/UserList.vue';
import AnimalList from '../components/AnimalList.vue';
export default {
  components: { RequestList, UserList, AnimalList }
}
</script>
