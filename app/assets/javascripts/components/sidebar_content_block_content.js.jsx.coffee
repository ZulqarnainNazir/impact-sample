SidebarContentBlockContent = React.createClass
  mixins: [BackgroundImageCSS]

  render: ->
    `<div className="panel panel-default text-center">
      <div className="panel-body">
        {this.renderHeading()}
        {this.renderImage()}
        {this.renderText()}
        {this.renderButton()}
      </div>
    </div>`

  renderHeading: ->
    if this.props.heading and this.props.heading.length > 0
      `<h4>{this.props.heading}</h4>`

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
    if this.props.text and this.props.text.length > 0
      `<p dangerouslySetInnerHTML={{__html: this.props.text}} />`

  renderButton: ->
    if this.props.link_version != 'link_none' and this.props.link_label and this.props.link_label.length > 0
      `<p><a className="btn btn-primary btn-lg" href="#" role="button">{this.props.link_label}</a></p>`

window.SidebarContentBlockContent = SidebarContentBlockContent
