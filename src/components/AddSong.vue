<template>
        
    <v-container>
      <h1 align="center">Let's add a song!</h1>
      <v-row justify="center">
        <v-col align="center" cols="12" md="8">
          <v-form
            ref="form"
            v-model="valid"
            lazy-validation
          >
            
            <v-text-field
              v-model="songName"
              :counter="25"
              :rules="nameRules"
              label="Song Name"
              required
            ></v-text-field>

            <v-text-field
              v-model="album"
              :counter="10"
              :rules="albumRules"
              label="Album"
              required
            ></v-text-field>

            <v-autocomplete
                v-model="genre"
                :items="genre_list"
                :rules="genreRules"
                dense
                label="Genre"
            ></v-autocomplete>

            <v-text-field
              v-model="year"
              :counter="4"
              :rules="yearRules"
              label="Year"
              required
            ></v-text-field>

            <v-file-input
            counter
            show-size
            truncate-length="17"
              label="Song File"
              accept = "audio/mpeg"
              v-model="songFile"
             ></v-file-input>

            <v-file-input
            @change="previewCover"
            counter
            show-size
            truncate-length="17"
              label="Song/Album Cover"
              accept = "image/jpg"
              v-model="songCover"
             ></v-file-input>
             
            <v-btn
              v-if="connected"
              :disabled="!valid"
              color="success"
              class="mr-4"
              @click="validate"
            >
              Add
            </v-btn>
  
            <v-btn
              color="error"
              class="mr-4"
              @click="reset"
            >
              Reset
            </v-btn>
          </v-form>
        </v-col>
        <v-col align="center" cols="12" md="3" v-if="songCoverLink">
          <v-img 
            max-height="500"
            max-width="500"
            :src=songCoverLink
          ></v-img>
        </v-col>
      </v-row>
      <v-row justify="center">
        <v-alert type="success" transition="fade-transition" :value="alert_succ">
          Song successfully added
          </v-alert>
          <v-alert type="error" transition="fade-transition" :value="alert_fail">
          Song not added beacause already present
          </v-alert>
      </v-row>
    </v-container>
</template>
  
<script>
import { storage } from "@/firebase";
import { ref, uploadBytes} from "firebase/storage"; 
const Web3 = require('web3');
const MusiChain = require('../../build/contracts/MusiChain.json');

export default {


      data: () => ({
        songName: null,
        genre: null,
        album: null,
        year: null,
        songFile: null,
        songCover: null,
        songCoverLink: null,
        alert_succ: false,
        alert_fail: false,
        valid: true,
        genre_list: ['Indie', 'Pop', 'Rock', 'Techno','Soul','Reggae','Country','Funk','Hip Hop','Jazz','Classical','Electronic','Blues','Vocal','Vaporwave','Traditional'],
        nameRules: [
          v => !!v || 'Name of song is required',
          v => (v && v.length <= 25) || 'Name must be less than 25 characters',
        ],

        yearRules: [
          v => !!v || 'Year of song is required',
          v => (v && v.length <= 4) || 'It is not possible register a song from the future',
        ],
        albumRules: [
          v => !!v || 'Album of song is required',
          v => (v && v.length <= 25) || 'Name must be less than 25 characters',
        ],
        genreRules: [
          v => !!v || 'Genre of song is required',  
        ],

      }),
  
      props: {
      connected: Boolean,
      address: String,
      artistName: String
    },


      methods: {
        validate () {
            this.$refs.form.validate();
            this.submitSong();
            
        },

        reset () {
          this.$refs.form.reset()
        },

        previewCover () {
          this.songCoverLink = URL.createObjectURL(this.songCover)
        },

        submitSong(){
          const init = async () => {
            const web3 = new Web3(window.ethereum);
            const id = await web3.eth.net.getId();
            const deployedNetwork = MusiChain.networks[id];
            const contractMusiChain = new web3.eth.Contract(MusiChain.abi, deployedNetwork.address);
            
            contractMusiChain.methods.addSong(this.songName, this.genre, this.album, this.year).send({from: this.address, gas: 300000})
            .then(receipt => {
                console.log('CANZONE AGGIUNTA');
                console.log(receipt);
                this.uploadSongAndCover();
            }).catch(error => {
                this.alert_fail=true;
                setTimeout(()=>{
                  this.alert_fail=false;
                  this.$refs.form.reset();
                  this.songCoverLink = null;
                  this.songCoverLink = null;
                  },3000);
                
                console.log('CANZONE NON AGGIUNTA'+error.message);
            });
          }

          init();
        },

        uploadSongAndCover(){
          var reader = new FileReader();
            var reader2 = new FileReader();
            reader.readAsArrayBuffer(this.songFile);
            reader2.readAsArrayBuffer(this.songCover);
            reader.onload = () => {
              console.log(reader.result);
              var metadata = {
                    contentType: 'audio/mpeg',
                    };
              
              uploadBytes(ref(storage, this.artistName+'_'+this.songName+'.mp3'), reader.result, metadata).then((snapshot) => {
                          console.log(snapshot);
                      });
            }

            reader2.onload = () => {
                this.alert_succ=true;
              
              console.log(reader2.result);
              var metadata = {
                    contentType: 'image/jpg',
                    };
              
              uploadBytes(ref(storage, this.artistName+'_'+this.album+'_cover.jpg'), reader2.result, metadata).then((snapshot) => {
                          console.log(snapshot);
                          setTimeout(()=>{
                            this.alert_succ=false;
                            this.$refs.form.reset();
                            this.songCoverLink = null;
                            
                          },3000);
                         

                          
                      });
              
              
            }
        }
      },
    }
</script>