ImagesUpload = React.createClass
  propTypes:
    presignedPost: React.PropTypes.object.isRequired

  getInitialState: ->
    uploading: false
    uploads: []

  componentDidMount: ->
    $(ReactDOM.findDOMNode(this)).fileupload
      dataType: 'XML'
      url: this.props.presignedPost.url
      formData: this.props.presignedPost.fields
      paramName: 'file'
      dropZone: '.images-upload-dropzone'
      start: this.uploadStart
      add: this.uploadAdd
      progress: this.uploadProgress
      done: this.uploadDone
      fail: this.uploadFail

  render: ->
    `<div>
      {this.renderForm()}
      {this.renderUploads()}
    </div>`

  renderForm: ->
    if !this.state.uploading
      `<div>
        <input type="file" className="hidden" ref="fileInput" multiple />
        <div className="row">
          <div className="col-sm-4 col-sm-offset-4">
            <div onClick={this.triggerFileInput} className="btn btn-block btn-primary" style={{marginRight: 20}}><i className="fa fa-plus-circle"></i> Choose Images</div>
          </div>
        </div>
        <div className="images-upload-dropzone text-muted text-center" style={{border: 'dashed 1px #bbb', borderRadius: 2, fontSize: 18, margin: '40px 0', padding: '40px 20px'}}>Or drop images here to begin bulk upload.</div>
      </div>`

  renderUploads: ->
    if this.state.uploading
      this.state.uploads.map this.renderUpload

  renderUpload: (upload) ->
    `<div key={upload.key} style={{marginTop: 20, marginBottom: 20}}>
      <div>
        <div className="small clearfix">
          <strong>{upload.file_name}</strong> <span className="pull-right">{upload.file_size / 1000}kb</span>
        </div>
        {this.renderProgress(upload)}
        {this.renderStatus(upload)}
      </div>
    </div>`

  renderProgress: (upload) ->
    `<div className="progress" style={{marginTop: 5, marginBottom: 5}}>
      {this.renderProgressBar(upload)}
    </div>`

  renderProgressBar: (upload) ->
    if upload.status is 'uploading'
      `<div className="progress-bar progress-bar-striped active" style={{width: this.progressWidthPercentage(upload.progress)}} />`
    else if upload.status is 'finishing'
      `<div className="progress-bar progress-bar-striped progress-bar-success active" style={{width: '100%'}} />`
    else if upload.status is 'attached'
      `<div className="progress-bar progress-bar-success" style={{width: '100%'}} />`
    else if upload.status is 'failed'
      `<div className="progress-bar progress-bar-danger" style={{width: '100%'}} />`

  renderStatus: (upload) ->
    if upload.status is 'uploading'
      `<div className="small text-muted">Uploading...</div>`
    else if upload.status is 'finishing'
      `<div className="small text-muted">Saving...</div>`
    else if upload.status is 'attached'
      `<div className="small text-success">Saved.</div>`
    else if upload.status is 'failed'
      `<div className="small text-danger">Failed to upload image.</div>`

  uploadStart: ->
    this.setState uploading: true

  uploadAdd: (event, data) ->
    key = 'upload-' + parseInt(Math.random()*10**12)
    file = data.files[0]
    file.key = key
    formData = this.props.presignedPost.fields
    formData['Content-Type'] = file.type
    data.formData = formData
    data.submit()
    upload =
      content_type: file.type
      file_name: file.name
      file_size: file.size
      key: key
      progress: 0
      status: 'uploading'
    this.setState uploads: React.addons.update(this.state.uploads, $push: [upload])

  uploadProgress: (event, data) ->
    filter = (u) -> u.key == data.files[0].key
    existingUpload = this.state.uploads.filter(filter)[0]
    if existingUpload
      index = this.state.uploads.indexOf(existingUpload)
      progress = parseInt(data.loaded / data.total)
      newUpload = $.extend(existingUpload, progress: progress)
      this.setState uploads: React.addons.update(this.state.uploads, $splice: [[index, 1, newUpload]])

  uploadDone: (event, data) ->
    filter = (u) -> u.key == data.files[0].key
    existingUpload = this.state.uploads.filter(filter)[0]
    if existingUpload
      index = this.state.uploads.indexOf(existingUpload)
      urlKey = $(data.jqXHR.responseXML).find('Key').text()
      url = "//#{this.props.presignedPost.host}/#{urlKey}"
      newUpload = $.extend(existingUpload, status: 'finishing', url: url)
      this.setState uploads: React.addons.update(this.state.uploads, $splice: [[index, 1, newUpload]]), this.uploadTransfer.bind(null, data.files[0].key)

  uploadTransfer: (key) ->
    filter = (u) -> u.key == key
    existingUpload = this.state.uploads.filter(filter)[0]
    if existingUpload
      image_data =
        attachment_cache_url: existingUpload.url
        attachment_content_type: existingUpload.content_type
        attachment_file_size: existingUpload.file_size
        attachment_file_name: existingUpload.file_name
      aJ = $.ajax
        type: 'POST'
        url: this.props.uploadURL
        beforeSend: (xhr) -> xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
        cache: false
        data: { image: image_data }
        dataType: 'html'
      aJ.done this.uploadFinish.bind(null, key)
      aJ.fail this.uploadFail.bind(null, null, { files: [{ key: key }] })

  uploadFinish: (key) ->
    filter = (u) -> u.key == key
    existingUpload = this.state.uploads.filter(filter)[0]
    if existingUpload
      index = this.state.uploads.indexOf(existingUpload)
      newUpload = $.extend(existingUpload, status: 'attached')
      this.setState uploads: React.addons.update(this.state.uploads, $splice: [[index, 1, newUpload]])

  uploadFail: (event, data) ->
    filter = (u) -> u.key == data.files[0].key
    existingUpload = this.state.uploads.filter(filter)[0]
    if existingUpload
      index = this.state.uploads.indexOf(existingUpload)
      newUpload = $.extend(existingUpload, status: 'failed')
      this.setState uploads: React.addons.update(this.state.uploads, $splice: [[index, 1, newUpload]])

  progressWidthPercentage: (progress) ->
    progress + '%'

  triggerFileInput: ->
    $(this.refs.fileInput.getDOMNode()).click()

window.ImagesUpload = ImagesUpload
