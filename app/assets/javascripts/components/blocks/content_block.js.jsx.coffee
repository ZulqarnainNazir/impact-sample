ContentBlock = React.createClass
  render: ->
    style =
      backgroundColor: this.props.background_color
      color: this.props.foreground_color
    if this.props.block_background_placement and this.props.block_background_placement.image_attachment_url and this.props.block_background_placement.image_attachment_url.length > 0
      style['backgroundImage'] = "url(\"#{this.props.block_background_placement.image_attachment_url}\")"
    `<div className="webpage-content" style={style}>
      {this.renderHeading()}
      {this.renderInterior()}
    </div>`

  renderHeading: ->
    if (this.props.heading and this.props.heading.length > 0 and this.props.heading != '<br>') or this.props.richText or true
      `<div>
        <div className="lead text-center">
          <RichTextEditor enabled={this.props.editing && this.props.richText} html={this.props.heading} inline={true} update={this.props.updateHeading} />
        </div>
        <hr />
      </div>`

  renderInterior: ->
    switch this.props.theme
      when 'text'
        `<RichTextEditor enabled={this.props.editing && this.props.richText} html={this.props.text} update={this.props.updateText} />`
      when 'image'
        `<BlockImagePlacement {...this.props.block_image_placement} editing={this.props.editing} version="jumbo" />`
      when 'left'
        `<div className="row">
          <div className="col-sm-8">
            <RichTextEditor enabled={this.props.editing && this.props.richText} html={this.props.text} update={this.props.updateText} />
          </div>
          <div className="col-sm-4">
            <BlockImagePlacement {...this.props.block_image_placement} editing={this.props.editing} version="small" />
          </div>
        </div>`
      when 'right'
        `<div className="row">
          <div className="col-sm-4">
            <BlockImagePlacement {...this.props.block_image_placement} editing={this.props.editing} version="small" />
          </div>
          <div className="col-sm-8">
            <RichTextEditor enabled={this.props.editing && this.props.richText} html={this.props.text} update={this.props.updateText} />
          </div>
        </div>`
      when 'left_half'
        `<div className="row">
          <div className="col-sm-6">
            <RichTextEditor enabled={this.props.editing && this.props.richText} html={this.props.text} update={this.props.updateText} />
          </div>
          <div className="col-sm-6">
            <BlockImagePlacement {...this.props.block_image_placement} editing={this.props.editing} version="medium" />
          </div>
        </div>`
      when 'right_half'
        `<div className="row">
          <div className="col-sm-6">
            <BlockImagePlacement {...this.props.block_image_placement} editing={this.props.editing} version="medium" />
          </div>
          <div className="col-sm-6">
            <RichTextEditor enabled={this.props.editing && this.props.richText} html={this.props.text} update={this.props.updateText} />
          </div>
        </div>`

window.ContentBlock = ContentBlock
