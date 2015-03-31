ImageEmpty = React.createClass
  propTypes:
    padding: React.PropTypes.string

  getDefaultPropTypes:
    padding: 50

  render: ->
    `<p className="well text-center text-muted" style={{paddingTop: this.props.padding, paddingBottom: this.props.padding}}>
      <i className="fa fa-photo fa-3x" />
      <br />
      <span className="small">Drop an image here to begin upload...</span>
    </p>`

window.ImageEmpty = ImageEmpty
