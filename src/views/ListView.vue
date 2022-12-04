<template>
    <v-container>
        <h1 align="center">Search for an artist's song catalog</h1>
        <v-form
          ref="form"
          v-model="valid"
          lazy-validation
        >
        <v-text-field
            v-model="artistName"
            :counter="15"
            :rules="nameRules"
            label="Name"
            required
            solo
        ></v-text-field>

        <v-btn
            :disabled="!valid"
            color="#006400"
            class="mr-4"
            @click="validate"
          >
            Search
        </v-btn>

        <v-btn
            color="#A52A2A"
            class="mr-4"
            @click="reset"
          >
            Cancel
        </v-btn>

        </v-form>
        <v-col
          v-for="(song, i) in songs"
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
            valid: false,
            group: null,
            songs: [],
            artistName: null,
            nameRules: [
            v => !!v || 'Name is required',
            v => (v && v.length <= 15) || 'Name must be less than 15 characters',],

            
        }
      },

    props: {
      connected: Boolean,
      address: String,
    },

    methods:{
        validate () {
            this.$refs.form.validate();
            const init = async () => {
            const web3 = new Web3('http://localhost:7545');
            const id = await web3.eth.net.getId();
            const deployedNetwork = MusiChain.networks[id];
            const contractMusiChain = new web3.eth.Contract(MusiChain.abi, deployedNetwork.address);

            const idArt = await contractMusiChain.methods.artistsCheck(this.artistName).call();
            const result = await contractMusiChain.getPastEvents('songAdded', {filter: {idArtist: idArt},fromBlock: 0});
            this.songs = [];
            for (let [key, value] of Object.entries(result)) {
                let randcolor = '#'+(Math.random()*0xFFFFFF<<0).toString(16);
                this.songs.push({title:value.returnValues[2],artist:value.returnValues[3],color: randcolor, cover: value.returnValues[7]});
                console.log(value.returnValues[2]);
                console.log(key)
            }
            
        }

        init();
        },

        reset(){
            this.$refs.form.reset();
        }
  
    }
  };
  </script>
  