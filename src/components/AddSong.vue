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
              :counter="25"
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
              type="number"
              required
            ></v-text-field>

            <v-switch
              v-model="setPricing"
              label="Set song princing in ETH"
            ></v-switch>

            <v-row justify="center" v-if="setPricing">
              <v-col align="center" cols="12" md="4">
                <v-text-field
                  v-model="pricing[0]"
                  label="Price for 1 day"
                  type="number"
                  step="0.001"
                  max="2"
                ></v-text-field>

              </v-col>
              <v-col align="center" cols="12" md="4">
                <v-text-field
                  v-model="pricing[1]"
                  label="Price for 3 days"
                  type="number"
                  step="0.001"
                  max="2"
                ></v-text-field>
              </v-col>
              <v-col align="center" cols="12" md="4">
                <v-text-field
                  v-model="pricing[2]"
                  label="Price for 1 week"
                  type="number"
                  step="0.001"
                  max="2"
                ></v-text-field>
              </v-col>
            </v-row>

            <v-row justify="center" v-if="setPricing">
              <v-col align="center" cols="12" md="6">
                <v-text-field
                  v-model="pricing[3]"
                  label="Price for 1 month"
                  type="number"
                  step="0.001"
                  max="2"
                ></v-text-field>
              </v-col>
              <v-col align="center" cols="12" md="6">
                <v-text-field
                  v-model="pricing[4]"
                  label="Price for 1 year"
                  type="number"
                  step="0.001"
                  max="2"
                ></v-text-field>
              </v-col>
            </v-row>

            <v-file-input
            @change="previewSong"
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
            <v-row justify="center">
            
            <v-col align="center" cols="12" md="7">
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
          </v-col>
            <v-col align="center" cols="12" md="5" v-if="(alert_succ || alert_fail)">
              <v-alert type="success" transition="fade-transition" :value="alert_succ">
                Song successfully added
                </v-alert>
                <v-alert type="error" transition="fade-transition" :value="alert_fail">
                Song not added beacause already present
              </v-alert>
            </v-col>
          </v-row>
          </v-form>
          <v-row justify="center">
            
          </v-row>
          
        </v-col>
        <v-col align="center" cols="12" md="3" v-if="(songCoverLink || songFileLink)">
        
          <v-img 
            max-height="500"
            max-width="500"
            :src=songCoverLink
          ></v-img>
          <vuetify-audio :file="songFileLink" color="success"></vuetify-audio>
        </v-col>
      </v-row>
    </v-container>
</template>
  
<script>
import { storage } from "@/firebase";
import { ref, uploadBytesResumable, getDownloadURL} from "firebase/storage"; 
const Web3 = require('web3');
const MusiChain = require('../../build/contracts/MusiChain.json');

export default {

      components: {
        VuetifyAudio: () => import('vuetify-audio'),
      },
      data: () => ({
        audioFinish: ' ',
        setPricing: false,
        pricing: [0.001,0.0025,0.006,0.02,0.2],
        songName: null,
        genre: null,
        album: null,
        year: null,
        songFile: null,
        songCover: null,
        songCoverLink: null,
        songFileLink: null,
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
/*         priceRules: [
          v => !!v || 'Album of song is required',
          v => (v && v.length <= 6) || 'Price must be less than 5 digits',
        ], */

      }),
  
      props: {
      connected: Boolean,
      address: String,
      artistName: String
    },


      methods: {
        validate () {
            this.$refs.form.validate();
            this.uploadSongAndCover();
            
        },

        reset () {
          this.$refs.form.reset();
          this.pricing = [0.001,0.0025,0.006,0.02,0.2];
          URL.revokeObjectURL(this.songCoverLink);
          URL.revokeObjectURL(this.songFileLink);
          this.songCoverLink = null;
          this.songFileLink = null;
        },

        previewCover () {
          this.songCoverLink = URL.createObjectURL(this.songCover);
        },

        previewSong(){
          this.songFileLink = URL.createObjectURL(this.songFile);

        },

        submitSong(file_url, cover_url){
          const urls = [file_url, cover_url];
          console.log(urls[0]);
          console.log(urls[1]);
          const init = async () => {
                const web3 = new Web3('http://localhost:7545');
                const id = await web3.eth.net.getId();
                const deployedNetwork = MusiChain.networks[id];
                const contractMusiChain = new web3.eth.Contract(MusiChain.abi, deployedNetwork.address);
                var new_pricing = [];
                this.pricing.forEach(toWei)
                function toWei(item) {
                  new_pricing.push(web3.utils.toWei(item.toString()));
                }
                console.log(new_pricing);
                console.log(this.pricing);
                if(new_pricing.length != 0){
                  contractMusiChain.methods.addSong(this.songName, this.album, this.genre, this.year, new_pricing, urls).send({from: this.address, gas: 700000})
                  .then(receipt => {
                      console.log(receipt);
                      this.alert_succ = true;
                      setTimeout(()=>{
                        this.alert_succ = false;
                        this.$refs.form.reset();
                        this.pricing = [0.001,0.0025,0.006,0.02,0.2];
                        URL.revokeObjectURL(this.songCoverLink);
                        URL.revokeObjectURL(this.songFileLink);
                        this.songCoverLink = null;
                        this.songFileLink = null;
                      },3000);
                      
                      
                  }).catch(error => {
                      console.log(error.message);
                      this.alert_fail = true;
                      setTimeout(()=>{
                        this.alert_fail = false;
                        this.$refs.form.reset();
                        this.pricing = [0.001,0.0025,0.006,0.02,0.2];
                        URL.revokeObjectURL(this.songCoverLink);
                        URL.revokeObjectURL(this.songFileLink);
                        this.songCoverLink = null;
                        this.songFileLink = null;
                      },3000);
                      
                  });
                }else{
                  this.alert_fail = true;
                      setTimeout(()=>{
                        this.alert_fail = false;
                        this.$refs.form.reset();
                        URL.revokeObjectURL(this.songCoverLink);
                        URL.revokeObjectURL(this.songFileLink);
                        this.songCoverLink = null;
                        this.songFileLink = null;
                      },3000);
                }
            }

            init();
          
        },



        uploadSong(file, cover){
          var metadata = {contentType: 'audio/mpeg',};
          const storageRef = ref(storage, this.artistName.toLowerCase().replace(/\s/g, "")+'_'+this.songName.toLowerCase().replace(/\s/g, "")+'.mp3');
          const uploadTask = uploadBytesResumable(storageRef, file, metadata);
          uploadTask.on('state_changed', 
                    (snapshot) => {
                      // Observe state change events such as progress, pause, and resume
                      // Get task progress, including the number of bytes uploaded and the total number of bytes to be uploaded
                      const progress = (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
                      console.log('Upload is ' + progress + '% done');
                      switch (snapshot.state) {
                        case 'paused':
                          console.log('Upload is paused');
                          break;
                        case 'running':
                          console.log('Upload is running');
                          break;
                      }
                    }, 
                    (error) => {
                      // Handle unsuccessful uploads
                      console.log(error);
                    }, 
                    () => {
                      // Handle successful uploads on complete
                      // For instance, get the download URL: https://firebasestorage.googleapis.com/...
                      getDownloadURL(uploadTask.snapshot.ref).then((downloadURL) => {
                        console.log('File available at', downloadURL);
                        this.uploadCover(cover, downloadURL);
                        //var cover_url =  this.uploadCover(reader2);
                      });
                      
                    }
                  );
                
        },

        uploadCover(cover, file_url){
          var metadata = {contentType: 'audio/mpeg',};
          const storageRef = ref(storage, this.artistName.toLowerCase().replace(/\s/g, "")+'_'+this.songName.toLowerCase().replace(/\s/g, "")+'_cover.jpg');
          const uploadTask = uploadBytesResumable(storageRef, cover, metadata);
          uploadTask.on('state_changed', 
                    (snapshot) => {
                      // Observe state change events such as progress, pause, and resume
                      // Get task progress, including the number of bytes uploaded and the total number of bytes to be uploaded
                      const progress = (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
                      console.log('Upload is ' + progress + '% done');
                      switch (snapshot.state) {
                        case 'paused':
                          console.log('Upload is paused');
                          break;
                        case 'running':
                          console.log('Upload is running');
                          break;
                      }
                    }, 
                    (error) => {
                      // Handle unsuccessful uploads
                      console.log(error);
                    }, 
                    () => {
                      // Handle successful uploads on complete
                      // For instance, get the download URL: https://firebasestorage.googleapis.com/...
                      getDownloadURL(uploadTask.snapshot.ref).then((downloadURL) => {
                        console.log('Cover available at', downloadURL);
                        this.submitSong(file_url, downloadURL);
                      });
                    }
                  );
        },
        uploadSongAndCover(){
            /* var file_url = '';
            var cover_url = '';  */

            var reader = new FileReader();
            var reader2 = new FileReader();

            reader.onloadend = () => {
              console.log("FILE "+reader.result);
              console.log("COVER "+reader2.result);
              this.uploadSong(reader.result, reader2.result);  
            }

            reader.readAsArrayBuffer(this.songFile);
            reader2.readAsArrayBuffer(this.songCover);
          }
      },
    }
</script>