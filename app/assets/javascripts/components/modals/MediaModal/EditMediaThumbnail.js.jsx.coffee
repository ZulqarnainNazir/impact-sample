EditMediaThumbnail = React.createClass
  render: ->
    if (this.props.mediaImageAttachmentURL)
      return (
        `<div className="media_dropzone">
          <div className="small">
            <div className="thumbnail">
              <img style={{ width: '100%' }} src={this.props.mediaImageAttachmentURL} />
            </div>
            <div style={{ overflow: 'hidden', whiteSpace: 'nowrap' }}>
              <strong>{this.props.mediaImageAttachmentFileName}</strong>
            </div>
            <div>{this.props.mediaImageAttachmentContentType} – {this.props.mediaImageAttachmentFileSize / 1000}KB</div>
          </div>
        </div>`
      )
    return (
      `<div className="media_dropzone">
        <ImageEmpty padding={20} dropzone />
      </div>`
    )


EditMediaThumbnail.propTypes = {
  mediaImageAttachmentURL: React.PropTypes.string,
  mediaImageAttachmentFileName: React.PropTypes.string,
  mediaImageAttachmentContentType: React.PropTypes.string,
  mediaImageAttachmentFileSize: React.PropTypes.number,
}
EditMediaThumbnail.defaultProps = {
  mediaImageAttachmentURL: '',
  mediaImageAttachmentFileName: '',
  mediaImageAttachmentContentType: '',
  mediaImageAttachmentFileSize: 0,
}

window.EditMediaThumbnail = EditMediaThumbnail
