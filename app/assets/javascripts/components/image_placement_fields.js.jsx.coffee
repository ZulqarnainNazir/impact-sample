ImagePlacementFields = React.createClass
  propTypes:
    initialAlt: React.PropTypes.string
    initialFileName: React.PropTypes.string
    initialFileSize: React.PropTypes.number
    initialFileType: React.PropTypes.string
    initialTitle: React.PropTypes.string
    initialUrl: React.PropTypes.string
    presignedPostFields: React.PropTypes.object
    presignedPostHost: React.PropTypes.string
    presignedPostUrl: React.PropTypes.string
    imageReceivers: React.PropTypes.arrayOf(React.PropTypes.func)

  getInitialState: ->
    alt: this.props.initialAlt
    fileName: this.props.initialFileName
    fileSize: this.props.initialFileSize
    fileType: this.props.initialFileType
    progress: 0
    state: if this.props.initialUrl.length > 0 then 'stored' else 'empty'
    title: this.props.initialTitle
    uploadXHR: null
    url: this.props.initialUrl

  render: ->
    `<div className="row">
      <div className="col-sm-4">
        <ImagePlacementThumbnail url={this.state.url} alt={this.state.alt} title={this.state.title} />
      </div>
      <div className="col-sm-8">
        <ImagePlacementDropZone ref="dropZone" state={this.state.state} />
        <ImagePlacementFileDetails state={this.state.state} fileName={this.state.fileName} fileSize={this.state.fileSize} />
        <ImagePlacementProgressBar state={this.state.state} progress={this.state.progress} />
        <ImagePlacementButtons state={this.state.state} cancel={this.cancel} edit={this.edit} reset={this.reset} />
        <ImagePlacementMetaModal ref="metaModal" alt={this.state.alt} title={this.state.title} onClick={this.updateMetaData} />
      </div>
    </div>`

  componentDidMount: ->
    this.initializeFileUpload() if this.state.state is 'empty'

  initializeFileUpload: ->
    this.setState uploadXHR: $(this.getDOMNode()).fileupload
      dataType: 'XML'
      url: this.props.presignedPostUrl
      formData: this.props.presignedPostFields
      paramName: 'file'
      dropZone: $(this.refs.dropZone.refs.dropZone.getDOMNode())
      add: this.add
      start: this.start
      progress: this.progress
      done: this.done
      fail: this.fail

  add: (e, data) ->
    file = data.files[0]
    reader = new FileReader()
    reader.onload = this.readTargetResult
    reader.readAsDataURL file
    formData = this.props.presignedPostFields
    formData['Content-Type'] = file.type
    data.formData = formData
    data.submit()
    this.setState fileName: file.name, fileSize: file.size, fileType: file.type
    $(this.getDOMNode()).closest('.image-placement-fields').find('input[name*="attachment_content_type"]').val file.type
    $(this.getDOMNode()).closest('.image-placement-fields').find('input[name*="attachment_file_name"]').val file.name
    $(this.getDOMNode()).closest('.image-placement-fields').find('input[name*="attachment_file_size"]').val file.size
    $(this.getDOMNode()).closest('.image-placement-fields').find('input[name*="placement"][name*="_destroy"]').val ''

  readTargetResult: (e) ->
    this.setState url: e.target.result
    recieve(e.target.result) for recieve in this.props.imageReceivers

  start: (e) ->
    this.setState state: 'uploading'
    this.disableFormButton()

  progress: (e, data) ->
    if this.state.state is 'uploading'
      this.setState progress: parseInt(data.loaded / data.total * 100, 10)

  done: (e, data) ->
    if this.state.state is 'uploading'
      key = $(data.jqXHR.responseXML).find('Key').text()
      url = "//#{this.props.presignedPostHost}/#{key}"
      $(this.getDOMNode()).closest('.image-placement-fields').find('input[name*="attachment_cache_url"]').val url
      this.setState state: 'cached'
      this.reenableFormButton()

  fail: (e, data) ->
    if this.state.state is 'uploading'
      this.setState state: 'failed'
      this.reenableFormButton()

  cancel: ->
    this.reenableFormButton()
    this.reset()

  edit: ->
    $(this.refs.metaModal.refs.modal.getDOMNode()).modal('show')

  updateMetaData: ->
    $(this.refs.metaModal.refs.modal.getDOMNode()).modal('hide')
    modal = $(this.refs.metaModal.refs.modal.getDOMNode())
    alt = modal.find('input[name="alt"]').val()
    title = modal.find('input[name="title"]').val()
    $(this.getDOMNode()).closest('.image-placement-fields').find('input[name*="alt"]').val alt
    $(this.getDOMNode()).closest('.image-placement-fields').find('input[name*="title"]').val title
    this.setState alt: alt, title: title

  reset: ->
    $(this.getDOMNode()).fileupload('destroy') if this.state.uploadXHR
    $(this.getDOMNode()).closest('.image-placement-fields').find('input[name*="id"].image_id').remove()
    $(this.getDOMNode()).closest('.image-placement-fields').find('input[name*="attachment_alt"]').val ''
    $(this.getDOMNode()).closest('.image-placement-fields').find('input[name*="attachment_title"]').val ''
    $(this.getDOMNode()).closest('.image-placement-fields').find('input[name*="attachment_cache_url"]').val ''
    $(this.getDOMNode()).closest('.image-placement-fields').find('input[name*="attachment_content_type"]').val ''
    $(this.getDOMNode()).closest('.image-placement-fields').find('input[name*="attachment_file_name"]').val ''
    $(this.getDOMNode()).closest('.image-placement-fields').find('input[name*="attachment_file_size"]').val ''
    $(this.getDOMNode()).closest('.image-placement-fields').find('input[name*="placement"][name*="_destroy"]').val '1'
    $(this.getDOMNode()).closest('.image-placement-fields').find('input[name*="alt"]').val ''
    $(this.getDOMNode()).closest('.image-placement-fields').find('input[name*="title"]').val ''
    this.setState state: 'empty', alt: '', title: '', fileName: '', fileSize: 0, fileType: '', uploadXHR: null, url: '', progress: 0, ->
      this.initializeFileUpload()
    recieve(null) for recieve in this.props.imageReceivers

  disableFormButton: ->
    button = $(this.getDOMNode()).closest('form').find('button')
    button.removeClass('btn-primary').addClass('btn-default').addClass('disabled').prepend
    button.prepend $('<i class="fa fa-spin fa-spinner" style="margin-right:1em">')

  reenableFormButton: ->
    button = $(this.getDOMNode()).closest('form').find('button')
    button.removeClass('btn-default').addClass('btn-primary').removeClass('disabled').find('i.fa-spin').remove()

window.ImagePlacementFields = ImagePlacementFields
