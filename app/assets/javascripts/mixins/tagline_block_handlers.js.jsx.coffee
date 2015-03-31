TaglineBlockHandlers =
  propTypes:
    initialTaglineBlock: React.PropTypes.object
    defaultTaglineBlockAttributes: React.PropTypes.object

  getInitialState: ->
    taglineBlock: this.taglineBlockInitial()

  taglineBlockInputs: ->
    if this.props.initialTaglineBlock and this.state.taglineBlock
      `<input key={this.taglineBlockName('id')} type="hidden" name={this.taglineBlockName('id')} value={this.props.initialTaglineBlock.id} />`
    else if this.props.initialTaglineBlock
      `<div>
        <input key={this.taglineBlockName('id')} type="hidden" name={this.taglineBlockName('id')} value={this.props.initialTaglineBlock.id} />
        <input key={this.taglineBlockName('_destroy')} type="hidden" name={this.taglineBlockName('_destroy')} value="1" />
      </div>`
    else
      `<div />`

  taglineBlockProps: ->
    if this.state.taglineBlock
      block: $.extend({}, this.state.taglineBlock, { editing: this.state.editing, dropZoneClassName: this.taglineBlockDropZoneClassName() })
      blockEditor: this.taglineBlockEditorProps()
      blockInputLink: this.taglineBlockInputLinkProps()
      blockInputText: this.taglineBlockInputTextProps()
      blockOptions: this.taglineBlockOptionsProps()
      blockInputsClassName: if this.state.taglineBlock and this.state.taglineBlock.displayImageLibrary then 'hide' else ''
      editing: this.state.editing
      name: this.taglineBlockName
    else
      blockAdd: this.taglineBlockAddProps()
      editing: this.state.editing

  # PRIVATE LEVEL 1

  taglineBlockInitial: ->
    if this.props.initialTaglineBlock
      $.extend {}, this.taglineBlockDefaultProps(), this.props.initialTaglineBlock

  taglineBlockID: (name) ->
    "tagline-block-attributes-#{name}"

  taglineBlockName: (name) ->
    "tagline_block_attributes[#{name}]"

  taglineBlockDropZoneClassName: ->
    'tagline-block-drop-zone'

  taglineBlockAddProps: ->
    visible: !this.state.taglineBlock
    onClick: this.taglineBlockAdd
    content: 'Add a Tagline Block'

  taglineBlockEditorProps: ->
    id: 'tagline-block-editor'
    title: 'Edit Tagline Block Details'
    swapForm: this.taglineBlockSwapForm
    resetForm: this.taglineBlockResetForm

  taglineBlockInputLinkProps: ->
    id: this.taglineBlockID
    name: this.taglineBlockName
    label: this.state.taglineBlock.link_label
    version: this.state.taglineBlock.link_version
    target_blank: this.state.taglineBlock.link_target_blank
    no_follow: this.state.taglineBlock.link_no_follow
    link_id: this.state.taglineBlock.link_id
    link_type: this.state.taglineBlock.link_type
    external_url: this.state.taglineBlock.link_external_url
    checkedNone: this.state.taglineBlock.link_version is 'link_none'
    checkedInternal: this.state.taglineBlock.link_version is 'link_internal'
    checkedExternal: this.state.taglineBlock.link_version is 'link_external'
    internalWebpages: this.props.internalWebpages

  taglineBlockInputTextProps: ->
    id: this.taglineBlockID('text')
    name: this.taglineBlockName('text')
    value: this.state.taglineBlock.text
    label: 'Text'
    rows: 4

  taglineBlockOptionsProps: ->
    visible: this.state.editing
    prev: this.taglineBlockPrevTheme
    next: this.taglineBlockNextTheme
    editorTarget: '#tagline-block-editor'
    editLabel: 'Edit Details'
    removeLabel: 'Remove Tagline Block'
    onRemove: this.taglineBlockRemove
    onEdit: this.taglineBlockEdit

  # PRIVATE LEVEL 2

  taglineBlockDefaultProps: ->
    link_target_blank: false
    link_no_follow: false
    displayImageLibrary: false
    text: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.
      Aenean ultricies ultrices mi eu maximus. Curabitur dignissim libero
      quis sem suscipit tristique. Nunc convallis lorem ut sagittis faucibus.'

  taglineBlockAdd: (event, callback) ->
    event.preventDefault() if event
    this.taglineBlockSave $set: $.extend({}, this.taglineBlockDefaultProps(), (this.props.defaultTaglineBlockAttributes or {})), callback

  taglineBlockEdit: ->

  taglineBlockUpdate: (attributes, event, callback) ->
    event.preventDefault() if event
    this.taglineBlockSave $merge: attributes, callback

  taglineBlockRemove: (event, callback) ->
    event.preventDefault() if event
    this.taglineBlockSave $set: null, callback

  taglineBlockSwapForm: () ->
    this.taglineBlockUpdate
      image_alt: this.taglineBlockInputGetVal('image_alt')
      image_title: this.taglineBlockInputGetVal('image_title')
      link_version: $("input[name=\"#{this.taglineBlockName('link_version')}\"]:checked").val()
      link_label: this.taglineBlockInputGetVal('link_label')
      link_id: this.taglineBlockInputGetVal('link_id')
      link_type: this.taglineBlockInputGetVal('link_type')
      link_external_url: this.taglineBlockInputGetVal('link_external_url')
      link_target_blank: this.taglineBlockInputGetVal('link_target_blank')
      link_no_follow: this.taglineBlockInputGetVal('link_no_follow')
      text: this.taglineBlockInputGetVal('text')

  taglineBlockResetForm: () ->
    this.taglineBlockInputSetVal 'link_version', this.state.taglineBlock.link_version
    this.taglineBlockInputSetVal 'link_label', this.state.taglineBlock.link_label
    this.taglineBlockInputSetVal 'link_id', this.state.taglineBlock.link_id
    this.taglineBlockInputSetVal 'link_type', this.state.taglineBlock.link_type
    this.taglineBlockInputSetVal 'link_external_url', this.state.taglineBlock.link_external_url
    this.taglineBlockInputSetVal 'link_target_blank', this.state.taglineBlock.link_target_blank
    this.taglineBlockInputSetVal 'link_no_follow', this.state.taglineBlock.link_no_follow
    this.taglineBlockInputSetVal 'heading', this.state.taglineBlock.heading
    this.taglineBlockInputSetVal 'text', this.state.taglineBlock.text

  taglineBlockPrevTheme: ->
    this.taglineBlockUpdate theme: this.prevItem(this.taglineBlockThemes, this.state.taglineBlock.theme)

  taglineBlockNextTheme: ->
    this.taglineBlockUpdate theme: this.nextItem(this.taglineBlockThemes, this.state.taglineBlock.theme)

  # PRIVATE LEVEL 3

  taglineBlockSave: (changes, callback) ->
    updated = React.addons.update(this.state, taglineBlock: changes)
    if typeof(callback) is 'function'
      this.setState updated, callback
    else
      this.setState updated

  taglineBlockInputGetVal: (name) ->
    $('#' + this.taglineBlockID(name)).val()

  taglineBlockInputSetVal: (name, value) ->
    $('#' + this.taglineBlockID(name)).val(value)

  taglineBlockThemes: ['left', 'center', 'contain']

window.TaglineBlockHandlers = TaglineBlockHandlers
