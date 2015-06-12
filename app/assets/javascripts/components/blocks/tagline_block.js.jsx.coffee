TaglineBlock = React.createClass
  render: ->
    `<div className="webpage-tagline">
      <div className={this.wellClass()} style={{textAlign: this.props.theme}}>
        <div className="lead">
          <RichTextEditor enabled={this.props.editing && this.props.richText} html={this.props.text} inline={true} update={this.props.updateText} />
        </div>
        <BlockLinkButton {...this.props} />
      </div>
    </div>`

  wellClass: ->
    switch this.props.well_style
      when 'transparent'
        'well well-transparent'
      when 'dark'
        'well well-dark'
      else
        'well well-light'

window.TaglineBlock = TaglineBlock
