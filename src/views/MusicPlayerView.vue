<template>
        
    <v-container>
        <vuetify-audio :file="file" color="success" :ended="audioFinish" downloadable></vuetify-audio>
    </v-container>
</template>
  
<script>
  
export default{
    components: {
        VuetifyAudio: () => import('vuetify-audio'),
    },
    data: () => ({
        file: 'http://www.hochmuth.com/mp3/Boccherini_Concerto_478-1.mp3',
    }),
}
</script>