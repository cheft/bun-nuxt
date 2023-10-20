<template>
  <ClientOnly>
    <naive-config>
      <div>
        <div class="title">
          <div class="flag"></div>
          <div class="text">
            <pre class="cn">
  苏溪镇
  党组织
  分布图</pre>
            <!-- <pre class="cn">苏溪镇
      党建统领网格智治
      示意图</pre> -->
            <!-- <pre class="en">Suxi
      Party Building Leads
      Grid Governance
      Schematic Diagram</pre> -->
          </div>
        </div>
        <baidu-map class="map" ak="jvGhUbUTMYNeHrwvq6mKV2xTjKZp3Hda" v="3.0" type="API" @click="closePopover"
          @touchend="closePopover" :center="{lng: 120.137897, lat: 29.41603}" :zoom="15" mapType="BMAP_HYBRID_MAP"
          :scroll-wheel-zoom="true">
          <bm-navigation anchor="BMAP_ANCHOR_TOP_RIGHT"></bm-navigation>

          <bm-overlay v-for="v in data" :id="v.name" pane="labelPane" :class="{sample: true, active}"
            @draw="(e) => { draw(e, v) }" @mouseover="active = true" @mouseleave="active = false"
            @click="(e) => {handlePopover(e, v)}" @touchend="(e) => {handlePopover(e, v)}">
            <img src="@/assets/icon-yellow.svg" />
            <div>{{v.name}}</div>
          </bm-overlay>

          <!-- <bm-boundary name="浙江省金华市义务市苏溪镇" :strokeWeight="2" strokeColor="blue"></bm-boundary> -->
        </baidu-map>

        <img class="right-arrow" src="@/assets/right-arrow.svg" @click="toLeft">

        <n-popover :show="showPopover" :x="x" :y="y" trigger="manual" @keydown.esc="closePopover" tabindex="0">
          <div class="popover-container">
            <div class="header">
              <img class="logo" src="@/assets/icon.svg" />
              <div v-if="editable" class="tools">
                <input type="hidden" :value="editId" />

                <!-- <div class="network">
                    经度
                    <n-input v-model:value="" type="text" placeholder="" />
                    纬度
                    <n-input v-model:value="" type="text" placeholder="" />
                  </div> -->
                <n-button type="info" @click="cancelEdit">取消修改</n-button>
                <n-button type="primary" @click="saveEdit">
                  保存修改
                </n-button>
              </div>
              <div class="text">{{editRegin}} —— {{editName}}</div>
            </div>
            <div class="body" style="max-width:800px;">
              <s-editor name="content2" v-if="editable" v-model:content="content" />
              <div v-else v-html="content" class="el-tiptap-editor__content content2"></div>
            </div>
          </div>
        </n-popover>
      </div>
    </naive-config>
  </ClientOnly>
</template>

<script setup>
  // https://api.map.baidu.com/lbsapi/getpoint/index.html 地图坐标拾取
  // BMAP_NORMAL_MAP BMAP_SATELLITE_MAP BMAP_HYBRID_MAP
  import { ref } from 'vue'
  import { NPopover } from 'naive-ui'
  import { BaiduMap, BmNavigation, BmOverlay } from 'vue-baidu-map-3x'
  const { data, refresh } = await useFetch('/api/villagemark')
  const { isView } = defineProps(['isView'])
  const active = ref(false);

  const showPopover = ref(false)
  const x = ref(0)
  const y = ref(0)

  const editable = ref(false)
  const editId = ref(0)
  const editName = ref("")
  const editRegin = ref("")
  const editLng = ref("")
  const editLat = ref("")
  const content = ref('')

  useHead({
    title: '苏溪镇党组织分布图',
    meta: [{
      name: 'viewport',
      content: 'width=device-width, initial-scale=0.5,user-scalable=yes,maximum-scale=4',
    }]
  })

  const draw = (e, v) => {
    const { el, BMap, map } = e;
    const pixel = map.pointToOverlayPixel(new BMap.Point(v.lng, v.lat))
    el.style.left = pixel.x - 60 + 'px'
    el.style.top = pixel.y - 20 + 'px'
  };

  const handlePopover = (e, v) => {
    // console.log(v, 111)
    showPopover.value = true
    if (v.desc) {
      content.value = v.desc
    }
    if (!isView) {
      editable.value = true
    }
    editId.value = v.id
    editName.value = v.name
    editRegin.value = v.region
    editLng.value = v.lng
    editLat.value = v.lat

    if (e.clientX) {
      x.value = e.clientX
      y.value = e.clientY
    } else if (e.changedTouches && e.changedTouches[0]) {
      x.value = e.changedTouches[0].clientX
      y.value = e.changedTouches[0].clientY
    }

    e.stopPropagation()
  }

  function closePopover(e) {
    showPopover.value = false
  }

  function cancelEdit() {
    editable.value = false
  }

  async function saveEdit() {
    const formData = {
      id: editId.value,
      lng: editLng.value,
      lat: editLat.value,
      name: editName.value,
      region: editRegin.value,
      desc: content.value
    }
    console.log(formData, 1111)

    await $fetch('/api/villagemark', {
      method: 'POST',
      body: formData
    });

    editable.value = false
    await refresh()
  }


  const toLeft = () => {
    return navigateTo('/grid')
  }
</script>

<style>
  body {
    margin: 0;
    overflow: hidden;
    min-height: 100vh;
  }

  .title {
    position: absolute;
    top: 50px;
    left: 0;
    display: flex;
    z-index: 1;
    background: rgba(255, 255, 255, 0.4);
    backdrop-filter: blur(6px);
    padding: 10px 30px 10px 0;
  }

  .title .flag {
    width: 50px;
    height: 120px;
    background: #B71C24;
  }

  .title .cn {
    font-family: -apple-system, BlinkMacSystemFont, "PingFang SC", "Helvetica Neue", STHeiti, "Microsoft Yahei", Tahoma, Simsun, sans-serif;
    margin: 0 0 0 20px;
    color: #B71C24;
    font-size: 36px;
    line-height: 40px;
    font-weight: 900;
  }

  .title .en {
    margin: 20px 0 0 20px;
    font-size: 24px;
    font-weight: 900;
  }

  .map {
    width: 100%;
    height: 100vh;
  }

  .sample {
    position: absolute;
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 4px;
    cursor: auto;
  }


  .sample div {
    width: 120px;
    height: 26px;
    line-height: 26px;
    background: rgba(231, 51, 35, 0.9);
    color: #fff;
    font-size: 14px;
    font-weight: bold;
    text-align: center;
  }

  .sample.active div {
    background: rgba(231, 51, 35, 1);
  }

  .sample img {
    width: 16px;
    height: 16px;
  }


  .right-arrow {
    position: absolute;
    cursor: pointer;
    width: 50px;
    height: 50px;
    right: 50px;
    bottom: 50px;
    z-index: 1;
  }


  .n-popover-arrow {
    background: #B71C24 !important;
  }

  .n-popover {
    background: #B71C24 !important;
    border-radius: 20px !important;
    color: #ffffff;
    --n-space-arrow: 20px !important;
    --n-arrow-height: 20px !important;
  }

  .popover-container {
    padding: 10px 20px 20px 20px;
  }

  .popover-container .tools {
    display: flex;
    gap: 10px;
  }

  .popover-container .header {
    display: flex;
    justify-content: space-between;
    font-size: 36px;
    font-weight: bold;
    color: #D5AB81;
    align-items: baseline;
    padding-bottom: 20px;
    margin-bottom: 20px;
    border-bottom: 2px solid #D5AB81;
  }

  .popover-container .header .logo {
    width: 50px;
    height: 50px;
  }

  .popover-container .content2 h3 {
    font-size: 20px !important;
    font-weight: bold !important;
    padding-top: 16px !important;
  }

  /* .popover-container .body h3 {
    font-size: 20px;
    font-weight: bold;
    padding-top: 16px;
  } */

  .popover-container .content2 p {
    font-size: 16px !important;
    padding: 8px 0 !important;
  }

  /* .popover-container .body p {
    font-size: 16px;
    padding: 8px 0;
  } */

  .popover-container .content2 {
    max-width: 680px;
    height: 360px;
    overflow: auto;
  }

  .popover-container .network {
    font-size: 13px;
    display: flex;
    align-items: center;
  }

  .popover-container .network .n-input {
    width: 60px;
  }
</style>