ContentBlock = React.createClass
  render: ->
    `<div className="webpage-content">
      {this.renderInterior()}
    </div>`

  renderInterior: ->
    switch this.props.theme
      when 'text'
        `<RichTextEditor enabled={this.props.editing && this.props.richText} html={this.props.text} update={this.props.updateText} />`
      when 'image'
        `<BlockImagePlacement {...this.props.block_image_placement} editing={this.props.editing} />`
      when 'left'
        `<div>
          <div className="webpage-block-col-8">
            <RichTextEditor enabled={this.props.editing && this.props.richText} html={this.props.text} update={this.props.updateText} />
          </div>
          <div className="webpage-block-col-4">
            <BlockImagePlacement {...this.props.block_image_placement} editing={this.props.editing} />
          </div>
        </div>`
      else
        `<div>
          <div className="webpage-block-col-4">
            <BlockImagePlacement {...this.props.block_image_placement} editing={this.props.editing} />
          </div>
          <div className="webpage-block-col-8">
            <RichTextEditor enabled={this.props.editing && this.props.richText} html={this.props.text} update={this.props.updateText} />
          </div>
        </div>`

window.ContentBlock = ContentBlock
