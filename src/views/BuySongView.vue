<template>
        
    <v-container>
      <h1 align="center">Buy a Song</h1>
      <v-row justify="center">
        <v-col align="center" cols="12" md="6">
          <v-form
            ref="form"
            v-model="valid"
            lazy-validation
          >

          <v-text-field
              v-model="Artist"
              :counter="10"
              :rules="artistRules"
              label="Name of Artist"
              required
            ></v-text-field>
            
            <v-text-field
              v-model="nameSong"
              :counter="25"
              :rules="songRules"
              label="Name of Song"
              required
            ></v-text-field>

            <br>
           
           <v-row
           align="center"
           >
           <v-col cols="13">
          <v-autocomplete
            v-model="rent"
            :items="items"
            :rules="rentRules"
            dense
            label="Rent period"
          ></v-autocomplete>
          </v-col>
          </v-row>

            <v-text-field
              v-model="Amount"
              :counter="4"
              :rules="amountRules"
              label="Amount"
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
              color="success"
              class="mr-4"
              @click="validate"
              :rules="buyRules"
              v-for="link in links" :key="link.text" router :to="link.route"
              >
              Buy
            </v-btn>
  
            <v-btn
              color="error"
              class="mr-4"
              @click="reset"
            >
              Reset Form
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
        links: [
          { route: '/failed'},
          
        ],
        nameSong: '',
        Amount:'',
        items: ['1 day', '3 days', '7 days', '31 days', '365 days'],
        values: ['1 day', '365 days'],
        genre: null,
        songRules: [
          v => !!v || 'Name of song is required',
          v => (v && v.length <= 25) || 'Name must be less than 25 characters',
        ],
        Artist: '',
        artistRules: [
          v => !!v || 'Lenght of song is required',
          v => (v && v.length <= 10) || 'Name must be less than 10 characters',
        ],
        rentRules: [
          v => !!v || 'Rent period is required',
          v => (v && v.length <= 15) || 'Error',
        ],
        amountRules: [
          v => !!v || 'You can not buy without money',
          v => (v && v.length <= 4) || 'Less than 4 character',
        ],
        buyRules: [
          v => (v && v.length <= 25) || 'Insufficient!',
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