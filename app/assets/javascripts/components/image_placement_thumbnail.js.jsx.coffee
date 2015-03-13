ImagePlacementThumbnail = React.createClass
  propTypes:
    alt: React.PropTypes.string
    title: React.PropTypes.string
    url: React.PropTypes.string

  render: ->
    if this.props.url.length > 0
      `<div className="thumbnail"><img style={{width: '100%'}} src={this.props.url} alt={this.props.alt} title={this.props.title} /></div>`
    else
      `<div className="thumbnail text-center"><i className="fa fa-photo" style={{fontSize: '3em', margin: '25px 0'}} /></div>`

window.ImagePlacementThumbnail = ImagePlacementThumbnail
