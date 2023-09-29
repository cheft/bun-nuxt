<template>
  <div>
    <el-tiptap v-model="content" :extensions="extensions" />
  </div>
</template>

<script>
  import {
    // necessary extensions
    Doc,
    Text,
    Paragraph,

  } from 'element-tiptap-vue3-fixed';

  export default {
    data() {
      // editor extensions
      // they will be added to menubar and bubble menu by the order you declare.
      return {
        extensions: [
          new Doc(),
          new Text(),
          new Paragraph(),

        ],
        // editor's content
        content: `
          <h1>Heading</h1>
          <p>This Editor is awesome!</p>
        `,
      };
    },
  }

</script>