<template>
    <div class="successfull">
      <v-parallax
      dark
      height="630"
      src="https://c4.wallpaperflare.com/wallpaper/1019/330/572/abstract-green-shapes-wallpaper-preview.jpg"
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
            Payment Successfull!
          </h1>
          <v-img
            :src="require('../assets/paymentsuccessful21.svg')"
            class="my-3"
            contain
            height="200"
          />
          <h5 class="subheading">
            Thank you for your payment.
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