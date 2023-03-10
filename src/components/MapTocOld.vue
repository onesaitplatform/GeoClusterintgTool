<template>
  <div id="toc" :class="['toc', !expanded && 'closed']">
    <!-- MAP CONTENTS -->
    <div v-if="expanded && show" class="tocContent">
      <template v-for="collapse in config.toc.content">
        <b-collapse
          :key="collapse.id"
          class="card"
          animation="slide"
          :open.sync="collapse.isOpen"
          @open="handleCollapse(collapse.id)"
        >
          <template #trigger="props">
            <div
              class="card-header"
              role="button"
              aria-controls="contentIdForA11y3"
              :aria-expanded="props.open"
            >
              <p class="card-header-title">{{ collapse.name }}</p>
              <a class="card-header-icon">
                <b-icon :icon="props.open ? 'menu-down' : 'menu-up'"> </b-icon>
              </a>
            </div>
          </template>

          <div class="card-content">
            <!-- LAYER GROUPS -->
            <template v-for="group in collapse.groups">
              <!-- EXPANDABLE LAYER GROUP -->
              <div :key="group.id">
                <div v-on:click="openLayerGroup(collapse.id, group.id)">
                  <b-icon
                    :icon="
                      group.isOpen ? 'minus-box-outline' : 'plus-box-outline'
                    "
                    size="is-small"
                  />
                  <span>{{ group.name }}</span>
                </div>

                <b-collapse :open="group.isOpen" aria-id="contentIdForA11y1">
                  <div class="content column">
                    <template v-for="layer in group.layers">
                      <section :key="layer.id">
                        <div class="row">
                          <img :src="icons.layer" class="img" />
                          <b-field>
                            <b-radio
                              v-model="selectedLayer"
                              size="is-small"
                              :native-value="layer.id"
                            >
                              {{ layer.name }}
                            </b-radio>
                          </b-field>
                        </div>
                      </section>
                    </template>
                  </div>
                </b-collapse>
              </div>
            </template>
          </div>
        </b-collapse>
      </template>
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
export default {
  data() {
    return {
      expanded: true,
      show: true,
      label: false,
      selectedLayer: null,
      icons: {
        layer:
          "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsQAAA7EAZUrDhsAAAL/SURBVDhPVZPNbxtVFMV/773x58RObGJSt6VUatSQFolGZYmQECxASAgJIf4FlmzY8wewZ8uim4oNy7ABgZDKJogoLSQKIQGUxCSO3fgj4xl75nEmZcOMRnPnvXfvuefcM+abnZ6PM7AeykVLnGakM5grWyazjFkK1ZJlqniq9ZLOGCAwnuVmGVuwsLxYJ/Uhj0+KzGYhC2HIxlGRRPFz4RybivuR4lrIQb9MPC0zimZcJDNsKoQ4dWAM7TDAOiFPLdfqAc5YxrHhquKqkMexpVlxNEKnPUOWZdjJNOPoPGUiGitLjiTzHDz13LvqSNXm3tOMl9uOSsHzRx+uN6BdMzhhijU2532zaVkow/ZpKu5w5wr8fJhSLsA9JW8epwiHV9oIDP4c6Ft6iP2lduJvsFImUNV8MReppGSnxUx3ORCiVlMdzpEDKyH/O2gTle6MU+kgMZsOic2hUO608tjzV9+wuhSwtBBwMXO81Aqkj1ORZxTM+nbPtxoNBtH0MllguACiRGPVe65SYH3rgKj4E3F2Ti0o0+Q12pUGay9ojHkrYeApqK2xeAWaa63oGE+NaBh+3NkjYqz5ezIzx5PBEVvRA349e0z/wmOnM8/pxBOL6w21lmo0nWEqOkYHItZ/7/Lm3UXeuVtn7UaVW+0ZcfWY3ybfsdPfwlrNM5BYBb1zTs66S9EiGeTR7iGvrtxmnLTo8jVR+Utq84/Y77zBIIjZG21ic+WfD8VVrR+Pno3u2rxj/8yzc3JOqT5k429LJzliaiN6o5qMtsTpYI397nWsGHA2kRsl4ItKzEd1Im63F50K1XjS22DrBFl4TiIbdjtvkUwK9Hst4ski7sOPP/3MB0XZMqVeMgxVKX+uhPqxlPDVRoJxRgZapTvyLFS3SYM9kshxv9HEPPzlxEeU9NdJZaHnJspNlXpLVXS++GFT3Oe1F5D0l3n73feYL5yzu/kB79/8CNPv/uOHg6Gclaf+/7oUWKb4/Nstvu9XiH1F3x1Wiy0+ef0W91cW+Re5LU97iP6u7QAAAABJRU5ErkJggg==",
        disabledLayer:
          "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsQAAA7EAZUrDhsAAAIISURBVDhPPZLJqjJBDIXT7SyKM46IiBtREPEpfF1XvsBdioIuFDeKE6Ki4jz2/3/h9g0UlapKTk5Oyuj1etb7/RbDMMTlcsnn8xHOPp9PXq+Xnj0ej96x3G63xrJSqZSYDodDHcuyZLlcakIgEJDpdKp+MBiU2Wwmt9tNQqGQ7HY7Beb8eDzEJOj7/SpiOBwWAAmIRqN6R1AkElEW9/tdwVm8kWc+n09FhV46ndaqnPP5vAZtt1vJ5XLaHj5gdiFYm/SUTCbF7/fLarUSr9erCZPJRJMAms/nWo374/H4V5ACpvw3qnJwOp26g0yyTZN7TBNMU6vjYyb9nk4n7TuRSCjyfr+XTCajQLaPJrSbzWbVt1swut2uRV+oaotJRYLZGWen09EzRRATEZlIsViEkal920lQ52wDDAaDv/lj6/VaNVksFnI+n8XkEYcdJuhxOBy0ncvlIv1+X2q1mtTrdSmVSjopDMEBMaFsi4PRGyxgMBwOpVwuK3WK0CZMmASFYKMtMFd65YEARGJUUGW8/ETeMFjBlk9FjImSdgvxeFyRmQrfOxaLaTJABCMyuz05cnSM1+tVKcOGnTNMCoWCjEYjHSUfazweKyPY2syNn58fi6os/Zq/WuAD0m63VRcM8Gq1qhrBrNFoiLHZbCzokKgf4/eHYba4rVZLFacFDI2azaZUKhX5B7wQgs/Z0tkNAAAAAElFTkSuQmCC",
      },
    };
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
  },
  watch: {
    expanded: function (value) {
      if (value) {
        this.name = false;
        setTimeout(() => {
          this.show = true;
        }, 450);
      } else {
        this.show = false;
        setTimeout(() => {
          this.name = true;
          this.viewer.updateMapsSize()
        }, 450);
      }
    },
    selectedLayer: function (layerId) {
      this.$emit('onClick', layerId)
    },
  },
  methods: {
    handleCollapse(id) {
      /** Close all collapsables except the current opened one */
      this.config.toc.content
        .filter((x) => x.id !== id)
        .forEach((elem) => {
          elem.isOpen = false;
        });
    },
    openLayerGroup(collapseId, layerId) {
      const group = this.config.toc.content
        .find((x) => x.id === collapseId)
        .groups.find((y) => y.id === layerId);
      group.isOpen = !group.isOpen;
    },
  },
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
  height: 100%;
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
