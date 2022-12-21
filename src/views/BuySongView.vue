<template>  
        <v-container>
          <h1 align="center">Rent a Song</h1>

          <!-- <v-sheet
            class="mx-auto"
            
            max-width="80%"
            color="transparent"
          >
            <v-slide-group
              v-model="model"
              class="pa-4"
              center-active
              show-arrows
            >
              <v-slide-item
                v-for="(artist,n) in artistList"
                :key="n"
                v-slot="{ active}"
              >
              
                <v-card
                  :color="active ? 'transparent' : 'transparent'"
                  class="ma-8"
                  height="150"
                  width="100"
                  elevation="0"
                  @click="search='c'"
                  
                >
                  <v-row
                    class="fill-height"
                    align="center"
                    justify="center"

                  >
                  
                    <v-scale-transition>
                      <v-img :src="artist.link_avatar" class="rounded-circle"></v-img>
                      
                    </v-scale-transition>
                    {{ artist.name }}
                  </v-row>
                  
                </v-card>
                
              </v-slide-item>
            </v-slide-group>
          </v-sheet> -->
          


          <v-row justify="center">
          <v-col align="center" cols="12" md="6">
            <v-form
            ref="form"
            v-model="valid"
            lazy-validation
            :diasbled="isLoading"
            >
            <v-autocomplete
                v-model="songId"
                :items="songList"
                item-text="title"
                item-value="id"
                label="Name"
                solo
                chips
                clearable
                hide-selected
                :loading="isLoading2"
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
                <span v-text="(item.title)"></span>
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
                <v-list-item-title v-text="item.songName"></v-list-item-title>
                <v-list-item-subtitle v-text="(item.album+' ('+item.year+') - '+item.artistName)+' ['+item.genre+']'"></v-list-item-subtitle>
              </v-list-item-content>
              <v-list-item-action>
                <v-icon>mdi-music</v-icon>
              </v-list-item-action>
            </template>
            </v-autocomplete>

            <v-select
              :disabled="(songId == null)"
              v-model="rentPeriod"
              :items="rentList"
              dense
              solo
              chips
              label="Rent period"
              clearable
              hide-selected
            ></v-select>

            <v-btn
              v-if="connected && (songId!=null && rentPeriod!=null)"
              :disabled="isLoading"
              color="success"
              class="mr-4"
              @click="validate"
              >
              Rent for {{amount}} ETH
            </v-btn>
            </v-form>
        </v-col>
      </v-row>

      <v-snackbar :timeout="3000" v-model="alert_succ" color="success">
        Song successfully rented
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
        Fail, unable to rent the song
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

<!--       <v-row justify="center">
        <v-col align="center" cols="12" md="3">
          <v-alert type="success" transition="fade-transition" :value="alert_succ">
           Song successfully rented
          </v-alert>
          
          <v-alert type="error" transition="fade-transition" :value="alert_fail">
          Fail, unable to rent the song
          </v-alert>
        </v-col>
       </v-row> -->
      <v-row justify="center">
        <v-col align="center" cols="12" md="3" v-if="songId">
        
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
import { ref, getBytes} from "firebase/storage";
const crypto = require("crypto-js");
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
        model: null,
        songList: [],
        isLoading: false,
        isLoading2: false,
        search: null,
        alert_succ: false,
        alert_fail: false,
        valid: false,
        rentPeriod: null,
        rentPeriodNumeric: null,
        songName: null,
        amount: null,
        songId: null,
        songCoverLink: null,
        songFileLink: null,
        rentList: ['1 day', '3 days', '1 week', '1 month', '1 year'],
      }),

      created(){
        const init = async () => {
          web3 = new Web3('http://localhost:7545');
          id = await web3.eth.net.getId();
          deployedNetwork = MusiChain.networks[id];
          contractMusiChain = new web3.eth.Contract(MusiChain.abi, deployedNetwork.address);
        }

        init();
        
      },

      watch:{

        songId(){
          if(this.songId){
            this.songCoverLink=this.songList.find(x => x.id === this.songId).link_cover;
            this.songFileLink=this.songList.find(x => x.id === this.songId).link_file;
            if(this.rentPeriod != null){
            this.displayAmount();
            this.valid = true;
            }
            
            
          }else{
            this.valid = false;
          }
          
        },

        rentPeriod(){
          if(this.rentPeriod){
            this.valid = true;
            this.displayAmount();
          }else{
            this.valid = false;
          }
          
        },

        search () {
        // Items have already been loaded
        if (this.songList.length > 0) return

        this.isLoading2 = true;

        const init = async () => {
            
            
            const result = await contractMusiChain.getPastEvents('songAdded', {fromBlock: 0});
            
            for (let [, value] of Object.entries(result)) {
          
                this.songList.push({idArtist:value.returnValues[1],id:value.returnValues[2],title:value.returnValues[3]+' - '+value.returnValues[5]+'('+value.returnValues[7]+'), '+value.returnValues[4]+' ['+value.returnValues[6]+']',songName:value.returnValues[3], artistName:value.returnValues[4], album:value.returnValues[5], genre: value.returnValues[6],  year:value.returnValues[7],pricing:value.returnValues[9],link_file:value.returnValues[10],link_cover:value.returnValues[11]});
            }
            console.log(this.songList);
            this.isLoading2 = false;
          }

          init();
      },
      },
      props: {
        connected: Boolean,
        address: String,
        artistList: Array
      },
  
      methods: {
        validate () {
          this.isLoading = true;
          this.$refs.form.validate();
          this.rentSong();
          
        },
        reset () {
          this.isLoading = false;
          this.amount = null;
          this.$refs.form.reset();
        },

        
        displayAmount(){
          
          const web3 = new Web3(window.ethereum);
          switch(this.rentPeriod){
                  case '1 day':
                    this.amount = web3.utils.fromWei(this.songList.find(x => x.id === this.songId).pricing[0]);
                    this.rentPeriodNumeric = 0;
                  break;
                  case '3 days':
                    this.amount = web3.utils.fromWei(this.songList.find(x => x.id === this.songId).pricing[1]);
                    this.rentPeriodNumeric = 1;
                  break;
                  case '1 week':
                    this.amount = web3.utils.fromWei(this.songList.find(x => x.id === this.songId).pricing[2]);
                    this.rentPeriodNumeric = 2;
                  break;
                  case '1 month':
                    this.amount = web3.utils.fromWei(this.songList.find(x => x.id === this.songId).pricing[3]);
                    this.rentPeriodNumeric = 3;
                  break;
                  case '1 year':
                    this.amount = web3.utils.fromWei(this.songList.find(x => x.id === this.songId).pricing[4]);
                    this.rentPeriodNumeric = 4;
                  break;
                }


        },

        rentSong(){
          const init = async () => {
            web3 = new Web3(window.ethereum);
            id = await web3.eth.net.getId();
            deployedNetwork = MusiChain.networks[id];
            contractMusiChain = new web3.eth.Contract(MusiChain.abi, deployedNetwork.address);
            const amountWei = web3.utils.toWei(this.amount.toString());
            const amountArtist = web3.utils.toWei((this.amount*0.98).toString());
            const amountMusiChain = web3.utils.toWei((this.amount*0.02).toString());
            console.log('Amount '+amountWei);
            console.log('Amount Artist '+amountArtist);
            console.log('Amount MusiChain '+amountMusiChain);
            console.log('Renting '+this.rentPeriodNumeric);
            const song = this.songList.find(x => x.id === this.songId);
            contractMusiChain.methods.buySong(song.artistName, song.songName, amountArtist, amountMusiChain, this.rentPeriodNumeric)
            .send({from: this.address, value: amountWei})
            .then(receipt => {
              this.alert_succ=true;
                console.log('CANZONE COMPRATA');
                console.log(receipt);
                this.downloadSong(song);
                this.reset();
                this.valid = true;          
            }).catch(error => {
                console.log('CANZONE NON COMPRATA'+error.message);
                this.alert_fail=true;
                this.reset();
                this.valid = false;
            });
          }

          init();
        },

        downloadSong(song){
          const songRef = ref(storage, song.artistName.toLowerCase().replace(/\s/g, "")+'_'+song.songName.toLowerCase().replace(/\s/g, "")+'.mp3');

          getBytes(songRef).then((bytes) =>{
                    console.log('Canzone scaricata' + bytes);
                    const init = async() =>{
                      const randomKey = await contractMusiChain.methods.users(this.address).call();
                      console.log(randomKey);
                      if (bytes) {
                          const byteArray = new Uint8Array(bytes);
                          var wordArray = crypto.lib.WordArray.create(byteArray);
                          console.log(wordArray);
                          var encrypted = crypto.AES.encrypt(wordArray, randomKey).toString();
                          console.log("File Criptato = "+encrypted);
                          var md5 = crypto.MD5(encrypted).toString();
                          console.log("MD5 = "+md5);
                          
                          const result = await contractMusiChain.methods.emitRented(song.artistName, song.songName, this.rentPeriodNumeric, song.link_cover, md5)
                          .send({from: this.address})
                          console.log(result);
                          const blob = new Blob([encrypted], { type: "audio/mpeg"});
                          const url = window.URL.createObjectURL(blob);
                          var a = document.createElement("a");
                          a.href = url;
                          a.download = song.artistName.toLowerCase().replace(/\s/g, "")+'_'+song.songName.toLowerCase().replace(/\s/g, "");
                          a.click();
                          URL.revokeObjectURL(url);
                      }
                    };

                    init();
                    
                }).catch((error) => {
                    console.log(error)
                });
        }
      },
    }
</script>