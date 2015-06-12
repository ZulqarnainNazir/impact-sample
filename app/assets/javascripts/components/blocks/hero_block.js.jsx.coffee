HeroBlock = React.createClass
  render: ->
    style =
      backgroundColor: this.props.background_color
      height: if parseInt(this.props.height) > 0 then parseInt(this.props.height) else 'auto'
      overflow: 'hidden'
    if this.props.block_background_placement and this.props.block_background_placement.image_attachment_url and this.props.block_background_placement.image_attachment_url.length > 0
      style['backgroundImage'] = "url(\"#{this.props.block_background_placement.image_attachment_url}\")"
    `<div className="webpage-hero jumbotron" style={style}>
      {this.renderInterior()}
    </div>`

  renderInterior: ->
    switch this.props.theme
      when 'right'
        `<div>
          <div key="content" className="webpage-block-col-6">
            <div className="well">
              <h1><RichTextEditor enabled={this.props.editing && this.props.richText} html={this.props.heading} inline={true} update={this.props.updateHeading} /></h1>
              <RichTextEditor enabled={this.props.editing && this.props.richText} html={this.props.text} update={this.props.updateText} />
              <BlockLinkButton {...this.props} />
            </div>
          </div>
          <div key="image" className="webpage-block-col-6">
            <BlockImagePlacement {...this.props.block_image_placement} editing={this.props.editing} />
          </div>
        </div>`
      when 'left'
        `<div>
          <div key="image" className="webpage-block-col-6">
            <BlockImagePlacement {...this.props.block_image_placement} editing={this.props.editing} />
          </div>
          <div key="content" className="webpage-block-col-6">
            <div className="well">
              <h1><RichTextEditor enabled={this.props.editing && this.props.richText} html={this.props.heading} inline={true} update={this.props.updateHeading} /></h1>
              <RichTextEditor enabled={this.props.editing && this.props.richText} html={this.props.text} update={this.props.updateText} />
              <BlockLinkButton {...this.props} />
            </div>
          </div>
        </div>`
      else
        `<div className="well">
          <h1><RichTextEditor enabled={this.props.editing && this.props.richText} html={this.props.heading} inline={true} update={this.props.updateHeading} /></h1>
          {this.renderInlineImage()}
          <RichTextEditor enabled={this.props.editing && this.props.richText} html={this.props.text} update={this.props.updateText} />
          <BlockLinkButton {...this.props} />
        </div>`

  renderInlineImage: ->
    if this.props.editing
      `<div style={{float: 'left', maxWidth: 200, marginRight: 10, marginBottom: 10}}>
        <BlockImagePlacement {...this.props.block_image_placement} editing={this.props.editing} />
      </div>`

window.HeroBlock = HeroBlock
