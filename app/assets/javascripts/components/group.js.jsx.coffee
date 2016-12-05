Group = React.createClass
  propTypes:
    blocks: React.PropTypes.object
    editing: React.PropTypes.bool
    sidebarPosition: React.PropTypes.string
    switchSidebarPosition: React.PropTypes.func
    type: React.PropTypes.string
    updateGroup: React.PropTypes.func
    uuid: React.PropTypes.number

  componentDidMount: ->
    $(this.getDOMNode()).find('.webpage-group-popover').popover
      container: 'body'
      placement: 'top'
      trigger: 'hover'
      delay:
        show: 500
        hide: 0

  render: ->
    `<div className={this.groupClass()} data-uuid={this.props.uuid}>
      <div className="webpage-fields">
        <input type="hidden" name={this.inputName('id')} value={this.props.id} />
        <input type="hidden" name={this.inputName('type')} value={this.props.type} />
        <input type="hidden" name={this.inputName('kind')} value={this.props.kind} />
        <input type="hidden" name={this.inputName('height')} value={this.props.height} />
        <input type="hidden" name={this.inputName('max_blocks')} value={this.props.max_blocks} />
        <input type="hidden" name={this.inputName('position')} value={this.props.position} />
        <input type="hidden" name={this.inputName('hero_position')} value={this.props.hero_position} />
        <input type="hidden" name={this.inputName('custom_class')} value={this.props.custom_class} />
        {this.renderRemovedBlocksInputs()}
      </div>
      {this.renderMoveHandle()}
      {this.renderCustomHandle()}
      {this.renderSidebarSwitcher()}
      {this.renderCallToActionSizeChanger()}
      {this.renderHeroToggles()}
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

  renderCustomHandle: ->
    if this.props.editing
      `<span onClick={this.props.editCustomGroup.bind(null, this.props.uuid)} className="fa fa-cog webpage-group-custom-handle" />`

  renderSidebarSwitcher: ->
    if this.props.editing and this.props.type is 'SidebarGroup'
      `<span onClick={this.props.switchSidebarPosition} className="fa webpage-group-sidebar-handle" />`

  renderCallToActionSizeChanger: ->
    if this.props.editing and this.props.type is 'CallToActionGroup'
      `<strong onClick={this.props.updateGroup.bind(null, this.props.uuid, { max_blocks: this.nextMaxBlocksValue() })} className="webpage-group-call-to-action-size-handle">{this.props.max_blocks}x</strong>`

  renderHeroToggles: ->
    if this.props.editing and this.props.type is 'HeroGroup'
      `<span className="webpage-group-hero-handles">
	{this.renderHeroSwitchers()}
        {this.renderHeroAdder()}
      </span>`

  renderHeroSwitchers: ->
    blocks = _.reject(this.props.blocks, (block) -> block is undefined)
    if Object.keys(blocks).length > 1
      _.map _.sortBy(_.reject(this.props.blocks, (block) -> block is undefined), 'position'), this.renderHeroSwitcher

  renderHeroSwitcher: (block) ->
    if this.props.current_block is block.uuid
      `<span onClick={this.props.updateGroup.bind(null, this.props.uuid, { current_block: block.uuid })} className="fa fa-square webpage-group-hero-switch-handle" data-uuid={block.uuid} key={block.uuid} />`
    else
      `<span onClick={this.props.updateGroup.bind(null, this.props.uuid, { current_block: block.uuid })} className="fa fa-square-o webpage-group-hero-switch-handle webpage-group-popover" data-content="Click to edit this slide" data-uuid={block.uuid} key={block.uuid} />`

  renderHeroAdder: ->
    blocksLength = Object.keys(_.reject(this.props.blocks, (block) -> block is undefined)).length

    if blocksLength is 1
      `<span onClick={this.props.insertBlock.bind(null, this.props.uuid, 'HeroBlock')} className="fa fa-plus-square-o webpage-group-hero-add-handle webpage-group-popover" data-content="Click to turn hero into rotating carousel" />`
    else if blocksLength < 6
      `<span onClick={this.props.insertBlock.bind(null, this.props.uuid, 'HeroBlock')} className="fa fa-plus-square-o webpage-group-hero-add-handle webpage-group-popover" data-content="Click to add slide to carousel" />`

  renderBlocks: ->
    if this.props.max_blocks
      _.map _.sortBy(_.reject(this.props.blocks, (block) -> block is undefined).slice(0, this.props.max_blocks), 'position'), this.renderBlock
    else
      _.map _.sortBy(this.props.blocks, 'position'), this.renderBlock

  renderBlock: (block) ->
    if block
      `<Block key={block.uuid} custom_class={this.props.custom_class} editing={this.props.editing} kind={this.props.kind} current_block={this.props.current_block} groupHeight={this.props.height} max_blocks={this.props.max_blocks} groupInputName={this.inputName('blocks_attributes')} contents_path={this.props.contents_path} reviews_path={this.props.reviews_path} {...block} />`

  nextMaxBlocksValue: ->
    if this.props.max_blocks is 3
      4
    else if this.props.max_blocks is 4
      2
    else
      3

window.Group = Group
