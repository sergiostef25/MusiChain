<template>
      
    <v-container>
      <v-row justify="center" v-if="!addsong"><h2>Your Songs</h2></v-row>
      
      <v-row >
        <v-col align="center" cols="12" md="3">
          <v-img 
            v-if="(artistAvatarLink)"
            max-height="150"
            max-width="150"
            :src=artistAvatarLink
            class="rounded-pill mb-10"
          >
          <template v-slot:placeholder>
              <v-row
                class="fill-height ma-0"
                align="center"
                justify="center"
              >
                <v-progress-circular
                  indeterminate
                  color="grey lighten-5"
                ></v-progress-circular>
              </v-row>
          </template>
          </v-img>
          <h2 align="center" class="mb-10">Hi, <span class="purple--text">{{artistName}}</span></h2>
          <v-btn @click="addsong = !addsong" v-if="!addsong" color="primary">Let's add a new song!</v-btn>
          <v-btn @click="addsong = !addsong" v-if="addsong" color="primary">Go to your catalog</v-btn>
          
        </v-col>
        
        <v-col align="center" cols="12" md="6" >
          <v-form
          v-if="addsong"
            ref="form"
            v-model="valid"
            lazy-validation
            :disabled="isLoading"
          >
            
            <v-text-field
              v-model="songName"
              :counter="25"
              :rules="nameRules"
              label="Song Name"
              required
              solo
              clearable
              
            ></v-text-field>

            <v-combobox
              v-model="album"
              :items="albumList"
              :loading="isLoading2"
              :search-input.sync="search"
              item-text="album"
              item-value="album"
              label="Album"
              required
              solo
              clearable
              chips
              @input="handleInput"
            >
                <template v-slot:item="{ item }">
                  <v-list-item-avatar
                    color="indigo"
                    class="text-h5 font-weight-light white--text"
                  >
                    <v-img :src="item.link_cover"></v-img>
                  </v-list-item-avatar>
                  <v-list-item-content>
                    <v-list-item-title v-text="item.album"></v-list-item-title>
                    </v-list-item-content>
                  <v-list-item-action>
                    <v-icon>mdi-album</v-icon>
                  </v-list-item-action>
                </template>

                <template v-slot:no-data>
                <v-list-item>
                  <v-list-item-content>
                    <v-list-item-title>
                      No results matching "<strong>{{ search }}</strong>". Press <kbd>enter</kbd> to create a new one
                    </v-list-item-title>
                  </v-list-item-content>
                </v-list-item>
              </template>
            </v-combobox>

            <v-autocomplete
                v-model="genre"
                :items="genre_list"
                :rules="genreRules"
                dense
                label="Genre"
                solo
                required
                clearable
            ></v-autocomplete>

            <v-text-field
              v-model="year"
              :counter="4"
              :rules="yearRules"
              label="Year"
              type="number"
              required
              solo
              clearable
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
                  solo
                  clearable
                ></v-text-field>

              </v-col>
              <v-col align="center" cols="12" md="4">
                <v-text-field
                  v-model="pricing[1]"
                  label="Price for 3 days"
                  type="number"
                  step="0.001"
                  max="2"
                  solo
                  clearable
                ></v-text-field>
              </v-col>
              <v-col align="center" cols="12" md="4">
                <v-text-field
                  v-model="pricing[2]"
                  label="Price for 1 week"
                  type="number"
                  step="0.001"
                  max="2"
                  solo
                  clearable
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
                  solo
                  clearable
                ></v-text-field>
              </v-col>
              <v-col align="center" cols="12" md="6">
                <v-text-field
                  v-model="pricing[4]"
                  label="Price for 1 year"
                  type="number"
                  step="0.001"
                  max="2"
                  solo
                  clearable
                ></v-text-field>
              </v-col>
            </v-row>

            <v-file-input
              counter
              show-size
              truncate-length="17"
              label="Cover"
              accept = "image/jpg"
              v-model="songCover"
              required
              solo
              clearable
             ></v-file-input>

            <v-file-input
              counter
              show-size
              truncate-length="17"
              label="Song File"
              accept = "audio/mpeg"
              v-model="songFile"
              required
              solo
              clearable
             ></v-file-input>

            
            <v-row justify="center">
            
            <v-col align="center" cols="12" md="7">
            <v-btn
              v-if="connected && (songFile && songCover && songName && album && genre && year)"
              color="success"
              class="mr-4"
              :loading="isLoading"
              :disabled="isLoading"
              @click="validate"
            >
              Upload
            </v-btn>
  
            <v-btn
              v-if="connected && (songFile || songCover || songName || album || genre || year)"
              color="error"
              class="mr-4"
              @click="reset"
              :disabled="isLoading"
            >
              Reset
            </v-btn>
          </v-col>

          </v-row>
          </v-form>
          
        <v-row justify="center" v-if="!addsong">
        
        <v-col justify="center" md="10"
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
                  v-text="song.songName"
                ></v-card-title>
                <v-card-subtitle>{{ song.album }} ({{ song.year }}), {{song.genre }}</v-card-subtitle>
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


        </v-col>
        
        <v-col align="center" cols="12" md="3" v-if="(songCoverLink || songFileLink)">
          <v-img 
            v-if="(songCoverLink || songFileLink)"
            max-height="500"
            max-width="500"
            :src=songCoverLink
          ></v-img>
          <vuetify-audio :file="songFileLink" color="success" v-if="(songCoverLink || songFileLink)"></vuetify-audio>
        </v-col>
        
        
      

      

      </v-row>

      
      <v-snackbar :timeout="3000" v-model="alert_succ" color="success">
        Song successfully added
        <template v-slot:action="{ attrs }">
        <v-btn
          color="white"
          text
          v-bind="attrs"
          @click="alert_succ = false"
        >
          Close
        </v-btn>
      </template>
      </v-snackbar>
      <v-snackbar :timeout="3000" v-model="alert_fail" color="error">
        Song not added beacause already present
        <template v-slot:action="{ attrs }">
        <v-btn
          color="white"
          text
          v-bind="attrs"
          @click="alert_fail = false"
        >
          Close
        </v-btn>
      </template>
      </v-snackbar>
    </v-container>
</template>
  
<script>
import { storage } from "@/firebase";
import { ref, uploadBytesResumable, getDownloadURL} from "firebase/storage"; 
const Web3 = require('web3');
const MusiChain = require('../../build/contracts/MusiChain.json');
var web3=null;
var id=null;
var deployedNetwork=null;
var contractMusiChain=null;
export default {

      components: {
        VuetifyAudio: () => import('vuetify-audio'),
      },
      data: () => ({
        addsong: false,
        songList: [],
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
        valid: false,
        isLoading: false,
        albumList: [],
        search: null,
        isLoading2: false,
        result: null,
        artistAvatarLink: null,
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
      
      created(){
        const init = async () => {
          web3 = new Web3(window.ethereum);
          id = await web3.eth.net.getId();
          deployedNetwork = MusiChain.networks[id];
          contractMusiChain = new web3.eth.Contract(MusiChain.abi, deployedNetwork.address);
          
          const artistId = await contractMusiChain.methods.artistsCheck(this.artistName).call();
          const result = await contractMusiChain.getPastEvents('artistAdded', {filter: {idArtist: artistId},fromBlock: 0});
          for (let [, value] of Object.entries(result)) {
            this.artistAvatarLink = value.returnValues[3];
          }
        }

        init();
      },
      mounted(){
        if(this.connected){
          this.displaySongs();
        }
      },
      watch: {
        connected(){
          this.displaySongs();
        },
        songFile(){
          if(this.songFile != null){
            this.previewSong();
          }else{  
            URL.revokeObjectURL(this.songFileLink);
            this.songFileLink = null;
          }
        },
        songCover(){
          if(this.songCover != "0"){
            if(this.songCover != null){
              this.previewCover();
            }else{  
              URL.revokeObjectURL(this.songCoverLink);
              this.songCoverLink = null;
            }
          }
          
        },
        search(){
          
          /* if(this.albumList.length > 0) return */

          this.isLoading2 = true;

          const init = async () => {
              /* const web3 = new Web3('http://localhost:7545');
              const id = await web3.eth.net.getId();
              const deployedNetwork = MusiChain.networks[id];
              const contractMusiChain = new web3.eth.Contract(MusiChain.abi, deployedNetwork.address); */
              
              this.result = await contractMusiChain.getPastEvents('songAdded', {filter: {user: this.address}, fromBlock: 0});
              /* this.albumList = []; */
              for (let [, value] of Object.entries(this.result)) {
                  this.albumList.push({album:value.returnValues[5], genre: value.returnValues[6],  year:value.returnValues[7],link_cover:value.returnValues[11]});
              }
              this.isLoading2 = false;
          }

            init();
        },


      },
      props: {
      connected: Boolean,
      address: String,
      artistName: String
    },

      methods: {

        handleInput(e) {
        console.log(e);
        if(typeof e == 'string') {
          console.log("Stringa");
            this.album = {album: this.album}
        }else{
           console.log('object - do something with object, value selected from list');
           this.genre = this.album.genre;
           this.year = this.album.year;
           this.songCoverLink = this.album.link_cover;
           this.songCover = "0";
       }
      },

      displaySongs(){
          const init = async () => {
            const web3 = new Web3(window.ethereum);
            const id = await web3.eth.net.getId();
            const deployedNetwork = MusiChain.networks[id];
            const contractMusiChain = new web3.eth.Contract(MusiChain.abi, deployedNetwork.address);
            
            //const idArt = await contractMusiChain.methods.artistsCheck(this.artistName).call();
            const result = await contractMusiChain.getPastEvents('songAdded', {filter: {user: this.address},fromBlock: 0});
            this.songList = [];
            var color = ['#4A148C','#6A1B9A','#7B1FA2','#8E24AA','#AB47BC','#BA68C8','#CE93D8','#E1BEE7','#F3E5F5']
            for (let [key, value] of Object.entries(result)) {
                /* let randcolor = '#'+(Math.random()*0xFFFFFF<<0).toString(16); */
                
                
                  this.songList.push({songName: value.returnValues[3], album: value.returnValues[5], genre: value.returnValues[6], year: value.returnValues[7], link_cover: value.returnValues[11],color: color[key]}); 
                

                }
            
          }

          init();
        },

        validate () {
            this.$refs.form.validate();
            this.isLoading = true;
            this.uploadSongAndCover();
            
        },

        reset () {
          this.$refs.form.reset();
          this.pricing = [0.001,0.0025,0.006,0.02,0.2];
          URL.revokeObjectURL(this.songCoverLink);
          URL.revokeObjectURL(this.songFileLink);
          this.songCoverLink = null;
          this.songFileLink = null;
          this.isLoading = false;
          this.albumList = [];
        },

        previewCover () {
          if(this.songCover != "0"){
            this.songCoverLink = URL.createObjectURL(this.songCover);
          }
          
        },

        previewSong(){
          this.songFileLink = URL.createObjectURL(this.songFile);

        },

        submitSong(file_url, cover_url){
          const urls = [file_url, cover_url];
          const init = async () => {
                /* const web3 = new Web3('http://localhost:7545');
                const id = await web3.eth.net.getId();
                const deployedNetwork = MusiChain.networks[id];
                const contractMusiChain = new web3.eth.Contract(MusiChain.abi, deployedNetwork.address); */
                var new_pricing = [];
                this.pricing.forEach(toWei)
                function toWei(item) {
                  new_pricing.push(web3.utils.toWei(item.toString()));
                }

                if(new_pricing.length != 0){
                  
                  contractMusiChain.methods.addSong(this.songName, this.album.album, this.genre, this.year, new_pricing, urls).send({from: this.address, gas: 700000})
                  .then(receipt => {
                      console.log(receipt);
                      this.alert_succ = true;
                        this.reset();
                        this.displaySongs();
                      
                      
                  }).catch(error => {
                      console.log(error.message);
                      this.alert_fail = true;
                      this.reset();
                      
                  });
                }else{
                  this.alert_fail = true;
                  this.reset();
                      
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
                        if(this.songCover != "0"){
                          this.uploadCover(cover, downloadURL);
                        }else{
                          this.submitSong(downloadURL, this.songCoverLink);
                        }
                          
                        //var cover_url =  this.uploadCover(reader2);
                      });
                      
                    }
                  );
                
        },

        uploadCover(cover, file_url){


            var metadata = {contentType: 'image/jpg',};
            const storageRef = ref(storage, this.artistName.toLowerCase().replace(/\s/g, "")+'_'+this.album.album.toLowerCase().replace(/\s/g, "")+'_cover.jpg');
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