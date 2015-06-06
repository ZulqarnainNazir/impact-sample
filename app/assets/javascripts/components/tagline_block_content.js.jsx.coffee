TaglineBlockContent = React.createClass
  render: ->
    `<div className="webpage-tagline">
      {this.renderInterior()}
    </div>`

  renderInterior: ->
    switch this.props.theme
      when 'center'
        this.renderCenter()
      when 'contain'
        this.renderContain()
      else
        this.renderLeft()

  renderLeft: ->
    `<nav className="page-header tagline tagline-left">
      {this.renderButton()}
      {this.renderText()}
    </nav>`

  renderContain: ->
    `<nav className="well tagline tagline-left">
      {this.renderButton()}
      {this.renderText()}
    </nav>`

  renderCenter: ->
    `<nav className="page-header tagline tagline-center text-center">
      {this.renderText()}
      {this.renderButton()}
    </nav>`

  renderText: ->
    `<p className="lead">{this.text()}</p>`

  text: ->
    if this.props.text and this.props.text.length > 0
      this.props.text
    else
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum finibus ut tortor quis mattis. Donec sit amet hendrerit risus. Maecenas sed orci metus. Nulla viverra bibendum quam, eu ullamcorper felis dignissim sit amet. Pellentesque quis urna nec arcu malesuada accumsan. Nunc eu lacinia est. Vestibulum cursus consequat interdum.'

  renderButton: ->
    if this.props.link_version != 'link_none' and this.props.link_label and this.props.link_label.length > 0
      `<p><a className="btn btn-primary btn-lg" href="#" role="button">{this.props.link_label}</a></p>`

window.TaglineBlockContent = TaglineBlockContent
