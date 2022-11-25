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
              v-model="addressUser"
              :counter="35"
              :rules="addressUserRules"
              label="Address of User"
              required
            ></v-text-field>
            
            <v-text-field
              v-model="nameSong"
              :counter="25"
              :rules="nameRules"
              label="Name of Song"
              required
            ></v-text-field>

            <v-text-field
              v-model="nameArtist"
              :counter="20"
              :rules="nameArtistRules"
              label="Name of Artist"
              required
            ></v-text-field>

            <v-text-field
              v-model="genre"
              :counter="20"
              :rules="nameArtistRules"
              label="Name of Artist"
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
        nameRules: [
          v => !!v || 'Name of song is required',
          v => (v && v.length <= 25) || 'Name must be less than 25 characters',
        ],
        addressUser: '',
        addressUserRules: [
          v => !!v || 'Address of User is required',
          v => (v && v.length <= 35) || 'Address must be less than 35 characters',
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