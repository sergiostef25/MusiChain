import Vue from 'vue'
import VueRouter from 'vue-router'
import HomeView from '../views/HomeView.vue'
import AccountView from '../views/AccountView.vue'
import SongView from '../views/SongView.vue'
import MusicPlayerView from '@/views/MusicPlayerView.vue'

Vue.use(VueRouter)

const routes = [
  {
    path: '/',
    name: 'home',
    component: HomeView
  },
  {
    path: '/account',
    name: 'account',
    component: AccountView
  },
  {
    path: '/song',
    name: 'song',
    component: SongView
  },

  {
    path: '/player',
    name: 'player',
    component: MusicPlayerView
  },
]

const router = new VueRouter({
  mode: 'history',
  base: process.env.BASE_URL,
  routes
})

export default router
