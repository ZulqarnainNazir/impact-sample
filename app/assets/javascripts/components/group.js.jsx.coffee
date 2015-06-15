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
    `<div className={this.groupClass()} data-uuid={this.props.uuid}>
      <div className="webpage-fields">
        <input type="hidden" name={this.inputName('id')} value={this.props.id} />
        <input type="hidden" name={this.inputName('type')} value={this.props.type} />
        <input type="hidden" name={this.inputName('kind')} value={this.props.kind} />
        <input type="hidden" name={this.inputName('max_blocks')} value={this.props.max_blocks} />
        <input type="hidden" name={this.inputName('position')} value={this.props.position} />
        {this.renderRemovedBlocksInputs()}
      </div>
      {this.renderMoveHandle()}
      {this.renderSidebarSwitcher()}
      {this.renderCallToActionSizeChanger()}
      {this.renderCallToActionAdder()}
      <div className={this.groupRowClass()}>
        {this.renderBlocks()}
      </div>
    </div>`

  renderRemovedBlocksInputs: ->
    for block in this.props.removedBlocks
      destroyName = "#{this.inputName('blocks_attributes')}[#{block.index}][_destroy]"
      idName = "#{this.inputName('blocks_attributes')}[#{block.index}][id]"
      `<div key={block.index}>
        <input type="hidden" name={destroyName} value="1" />
        <input type="hidden" name={idName} value={block.id} />
      </div>`

  groupClass: ->
    if this.props.sidebarPosition is 'left'
      if this.props.type is 'SidebarGroup'
        'webpage-group webpage-group-sidebar webpage-group-sidebar-left'
      else 'webpage-group webpage-group-basic webpage-group-basic-right'
    else
      if this.props.type is 'SidebarGroup'
        'webpage-group webpage-group-sidebar webpage-group-sidebar-right'
      else 'webpage-group webpage-group-basic webpage-group-basic-left'

  groupRowClass: ->
    switch this.props.type
      when 'CallToActionGroup'
        'webpage-group-horizontal-container row'
      when 'SidebarGroup'
        'webpage-group-vertical-container'
      else ''

  inputName: (name) ->
    "groups_attributes[#{this.props.uuid}][#{name}]"

  renderMoveHandle: ->
    if this.props.editing
      `<span className="fa fa-reorder webpage-group-sort-handle" />`

  renderSidebarSwitcher: ->
    if this.props.editing and this.props.type is 'SidebarGroup'
      `<span onClick={this.props.switchSidebarPosition} className="fa webpage-group-sidebar-handle" />`

  renderCallToActionSizeChanger: ->
    if this.props.editing and this.props.type is 'CallToActionGroup'
      `<strong onClick={this.props.updateGroup.bind(null, this.props.uuid, { max_blocks: this.nextMaxBlocksValue() })} className="webpage-group-call-to-action-size-handle">{this.props.max_blocks}x</strong>`

  renderCallToActionAdder: ->
    if this.props.editing and this.props.type is 'CallToActionGroup' and _.reject(this.props.blocks, (block) -> block is undefined).length < this.props.max_blocks
      `<strong onClick={this.props.insertBlock.bind(null, this.props.uuid, 'CallToActionBlock')} className="webpage-group-call-to-action-add-handle"><i className="fa fa-plus-circle" /></strong>`

  renderBlocks: ->
    if this.props.max_blocks
      _.map _.reject(this.props.blocks, (block) -> block is undefined).slice(0, this.props.max_blocks), this.renderBlock
    else
      _.map this.props.blocks, this.renderBlock

  renderBlock: (block) ->
    if block
      `<Block key={block.uuid} editing={this.props.editing} kind={this.props.kind} max_blocks={this.props.max_blocks} groupInputName={this.inputName('blocks_attributes')} {...block} />`

  nextMaxBlocksValue: ->
    if this.props.max_blocks is 3
      4
    else if this.props.max_blocks is 4
      2
    else
      3

window.Group = Group
