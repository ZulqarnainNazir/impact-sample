HeaderBlockHandlers =
  propTypes:
    initialHeaderBlock: React.PropTypes.object
    defaultHeaderBlockAttributes: React.PropTypes.object

  getInitialState: ->
    headerBlock: this.headerBlockInitial()

  headerBlockInputs: ->
    if this.props.initialHeaderBlock and this.state.headerBlock
      `<input key={this.headerBlockName('id')} type="hidden" name={this.headerBlockName('id')} value={this.props.initialHeaderBlock.id} />`
    else if this.props.initialHeaderBlock
      `<div>
        <input key={this.headerBlockName('id')} type="hidden" name={this.headerBlockName('id')} value={this.props.initialHeaderBlock.id} />
        <input key={this.headerBlockName('_destroy')} type="hidden" name={this.headerBlockName('_destroy')} value="1" />
      </div>`
    else
      `<div />`

  headerBlockProps: ->
    if this.state.headerBlock
      block: $.extend({}, this.state.headerBlock, { editing: this.state.editing })
      blockEditor: this.headerBlockEditorProps()
      blockInputStyle: this.headerBlockInputStyleProps()
      blockOptions: this.headerBlockOptionsProps()
      editing: this.state.editing
      name: this.headerBlockName
    else
      blockAdd: this.headerBlockAddProps()
      editing: this.state.editing

  # PRIVATE LEVEL 1

  headerBlockInitial: ->
    if this.props.initialHeaderBlock
      $.extend {}, this.headerBlockDefaultProps(), this.props.initialHeaderBlock

  headerBlockID: (name) ->
    "header-block-attributes-#{name}"

  headerBlockName: (name) ->
    "header_block_attributes[#{name}]"

  headerBlockAddProps: ->
    visible: !this.state.headerBlock
    onClick: this.headerBlockAdd
    content: 'Add a Header Block'

  headerBlockEditorProps: ->
    id: 'header-block-editor'
    title: 'Edit Header Block Details'
    swapForm: this.headerBlockSwapForm
    resetForm: this.headerBlockResetForm

  headerBlockInputStyleProps: ->
    id: this.headerBlockID('style')
    name: this.headerBlockName('style')
    value: this.state.headerBlock.style
    label: 'Navbar Style'
    options: [
      { value: 'light', label: 'Light', },
      { value: 'dark', label: 'Dark', },
    ]

  headerBlockOptionsProps: ->
    visible: this.state.editing
    prev: this.headerBlockPrevTheme
    next: this.headerBlockNextTheme
    editorTarget: '#header-block-editor'
    editLabel: 'Edit Details'
    onEdit: this.headerBlockEdit

  # PRIVATE LEVEL 2

  headerBlockDefaultProps: ->
    style: 'dark'

  headerBlockAdd: (event, callback) ->
    event.preventDefault() if event
    this.headerBlockSave $set: $.extend({}, this.headerBlockDefaultProps(), (this.props.defaultHeaderBlockAttributes or {})), callback

  headerBlockEdit: ->

  headerBlockUpdate: (attributes, event, callback) ->
    event.preventDefault() if event
    this.headerBlockSave $merge: attributes, callback

  headerBlockSwapForm: () ->
    this.headerBlockUpdate
      style: this.headerBlockInputGetVal('style')

  headerBlockResetForm: () ->
    this.headerBlockInputSetVal 'style', this.state.headerBlock.style

  headerBlockPrevTheme: ->
    this.headerBlockUpdate theme: this.prevItem(this.headerBlockThemes, this.state.headerBlock.theme)

  headerBlockNextTheme: ->
    this.headerBlockUpdate theme: this.nextItem(this.headerBlockThemes, this.state.headerBlock.theme)

  # PRIVATE LEVEL 3

  headerBlockSave: (changes, callback) ->
    updated = React.addons.update(this.state, headerBlock: changes)
    if typeof(callback) is 'function'
      this.setState updated, callback
    else
      this.setState updated

  headerBlockInputGetVal: (name) ->
    $('#' + this.headerBlockID(name)).val()

  headerBlockInputSetVal: (name, value) ->
    $('#' + this.headerBlockID(name)).val(value)

  headerBlockThemes: ['inline', 'center', 'justify', 'logo_above', 'logo_above_full_width', 'logo_below', 'logo_center']

window.HeaderBlockHandlers = HeaderBlockHandlers
