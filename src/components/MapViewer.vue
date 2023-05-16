<template>
  <div class="app">
    <!-- HEADER -->
    <NavBar v-if="viewer" :config="appConfig" :viewer="viewer" />

    <!-- MAP -->
    <div class="viewer">

      <!-- TABLE OF CONTENTS -->
      <MapToc
        v-if="viewer"
        class="toc"
        :viewer="viewer"
        :tocInfo="mapConfig.toc"
      />

      <!-- MAP WRAPPER -->
      <div class="mapContainer">
        <div class="navButtonBar">
          <b-button
            size="is-small"
            icon-left="plus"
            outlined
            v-on:click="navAction('plus')"
          />
          <b-button
            size="is-small"
            icon-left="home"
            outlined
            v-on:click="navAction('home')"
          ></b-button>
          <b-button
            size="is-small"
            icon-left="minus"
            outlined
            v-on:click="navAction('minus')"
          ></b-button>
        </div>
        <div class="container-fluid" id="geoclusterMap"></div>
      </div>

      <!-- <div class="mapToolbar">
        <b-button
          :class="identifyActive ? 'is-danger' : ''"
          size="is-small"
          icon-left="delete"
          @click="identify"
        />
      </div> -->

      <!-- <SideBar
        :config="appConfig"
        :viewer="viewer"
        :service="wmsService"
        :layerId="wmsName"
        :legend="wmsLegend"
        :title="wmsTitle"
      /> -->
    </div>

    <!-- FOOTER -->
    <FooterBar :config="appConfig" />
  </div>
</template>

<script>
/** Import the app configuration */
import AppConfig from '../assets/AppConfig.json'
import MapConfig from '../assets/MapConfig.json'

import NavBar from './NavBar.vue'
import MapToc from './MapToc.vue'
// import SideBar from './SideBar.vue'
import FooterBar from './FooterBar.vue'

import { Viewer } from 'os-map-library/build/main/Viewer'

export default {
  data() {
    return {
      loaded: false,
      appConfig: null,
      mapConfig: null,
      viewer: null,
      serviceName: 'Geocluster',
      serviceUrl: 'https://development.onesaitplatform.com/geoserver/metabuilding_geocluster/wms?',
      wmsService: null,
      wmsFilter: null,
      wmsLegend: null,
      wmsName: null,
      wmsTitle: null,
      currentLayer: null,
      identifyActive: false,
    }
  },
  components: {
    NavBar,
    MapToc,
    // SideBar,
    FooterBar
  },
  methods: {
    loadData() {
      /** Get the application configuration */
      this.appConfig = AppConfig

      /** Get the map configuration */
      this.mapConfig = JSON.parse(JSON.stringify(MapConfig.mapConfig))
    },
    async loadMap() {
      /** Create the Viewer class (that will contain the map viewers) */
      this.viewer = new Viewer()

      /** Load the maps in the viewer */
      await this.viewer.loadMaps(this.mapConfig, 'geoclusterMap')

      this.loaded = true

    },
    async handleWmsLayer(layerName, filter) {

      if (this.wmsService) {
        this.viewer.getActiveMap().removeServiceById(this.wmsService.getId())
        this.wmsService = null
        this.wmsLegend = null
        this.wmsName = null
        this.wmsTitle = null
      }

      if (!this.wmsService) {

        /** Setup the Map with the layer and styles to create the WMS */
        const wmsMap = new Map()
        wmsMap.set(layerName, null)

        const layerConfig = {
          type: "WMS",
          url: this.serviceUrl,
          wmsSublayers: wmsMap,
          customName: this.serviceName,
        }

        this.wmsService = await this.viewer.addService(layerConfig)

        /** Get the title of the layer */
        this.wmsName = this.wmsService.getSelectedLayers()[0].getLayerName()
        this.wmsTitle = this.wmsService.getSelectedLayers()[0].getTitle()

        /** Store the filter */
        this.wmsFilter = filter

        /** Get the legend */
        const fetchUrl = await fetch('https://development.onesaitplatform.com/geoserver/metabuilding_geocluster/wms?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&LAYER=' + layerName)
        this.wmsLegend = fetchUrl.url
      }
    },
    navAction(action) {
      if (!action) return

      switch (action) {
        case 'home':
          this.viewer.goToInitExtent()
          break

        case 'plus':
          this.viewer.zoomIn()
          break

        case 'minus':
          this.viewer.zoomOut()
          break
      }
    },
  },
  beforeMount() {
    /** Load the config data */
    this.loadData()
  },
  mounted() {
    /** Create the map */
    this.loadMap()

    // PubSub.subscribe('updateListOfLayers', this.updateListOfLayers.bind(this));

    /** Allow the app to load to avoid flickering and async problems */

    // console.log(this.viewer.getActiveMap())

  }
}
</script>

<style scoped>
body,
html {
  margin: auto;
}
.app {
  display: flex;
  flex-direction: column;
  width: 100%;
  height: 100vh;
  background-color: white;
}

.viewer {
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  height: 100%;
}

.toc {
  margin: 0 6px 6px 6px;
}

.mapContainer {
  order: 0;
  flex: 0 1 auto;
  align-self: auto;
  height: auto;
  width: 100%;
}

.mapToolbar {
  width: 48px;
  max-width: 48px;
  min-width: 48px;
}

.navButtonBar {
  display: flex;
  flex-direction: column;
  width: fit-content;
  justify-content: space-between;
  align-items: center;
  position: absolute;
  z-index: 10;
  border-radius: 6px;
  box-shadow: 0px 2px 3px #00000026, 0px 5px 4px #0000004d;
  margin: 10px 0 0 10px;
}

.button .icon:first-child:last-child {
  margin-left: calc(-0.5em - 1px);
  margin-right: calc(-0.5em - 1px) !important;
}

/* .button {
  width: 20px;
  height: 33px;
}

.icon span {
  margin-left: 10px !important;
} */

.button span {
  margin-left: -0.5rem !important;
}

#geoclusterMap {
  min-height: 80%;
  height: 100%;
}
</style>
