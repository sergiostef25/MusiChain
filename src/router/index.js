import Vue from 'vue'
import VueRouter from 'vue-router'
import HomeView from '../views/HomeView.vue'
import ArtistView from '../views/ArtistView.vue'
import MusicPlayerView from '@/views/MusicPlayerView.vue'
import BuySongView from '../views/BuySongView.vue'
import ListView from '../views/ListView.vue'
import ListArtistView from '../views/ListArtistView.vue'



Vue.use(VueRouter)

const routes = [
  {
    path: '/',
    name: 'home',
    component: HomeView
  },
  {
    path: '/artist',
    name: 'artist',
    component: ArtistView
  },

  {
    path: '/player',
    name: 'player',
    component: MusicPlayerView
  },

  {
    path: '/buy',
    name: 'buy',
    component: BuySongView
  },

  {
    path: '/list',
    name: 'list',
    component: ListView
  },

  {
    path: '/listArtist',
    name: 'listArtist',
    component: ListArtistView
  },


]

const router = new VueRouter({
  mode: 'history',
  base: process.env.BASE_URL,
  routes
})

export default router
