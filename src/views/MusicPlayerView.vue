<template>
        
    <v-container>
        <v-row justify="center">
            <v-col align="center" cols="12" md="8">
                <v-file-input
                counter
                show-size
                truncate-length="17"
                label="Song File"
                accept = "audio/mpeg"
                v-model="songFile"
                solo
                @change="upload"
                ></v-file-input>
            </v-col>
        </v-row>
            <v-row justidy="center">
                <v-col align="center" cols="12" md="12">
                    <vuetify-audio :file="file" color="success" :ended="audioFinish"></vuetify-audio>
                    <h1>{{data}}</h1>
                </v-col>
                
            </v-row>

            
        
    </v-container>
</template>
  
<script>
//import { onMounted } from "vue";
const crypto = require("crypto-js");



export default{
    components: {
        VuetifyAudio: () => import('vuetify-audio'),
    },
    data: () => ({
        file: null,
        data: null,
        songFile: null,
    }),
    
    props: {
      connected: Boolean,
      address: String,
    },

    methods: {
        upload(){
            var reader = new FileReader();
            reader.readAsText(this.songFile);
            reader.onload = () => {
              console.log(reader.result);
              var decrypted = crypto.AES.decrypt(reader.result, "Secret Passphrase");             
              var typedArray = this.convertWordArrayToUint8Array(decrypted);
              const blob = new Blob([typedArray], { type: "audio/mpeg"});
              this.file = window.URL.createObjectURL(blob);
              setTimeout(() => {
                 URL.revokeObjectURL(this.file);
              },1000);
              this.$refs.form.reset();
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