<template>
  <naive-config>
    <div v-if="editor">
      <button type="primary" @click="toggleText">
        标题/内容
      </button>
      <button type="primary" @click="toggleAlign">
        对齐
      </button>
      <button type="primary"
        @click="editor.chain().focus().insertTable({ rows: 3, cols: 3, withHeaderRow: true }).run()">
        创建表
      </button>
      <!-- <button text @click="editor.chain().focus().deleteTable().run()"
        :disabled="!editor.can().deleteTable()">
        删除表
      </button> -->
      <button type="primary" @click="editor.chain().focus().addColumnBefore().run()"
        :disabled="!editor.can().addColumnBefore()">
        前插列
      </button>
      <button type="primary" @click="editor.chain().focus().addColumnAfter().run()"
        :disabled="!editor.can().addColumnAfter()">
        后插列
      </button>
      <button type="primary" @click="editor.chain().focus().deleteColumn().run()"
        :disabled="!editor.can().deleteColumn()">
        删除列
      </button>
      <button type="primary" @click="editor.chain().focus().addRowBefore().run()"
        :disabled="!editor.can().addRowBefore()">
        前插行
      </button>
      <button type="primary" @click="editor.chain().focus().addRowAfter().run()"
        :disabled="!editor.can().addRowAfter()">
        后插行
      </button>
      <button type="primary" @click="editor.chain().focus().deleteRow().run()" :disabled="!editor.can().deleteRow()">
        删除行
      </button>
      <!-- <button type="primary" @click="editor.chain().focus().mergeCells().run()"
        :disabled="!editor.can().mergeCells()">
        mergeCells
      </button>
      <button type="primary" @click="editor.chain().focus().splitCell().run()" :disabled="!editor.can().splitCell()">
        splitCell
      </button> -->
      <!-- <button type="primary" @click="editor.chain().focus().toggleHeaderColumn().run()"
        :disabled="!editor.can().toggleHeaderColumn()">
        toggleHeaderColumn
      </button>
      <button type="primary" @click="editor.chain().focus().toggleHeaderRow().run()"
        :disabled="!editor.can().toggleHeaderRow()">
        toggleHeaderRow
      </button> -->

      <button text @click="editor.chain().focus().toggleHeaderCell().run()"
        :disabled="!editor.can().toggleHeaderCell()">
        切换表头
      </button>

      <!-- <button type="primary" @click="editor.chain().focus().toggleHeaderCell().run()"
        :disabled="!editor.can().toggleHeaderCell()">
        toggleHeaderCell
      </button> -->
      <button text @click="editor.chain().focus().mergeOrSplit().run()" :disabled="!editor.can().mergeOrSplit()">
        合并/分离
      </button>
      <button text @click="toggleList">
        列表
      </button>
      <button text @click="editor.chain().focus().setHorizontalRule().run()">
        线
      </button>
      <button @click="editor.chain().focus().undo().run()" :disabled="!editor.can().chain().focus().undo().run()">
        撤销
      </button>
      <button @click="editor.chain().focus().redo().run()" :disabled="!editor.can().chain().focus().redo().run()">
        恢复
      </button>
      <!-- <button type="primary" @click="editor.chain().focus().setCellAttribute('backgroundColor', '#FAF594').run()"
        :disabled="!editor.can().setCellAttribute('backgroundColor', '#FAF594')">
        setCellAttribute
      </button> -->
      <!-- <button type="primary" @click="editor.chain().focus().fixTables().run()" :disabled="!editor.can().fixTables()">
        fixTables
      </button>
      <button type="primary" @click="editor.chain().focus().goToNextCell().run()"
        :disabled="!editor.can().goToNextCell()">
        goToNextCell
      </button>
      <button type="primary" @click="editor.chain().focus().goToPreviousCell().run()"
        :disabled="!editor.can().goToPreviousCell()">
        goToPreviousCell
      </button> -->
    </div>
  </naive-config>
  <editor-content :class="name + ' el-tiptap-editor__content'" :editor="editor" />
</template>

<script>
  import Table from '@tiptap/extension-table'
  import TableCell from '@tiptap/extension-table-cell'
  import TextAlign from '@tiptap/extension-text-align'
  import TableHeader from '@tiptap/extension-table-header'
  import TableRow from '@tiptap/extension-table-row'
  import StarterKit from '@tiptap/starter-kit'
  import { Editor, EditorContent } from '@tiptap/vue-3'

  const CustomTableCell = TableCell.extend({
    addAttributes() {
      return {
        // extend the existing attributes …
        ...this.parent?.(),

        // and add a new one …
        backgroundColor: {
          default: null,
          parseHTML: element => element.getAttribute('data-background-color'),
          renderHTML: attributes => {
            return {
              'data-background-color': attributes.backgroundColor,
              style: `background-color: ${attributes.backgroundColor}`,
            }
          },
        },
      }
    },
  })
  let text = 0;
  let align = 2;
  let list = 0;

  export default {
    props: ['content', 'name'],
    emits: ['update:content'],
    components: {
      EditorContent,
    },

    data() {
      return {
        editor: null,
      }
    },

    mounted() {
      this.editor = new Editor({
        extensions: [
          StarterKit,
          TextAlign.configure({
            types: ['heading', 'paragraph'],
            alignments: ['left', 'center', 'right'],
          }),
          Table.configure({
            resizable: true,
          }),
          TableRow,
          TableHeader,
          // Default TableCell
          // TableCell,
          // Custom TableCell with backgroundColor attribute
          CustomTableCell,
        ],
        content: this.content,

        onUpdate: this.onUpdate

      })
    },

    beforeUnmount() {
      this.editor.destroy()
    },

    // setup(props) {
    //   const onUpdate = (editor) => {
    //     const html = editor.editor.getHTML();

    //     console.log(props.content, 1111)
    //   }
    // },

    methods: {
      onUpdate(editor) {
        const html = editor.editor.getHTML();
        // console.log(html)
        // this.content = html
        this.$emit('update:content', html)
      },

      toggleText(e) {
        if (text === 0) {
          this.editor.chain().focus().toggleHeading({ level: 1 }).run()
          text++
        } else if (text === 1) {
          this.editor.chain().focus().toggleHeading({ level: 2 }).run()
          text++
        } else if (text === 2) {
          this.editor.chain().focus().toggleHeading({ level: 3 }).run()
          text++
        } else if (text === 3) {
          this.editor.chain().focus().setParagraph({ level: 3 }).run()
          text = 0
        }
      },

      toggleAlign(e) {
        if (align === 0) {
          this.editor.commands.setTextAlign('left')
          align++
        } else if (align === 1) {
          this.editor.commands.setTextAlign('center')
          align++
        } else if (align === 2) {
          this.editor.commands.setTextAlign('right')
          align = 0
        }
      },

      toggleList(e) {
        if (list === 0) {
          this.editor.chain().focus().toggleBulletList().run()
          list++
        } else if (list === 1) {
          this.editor.chain().focus().toggleOrderedList().run()
          list++
        } else if (list === 2) {
          this.editor.chain().focus().toggleOrderedList().run()
          list = 0
        }
      }
    }
  }
</script>

<style>
  button {
    font-size: 12px;
    color: #000;
    margin: 0.1rem;
    border: 1px solid black;
    border-radius: 0.3rem;
    padding: 0.1rem 0.4rem;
    background: #fefefe;
    accent-color: black;
  }


  .tiptap {
    outline: none;
    border: none;
    height: 360px;
    overflow: auto;
  }

  h1 {
    font-size: 22px;
    margin: 4px;
  }

  h2 {
    font-size: 18px;
    margin: 2px;
  }

  h3 {
    font-size: 16px;
    margin: 0px;
  }

  p {
    font-size: 12px;
    margin: 0px;
  }

  hr {
    border-top: 1px solid #fefefe;
  }

  ol,
  ul {
    margin: 0;
    padding: 0 4px;
    list-style: none;
  }

  table {
    border-collapse: collapse;
    table-layout: fixed;
    width: 100%;
    margin: 0;
    overflow: hidden;
  }

  td,
  th {
    min-width: 1em;
    border: 2px solid #fefefe;
    padding: 3px 5px;
    box-sizing: border-box;
    position: relative;
  }

  th {
    font-weight: bold;
    color: #a92e2b;
    background: #cdac86;
  }

  .selectedCell:after {
    z-index: 2;
    position: absolute;
    content: "";
    left: 0;
    right: 0;
    top: 0;
    bottom: 0;
    background: rgba(200, 200, 255, 0.4);
    pointer-events: none;
  }

  .column-resize-handle {
    position: absolute;
    right: -2px;
    top: 0;
    bottom: -2px;
    width: 4px;
    background-color: #adf;
    pointer-events: none;
  }

  p {
    margin: 0;
  }

  .tableWrapper {
    overflow-x: auto;
  }

  .resize-cursor {
    cursor: ew-resize;
    cursor: col-resize;
  }

  /* .el-tiptap-editor__content {
    width: 800px;
    height: 220px;
    overflow: auto;
  }

  .el-tiptap-editor *[class^=el-tiptap-editor] {
    color: #fefefe;
    background: #a92e2b;
  }

  .el-tiptap-editor *[class^=el-tiptap-editor] svg {
    fill: #fefefe;
  }

  .el-tiptap-editor__content th,
  .el-tiptap-editor__content td {
    border: 1px solid #fefefe;
    padding: 0;
    font-size: 12px;
    vertical-align: middle;
  }

  .el-tiptap-editor__content th {
    font-size: 14px;
    font-weight: bold;
  }

  .el-tiptap-editor__content th mark,
  .el-tiptap-editor__content td mark {
    padding: 2px;
    background-color: #cdac86;
    display: block;
  }

  .el-tiptap-editor__content th.selectedCell,
  .el-tiptap-editor__content td.selectedCell {
    background-color: #E1BABA;
  } */
</style>