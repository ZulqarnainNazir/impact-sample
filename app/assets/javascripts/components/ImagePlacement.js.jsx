// import React from 'react';
// import PropTypes from 'prop-types';
// import { render } from 'react-dom';

const ImagePlacement = React.createClass({
  propTypes: {
    inputPrefix: React.PropTypes.string.isRequired,
    imagesPath: React.PropTypes.string.isRequired,
    presignedPost: React.PropTypes.object.isRequired,

    placement: React.PropTypes.shape({
      id: React.PropTypes.number,
      kind: React.PropTypes.string,
      embed: React.PropTypes.string,
      _destroy: React.PropTypes.string,
      image: React.PropTypes.shape({
        id: React.PropTypes.number,
        alt: React.PropTypes.string,
        title: React.PropTypes.string,
        attachment_cache_url: React.PropTypes.string,
        attachment_content_type: React.PropTypes.string,
        attachment_file_name: React.PropTypes.string,
        attachment_file_size: React.PropTypes.string,
        attachment_thumbnail_url: React.PropTypes.string
      }).isRequired
    }).isRequired,

    allowEmbed: React.PropTypes.bool,
    buttonSize: React.PropTypes.string,
    buttonRemove: React.PropTypes.bool,
    label: React.PropTypes.string
  },

  getDefaultProps() {
    return {buttonRemove: true};
  },

  getInitialState() {
    return {
      imageAlt: this.props.placement.image.alt,
      imageAttachmentCacheURL: this.props.placement.image.attachment_cache_url,
      imageAttachmentContentType: this.props.placement.image.attachment_content_type,
      imageAttachmentFileName: this.props.placement.image.attachment_file_name,
      imageAttachmentFileSize: this.props.placement.image.attachment_file_size,
      imageAttachmentURL: this.props.placement.image.attachment_thumbnail_url,
      imageID: this.props.placement.image.id,
      imageTitle: this.props.placement.image.title,
      hover: false,
      imageBrowseModal: false,
      libraryImages: [],
      libraryLoaded: false,
      libraryLoadedAll: false,
      libraryLocalOnly: true,
      libraryPage: 1,
      libraryVisible: false,
      placementID: this.props.placement.id,
      placementKind: this.props.placement.kind || 'images',
      placementEmbed: this.props.placement.embed,
      placementDestroy: this.props.placement.destroy,
      uploadProgress: 0,
      uploadState: this.props.placement.image.attachment_thumbnail_url && (this.props.placement.image.attachment_thumbnail_url.length > 0) ? 'attached' : 'empty',
      uploadXHR: null
    };
  },

  componentDidMount() {
    this.initializeFileUpload();
    if (this.state.placementKind && (this.state.placementKind === 'embeds')) {
      $(`#${this.id('nav_tab_image')}`).removeClass('active');
      $(`#${this.id('nav_tab_embed')}`).addClass('active');
      $(`#${this.id('tab_image')}`).removeClass('in active');
      return $(`#${this.id('tab_embed')}`).addClass('in active');
    }
  },

  render() {
    if (this.props.allowEmbed) {
      if (this.state.placementKind === 'embeds') {
        return this.renderEmbed();
      } else {
        return this.renderImage();
      }
    } else {
      return this.renderImage();
    }
  },

  renderImage() {
    return <div className="form-group">
      {this.renderLabel()}
      <input type="hidden" name={this.name('id')} value={this.state.placementID} />
      <input type="hidden" name={this.name('kind')} value={this.state.placementKind} />
      <input type="hidden" name={this.name('_destroy')} value={this.state.placementDestroy} />
      <input type="hidden" name={this.name('image_id')} value={this.state.imageID} />
      <div className="row">
        <div className="col-sm-12">
          {this.renderThumbnail(this.state.imageID)}
        </div>
        <div className="col-sm-12">
          {this.renderProgress()}
          {this.renderButtons()}
        </div>
      </div>
      {this.renderLibrary()}
      {this.renderImageAttributes(this.state.imageID)}
    </div>;
  },

  renderLabel() {
    if (!this.props.allowEmbed) {
      return <label className="control-label">{this.props.label}</label>;
    }
  },

  renderThumbnail(id) {
    if ((this.state.placementDestroy !== '1') && this.imageURL()) {
      return <div id={this.id('dropzone')}>
        <div className="small">
          <input type="hidden" name={this.name('image_attachment_cache_url')} value={this.state.imageAttachmentCacheURL} />
          <input type="hidden" name={this.name('image_attachment_content_type')} value={this.state.imageAttachmentContentType} />
          <input type="hidden" name={this.name('image_attachment_file_name')} value={this.state.imageAttachmentFileName} />
          <input type="hidden" name={this.name('image_attachment_file_size')} value={this.state.imageAttachmentFileSize} />
          <div onMouseEnter={this.mouseHoverEnter} onMouseLeave={this.mouseHoverLeave}>
            <img style={{width: '100%'}} src={this.imageURL()} alt={this.state.imageAlt} title={this.state.imageTitle} />
            {this.renderUploadButtons()}
            {this.renderButtonRemove(id)}
          </div>
          <div style={{overflow: 'hidden', whiteSpace: 'nowrap'}}><strong>{this.state.imageAttachmentFileName}</strong></div>
          <div>{this.state.imageAttachmentContentType} – {this.state.imageAttachmentFileSize / 1000}KB</div>
        </div>
      </div>;
    } else {
      return <div id={this.id('dropzone')} onMouseEnter={this.mouseHoverEnter} onMouseLeave={this.mouseHoverLeave} onClick={this.mouseHoverEnter}>
        <ImageEmpty padding={20} dropzone={true}>
          {this.renderUploadButtons()}
        </ImageEmpty>
      </div>;
    }
  },

  mouseHoverEnter() {
    console.log('hover');
    return this.setState({hover: true});
  },

  mouseHoverLeave() {
    return this.setState({hover: false});
  },

  renderProgress() {
    if (this.state.uploadState === 'uploading') {
      return <div>
        <i className="fa fa-close pull-right" />
        <div className="progress" style={{marginRight: 20}}>
          <div className="progress-bar progress-bar-striped active" style={{width: this.progressWidthPercentage()}} />
        </div>
      </div>;
    } else if (this.state.uploadState === 'finishing') {
      return <div className="progress">
        <div className="progress-bar progress-bar-success" style={{width: '100%'}} />
      </div>;
    } else if (this.state.uploadState === 'failed') {
      return <div className="progress">
        <div className="progress-bar progress-bar-danger" style={{width: '100%'}} />
      </div>;
    }
  },

  renderInputs() {
    if ((this.state.uploadState === 'uploading') || (this.state.uploadState === 'finishing') || (this.state.uploadState === 'attached')) {
      return <div>
        <div className="form-group">
          <label htmlFor={this.id('image_alt')} className="control-label"><code>ALT</code> HTML Attribute</label>
          <input id={this.id('image_alt')} name={this.name('image_alt')} type="text" defaultValue={this.state.imageAlt} className="form-control" />
        </div>
        <div className="form-group">
          <label htmlFor={this.id('image_title')} className="control-label"><code>Title</code> HTML Attribute</label>
          <input id={this.id('image_title')} name={this.name('image_title')} type="text" defaultValue={this.state.imageTitle} className="form-control" placeholder="Add a description of the image. Can be more than 1 sentence." />
        </div>
      </div>;
    }
  },

  renderButtons() {
    if ((this.state.uploadState === 'empty') || (this.state.uploadState === 'failed') || (this.state.uploadState === 'attached')) {
      const uploadLabel = this.props.buttonSize === 'small' ? 'Upload' : 'Upload Image';
      const browseLabel = this.props.buttonSize === 'small' ? 'Browse' : 'Browse Library';
      return <div>
        <input type="file" className="hidden" ref="fileInput" />
        {this.renderBulkUploadLink()}
      </div>;
    }
  },

  renderUploadButtons() {
    if (this.state.hover) {
      const uploadLabel = this.props.buttonSize === 'small' ? 'Upload' : 'Upload Image';
      const browseLabel = this.props.buttonSize === 'small' ? 'Browse' : 'Browse Library';
      return <div style={{position: 'absolute', top: 5, left: 20}}>
         <span className="btn-group btn-group-sm">
           <span onClick={this.triggerFileInput} className="btn btn-default">
             <i className="fa fa-cloud-upload" /> {uploadLabel}
           </span>
           <span onClick={this.loadInitialLibraryImages} className="btn btn-default">
             <i className="fa fa-th" /> {browseLabel}
           </span>
          {this.renderEmbedButton()}
         </span>
       </div>;
    }
  },

  renderEmbedButton() {
    if (this.props.allowEmbed) {
      return <span onClick={this.setKind.bind(null, 'embeds')} className="btn btn-default">
         Embed
       </span>;
    }
  },


  renderButtonRemove(id) {
    if (this.props.buttonRemove && ((this.state.uploadState === 'failed') || (this.state.uploadState === 'attached')) && this.state.hover) {
      return <span style={{position: 'absolute', bottom: 30, left: 20}}>
        <span className="btn btn-default" style={{marginRight: 10}} data-toggle="modal" data-target={`#image-attributes-${id}`} >
         <i className="fa fa-cog" />
        </span>
        <span onClick={this.removeImage} className="btn btn-sm btn-danger">
          <i className="fa fa-close" /> Remove
        </span>
      </span>;
    }
  },

  renderImageAttributes(id) {
    return <div id={`image-attributes-${id}`} className="modal fade">
        <div className="modal-dialog">
            <div className="modal-content">
                <div className="modal-header">
                    <span className="close" data-dismiss='modal'>&times;</span>
                    <h4 className="modal-title">Image Attributes</h4>
                </div>
                <div className="modal-body">
                    {this.renderInputs()}
                </div>
            </div>
        </div>
    </div>;
  },

  renderBulkUploadLink() {
    if (this.props.bulkUploadPath && (this.props.bulkUploadPath.length > 0)) {
      return <p className="small" style={{marginTop: 10}}>Have a lot of images to add? <a href={this.props.bulkUploadPath} target="_blank">Try Bulk Upload</a></p>;
    }
  },

  renderLibrary() {
    return <div id={this.id('library')} className="modal fade">
      <div className="modal-dialog">
        <div className="modal-content">
          <div className="modal-header">
            <span className="close" onClick={this.closeModal}>&times;</span>
            {this.renderLibraryLocalOnlyCheckbox()}
            <p className="h4 modal-title">Image Library</p>
          </div>
          <div className="modal-body">
            {this.renderLibraryBody()}
          </div>
        </div>
      </div>
    </div>;
  },

  closeModal() {
    return $(`#${this.id('library')}`).modal('hide');
  },

  renderLibraryLocalOnlyCheckbox() {
    if (this.props.showLocalOnlyOption) {
      return <div className="checkbox pull-right small" style={{marginTop: 3, marginRight: 20}}>
        <label>
          <input type="checkbox" onChange={this.toggleLibraryLocalOnly} defaultChecked={true} style={{marginTop: 2}} />
          Current Site Only
        </label>
      </div>;
    }
  },

  renderLibraryBody() {
    if (this.state.libraryLoaded) {
      return <div>
        <div className="row row-narrow">
          {this.renderLibraryImages()}
        </div>
        {this.renderLibraryMoreButton()}
      </div>;
    } else {
      return <div className="text-center" style={{marginTop: 50, marginBottom: 50}}>
        <i className="fa fa-spinner fa-spin fa-4x" />
      </div>;
    }
  },

  renderLibraryImages() {
    return this.state.libraryImages.map(this.renderLibraryImage);
  },

  renderLibraryImage(image) {
    return <div key={image.id} className="col-xs-4 col-sm-3 p-h-xs">
      <img onClick={this.selectImage.bind(null, image)} src={image.attachment_thumbnail_url} alt={image.alt} title={image.title} style={{maxWidth: '100%', cursor: 'pointer'}} data-dismiss="modal" />
    </div>;
  },

  renderLibraryMoreButton() {
    if (!this.state.libraryLoadedAll) {
      return <div className="row text-center">
        <div className="col-sm-4 col-sm-offset-4">
          <div onClick={this.loadMoreLibraryImages} className="btn btn-block btn-default">Load More</div>
        </div>
      </div>;
    }
  },

  renderEmbed() {
    return <div className="form-group">
        <input type="hidden" name={this.name('kind')} value={this.state.placementKind} />
        <div>
         <span className="btn-group btn-group-sm">
           <span onClick={this.setKind.bind(null, 'images')} className="btn btn-default">
             <i className="fa fa-arrow-left" /> Image
           </span>
         </span>
        </div>
      <textarea id={this.id('embed')} name={this.name('embed')} rows="6" className="form-control" defaultValue={this.state.placementEmbed} />
    </div>;
  },

  setKind(kind) {
    return this.setState({placementKind: kind});
  },

  initializeFileUpload() {
    if (!this.state.uploadXHR) {
      const uploadXHR = $(ReactDOM.findDOMNode(this)).fileupload({
        dataType: 'XML',
        url: this.props.presignedPost.url,
        formData: this.props.presignedPost.fields,
        paramName: 'file',
        dropZone: `#${this.id('dropzone')}`,
        add: this.uploadAdd,
        progress: this.uploadProgress,
        always: this.uploadAlways,
        done: this.uploadDone,
        fail: this.uploadFail
      });
      return this.setState({uploadXHR});
    }
  },

  loadInitialLibraryImages() {
    $(`#${this.id('library')}`).modal('show');
    if (!this.state.libraryLoaded) {
      return $.get(`${this.props.imagesPath}?page=${this.state.libraryPage}&local=${this.state.libraryLocalOnly}`, this.updateLibrary);
    }
  },

  loadMoreLibraryImages() {
    if (!this.state.libraryLoadedAll) {
      return $.get(`${this.props.imagesPath}?page=${this.state.libraryPage}&local=${this.state.libraryLocalOnly}`, this.updateLibrary);
    }
  },

  toggleLibraryLocalOnly() {
    const changes = {
      libraryImages: [],
      libraryLoaded: false,
      libraryLoadedAll: false,
      libraryLocalOnly: !this.state.libraryLocalOnly,
      libraryPage: 1
    };
    return this.setState(changes, this.loadInitialLibraryImages);
  },

  updateLibrary(data) {
    return this.setState({
      libraryImages: [].concat.apply(this.state.libraryImages, data.images),
      libraryLoaded: true,
      libraryLoadedAll: data.images.length < 24,
      libraryPage: this.state.libraryPage + 1
    });
  },

  selectImage(image) {
    this.setState({
      imageAlt: image.alt,
      imageAttachmentCacheURL: null,
      imageAttachmentContentType: image.attachment_content_type,
      imageAttachmentFileName: image.attachment_file_name,
      imageAttachmentFileSize: image.attachment_file_size,
      imageAttachmentURL: image.attachment_thumbnail_url,
      imageID: image.id,
      imageTitle: image.title,
      libraryVisible: false,
      placementDestroy: '',
      uploadState: 'attached'
    });
    $(`#${this.id('image_alt')}`).val(image.alt);
    return $(`#${this.id('image_title')}`).val(image.title);
  },

  removeImage(event) {
    event.preventDefault();
    if (this.state.uploadXHR) { this.state.uploadXHR.fileupload('destroy'); }
    this.setState({
      imageAlt: null,
      imageAttachmentCacheURL: null,
      imageAttachmentContentType: null,
      imageAttachmentFileName: null,
      imageAttachmentFileSize: null,
      imageAttachmentURL: null,
      imageID: null,
      imageTitle: null,
      placementDestroy: '1',
      uploadProgress: 0,
      uploadState: 'empty',
      uploadXHR: null
    });
    $(`#${this.id('image_alt')}`).val('');
    return $(`#${this.id('image_title')}`).val('');
  },

  uploadAdd(event, data) {
    this.disableClosestFormButton();
    const file = data.files[0];
    const reader = new FileReader();
    reader.onload = this.uploadRead.bind(null, file);
    reader.readAsDataURL(file);
    const formData = this.props.presignedPost.fields;
    formData['Content-Type'] = file.type;
    data.formData = formData;
    return data.submit();
  },

  uploadRead(file, event) {
    if (file.type.match(/^image/)) {
      this.setState({
        imageAlt: '',
        imageAttachmentCacheURL: event.target.result,
        imageAttachmentContentType: file.type,
        imageAttachmentFileName: file.name,
        imageAttachmentFileSize: file.size,
        imageAttachmentURL: null,
        imageID: null,
        imageTitle: '',
        placementDestroy: null,
        uploadState: 'uploading'
      });
      $(`#${this.id('image_alt')}`).val('');
      return $(`#${this.id('image_title')}`).val('');
    } else {
      this.setState({
        uploadState: ((this.state.imageAttachmentURL && (this.state.imageAttachmentURL.length > 0)) || (this.state.imageAttachmentURL && (this.state.imageAttachmentURL.length > 0))) ? 'attached' : 'empty'});
      this.enableClosestFormButton();
      return alert('Only PNG, JPG and GIF images are allowed.');
    }
  },

  uploadProgress(event, data) {
    if (this.state.uploadState === 'uploading') {
      return this.setState({
        uploadProgress: parseInt((data.loaded / data.total) * 100, 10)});
    }
  },

  uploadAlways() {
    return this.enableClosestFormButton();
  },

  uploadDone(event, data) {
    if (this.state.uploadState === 'uploading') {
      this.setState({
        imageAttachmentCacheURL: `//${this.props.presignedPost.host}/${$(data.jqXHR.responseXML).find('Key').text()}`,
        uploadState: 'finishing'
      });
      return setTimeout(this.uploadFinish, 500);
    }
  },

  uploadFinish() {
    if (this.state.uploadState === 'finishing') {
      this.state.uploadXHR.fileupload('destroy');
      const attributes = {
        uploadProgress: 0,
        uploadState: 'attached',
        uploadXHR: null
      };
      return this.setState(attributes, this.initializeFileUpload);
    }
  },

  uploadFail(event, data) {
    if (this.state.uploadState === 'uploading') {
      return this.setState({
        uploadState: 'failed'});
    }
  },

  id(value) {
    return `${this.props.inputPrefix.replace(/[\[\]]/g, '_').replace(/__/g, '_').replace(/\A_/, '').replace(/_\z/, '')}_${value}`;
  },

  name(value) {
    return `${this.props.inputPrefix}[${value}]`;
  },

  imageURL() {
    if (this.state.imageAttachmentCacheURL && (this.state.imageAttachmentCacheURL.length > 0)) {
      return this.state.imageAttachmentCacheURL;
    } else if (this.state.imageAttachmentURL && (this.state.imageAttachmentURL.length > 0)) {
      return this.state.imageAttachmentURL;
    }
  },

  progressWidthPercentage() {
    return `${this.state.uploadProgress}%`;
  },

  triggerFileInput() {
    return $(ReactDOM.findDOMNode(this.refs.fileInput)).click();
  },

  disableClosestFormButton() {
    const formButton = $(ReactDOM.findDOMNode(this)).closest('form').find('button[type="submit"]');
    return formButton.removeClass('btn-primary').addClass('disabled btn-default');
  },

  enableClosestFormButton() {
    const formButton = $(ReactDOM.findDOMNode(this)).closest('form').find('button[type="submit"]');
    return formButton.removeClass('disabled btn-default').addClass('btn-primary');
  }
});

// export default ImagePlacement;
