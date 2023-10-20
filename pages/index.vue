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

          <bm-overlay v-for="v in villages" :id="v.name" pane="labelPane" :class="{sample: true, active}"
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

                <div class="network">
                  <n-input v-model:value="editNetworkNum" type="text" placeholder="" />
                  个网格
                </div>
                <n-button type="info" @click="cancelEdit">取消修改</n-button>
                <n-button type="primary" @click="saveEdit">
                  保存修改
                </n-button>
              </div>
              <div class="text">江南共建委 —— {{editName}}</div>
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
  // https://api.map.baidu.com/lbsapi/getpoint/index.html 地图坐标拾取
  // BMAP_NORMAL_MAP BMAP_SATELLITE_MAP BMAP_HYBRID_MAP
  import { ref } from 'vue'
  import { NPopover } from 'naive-ui'
  import { BaiduMap, BmNavigation, BmOverlay } from 'vue-baidu-map-3x'

  const active = ref(false);


  const showPopover = ref(false)
  const x = ref(0)
  const y = ref(0)

  const villages = ref([
    // content: '<h3>村社简介</h3><p></p><h3>村社党群服务中心简介</h3><p></p><h3>党组织简介</h3><p></p>'
    { name: '东风社区', region: '社区', lng: 120.143406, lat: 29.413794 },
    { name: '十合里社区', region: '社区', lng: 120.153176, lat: 29.402931, content: '<h3>村社简介</h3><p>十和里社区，面积1.8平方千米，现有户籍人口5617人，常住人口6500人，流动人口8500人。村（社区）内特色产业为/，年集体收入为/万元。</p><h3>村社党群服务中心简介</h3><p>十和里社区党群服务中心位于苏溪镇阳光大道M18号，面积        1400平方米，设有共享法庭、退役军人服务站、青年之家、民事议事堂等功能区块，年组织活动100场，年参与活动3100人次。</p><h3>党组织简介</h3><p>十和里社区党委，四星级党组织，下辖8个支部（党总支、社区党委填写即可），现有正式党员157人，预备党员2人，流动党员103人。</p>' },
    { name: '胡宅社区', region: '社区', lng: 120.13233, lat: 29.420724, content: '<h3>村社简介</h3><p>胡宅   村（社区），面积  2.1  平方千米，现有户籍人口  3600 人，常住人口  26000余 人，流动人口 23000余 人。村（社区）内特色产业为    ，年集体收入为    万元。</p><h3>村社党群服务中心简介</h3><p>胡宅  村（社区）党群服务中心位于 苏溪镇人民路70号 ，面积  350  平方米，设有  党员教育功能区、服务群众功能区、会议培训功能区、图书阅览功能区  功能区块，年组织活动 30 场，年参与活动  1500余 人次。</p><h3>党组织简介</h3><p>胡宅社区   支部/总支/党委，  四  星级党组织，下辖  9  个支部（党总支、社区党委填写即可），现有正式党员  239  人，预备党员  6  人，流动党员  138  人。</p>' },
    { name: '龙祈社区', region: '社区', lng: 120.139202, lat: 29.406828, content: '<h3>村社简介</h3><p>龙祈   社区，面积  1.33  平方千米，现有户籍人口2094       人，常住人口 15704  人，流动人口  12080  人。社区内特色产业为  酒店旅游  ，年集体收入为   0   万元。</p><h3>村社党群服务中心简介</h3><p>龙祈   社区党群服务中心位于   苏溪镇杨梅岗小区内    ，面积  1000  平方米，设有 妇女儿童驿站、老年学堂、便民服务站等 功能区块，年组织活动  31   场，年参与活动  1300  人次。</p><h3>党组织简介</h3><p>龙祈社区    支部/总支/党委，  三  星级党组织，下辖 6  个支部（党总支、社区党委填写即可），现有正式党员   123  人，预备党员  1  人，流动党员  136  人。</p>' },
    { name: '苏福社区', region: '社区', lng: 120.140288, lat: 29.396127, content: '<h3>村社简介</h3><p>苏福 社区，面积 2.5 平方千米，现有户籍人口 1418 人，常住人口 11212 人，流动人口 9794 人。社区内特色产业为      ，年集体收入为         万元。</p><h3>村社党群服务中心简介</h3><p>苏福 社区党群服务中心位于苏福社区居民委员会，面积        300平方米，设有  服务群众、会议培训  功能区块，年组织活动31场，年参与活动 900 人次。</p><h3>党组织简介</h3><p>苏福社区支部/总支/党委，五星级党组织，下辖 6 个支部（党总支、社区党委填写即可），现有正式党员113人，预备党员 2 人，流动党员 89 人。</p>' },

    { name: '三联村', region: '巧溪共建委', lng: 120.157532, lat: 29.430803 },
    { name: '上山下村', region: '巧溪共建委', lng: 120.184865, lat: 29.407075 },
    { name: '下屋村', region: '巧溪共建委', lng: 120.170964, lat: 29.41789 },
    { name: '六都村', region: '巧溪共建委', lng: 120.153887, lat: 29.413972 },
    { name: '同裕村', region: '巧溪共建委', lng: 120.174531, lat: 29.438945 },
    { name: '殿下村', region: '巧溪共建委', lng: 120.162318, lat: 29.414793 },
    { name: '溪北村', region: '巧溪共建委', lng: 120.16968, lat: 29.421157, content: '<h3>村社简介</h3><p>溪北  村（社区），面积 1.3 平方千米，现有户籍人口 1383 人，常住人口   1800 人，流动人口   700  人。村（社区）内特色产业为  无   ，年集体收入为   60   万元。</p><h3>村社党群服务中心简介</h3><p>溪北  村（社区）党群服务中心位于    溪北村     ，面积  200  平方米，设有 会议室 功能区块，年组织活动 20余   场，年参与活动 2000 人次。</p><h3>党组织简介</h3><p>溪北村  党委， 三 星级党组织，下辖 2 个支部（党总支、社区党委填写即可），现有正式党员 71 人，预备党员 0 人，流动党员 6 人。</p>' },
    { name: '翁界村', region: '巧溪共建委', lng: 120.182712, lat: 29.422483 },
    { name: '联合村', region: '巧溪共建委', lng: 120.159893, lat: 29.440348 },
    { name: '花厅村', region: '巧溪共建委', lng: 120.161028, lat: 29.42145 },
    { name: '范家村', region: '巧溪共建委', lng: 120.185959, lat: 29.399406 },
    { name: '齐山楼村', region: '巧溪共建委', lng: 120.151659, lat: 29.422459 },

    { name: '上娄村', region: '正阳共建委', lng: 120.143917, lat: 29.437273 },
    { name: '同春村', region: '正阳共建委', lng: 120.149048, lat: 29.446108 },
    { name: '后店村', region: '正阳共建委', lng: 120.147083, lat: 29.422984 },
    { name: '塘里蒋村', region: '正阳共建委', lng: 120.136408, lat: 29.437678 },
    { name: '新乐村', region: '正阳共建委', lng: 120.127883, lat: 29.432011 },
    { name: '新院村', region: '正阳共建委', lng: 120.14083, lat: 29.424968 },
    { name: '蒋宅村', region: '正阳共建委', lng: 120.135303, lat: 29.424943 },
    { name: '邢宅村', region: '正阳共建委', lng: 120.122161, lat: 29.441168 },
    { name: '青春村', region: '正阳共建委', lng: 120.130231, lat: 29.448391 },

    { name: '东青村', region: '江南共建委', lng: 120.107899, lat: 29.430078 },
    { name: '密溪村', region: '江南共建委', lng: 120.103441, lat: 29.416736 },
    { name: '徐丰村', region: '江南共建委', lng: 120.125437, lat: 29.40359 },
    { name: '杜村', region: '江南共建委', lng: 120.093504, lat: 29.433103 },
    { name: '洪流村', region: '江南共建委', lng: 120.114944, lat: 29.422459 },
    { name: '湾头下村', region: '江南共建委', lng: 120.126132, lat: 29.391933 },
    { name: '立塘村', region: '江南共建委', lng: 120.117458, lat: 29.413234 },
    { name: '马丁村', region: '江南共建委', lng: 120.131722, lat: 29.40619 },
    { name: '龙华村', region: '江南共建委', lng: 120.113318, lat: 29.404571 },

    { name: '上甘村', region: '联合共建委', lng: 120.183388, lat: 29.394707 },
    { name: '上西陶村', region: '联合共建委', lng: 120.130231, lat: 29.448391 },
    { name: '下陈村', region: '联合共建委', lng: 120.176486, lat: 29.388838 },
    { name: '东洪村', region: '联合共建委', lng: 120.14308, lat: 29.390176 },
    { name: '东陶村', region: '联合共建委', lng: 120.143421, lat: 29.384948 },
    { name: '后山坞村', region: '联合共建委', lng: 120.143673, lat: 29.396691 },
    { name: '塘头应村', region: '联合共建委', lng: 120.153667, lat: 29.386468 },
    { name: '新厅村', region: '联合共建委', lng: 120.187142, lat: 29.387618 },
    { name: '畈田村', region: '联合共建委', lng: 120.176182, lat: 29.402941 },
    { name: '苏港村', region: '联合共建委', lng: 120.162654, lat: 29.385204 },
    { name: '西山下村', region: '联合共建委', lng: 120.174391, lat: 29.39845 },
    { name: '里宅村', region: '联合共建委', lng: 120.150187, lat: 29.395225 },
    { name: '高岭村', region: '联合共建委', lng: 120.15211, lat: 29.391875 },

    // {name: '天能光合', region: '', lng: 120.169158, lat: 29.405486},
    // {name: '东方日升', region: '', lng: 120.18235, lat: 29.397243},
    // {name: '超凡', region: '', lng: 120.168212, lat: 29.397472},
    // {name: '里宅', region: '', lng: 120.18235, lat: 29.397243},
    // {name: '和谐明芯', region: '', lng: 120.176413, lat: 29.405363},
    // {name: '爱旭', region: '', lng: 120.165364, lat: 29.410898},
    // {name: '枢纽港', region: '', lng: 120.137897, lat: 29.41603},
  ])

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
    // console.log(e, 111)
    showPopover.value = true
    if (v.content) {
      content.value = v.content
    }
    editName.value = v.name
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
    font-size: 20px;
    font-weight: bold;
    padding-top: 16px;
  }

  .popover-container .content2 p {
    font-size: 16px;
    line-height: 22px;
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