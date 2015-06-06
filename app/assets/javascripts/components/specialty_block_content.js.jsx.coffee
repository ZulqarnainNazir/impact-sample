SpecialtyBlockContent = React.createClass
  mixins: [BackgroundImageCSS]

  render: ->
    `<div className="webpage-specialty">
      <p className="lead text-center">{this.heading(this.props.heading)}</p>
      <hr />
      {this.renderContent()}
    </div>`

  renderContent: ->
    if this.props.theme is 'right'
      `<div>
        <div className="webpage-block-col-6">
          {this.renderText()}
        </div>
        <div className="webpage-block-col-6">
          {this.renderImage()}
        </div>
      </div>`
    else
      `<div>
        <div className="webpage-block-col-6">
          {this.renderImage()}
        </div>
        <div className="webpage-block-col-6">
          {this.renderText()}
        </div>
      </div>`

  renderImage: ->
    if this.props.image_placement_kind is 'embeds'
      `<div key="imageEmbed" style={{overflow: 'hidden'}} dangerouslySetInnerHTML={{__html: this.props.image_placement_embed}} />`
    else if this.props.image_url and this.props.image_url.length > 0
      `<img className="img-responsive" src={this.props.image_url} alt={this.props.image_alt} title={this.props.image_title} style={{width: '100%'}}/>`
    else if this.props.editing
      `<div>
        <ImageEmpty />
      </div>`

  renderText: ->
    `<p dangerouslySetInnerHTML={{__html: this.text(this.props.text)}} />`

  heading: (value) ->
    if value and value.length > 0
      value
    else
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit'

  text: (value) ->
    if value and value.length > 0
      value
    else
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum finibus ut tortor quis mattis. Donec sit amet hendrerit risus. Maecenas sed orci metus. Nulla viverra bibendum quam, eu ullamcorper felis dignissim sit amet. Pellentesque quis urna nec arcu malesuada accumsan. Nunc eu lacinia est. Vestibulum cursus consequat interdum.'

window.SpecialtyBlockContent = SpecialtyBlockContent
