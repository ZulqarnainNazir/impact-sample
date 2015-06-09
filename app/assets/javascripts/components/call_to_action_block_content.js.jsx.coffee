CallToActionBlockContent = React.createClass
  mixins: [BackgroundImageCSS]

  render: ->
    `<div className="webpage-call-to-action">
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
      <RichTextEditor enabled={this.props.editing && this.props.richText} html={this.props.text} inline={true} />
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
    `<RichTextEditor enabled={this.props.editing && this.props.richText} html={this.props.text} />`

  renderButton: ->
    if this.props.link_version != 'link_none' and this.props.link_label and this.props.link_label.length > 0
      `<p className="text-center"><a className="btn btn-primary btn-lg" href="#" role="button">{this.props.link_label}</a></p>`

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

window.CallToActionBlockContent = CallToActionBlockContent
