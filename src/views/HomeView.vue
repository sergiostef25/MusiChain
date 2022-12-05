<template>
  <div class="home">
    <v-row
      align="center"
      justify="center"
    >
      <v-col
        class="text-center"
        cols="10"
      >
        <h1 class="text-h4 font-weight-thin mb-4">
          
        </h1>
        <v-img
          :src="require('../assets/musichain2.svg')"
          class="my-3"
          contain
          height="130"
        />
        <h4 class="subheading">
          MusiChain
        </h4>
        <br>
        <br>
        <br>
        

      </v-col>

      
    </v-row>

    <br>
    <br>
    <br>
    
    

  <template>
    <v-card
    elevation="24"
    max-width="900"
    class="mx-auto"
    >
    <v-carousel
      cycle
      height="600"
      show-arrows-on-hover
    >
      <v-carousel-item
        v-for="(item,i) in items"
        :key="i"
        :src="item.src"        
      >
        <v-row
          class="fill-height"
          align="center"
          justify="center"
        >
          <div class="text-h2">
            <h5> {{ slides[i] }} </h5>  
          </div>
        </v-row>
      </v-carousel-item>
    </v-carousel>
    </v-card>
  </template>

    <br>
    <br>
    <br>
    <br>
    <br>
    <br>

  <template>
    <v-footer
    dark
    padless
    >
      <v-card
      flat
      tile
      class="blue-grey darken-4 white--text text-center"
      >
      <v-card-text>
        <v-btn
          v-for="icon in icons"
          :key="icon"
          class="mx-4 white--text"
          icon
        >
          <v-icon size="24px">
            {{ icon }}
          </v-icon>
        </v-btn>
      </v-card-text>

      <v-card-text class="white--text pt-0">
        Sync, update to new versions of Musichain, purchases on the Store: if you need assistance, just ask. Our team will make every transaction secure and immediate to ensure a management of your data as safe as possible. For other references, consult our social.
      </v-card-text>

      <v-divider></v-divider>

      <v-card-text class="white--text">
        {{ new Date().getFullYear() }} — <strong>Musichain</strong>
      </v-card-text>
      </v-card>
    </v-footer>
  </template>

    
  </div>
</template>


<style>
#app {
  background: url('https://wallpapers.com/images/hd/purple-ombre-polygon-abstract-4bu0liuxf9z3s7q2.jpg')
    no-repeat center center fixed !important;
  background-size: cover;
}
</style>

<script>
//const Web3 = require('web3');
//const MusiChain = require('../../build/contracts/MusiChain.json');

  export default {
    name: 'HomePage',

    data() {
      return {
        contractResult: '',
        owner: '',
        items: [
          {
            src: 'https://res.allmacwallpaper.com/get/Retina-MacBook-Air-13-inch-wallpapers/flint-blur-5k-2560x1600/21531-11.jpg',
          },
          {
            src: 'https://consequence.net/wp-content/uploads/2022/01/CoS-HERO_Upcoming_1200x675.jpg?quality=80&w=1031&h=580&crop=1&resize=1031%2C580&strip',
          },
          {
            src: 'https://i.pinimg.com/originals/22/17/7c/22177c78433b7146788d7a4c6122f6c5.jpg',
          },
          {
            src: 'https://corporate.payu.com/wp-content/uploads/2022/04/Safety-security-banner-header-1440x465.webp',
          },
        ],
        
        slides: [
          'Discover our features',
          'Rent songs of your favorite artists',
          'Upload your songs on the Blockchain',
          'Safe and immediate transactions',
        ],

        icons: [
        'mdi-facebook',
        'mdi-twitter',
        'mdi-linkedin',
        'mdi-instagram',
      ],
      }
    },

    props: {
      connected: Boolean,
      address: String,
    },

    methods:{
      
    }
  }
</script>
