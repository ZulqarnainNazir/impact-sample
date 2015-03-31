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
      block: $.extend({}, this.state.headerBlock, { editing: this.state.editing, dropZoneClassName: this.headerBlockDropZoneClassName() })
      blockOptions: this.headerBlockOptionsProps()
      name: this.headerBlockName

  # PRIVATE LEVEL 1

  headerBlockInitial: ->
    if this.props.initialHeaderBlock
      $.extend {}, this.headerBlockDefaultProps(), this.props.initialHeaderBlock

  headerBlockID: (name) ->
    "header-block-attributes-#{name}"

  headerBlockName: (name) ->
    "header_block_attributes[#{name}]"

  headerBlockDropZoneClassName: ->
    'header-block-drop-zone'

  headerBlockOptionsProps: ->
    visible: this.state.editing
    prev: this.headerBlockPrevTheme
    next: this.headerBlockNextTheme
    editorTarget: '#header-block-editor'
    editLabel: 'Edit Details'
    removeLabel: 'Remove Header Block'

  # PRIVATE LEVEL 2

  headerBlockDefaultProps: ->
    {}

  headerBlockUpdate: (attributes, event, callback) ->
    event.preventDefault() if event
    this.headerBlockSave $merge: attributes, callback

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

  headerBlockThemes: ['inline', 'center', 'justify', 'logo_above', 'logo_above_full_width', 'logo_below', 'logo_center']

window.HeaderBlockHandlers = HeaderBlockHandlers
