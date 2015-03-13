ImagePlacementDropZone = React.createClass
  propTypes:
    state: React.PropTypes.string

  triggerFileInput: ->
    $(this.refs.fileInput.getDOMNode()).click()

  render: ->
    if this.props.state is 'empty'
      style =
        border: 'dashed 1px #ccc'
        borderRadius: '2px'
        textAlign: 'center'
        padding: '2em'
      `<div ref="dropZone" style={style}>
        Drop an image here to begin upload or <br />
        <u onClick={this.triggerFileInput} style={{cursor: 'pointer'}}>select an image from your computer</u>
        <input type="file" className="hidden" ref="fileInput" />
      </div>`
    else
      `<div></div>`

window.ImagePlacementDropZone = ImagePlacementDropZone
