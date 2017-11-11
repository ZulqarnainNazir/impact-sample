TaglineBlock = React.createClass
  render: ->
    `<div className="webpage-tagline">
      <div className={this.wellClass()} style={{textAlign: this.props.theme}}>
        <div className="lead">
          <RichTextEditor enabled={this.props.editing && this.props.richText} html={this.props.text} update={this.props.updateText} />
        </div>
        <BlockLinkButton {...this.props} />
      </div>
    </div>`

  wellClass: ->
    switch this.props.well_style
      when 'light'
        'well well-light'
      when 'dark'
        'well well-dark'
      else
        'well well-transparent'

window.TaglineBlock = TaglineBlock
