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
      <v-list-item three-line>
        <v-list-item-content>
          <div class="text-overline mb-4">
            Album
          </div>
          <v-list-item-title class="text-h5 mb-1">
            Title Song
          </v-list-item-title>
          <v-list-item-subtitle>idk what write</v-list-item-subtitle>
        </v-list-item-content>
  
        <v-list-item-avatar
          tile
          size="80"
          color="grey"
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
export default {}
</script>