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
          height="170"
        />
        <h4 class="subheading">
          Welcome to Musichain!
        </h4>
      </v-col>

      
    </v-row>

    <br>
    <br>
    <br>

    <v-carousel
    cycle
    height="500"
    hide-delimiter-background
    show-arrows-on-hover
  >
    <v-carousel-item
      v-for="(slide, i) in slides"
      :key="i"
    >
      <v-sheet
        :color="colors[i]"
        height="100%"
      >
        <v-row
          class="fill-height"
          align="center"
          justify="center"
        >
          <div class="text-h2">
            {{ slide }} 
          </div>
        </v-row>
      </v-sheet>
    </v-carousel-item>
  </v-carousel>
    
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
        colors: [
          'indigo',
          'warning',
          'pink darken-2',
          'red lighten-1',
          'deep-purple accent-4',
        ],
        slides: [
          'Scopri le nostre funzioni',
          'Puoi acquistare canzoni',
          'Caricarle in Blockchain',
          'Transizione immediata e sicura',
          'Queste scritte sono indicative, tranquillo amo',
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
