import { ref, computed } from 'vue';
import { defineStore } from 'pinia';

function checkJWT(token) {
    if (!token) return false;
    const base64Url = token.split('.')[1];
    if (!base64Url) return false;
    const base64 = base64Url.replace(/-/g, '+').replace(/_/g, '/');
    const payload = JSON.parse(atob(base64));
    const currentTime = Math.floor(Date.now() / 1000);
    return currentTime < payload.exp;
}

export const useApplicationStore = defineStore('application', () => {
    const userData = ref(null);

    const setUserData = (tempUserData) => {
        userData.value = tempUserData;
    };

    const persistUserData = () => {
        localStorage.setItem('userData', JSON.stringify(userData.value));
    };

    const loadUserData = () => {
        const stored = localStorage.getItem('userData');
        if (!stored) return;
        userData.value = JSON.parse(stored);
    };

    const clearUserData = () => {
        localStorage.removeItem('userData');
        userData.value = null;
    };

    const isAuthenticated = computed(() => {
        return checkJWT(userData.value?.accessToken);
    });

    const role = computed(() => userData.value?.role || null);

    const hasAccess = (page) => {
        const accessMap = {
            user: ['home', 'animals', 'login', 'register', 'logout'],
            shelter: ['home', 'animals', 'requests', 'login', 'register', 'logout'],
            doctor: ['home', 'animals', 'requests', 'login', 'register', 'logout'],
            admin: ['home', 'animals', 'requests', 'users', 'login', 'register', 'logout'],
        };
        return accessMap[role.value]?.includes(page);
    };

    return {
        userData,
        setUserData,
        persistUserData,
        loadUserData,
        clearUserData,
        isAuthenticated,
        role,
        hasAccess,
    };
});
