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
              <div class="text">{{editRegin}} —— {{editName}}</div>
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
    // , content: '<h3>村社简介</h3><p></p><h3>村社党群服务中心简介</h3><p></p><h3>党组织简介</h3><p></p>'
    { name: '东风社区', region: '社区', lng: 120.143406, lat: 29.413794, content: '<h3>村社简介</h3><p>东风  社区，面积  0.85  平方千米，现有户籍人口 1258  人，常住人口  6664  人，流动人口  7426    人。社区内特色产业为      ，年集体收入为         万元。</p><h3>村社党群服务中心简介</h3><p>东风 社区党群服务中心位于  镇前街与民丰路交叉口   ，面积  1200  平方米，设有   党员教育功能区、服务群众功能区、会议培训功能区、图书阅览功能区、文体活动功能区  功能区块，年组织活动   32   场，年参与活动  1500余 人次。</p><h3>党组织简介</h3><p>东风社区   党总支，  4  星级党组织，下辖 6  个支部（党总支、社区党委填写即可），现有正式党员   65  人，预备党员  0  人，流动党员  76  人。</p>' },
    { name: '十合里社区', region: '社区', lng: 120.153176, lat: 29.402931, content: '<h3>村社简介</h3><p>十和里社区，面积1.8平方千米，现有户籍人口5617人，常住人口6500人，流动人口8500人。村（社区）内特色产业为/，年集体收入为/万元。</p><h3>村社党群服务中心简介</h3><p>十和里社区党群服务中心位于苏溪镇阳光大道M18号，面积        1400平方米，设有共享法庭、退役军人服务站、青年之家、民事议事堂等功能区块，年组织活动100场，年参与活动3100人次。</p><h3>党组织简介</h3><p>十和里社区党委，四星级党组织，下辖8个支部（党总支、社区党委填写即可），现有正式党员157人，预备党员2人，流动党员103人。</p>' },
    { name: '胡宅社区', region: '社区', lng: 120.13233, lat: 29.420724, content: '<h3>村社简介</h3><p>胡宅   村（社区），面积  2.1  平方千米，现有户籍人口  3600 人，常住人口  26000余 人，流动人口 23000余 人。村（社区）内特色产业为    ，年集体收入为    万元。</p><h3>村社党群服务中心简介</h3><p>胡宅  村（社区）党群服务中心位于 苏溪镇人民路70号 ，面积  350  平方米，设有  党员教育功能区、服务群众功能区、会议培训功能区、图书阅览功能区  功能区块，年组织活动 30 场，年参与活动  1500余 人次。</p><h3>党组织简介</h3><p>胡宅社区   支部/总支/党委，  四  星级党组织，下辖  9  个支部（党总支、社区党委填写即可），现有正式党员  239  人，预备党员  6  人，流动党员  138  人。</p>' },
    { name: '龙祈社区', region: '社区', lng: 120.139202, lat: 29.406828, content: '<h3>村社简介</h3><p>龙祈   社区，面积  1.33  平方千米，现有户籍人口2094       人，常住人口 15704  人，流动人口  12080  人。社区内特色产业为  酒店旅游  ，年集体收入为   0   万元。</p><h3>村社党群服务中心简介</h3><p>龙祈   社区党群服务中心位于   苏溪镇杨梅岗小区内    ，面积  1000  平方米，设有 妇女儿童驿站、老年学堂、便民服务站等 功能区块，年组织活动  31   场，年参与活动  1300  人次。</p><h3>党组织简介</h3><p>龙祈社区    支部/总支/党委，  三  星级党组织，下辖 6  个支部（党总支、社区党委填写即可），现有正式党员   123  人，预备党员  1  人，流动党员  136  人。</p>' },
    { name: '苏福社区', region: '社区', lng: 120.140288, lat: 29.396127, content: '<h3>村社简介</h3><p>苏福 社区，面积 2.5 平方千米，现有户籍人口 1418 人，常住人口 11212 人，流动人口 9794 人。社区内特色产业为      ，年集体收入为         万元。</p><h3>村社党群服务中心简介</h3><p>苏福 社区党群服务中心位于苏福社区居民委员会，面积        300平方米，设有  服务群众、会议培训  功能区块，年组织活动31场，年参与活动 900 人次。</p><h3>党组织简介</h3><p>苏福社区支部/总支/党委，五星级党组织，下辖 6 个支部（党总支、社区党委填写即可），现有正式党员113人，预备党员 2 人，流动党员 89 人。</p>' },

    { name: '三联村', region: '巧溪共建委', lng: 120.157532, lat: 29.430803, content: '<h3>村社简介</h3><p>三联  村（社区），面积0.95平方千米，现有户籍人口  1240     人，常住人口   800 人，流动人口  360 人。村（社区）内特色产业为  无   ，年集体收入为  55  万元。</p><h3>村社党群服务中心简介</h3><p>三联 村（社区）党群服务中心位于    三联村     ，面积  680  平方米，设有 会议室、图书室等 功能区块，年组织活动 20余   场，年参与活动1200 人次。</p><h3>党组织简介</h3><p>三联村  党总支， 四 星级党组织，下辖 三 个支部（党总支、社区党委填写即可），现有正式党员 70 人，预备党员 0 人，流动党员 2人。 </p>' },
    { name: '上山下村', region: '巧溪共建委', lng: 120.184865, lat: 29.407075, content: '<h3>村社简介</h3><p>上山下  村（社区），目前处于拆迁集聚过程中，现有户籍人口   360   人，年集体收入为   50   万元。</p><h3>党组织简介</h3><p>上山下村  党委， 二 星级党组织，现有正式党员                                       19人，预备党员 0 人，流动党员 0 人。</p>' },
    { name: '下屋村', region: '巧溪共建委', lng: 120.170964, lat: 29.41789, content: '<h3>村社简介</h3><p>下屋  村（社区），面积  平方千米，现有户籍人口702       人，常住人口 1200 人，流动人口   700  人。村（社区）内特色产业为  无   ，年集体收入为   50   万元。</p><h3>村社党群服务中心简介</h3><p>下屋  村（社区）党群服务中心位于    下屋村     ，面积  100  平方米，设有 会议室、图书室等 功能区块，年组织活动 20余   场，年参与活动 800 人次。</p><h3>党组织简介</h3><p>下屋村  党委， 四 星级党组织，下辖 / 个支部（党总支、社区党委填写即可），现有正式党员 27 人，预备党员 0 人，流动党员 5 人。</p>' },
    { name: '六都村', region: '巧溪共建委', lng: 120.153887, lat: 29.413972, content: '<h3>村社简介</h3><p>六都      村，面积 53  平方千米，现有户籍人口       人，常住人口   1858    人，流动人口   563     人。村内特色产业为  香榧种植        ，年集体收入为         80万元。</p><h3>村社党群服务中心简介</h3><p>六都    村党群服务中心位于 六都村文教广场  ，面积        2000平方米，设有 9大功能区块，年组织活动  156       场，年参与活动   4686 人次。</p><h3>党组织简介</h3><p>六都村 党委，  五  星级党组织，下辖 5 个支部，现有正式党员 101 人，预备党员 1 人，流动党员 15   人。</p>' },
    { name: '同裕村', region: '巧溪共建委', lng: 120.174531, lat: 29.438945, content: '<h3>村社简介</h3><p>同裕  村（社区），面积 1.1 平方千米，现有户籍人口       人，常住人口   1700 人，流动人口   500  人。村（社区）内特色产业为  无   ，年集体收入为   60   万元。</p><h3>村社党群服务中心简介</h3><p>同裕  村（社区）党群服务中心位于    龙祁山   ，面积  600  平方米，设有 会议室、图书室等 功能区块，年组织活动 20余   场，年参与活动 3000 人次。</p><h3>党组织简介</h3><p>同裕  党委， 三 星级党组织，下辖  个支部（党总支、社区党委填写即可），现有正式党员 41人，预备党员 1 人，流动党员 0 人。</p>' },
    { name: '殿下村', region: '巧溪共建委', lng: 120.162318, lat: 29.414793, content: '<h3>村社简介</h3><p>殿下  村（社区），面积 1.2 平方千米，现有户籍人口  1396  人，常住人口  1300 人，流动人口  450  人。村（社区）内特色产业为  无   ，年集体收入为   200  万元。</p><h3>村社党群服务中心简介</h3><p>殿下村  村（社区）党群服务中心位于    殿下村一区99号     ，面积  350 平方米，设有 会议室、图书室等 功能区块，年组织活动 20余   场，年参与活动 2000 人次。</p><h3>党组织简介</h3><p>殿下村  党委， 五 星级党组织，下辖 二 个支部（党总支、社区党委填写即可），现有正式党员 85 人，预备党员 1 人，流动党员 2 人。</p>' },
    { name: '溪北村', region: '巧溪共建委', lng: 120.16968, lat: 29.421157, content: '<h3>村社简介</h3><p>溪北  村（社区），面积 1.3 平方千米，现有户籍人口 1383 人，常住人口   1800 人，流动人口   700  人。村（社区）内特色产业为  无   ，年集体收入为   60   万元。</p><h3>村社党群服务中心简介</h3><p>溪北  村（社区）党群服务中心位于    溪北村     ，面积  200  平方米，设有 会议室 功能区块，年组织活动 20余   场，年参与活动 2000 人次。</p><h3>党组织简介</h3><p>溪北村  党委， 三 星级党组织，下辖 2 个支部（党总支、社区党委填写即可），现有正式党员 71 人，预备党员 0 人，流动党员 6 人。</p>', content: '<h3>村社简介</h3><p></p><h3>村社党群服务中心简介</h3><p></p><h3>党组织简介</h3><p></p>' },
    { name: '翁界村', region: '巧溪共建委', lng: 120.182712, lat: 29.422483, content: '<h3>村社简介</h3><p>翁界村面积3平方公里，现有户籍人口1043人，常住人口九百多人，流动人口两百多人，村内特色产业有马家柚基地，年集体收入50万元。</p><h3>村社党群服务中心简介</h3><p>翁界村党群服务中心位于苏溪镇翁界村翁界大桥边，面积1000平方米左右，设有党员会议室、党支部办公室、文化礼堂、消防站，便民服务站，老年活动中心，居家养老食堂，红白喜事专用场地、健身设施，公厕等等。年组织活动100场以上，年参加活动1500人次以上。</p><h3>党组织简介</h3><p>党员志愿者活动、党员学习活动、义诊活动、迎国庆活动，、篮球比赛活动、预防登革热爱国卫生活动、文明创建活动等。活动地点：翁界村文化礼堂及村内。翁界村党总支，下辖二个支部，现有正式党员55名，预备党员2人，流动党员1名。</p>' },
    { name: '联合村', region: '巧溪共建委', lng: 120.159893, lat: 29.440348, content: '<h3>村社简介</h3><p>联合  村（社区），面积 1.3 平方千米，现有户籍人口       人，常住人口   1700 人，流动人口   500  人。村（社区）内特色产业为  无   ，年集体收入为   60   万元。</p><h3>村社党群服务中心简介</h3><p>联合  村（社区）党群服务中心位于    联合村     ，面积  600  平方米，设有 会议室、图书室等 功能区块，年组织活动 20余   场，年参与活动 3000 人次。</p><h3>党组织简介</h3><p>联合村  党委， 三 星级党组织，下辖 四 个支部（党总支、社区党委填写即可），现有正式党员 115 人，预备党员 0 人，流动党员 8 人。</p>' },
    { name: '花厅村', region: '巧溪共建委', lng: 120.161028, lat: 29.42145, content: '<h3>村社简介</h3><p>花厅  村，面积 1.3 平方千米，现有户籍人口     970  人，常住人口   1400 人，流动人口   500  人。年集体收入为   50   万元。</p><h3>村社党群服务中心简介</h3><p>花厅  村党群服务中心位于    苏溪镇花厅村     ，面积  300  平方米，设有 会议室、图书室等 功能区块，年组织活动 20余   场，年参与活动 2000 人次。</p><h3>党组织简介</h3><p>花厅村  党总支， 四 星级党组织，下辖 二 个支部，现有正式党员 59人，预备党员 0 人，流动党员 4 人。</p>' },
    { name: '范家村', region: '巧溪共建委', lng: 120.185959, lat: 29.399406, content: '<h3>村社简介</h3><p>范家村     村（社区），面积  2.5      平方千米，现有户籍人口 617人，常住人口  395 人，流动人口         222人。村（社区）内特色产业为          ，年集体收入为         万元。</p><h3>村社党群服务中心简介</h3><p>范家村（社区）党群服务中心位于                 ，面积        平方米，设有                   功能区块，年组织活动         场，年参与活动       人次。</p><h3>党组织简介</h3><p>范家村       支部/总支/党委， 五   星级党组织，下辖  1 个支部（党总支、社区党委填写即可），现有正式党员   29  人，预备党员  0  人，流动党员  0  人。</p>' },
    { name: '齐山楼村', region: '巧溪共建委', lng: 120.151659, lat: 29.422459, content: '<h3>村社简介</h3><p>齐山楼  村（社区），面积 1.3 平方千米，现有户籍人口 1460  人，常住人口 1200  人，流动人口 2300  人。村（社区）内特色产业为  无   ，年集体收入为   60   万元。</p><h3>村社党群服务中心简介</h3><p>齐山楼  村（社区）党群服务中心位于  齐山楼公交车站     ，面积 200  平方米，设有 会议室、图书室等 功能区块，年组织活动 40   场，年参与活动 3000 人次。</p><h3>党组织简介</h3><p>齐山楼村  党委， 四 星级党组织，下辖 2 个支部（党总支、社区党委填写即可），现有正式党员 52 人，预备党员 1 人，流动党员 12 人。</p>' },

    { name: '上娄村', region: '正阳共建委', lng: 120.143917, lat: 29.437273, content: '<h3>村社简介</h3><p>上娄 村，面积  1.5  平方千米，现有户籍人口 800  人，常住人口   1587    人，流动人口   787     人。村内特色产业为  浙江省“一村万树“（银杏林） ，年集体收入为 100  万元。</p><h3>村社党群服务中心简介</h3><p>上娄 村党群服务中心位于 上娄村  ，面积600 平方米，设有 便民服务中心、文化礼堂、会议室等             功能区块，年组织活动 50 场，年参与活动 1500  人次。</p><h3>党组织简介</h3><p>上娄村党支部，  五  星级党组织，现有正式党员  50   人，预备党员  1  人，流动党员 2  人。</p>' },
    { name: '同春村', region: '正阳共建委', lng: 120.149048, lat: 29.446108, content: '<h3>村社简介</h3><p>同春   村，面积     6   平方千米，现有户籍人口   1268    人，常住人口   823    人，流动人口        480人。村（社区）内特色产业为  粮食种植 ，年集体收入为    70     万元。</p><h3>村社党群服务中心简介</h3><p>同春   村党群服务中心位于 同春村村委会旁      ，面积 80  平方米，设有   图书阅读室、会议室等                功能区块，年组织活动   12  场，年参与活动   1100   人次。</p><h3>党组织简介</h3><p>同春村      党总支，  4  星级党组织，下辖2   个支部，现有正式党员  74   人，预备党员  0  人，流动党员  4  人。</p>' },
    { name: '后店村', region: '正阳共建委', lng: 120.147083, lat: 29.422984, content: '<h3>村社简介</h3><p>后店     村（社区），面积 8.8 平方千米，现有户籍人口   410    人，常住人口    860   人，流动人口    450    人。村（社区）内特色产业为    无   ，年集体收入为    60   万元。</p><h3>村社党群服务中心简介</h3><p> 后店   村党群服务中心位于    苏溪镇正阳学校对面   ，面积  600  平方米，设有      2      功能区块，年组织活动     18    场，年参与活动   500    人次。</p><h3>党组织简介</h3><p>后店村      党支部， 五   星级党组织，现有正式党员  36   人，预备党员  2  人，流动党员  2  人。</p>' },
    { name: '塘里蒋村', region: '正阳共建委', lng: 120.136408, lat: 29.437678, content: '<h3>村社简介</h3><p>塘里蒋    村，面积  1.55      平方千米，现有户籍人口  504     人，常住人口  450   人，流动人口 1500  人。年集体收入为  60   万元。</p><h3>村社党群服务中心简介</h3><p>塘里蒋    村党群服务中心位于   苏溪镇塘里蒋村       ，面积   300   平方米，设有活动室会议室。阅览室。功能设施。年组织活动   20   场，年参与活动   1500    人次。</p><h3>党组织简介</h3><p>塘里蒋村          党支部，  四  星级党组织，现有正式党员   45  人，预备党员 0  人，流动党员 4   人。</p>' },
    { name: '新乐村', region: '正阳共建委', lng: 120.127883, lat: 29.432011, content: '<h3>村社简介</h3><p>新乐  村，面积   2.3   平方千米，现有户籍人口   1050 人，常住人口   1550    人，流动人口 500       人。村（社区）内特色产业为    菜苗      ，年集体收入为  50   万元。</p><h3>村社党群服务中心简介</h3><p>新乐 村（社区）党群服务中心位于   新乐村村口    ，面积    280    平方米，设有    会议室    功能区块，年组织活动  12  场，年参与活动  400  人次。</p><h3>党组织简介</h3><p>新乐村 党支部， 三 星级党组织，现有正式党员 38 人，预备党员  1  人，流动党员 3 人。</p>' },
    { name: '新院村', region: '正阳共建委', lng: 120.14083, lat: 29.424968, content: '<h3>村社简介</h3><p>新院 村（社区），面积 3.2平方千米，现有户籍人口       1414人，常住人口 7956 人，流动人口 6542 人。村（社区）内特色产业为 第二、三产业 ，年集体收入为115.3 万元。</p><h3>村社党群服务中心简介</h3><p>新院 村党群服务中心位于 苏溪镇新院村 ，面积 1253 平方米，设有 文明实践站、阅读吧、居家养老、便民服务站等功能区块，年组织活动 20余 场，年参与活动       450余人次。</p><h3>党组织简介</h3><p>新院村党总支，二星级党组织，下辖二个支部（党总支、社区党委填写即可），现有正式党员58人，预备党员0人，流动党员19人。</p>' },
    { name: '蒋宅村', region: '正阳共建委', lng: 120.135303, lat: 29.424943, content: '<h3>村社简介</h3><p>蒋宅   村（社区），面积  5.8 平方千米，现有户籍人口 1809人，常住人口   5238  人，流动人口   4000   人。村（社区）内特色产业为 电商、衬衣、内衣、箱包、袖套等  ，年集体收入为  150  万元。</p><h3>村社党群服务中心简介</h3><p>蒋宅   村（社区）党群服务中心位于 苏溪镇蒋宅村人民北路138号 ，面积 800 平方米，                设有  党群服务中心，便民服务站，文化礼堂  等功能区块，年组织活动 100 场，年参与活动 4000 人次。</p><h3>党组织简介</h3><p>蒋宅村    党总支，   三 星级党组织，下辖 五  个支部，现有正式党员   116  人，预备党员  1 人，流动党员  5  人。</p>' },
    { name: '邢宅村', region: '正阳共建委', lng: 120.122161, lat: 29.441168, content: '<h3>村社简介</h3><p>邢宅      村（社区），面积  2   平方千米，现有户籍人口  1016  人，常住人口  1600 人，流动人口 584       人。年集体收入为56万元。</p><h3>村社党群服务中心简介</h3><p>邢宅 村党群服务中心位于  苏溪镇邢宅村6号  ，面积  800  平方米，设有会议室，文化礼堂，阅吧，便民服务等功能区块，年组织活动  45  场，年参与活动1800       人次。</p><h3>党组织简介</h3><p>邢宅村 党总支， 五  星级党组织，下辖 3 个支部，现有正式党员  54  人，预备党员  1  人，流动党员  4  人。</p>' },
    { name: '青春村', region: '正阳共建委', lng: 120.130231, lat: 29.448391, content: '<h3>村社简介</h3><p>青春    村，面积    5.2    平方千米，现有户籍人口    650   人，常住人口   600    人，流动人口 500       人。村（社区）内特色产业为  土面、蜜枣等特产加工    ，年集体收入为     40    万元。</p><h3>村社党群服务中心简介</h3><p>青春    村（社区）党群服务中心位于  苏溪镇青春村西张               ，面积    600    平方米，设有                   表演，活动会议功能区块，年组织活动      15   场，年参与活动       800人次。</p><h3>党组织简介</h3><p> 青春村       党支部，  3  星级党组织，现有正式党员   46  人，预备党员   1 人，流动党员 8   人。</p>' },

    { name: '东青村', region: '江南共建委', lng: 120.107899, lat: 29.430078, content: '<h3>村社简介</h3><p>东青  村（社区），面积  12.27  平方千米，现有户籍人口 726 人，常住人口 422 人，流动人口 30 人。村（社区）内特色产业为  种植生姜 ，年集体收入为 50 万元。</p><h3>村社党群服务中心简介</h3><p>东青 村（社区）党群服务中心位于 东青村51号（临时） ，面积 300 平方米，设有 退伍军人服务中心、便民服务站、共享法庭、社会矛盾纠纷调处化解站、会议室 功能区块，年组织活动  24 场，年参与活动  1100 人次。</p><h3>党组织简介</h3><p>东青村  支部/总支/党委， 三 星级党组织，下辖 0  个支部（党总支、社区党委填写即可），现有正式党员  29 人，预备党员 1 人，流动党员  0  人。</p>' },
    { name: '密溪村', region: '江南共建委', lng: 120.103441, lat: 29.416736, content: '<h3>村社简介</h3><p>密溪  村（社区），面积        平方千米，现有户籍人口645人，常住人口 280 人，流动人口 30 人。村（社区）内特色产业为          ，年集体收入为  50  万元。</p><h3>村社党群服务中心简介</h3><p>密溪  村（社区）党群服务中心位于  密溪村村中心  ，面积 150 平方米，设有 党员活动室、文化礼堂、文明实践站、儿童活动中心、图书室  功能区块，年组织活动  12 场，年参与活动 120 人次。</p><h3>党组织简介</h3><p>密溪村  支部/总支/党委， 四星级党组织，下辖一个支部（党总支、社区党委填写即可），现有正式党员23人，预备党员 1人，流动党员 0人。</p>' },
    { name: '徐丰村', region: '江南共建委', lng: 120.125437, lat: 29.40359, content: '<h3>村社简介</h3><p>徐丰  村（社区），面积 2  平方千米，现有户籍人口1376       人，常住人口 450 人，流动人口 950 人。村（社区）内特色产业为          ，年集体收入为 100 万元。</p><h3>村社党群服务中心简介</h3><p>徐丰村（社区）党群服务中心位于徐丰村村口 ，面积120        平方米，设有 党员活动室、办公  功能区块，年组织活动         20场，年参与活动2000人次。</p><h3>党组织简介</h3><p>徐丰村党总支，五星级党组织，下辖2个支部（党总支、社区党委填写即可），现有正式党员  81人，预备党员1人，流动党员3人。</p>' },
    { name: '杜村', region: '江南共建委', lng: 120.093504, lat: 29.433103, content: '<h3>村社简介</h3><p>杜村 村（社区），面积     6500 0  平方千米，现有户籍人口     386人，常住人口409 人，流动人口      215  人。村（社区）内特色产业为      旅游业    ，年集体收入为   79      万元。</p><h3>村社党群服务中心简介</h3><p>杜 村（社区）党群服务中心位于         杜村村内     ，面积      1200  平方米，设有                   功能区块，年组织活动    12     场，年参与活动    1000  人次。</p><h3>党组织简介</h3><p>杜   支部/总支/党委，  四  星级党组织，下辖   个支部（党总支、社区党委填写即可），现有正式党员  20   人，预备党员 1   人，流动党员  0  人。</p>' },
    { name: '洪流村', region: '江南共建委', lng: 120.114944, lat: 29.422459, content: '<h3>村社简介</h3><p>洪流村  村（社区），面积    10万多    平方千米，现有户籍人口  810 人，常住人口   510 人，流动人口   300     人。村（社区）内特色产业为   无       ，年集体收入为         50万元。</p><h3>村社党群服务中心简介</h3><p>洪流村 村（社区）党群服务中心位于  稠下线道路两侧    ，面积    200    平方米，设有    阅读吧               功能区块，年组织活动    96     场，年参与活动      20人次。</p><h3>党组织简介</h3><p>洪流村      支部/总支/党委，  五  星级党组织，下辖  1 个支部（党总支、社区党委填写即可），现有正式党员   44  人，预备党员   0 人，流动党员  0  人。</p>' },
    { name: '湾头下村', region: '江南共建委', lng: 120.126132, lat: 29.391933, content: '<h3>村社简介</h3><p>湾头下  村（社区），面积  0.0713    平方千米，现有户籍人口  771  人，常住人口 771 人，流动人口  1600  人。村（社区）内特色产业为  无   ，年集体收入为  50  万元。</p><h3>村社党群服务中心简介</h3><p>湾头下 村（社区）党群服务中心位于    湾头下村祠堂  ，面积   100    平方米，设有        会议     功能区块，年组织活动    12  场，年参与活动 300 人次。</p><h3>党组织简介</h3><p>湾头下 支部/总支/党委， 一星级党组织，下辖 1个支部（党总支、社区党委填写即可），现有正式党员 35 人，预备党员 2 人，流动党员 0 人。</p>' },
    { name: '立塘村', region: '江南共建委', lng: 120.117458, lat: 29.413234, content: '<h3>村社简介</h3><p>立塘  村（社区），面积    2    平方千米，现有户籍人口   1078 人，常住人口   1484  人，流动人口  336    人。村（社区）内特色产业为    围巾加工      ，年集体收入为    50   万元。</p><h3>村社党群服务中心简介</h3><p>立塘 村（社区）党群服务中心位于    立塘村文化礼堂    ，面积    100 平方米，设有  图书馆           功能区块，年组织活动     12  场，年参与活动  100  人次。</p><h3>党组织简介</h3><p>立塘村   支部/总支/党委，  四  星级党组织，下辖   个支部（党总支、社区党委填写即可），现有正式党员 50    人，预备党员  0  人，流动党员  1  人。</p>' },
    { name: '马丁村', region: '江南共建委', lng: 120.131722, lat: 29.40619, content: '<h3>村社简介</h3><p>马丁  村（社区），面积  0.086  平方千米，现有户籍人口  709  人，常住人口  2500  人，流动人口  1800 人。村（社区）内特色产业为 箱包围巾制造 ，年集体收入为         50万元。</p><h3>村社党群服务中心简介</h3><p>马丁  村（社区）党群服务中心位于  马丁村8幢1号 ，面积 108  平方米，设有  党建活动，服务中心，老年协会  功能区块，年组织活动  120  场，年参与活动 1200 人次。</p><h3>党组织简介</h3><p>马丁村   支部， 三 星级党组织，下辖   个支部（党总支、社区党委填写即可），现有正式党员 35  人，预备党员  0  人，流动党员 8  人。</p>' },
    { name: '龙华村', region: '江南共建委', lng: 120.113318, lat: 29.404571, content: '<h3>村社简介</h3><p>龙华  村（社区），面积  0.8   平方千米，现有户籍人口 855 人，常住人口  588   人，流动人口  368  人。村（社区）内特色产业为 围巾 ，年集体收入为  50 万元。</p><h3>村社党群服务中心简介</h3><p>龙华 村（社区）党群服务中心位于 龙华村文化礼堂 ，面积 400 平方米，设有居家养老中心食堂、老年活动中心、春泥活动室、图书馆、健身区、会议中心等功能区块，年组织活动  100 场，年参与活动 300 人次。</p><h3>党组织简介</h3><p>龙华村党  支部/总支/党委， 五 星级党组织，下辖 1  个支部（党总支、社区党委填写即可），现有正式党员 46    人，预备党员  1  人，流动党员  1  人。</p>' },

    { name: '上甘村', region: '联合共建委', lng: 120.183388, lat: 29.394707, content: '<h3>村社简介</h3><p>上甘 村，面积  1.05  平方千米，现有户籍人口  531  人，常住人口  1230 人，流动人口  860  人。年集体收入为  80  万元。</p><h3>村社党群服务中心简介</h3><p>上甘  村（社区）党群服务中心位于   苏溪镇上甘村   ，面积 150 平方米，设有   宣传党建、会议室、活动室等   功能区块，年组织活动  15  场，年参与活动  200  人次。</p><h3>党组织简介</h3><p>上甘  党支部，  三  星级党组织，现有正式党员  25  人，预备党员  0  人，流动党员  2  人。</p>' },
    { name: '上西陶村', region: '联合共建委', lng: 120.130231, lat: 29.448391, content: '<h3>村社简介</h3><p>上西陶 村，面积   0.665 平方千米，现有农户       305户，常住人口  1403人，流动人口 2233  人。村内特色产业为  房屋出租 ，年集体收入为  50 万元。</p><h3>村社党群服务中心简介</h3><p>上西陶 村（社区）党群服务中心位于  苏溪镇上西陶村21幢  ，面积 200  平方米，设有 综合服务中心.党群活动区.文体活动区.宣传教育区.居家养老、老年协会、、文化中心、消防护村队办公室等功能区块，年组织活动  30   场，年参与活动     1000  人次。</p><h3>党组织简介</h3><p>上西陶村党总支，  五 星级党组织，下辖 2 个支部，现有正式党员  75   人，预备党员   0 人，流动党员  18 人。</p>' },
    { name: '下陈村', region: '联合共建委', lng: 120.176486, lat: 29.388838, content: '<h3>村社简介</h3><p>下陈 村，面积3.3平方千米，现有户籍人口       915人，常住人口650人，流动人口 1500人。村内特色产业为 无 ，年集体收入为  50 万元。</p><h3>村社党群服务中心简介</h3><p>下陈 村（社区）党群服务中心位于 下陈自然村 ，面积        360平方米，设有党群服务中心和文化礼堂，村委办公楼等功能区块，年组织活动  20 场，年参与活动1000人次。</p><h3>党组织简介</h3><p>下陈村 党支部， 四星级党组织，，现有正式党员44人，预备党员1人，流动党员 12人。</p>' },
    { name: '东洪村', region: '联合共建委', lng: 120.14308, lat: 29.390176, content: '<h3>村社简介</h3><p>东洪  村，面积 1.5  平方千米，现有户籍人口 476 人，常住人口 950 人，流动人口 650  人。村内特色产业为 房屋出租    ，年集体收入为   50  万元。</p><h3>村社党群服务中心简介</h3><p>东洪  村（社区）党群服务中心位于    东洪村办公室 ，面积 450  平方米，设有  综合服务中心.党群活动区.文体活动区.宣传教育区.居家养老、老年协会、、文化中心、村辅警办公室、消防护村队办公室 等功能区块，年组织活动         28场，年参与活动 600 人次。</p><h3>党组织简介</h3><p>东洪村  党支部，三 星级党组织，现有正式党员27  人，预备党员 1 人，流动党员4 人。</p>' },
    { name: '东陶村', region: '联合共建委', lng: 120.143421, lat: 29.384948, content: '<h3>村社简介</h3><p>东陶 村，面积   1.2 平方千米，现有户籍人口       651人，常住人口 5000 人，流动人口 700  人。村内特色产业为  房屋出租 ，年集体收入为  76  万元。</p><h3>村社党群服务中心简介</h3><p>东陶 村党群服务中心位于  东陶村综合楼 ，面积 500平方米，设有 综合服务中心.党群活动区.文体活动区.宣传教育区.居家养老、老年协会、、文化中心、村辅警办公室、消防护村队办公室等功能区块，年组织活动  48  场，年参与活动     1200  人次。</p><h3>党组织简介</h3><p>东陶村党支部，  三 星级党组织，现有正式党员  40 人，预备党员   1 人，流动党员  15人。</p>' },
    { name: '后山坞村', region: '联合共建委', lng: 120.143673, lat: 29.396691, content: '<h3>村社简介</h3><p>后山坞 村，面积 0.18 平方千米，现有户籍人口 324 人，常住人口 1980 人，流动人口 1651 人。年集体收入为 11  万元。</p><h3>村社党群服务中心简介</h3><p>后山坞 村党群服务中心位于  苏溪镇后山坞新村南侧 ，面积 325平方米，设有 居家养老、老年协会、党群服务中心、文化中心、红白喜事用房、村辅警办公室、消防护村队办公室 等功能区块，年组织活动 22 场，年参与活动 462 人次。</p><h3>党组织简介</h3><p>后山坞 党支部， 4 星级党组织，现有正式党员     25人，预备党员 2 人，流动党员 8 人。</p>' },
    { name: '塘头应村', region: '联合共建委', lng: 120.153667, lat: 29.386468, content: '<h3>村社简介</h3><p>塘头应 村，面积 0.39 平方千米，现有户籍人口       706人，常住人口 560 人，流动人口 270 人。村内特色产业无，年集体收入为  80 万元。</p><h3>村社党群服务中心简介</h3><p>塘头应 村党群服务中心位于 塘头应村篮球场旁 ，面积 150 平方米，设有 老年活动中心、党群服务中心、退役军人服务站等 功能区块，年组织活动  24 场，年参与活动 640 人次。</p><h3>党组织简介</h3><p>塘头应村  党支部， 三 星级党组织，现有正式党员 37 人，预备党员 0  人，流动党员 4  人。</p>' },
    { name: '新厅村', region: '联合共建委', lng: 120.187142, lat: 29.387618, content: '<h3>村社简介</h3><p>新厅 村，面积 0.53 平方千米，现有户籍人口       926人，常住人口 725 人，流动人口852 人。村内特色产业无，年集体收入为 50 万元。</p><h3>村社党群服务中心简介</h3><p>新厅 村（社区）党群服务中心位于 新厅村篮球场旁 ，面积 240 平方米，设有 老年活动中心、党群服务中心、退役军人服务站等 功能区块，年组织活动  24 场，年参与活动 640 人次。</p><h3>党组织简介</h3><p>新厅村  党支部， 四 星级党组织，现有正式党员 36人，预备党员 0  人，流动党员0  人。</p>' },
    { name: '畈田村', region: '联合共建委', lng: 120.176182, lat: 29.402941, content: '<h3>村社简介</h3><p>畈田     村，目前处于拆迁集聚过程中，现有户籍人口    1268   人，年集体收入20  万元。</p><h3>村社党群服务中心简介</h3><p>畈田    村党群服务中心位于   苏溪镇龙祈路550号            ，面积   40     平方米，设有                   党群服务中心，退伍军人服务站等功能区块，年组织活动   12     场，年参与活动  552   人次。</p><h3>党组织简介</h3><p>畈田村      党支部， 1   星级党组织，现有正式党员  46   人，预备党员  1  人，流动党员  0  人。</p>' },
    { name: '苏港村', region: '联合共建委', lng: 120.162654, lat: 29.385204, content: '<h3>村社简介</h3><p>苏港    村，面积  2.1  平方千米，现有户籍人口 1802 人，常住人口 9800 人，流动人口 7000 人。村内特色产业为 皮带、模具加工 ，年集体收入为 70 万元。</p><h3>村社党群服务中心简介</h3><p>苏港 村党群服务中心位于 苏溪高速出口南150米 ，面积   400  平方米，设有  大会议室、便民服务中心、避灾点 功能区块，年组织活动 24 场，年参与活动 2000 人次。</p><h3>党组织简介</h3><p>苏港村  党总支， 四 星级党组织，下辖 三 个支部，现有正式党员 93 人，预备党员 1  人，流动党员 11 人。</p>' },
    { name: '西山下村', region: '联合共建委', lng: 120.174391, lat: 29.39845, content: '<h3>村社简介</h3><p>西山下村，面积      0.2  平方千米，现有户籍人口  2162 人，常住人口1806人，流动人口 5062  人。西山下村内特色产业为 房屋出租、生态长廊饮食街、人才公寓 ，年集体收入为   500 万元。</p><h3>村社党群服务中心简介</h3><p>西山下村党群服务中心位于 西山下村X56号 ，面积        500平方米，设有 文化礼堂、应急管理中心、避灾点、居家养老中心、老年协会、退役军人服务站、会议室、阅读室、图书馆功能区块，年组织活动 48 场，年参与活动  1050    人次。</p><h3>党组织简介</h3><p>西山下村党总支， 五 星级党组织，下辖  3 个支部，现有正式党员 93   人，预备党员  1  人，流动党员  25  人。</p>' },
    { name: '里宅村', region: '联合共建委', lng: 120.150187, lat: 29.395225, content: '<h3>村社简介</h3><p>里宅 村，面积   0.2 平方千米，现有户籍人口       596人，常住人口  3400 人，流动人口 500  人。村内特色产业为  房屋出租 ，年集体收入为  96  万元。</p><h3>村社党群服务中心简介</h3><p>里宅 村（社区）党群服务中心位于  苏溪镇里宅村48幢  ，面积 200  平方米，设有 综合服务中心.党群活动区.文体活动区.宣传教育区.居家养老、老年协会、、文化中心、村辅警办公室、消防护村队办公室功能区块，年组织活动  52   场，年参与活动     1200  人次。</p><h3>党组织简介</h3><p>里宅村党支部，  五 星级党组织，现有正式党员  47   人，预备党员   1 人，流动党员  22 人。</p>' },
    { name: '高岭村', region: '联合共建委', lng: 120.15211, lat: 29.391875, content: '<h3>村社简介</h3><p>高岭村 ，面积  3.5  平方千米，现有户籍人口   814人，常住人口  5800 人，流动人口 1200 人。村（社区）内特色产业为 小商品，年集体收入为  180 万元。</p><h3>村社党群服务中心简介</h3><p>高岭 村党群服务中心位于    苏溪镇高岭村21排8号，面积  200  平方米，设有  党群服务中心  居家养老 老年会   文化礼堂  功能区块，年组织活动 32场，年参与活动 800  人次。</p><h3>党组织简介</h3><p>高岭村  党支部，  5 星级党组织，现有正式党员 43 人，预备党员  0  人，流动党员 31   人。</p>' },

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
  const editName = ref("")
  const editRegin = ref("")
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
    editRegin.value = v.region
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