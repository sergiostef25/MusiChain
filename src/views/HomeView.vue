<template>
  <div class="home">
    <v-parallax
    dark
    height="900"
    src="https://wallpapersmug.com/download/1366x768/f5d72b/digital-art-horizon-mountains-forest-pinkish.jpg"
  >
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
  </v-parallax>

    
  </div>
</template>

<script>
//const Web3 = require('web3');
//const MusiChain = require('../../build/contracts/MusiChain.json');

  export default {
    name: 'HomePage',

    data() {
      return {
        contractResult: '',
        owner: '',
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
