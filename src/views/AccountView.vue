<template>
   
  <v-container>
    <h1 align="center">Registration as Artist</h1>
    <v-row justify="center">
      <v-col align="center" cols="12" md="6">
        <v-form
          ref="form"
          v-model="valid"
          lazy-validation
        >
          <v-text-field
            v-model="name"
            :counter="15"
            :rules="nameRules"
            label="Name"
            required
          ></v-text-field>

          <v-btn
            v-if="connected"
            :disabled="!valid"
            color="success"
            class="mr-4"
            @click="validate"
          >
            Subscribe
          </v-btn>

          <v-btn
            color="error"
            class="mr-4"
            @click="reset"
          >
            Cancel
          </v-btn>

        </v-form>
      </v-col>
    </v-row>
    <v-row justify="center">
      <h3 v-if="done">Iscritto come artista</h3>
      <h3 v-if="!done && connected">Sei già un artista</h3>
    </v-row>
  </v-container>
</template>

<script>
const Web3 = require('web3');
const MusiChain = require('../../build/contracts/MusiChain.json');

export default {
    data: () => ({
      done: false,
      valid: true,
      name: '',
      nameRules: [
        v => !!v || 'Name is required',
        v => (v && v.length <= 15) || 'Name must be less than 15 characters',
      ],
    }),

    props: {
      connected: Boolean,
      address: String
    },

    methods: {
      validate () {
        this.$refs.form.validate();
        const init = async () => {
        const web3 = new Web3(window.ethereum);
        const id = await web3.eth.net.getId();
        const deployedNetwork = MusiChain.networks[id];
        const contractMusiChain = new web3.eth.Contract(MusiChain.abi, deployedNetwork.address);

        contractMusiChain.methods.addArtist(this.name).send({from: this.address})
        .then(receipt => {
            this.done = true;
            console.log(receipt);
        }).catch(error => {
            console.log(error.message);
        });
      }

      init();
      },

      reset () {
        this.$refs.form.reset()
      },
    },
}
</script>