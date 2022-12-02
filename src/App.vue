<template>
  <v-app> 
    <v-app-bar
      dark
      app
    >
      <v-app-bar-nav-icon @click="drawer = !drawer"></v-app-bar-nav-icon>

          <router-link to="/" style="text-decoration: none; color: inherit;">
            <v-toolbar-title>MusiChain</v-toolbar-title>
          </router-link>
          <!-- connect-wallet button is visible if the wallet is not connected -->
          <v-btn text v-if="!connected" @click="connect" fixed right>Connect Wallet</v-btn>
          <v-btn text v-if="connected" disabled fixed right>Wallet Connected</v-btn>


      
    </v-app-bar>

    <v-navigation-drawer
      v-model="drawer"
      app
    >
      <v-list
        nav
        dense
      >
        <v-list-item-group
          v-model="group"
          
        >

          <v-list-item v-for="link in links" :key="link.text" router :to="link.route">
            <v-list-item-icon>
                <v-icon>{{link.icon}}</v-icon>
              </v-list-item-icon>
              <v-list-item-title>{{link.text}}</v-list-item-title>
          </v-list-item>
        </v-list-item-group>
      </v-list>
    </v-navigation-drawer>
    <v-main>

      <v-container fluid>
        <!-- If using vue-router -->
        <router-view :connected="connected" :address="address" :artistName="artistName" @changeArtistName="artistName = $event"></router-view>

      </v-container>

    </v-main>

    <v-footer app>
    <!-- -->
    </v-footer>
  </v-app>
</template>

<script>
const Web3 = require('web3');
const MusiChain = require('../build/contracts/MusiChain.json');

export default {
  name: 'App',
  data() {
      return {
        address: null,
        artistName: 'none',
        connected: false,
        drawer: false,
        group: null,
        links: [
          {icon: 'mdi-home', text: 'Home', route: '/'},
          {icon: 'mdi-account-circle', text: 'Artist', route: '/artist'},
          {icon: 'mdi-cart-arrow-down', text: 'Buy Song', route: '/buy'},
          {icon: 'mdi-play', text: 'Music Player', route: '/player'},
          {icon: 'mdi-playlist-music', text: 'List', route: '/list'},
        ]
      }
    },

  methods:{
      connect(){

        if(window.ethereum){
          window.ethereum.request({method: 'eth_requestAccounts'})
          .then(() => {
            this.connected = true;
            this.address = window.ethereum.selectedAddress;

            const init = async () => {
            const web3 = new Web3(window.ethereum);
            const id = await web3.eth.net.getId();
            const deployedNetwork = MusiChain.networks[id];
            const contractMusiChain = new web3.eth.Contract(MusiChain.abi, deployedNetwork.address);

            const result = await contractMusiChain.methods.artists(this.address).call();
            if(result.length > 0){
              this.artistName = result;
            }
          }

          init();
          
          })
        }
      },


  }
};
</script>
