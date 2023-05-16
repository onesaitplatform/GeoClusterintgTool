<template>
  <div id="sidebar" :class="['sidebar', !expanded && 'closed']">
    <!-- MAP CONTENTS -->
    <div v-if="expanded && show" class="sidebarContent">
      <!-- LEGEND SLOT -->
      <div class="infoSlot">
        <!-- LEGEND TITLE -->
        <div class="slotTitle">{{ legendSlotTitle }}</div>

        <!-- INFO TEXT IF NO LAYER HAS BEEN SELECTED -->
        <div v-if="!legendUrl && !firstSelection">
          {{ selectLegendMsg }}
        </div>

        <!-- INFO WITH THE LAYER NAME AND THE LEGEND ITSELF -->
        <div v-else class="column">
          <span class="legendTitle">{{ legendTitle }}</span>
          <img class="legendImage" :src="legendUrl" />
        </div>
      </div>

      <div class="infoSlot">
        <!-- FILTERS TITLE -->
        <div class="slotTitle">{{ filterSlotTitle }}</div>

        <!-- INFO TEXT IF NO LAYER HAS BEEN SELECTED -->
        <div v-if="!legendUrl && !firstSelection">{{ selectFilterMsg }}</div>

        <!-- INFO TEXT IF THE LAYER HAS NO SQL PARAMETERS TO FILTER -->
        <div v-else-if="legendUrl && availableFilters.length === 0">
          {{ noFiltersMsg }}
        </div>

        <!-- FILTER INPUTS FOR THE LAYER -->
        <div v-else-if="legendUrl && availableFilters.length > 0">
          <div
            class="row"
            v-for="filter in availableFilters"
            :key="filter.name"
          >
            <div class="leftSide">
              <span class="paramName">{{ filter.name }}</span>
            </div>
            <div class="rightSide">
              <input type="number" v-model="filter.currentValue" size="8" />
            </div>
          </div>

          <b-button
            class="filterButton"
            type="is-primary"
            size="is-small"
            @click="sendFilter(availableFilters)"
            >{{ filterbuttonMsg }}</b-button
          >
        </div>
      </div>
    </div>

    <!-- TOC LABEL WHEN COLLAPSED -->
    <div v-if="!expanded && label"></div>

    <!-- SHOW/COLLAPSE TOC -->
    <span class="sidebarButton" @click="expanded = !expanded">
      <b-icon
        :icon="expanded ? 'chevron-double-right' : 'chevron-double-left'"
      />
    </span>
  </div>
</template>

<script>
export default {
  data() {
    return {
      expanded: true,
      show: true,
      label: false,
      firstSelection: false,
      wmsService: null,
      layerName: null,
      legendUrl: null,
      legendTitle: null,
      legendSlotTitle: 'Legend',
      filterSlotTitle: 'Applied Filters',
      selectFilterMsg: 'Please, select a layer to enable filters',
      noFiltersMsg: 'No filters available for this layer',
      selectLegendMsg: 'Please, select a layer to show it legend',
      filterbuttonMsg: 'Filter',
      availableFilters: [],
      paramsUrl: 'http://localhost:8083/geoserver/rest/workspaces/metabuilding_geocluster/datastores/Onesait+Platform+Development+PostGIS/featuretypes/'
    }
  },
  props: {
    config: {
      type: Object,
      required: true,
    },
    viewer: {
      type: Object,
      required: true,
    },
    service: {
      required: true
    },
    layerId: {
      required: true
    },
    legend: {
      required: true
    },
    title: {
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
    },
    layerId: async function (name) {
      if (!name) return

      if (!this.firstSelection) {
        this.firstSelection = true
      }

      this.layerName = name
      this.availableFilters.length = 0

      await fetch(this.paramsUrl + name + '.json')
        .then((response) => response.json())
        .then((data) => {

          console.log("DATAAA", data)

          if (!Array.isArray(data.featureType.metadata.entry)) return

          data.featureType.metadata.entry.forEach(val => {
            if (val['@key'] && val['@key'] === 'JDBC_VIRTUAL_TABLE') {
              const virtualTable = val.virtualTable

              if (!virtualTable.parameter) return

              virtualTable.parameter.forEach(param => {
                param.currentValue = param.defaultValue
                this.availableFilters.push(param)
              })
            }

          })
        })
    },
    service: function (wmsService) {
      this.wmsService = wmsService
    },
    legend: function (url) {
      this.legendUrl = url
    },
    title: function (string) {
      this.legendTitle = string
    }
  },
  methods: {
    sendFilter(filter) {

      let viewparamFilter = ''

      filter.forEach(param => {
        viewparamFilter += param.name + ':' + param.currentValue + ';'
      })

      this.wmsService.addFilter('viewparams', viewparamFilter)
    }
  },
};
</script>

<style scoped>
.sidebar {
  display: flex;
  flex-direction: column;
  flex: 0 1 auto;
  justify-content: space-between;
  min-width: 350px;
  max-width: 350px;
  width: auto;
  height: 100%;
  background-color: white;
  transition: width 0.4s, min-width 0.4s;
}

.sidebar span {
  margin-top: auto;
}

.closed {
  width: 42px;
  min-width: 42px;
}

.sidebarButton {
  display: flex;
  justify-content: flex-end;
  margin-bottom: 6px;
}

.sidebarContent {
  display: flex;
  flex-direction: column;
  justify-content: space-around;
}

.card-content {
  padding: 6px;
}

.row {
  display: flex;
  flex-direction: row;
  row-gap: 6px;
}

.column {
  display: flex;
  flex-direction: column;
}

.img {
  width: 16px;
  height: 16px;
  margin: 0 6px 0 0;
}

.column {
  display: flex;
  flex-direction: column;
  flex-grow: inherit;
  /* column-gap: 60px; */
}

.infoSlot {
  height: 45vh;
  display: flex;
  flex-direction: column;
  column-gap: 60px;
  padding: 12px;
}

.slotTitle {
  font-weight: bold;
  font-size: large;
}

.legendTitle {
  font-weight: bold;
  font-size: large;
  font-style: italic;
  margin-bottom: 10px;
}

.legendName {
  font-weight: bold;
  font-size: medium;
}

.legendImage {
  width: fit-content;
}

.leftSide {
  float: left;
  width: 50%;
}

.rightSide {
  float: right;
  width: 50%;
}

.filterButton {
  margin-top: 20px;
}
</style>
