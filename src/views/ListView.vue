<template>
    <v-container>
      <v-row justify="center">
        <v-col justify="center" md="7"
          v-for="(song, i) in songList"
          :key="i"
          cols="12"
        >
          <v-card
            
            dark
            
          >
            <div class="d-flex flex-no-wrap justify-space-between">
              <div>
                <v-card-title
                  class="text-h5"
                  v-text="song.songName"
                ></v-card-title>

                <v-card-subtitle>{{song.artistName}}
                <div>
                  Purchased: {{new Date(song.timeOfPurchase * 1000).toDateString()}}
                </div>
                <div>
                  Expire: {{new Date(song.expirationTime * 1000).toDateString()}}
                </div>
                </v-card-subtitle>
        
              </div>
              <v-avatar
                class="ma-3"
                size="125"
                tile
              >
                <v-img :src="song.link_cover"></v-img>
              </v-avatar>
              
            </div>
          </v-card>
        </v-col>
      </v-row>
    </v-container>

</template>
  
<script>

const Web3 = require('web3');
const MusiChain = require('../../build/contracts/MusiChain.json');

  
  export default {
    data() {
        return {
            isLoading: false,
            songList: [],
        }
      },
  
    
    props: {
      connected: Boolean,
      address: String,
    },
    watch:{
      connected(){
        this.displaySongs();
      }
    },
    mounted(){
      if(this.connected){
        this.displaySongs();
      }
    },

    methods:{
        displaySongs(){
          const init = async () => {
            const web3 = new Web3(window.ethereum);
            const id = await web3.eth.net.getId();
            const deployedNetwork = MusiChain.networks[id];
            const contractMusiChain = new web3.eth.Contract(MusiChain.abi, deployedNetwork.address);

            //const idArt = await contractMusiChain.methods.artistsCheck(this.artistName).call();
            const result = await contractMusiChain.getPastEvents('rented', {filter: {user: this.address},fromBlock: 0});
            this.songList = [];
            
            for (let [, value] of Object.entries(result)) {
                /* let randcolor = '#'+(Math.random()*0xFFFFFF<<0).toString(16); */
                
                if(value.returnValues[4]*1000 > Date.now()){
                  this.songList.push({artistName: value.returnValues[1], songName: value.returnValues[2],timeOfPurchase: value.returnValues[3],expirationTime: value.returnValues[4], link_cover: value.returnValues[5]}); 
                }

                }
            
          }

          init();
        }
    }
  };
  </script>
  