<template>
    <v-container>
        <h1 align="center">Artists</h1>
        <v-card
            class="mx-auto"
            max-width="600"
        >

          <v-container fluid>
            <v-row dense>
              <v-col
                v-for="card in cards"
                :key="card.title"
                :cols="card.flex"
              >
                <v-card>
                  <v-img
                    :src="card.src"
                    class="white--text align-end"
                    gradient="to bottom, rgba(0,0,0,.1), rgba(0,0,0,.5)"
                    height="250px"
                  >
                    <v-card-title v-text="card.title"></v-card-title>
                  </v-img>

                  <v-card-actions>
                    <v-spacer></v-spacer>
                    <v-spacer></v-spacer>
                    <v-btn icon>
                      <v-icon>mdi-heart</v-icon>
                    </v-btn>

                    <v-btn icon>
                      <v-icon>mdi-folder-music</v-icon>
                    </v-btn>

                  </v-card-actions>

              </v-card>
              </v-col>
            </v-row>
          </v-container>
              </v-card>
          


 </v-container>

</template>

<script>
export default {
    data() {
        return {
            valid: false,
            group: null,
            songs: [],
            artistName: null,
            cards: [
             
             { title: 'Dua Lipa', src: 'https://yt3.ggpht.com/ytc/AMLnZu_rkOQP282cWp5MJLwUAHdVgJ9QqmO8Y4xmJk92vQ=s900-c-k-c0x00ffffff-no-rj', flex: 6 },
             { title: 'Harry Styles', src: 'https://www.cromosomax.com/pics/2022/06/harry-styles-ayuda-a-un-fan-a-salir-del-armario-como-gay-durante-el-concierto-de-wembley-eres-un-hombre-libre.jpg', flex: 6 },
             { title: 'Francesca Michielin', src: 'https://www.radiobruno.it/wp-content/uploads/2018/07/FRANCESCA-MICHIELIN.jpg', flex: 6 },
             { title: 'Daft Punk', src: 'https://i.discogs.com/sP_wDoC5MsG9lZUfb9thLbpmMmL__nuVnGMNpwgjirE/rs:fit/g:sm/q:90/h:438/w:600/czM6Ly9kaXNjb2dz/LWRhdGFiYXNlLWlt/YWdlcy9BLTEyODkt/MTYxNTQ4NDUyOS00/Mjg0LmpwZWc.jpeg', flex: 6 },
             { title: 'Ed Sheeran', src: 'https://st.ilfattoquotidiano.it/wp-content/uploads/2019/07/12/ed-sheeran-905.jpg', flex: 6 },
             { title: 'Lady Gaga', src: 'https://www.umbriajournal.com/wp-content/uploads/2022/10/Lady-Gaga.jpg', flex: 6 },
             { title: 'Bruno Mars', src: 'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/gettyimages-911568542-1517221248.jpg', flex: 6 },
             { title: 'Ariana Grande', src: 'https://media.allure.com/photos/6127ac0b238beb835812ce4c/1:1/w_2250,h_2250,c_limit/Ariana%20Grande%20Allure%20Cover%20No%20Coverlines.jpg', flex: 6 },
             { title: 'Eminem', src: 'https://www.outpump.com/wp-content/uploads/2022/03/eminem-diamante-outpump.jpeg', flex: 6 },
            ],

            
        }
      },

    }


</script>