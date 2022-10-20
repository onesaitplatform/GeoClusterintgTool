<template>
  <div class="footer">
    <!-- LEFT SIDE -->
    <div class="left" v-if="config.footer.left">
      <template v-for="option in config.footer.left">
        <div v-if="option.icon" :key="option.id">
          <b-image :src="option.icon" :responsive="true"></b-image>
        </div>
      </template>
    </div>

    <!-- CENTERED -->
    <div class="center">
      <template v-for="option in config.footer.center">
        <div class="row" :key="option.id">
          <span v-if="option.text">{{ option.text }}</span>
          <b-image
            v-if="option.icon"
            :src="option.icon"
            :responsive="true"
          ></b-image>
        </div>
      </template>
    </div>

    <!-- RIGHT SIDE -->
    <div class="right" v-if="config.footer.right">
      <template v-for="option in config.footer.right">
        <div :key="option.id">
          <span v-if="option.text">{{ option.text }}</span>
          <b-image v-if="option.icon" :src="option.icon" :responsive="true" />
        </div>
      </template>
    </div>
  </div>
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
    }
  }
}
</script>

<style scoped>
.footer {
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  background-color: black;
  color: aliceblue;
  padding: 8px;
}

.left {
  display: flex;
  flex-direction: row;
  column-gap: 3px;
}

.right {
  display: flex;
  flex-direction: row;
  column-gap: 3px;
  font-weight: bold;
}

.row {
  display: flex;
  flex-direction: row;
  column-gap: 10px;
}
</style>
