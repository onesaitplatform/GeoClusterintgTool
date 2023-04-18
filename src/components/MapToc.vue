<template>
  <div id="toc" :class="['toc', !expanded && 'closed']">
    <!-- MAP CONTENTS -->
    <div v-if="expanded && show" class="tocContent">
      <!-- MAP TITLE -->
      <div class="mapName">{{ mapName }}</div>

      <!-- TOC TABS -->
      <b-tabs v-model="activeTab">
        <!-- FULL TOC -->
        <b-tab-item label="All layers">
          <!-- TOC CONTENT -->
          <div v-if="dataLoaded && services.length > 0">
            <!-- LOAD GROUPS -->
            <div v-for="group in services" :key="group.id" class="layerGroup">
              <!-- GROUP NAME -->
              <div class="layerGroupName">{{ group.name }}</div>

              <!-- LAYER SLOT -->
              <div
                v-for="layer in group.layers"
                :key="layer.name"
                class="layerSlot"
              >
                <!-- LAYER BLOCK -->
                <div class="layerGroupItems">
                  <!-- LAYER VISIBILITY ICON + LAYER NAME -->
                  <div class="layerLeftBlock">
                    <!-- LAYER VISIBILITY ICON -->
                    <div
                      class="layerVisibility"
                      @click="
                        handleVisibility(layer.id, layer.name, layer.symbology)
                      "
                    >
                      <b-icon
                        :icon="layer.show ? 'eye-outline' : 'eye-off-outline'"
                        size="is-small"
                      >
                      </b-icon>
                    </div>

                    <!-- LAYER NAME -->
                    <div class="layerName">{{ layer.name }}</div>
                  </div>

                  <!-- LAYER LEGEND ICON -->
                  <div class="layerRightBlock">
                    <div
                      class="layerSymbology"
                      @click="
                        handleSymbology(layer.id, layer.name, layer.symbology)
                      "
                    >
                      <!-- TOOLTIP -->
                      <b-tooltip
                        :delay="500"
                        :label="
                          layer.symbology
                            ? texts.tooltips.hideLegend
                            : texts.tooltips.showLegend
                        "
                        type="is-light"
                        position="is-left"
                      >
                        <b-icon
                          :icon="
                            layer.symbology
                              ? 'chevron-down-circle-outline'
                              : 'chevron-left-circle-outline'
                          "
                          size="is-small"
                        >
                        </b-icon>
                      </b-tooltip>
                    </div>
                  </div>
                </div>

                <!-- LEGEND -->
                <div v-if="layer.symbology" class="legend">
                  <img :src="layer.legend" />
                </div>
              </div>
            </div>
          </div>
        </b-tab-item>

        <!-- FILTERED TOC -->
        <b-tab-item
          label="Visible layers"
          :disabled="visibleServices.length === 0"
        >
          <draggable
            class="list-group"
            tag="ul"
            v-model="visibleServices"
            v-bind="dragOptions"
            handle=".layerDrag"
            @start="drag = true"
            @end="dragEnd()"
          >
            <transition-group
              type="transition"
              :name="!drag ? 'flip-list' : null"
            >
              <div
                v-for="layer in visibleServices"
                :key="layer.id"
                class="layerSlot"
              >
                <!-- LAYER BLOCK -->
                <div class="layerGroupItems">
                  <!-- LAYER VISIBILITY ICON + LAYER NAME -->
                  <div class="layerLeftBlock">
                    <!-- DRAG ICON -->
                    <div class="layerDrag">
                      <b-icon icon="menu" size="is-small"> </b-icon>
                    </div>

                    <!-- LAYER VISIBILITY ICON -->
                    <div
                      class="layerVisibility"
                      @click="
                        handleVisibility(layer.id, layer.name, layer.symbology)
                      "
                    >
                      <b-icon
                        :icon="layer.show ? 'eye-outline' : 'eye-off-outline'"
                        size="is-small"
                      >
                      </b-icon>
                    </div>

                    <!-- LAYER NAME -->
                    <div class="layerName">{{ layer.name }}</div>
                  </div>

                  <!-- OPTIONS ICON -->
                  <div class="layerRightBlock">
                    <!-- SHOW LEGEND -->
                    <div
                      class="layerSymbology"
                      @click="
                        handleSymbology(layer.id, layer.name, layer.symbology)
                      "
                    >
                      <!-- LEGEND & LEGEND TOOLTIP -->
                      <b-tooltip
                        :delay="500"
                        :label="
                          layer.symbology
                            ? texts.tooltips.hideLegend
                            : texts.tooltips.showLegend
                        "
                        type="is-light"
                        position="is-left"
                      >
                        <b-icon
                          :icon="
                            layer.symbology
                              ? 'chevron-down-circle-outline'
                              : 'chevron-left-circle-outline'
                          "
                          size="is-small"
                        >
                        </b-icon>
                      </b-tooltip>
                    </div>

                    <!-- LAYER OPACITY -->
                    <div
                      class="layerTransparency"
                      @click="handeLayerSlider(layer.id)"
                    >
                      <!-- FILTER & FILTER TOOLTIP -->
                      <b-tooltip
                        :delay="500"
                        :label="texts.tooltips.layerOpacity"
                        type="is-light"
                        position="is-left"
                      >
                        <b-icon icon="flip-horizontal" size="is-small">
                        </b-icon>
                      </b-tooltip>
                    </div>

                    <!-- FILTER LAYER -->
                    <div
                      class="layerTransparency"
                      @click="filterLayer(layer.id, layer.name)"
                    >
                      <!-- FILTER & FILTER TOOLTIP -->
                      <b-tooltip
                        :delay="500"
                        :label="texts.tooltips.filterLayer"
                        type="is-light"
                        position="is-left"
                      >
                        <b-icon icon="layers-search" size="is-small"> </b-icon>
                      </b-tooltip>
                    </div>
                  </div>
                </div>

                <!-- LAYER OPACITY -->
                <div v-if="layer.showLayerSlider" class="opacity">
                  <div class="transparencyName">
                    {{ texts.inputs.opacity }}
                  </div>
                  <div
                    class="transparencySlider"
                    v-on:input="changeLayerOpacity(layer)"
                  >
                    <input
                      type="range"
                      min="0"
                      max="1"
                      step="0.01"
                      value="1"
                      v-model="layer.opacity"
                    />
                  </div>
                  <div class="transparencyValue">
                    {{ parseInt(layer.opacity * 100) }}
                  </div>
                </div>

                <!-- LEGEND -->
                <div v-if="layer.symbology" class="legend">
                  <img :src="layer.legend" />
                </div>
              </div>
            </transition-group>
          </draggable>
        </b-tab-item>
      </b-tabs>
    </div>

    <!-- TOC LABEL WHEN COLLAPSED -->
    <div v-if="!expanded && label"></div>

    <!-- SHOW/COLLAPSE TOC -->
    <span class="tocButton" @click="expanded = !expanded">
      <b-icon
        :icon="expanded ? 'chevron-double-left' : 'chevron-double-right'"
      />
    </span>
  </div>
</template>

<script>
// import { PubSub } from 'os-map-library/build/main/OSModule/Utils/PubSub'
import draggable from 'vuedraggable'

export default {
  data() {
    return {
      dataLoaded: false,
      activeTab: 0,
      drag: false,
      map: null,
      mapName: null,
      services: [],
      visibleServices: [],
      url: 'https://development.onesaitplatform.com/geoserver/metabuilding_geocluster/wms',
      url2: 'https://development.onesaitplatform.com/geoserver/rest/workspaces/metabuilding_geocluster/datastores/Onesait+Platform+Development+PostGIS/featuretypes/',
      expanded: true,
      show: true,
      label: false,
      showTest: false,
      showFilter: false,
      texts: {
        inputs: {
          opacity: 'Opacity:'
        },
        tooltips: {
          showLegend: 'Show Legend',
          hideLegend: 'Hide Legend',
          layerOpacity: "Change Opacity",
          filterLayer: 'Filter Layer'
        }
      }
    }
  },
  props: {
    viewer: {
      type: Object,
      required: true,
    },
    tocInfo: {
      type: Array,
      required: true
    }
  },
  components: {
    draggable
  },
  computed: {
    dragOptions() {
      return {
        animation: 200,
        group: "description",
        disabled: false,
        ghostClass: "ghost"
      }
    }
  },
  watch: {
    expanded: function (value) {
      if (value) {
        this.name = false
        setTimeout(() => {
          this.show = true
        }, 450)
      } else {
        this.show = false
        setTimeout(() => {
          this.name = true
          this.viewer.updateMapsSize()
        }, 450)
      }
    },
    activeTab: function (tabIndex) {
      if (tabIndex === 0) {
        this.services.forEach(group => {
          group.layers.forEach(layer => {
            if (layer.service) {
              layer.service.setZIndex(layer.zIndex)
              layer.service.setOpacity(1)
            }
          })
        })
      } else {
        this.visibleServices.forEach(service => {
          service.service.setZIndex(service.visibleIndex)
          service.service.setOpacity(service.opacity)
        })
      }
    },
  },
  methods: {
    findService(id) {
      let service = null

      this.services.forEach(serv => {
        const find = serv.layers.find(x => x.id === id)
        if (find) service = find
      })

      return service
    },
    async handleVisibility(id, name, filter) {
      /** Find the service */
      const service = this.findService(id)

      if (service.service && service.type && service.type === 'multi') {
        this.viewer.getActiveMap().removeService(service.service)
      }

      if (!service.service) {
        const wmsService = await this.loadWmsService(id, name, filter)
        service.service = wmsService[0]
        service.legend = wmsService[1]
        service.show = true
        service.service.setZIndex(service.zIndex)
      } else {
        /** Check if the service is already loaded with a multi flag */
        service.service.setVisible(!service.service.isVisible())
        service.show = !service.show
      }

      this.handleVisibleLayer(service)

      if (this.visibleServices.length === 0) {
        this.activeTab = 0
      }

    },
    handleVisibleLayer(service) {
      const id = service.id
      const visible = service.show

      if (visible) {
        service.visibleIndex = this.visibleServices.length + 1
        this.visibleServices.push(service)
        this.visibleServices = this.visibleServices.sort((a, b) => b.visibleIndex - a.visibleIndex)
      } else {
        this.visibleServices = this.visibleServices.filter(x => x.id !== id)
        service.service.setZIndex(service.zIndex)
      }
    },
    dragEnd() {
      this.drag = false
      let n = this.visibleServices.length
      this.visibleServices.forEach(service => {
        service.visibleIndex = n
        service.service.setZIndex(n)
        n -= 1
      })
    },
    handeLayerSlider(id) {
      const service = this.visibleServices.find(x => x.id === id)
      service.showLayerSlider = !service.showLayerSlider
    },
    changeLayerOpacity(layer) {
      layer.service.setOpacity(layer.opacity)
    },
    async handleSymbology(id, name) {
      /** Find the service */
      const service = this.findService(id)

      if (!service.service) {
        const wmsService = await this.loadWmsService(id, name)
        service.service = wmsService[0]
        service.legend = wmsService[1]
        service.service.setVisible(false)
      }

      service.symbology = !service.symbology
    },
    async loadWmsService(id, name, filter) {
      const wmsMap = new Map()
      wmsMap.set(id)

      const layerConfig = {
        type: "WMS",
        url: this.url,
        sublayers: wmsMap,
        customName: name,
      }

      const service = await this.viewer.addService(layerConfig)

      /** Store the filter */
      if (filter) {
        this.wmsFilter = filter
      }

      /** Get the legend */
      const fetchUrl = await fetch(this.url + '?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&LAYER=' + id)
      const wmsLegend = fetchUrl.url

      return [service, wmsLegend]
    },
    async filterLayer(id) {

      const availableFilters = []

      await fetch(this.url2 + id + '.json')
        .then((response) => response.json())
        .then((data) => {

          if (!Array.isArray(data.featureType.metadata.entry)) return

          data.featureType.metadata.entry.forEach(val => {
            if (val['@key'] && val['@key'] === 'JDBC_VIRTUAL_TABLE') {
              const virtualTable = val.virtualTable

              if (!virtualTable.parameter) return

              virtualTable.parameter.forEach(param => {
                param.currentValue = param.defaultValue
                availableFilters.push(param)
              })
            }

          })
        })

      this.showFilter = true

      const newFilters = []

      availableFilters.forEach(filter => {
        const userFilter = prompt("Add a filter for'" + filter.name + "'", filter.currentValue)
        const newFilter = {
          name: filter.name,
          value: userFilter
        }
        newFilters.push(newFilter)
      })

      if (newFilters.length === 0) return

      this.sendFilter(id, newFilters)

    },
    sendFilter(id, filter) {
      /** Find the service */
      const service = this.findService(id)

      if (!service) return

      let viewparamFilter = ''

      filter.forEach(param => {
        viewparamFilter += param.name + ':' + param.value + ';'
      })

      service.service.addFilter('viewparams', viewparamFilter)

    },
  },
  async mounted() {
    /** Get the map and it name */
    this.map = await this.viewer.getListOfMaps()[0]
    this.mapName = this.viewer.getListOfMaps()[0].getName()

    let n = 1

    this.tocInfo.forEach(group => {

      const obj = {
        id: group.id,
        name: group.name,
        layers: []
      }

      group.layers.forEach(layer => {

        obj.layers.push({
          id: layer.id,
          name: layer.name,
          loaded: false,
          show: false,
          service: null,
          symbology: false,
          showLayerSlider: false,
          opacity: 1,
          legend: null,
          zIndex: n,
          visibleIndex: null,
        })

        n += 1
      })

      this.services.push(obj)
    })

    this.dataLoaded = true
  }
};
</script>

<style scoped>
/* TOC COMPONENT */
.toc {
  display: flex;
  flex-direction: column;
  flex: 0 1 auto;
  justify-content: space-between;
  min-width: 350px;
  max-width: 350px;
  width: auto;
  /* height: 100%; */
  background-color: white;
  transition: width 0.4s, min-width 0.4s;
  /* overflow-y: scroll; */
}

.toc span {
  margin-top: auto;
}

.closed {
  width: 42px;
  min-width: 42px;
}

.tocButton {
  display: flex;
  justify-content: flex-end;
  margin-bottom: 6px;
}

.tocContent {
  display: flex;
  flex-direction: column;
  height: calc(100vh - 52px - 40px - 41px - 100px);
  max-height: calc(100vh - 52px - 40px - 41px - 100px);
}

/* TOC TITLE */

/* The map name in the gray block */
.mapName {
  color: #001927;
  font-weight: lighter;
  font-size: large;
  padding: 6px 0 6px 12px;
  background-color: #f0f1f2;
  margin-bottom: 6px;
}

/* TABS */
:deep(.tab-content) {
  overflow-y: auto !important;
  height: calc(100vh - 52px - 40px - 41px - 100px);
}

.handle {
  float: left;
  padding-top: 8px;
  padding-bottom: 8px;
}

/* LAYERS */

/* Each block of layers: Default, Climate, etc. */
.layerGroup {
  margin-bottom: 20px;
}

/* The name of each layer block */
.layerGroupName {
  display: flex;
  font-weight: bold;
}

.layerSlot {
  display: flex;
  flex-direction: column;
  margin-bottom: 6px;
}

.layerGroupItems {
  display: flex;
  flex-direction: row;
  justify-content: space-between;
}

.layerLeftBlock {
  display: flex;
  flex-direction: row;
  justify-content: space-between;
}

.layerRightBlock {
  display: flex;
  flex-direction: row;
  justify-content: flex-end;
}

.layersContainer {
  color: #001927;
  /* padding: 6px 0 6px 12px; */
  /* overflow-y: scroll; */
}

.legend {
  display: flex;
  margin-top: 10px;
  margin-left: 25px;
  margin-bottom: 10px;
}

.opacity {
  display: flex;
  margin-top: 10px;
  margin-left: 25px;
  margin-bottom: 10px;
}

.transparencySlider {
  margin-left: 20px;
}

.transparencyValue {
  margin-left: 20px;
}

.slot {
  display: flex;
  justify-content: space-between;
}

.margin-bottom {
  margin-bottom: 12px;
}

.layerDrag {
  margin-right: 6px;
  cursor: grab;
}

.layerVisibility {
  margin-right: 6px;
  cursor: pointer;
}

.card-content {
  padding: 6px;
}

.row {
  display: flex;
  flex-direction: row;
  row-gap: 6px;
}

.img {
  width: 16px;
  height: 16px;
  margin: 0 6px 0 0;
}

.column {
  display: flex;
  flex-direction: column;
  column-gap: 60px;
}
</style>
