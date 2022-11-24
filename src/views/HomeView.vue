<template>
  <div class="home">
    <v-container>
      <h1 align="center">Benvenuto</h1>
    </v-container>
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
    },

    methods:{
      
    }
  }
</script>
