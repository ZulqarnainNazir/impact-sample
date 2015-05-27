HomePage = React.createClass
  propTypes:
    browserButtonsSrc: React.PropTypes.string.isRequired

  mixins: [
    PrevNext,
    HeroBlockHandlers,
    TaglineBlocksHandlers,
    CallToActionBlocksHandlers,
    SpecialtyBlocksHandlers,
    ContentBlocksHandlers,
    FeedBlockHandlers,
    SidebarContentBlocksHandlers,
    SidebarFeedBlockHandlers,
    SidebarEventsBlockHandlers,
  ]

  getInitialState: ->
    editing: true
    blockTypeOrder: this.props.initialBlockTypeOrder
    sidebarPosition: if this.props.initialSidebarPosition is 'left' then 'left' else (if this.props.initialSidebarPosition is 'right' then 'right' else 'none')

  componentDidMount: ->
    this.enableSortable()
    this.enableBlockSortables()
    this.sortBlockTypes()
    this.sortBlockSets()

  disableSortable: ->
    $('.webpage-sortable').sortable('destroy')

  enableSortable: ->
    $('.webpage-sortable').sortable
      axis: 'y'
      container: '.webpage-sortable'
      expandOnHover: 400
      forceHelperSize: true
      forcePlaceholderSize: true
      handle: '.webpage-container-handle'
      helper: 'clone'
      items: '> div'
      opacity: 0.5
      placeholder: 'placeholder'
      revert: 100
      startCollapsed: false
      tabSize: 20
      tolerance: 'pointer'
      update: this.sortBlockTypes

  enableBlockSortables: ->
    $('.block-sortable').sortable
      container: '.block-sortable'
      expandOnHover: 400
      forceHelperSize: true
      forcePlaceholderSize: true
      handle: '.webpage-block-options-handle'
      helper: 'clone'
      items: '> div'
      opacity: 0.5
      placeholder: 'placeholder'
      revert: 100
      startCollapsed: false
      tabSize: 20
      tolerance: 'pointer'
      update: this.sortBlockSets

  sortBlockTypes: ->
    this.setState blockTypeOrder: this.blockTypeOrder().join(',')

  sortBlockSets: ->
    $('.block-sortable').each this.sortBlocks

  sortBlocks: (index, set) ->
    $(set).children().each this.sortBlock

  sortBlock: (index, block) ->
    $(block).find('input[name*="position"]').val(index)

  blockTypeOrder: ->
    order = $('.webpage-sortable > div').map -> $(this).data().type
    order.push('hero') unless 'hero' in order
    order.push('tagline') unless 'tagline' in order
    order.push('call_to_action') unless 'call_to_action' in order
    order.push('specialty') unless 'specialty' in order
    order.push('content') unless 'content' in order
    order.push('feed') unless 'feed' in order
    order.push('interior') unless 'interior' in order
    order.get()

  toggleEditing: ->
    this.setState editing: !this.state.editing

  styles: ->
    """
    .webpage-background,
    .webpage-hero,
    .webpage-tagline,
    .webpage-call-to-action,
    .webpage-specialty,
    .webpage-content,
    .webpage-feed,
    .webpage-sidebar-content,
    .webpage-sidebar-feed,
    .webpage-sidebar-events {
      background-color: #{this.props.defaultBackgroundColor};
      color: #{this.props.defaultForegroundColor};
    }
    .webpage-hero,
    .webpage-call-to-action,
    .webpage-sidebar-content {
      color: #000;
    }
    .webpage-add {
      background-color: #{this.props.defaultBackgroundColor};
      border-color: #{this.props.defaultForegroundColor};
      color: #{this.props.defaultForegroundColor};
    }
    .webpage-background a,
    .webpage-hero a,
    .webpage-tagline a,
    .webpage-call-to-action a,
    .webpage-specialty a,
    .webpage-content a,
    .webpage-feed a,
    .webpage-sidebar-content a,
    .webpage-sidebar-feed a,
    .webpage-sidebar-events a {
      color: #{this.props.defaultLinkColor};
    }
    """

  render: ->
    `<div>
      <style dangerouslySetInnerHTML={{__html: this.styles()}} />
      <BrowserPanel browserButtonsSrc={this.props.browserButtonsSrc} toggleEditing={this.toggleEditing} editing={this.state.editing}>
        <div className="panel-body" style={{position: 'relative'}}>
          <div className="webpage-background" style={{position: 'absolute', top: 0, right: 0, bottom: 0, left: 0, zIndex: 0}} />
          <div className="webpage-sortable">
            {this.renderBlocks()}
          </div>
          <div className="webpage-fields">
            <input type="hidden" id="block_type_order" name="block_type_order" value={this.state.blockTypeOrder} />
            <input type="hidden" id="call_to_action_blocks_per_row" name="call_to_action_blocks_per_row" value={this.state.callToActionBlocksPerRow} />
            <input type="hidden" id="sidebar_position" name="sidebar_position" value={this.state.sidebarPosition} />
            {this.heroBlockInputs()}
            {this.taglineBlocksInputs()}
            {this.callToActionBlocksInputs()}
            {this.specialtyBlocksInputs()}
            {this.contentBlocksInputs()}
            {this.feedBlockInputs()}
            {this.sidebarContentBlocksInputs()}
            {this.sidebarFeedBlockInputs()}
            {this.sidebarEventsBlockInputs()}
          </div>
        </div>
        <div className="panel-footer clearfix">
          <div className="checkbox pull-right" style={{margin: 0}}>
            <label>
              <input type="checkbox" checked={this.state.editing} onChange={this.toggleEditing} />
              Display Editing Dialogs?
            </label>
          </div>
          <div className="pull-left">
            <span className="small" style={{marginRight: 10}}>Sidebar Position</span>
            <div className="btn-group btn-group-xs">
              <span onClick={this.updateSidebar.bind(null, 'left')} className={this.sidebarClass('left')}>Left</span>
              <span onClick={this.updateSidebar.bind(null, 'none')} className={this.sidebarClass('none')}>None</span>
              <span onClick={this.updateSidebar.bind(null, 'right')} className={this.sidebarClass('right')}>Right</span>
            </div>
          </div>
        </div>
      </BrowserPanel>
    </div>`

  renderBlocks: ->
    if this.state.sidebarPosition is 'left' or this.state.sidebarPosition is 'right'
      this.state.blockTypeOrder.split(',').map this.renderBlockSidebar
    else
      this.state.blockTypeOrder.split(',').map this.renderBlock

  renderBlock: (type) ->
    switch type
      when 'hero'
        `<HeroBlock key="hero" {...this.heroBlockProps()} />`
      when 'tagline'
        `<TaglineBlocks key="tagline" {...this.taglineBlocksProps()} />`
      when 'call_to_action'
        `<CallToActionBlocks key="call_to_action" {...this.callToActionBlocksProps()} />`
      when 'specialty'
        `<SpecialtyBlocks key="specialty" {...this.specialtyBlocksProps()} />`
      when 'content'
        `<ContentBlocks key="content" {...this.contentBlocksProps()} />`
      when 'feed'
        `<FeedBlock key="feed" {...this.feedBlockProps()} />`

  renderBlockSidebar: (type) ->
    switch type
      when 'hero'
        `<HeroBlock key="hero" {...this.heroBlockProps()} />`
      when 'tagline'
        `<TaglineBlocks key="tagline" {...this.taglineBlocksProps()} />`
      when 'call_to_action'
        `<CallToActionBlocks key="call_to_action" {...this.callToActionBlocksProps()} />`
      when 'specialty'
        `<SpecialtyBlocks key="specialty" {...this.specialtyBlocksProps()} />`
      when 'interior'
        mainClass = 'col-sm-8'
        mainClass += ' pull-right' if this.state.sidebarPosition is 'left'

        `<div key="interior" className="webpage-interior row clearfix" data-type="interior" style={{position: 'relative'}}>
          <i className="fa fa-reorder webpage-container-handle" />
          <div key="main" className={mainClass}>
            <ContentBlocks key="content" {...this.contentBlocksProps()} />
            <FeedBlock key="feed" {...this.feedBlockProps()} />
          </div>
          <div key="sidebar" className="col-sm-4">
            <SidebarContentBlocks key="sidebar_content" {...this.sidebarContentBlocksProps()} />
            <SidebarFeedBlock key="sidebar_feed" {...this.sidebarFeedBlockProps()} />
            <SidebarEventsBlock key="sidebar_events" {...this.sidebarEventsBlockProps()} />
          </div>
        </div>`

  updateSidebar: (position) ->
    this.disableSortable()
    this.setState sidebarPosition: position, this.completeSidebar.bind(null, position)

  completeSidebar: (position) ->
    if position is 'left' or position is 'right'
      $('.webpage-sortable > .webpage-container[data-type="content"]').remove()
      $('.webpage-sortable > .webpage-container[data-type="feed"]').remove()
    this.enableSortable()

  sidebarClass: (position) ->
    if this.state.sidebarPosition is position then 'btn btn-primary' else 'btn btn-default'

window.HomePage = HomePage
