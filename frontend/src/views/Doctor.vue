<template>
  <div>
    <h2>Doctor Dashboard</h2>
    <nav>
      <router-link to="/animals">Λίστα Ζώων</router-link> |
      <router-link to="/requests">Αιτήσεις προς Επαλήθευση</router-link>
    </nav>
    <section>
      <h3>Ενέργειες Κτηνίατρου</h3>
      <ul>
        <li>Επαλήθευση υγείας ζώων</li>
        <li>Έγκριση/απόρριψη ζώων για υιοθεσία</li>
      </ul>
    </section>
    <RequestList />
    <router-view/>
  </div>
</template>

<script>
import RequestList from '../components/RequestList.vue';
export default {
  components: { RequestList }
}
</script>
