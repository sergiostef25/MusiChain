<template>
   
  <v-container>
    <h1 v-if="(!connected || artistName == 'none')" align="center" class="ma-10">Subscribe as an <span class="purple--text">Artist</span></h1>

    
    <v-row v-if="(!connected || artistName == 'none')" justify="center">
      <v-col align="center" cols="12" md="9">
        <v-form
          ref="form"
          v-model="valid"
          lazy-validation
          :disabled="isLoading"
        >
        <v-img 
            v-if="artistAvatarLink"
            max-height="200"
            max-width="200"
            :src=artistAvatarLink
            class="rounded-circle mb-10"
          ></v-img>

          

          <v-text-field
            v-model="name"
            :counter="15"
            :rules="nameRules"
            label="Name"
            required
            solo
            clearable
          ></v-text-field>

          <v-file-input
              counter
              show-size
              truncate-length="17"
              label="Artist Avatar"
              accept = "image/jpg"
              v-model="artistAvatar"
              required
              solo
              clearable
             ></v-file-input>

          <v-btn
            v-if="connected && artistAvatarLink != null"
            :disabled="isLoading"
            :loading="isLoading"
            color="success"
            class="mr-4"
            @click="validate"
          >
            Subscribe
          </v-btn>

          

        </v-form>
      </v-col>
    </v-row>
    <v-row v-if="(connected && artistName != 'none')" justify="center">
      <!-- <h1 align="center" class="mb-10">Hi, <span class="purple--text">{{artistName}}</span><br/>Let's add a song!</h1>
       -->
      <AddSong :connected="connected" :address="address" :artistName="artistName" />
    </v-row>
    
  </v-container>
</template>
  
<script>
const Web3 = require('web3');
const MusiChain = require('../../build/contracts/MusiChain.json');
import AddSong from '../components/AddSong.vue';
import { storage } from "@/firebase";
import { ref, uploadBytesResumable, getDownloadURL} from "firebase/storage"; 

export default {

    data: () => ({
      valid: false,
      name: null,
      artistAvatar: null,
      artistAvatarLink: null,
      isLoading: false,
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

    watch:{
      artistAvatar(){
          if(this.artistAvatar != null){
            this.previewAvatar();
          }else{  
            URL.revokeObjectURL(this.artistAvatarLink);
            this.artistAvatarLink = null;
          }
        },
    },

    methods: {

      previewAvatar(){
          this.artistAvatarLink = URL.createObjectURL(this.artistAvatar);
        },

      uploadAvatar(avatar){
        
        var metadata = {contentType: 'image/jpg',};
            const storageRef = ref(storage, this.name.toLowerCase().replace(/\s/g, "")+'_avatar.jpg');
            const uploadTask = uploadBytesResumable(storageRef, avatar, metadata);
            uploadTask.on('state_changed', 
                      (snapshot) => {
                        // Observe state change events such as progress, pause, and resume
                        // Get task progress, including the number of bytes uploaded and the total number of bytes to be uploaded
                        const progress = (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
                        console.log('Upload is ' + progress + '% done');
                        switch (snapshot.state) {
                          case 'paused':
                            console.log('Upload is paused');
                            break;
                          case 'running':
                            console.log('Upload is running');
                            break;
                        }
                      }, 
                      (error) => {
                        // Handle unsuccessful uploads
                        console.log(error);
                      }, 
                      () => {
                        // Handle successful uploads on complete
                        // For instance, get the download URL: https://firebasestorage.googleapis.com/...
                        getDownloadURL(uploadTask.snapshot.ref).then((downloadURL) => {
                          console.log('Cover available at', downloadURL);
                          this.submitArtist(downloadURL);
                        });
                      }
                    );
      },
      validate () {
        this.$refs.form.validate();
        this.isLoading = true;
        var reader = new FileReader();

        reader.onloadend = () => {
          this.uploadAvatar(reader.result);  
        }

        reader.readAsArrayBuffer(this.artistAvatar);

      },

      submitArtist(avatarURL) {
        const init = async () => {
          const web3 = new Web3(window.ethereum);
          const id = await web3.eth.net.getId();
          const deployedNetwork = MusiChain.networks[id];
          const contractMusiChain = new web3.eth.Contract(MusiChain.abi, deployedNetwork.address);

          contractMusiChain.methods.addArtist(this.name, avatarURL).send({from: this.address})
          .then(receipt => {
              this.$emit("changeArtistName", this.name);
              URL.revokeObjectURL(this.artistAvatarLink);
              this.artistAvatarLink = null;
              /* var new_artistsList = [];
              const init = async () => {
                const result = await contractMusiChain.getPastEvents('artistAdded', {fromBlock: 0});

                for (let [, value] of Object.entries(result)) {
                    
                  new_artistsList.push(value.returnValues[2]);
                }
              }
              init();
              this.$emit("addArtist", new_artistsList); */
              console.log(receipt);
          }).catch(error => {
            URL.revokeObjectURL(this.artistAvatarLink);
            this.artistAvatarLink = null;
            console.log(error.message);
          });
        }

        init();
        this.isLoading = false;
      },

      reset () {
        this.$refs.form.reset()
      },
    },
}
</script>