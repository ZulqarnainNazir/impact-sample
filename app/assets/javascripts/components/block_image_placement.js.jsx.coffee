BlockImagePlacement = React.createClass
  render: ->
    if this.props.kind is 'embeds'
      `<div key="imageEmbed" style={{marginBottom: 15, overflow: 'hidden'}} dangerouslySetInnerHTML={{__html: this.props.embed}} />`
    else if this.props.image_attachment_url and this.props.image_attachment_url.length > 0
      `<img className="center-block img-responsive thumbnail" src={this.props.image_attachment_url} alt={this.props.image_alt} title={this.props.image_title} style={{marginBottom: 15, maxWidth: '100%'}}/>`
    else if this.props.editing
      `<div style={{marginBottom: 15}}>
        <ImageEmpty />
      </div>`
    else
      `<div />`

window.BlockImagePlacement = BlockImagePlacement
