<template>
  <ClientOnly>
    <naive-config>
      <div>
        <div class="title">
          <div class="flag"></div>
          <div class="text">
            <pre class="cn">
苏溪镇
网格
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
          :center="{lng: 120.154778, lat: 29.417782}" :zoom="15" mapType="BMAP_HYBRID_MAP" :scroll-wheel-zoom="true">
          <bm-navigation anchor="BMAP_ANCHOR_TOP_RIGHT"></bm-navigation>

          <!-- <my-overlay :position="{lng: 120.154778, lat: 29.417782}" text="点击我11111111111111111111111111" :active="active"
        @mouseover.native="active = true" @mouseleave.native="active = false">
      </my-overlay> -->

          <bm-overlay pane="labelPane" :class="{sample: true, active}" @draw="draw" @mouseover="active = true"
            @mouseleave="active = false" @click="handlePopover">
            <img src="@/assets/icon-yellow.svg" />
            <div>南极星制衣支部</div>
          </bm-overlay>

          <bm-overlay pane="labelPane" :class="{sample: true, active}" @draw="draw2" @mouseover="active = true"
            @mouseleave="active = false" @click="handlePopover">
            <img src="@/assets/icon-yellow.svg" />
            <div>曲艺团支部</div>
          </bm-overlay>

          <!-- <bm-boundary name="浙江省金华市义务市苏溪镇" :strokeWeight="2" strokeColor="blue"></bm-boundary> -->
        </baidu-map>

        <img class="right-arrow" src="@/assets/right-arrow.svg" @click="toLeft">

        <n-popover :show="showPopover" :x="x" :y="y" trigger="manual" @keydown.esc="closePopover" tabindex="0">
          <div class="popover-container">
            <div class="header">
              <img class="logo" src="@/assets/icon.svg" />
              <div v-if="editable" class="tools">
                <input type="hidden" :value="editId"/>
  
                <div class="network">
                  <n-input v-model:value="editNetworkNum" type="text" placeholder="" />
                  个网格
                </div>
                <n-button type="info" @click="cancelEdit">取消修改</n-button>
                <n-button type="primary" @click="saveEdit">
                  保存修改
                </n-button>
              </div>
              <div class="text">{{editName}}</div>
            </div>
            <div class="body" style="max-width:800px;">
              <s-editor v-if="editable" v-model:content="content" />
              <div v-else v-html="content" class="el-tiptap-editor__content content2"></div>
            </div>
          </div>
        </n-popover>
      </div>
    </naive-config>
  </ClientOnly>
</template>

<script setup>
  // BMAP_NORMAL_MAP BMAP_SATELLITE_MAP BMAP_HYBRID_MAP
  import { ref } from 'vue'
  import { NPopover } from 'naive-ui'
  import { BaiduMap, BmNavigation, BmOverlay } from 'vue-baidu-map-3x'
  // import MyOverlay from '../components/my-overlay.vue'

  const active = ref(false);


  const showPopover = ref(false)
  const x = ref(0)
  const y = ref(0)

  const villages = ref({})

  const editable = ref(false)
  const editId = ref(0)
  const editNetworkNum = ref(0)
  const editName = ref("东青村")
  const editDesc = ref("")

  // const title = ref('东风社区')
  // const content = ref(`
  //     <div contenteditable="true" tabindex="0" translate="no" class="tiptap ProseMirror"><h1 style="text-align: center">网格力量“1+3+N”配备人员名单</h1><div class="tableWrapper"><table style="min-width: 649px;"><colgroup><col style="width: 87px;"><col style="width: 72px;"><col style="width: 90px;"><col style="width: 64px;"><col style="width: 90px;"><col style="width: 61px;"><col style="width: 92px;"><col style="width: 43px;"><col><col></colgroup><tbody><tr><th colspan="2" rowspan="1" colwidth="87,72"><h3>1</h3></th><th colspan="6" rowspan="1" colwidth="90,64,90,61,92,43"><h3>3</h3></th><th colspan="2" rowspan="1"><h3>N</h3></th></tr><tr><td colspan="2" rowspan="1" colwidth="87,72" style="background-color: null"><h3 style="text-align: center">网格长</h3></td><td colspan="2" rowspan="1" colwidth="90,64" style="background-color: null"><h3 style="text-align: center">网格员</h3></td><td colspan="2" rowspan="1" colwidth="90,61" style="background-color: null"><h3 style="text-align: center">兼职网格员</h3></td><td colspan="2" rowspan="1" colwidth="92,43" style="background-color: null"><h3 style="text-align: center">网格指导员</h3></td><td colspan="2" rowspan="1" style="background-color: null"><h3 style="text-align: center">其他包联人员</h3></td></tr><tr><td colspan="1" rowspan="1" colwidth="87" style="background-color: null"><p style="text-align: center">姓名</p></td><td colspan="1" rowspan="1" colwidth="72" style="background-color: null"><p style="text-align: center">身份</p></td><td colspan="1" rowspan="1" colwidth="90" style="background-color: null"><p style="text-align: center">姓名</p></td><td colspan="1" rowspan="1" colwidth="64" style="background-color: null"><p style="text-align: center">身份</p></td><td colspan="1" rowspan="1" colwidth="90" style="background-color: null"><p style="text-align: center">姓名</p></td><td colspan="1" rowspan="1" colwidth="61" style="background-color: null"><p style="text-align: center">身份</p></td><td colspan="1" rowspan="1" colwidth="92" style="background-color: null"><p style="text-align: center">姓名</p></td><td colspan="1" rowspan="1" colwidth="43" style="background-color: null"><p style="text-align: center">身份</p></td><td colspan="1" rowspan="1" style="background-color: null"><p style="text-align: center">姓名</p></td><td colspan="1" rowspan="1" style="background-color: null"><p style="text-align: center">身份</p></td></tr><tr><td colspan="1" rowspan="1" colwidth="87" style="background-color: null"><p style="text-align: center">楼正东</p><p style="text-align: center">13757901745</p></td><td colspan="1" rowspan="1" colwidth="72" style="background-color: null"><p style="text-align: center">村(社区)</p><p style="text-align: center">党组织书记</p></td><td colspan="1" rowspan="1" colwidth="90" style="background-color: null"><p style="text-align: center">何治军 13516845602</p></td><td colspan="1" rowspan="1" colwidth="64" style="background-color: null"><p style="text-align: center">村“两委”</p><p style="text-align: center">干部</p></td><td colspan="1" rowspan="1" colwidth="90" style="background-color: null"><p style="text-align: center">罗良菊 13676812006</p></td><td colspan="1" rowspan="1" colwidth="61" style="background-color: null"><p style="text-align: center">村“两委”</p><p style="text-align: center">干部</p></td><td colspan="1" rowspan="1" colwidth="92" style="background-color: null"><p style="text-align: center">王飞</p><p style="text-align: center">13429033238</p></td><td colspan="1" rowspan="1" colwidth="43" style="background-color: null"><p style="text-align: center">联村干部</p></td><td colspan="2" rowspan="1" style="background-color: null"><ul><li><p>城管: 吴东 15067052688</p></li><li><p>行政执法:叶湘照13777511101</p></li><li><p>卫生院: 何扬15058672691</p></li><li><p>交通执法:骆江舟13606891656</p></li><li><p>市场监管:金璐18858944066</p></li><li><p>交警: 朱志强13588679083</p></li><li><p>派出所: 孙今朝14757885791</p></li></ul></td></tr></tbody></table></div><p><br class="ProseMirror-trailingBreak"></p><h1 style="text-align: center">微网格设置情况</h1><div class="tableWrapper"><table style="min-width: 75px;"><colgroup><col><col><col></colgroup><tbody><tr><th colspan="1" rowspan="1"><h3>微网格</h3></th><th colspan="1" rowspan="1"><h3>微网格长</h3></th><th colspan="1" rowspan="1"><h3>微网格治理 团队</h3></th></tr><tr><td colspan="1" rowspan="1" style="background-color: null"><p style="text-align: center">东青1-1微网格</p></td><td colspan="1" rowspan="1" style="background-color: null"><p style="text-align: center">楼齐山 15957930430</p></td><td colspan="1" rowspan="1" style="background-color: null"><p style="text-align: center">楼成森、吕奇、俞庆远、蒋天勇</p></td></tr><tr><td colspan="1" rowspan="1" style="background-color: null"><p style="text-align: center">东青1-2微网格</p></td><td colspan="1" rowspan="1" style="background-color: null"><p style="text-align: center">罗良菊 13676812006</p></td><td colspan="1" rowspan="1" style="background-color: null"><p style="text-align: center">楼成森 、吕奇、俞庆远、蒋天勇</p></td></tr></tbody></table></div></div>
  //     `);
  const content = ref(`
  <h3>村社简介</h3>
  <p>东青村，面积1.2平方千米，现有户籍人口 726 人，常住人口 422 人，流动人口 30 人。村内特色产业为 种植生 姜 ，年集体收入为 50 万元。</p>
  <h3>村社党群服务中心简介</h3>
  <p>东青村党群服务中心位于 苏溪镇东青村51号 ，面积 300 平方米，设有 退伍军人服务中心、便民服务站、共享法庭、 社会矛盾纠纷调处化解站、会议室功能区块，年组织活动 44场，年参与活动1100人次。</p>
  <h3>党组织简介</h3>
  <p>东青村党支部， 三星级党组织，现有正式党员 29 人，预备党员1 人，流动党员 0 人。</p>
  `)


  const draw = ({ el, BMap, map }) => {
    const pixel = map.pointToOverlayPixel(new BMap.Point(120.12778, 29.417782))
    el.style.left = pixel.x - 60 + 'px'
    el.style.top = pixel.y - 20 + 'px'
  };

  const draw2 = ({ el, BMap, map }) => {
    const pixel = map.pointToOverlayPixel(new BMap.Point(120.164778, 29.427782))
    el.style.left = pixel.x - 60 + 'px'
    el.style.top = pixel.y - 20 + 'px'
  };

  const handlePopover = (e) => {
    showPopover.value = true
    x.value = e.clientX
    y.value = e.clientY
    e.stopPropagation()
  }

  function closePopover(e) {
    showPopover.value = false
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
    background: rgba(255, 255, 255, 0.4 );
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
    border-radius: 30px !important;
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
    font-size: 24px;
    font-weight: 900;
    color: #D5AB81;
    align-items: center;
    /* margin-bottom: 10px; */
    /* border-bottom: 2px solid #D5AB81; */
  }

  .popover-container .header .logo {
    width: 50px;
    height: 50px;
  }

  .popover-container .content2 h3 {
    font-size: 24px;
    font-weight: bold;
    padding: 16px 0;
  }

  .popover-container .content2 p {
    font-size: 14px;
    padding: 8px 0;
  }

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