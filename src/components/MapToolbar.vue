<template>
  <div class="container">
    <div v-for="button in buttonsList" :key="button">
        <span>"BUTTON"</span>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      buttonsList: ['identify']
    }
  },
  props: {
    viewer: {
      type: Object,
      required: true,
    }
  }
}
</script>

<style scoped>
.container {
  display: flex;
  flex-direction: column;
  row-gap: 4px;
}
</style>