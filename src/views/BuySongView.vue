<template>
  <div>    
    
      
        
        <v-container>
          <h1 align="center">Rent a Song</h1>
          <v-row justify="center">
          <v-col align="center" cols="12" md="6">
          <v-form
            ref="form"
            v-model="valid"
            lazy-validation
          >
            <br>
            <v-text-field
              v-model="artist"
              :counter="10"
              :rules="artistRules"
              label="Artist Name"
              required
              solo
              @change="(amount=0)"
            ></v-text-field>
            
            <v-text-field
              v-model="songName"
              :counter="25"
              :rules="songRules"
              label="Song Name"
              required
              solo
              @change="(amount=0)"
            ></v-text-field>

          
            <v-autocomplete
              v-model="rentPeriod"
              :items="rentList"
              :rules="rentRules"
              dense
              solo
              label="Rent period"
              @change="displayAmount"
            ></v-autocomplete>


            <v-btn
              v-if="connected"
              :disabled="!valid"
              color="success"
              class="mr-4"
              @click="validate"
              >
              Rent for {{amount}} ETH
            </v-btn>
  
            <v-btn
              color="#A52A2A"
              class="mr-4"
              @click="reset"
            >
              Reset Form
            </v-btn>

            <v-btn
              v-if="file"
              color="success"
              class="mr-4"
              >
              Download
            </v-btn>
            

          </v-form>
        </v-col>
      </v-row>

      <v-row justify="center">
        <v-col align="center" cols="12" md="3">
          <v-alert type="success" transition="fade-transition" :value="alert_succ">
           Song successfully rented
          </v-alert>
          
          <v-alert type="error" transition="fade-transition" :value="alert_fail">
          Fail, unable to rent the song
          </v-alert>
        </v-col>
       </v-row>
        
      
        </v-container>
      
      
     
  </div>  
</template>


  
<script>
import { storage } from "@/firebase";
import { ref, getBytes} from "firebase/storage";
const crypto = require("crypto-js");
const Web3 = require('web3');
const MusiChain = require('../../build/contracts/MusiChain.json');  
  
    export default {
      data: () => ({
        alert_succ: false,
        alert_fail: false,
        valid: true,
        rentPeriod: null,
        rentPeriodNumeric: null,
        songName: null,
        amount: null,
        artist: null,
        rentList: ['1 day', '3 days', '1 week', '1 month', '1 year'],
        songRules: [
          v => !!v || 'Song name is required',
          v => (v && v.length <= 25) || 'Name must be less than 25 characters',
        ],
        artistRules: [
          v => !!v || 'Artist name is required',
          v => (v && v.length <= 25) || 'Name must be less than 10 characters',
        ],
        rentRules: [
          v => !!v || 'Rent period is required',
        ],


      }),
  
      props: {
        connected: Boolean,
        address: String
      },
  
      methods: {
        validate () {
          this.$refs.form.validate();
          this.rentSong();
          //this.$refs.form.reset();
        },
        reset () {
          this.$refs.form.reset()
        },

        displayAmount(){
          const init = async () => {
            const web3 = new Web3(window.ethereum);
            const id = await web3.eth.net.getId();
            const deployedNetwork = MusiChain.networks[id];
            const contractMusiChain = new web3.eth.Contract(MusiChain.abi, deployedNetwork.address);
            const idArt = await contractMusiChain.methods.artistsCheck(this.artist).call();
            const result = await contractMusiChain.getPastEvents('songAdded', {filter: {idArtist: idArt},fromBlock: 0});
            
            for (let [, value] of Object.entries(result)) {
              if(value.returnValues[2] == this.songName){
                switch(this.rentPeriod){
                  case '1 day':
                    this.amount = web3.utils.fromWei(value.returnValues[5][0]);
                    this.rentPeriodNumeric = 0;
                  break;
                  case '3 days':
                    this.amount = web3.utils.fromWei(value.returnValues[5][1]);
                    this.rentPeriodNumeric = 1;
                  break;
                  case '1 week':
                    this.amount = web3.utils.fromWei(value.returnValues[5][2]);
                    this.rentPeriodNumeric = 2;
                  break;
                  case '1 month':
                    this.amount = web3.utils.fromWei(value.returnValues[5][3]);
                    this.rentPeriodNumeric = 3;
                  break;
                  case '1 year':
                    this.amount = web3.utils.fromWei(value.returnValues[5][4]);
                    this.rentPeriodNumeric = 4;
                  break;
                }

              }
                console.log(value.returnValues[5]);

            }

          }

          init();

        },

        rentSong(){
          const init = async () => {
            const web3 = new Web3(window.ethereum);
            const id = await web3.eth.net.getId();
            const deployedNetwork = MusiChain.networks[id];
            const contractMusiChain = new web3.eth.Contract(MusiChain.abi, deployedNetwork.address);
            const amountWei = web3.utils.toWei(this.amount.toString());
            const amountArtist = web3.utils.toWei((this.amount*0.98).toString());
            const amountMusiChain = web3.utils.toWei((this.amount*0.02).toString());
            console.log('Amount '+amountWei);
            console.log('Amount Artist '+amountArtist);
            console.log('Amount MusiChain '+amountMusiChain);
            console.log('Renting '+this.rentPeriodNumeric);

            contractMusiChain.methods.buySong(this.artist, this.songName, amountArtist, amountMusiChain, this.rentPeriodNumeric)
            .send({from: this.address, value: amountWei})
            .then(receipt => {
              this.alert_succ=true;
                console.log('CANZONE COMPRATA');
                console.log(receipt);
                this.downloadSong();
                setTimeout(()=>{
                            this.alert_succ=false;
                            this.$refs.form.reset();
                          },3000)
            }).catch(error => {
                console.log('CANZONE NON COMPRATA'+error.message);
                this.alert_fail=true;
                setTimeout(()=>{
                            this.alert_fail=false;
                            this.$refs.form.reset();
                          },3000)
            });
          }

          init();
        },

        downloadSong(){
          const songRef = ref(storage, this.artist.toLowerCase().replace(/\s/g, "")+'_'+this.songName.toLowerCase().replace(/\s/g, "")+'_enc.mp3');

          getBytes(songRef).then((bytes) =>{
                    console.log('Canzone scaricata' + bytes);
                    if (bytes) {
                    const byteArray = new Uint8Array(bytes);
                    var wordArray = crypto.lib.WordArray.create(byteArray);
                    console.log(wordArray);
                    var encrypted = crypto.AES.encrypt(wordArray, "Secret Passphrase").toString();
                    console.log("File Criptato = "+encrypted);
                    const blob = new Blob([encrypted], { type: "audio/mpeg"});
                    const url = window.URL.createObjectURL(blob);
                    var a = document.createElement("a");
                    a.href = url;
                    a.download = this.artist.toLowerCase().replace(/\s/g, "")+'_'+this.songName.toLowerCase().replace(/\s/g, "");
                    a.click();
                    URL.revokeObjectURL(url);
                }
                }).catch((error) => {
                    console.log(error)
                });
        }
      },
    }
</script>