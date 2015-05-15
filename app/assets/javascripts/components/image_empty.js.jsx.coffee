ImageEmpty = React.createClass
  propTypes:
    padding: React.PropTypes.string
    dropzone: React.PropTypes.bool

  getDefaultPropTypes:
    padding: 50
    dropzone: false

  render: ->
    if this.props.dropzone is true
      `<p className="well text-center text-muted" style={{paddingTop: this.props.padding, paddingBottom: this.props.padding}}>
        <i className="fa fa-photo fa-3x" />
        <br />
        <span className="small">Drop an image here to begin upload...</span>
      </p>`
    else
      `<p className="well text-center text-muted" style={{paddingTop: this.props.padding, paddingBottom: this.props.padding}}>
        <i className="fa fa-photo fa-3x" />
        <br />
      </p>`

window.ImageEmpty = ImageEmpty
