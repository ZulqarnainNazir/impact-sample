EditMediaInputs = React.createClass
  render: ->
    if (['uploading', 'finishing', 'attached'].indexOf(this.props.mediaImageStatus) >= 0)
      return (
        `<div>
          <div className="form-group">
            <label
              htmlFor="media_image_alt"
              className="control-label"
            ><code>ALT</code> HTML Attribute</label>
            <input id="media_image_alt" type="text" className="form-control" />
          </div>
          <div className="form-group">
            <label htmlFor="media_image_title" className="control-label"><code>Title</code> HTML Attribute</label>
            <input id="media_image_title" type="text" className="form-control" placeholder="Add a description of the image. Can be more than 1 sentence." />
          </div>
        </div>`
      )
    return `<div />`

EditMediaInputs.propTypes = {
  mediaImageStatus: React.PropTypes.string,
}
EditMediaInputs.defaultProps = {
  mediaImageStatus: '',
}

window.EditMediaInputs = EditMediaInputs
