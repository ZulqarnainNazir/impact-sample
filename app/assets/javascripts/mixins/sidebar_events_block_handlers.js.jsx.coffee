SidebarEventsBlockHandlers =
  propTypes:
    initialSidebarEventsBlock: React.PropTypes.object

  getInitialState: ->
    sidebarEventsBlock: this.sidebarEventsBlockInitial()

  sidebarEventsBlockInputs: ->
    if this.props.initialSidebarEventsBlock and this.state.sidebarEventsBlock
      `<input key={this.sidebarEventsBlockName('id')} type="hidden" name={this.sidebarEventsBlockName('id')} value={this.props.initialSidebarEventsBlock.id} />`
    else if this.props.initialSidebarEventsBlock
      `<div>
        <input key={this.sidebarEventsBlockName('id')} type="hidden" name={this.sidebarEventsBlockName('id')} value={this.props.initialSidebarEventsBlock.id} />
        <input key={this.sidebarEventsBlockName('_destroy')} type="hidden" name={this.sidebarEventsBlockName('_destroy')} value="1" />
      </div>`
    else
      `<div />`

  sidebarEventsBlockProps: ->
    if this.state.sidebarEventsBlock
      block: $.extend({}, this.state.sidebarEventsBlock, { editing: this.state.editing })
      blockEditor: this.sidebarEventsBlockEditorProps()
      blockInputItemsLimit: this.sidebarEventsBlockInputItemsLimitProps()
      blockOptions: this.sidebarEventsBlockOptionsProps()
      editing: this.state.editing
      name: this.sidebarEventsBlockName
      id: this.sidebarEventsBlockID
    else
      blockAdd: this.sidebarEventsBlockAddProps()
      editing: this.state.editing

  # PRIVATE LEVEL 1

  sidebarEventsBlockInitial: ->
    if this.props.initialSidebarEventsBlock
      $.extend {}, this.sidebarEventsBlockDefaultProps(), this.props.initialSidebarEventsBlock

  sidebarEventsBlockID: (name) ->
    "sidebar-events-block-attributes-#{name}"

  sidebarEventsBlockName: (name) ->
    "sidebar_events_block_attributes[#{name}]"

  sidebarEventsBlockAddProps: ->
    visible: !this.state.sidebarEventsBlock
    onClick: this.sidebarEventsBlockAdd
    content: 'Add Sidebar Events Block'

  sidebarEventsBlockEditorProps: ->
    id: 'sidebar-events-block-editor'
    title: 'Edit Events Block Details'
    swapForm: this.sidebarEventsBlockSwapForm
    resetForm: this.sidebarEventsBlockResetForm

  sidebarEventsBlockInputItemsLimitProps: ->
    id: this.sidebarEventsBlockID('items_limit')
    name: this.sidebarEventsBlockName('items_limit')
    value: this.state.sidebarEventsBlock.items_limit
    label: 'Items Limit'

  sidebarEventsBlockOptionsProps: ->
    visible: this.state.editing
    editorTarget: '#sidebar-events-block-editor'
    editLabel: 'Edit Details'
    removeLabel: 'Remove Events Block'
    onRemove: this.sidebarEventsBlockRemove
    onEdit: this.sidebarEventsBlockEdit

  # PRIVATE LEVEL 2

  sidebarEventsBlockDefaultProps: ->
    items_limit: 3

  sidebarEventsBlockAdd: (event, callback) ->
    event.preventDefault() if event
    this.sidebarEventsBlockSave $set: $.extend({}, this.sidebarEventsBlockDefaultProps(), (this.props.defaultSidebarEventsBlockAttributes or {})), callback

  sidebarEventsBlockEdit: ->

  sidebarEventsBlockUpdate: (attributes, event, callback) ->
    event.preventDefault() if event
    this.sidebarEventsBlockSave $merge: attributes, callback

  sidebarEventsBlockRemove: (event, callback) ->
    event.preventDefault() if event
    this.sidebarEventsBlockSave $set: null, callback

  sidebarEventsBlockSwapForm: () ->
    this.sidebarEventsBlockUpdate
      items_limit: this.sidebarEventsBlockInputGetVal('items_limit')

  sidebarEventsBlockResetForm: () ->
    this.sidebarEventsBlockInputSetVal 'items_limit', this.state.sidebarEventsBlock.items_limit

  # PRIVATE LEVEL 3

  sidebarEventsBlockSave: (changes, callback) ->
    updated = React.addons.update(this.state, sidebarEventsBlock: changes)
    if typeof(callback) is 'function'
      this.setState updated, callback
    else
      this.setState updated

  sidebarEventsBlockInputGetVal: (name) ->
    $('#' + this.sidebarEventsBlockID(name)).val()

  sidebarEventsBlockInputSetVal: (name, value) ->
    $('#' + this.sidebarEventsBlockID(name)).val(value)

window.SidebarEventsBlockHandlers = SidebarEventsBlockHandlers
