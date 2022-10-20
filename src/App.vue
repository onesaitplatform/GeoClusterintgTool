<template>
  <div id="app">
    <MapViewer />
  </div>
</template>

<script>
import MapViewer from './components/MapViewer.vue'

export default {
  name: 'App',
  components: {
    MapViewer
  }
}
</script>

<style>
/* #app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
} */
body {
  margin: 0 !important;
}
</style>
