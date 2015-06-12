ImageEmpty = React.createClass
  propTypes:
    padding: React.PropTypes.number
    dropzone: React.PropTypes.bool

  getDefaultPropTypes:
    padding: 50
    dropzone: false

  render: ->
    `<div className="well text-center text-muted" style={{padding: this.props.padding}}>
      <i className="fa fa-photo fa-3x" />
      {this.renderDropzone()}
    </div>`

  renderDropzone: ->
    if this.props.dropzone is true
      `<div>
        <br />
        <span className="small">Drop an image here to begin upload...</span>
      </div>`

window.ImageEmpty = ImageEmpty
