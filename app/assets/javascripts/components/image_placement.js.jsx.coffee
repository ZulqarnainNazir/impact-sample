ImagePlacement = React.createClass
  propTypes:
    label: React.PropTypes.string
    inputPrefix: React.PropTypes.string
    imagesPath: React.PropTypes.string

  getInitialState: ->
    imagePlacementID: this.props.initialPlacementID
    imagePlacementDestroy: this.props.initialPlacementDestroy
    imageID: this.props.initialImageID
    imageURL: this.props.initialImageURL
    imageAlt: this.props.initialImageAlt
    imageTitle: this.props.initialImageTitle
    imageContentType: this.props.initialImageContentType
    imageFileName: this.props.initialImageFileName
    imageFileSize: this.props.initialImageFileSize
    libraryImages: []
    libraryLoaded: false
    libraryLoadedAll: false
    libraryPage: 1
    libraryVisible: false
    uploadState: 'empty'
    uploadProgress: 0
    uploadXHR: null

  componentDidMount: ->
    this.initializeFileUpload()

  render: ->
    `<div className="form-group">
      <label className="control-label">{this.props.label}</label>
      <input type="hidden" name={this.name('image_id')} value={this.state.imageID} />
      <input type="hidden" name={this.name('image_placement_id')} value={this.state.imagePlacementID} />
      <input type="hidden" name={this.name('image_placement_destroy')} value={this.state.imagePlacementDestroy} />
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
    if this.state.imagePlacementDestroy != '1' and this.state.imageURL and this.state.imageURL.length > 0
      `<div className={this.name('dropzone')}>
        <div className="small">
          <input type="hidden" name={this.name('image_cache_url')} value={this.state.imageURL} />
          <input type="hidden" name={this.name('image_file_name')} value={this.state.fileName} />
          <input type="hidden" name={this.name('image_file_size')} value={this.state.fileSize} />
          <input type="hidden" name={this.name('image_content_type')} value={this.state.contentType} />
          <div className="thumbnail">
            <img style={{width: '100%'}} src={this.state.imageURL} />
          </div>
          <div style={{overflow: 'hidden', whiteSpace: 'nowrap'}}><strong>{this.state.imageFileName}</strong></div>
          <div>{this.state.imageContentType} – {this.state.imageFileSize / 100}KB</div>
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
      `<div>
        <input type="file" className="hidden" ref="fileInput" />
        <span className="btn-group btn-group-sm">
          <span onClick={this.triggerFileInput} className="btn btn-default">
            <i className="fa fa-cloud-upload" /> Upload Image
          </span>
          <span onClick={this.loadInitialLibraryImages} className="btn btn-default" data-toggle="modal" data-target={'#' + this.id('library')}>
            <i className="fa fa-th" /> Browse Library
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
    `<div key={image.image_id} className="col-xs-2">
      <img onClick={this.selectImage.bind(null, image)} src={image.image_thumbnail_url} alt={image.image_alt} title={image.image_title} className="thumbnail" style={{width: 90, height: 90, cursor: 'pointer'}} data-dismiss="modal" />
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
        url: this.props.presignedPostURL
        formData: this.props.presignedPostFields
        paramName: 'file'
        dropZone: ".#{this.name('dropzone')}"
        add: this.uploadAdd
        start: this.uploadStart
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
      libraryVisible: false
      uploadState: 'attached'
      imageID: image.image_id
      imagePlacementDestroy: ''
      imageURL: image.image_url
      imageContentType: image.image_file_type
      imageFileName: image.image_file_name
      imageFileSize: image.image_file_size

  removeImage: (event) ->
    event.preventDefault()
    this.state.uploadXHR.fileupload('destroy') if this.state.uploadXHR
    this.setState
      imagePlacementDestroy: '1'
      imageID: null
      imageURL: null
      imageAlt: null
      imageTitle: null
      imageContentType: null
      imageFileName: null
      imageFileSize: null
      uploadState: 'empty'
      uploadProgress: 0
      uploadXHR: null

  uploadAdd: (event, data) ->
    file = data.files[0]
    reader = new FileReader()
    reader.onload = this.uploadRead.bind(null, file)
    reader.readAsDataURL file
    formData = this.props.presignedPostFields
    formData['Content-Type'] = file.type
    data.formData = formData
    data.submit()

  uploadRead: (file, event) ->
    this.setState
      imageID: null
      imagePlacementDestroy: null
      imageURL: event.target.result
      imageContentType: file.type
      imageFileName: file.name
      imageFileSize: file.size

  uploadStart: (event) ->
    this.setState
      uploadState: 'uploading'

  uploadProgress: (event, data) ->
    if this.state.uploadState is 'uploading'
      this.setState
        uploadProgress: parseInt(data.loaded / data.total * 100, 10)

  uploadDone: (event, data) ->
    if this.state.uploadState is 'uploading'
      this.setState
        imageURL: "//#{this.props.presignedPostHost}/#{$(data.jqXHR.responseXML).find('Key').text()}"
        uploadState: 'finishing'
      setTimeout this.uploadFinish, 500

  uploadFinish: ->
    if this.state.uploadState is 'finishing'
      this.state.uploadXHR.fileupload('destroy')
      attributes =
        uploadState: 'attached',
        uploadProgress: 0
        uploadXHR: null
      this.setState attributes, this.initializeFileUpload

  uploadFail: (event, data) ->
    if this.state.uploadState is 'uploading'
      this.setState
        uploadState: 'failed'

  id: (value) ->
    "#{this.props.inputPrefix}_#{value}"

  name: (value) ->
    "#{this.props.inputPrefix}[#{value}]"

  progressWidthPercentage: ->
    "#{this.state.uploadProgress}%"

  triggerFileInput: ->
    $(this.refs.fileInput.getDOMNode()).click()

window.ImagePlacement = ImagePlacement
