Block = React.createClass
  propTypes:
    editing: React.PropTypes.bool
    removeBlock: React.PropTypes.func
    type: React.PropTypes.string

  render: ->
    `<div className="webpage-block">
      {this.renderBlockOptions()}
      {this.renderBlock()}
    </div>`

  renderBlockOptions: ->
    if this.props.editing
      `<div className="webpage-options btn-group btn-group-sm" style={{opacity: 0.8}}>
        {this.renderPrevThemeOption()}
        {this.renderEditTextOption()}
        {this.renderEditMediaOption()}
        {this.renderEditLinkOption()}
        {this.renderRemoveBlockOption()}
        {this.renderNextThemeOption()}
      </div>`

  renderPrevThemeOption: ->
    if this.props.prevTheme
      `<a href="#" onClick={this.props.prevTheme} className="btn btn-warning"><i className="fa fa-caret-left" /></a>`

  renderEditTextOption: ->
    if this.props.editText
      `<a href="#" onClick={this.props.editText} className="btn btn-warning"><i className="fa fa-pencil" /></a>`

  renderEditMediaOption: ->
    if this.props.editMedia
      `<a href="#" onClick={this.props.editMedia} className="btn btn-warning"><i className="fa fa-photo" /></a>`

  renderEditLinkOption: ->
    if this.props.editLink
      `<a href="#" onClick={this.props.editLink} className="btn btn-warning"><i className="fa fa-link" /></a>`

  renderRemoveBlockOption: ->
    if this.props.removeBlock
      `<a href="#" onClick={this.props.removeBlock} className="btn btn-warning"><i className="fa fa-trash" /></a>`

  renderNextThemeOption: ->
    if this.props.nextTheme
      `<a href="#" onClick={this.props.nextTheme} className="btn btn-warning"><i className="fa fa-caret-right" /></a>`

  renderBlock: ->
    switch this.props.type
      when 'hero'
        `<HeroBlockContent {...this.props} />`
      when 'tagline'
        `<TaglineBlockContent {...this.props} />`
      when 'call_to_action'
        `<CallToActionBlockContent {...this.props} />`
      when 'specialty'
        `<SpecialtyBlockContent {...this.props} />`
      when 'content'
        `<ContentBlockContent {...this.props} />`
      when 'blog_feed'
        `<BlogFeedBlockContent {...this.props} />`
      when 'sidebar_content'
        `<SidebarContentBlockContent {...this.props} />`
      when 'sidebar_blog_feed'
        `<SidebarBlogFeedBlockContent {...this.props} />`
      when 'sidebar_events_feed'
        `<SidebarEventsFeedBlockContent {...this.props} />`

window.Block = Block
