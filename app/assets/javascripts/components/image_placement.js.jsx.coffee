ImagePlacement = React.createClass
  propTypes:
    imagesPath: React.PropTypes.string.isRequired
    inputPrefix: React.PropTypes.string.isRequired
    label: React.PropTypes.string.isRequired
    placement: React.PropTypes.object.isRequired
    presignedPost: React.PropTypes.object.isRequired
    buttonsSize: React.PropTypes.string

  getInitialState: ->
    imageAlt: this.props.placement.image.alt
    imageAttachmentCacheURL: this.props.placement.image.attachment_cache_url
    imageAttachmentContentType: this.props.placement.image.attachment_content_type
    imageAttachmentFileName: this.props.placement.image.attachment_file_name
    imageAttachmentFileSize: this.props.placement.image.attachment_file_size
    imageAttachmentURL: this.props.placement.image.attachment_url
    imageID: this.props.placement.image.id
    imageTitle: this.props.placement.image.title
    libraryImages: []
    libraryLoaded: false
    libraryLoadedAll: false
    libraryPage: 1
    libraryVisible: false
    placementDestroy: null
    placementID: this.props.placement.id
    uploadProgress: 0
    uploadState: if this.props.placement.image.attachment_url and this.props.placement.image.attachment_url.length > 0 then 'attached' else 'empty'
    uploadXHR: null

  componentDidMount: ->
    this.initializeFileUpload()

  render: ->
    `<div className="form-group">
      <label className="control-label">{this.props.label}</label>
      <input type="hidden" name={this.name('id')} value={this.state.placementID} />
      <input type="hidden" name={this.name('_destroy')} value={this.state.placementDestroy} />
      <input type="hidden" name={this.name('image_id')} value={this.state.imageID} />
      <div className="row">
        <div className="col-sm-4">
          {this.renderImage()}
        </div>
        <div className="col-sm-8">
          {this.renderProgress()}
          {this.renderInputs()}
          {this.renderButtons()}
        </div>
      </div>
      {this.renderLibrary()}
    </div>`

  renderImage: ->
    if this.state.placementDestroy != '1' and this.imageURL()
      `<div className={this.name('dropzone')}>
        <div className="small">
          <input type="hidden" name={this.name('image_attachment_cache_url')} value={this.state.imageAttachmentCacheURL} />
          <input type="hidden" name={this.name('image_attachment_content_type')} value={this.state.imageAttachmentContentType} />
          <input type="hidden" name={this.name('image_attachment_file_name')} value={this.state.imageAttachmentFileName} />
          <input type="hidden" name={this.name('image_attachment_file_size')} value={this.state.imageAttachmentFileSize} />
          <div className="thumbnail">
            <img style={{width: '100%'}} src={this.imageURL()} alt={this.state.imageAlt} title={this.state.imageTitle} />
          </div>
          <div style={{overflow: 'hidden', whiteSpace: 'nowrap'}}><strong>{this.state.imageAttachmentFileName}</strong></div>
          <div>{this.state.imageAttachmentContentType} – {this.state.imageAttachmentFileSize / 100}KB</div>
        </div>
      </div>`
    else
      `<div className={this.name('dropzone')}>
        <ImageEmpty padding="20" />
      </div>`

  renderProgress: ->
    if this.state.uploadState is 'uploading'
      `<div>
        <i className="fa fa-close pull-right" />
        <div className="progress" style={{marginRight: 20}}>
          <div className="progress-bar progress-bar-striped active" style={{width: this.progressWidthPercentage()}} />
        </div>
      </div>`
    else if this.state.uploadState is 'finishing'
      `<div className="progress">
        <div className="progress-bar progress-bar-success" style={{width: '100%'}} />
      </div>`
    else if this.state.uploadState is 'failed'
      `<div className="progress">
        <div className="progress-bar progress-bar-danger" style={{width: '100%'}} />
      </div>`

  renderInputs: ->
    if this.state.uploadState is 'uploading' or this.state.uploadState is 'finishing' or this.state.uploadState is 'attached'
      `<div>
        <div className="form-group">
          <label htmlFor={this.id('image_alt')} className="control-label"><code>ALT</code> Attribute</label>
          <input id={this.id('image_alt')} name={this.name('image_alt')} type="text" defaultValue={this.state.imageAlt} className="form-control" />
        </div>
        <div className="form-group">
          <label htmlFor={this.id('image_title')} className="control-label"><code>Title</code> Attribute</label>
          <input id={this.id('image_title')} name={this.name('image_title')} type="text" defaultValue={this.state.imageTitle} className="form-control" />
        </div>
      </div>`

  renderButtons: ->
    if this.state.uploadState is 'empty' or this.state.uploadState is 'failed' or this.state.uploadState is 'attached'
      uploadLabel = if this.props.buttonsSize is 'small' then 'Upload' else 'Upload Image'
      browseLabel = if this.props.buttonsSize is 'small' then 'Browse' else 'Browse Library'
      `<div>
        <input type="file" className="hidden" ref="fileInput" />
        <span className="btn-group btn-group-sm">
          <span onClick={this.triggerFileInput} className="btn btn-default">
            <i className="fa fa-cloud-upload" /> {uploadLabel}
          </span>
          <span onClick={this.loadInitialLibraryImages} className="btn btn-default" data-toggle="modal" data-target={'#' + this.id('library')}>
            <i className="fa fa-th" /> {browseLabel}
          </span>
        </span>
        <span onClick={this.removeImage} className="btn btn-sm btn-danger pull-right">
          <i className="fa fa-close" /> Remove
        </span>
      </div>`

  renderLibrary: ->
    `<div id={this.id('library')} className="modal fade">
      <div className="modal-dialog">
        <div className="modal-content">
          <div className="modal-header">
            <span className="close" data-dismiss="modal">&times;</span>
            <p className="h4 modal-title">Image Library</p>
          </div>
          <div className="modal-body">
            {this.renderLibraryBody()}
          </div>
        </div>
      </div>
    </div>`

  renderLibraryBody: ->
    if this.state.libraryLoaded
      `<div className="row row-narrow">
        {this.renderLibraryImages()}
        {this.renderLibraryMoreButton()}
      </div>`
    else
      `<div className="text-center" style={{marginTop: 50, marginBottom: 50}}>
        <i className="fa fa-spinner fa-spin fa-4x" />
      </div>`

  renderLibraryImages: ->
    this.state.libraryImages.map this.renderLibraryImage

  renderLibraryImage: (image) ->
    `<div key={image.id} className="col-xs-2">
      <img onClick={this.selectImage.bind(null, image)} src={image.attachment_thumbnail_url} alt={image.alt} title={image.title} className="thumbnail" style={{width: 90, height: 90, cursor: 'pointer'}} data-dismiss="modal" />
    </div>`

  renderLibraryMoreButton: ->
    unless this.state.libraryLoadedAll
      `<div className="row text-center">
        <div className="col-sm-4 col-sm-offset-4">
          <div onClick={this.loadMoreLibraryImages} className="btn btn-block btn-default">Load More</div>
        </div>
      </div>`

  initializeFileUpload: ->
    unless this.state.uploadXHR
      uploadXHR = $(this.getDOMNode()).fileupload
        dataType: 'XML'
        url: this.props.presignedPost.url
        formData: this.props.presignedPost.fields
        paramName: 'file'
        dropZone: ".#{this.name('dropzone')}"
        add: this.uploadAdd
        progress: this.uploadProgress
        done: this.uploadDone
        fail: this.uploadFail
      this.setState uploadXHR: uploadXHR

  loadInitialLibraryImages: ->
    unless this.state.libraryLoaded
      $.get "#{this.props.imagesPath}?page=#{this.state.libraryPage}", this.updateLibrary

  loadMoreLibraryImages: ->
    unless this.state.libraryLoadedAll
      $.get "#{this.props.imagesPath}?page=#{this.state.libraryPage}", this.updateLibrary

  updateLibrary: (data) ->
    this.setState
      libraryImages: [].concat.apply(this.state.libraryImages, data.images)
      libraryLoaded: true
      libraryLoadedAll: data.images.length < 48
      libraryPage: this.state.libraryPage + 1

  selectImage: (image) ->
    this.setState
      imageAlt: image.alt
      imageAttachmentCacheURL: null
      imageAttachmentContentType: image.attachment_content_type
      imageAttachmentFileName: image.attachment_file_name
      imageAttachmentFileSize: image.attachment_file_size
      imageAttachmentURL: image.attachment_url
      imageID: image.id
      imageTitle: image.title
      libraryVisible: false
      placementDestroy: ''
      uploadState: 'attached'
    $('#' + this.id('image_alt')).val(image.alt)
    $('#' + this.id('image_title')).val(image.title)

  removeImage: (event) ->
    event.preventDefault()
    this.state.uploadXHR.fileupload('destroy') if this.state.uploadXHR
    this.setState
      imageAlt: null
      imageAttachmentCacheURL: null
      imageAttachmentContentType: null
      imageAttachmentFileName: null
      imageAttachmentFileSize: null
      imageAttachmentURL: null
      imageID: null
      imageTitle: null
      placementDestroy: '1'
      uploadProgress: 0
      uploadState: 'empty'
      uploadXHR: null
    $('#' + this.id('image_alt')).val('')
    $('#' + this.id('image_title')).val('')

  uploadAdd: (event, data) ->
    file = data.files[0]
    reader = new FileReader()
    reader.onload = this.uploadRead.bind(null, file)
    reader.readAsDataURL file
    formData = this.props.presignedPost.fields
    formData['Content-Type'] = file.type
    data.formData = formData
    data.submit()

  uploadRead: (file, event) ->
    this.setState
      imageAlt: ''
      imageAttachmentCacheURL: event.target.result
      imageAttachmentContentType: file.type
      imageAttachmentFileName: file.name
      imageAttachmentFileSize: file.size
      imageAttachmentURL: null
      imageID: null
      imageTitle: ''
      placementDestroy: null
      uploadState: 'uploading'
    $('#' + this.id('image_alt')).val('')
    $('#' + this.id('image_title')).val('')

  uploadProgress: (event, data) ->
    if this.state.uploadState is 'uploading'
      this.setState
        uploadProgress: parseInt(data.loaded / data.total * 100, 10)

  uploadDone: (event, data) ->
    if this.state.uploadState is 'uploading'
      this.setState
        imageAttachmentCacheURL: "//#{this.props.presignedPost.host}/#{$(data.jqXHR.responseXML).find('Key').text()}"
        uploadState: 'finishing'
      setTimeout this.uploadFinish, 500

  uploadFinish: ->
    if this.state.uploadState is 'finishing'
      this.state.uploadXHR.fileupload('destroy')
      attributes =
        uploadProgress: 0
        uploadState: 'attached',
        uploadXHR: null
      this.setState attributes, this.initializeFileUpload

  uploadFail: (event, data) ->
    if this.state.uploadState is 'uploading'
      this.setState
        uploadState: 'failed'

  id: (value) ->
    "#{this.props.inputPrefix.replace('[', '').replace(']', '')}_#{value}".replace(/__/, '_')

  name: (value) ->
    "#{this.props.inputPrefix}[#{value}]"

  imageURL: ->
    if this.state.imageAttachmentCacheURL and this.state.imageAttachmentCacheURL.length > 0
      this.state.imageAttachmentCacheURL
    else if this.state.imageAttachmentURL and this.state.imageAttachmentURL.length > 0
      this.state.imageAttachmentURL

  progressWidthPercentage: ->
    "#{this.state.uploadProgress}%"

  triggerFileInput: ->
    $(this.refs.fileInput.getDOMNode()).click()

window.ImagePlacement = ImagePlacement