HeroBlock = React.createClass
  render: ->
    style =
      backgroundColor: this.props.background_color
      color: this.props.foreground_color
      height: if parseInt(this.props.groupHeight) > 0 then parseInt(this.props.groupHeight) else 'auto'
    if this.props.block_background_placement and this.props.block_background_placement.image_attachment_jumbo_url and this.props.block_background_placement.image_attachment_jumbo_url.length > 0
      style['backgroundImage'] = "url(\"#{this.props.block_background_placement.image_attachment_jumbo_url}\")"
    else if this.props.block_background_placement and this.props.block_background_placement.image_attachment_url and this.props.block_background_placement.image_attachment_url.length > 0
      style['backgroundImage'] = "url(\"#{this.props.block_background_placement.image_attachment_url}\")"
    `<div className="webpage-hero">
      <div className="jumbotron" style={style}>
        <div className={this.containerClass()}>
          {this.renderInterior()}
        </div>
      </div>
    </div>`

  renderInterior: ->
    switch this.props.theme
      when 'right'
        `<div className="row">
          <div key="content" className="col-sm-6">
            <div className={this.wellClass()} style={{color: this.props.foreground_color}}>
              <h1><RichTextEditor enabled={this.props.editing && this.props.richText} html={this.props.heading} inline={true} update={this.props.updateHeading} /></h1>
              <RichTextEditor enabled={this.props.editing && this.props.richText} html={this.props.text} update={this.props.updateText} />
              <BlockLinkButton {...this.props} />
            </div>
          </div>
          <div key="image" className="col-sm-6">
            <BlockImagePlacement {...this.props.block_image_placement} editing={this.props.editing} version="medium" copy={true} />
          </div>
        </div>`
      when 'left'
        `<div className="row">
          <div key="image" className="col-sm-6">
            <BlockImagePlacement {...this.props.block_image_placement} editing={this.props.editing} version="medium" copy={true} />
          </div>
          <div key="content" className="col-sm-6">
            <div className={this.wellClass()} style={{color: this.props.foreground_color}}>
              <h1><RichTextEditor enabled={this.props.editing && this.props.richText} html={this.props.heading} inline={true} update={this.props.updateHeading} /></h1>
              <RichTextEditor enabled={this.props.editing && this.props.richText} html={this.props.text} update={this.props.updateText} />
              <BlockLinkButton {...this.props} />
            </div>
          </div>
        </div>`
      else
        `<div className="row">
          <div key="content" className="col-sm-12">
            <div className={this.wellClass()} style={{color: this.props.foreground_color}}>
              <h1><RichTextEditor enabled={this.props.editing && this.props.richText} html={this.props.heading} inline={true} update={this.props.updateHeading} /></h1>
              <RichTextEditor enabled={this.props.editing && this.props.richText} html={this.props.text} update={this.props.updateText} />
              <BlockLinkButton {...this.props} />
            </div>
          </div>
        </div>`

  containerClass: ->
    if this.props.kind is 'full_width'
      'container'
    else
      ''

  wellClass: ->
    switch this.props.well_style
      when 'light'
        'well well-light'
      when 'dark'
        'well well-dark'
      else
        'well well-transparent'

window.HeroBlock = HeroBlock
