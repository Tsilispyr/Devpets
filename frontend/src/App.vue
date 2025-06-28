<template>
  <Navbar />
  <router-view />
</template>

<script>
import Navbar from './components/Navbar.vue'
export default {
  name: 'App',
  components: { Navbar }
}
</script>

<style>
nav {
  margin-bottom: 20px;
}
</style>

