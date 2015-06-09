SidebarContentBlockContent = React.createClass
  mixins: [BackgroundImageCSS]

  render: ->
    `<div className="webpage-sidebar-content">
      <div className="panel panel-default">
        <div className="panel-body">
          {this.renderHeading()}
          {this.renderImage()}
          {this.renderText()}
          {this.renderButton()}
        </div>
      </div>
    </div>`

  renderHeading: ->
    `<h4 className="text-center">
      <RichTextEditor enabled={this.props.editing && this.props.richText} html={this.props.heading} inline={true} update={this.props.updateHeading} />
    </h4>`

  renderImage: ->
    if this.props.image_placement_kind is 'embeds'
     `<div key="imageEmbed" style={{overflow: 'hidden'}} dangerouslySetInnerHTML={{__html: this.props.image_placement_embed}} />`
    else if this.props.image_url and this.props.image_url.length > 0
      `<img className="thumbnail img-responsive" style={{width: '100%'}} src={this.props.image_url} alt={this.props.image_alt} title={this.props.image_title} />`
    else if this.props.editing
      `<div>
        <ImageEmpty />
      </div>`

  renderText: ->
    `<RichTextEditor enabled={this.props.editing && this.props.richText} html={this.props.text} update={this.props.updateText} />`

  renderButton: ->
    if this.props.link_version != 'link_none' and this.props.link_label and this.props.link_label.length > 0
      `<p><a className="btn btn-primary btn-lg" href="#" role="button">{this.props.link_label}</a></p>`

window.SidebarContentBlockContent = SidebarContentBlockContent
