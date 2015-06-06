Group = React.createClass
  propTypes:
    blocks: React.PropTypes.object
    editing: React.PropTypes.bool
    sidebarPosition: React.PropTypes.string
    switchSidebarPosition: React.PropTypes.func
    type: React.PropTypes.string
    updateGroup: React.PropTypes.func
    uuid: React.PropTypes.number

  render: ->
    `<div className={this.groupClass()}>
      {this.renderMoveHandle()}
      {this.renderSidebarSwitcher()}
      {this.renderCallToActionSizeChanger()}
      {this.renderCallToActionAdder()}
      <div className="webpage-blocks">
        {this.renderBlocks()}
      </div>
    </div>`

  groupClass: ->
    if this.props.sidebarPosition is 'left'
      if this.props.type is 'sidebar'
        'webpage-group webpage-group-sidebar webpage-group-sidebar-left'
      else
        'webpage-group webpage-group-basic webpage-group-basic-right'
    else
      if this.props.type is 'sidebar'
        'webpage-group webpage-group-sidebar webpage-group-sidebar-right'
      else
        'webpage-group webpage-group-basic webpage-group-basic-left'

  renderMoveHandle: ->
    if this.props.editing
      `<span className="fa fa-reorder webpage-group-handle" />`

  renderSidebarSwitcher: ->
    if this.props.editing and this.props.type is 'sidebar'
      `<span onClick={this.props.switchSidebarPosition} className="fa webpage-group-sidebar-handle" />`

  renderCallToActionSizeChanger: ->
    if this.props.editing and this.props.type is 'call_to_action'
      `<strong onClick={this.props.updateGroup.bind(null, this.props.uuid, { maxBlocks: this.nextMaxBlocksValue() })} className="webpage-group-call-to-action-size-handle">{this.props.maxBlocks}x</strong>`

  renderCallToActionAdder: ->
    if this.props.editing and this.props.type is 'call_to_action' and _.reject(this.props.blocks, (block) -> block is undefined).length < this.props.maxBlocks
      `<strong onClick={this.props.insertBlock.bind(null, this.props.uuid, 'call_to_action')} className="webpage-group-call-to-action-add-handle"><i className="fa fa-plus-circle" /></strong>`

  renderBlocks: ->
    if this.props.maxBlocks
      _.map _.reject(this.props.blocks, (block) -> block is undefined).slice(0, this.props.maxBlocks), this.renderBlock
    else
      _.map this.props.blocks, this.renderBlock

  renderBlock: (block) ->
    if block
      if block.type is 'call_to_action'
        `<div key={block.uuid} className={this.callToActionColumnClass()}><Block editing={this.props.editing} {...block} /></div>`
      else
        `<Block key={block.uuid} editing={this.props.editing} {...block} />`

  nextMaxBlocksValue: ->
    if this.props.maxBlocks is 3
      4
    else if this.props.maxBlocks is 4
      2
    else
      3

  callToActionColumnClass: ->
    if this.props.maxBlocks is 2
      'webpage-block-col-6'
    else if this.props.maxBlocks is 4
      'webpage-block-col-3'
    else
      'webpage-block-col-4'

window.Group = Group
