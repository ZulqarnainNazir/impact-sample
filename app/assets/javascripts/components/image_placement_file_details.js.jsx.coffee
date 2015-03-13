ImagePlacementFileDetails = React.createClass
  propTypes:
    fileName: React.PropTypes.string
    fileSize: React.PropTypes.number
    state: React.PropTypes.string

  render: ->
    if this.props.state is 'empty'
      `<div></div>`
    else if this.props.fileSize > 0
      `<p className="small"><strong className="pull-right">{parseFloat(this.props.fileSize / 1000.0)} KB</strong> {this.props.fileName}</p>`
    else
      `<p className="small">{this.props.fileName}</p>`

window.ImagePlacementFileDetails = ImagePlacementFileDetails
