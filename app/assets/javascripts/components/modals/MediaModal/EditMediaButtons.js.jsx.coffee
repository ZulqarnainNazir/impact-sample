EditMediaButtons = React.createClass
  triggerFileInput: () ->
    $('#file-input').click()

  render: () ->
    if (['empty', 'failed', 'attached'].indexOf(this.props.mediaImageStatus) >= 0)
      `<div>
        <input type="file" className="hidden" ref="fileInput" id="file-input" />
        <span className="btn-group btn-group-sm">
          <span onClick={this.triggerFileInput} className="btn btn-default">
            <i className="fa fa-cloud-upload" /> Upload Image
          </span>
          <span onClick={this.props.showMediaLibrary} className="btn btn-default">
            <i className="fa fa-th" /> Browse Library
          </span>
        </span>
        <EditMediaRemoveButton mediaImageStatus={this.props.mediaImageStatus} removeMediaImage={this.props.removeMediaImage} />
        <hr />
        <EditMediaUpscaleCheckbox />
        <hr />
        <p className="small" style={{ marginTop: 10 }}>Have a lot of images to add? <a href={this.props.bulkUploadPath} target="_blank" rel="noopener noreferrer">Try Bulk Upload</a></p>
      </div>`

    else
      return `<div />`

window.EditMediaButtons = EditMediaButtons
