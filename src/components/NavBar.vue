<template>
  <b-navbar>
    <template #brand>
      <b-navbar-item>
        <img :src="config.header.logo.url" :alt="config.header.logo.alt" />
      </b-navbar-item>
    </template>
    <template #start>
      <div v-for="option in config.header.buttons" :key="option.label">
        <b-navbar-item v-on:click="action(option.label)">
          <b-icon :icon="option.icon"> </b-icon>{{ option.label }}
        </b-navbar-item>
      </div>
    </template>

    <template #end> </template>
  </b-navbar>
</template>

<script>
export default {
  data() {
    return {
      printFormat: 'PDF',
      printOptions: {
        "pageSize": "A4",
        "resolution": "DPI150",
        "orientation": "LANDSCAPE",
        "title": "Metabuilding",
        "footer": "Onesait Platform"
      }
    }
  },
  props: {
    config: {
      type: Object,
      required: true
    },
    viewer: {
      type: Object,
      required: true
    }
  },
  mounted() {
    this.logo = this.config.header.logo
  },
  methods: {
    action(name) {
      switch (name) {
        case 'Print':
          this.printMap()
          break

        default:
          break
      }
    },
    printMap() {
      this.viewer.exportMap(this.printFormat,this.printOptions)
    }
  }
}
</script>
<style>
.navbar-start {
  align-items: center !important;
}

.icon {
  margin-right: 6px !important;
}
</style>
