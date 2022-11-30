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
              v-model="nameSong"
              :counter="25"
              :rules="nameRules"
              label="Song Name"
              required
            ></v-text-field>

            <br>
           
           <v-row
           align="center"
           >
           <v-col cols="13">
          <v-autocomplete
            v-model="genre"
            :items="items"
            :rules="genreRules"
            dense
            label="Genre"
          ></v-autocomplete>
          </v-col>
          </v-row>
          
          

            <v-text-field
              v-model="Album"
              :counter="10"
              :rules="albumRules"
              label="Album"
              required
            ></v-text-field>

            <v-text-field
              v-model="year"
              :counter="4"
              :rules="yearRules"
              label="Year"
              required
            ></v-text-field>

            <v-text-field
              v-model="Lenght"
              :counter="4"
              :rules="lenghtRules"
              label="Lenght in seconds"
              required
            ></v-text-field>

            <template>
            <v-file-input
            counter
            show-size
            truncate-length="17"
              label="Song File"
              accept = "audio/mpeg"
              v-model="songFile"
             ></v-file-input>
            </template>

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
          <v-alert type="success" :value="alert">
          Song successfully added
          </v-alert>
          <v-img 
            max-height="500"
            max-width="500"
            :src=songCoverLink
          ></v-img>
        </v-col>

      </v-row>
    </v-container>
</template>
  
<script>
import { storage } from "@/firebase";
import { ref, uploadBytes} from "firebase/storage"; 
  
export default {


      data: () => ({
        alert: false,
        valid: true,
        songCoverLink: null,
        nameSong: '',
        items: ['Indie', 'Pop', 'Rock', 'Techno','Soul','Reggae','Country','Funk','Hip Hop','Jazz','Classical','Electronic','Blues','Vocal','Vaporwave','Traditional'],
        values: ['Pop', 'Rock'],
        genre: null,
        nameRules: [
          v => !!v || 'Name of song is required',
          v => (v && v.length <= 25) || 'Name must be less than 25 characters',
        ],
        Lenght: '',
        lenghtRules: [
          v => !!v || 'Lenght of song is required',
          v => (v && v.length <= 4) || 'It is not possible register a song of 2 hours',
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
    },

    created(){
    
    },

      methods: {
        validate () {
          this.$refs.form.validate();
            var reader = new FileReader();
            var reader2 = new FileReader();
            // Use the javascript reader object to load the contents
            // of the file in the v-model prop
            reader.readAsArrayBuffer(this.songFile);
            reader2.readAsArrayBuffer(this.songCover);
            reader.onload = () => {
              console.log(reader.result);
              var metadata = {
                    contentType: 'audio/mpeg',
                    };
              
              uploadBytes(ref(storage, this.nameSong+'.mp3'), reader.result, metadata).then((snapshot) => {
                          console.log(snapshot);
                      });
            }

            reader2.onload = () => {
              setTimeout(()=>{
                this.alert=true
              },100)
              console.log(reader2.result);
              var metadata = {
                    contentType: 'image/jpg',
                    };
              
              uploadBytes(ref(storage, this.album+'_cover.jpg'), reader2.result, metadata).then((snapshot) => {
                          console.log(snapshot);
                          this.$refs.form.reset();
                      });
              
              setTimeout(()=>{
                this.alert=false
              },3000)
            }
            
        },

        reset () {
          this.$refs.form.reset()
        },

        previewCover () {
          this.songCoverLink = URL.createObjectURL(this.songCover)
        }
      },
    }
  </script>