<template>
    <v-container>
        <h1 align="center">Search for an artist's song catalog</h1>

        <v-autocomplete
            v-model="artistId"
            :items="artistList"
            item-text="artistName"
            item-value="idArtist"
            :isLoading="isLoading"
            :rules="nameRules"
            dense
            label="Name"
            solo
            chips
            clearable
            :loading="isLoading"
            :search-input.sync="search"
        >
        <template v-slot:selection="{ attr, on, item, selected }">
              <v-chip
                v-bind="attr"
                :input-value="selected"
                color="blue-grey"
                class="white--text"
                v-on="on"
              >
                <v-icon left>
                  mdi-music
                </v-icon>
                <span v-text="(item.artistName)"></span>
              </v-chip>
            </template>
            <template v-slot:item="{ item }">
              <v-list-item-avatar
                color="indigo"
                class="text-h5 font-weight-light white--text"
              >
                <v-img :src="item.link_cover"></v-img>
              </v-list-item-avatar>
              <v-list-item-content>
                <v-list-item-title v-text="item.artistName"></v-list-item-title>
              </v-list-item-content>
              <v-list-item-action>
                <v-icon>mdi-music</v-icon>
              </v-list-item-action>
            </template>
        </v-autocomplete>
        <v-col
          v-for="(song, i) in songList"
          :key="i"
          cols="12"
        >
          <v-card
            :color="song.color"
            dark
          >
            <div class="d-flex flex-no-wrap justify-space-between">
              <div>
                <v-card-title
                  class="text-h5"
                  v-text="song.title"
                ></v-card-title>

                <v-card-subtitle v-text="song.artist"></v-card-subtitle>

                <v-card-actions>
                  <v-btn
                    class="ml-2 mt-3"
                    fab
                    icon
                    height="40px"
                    right
                    width="40px"
                  >
                    <v-icon>mdi-play</v-icon>
                  </v-btn>
                </v-card-actions>
              </div>
              
              <v-avatar
                class="ma-3"
                size="125"
                tile
              >
                <v-img :src="song.cover"></v-img>
              </v-avatar>
              
            </div>
          </v-card>
        </v-col>

        
        



    </v-container>

</template>
  
<script>
const Web3 = require('web3');
const MusiChain = require('../../build/contracts/MusiChain.json');

  
  export default {
    data() {
        return {
            search: null,
            isLoading: false,
            valid: false,
            group: null,
            artistList: [],
            songList: [],
            artistId: null,
            nameRules: [
            v => !!v || 'Name is required'],

            
        }
      },
    
    watch:{
      artistId(){

        this.displaySongs();
      },

      search(){
        if (this.artistList.length > 0) return

        this.isLoading = true;

        const init = async () => {
            const web3 = new Web3('http://localhost:7545');
            const id = await web3.eth.net.getId();
            const deployedNetwork = MusiChain.networks[id];
            const contractMusiChain = new web3.eth.Contract(MusiChain.abi, deployedNetwork.address);
            
            const result = await contractMusiChain.getPastEvents('artistAdded', {fromBlock: 0});
            
            for (let [, value] of Object.entries(result)) {
          
                this.artistList.push({idArtist:value.returnValues[1],artistName:value.returnValues[2]});
            }
            console.log(this.artistList);
            this.isLoading = false;
          }

          init();
      }
    },
    props: {
      connected: Boolean,
      address: String,
    },

    methods:{
        validate () {
            this.$refs.form.validate();
        
        },

        reset(){
            this.$refs.form.reset();
            this.songs = [];
        },

        displaySongs(){
          const init = async () => {
            const web3 = new Web3('http://localhost:7545');
            const id = await web3.eth.net.getId();
            const deployedNetwork = MusiChain.networks[id];
            const contractMusiChain = new web3.eth.Contract(MusiChain.abi, deployedNetwork.address);

            //const idArt = await contractMusiChain.methods.artistsCheck(this.artistName).call();
            const result = await contractMusiChain.getPastEvents('songAdded', {filter: {idArtist: this.artistId},fromBlock: 0});
            this.songList = [];
            for (let [key, value] of Object.entries(result)) {
                let randcolor = '#'+(Math.random()*0xFFFFFF<<0).toString(16);
                this.songList.push({title:value.returnValues[3],artist:value.returnValues[4],color: randcolor, cover: value.returnValues[8]});
                console.log(value.returnValues[2]);
                console.log(key)
            }
            
          }

          init();
        }
    }
  };
  </script>
  