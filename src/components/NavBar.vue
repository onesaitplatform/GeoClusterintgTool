<template>
  <b-navbar>
    <template #brand>
      <b-navbar-item>
        <img :src="config.header.logo.url" :alt="config.header.logo.alt" />
      </b-navbar-item>
    </template>
    <template #start>
      <div v-for="option in config.header.buttons" :key="option.label">
        <b-navbar-item href="#">
          <b-icon :icon="option.icon"> </b-icon>{{ option.label }}
        </b-navbar-item>
      </div>
    </template>

    <template #end>
      <b-navbar-item tag="div">
        <div class="buttons">
          <a class="button is-primary">
            <strong>Sign up</strong>
          </a>
          <a class="button is-light"> Log in </a>
        </div>
      </b-navbar-item>
    </template>
  </b-navbar>
</template>
<script>
export default {
  data() {
    return {}
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
  watch: {
    config: function (val) {
      console.log('cambia', val)
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
