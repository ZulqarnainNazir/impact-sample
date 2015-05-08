ContentBlockContent = React.createClass
  mixins: [BackgroundImageCSS]

  render: ->
    if this.props.theme is 'full'
      `<div className="row">
        <div className="col-sm-12">
          {this.renderText()}
        </div>
      </div>`
    else if this.props.theme is 'fullImage'
      `<div className="row">
        <div className="col-sm-12">
          {this.renderImage()}
        </div>
      </div>`
    else
      `<div className="row">
        {this.renderLeft()}
        {this.renderRight()}
      </div>`

  renderLeft: ->
    if this.props.theme is 'left' then this.renderTextColumn() else this.renderImageColumn()

  renderRight: ->
    if this.props.theme is 'left' then this.renderImageColumn() else this.renderTextColumn()

  renderImageColumn: ->
    `<div className="col-sm-4">
      {this.renderImage()}
    </div>`

  renderImage: ->
    if this.props.image_placement_kind is 'embeds'
      `<div key="imageEmbed" style={{overflow: 'hidden'}} dangerouslySetInnerHTML={{__html: this.props.image_placement_embed}} />`
    else if this.props.image_url and this.props.image_url.length > 0
      `<img className="thumbnail img-responsive" style={{width: '100%'}} src={this.props.image_url} alt={this.props.image_alt} title={this.props.image_title} />`
    else if this.props.editing
      `<ImageEmpty />`

  renderTextColumn: ->
    `<div className="col-sm-8">
      {this.renderText()}
    </div>`

  renderText: ->
    if this.props.text and this.props.text.length > 0
      `<div dangerouslySetInnerHTML={{__html: this.props.text}} />`

window.ContentBlockContent = ContentBlockContent
