ContentBlockContent = React.createClass
  mixins: [BackgroundImageCSS]

  render: ->
    `<div className="row">
      <div className="col-sm-6">
        {this.renderLeft()}
      </div>
      <div className="col-sm-6">
        {this.renderRight()}
      </div>
    </div>`

  renderLeft: ->
    if this.props.theme is 'left' then this.renderText() else this.renderImage()

  renderRight: ->
    if this.props.theme is 'left' then this.renderImage() else this.renderText()

  renderImage: ->
    if this.props.image_url and this.props.image_url.length > 0
      `<img className="thumbnail img-responsive" style={{width: '100%'}} src={this.props.image_url} alt={this.props.image_alt} title={this.props.image_title} />`
    else if this.props.editing
      `<div>
        <ImageEmpty />
      </div>`

  renderText: ->
    if this.props.text and this.props.text.length > 0
      `<p>{this.props.text}</p>`

window.ContentBlockContent = ContentBlockContent
