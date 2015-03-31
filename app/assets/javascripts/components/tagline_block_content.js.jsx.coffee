TaglineBlockContent = React.createClass
  render: ->
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
    if this.props.text and this.props.text.length > 0
      `<p className="lead">{this.props.text}</p>`

  renderButton: ->
    if this.props.link_version != 'link_none' and this.props.link_label and this.props.link_label.length > 0
      `<p><a className="btn btn-primary btn-lg" href="#" role="button">{this.props.link_label}</a></p>`

window.TaglineBlockContent = TaglineBlockContent
