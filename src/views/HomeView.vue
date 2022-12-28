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
        
        <v-img
          :src="require('../assets/musichain2.svg')"
          class="my-3"
          contain
          height="130"
        />
        
      </v-col>

      
    </v-row>
    <v-row align="center" justify="center" class="ma-10">
      <h2 class="headline">Our artists</h2>
    </v-row>

  
    <v-sheet
      class="mx-auto mb-10"
      elevation="0"
      max-width="70%"
      color="transparent"
    >
      <v-slide-group
        v-model="model"
        class="pa-4"
        show-arrows
      >
        <v-slide-item
          v-for="(artist,i) in artistList"
          :key="i"
          v-slot="{ active }"
        >
        
          <v-card
            :color="active ? 'primary' : 'grey lighten-1'"
            class="ma-4 rounded-circle"
            
            height="150"
            width="150"
            :img="artist.link_avatar"
          >
          
            <v-row
              class="fill-height"
              align="center"
              justify="center"
            >
            
          </v-row>
        
          <v-card-subtitle class="overline" justify="center" align="center">{{ artist.name }}</v-card-subtitle>

          
          
          </v-card>
          
        </v-slide-item>
      </v-slide-group>
    </v-sheet>

    

    
    

  
    <v-card
    elevation="24"
    max-width="900"
    class="mx-auto"
    >
    <v-carousel
      cycle
      height="550"
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
          <div class="headline">
            <h3> {{ slides[i] }} </h3>  
          </div>
        </v-row>
      </v-carousel-item>
    </v-carousel>
    </v-card>



    <v-footer
    class="mt-10"
    dark
    padless
    >
      <v-card
      flat
      tile
      class="blue-grey darken-4 white--text text-center"
      >
      <v-card-text>
        
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
        model: null,
        contractResult: '',
        owner: '',
        items: [
          {
            src: 'https://c4.wallpaperflare.com/wallpaper/654/555/787/geometry-cyberspace-digital-art-lines-wallpaper-preview.jpg',
          },
          {
            src: 'https://images.unsplash.com/photo-1470229722913-7c0e2dbbafd3?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80',
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
          'Music on the Blockchain',
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
      artistList: Array
    },
    watch:{
      artistList(){
        console.log("cambiate");
      }
    }
  }
</script>
