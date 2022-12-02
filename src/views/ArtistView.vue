<template>
  <v-parallax
    dark
    height="200"
    src="https://wallpapersmug.com/download/1366x768/f5d72b/digital-art-horizon-mountains-forest-pinkish.jpg"
  >      
    <v-container>
      <h1 align="center">Registration as Artist</h1>
      <v-row justify="center">
        <v-col align="center" cols="12" md="6">
          <v-form
            ref="form"
            v-model="valid"
            lazy-validation
          >
          <br>
            <v-text-field
              v-model="name"
              :counter="15"
              :rules="nameRules"
              label="Name"
              required
              solo
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
  </v-parallax>  
</template>
  
  <script>
  
  
    export default {
      theme: { dark: true },
      data: () => ({
        valid: true,
        name: '',
        nameRules: [
          v => !!v || 'Name is required',
          v => (v && v.length <= 15) || 'Name must be less than 15 characters',
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