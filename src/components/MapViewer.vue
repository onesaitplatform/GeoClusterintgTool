<template>
  <div v-if="loaded" class="app">
    <!-- HEADER -->
    <NavBar :config="appConfig" :viewer="viewer" />

    <!-- MAP -->
    <div class="viewer">
      <MapToc :config="appConfig" :viewer="viewer" />

      <div class="map">b</div>

      <div class="sidebar">c</div>
    </div>

    <!-- FOOTER -->
    <FooterBar :config="appConfig" />
  </div>
</template>

<script>
/** Import the app configuration */
import AppConfig from '../assets/AppConfig.json'

import NavBar from './NavBar.vue'
import MapToc from './MapToc.vue'
import FooterBar from './FooterBar.vue'

export default {
  data() {
    return {
      loaded: false,
      appConfig: {},
      viewer: {}
    }
  },
  components: {
    NavBar,
    MapToc,
    FooterBar
  },
  mounted() {
    /** Get the application configuration */
    this.appConfig = AppConfig

    /** Get the map configuration */
    // this.mapConfig = MapConfig

    /** Allow the app to load */
    this.loaded = true
  }
}
</script>

<style scoped>
.app {
  display: flex;
  flex-direction: column;
  width: 100%;
  height: 100vh;
  background-color: aqua;
}

.viewer {
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  height: 100%;
}
</style>
