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
      <BlockLinkButton {...this.props} />
      <div className="lead">
        <RichTextEditor enabled={this.props.editing && this.props.richText} html={this.props.text} update={this.props.updateText} />
      </div>
    </nav>`

  renderContain: ->
    `<nav className="well tagline tagline-left">
      <BlockLinkButton {...this.props} />
      <div className="lead">
        <RichTextEditor enabled={this.props.editing && this.props.richText} html={this.props.text} update={this.props.updateText} />
      </div>
    </nav>`

  renderCenter: ->
    `<nav className="page-header tagline tagline-center text-center">
      <div className="lead">
        <RichTextEditor enabled={this.props.editing && this.props.richText} html={this.props.text} update={this.props.updateText} />
      </div>
      <BlockLinkButton {...this.props} />
    </nav>`

window.TaglineBlockContent = TaglineBlockContent
