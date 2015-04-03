ContentBlockContent = React.createClass
  mixins: [BackgroundImageCSS]

  render: ->
    `<div className="row">
      {this.renderLeft()}
      {this.renderRight()}
    </div>`

  renderLeft: ->
    if this.props.theme is 'left' then this.renderText() else this.renderImage()

  renderRight: ->
    if this.props.theme is 'left' then this.renderImage() else this.renderText()

  renderImage: ->
    if this.props.image_url and this.props.image_url.length > 0
      `<div className="col-sm-4">
        <img className="thumbnail img-responsive" style={{width: '100%'}} src={this.props.image_url} alt={this.props.image_alt} title={this.props.image_title} />
      </div>`
    else if this.props.editing
      `<div className="col-sm-4">
        <ImageEmpty />
      </div>`

  renderText: ->
    if this.props.text and this.props.text.length > 0
      `<div className="col-sm-8">
        <p dangerouslySetInnerHTML={{__html: this.props.text}} />
      </div>`

window.ContentBlockContent = ContentBlockContent
