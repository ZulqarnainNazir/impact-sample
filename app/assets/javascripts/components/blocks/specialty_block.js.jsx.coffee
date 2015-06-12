SpecialtyBlock = React.createClass
  render: ->
    `<div className="webpage-specialty">
      <div className="lead text-center">
        <RichTextEditor enabled={this.props.editing && this.props.richText} html={this.props.heading} inline={true} update={this.props.updateHeading} />
      </div>
      <hr />
      {this.renderContent()}
    </div>`

  renderContent: ->
    if this.props.theme is 'right'
      `<div className="row">
        <div className="col-sm-6">
          <RichTextEditor enabled={this.props.editing && this.props.richText} html={this.props.text} update={this.props.updateText} />
        </div>
        <div className="col-sm-6">
          <BlockImagePlacement {...this.props.block_image_placement} editing={this.props.editing} />
        </div>
      </div>`
    else
      `<div className="row">
        <div className="col-sm-6">
          <BlockImagePlacement {...this.props.block_image_placement} editing={this.props.editing} />
        </div>
        <div className="col-sm-6">
          <RichTextEditor enabled={this.props.editing && this.props.richText} html={this.props.text} update={this.props.updateText} />
        </div>
      </div>`

window.SpecialtyBlock = SpecialtyBlock
