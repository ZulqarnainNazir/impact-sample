# // import React, { PropTypes } from 'react';

MediaModal = React.createClass
  # constructor(props) {
  #   super(props);
  #   this.showMediaLibrary = this.showMediaLibrary.bind(this);
  # }

  mediaImageAttachmentURL: () ->
    if (this.props.mediaImageAttachmentThumbnailURL && this.props.mediaImageAttachmentThumbnailURL.length > 0)
      return this.props.mediaImageAttachmentThumbnailURL;
    return this.props.mediaImageAttachmentURL;

  renderMediaLibrarySaveButton: () ->
    if (['uploading', 'finishing'].indexOf(this.props.mediaImageStatus) >= 0)
      return `<span className="btn btn-primary col-xs-6 disabled" data-dismiss="modal" onClick={this.props.updateMedia}>Save</span>`
    return `<span className="btn btn-primary col-xs-6" data-dismiss="modal" onClick={this.props.updateMedia}>Save</span>`

  showMediaLibrary: () ->
    mediaHelpers.showMediaLibrary(this.props.loadMediaLibraryImages);

  render: () ->
    return (
      `<div id="media_modal" className="modal fade">
        <input id="media_type" type="hidden" />
        <input id="media_group_uuid" type="hidden" />
        <input id="media_block_uuid" type="hidden" />
        <div className="modal-dialog">
          <div className="modal-content">
            <div className="modal-header">
              <span className="close" data-dismiss="modal">&times;</span>
              <p className="h4 modal-title">{MediaModal.mediaModalTitle()}</p>
            </div>

            <div className="modal-body">
              <div id="media_tabs">
                <ul className="nav nav-tabs">
                  <li className="active"><a href="#media_tab_image" data-toggle="tab">Image</a></li>
                  <li><a href="#media_tab_embed" data-toggle="tab">Embed</a></li>
                </ul>
                <div className="tab-content">
                  <div id="media_tab_image" className="tab-pane fade in active">
                    <div className="form-group">
                      <div className="row">
                        <div className="col-sm-4">
                          <EditMediaThumbnail
                            {...this.props}
                            mediaImageAttachmentURL={this.mediaImageAttachmentURL()}
                          />
                        </div>
                        <div className="col-sm-8">
                          <EditMediaProgress
                            mediaImageStatus={this.props.mediaImageStatus}
                            mediaImageProgress={this.props.mediaImageProgress}
                          />
                          <EditMediaInputs mediaImageStatus={this.props.mediaImageStatus} />
                          <EditMediaButtons
                            mediaImageStatus={this.props.mediaImageStatus}
                            bulkUploadPath={this.props.bulkUploadPath}
                            showMediaLibrary={this.showMediaLibrary}
                            removeMediaImage={this.props.removeMediaImage}
                          />
                        </div>
                      </div>
                    </div>
                  </div>
                  <div id="media_tab_embed" className="tab-pane">
                    <div className="form-group">
                      <textarea id="media_embed" rows="6" className="form-control" />
                    </div>
                  </div>
                </div>
              </div>
              <div id="media_library">
                <MediaLibraryOnlyLocalCheckbox
                  showOnlyLocalMediaLibraryOption={this.props.showOnlyLocalMediaLibraryOption}
                  toggleMediaLibraryLocalOnly={this.props.toggleMediaLibraryLocalOnly}
                />
                <ol className="breadcrumb">
                  <li><a onClick={mediaHelpers.hideMediaLibrary} href="#">Edit Details</a></li>
                  <li className="active">Media Library</li>
                </ol>
                <MediaLibraryInterior
                  mediaLibraryLoaded={this.props.mediaLibraryLoaded}
                  mediaLibraryImages={this.props.mediaLibraryImages}
                  mediaLibraryLoadedAll={this.props.mediaLibraryLoadedAll} loadMediaLibraryImages={this.props.loadMediaLibraryImages}
                  selectMediaLibraryImage={this.props.selectMediaLibraryImage}
                />
              </div>
            </div>
            <div className="modal-footer">
              <span className="btn btn-link m-r-xl" data-dismiss="modal" onClick={this.props.resetMedia}>Cancel</span>
              {this.renderMediaLibrarySaveButton()}
            </div>
          </div>
        </div>
      </div>`
    )

MediaModal.mediaModalTitle = () ->
  if ($('#media_type').val() == 'background')
    return 'Add Background Image'
  return 'Add an Image or Embed'

MediaModal.propTypes = {
  mediaImageAttachmentURL: React.PropTypes.string,
  mediaImageAttachmentFileName: React.PropTypes.string,
  mediaImageAttachmentContentType: React.PropTypes.string,
  mediaImageAttachmentFileSize: React.PropTypes.number,
  mediaImageAttachmentThumbnailURL: React.PropTypes.string,
}

MediaModal.defaultProps = {
  mediaImageAttachmentURL: '',
  mediaImageAttachmentFileName: '',
  mediaImageAttachmentContentType: '',
  mediaImageAttachmentThumbnailURL: '',
}

# // export default MediaModal;
window.MediaModal = MediaModal
