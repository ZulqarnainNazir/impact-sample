EditMediaProgress = React.createClass
  render: ->
    if (this.props.mediaImageStatus == 'uploading')
      return (
        `<div>
          <div className="progress">
            <div className="progress-bar progress-bar-striped active" style={{ width: this.props.mediaImageProgress + '%' }} />
          </div>
        </div>`
      )
    else if (this.props.mediaImageStatus == 'finishing')
      return (
        `<div className="progress">
          <div className="progress-bar progress-bar-success" style={{ width: '100%' }} />
        </div>`
      )
    else if (this.props.mediaImageStatus == 'failed')
      return (
        `<div className="progress">
          <div className="progress-bar progress-bar-danger" style={{ width: '100%' }} />
        </div>`
      )
    return `<div />`

EditMediaProgress.propTypes = {
  mediaImageStatus: React.PropTypes.string.isRequired,
  mediaImageProgress: React.PropTypes.number,
}

EditMediaProgress.defaultProps = {
  mediaImageProgress: 0,
}

window.EditMediaProgress = EditMediaProgress
