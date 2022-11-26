<template>
  <v-app> 
    <v-app-bar
      dark
      app
    >
      <v-app-bar-nav-icon @click="drawer = !drawer"></v-app-bar-nav-icon>

      <v-toolbar-title class="display-1">Sections</v-toolbar-title>
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
        <router-view :connected="connected"></router-view>

      </v-container>

    </v-main>

    <v-footer app>
    <!-- -->
    </v-footer>
  </v-app>
</template>

<script>

export default {
  name: 'App',
  data() {
      return {
        connected: false,
        drawer: false,
        group: null,
        links: [
          {icon: 'mdi-home', text: 'Home', route: '/'},
          {icon: 'mdi-account', text: 'Account', route: '/account'},
          {icon: 'mdi-account', text: 'Songs', route: '/song'},
          {icon: 'mdi-play', text: 'Music Player', route: '/player'},
        ]
      }
    },

  methods:{
      connect: function(){

        if(window.ethereum){
          window.ethereum.request({method: 'eth_requestAccounts'})
          .then(() => {
            this.connected = true;
          })
        }
      },
  }
};
</script>
