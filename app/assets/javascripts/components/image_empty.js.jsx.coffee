ImageEmpty = React.createClass
  propTypes:
    padding: React.PropTypes.number
    copy: React.PropTypes.bool
    dropzone: React.PropTypes.bool

  getDefaultPropTypes:
    padding: 50
    dropzone: false

  render: ->
    `<div className="webpage-image-empty well text-center text-muted" style={{padding: this.props.padding}}>
      <i className="fa fa-photo fa-3x" />
      {this.renderCopy()}
    </div>`

  renderCopy: ->
    if this.props.dropzone is true
      `<div>
        <br />
        <span className="small">Drop an image here to begin upload...</span>
      </div>`
    else if this.props.copy is true
      `<div>
        <span style={{fontSize: 26}}>Add optional main image</span>
      </div>`

window.ImageEmpty = ImageEmpty
