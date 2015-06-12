TaglineBlock = React.createClass
  render: ->
    `<div className="webpage-tagline" style={{textAlign: this.props.theme}}>
      <div className="well">
        <div className="lead">
          <RichTextEditor enabled={this.props.editing && this.props.richText} html={this.props.text} update={this.props.updateText} />
        </div>
        <BlockLinkButton {...this.props} />
      </div>
    </div>`

window.TaglineBlock = TaglineBlock
