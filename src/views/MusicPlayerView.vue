<template>
        
    <v-container>
        <h1 align="center" class="display-1">Music Player</h1>
        <v-row justify="center" class="mt-10">
            <v-col align="center" cols="12" md="5">
                <v-file-input
                counter
                show-size
                label="Song File"
                accept = "audio/mpeg"
                v-model="songFile"
                solo
                :disabled="!connected"
                clearable
                
                ></v-file-input>
            </v-col>
        </v-row>
            <v-row justify="center" v-if="(songCover || songFile)">
                <v-col align="center" cols="12" md="5">
                    <h2 class="headline mb-5">{{ this.songName }} - {{ this.artistName }}</h2>
                    <v-img 
                        
                        max-height="500"
                        max-width="500"
                        :src=songCover
                    ></v-img>
                    <vuetify-audio :file="file" color="success"></vuetify-audio>
                </v-col>
                
            </v-row>

            <v-snackbar :timeout="3000" v-model="fail_exp" color="error">
                Can't play the song beacause is expired
                <template v-slot:action="{ attrs }">
                <v-btn
                color="white"
                text
                v-bind="attrs"
                @click="fail_exp = false"
                >
                Close
                </v-btn>
            </template>
            </v-snackbar>
            <v-snackbar :timeout="3000" v-model="fail_prop" color="error">
                This song doesn't belog to this user
                <template v-slot:action="{ attrs }">
                <v-btn
                color="white"
                text
                v-bind="attrs"
                @click="fail_prop = false"
                >
                Close
                </v-btn>
            </template>
            </v-snackbar>
        
    </v-container>
</template>
  
<script>
const crypto = require("crypto-js");
const Web3 = require('web3');
const MusiChain = require('../../build/contracts/MusiChain.json');


export default{
    components: {
        VuetifyAudio: () => import('vuetify-audio'),
    },
    data: () => ({
        file: null,
        songFile: null,
        songCover: null,
        artistName: null,
        songName: null,
        fail_exp: false,
        fail_prop: false
    }),
    
    props: {
      connected: Boolean,
      address: String,
    },
    watch:{
        songFile(){
            console.log("SongFile = "+this);
            if(this.songFile != null){
            var reader = new FileReader();
            reader.onloadend = () => {
                const init = async() =>{
                    const web3 = new Web3(window.ethereum);
                    const id = await web3.eth.net.getId();
                    const deployedNetwork = MusiChain.networks[id];
                    const contractMusiChain = new web3.eth.Contract(MusiChain.abi, deployedNetwork.address);
                    const randomKey = await contractMusiChain.methods.users(this.address).call();
                    console.log(randomKey);
                    console.log(reader.result);
                    var md5 = crypto.MD5(reader.result);
                    console.log("MD5 = "+md5);
                    var check_property = false;
                    const result = await contractMusiChain.getPastEvents('rented', {filter: {user: this.address},fromBlock: 0});
                    for (let [key, value] of Object.entries(result)) {
                        
                        
                        console.log("MD5 "+key+" "+value.returnValues[6]);

                        if(value.returnValues[6] == md5 ){
                            if(value.returnValues[4]*1000 > Date.now()){
                                var decrypted = crypto.AES.decrypt(reader.result, randomKey);             
                                var typedArray = this.convertWordArrayToUint8Array(decrypted);
                                const blob = new Blob([typedArray], { type: "audio/mpeg"});
                                this.file = window.URL.createObjectURL(blob);
                                this.songCover = value.returnValues[5];
                                this.artistName = value.returnValues[1];
                                this.songName = value.returnValues[2];
                                check_property = true;
                                break;
                            }else{
                            this.fail_exp = true;
                            console.log("Impossibile riprodurre canzone oltre il limite consentito");
                            
                        } 
                            
                        }

                    }

                    if(!check_property){
                        this.fail_prop = true;
                        console.log("Canzone non acquistata dall'utente");
                        check_property = false;
                    }
                    
                    
                };
                init();
            }
            reader.readAsText(this.songFile);
        }else{
            console.log("Vecchio "+this.file);
            this.songCover = null;
            URL.revokeObjectURL(this.file);
            this.file = null;
            console.log("Nuovo "+this.file);
        }
        }
    },
    beforeRouteLeave (to,from,next) {
        console.log(from.name+' to '+to.name);
        console.log("Link File da elimare: "+this.file);
        URL.revokeObjectURL(this.file);
        this.file = null;
        console.log("Link File eliminato ");
        next();
        },

    methods: {
        
        upload(){
            if(this.songFile != null){
            var reader = new FileReader();
            reader.onloadend = () => {
                const init = async() =>{
                    const web3 = new Web3(window.ethereum);
                    const id = await web3.eth.net.getId();
                    const deployedNetwork = MusiChain.networks[id];
                    const contractMusiChain = new web3.eth.Contract(MusiChain.abi, deployedNetwork.address);
                    const randomKey = await contractMusiChain.methods.users(this.address).call();
                    console.log(randomKey);
                    console.log(reader.result);
                    var md5 = crypto.MD5(reader.result);
                    console.log("MD5 = "+md5);
                    const result = await contractMusiChain.getPastEvents('rented', {filter: {user: this.address},fromBlock: 0});
                    for (let [, value] of Object.entries(result)) {
                        /* let randcolor = '#'+(Math.random()*0xFFFFFF<<0).toString(16); */
                        
                        console.log(value.returnValues[6]);

                        if(value.returnValues[6] == md5 && value.returnValues[4]*1000 > Date.now()){
                            var decrypted = crypto.AES.decrypt(reader.result, randomKey);             
                            var typedArray = this.convertWordArrayToUint8Array(decrypted);
                            const blob = new Blob([typedArray], { type: "audio/mpeg"});
                            this.file = window.URL.createObjectURL(blob);
                            this.songCover = value.returnValues[5];
                            break;
                        }else{
                            console.log("Canzone Scaduta");
                        } 

                    }
                    
                    
                };
                init();
            }
            reader.readAsText(this.songFile);
        }else{
            this.songCover = null;
        }

        },
        convertWordArrayToUint8Array(wordArray) {
                var arrayOfWords = wordArray.words;
                var length =wordArray.sigBytes;
                var uInt8Array = new Uint8Array(length), index=0, word, i;
                for (i=0; i<length; i++) {
                    word = arrayOfWords[i];
                    uInt8Array[index++] = word >> 24;
                    uInt8Array[index++] = (word >> 16) & 0xff;
                    uInt8Array[index++] = (word >> 8) & 0xff;
                    uInt8Array[index++] = word & 0xff;
                }
                return uInt8Array;
        },
    }
}
</script>