ContentBlockContent = React.createClass
  mixins: [BackgroundImageCSS]

  render: ->
    `<div className="webpage-content">
      {this.renderInterior()}
    </div>`

  renderInterior: ->
    if this.props.theme is 'full'
      this.renderText()
    else if this.props.theme is 'full_image'
      this.renderImage()
    else
      `<div>
        {this.renderLeft()}
        {this.renderRight()}
      </div>`

  renderLeft: ->
    if this.props.theme is 'left' then this.renderTextColumn() else this.renderImageColumn()

  renderRight: ->
    if this.props.theme is 'left' then this.renderImageColumn() else this.renderTextColumn()

  renderImageColumn: ->
    `<div className="webpage-block-col-4">
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
    `<div className="webpage-block-col-8">
      {this.renderText()}
    </div>`

  renderText: ->
    if this.props.text and this.props.text.length > 0
      `<div dangerouslySetInnerHTML={{__html: this.props.text}} />`
    else
      `<div dangerouslySetInnerHTML={{__html: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum finibus ut tortor quis mattis. Donec sit amet hendrerit risus. Maecenas sed orci metus. Nulla viverra bibendum quam, eu ullamcorper felis dignissim sit amet. Pellentesque quis urna nec arcu malesuada accumsan. Nunc eu lacinia est. Vestibulum cursus consequat interdum.'}} />`

window.ContentBlockContent = ContentBlockContent
