<template>
  <div id="toc" :class="['toc', !expanded && 'closed']">
    <!-- MAP CONTENTS -->
    <div v-if="expanded && show" class="tocContent">
      <!-- MAP TITLE -->
      <div class="mapName">{{ mapName }}</div>

      <!-- TOC CONTENT -->
      <div v-if="dataLoaded && services.length > 0" class="layersContainer">
        <!-- LOAD GROUPS -->
        <div v-for="group in services" :key="group.id" class="layersGroup">
          <!-- GROUP NAME -->
          <div class="layerGroupName">{{ group.name }}</div>

          <!-- LOAD LAYERS -->
          <div
            v-for="layer in group.layers"
            :key="layer.id"
            class="layerContainer"
          >
            <div class="layerGroupItems">
              <!-- LAYER -->
              <div class="layerGroupItems">
                <!-- LAYER VISIBILITY -->
                <div
                  class="layerVisibility"
                  @click="handleVisibility(layer.id, layer.name)"
                >
                  <b-icon
                    :icon="layer.show ? 'eye-outline' : 'eye-off-outline'"
                    size="is-small"
                  >
                  </b-icon>
                </div>

                <!-- SERVICE NAME -->
                <div class="layerName">{{ layer.name }}</div>
              </div>

              <!-- LAYER ICONS -->
              <div class="layerIcons">
                <div
                  class="layerSymbology"
                  @click="handleSymbology(layer.id, layer.name)"
                >
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

                <!-- SERVICE OPTIONS -->
                <div class="layerOptions">
                  <b-dropdown
                    aria-role="list"
                    class="is-pulled-right"
                    position="is-bottom-left"
                  >
                    <template #trigger>
                      <b-icon icon="dots-vertical"></b-icon>
                    </template>
                    <b-dropdown-item
                      aria-role="listitem"
                      @click="filterLayer(layer.id, layer.name)"
                      >Filter layer</b-dropdown-item
                    >
                    <!-- <b-dropdown-item aria-role="listitem">Action 2</b-dropdown-item>
                <b-dropdown-item aria-role="listitem">Action 3</b-dropdown-item> -->
                  </b-dropdown>
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
// import PubSub from 'os-map-library/build/main/OSModule/Utils/PubSub'

export default {
  data() {
    return {
      dataLoaded: false,
      map: null,
      mapName: null,
      services: [],
      url: 'https://development.onesaitplatform.com/geoserver/metabuilding_geocluster/wms',
      url2: 'https://development.onesaitplatform.com/geoserver/rest/workspaces/metabuilding_geocluster/datastores/Onesait+Platform+Development+PostGIS/featuretypes/',
      expanded: true,
      show: true,
      label: false,
      showTest: false,
      showFilter: false,
      formProps: ['uno', 'dos'],
      texts: {
        tooltips: {
          showLegend: 'Show legend',
          hideLegend: 'Hide legend'
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
    }
  },
  methods: {
    async handleVisibility(id, name, filter) {
      /** Find the service */
      let service = null

      this.services.forEach(serv => {
        const find = serv.layers.find(x => x.id === id)
        if (find) service = find
      })

      if (!service.service) {
        const wmsService = await this.loadWmsService(id, name, filter)
        service.service = wmsService[0]
        service.legend = wmsService[1]
        service.show = true
      } else {
        service.service.setVisible(!service.service.isVisible())
        service.show = !service.show
      }

    },
    async handleSymbology(id, name) {
      let service = null

      this.services.forEach(serv => {
        const find = serv.layers.find(x => x.id === id)
        if (find) service = find
      })

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
      wmsMap.set(id, null)

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

      // this.openModal(availableFilters)

    },
    sendFilter(id, filter) {
      /** Find the service */
      let service = null

      this.services.forEach(serv => {
        const find = serv.layers.find(x => x.id === id)
        if (find) service = find
      })

      if (!service) return

      let viewparamFilter = ''

      filter.forEach(param => {
        viewparamFilter += param.name + ':' + param.value + ';'
      })

      service.service.addFilter('viewparams', viewparamFilter)

    },
    openModal() {

      // this.showFilter = true

      // const filterValues = {

      // }

      // let htmlCode = ''

      // availableFilters.forEach(filter => {
      //   const filterName = filter.name
      //   filterValues[filterName] = {}
      //   filterValues[filterName].defaultValue = filter.defaultValue
      //   filterValues[filterName].currentValue = filter.currentValue

      //   const newBField = document.createElement("b-field")
      //   const newBInput = document.createElement("b-input")
      //   newBField.appendChild(newBInput)

      //   htmlCode = htmlCode + new XMLSerializer().serializeToString(newBField)

      // })



      // const htmlCode = newBField.toString()

      // `<div><b-field label="Name1"><b-input v-model="name1"></b-input></b-field></div><div><b-field label="Name2"><b-input v-model="name2"></b-input></b-field></div>`

      // this.$buefy.dialog.prompt({
      //   title: 'Add filter to the layer',
      //   message: htmlCode,
      //   // inputAttrs: {
      //   //   placeholder: 'e.g. Walter 1',
      //   //   maxlength: 10
      //   // },
      //   trapFocus: true,
      //   onConfirm: (value) => this.$buefy.toast.open(`Your name is: ${value}`)
      // })

      this.$buefy.dialog.prompt({
        message: `Layer filter parameters`,
        inputAttrs: {
          placeholder: 'e.g. Walter 1',
          maxlength: 10
        },
        trapFocus: true,
        onConfirm: (value) => this.$buefy.toast.open(`Your name is: ${value}`)
      })
    }
  },
  async mounted() {
    /** Get the map and it name */
    this.map = await this.viewer.getListOfMaps()[0]
    this.mapName = await this.viewer.getListOfMaps()[0].getName()


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
          legend: null
        })
      })

      this.services.push(obj)
    })

    this.dataLoaded = true

    // /** Wait until all services are loaded */
    // PubSub.subscribe('finishLoadServices', this.servicesLoaded.bind(this))

  }
};
</script>

<style scoped>
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
  max-height: 90vh;
}

.mapName {
  color: #001927;
  font-weight: lighter;
  font-size: large;
  padding: 6px 0 6px 12px;
  background-color: #f0f1f2;
  margin-bottom: 6px;
}

.layerGroup {
  display: flex;
  flex-direction: column;
  padding: 6px 0 24px 12px;
}

.layerGroupName {
  display: flex;
  font-weight: bold;
}

.layerContainer {
  display: flex;
  flex-direction: column;
}

.layerGroupItems {
  display: flex;
  flex-direction: row;
  justify-content: space-between;
}

.layerIcons {
  display: flex;
  flex-direction: row;
  justify-content: flex-end;
}

.layersContainer {
  color: #001927;
  padding: 6px 0 6px 12px;
  overflow-y: scroll;
}

.layersGroup {
  margin-bottom: 10px;
}

.legend {
  display: flex;
  margin-top: 10px;
  margin-left: 25px;
  margin-bottom: 10px;
}

.slot {
  display: flex;
  justify-content: space-between;
}

.margin-bottom {
  margin-bottom: 12px;
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
