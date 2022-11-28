<template>
    <div class="failed">
      <v-parallax
      dark
      height="630"
      src="https://wallpaperaccess.com/full/343670.png"
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
            Ops, something went wrong!
          </h1>
          <v-img
            :src="require('../assets/failed.svg')"
            class="my-3"
            contain
            height="200"
          />
          <h5 class="subheading">
            Your amount is insufficient, try again.
          </h5>
        </v-col>
      </v-row>
    </v-parallax>
  
      
    </div>
  </template>
  
  <script>
  //const Web3 = require('web3');
  //const MusiChain = require('../../build/contracts/MusiChain.json');
  
    export default {
      name: 'FailedPage',
  
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