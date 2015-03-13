ImagePlacementProgressBar = React.createClass
  propTypes:
    state: React.PropTypes.string
    progress: React.PropTypes.number

  render: ->
    if this.props.state is 'empty'
      `<div></div>`
    else if this.props.state is 'stored'
      `<hr style={{marginTop: 0}} />`
    else
      progressClass = 'progress-bar'
      progressClass += ' progress-bar-striped active' if this.props.state is 'uploading'
      progressClass += ' progress-bar-success' if this.props.state is 'cached'
      progressClass += ' progress-bar-danger' if this.props.state is 'failed'
      `<div className="progress">
        <div className={progressClass} role="progressbar" aria-valuenow={this.props.progress} aria-valuemin="0" aria-valuemax="100" style={{minWidth: 30, width: this.props.progress + '%'}}>
          {this.props.progress}%
        </div>
      </div>`

window.ImagePlacementProgressBar = ImagePlacementProgressBar
