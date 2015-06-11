ContentBlockContent = React.createClass
  render: ->
    `<div className="webpage-content">
      {this.renderInterior()}
    </div>`

  renderInterior: ->
    if this.props.theme is 'full'
      `<RichTextEditor enabled={this.props.editing && this.props.richText} html={this.props.text} update={this.props.updateText} />`
    else if this.props.theme is 'full_image'
      `<BlockImagePlacement {...this.props.block_image_placement} editing={this.props.editing} />`
    else
      `<div>
        {this.renderLeft()}
        {this.renderRight()}
      </div>`

  renderLeft: ->
    if this.props.theme is 'left' then this.renderTextColumn() else this.renderImageColumn()

  renderRight: ->
    if this.props.theme is 'left' then this.renderImageColumn() else this.renderTextColumn()

  renderImageColumn: ->
    `<div className="webpage-block-col-4">
      <BlockImagePlacement {...this.props.block_image_placement} editing={this.props.editing} />
    </div>`

  renderTextColumn: ->
    `<div className="webpage-block-col-8">
      <RichTextEditor enabled={this.props.editing && this.props.richText} html={this.props.text} update={this.props.updateText} />
    </div>`

window.ContentBlockContent = ContentBlockContent
