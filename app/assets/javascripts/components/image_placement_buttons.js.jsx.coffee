ImagePlacementButtons = React.createClass
  propTypes:
    state: React.PropTypes.string
    cancel: React.PropTypes.func
    edit: React.PropTypes.func
    reset: React.PropTypes.func

  render: ->
    if this.props.state is 'empty'
      `<div></div>`
    else if this.props.state is 'uploading'
      `<div className="btn-group btn-group-sm">
        <span className="btn btn-warning" onClick={this.props.cancel}>Cancel</span>
      </div>`
    else if this.props.state is 'failed'
      `<div className="btn-group btn-group-sm">
        <span className="btn btn-primary" onClick={this.props.reset}>Retry</span>
      </div>`
    else
      `<div className="btn-group btn-group-sm">
        <span className="btn btn-default" onClick={this.props.edit}>Edit</span>
        <span className="btn btn-danger" onClick={this.props.reset}>Detach</span>
      </div>`

window.ImagePlacementButtons = ImagePlacementButtons
