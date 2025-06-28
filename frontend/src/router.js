import { createRouter, createWebHistory } from 'vue-router';
import { useAuthStore } from './stores/auth.js';
import Login from './views/Login.vue';
import Home from './views/Home.vue';
import Register from './views/Register.vue';
import VerifyEmail from './views/VerifyEmail.vue';
import Animals from './views/Animals.vue';
import Requests from './views/Requests.vue';
import RequestDetail from './views/RequestDetail.vue';
import AddAnimal from './views/AddAnimal.vue';
import Admin from './views/Admin.vue';
import Doctor from './views/Doctor.vue';
import Shelter from './views/Shelter.vue';
import Citizen from './views/Citizen.vue';
import Users from './views/Users.vue';
import AnimalDetail from './views/AnimalDetail.vue';

const router = createRouter({
    history: createWebHistory(import.meta.env.BASE_URL),
    routes: [
        { path: '/', name: 'home', component: Home },
        { path: '/login', name: 'login', component: Login },
        { path: '/register', name: 'register', component: Register },
        { path: '/verify-email', name: 'verify-email', component: VerifyEmail },
        { path: '/animals', name: 'animals', component: Animals },
        { path: '/animals/add', name: 'add-animal', component: AddAnimal },
        { path: '/animals/:id', name: 'animal-detail', component: AnimalDetail },
        { path: '/requests', name: 'requests', component: Requests },
        { path: '/requests/:id', name: 'request-detail', component: RequestDetail },
        { path: '/admin', name: 'admin', component: Admin },
        { path: '/doctor', name: 'doctor', component: Doctor },
        { path: '/shelter', name: 'shelter', component: Shelter },
        { path: '/citizen', name: 'citizen', component: Citizen },
        { path: '/users', name: 'users', component: Users },
        { path: '/user/:user_id', name: 'user', component: Users },
        { path: '/:pathMatch(.*)*', name: 'not-found', component: Home },
    ]
});

router.beforeEach((to, from, next) => {
    const authStore = useAuthStore();
    const requiresAuth = to.matched.some((record) => record.meta && record.meta.requiresAuth);

    if (requiresAuth && !authStore.isLoggedIn) {
        console.log('user not authenticated. redirecting to /login');
        next('/login');
    } else {
        next();
    }
});

export default router;