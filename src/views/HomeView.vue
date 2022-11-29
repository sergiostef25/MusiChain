<template>
  <div class="home">
    <v-parallax
    dark
    height="630"
    src="https://cdn.vuetifyjs.com/images/backgrounds/vbanner.jpg"
  >
    <v-row
      align="center"
      justify="center"
    >
      <v-col
        class="text-center"
        cols="12"
      >
        <h1 class="text-h4 font-weight-thin mb-4">
          Welcome to Musichain
        </h1>
        <v-img
          :src="require('../assets/musichain.svg')"
          class="my-3"
          contain
          height="200"
        />
        <h4 class="subheading">
          Menage your songs in Blockchain!
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
