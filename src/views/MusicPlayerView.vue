<template>
        
    <v-container>
        <vuetify-audio :file="file" color="success" :ended="audioFinish" downloadable></vuetify-audio>
        <v-btn @click="crypt_decrypt">Crypt-Decrypt</v-btn>
        <h1>{{data}}</h1>
    </v-container>
</template>
  
<script>
//import { onMounted } from "vue";
import { storage } from "@/firebase";
import { ref, getDownloadURL, getBytes, uploadBytes} from "firebase/storage";
const crypto = require("crypto-js");



export default{
    components: {
        VuetifyAudio: () => import('vuetify-audio'),
    },
    data: () => ({
        file: null,
        data: null,
    }),
    
    props: {
      connected: Boolean,
      address: String,
    },

    methods: {
        crypt_decrypt: function(){
            function convertWordArrayToUint8Array(wordArray) {
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
                }



                
                const songRef = ref(storage, 'Calcutta_Pesto.mp3');
                this.data = songRef.fullPath;
                getDownloadURL(songRef)
                .then((url) => {
                    //this.file = url
                    console.log(url)
                })
                .catch((error) => {
                    console.log(error)
                });

                getBytes(songRef).then((bytes) =>{
                    console.log('Canzone scaricata' + bytes);
                    if (bytes) {
                    const byteArray = new Uint8Array(bytes);
                    var wordArray = crypto.lib.WordArray.create(byteArray);
                    console.log(wordArray);
                    var encrypted = crypto.AES.encrypt(wordArray, "Secret Passphrase").toString();
                    console.log('File criptato = ' + encrypted);
                    var decrypted = crypto.AES.decrypt(encrypted, "Secret Passphrase");             
                    var typedArray = convertWordArrayToUint8Array(decrypted);
                    console.log(typedArray);
                    const metadata = {
                    contentType: 'audio/mpeg',
                    };
                    uploadBytes(ref(storage, 'song_dec.mp3'), typedArray, metadata).then((snapshot) => {
                        console.log(snapshot);
                        console.log('Uploaded an array!');
                    });

                    const blob = new Blob([byteArray], { type: "audio/wav" });
                    this.file = window.URL.createObjectURL(blob);
                    console.log('Stringa file = '+byteArray);
                    console.log(this.file);
                }
                }).catch((error) => {
                    console.log(error)
                });

        }
    }
}
</script>