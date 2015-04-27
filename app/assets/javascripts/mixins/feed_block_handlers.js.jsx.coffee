FeedBlockHandlers =
  propTypes:
    initialFeedBlock: React.PropTypes.object

  getInitialState: ->
    feedBlock: this.feedBlockInitial()

  feedBlockInputs: ->
    if this.props.initialFeedBlock and this.state.feedBlock
      `<input key={this.feedBlockName('id')} type="hidden" name={this.feedBlockName('id')} value={this.props.initialFeedBlock.id} />`
    else if this.props.initialFeedBlock
      `<div>
        <input key={this.feedBlockName('id')} type="hidden" name={this.feedBlockName('id')} value={this.props.initialFeedBlock.id} />
        <input key={this.feedBlockName('_destroy')} type="hidden" name={this.feedBlockName('_destroy')} value="1" />
      </div>`
    else
      `<div />`

  feedBlockProps: ->
    if this.props.blog and this.state.feedBlock
      block: $.extend({}, this.state.feedBlock, { editing: this.state.editing })
      blockEditor: this.feedBlockEditorProps()
      blockInputItemsLimit: this.feedBlockInputItemsLimitProps()
      blockOptions: this.feedBlockOptionsProps()
      editing: this.state.editing
      name: this.feedBlockName
    else
      blockAdd: this.feedBlockAddProps()
      editing: this.state.editing
      blog: this.props.blog
      blogPath: this.props.blogPath

  # PRIVATE LEVEL 1

  feedBlockInitial: ->
    if this.props.initialFeedBlock
      $.extend {}, this.feedBlockDefaultProps(), this.props.initialFeedBlock

  feedBlockID: (name) ->
    "feed-block-attributes-#{name}"

  feedBlockName: (name) ->
    "feed_block_attributes[#{name}]"

  feedBlockAddProps: ->
    visible: !this.state.feedBlock
    onClick: this.feedBlockAdd
    content: 'Add an Feed Block'

  feedBlockEditorProps: ->
    id: 'feed-block-editor'
    title: 'Edit Feed Block Details'
    swapForm: this.feedBlockSwapForm
    resetForm: this.feedBlockResetForm

  feedBlockInputItemsLimitProps: ->
    id: this.feedBlockID('items_limit')
    name: this.feedBlockName('items_limit')
    value: this.state.feedBlock.items_limit
    label: 'Items Limit'
    min: 2
    max: 20

  feedBlockOptionsProps: ->
    visible: this.state.editing
    editorTarget: '#feed-block-editor'
    editLabel: 'Edit Details'
    removeLabel: 'Remove Feed Block'
    onRemove: this.feedBlockRemove
    onEdit: this.feedBlockEdit

  # PRIVATE LEVEL 2

  feedBlockDefaultProps: ->
    items_limit: 10

  feedBlockAdd: (event, callback) ->
    event.preventDefault() if event
    this.feedBlockSave $set: $.extend({}, this.feedBlockDefaultProps(), (this.props.defaultFeedBlockAttributes or {})), callback

  feedBlockEdit: ->

  feedBlockUpdate: (attributes, event, callback) ->
    event.preventDefault() if event
    this.feedBlockSave $merge: attributes, callback

  feedBlockRemove: (event, callback) ->
    event.preventDefault() if event
    this.feedBlockSave $set: null, callback

  feedBlockSwapForm: () ->
    this.feedBlockUpdate
      items_limit: this.feedBlockInputGetVal('items_limit')

  feedBlockResetForm: () ->
    this.feedBlockInputSetVal 'items_limit', this.state.feedBlock.items_limit

  # PRIVATE LEVEL 3

  feedBlockSave: (changes, callback) ->
    updated = React.addons.update(this.state, feedBlock: changes)
    if typeof(callback) is 'function'
      this.setState updated, callback
    else
      this.setState updated

  feedBlockInputGetVal: (name) ->
    $('#' + this.feedBlockID(name)).val()

  feedBlockInputSetVal: (name, value) ->
    $('#' + this.feedBlockID(name)).val(value)

window.FeedBlockHandlers = FeedBlockHandlers
