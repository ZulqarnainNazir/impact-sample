SpecialtyBlockContent = React.createClass
  mixins: [BackgroundImageCSS]

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
      `<div>
        <div className="webpage-block-col-6">
          <RichTextEditor enabled={this.props.editing && this.props.richText} html={this.props.text} update={this.props.updateText} />
        </div>
        <div className="webpage-block-col-6">
          {this.renderImage()}
        </div>
      </div>`
    else
      `<div>
        <div className="webpage-block-col-6">
          {this.renderImage()}
        </div>
        <div className="webpage-block-col-6">
          <RichTextEditor enabled={this.props.editing && this.props.richText} html={this.props.text} update={this.props.updateText} />
        </div>
      </div>`

  renderImage: ->
    if this.props.image_placement_kind is 'embeds'
      `<div key="imageEmbed" style={{overflow: 'hidden'}} dangerouslySetInnerHTML={{__html: this.props.image_placement_embed}} />`
    else if this.props.image_url and this.props.image_url.length > 0
      `<img className="img-responsive" src={this.props.image_url} alt={this.props.image_alt} title={this.props.image_title} style={{width: '100%'}}/>`
    else if this.props.editing
      `<div>
        <ImageEmpty />
      </div>`

window.SpecialtyBlockContent = SpecialtyBlockContent
