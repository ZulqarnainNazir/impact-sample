SidebarFeedBlockHandlers =
  propTypes:
    initialSidebarFeedBlock: React.PropTypes.object

  getInitialState: ->
    sidebarFeedBlock: this.sidebarFeedBlockInitial()

  sidebarFeedBlockInputs: ->
    if this.props.initialSidebarFeedBlock and this.state.sidebarFeedBlock
      `<input key={this.sidebarFeedBlockName('id')} type="hidden" name={this.sidebarFeedBlockName('id')} value={this.props.initialSidebarFeedBlock.id} />`
    else if this.props.initialSidebarFeedBlock
      `<div>
        <input key={this.sidebarFeedBlockName('id')} type="hidden" name={this.sidebarFeedBlockName('id')} value={this.props.initialSidebarFeedBlock.id} />
        <input key={this.sidebarFeedBlockName('_destroy')} type="hidden" name={this.sidebarFeedBlockName('_destroy')} value="1" />
      </div>`
    else
      `<div />`

  sidebarFeedBlockProps: ->
    if this.state.sidebarFeedBlock
      block: $.extend({}, this.state.sidebarFeedBlock, { editing: this.state.editing })
      blockEditor: this.sidebarFeedBlockEditorProps()
      blockInputItemsLimit: this.sidebarFeedBlockInputItemsLimitProps()
      blockOptions: this.sidebarFeedBlockOptionsProps()
      editing: this.state.editing
      name: this.sidebarFeedBlockName
      id: this.sidebarFeedBlockID
    else
      blockAdd: this.sidebarFeedBlockAddProps()
      editing: this.state.editing

  # PRIVATE LEVEL 1

  sidebarFeedBlockInitial: ->
    if this.props.initialSidebarFeedBlock
      $.extend {}, this.sidebarFeedBlockDefaultProps(), this.props.initialSidebarFeedBlock

  sidebarFeedBlockID: (name) ->
    "sidebar-feed-block-attributes-#{name}"

  sidebarFeedBlockName: (name) ->
    "sidebar_feed_block_attributes[#{name}]"

  sidebarFeedBlockAddProps: ->
    visible: !this.state.sidebarFeedBlock
    onClick: this.sidebarFeedBlockAdd
    content: 'Add a Sidebar Feed'

  sidebarFeedBlockEditorProps: ->
    id: 'sidebar-feed-block-editor'
    title: 'Edit Feed Block Details'
    swapForm: this.sidebarFeedBlockSwapForm
    resetForm: this.sidebarFeedBlockResetForm

  sidebarFeedBlockInputItemsLimitProps: ->
    id: this.sidebarFeedBlockID('items_limit')
    name: this.sidebarFeedBlockName('items_limit')
    value: this.state.sidebarFeedBlock.items_limit
    label: 'Items Limit'

  sidebarFeedBlockOptionsProps: ->
    visible: this.state.editing
    editorTarget: '#sidebar-feed-block-editor'
    editLabel: 'Edit Details'
    removeLabel: 'Remove Feed Block'
    onRemove: this.sidebarFeedBlockRemove
    onEdit: this.sidebarFeedBlockEdit

  # PRIVATE LEVEL 2

  sidebarFeedBlockDefaultProps: ->
    items_limit: 3

  sidebarFeedBlockAdd: (event, callback) ->
    event.preventDefault() if event
    this.sidebarFeedBlockSave $set: $.extend({}, this.sidebarFeedBlockDefaultProps(), (this.props.defaultSidebarFeedBlockAttributes or {})), callback

  sidebarFeedBlockEdit: ->

  sidebarFeedBlockUpdate: (attributes, event, callback) ->
    event.preventDefault() if event
    this.sidebarFeedBlockSave $merge: attributes, callback

  sidebarFeedBlockRemove: (event, callback) ->
    event.preventDefault() if event
    this.sidebarFeedBlockSave $set: null, callback

  sidebarFeedBlockSwapForm: () ->
    this.sidebarFeedBlockUpdate
      items_limit: this.sidebarFeedBlockInputGetVal('items_limit')

  sidebarFeedBlockResetForm: () ->
    this.sidebarFeedBlockInputSetVal 'items_limit', this.state.sidebarFeedBlock.items_limit

  # PRIVATE LEVEL 3

  sidebarFeedBlockSave: (changes, callback) ->
    updated = React.addons.update(this.state, sidebarFeedBlock: changes)
    if typeof(callback) is 'function'
      this.setState updated, callback
    else
      this.setState updated

  sidebarFeedBlockInputGetVal: (name) ->
    $('#' + this.sidebarFeedBlockID(name)).val()

  sidebarFeedBlockInputSetVal: (name, value) ->
    $('#' + this.sidebarFeedBlockID(name)).val(value)

window.SidebarFeedBlockHandlers = SidebarFeedBlockHandlers
