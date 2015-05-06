BlogPage = React.createClass
  propTypes:
    browserButtonsSrc: React.PropTypes.string.isRequired

  mixins: [
    PrevNext,
    FeedBlockHandlers,
    SidebarContentBlocksHandlers,
  ]

  getInitialState: ->
    editing: true
    sidebarPosition: if this.props.initialSidebarPosition is 'left' then 'left' else (if this.props.initialSidebarPosition is 'right' then 'right' else 'none')

  toggleEditing: ->
    this.setState editing: !this.state.editing

  styles: ->
    """
    .webpage-background,
    .webpage-feed,
    .webpage-sidebar-content,
    .webpage-sidebar-feed {
      background-color: #{this.props.defaultBackgroundColor};
      color: #{this.props.defaultForegroundColor};
    }
    .webpage-sidebar-content {
      color: #000;
    }
    .webpage-add {
      background-color: #{this.props.defaultBackgroundColor};
      border-color: #{this.props.defaultForegroundColor};
      color: #{this.props.defaultForegroundColor};
    }
    .webpage-background a,
    .webpage-feed a,
    .webpage-sidebar-content a,
    .webpage-sidebar-feed a {
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
            <input type="hidden" id="sidebar_position" name="sidebar_position" value={this.state.sidebarPosition} />
            {this.feedBlockInputs()}
            {this.sidebarContentBlocksInputs()}
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
      mainClass = 'col-sm-8'
      mainClass += ' pull-right' if this.state.sidebarPosition is 'left'

      `<div className="webpage-interior row clearfix" style={{position: 'relative'}}>
        <div key="main" className={mainClass}>
          <FeedBlock key="feed" {...this.feedBlockProps()} />
        </div>
        <div key="sidebar" className="col-sm-4">
          <SidebarContentBlocks key="sidebar_content" {...this.sidebarContentBlocksProps()} />
        </div>
      </div>`
    else
      `<div>
        <FeedBlock key="feed" {...this.feedBlockProps()} />
      </div>`

  updateSidebar: (position) ->
    this.setState sidebarPosition: position

  sidebarClass: (position) ->
    if this.state.sidebarPosition is position then 'btn btn-primary' else 'btn btn-default'

window.BlogPage = BlogPage
