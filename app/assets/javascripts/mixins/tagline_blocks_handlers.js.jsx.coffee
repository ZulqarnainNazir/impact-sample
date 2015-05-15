TaglineBlocksHandlers =
  propTypes:
    initialTaglineBlocks: React.PropTypes.array
    defaultTaglineBlockAttributes: React.PropTypes.object

  getInitialState: ->
    taglineBlocks: this.props.initialTaglineBlocks.map(this.taglineBlockInitial)

  taglineBlocksInputs: ->
    this.props.initialTaglineBlocks.map this.taglineBlockInputs

  taglineBlockInputs: (block) ->
    if block.id
      blockFilter = (b) -> b.key == block.key
      foundBlock = this.state.taglineBlocks.filter(blockFilter)[0]
      if foundBlock
        `<input key={this.taglineBlockName(block, 'id')} type="hidden" name={this.taglineBlockName(block, 'id')} value={block.id} />`
      else
        `<div>
          <input key={this.taglineBlockName(block, 'id')} type="hidden" name={this.taglineBlockName(block, 'id')} value={block.id} />
          <input key={this.taglineBlockName(block, '_destroy')} type="hidden" name={this.taglineBlockName(block, '_destroy')} value="1" />
        </div>`
    else
      `<div />`

  taglineBlocksProps: ->
    blockProps: this.state.taglineBlocks.map(this.taglineBlockProps)
    blockAdd: this.taglineBlockAddProps()

  taglineBlockProps: (block) ->
    block: $.extend({}, block, { editing: this.state.editing })
    blockEditor: this.taglineBlockEditorProps(block)
    blockInputLink: this.taglineBlockInputLinkProps(block)
    blockInputText: this.taglineBlockInputTextProps(block)
    blockOptions: this.taglineBlockOptionsProps(block)
    blockInputsClassName: if block and block.displayImageLibrary then 'hide' else ''
    editing: this.state.editing
    name: this.taglineBlockName.bind(null, block)

  # PRIVATE LEVEL 1

  taglineBlockInitial: (block) ->
    $.extend {}, this.taglineBlockDefaultProps(), block

  taglineBlockID: (block, name) ->
    "tagline-blocks-#{block.key}-attributes-#{name}"

  taglineBlockName: (block, name) ->
    "tagline_blocks_attributes[#{block.key}][#{name}]"

  taglineBlockAddProps: ->
    visible: this.state.editing and this.state.taglineBlocks.length < 100
    onClick: this.taglineBlockAdd
    content: 'Add a Tagline Block'

  taglineBlockEditorProps: (block) ->
    id: "tagline-block-#{block.key}-editor"
    title: 'Edit Tagline Block Details'
    swapForm: this.taglineBlockSwapForm.bind(null, block)
    resetForm: this.taglineBlockResetForm.bind(null, block)

  taglineBlockInputLinkProps: (block) ->
    id: this.taglineBlockID.bind(null, block)
    name: this.taglineBlockName.bind(null, block)
    label: block.link_label
    version: block.link_version
    target_blank: block.link_target_blank
    no_follow: block.link_no_follow
    link_id: block.link_id
    link_type: block.link_type
    external_url: block.link_external_url
    checkedNone: block.link_version is 'link_none'
    checkedInternal: block.link_version is 'link_internal'
    checkedExternal: block.link_version is 'link_external'
    internalWebpages: this.props.internalWebpages

  taglineBlockInputTextProps: (block) ->
    id: this.taglineBlockID(block, 'text')
    name: this.taglineBlockName(block, 'text')
    value: block.text
    label: 'Text'
    rows: 4

  taglineBlockOptionsProps: (block) ->
    visible: this.state.editing
    prev: this.taglineBlockPrevTheme.bind(null, block)
    next: this.taglineBlockNextTheme.bind(null, block)
    editorTarget: "#tagline-block-#{block.key}-editor"
    editLabel: 'Edit Details'
    removeLabel: 'Remove Tagline Block'
    onRemove: this.taglineBlockRemove.bind(null, block)
    onEdit: this.taglineBlockEdit.bind(null, block)
    sortable: true

  # PRIVATE LEVEL 2

  taglineBlockDefaultProps: ->
    key: Math.floor(Math.random() * Math.pow(10, 10))
    link_target_blank: false
    link_no_follow: false
    displayImageLibrary: false
    text: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.
      Aenean ultricies ultrices mi eu maximus. Curabitur dignissim libero
      quis sem suscipit tristique. Nunc convallis lorem ut sagittis faucibus.'

  taglineBlockAdd: (event, callback) ->
    event.preventDefault() if event
    this.taglineBlockSave $push: [$.extend({}, this.taglineBlockDefaultProps(), (this.props.defaultTaglineBlockAttributes or {}))], callback

  taglineBlockEdit: (block) ->

  taglineBlockUpdate: (block, attributes, event, callback) ->
    event.preventDefault() if event
    blockFilter = (b) -> b.key == block.key
    foundBlock = this.state.taglineBlocks.filter(blockFilter)[0]
    this.taglineBlockSave $splice: [[this.state.taglineBlocks.indexOf(foundBlock), 1, $.extend({}, foundBlock, attributes)]], callback

  taglineBlockRemove: (block, event, callback) ->
    event.preventDefault() if event
    blockFilter = (b) -> b.key == block.key
    foundBlock = this.state.taglineBlocks.filter(blockFilter)[0]
    this.taglineBlockSave $splice: [[this.state.taglineBlocks.indexOf(foundBlock), 1]], callback

  taglineBlockSwapForm: (block) ->
    this.taglineBlockUpdate block,
      link_version: $("input[name=\"#{this.taglineBlockName(block, 'link_version')}\"]:checked").val()
      link_label: this.taglineBlockInputGetVal(block, 'link_label')
      link_id: this.taglineBlockInputGetVal(block, 'link_id')
      link_type: this.taglineBlockInputGetVal(block, 'link_type')
      link_external_url: this.taglineBlockInputGetVal(block, 'link_external_url')
      link_target_blank: this.taglineBlockInputGetVal(block, 'link_target_blank')
      link_no_follow: this.taglineBlockInputGetVal(block, 'link_no_follow')
      text: this.taglineBlockInputGetVal(block, 'text')

  taglineBlockResetForm: (block) ->
    this.taglineBlockInputSetVal block, 'link_version', block.link_version
    this.taglineBlockInputSetVal block, 'link_label', block.link_label
    this.taglineBlockInputSetVal block, 'link_id', block.link_id
    this.taglineBlockInputSetVal block, 'link_type', block.link_type
    this.taglineBlockInputSetVal block, 'link_external_url', block.link_external_url
    this.taglineBlockInputSetVal block, 'link_target_blank', block.link_target_blank
    this.taglineBlockInputSetVal block, 'link_no_follow', block.link_no_follow
    this.taglineBlockInputSetVal block, 'heading', block.heading
    this.taglineBlockInputSetVal block, 'text', block.text

  taglineBlockPrevTheme: (block) ->
    this.taglineBlockUpdate block, theme: this.prevItem(this.taglineBlockThemes, block.theme)

  taglineBlockNextTheme: (block) ->
    this.taglineBlockUpdate block, theme: this.nextItem(this.taglineBlockThemes, block.theme)

  # PRIVATE LEVEL 3

  taglineBlockSave: (changes, callback) ->
    updated = React.addons.update(this.state, taglineBlocks: changes)
    if typeof(callback) is 'function'
      this.setState updated, callback
    else
      this.setState updated

  taglineBlockInputGetVal: (block, name) ->
    $('#' + this.taglineBlockID(block, name)).val()

  taglineBlockInputSetVal: (block, name, value) ->
    $('#' + this.taglineBlockID(block, name)).val(value)

  taglineBlockThemes: ['left', 'center', 'contain']

window.TaglineBlocksHandlers = TaglineBlocksHandlers
