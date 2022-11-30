import Vue from 'vue'
import VueRouter from 'vue-router'
import HomeView from '../views/HomeView.vue'
import ArtistView from '../views/ArtistView.vue'
import MusicPlayerView from '@/views/MusicPlayerView.vue'
import BuySongView from '../views/BuySongView.vue'
import SuccessfulPurchaseView from '../views/SuccessfulPurchaseView.vue'
import PaymentFailedView from '../views/PaymentFailedView.vue'


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
    path: '/successful',
    name: 'successful',
    component: SuccessfulPurchaseView
  },

  {
    path: '/failed',
    name: 'failed',
    component: PaymentFailedView
  },


]

const router = new VueRouter({
  mode: 'history',
  base: process.env.BASE_URL,
  routes
})

export default router
