<template>
   
  <v-container>
    <h1 v-if="(!connected || artistName == 'none')" align="center">Subscribe as an artist</h1>
    <v-row v-if="(!connected || artistName == 'none')" justify="center">
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
    <v-row v-if="(connected && artistName != 'none')" justify="center">
      <h1>Hi, <span class="purple--text">{{artistName}}</span></h1>
      <AddSong :connected="connected" :address="address" :artistName="artistName"/>
    </v-row>
    
  </v-container>
</template>
  
<script>
const Web3 = require('web3');
const MusiChain = require('../../build/contracts/MusiChain.json');
import AddSong from '../components/AddSong.vue';

export default {

    data: () => ({
      valid: true,
      name: '',
      nameRules: [
        v => !!v || 'Name is required',
        v => (v && v.length <= 15) || 'Name must be less than 15 characters',
      ],
    }),
    components: {
      AddSong
    },
    props: {
      connected: Boolean,
      address: String,
      artistName: String
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
            this.$emit("changeArtistName", this.name);
            console.log(receipt);
        }).catch(error => {
            console.log(error.message);
        });
      }

      init();
      },

      changeName() {
      
      },

      reset () {
        this.$refs.form.reset()
      },
    },
}
</script>