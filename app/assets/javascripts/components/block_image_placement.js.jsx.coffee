BlockImagePlacement = React.createClass
  render: ->
    if this.props.kind is 'embeds'
      `<div key="imageEmbed" style={{marginBottom: 15, overflow: 'hidden'}} dangerouslySetInnerHTML={{__html: this.props.embed}} />`
    else if this.imageURL().length > 0
      `<img className="center-block img-responsive thumbnail" src={this.imageURL()} alt={this.props.image_alt} title={this.props.image_title} style={{marginBottom: 15, maxWidth: '100%'}}/>`
    else if this.props.editing
      `<div style={{marginBottom: 15}}>
        <ImageEmpty />
      </div>`
    else
      `<div />`

  imageURL: ->
    imageVersionURL = switch this.props.version
      when 'jumbo'
        this.props.image_attachment_jumbo_url
      when 'large'
        this.props.image_attachment_large_url
      when 'medium'
        this.props.image_attachment_medium_url
      when 'small'
        this.props.image_attachment_small_url
      when 'thumbnail'
        this.props.image_attachment_thumbnail_url
    if imageVersionURL and imageVersionURL.length > 0
      imageVersionURL
    else
      this.props.image_attachment_url or ''

window.BlockImagePlacement = BlockImagePlacement
