<template>

    <v-container>
        <h1 align="center">List of Songs</h1>
            <v-row justify="center">
             <v-col align="center" cols="12" md="6">
             <v-form
            ref="form"
            v-model="valid"
            lazy-validation
            >

          <br>

     <v-card
      class="mx-auto"
      max-width="344"
      outlined
     >
      <v-list-item three-line >
        <v-list-item-content>
          <div class="text-overline mb-4">
            album
          </div>
          <v-list-item-title class="text-h5 mb-1">
            Title
          </v-list-item-title>
          <v-list-item-subtitle>artist</v-list-item-subtitle>
        </v-list-item-content>
  
        <v-list-item-avatar
          tile
          size="80"
          color="grey"
          src="https://m.media-amazon.com/images/I/81rYyY4k+QL._AC_SL1425_.jpg"
        ></v-list-item-avatar>
      </v-list-item>
  
      <v-card-actions>
        <v-btn
          outlined
          rounded
          text
        >
          Buy
        </v-btn>
      </v-card-actions>
    </v-card>

             </v-form>
             </v-col>
             </v-row>
    </v-container>
  </template>

<script>
export default {
    data: () => ({
        songs: [
          {title: 'Levitating', artist: 'Dua Lipa', album: 'Future Nostalgia'},
          {title: 'Physical', artist: 'Dua Lipa', album: 'Future Nostalgia'},
          {title: 'Love Me Again', artist: 'Dua Lipa', album: 'Future Nostalgia'},
  
        ],

        title1: this.songs.title,

    }),

    props: {
        connected: Boolean,
        address: String
      },

    methods: {
        

    },
}


</script>