<template>
        
    <v-container>
      <h1 align="center">Recording of Song</h1>
      <v-row justify="center">
        <v-col align="center" cols="12" md="6">
          <v-form
            ref="form"
            v-model="valid"
            lazy-validation
          >
            
            <v-text-field
              v-model="nameSong"
              :counter="25"
              :rules="nameRules"
              label="Name of Song"
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
              v-model="Year"
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


            <v-btn
              v-if="connected"
              :disabled="!valid"
              color="success"
              class="mr-4"
              @click="validate"
            >
              Validate
            </v-btn>
  
            <v-btn
              color="error"
              class="mr-4"
              @click="reset"
            >
              Reset Form
            </v-btn>
  
            <v-btn
              color="warning"
              @click="resetValidation"
            >
              Reset Validation
            </v-btn>
          </v-form>
        </v-col>
      </v-row>
    </v-container>
  </template>
  
  <script>
  
  
    export default {
      data: () => ({
        valid: true,
        nameSong: '',
        items: ['indie', 'pop', 'rock', 'techno','soul','reggae','country','funk','hip hop','jazz','classical','electronic','blues','vocal','vaporwave','traditional'],
        values: ['pop', 'rock'],
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
        connected: Boolean
      },
  
      methods: {
        validate () {
          this.$refs.form.validate()
        },
        reset () {
          this.$refs.form.reset()
        },
        resetValidation () {
          this.$refs.form.resetValidation()
        },
      },
    }
  </script>