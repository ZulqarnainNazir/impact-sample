BlockInputImage = React.createClass
  mixins: [React.addons.PureRenderMixin]

  propTypes:
    id: React.PropTypes.func.isRequired
    name: React.PropTypes.func.isRequired
    init: React.PropTypes.func.isRequired
    showImageLibrary: React.PropTypes.func.isRequired
    alt: React.PropTypes.string
    progress: React.PropTypes.number
    state: React.PropTypes.string
    image_id: React.PropTypes.number
    image_placement_id: React.PropTypes.number
    title: React.PropTypes.string
    attached_url: React.PropTypes.string
    cache_url: React.PropTypes.string
    temp_cache_url: React.PropTypes.string
    file_name: React.PropTypes.string
    file_size: React.PropTypes.number
    file_type: React.PropTypes.string
    temp_file_name: React.PropTypes.string
    temp_file_size: React.PropTypes.number
    temp_file_type: React.PropTypes.string
    label: React.PropTypes.string
    dropZoneClassName: React.PropTypes.string

  defDefaultProps: ->
    progress: 0
    state: 'empty'
    label: 'Image'

  componentDidMount: ->
    this.props.init(this) if this.props.state is 'empty' or this.props.state is 'attached'

  progressWidthCSS: ->
    "#{this.props.progress}%"

  triggerFileInput: ->
    $(this.refs.fileInput.getDOMNode()).click()

  fileName: ->
    if this.props.temp_file_name and this.props.temp_file_name.length > 0
      this.props.temp_file_name
    else
      this.props.file_name

  fileType: ->
    if this.props.temp_file_type and this.props.temp_file_type.length > 0
      this.props.temp_file_type
    else
      this.props.file_type

  fileSize: ->
    if this.props.temp_file_size
      "#{Math.floor(this.props.temp_file_size / 1000)}KB"
    else if this.props.file_size
      "#{Math.floor(this.props.file_size / 1000)}KB"

  url: ->
    if this.props.temp_cache_url and this.props.temp_cache_url.length > 0
      this.props.temp_cache_url
    else if this.props.cache_url and this.props.cache_url.length > 0
      this.props.cache_url
    else if this.props.attached_url and this.props.attached_url.length > 0
      this.props.attached_url
    else ''

  render: ->
    `<div className="form-group">
      <label className="control-label">{this.props.label}</label>
      <input type="hidden" name={this.props.name('image_id')} value={this.props.image_id} />
      <input type="hidden" name={this.props.name('image_placement_id')} value={this.props.image_placement_id} />
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
    </div>`

  renderImage: ->
    if this.url()
      `<div className={this.props.dropZoneClassName}>
        <div className="small">
          <input type="hidden" name={this.props.name('image_cache_url')} value={this.props.cache_url} />
          <input type="hidden" name={this.props.name('image_file_name')} value={this.props.file_name} />
          <input type="hidden" name={this.props.name('image_file_size')} value={this.props.file_size} />
          <input type="hidden" name={this.props.name('image_content_type')} value={this.props.file_type} />
          <div className="thumbnail"><img style={{width: '100%'}} src={this.url()} /></div>
          <div style={{overflow: 'hidden', whiteSpace: 'nowrap'}}><strong>{this.fileName()}</strong></div>
          <div>{this.fileType()} – {this.fileSize()}</div>
        </div>
      </div>`
    else
      `<div className={this.props.dropZoneClassName}>
        <ImageEmpty padding="20" />
      </div>`

  renderProgress: ->
    if this.props.state is 'uploading'
      `<div>
        <i className="fa fa-close pull-right" />
        <div className="progress" style={{marginRight: 20}}>
          <div className="progress-bar progress-bar-striped active" style={{width: this.progressWidthCSS()}} />
        </div>
      </div>`
    else if this.props.state is 'finishing'
      `<div className="progress">
        <div className="progress-bar progress-bar-success" style={{width: '100%'}} />
      </div>`
    else if this.props.state is 'failed'
      `<div className="progress">
        <div className="progress-bar progress-bar-danger" style={{width: '100%'}} />
      </div>`

  renderInputs: ->
    if this.props.state is 'uploading' or this.props.state is 'finishing' or this.props.state is 'attached'
      `<div>
        <div className="form-group">
          <label htmlFor={this.props.id('image_alt')} className="control-label"><code>ALT</code> Attribute</label>
          <input id={this.props.id('image_alt')} name={this.props.name('image_alt')} type="text" defaultValue={this.props.alt} className="form-control" />
        </div>
        <div className="form-group">
          <label htmlFor={this.props.id('image_title')} className="control-label"><code>Title</code> Attribute</label>
          <input id={this.props.id('image_title')} name={this.props.name('image_title')} type="text" defaultValue={this.props.title} className="form-control" />
        </div>
      </div>`

  renderButtons: ->
    if this.props.state is 'empty' or this.props.state is 'failed' or this.props.state is 'attached'
      `<div>
        <input type="file" className="hidden" ref="fileInput" />
        <span className="btn-group btn-group-sm">
          <span onClick={this.triggerFileInput} className="btn btn-default">
            <i className="fa fa-cloud-upload" /> Upload Image
          </span>
          <span onClick={this.props.showImageLibrary} className="btn btn-default">
            <i className="fa fa-th" /> Browse Library
          </span>
        </span>
        <span className="btn btn-sm btn-danger pull-right">
          <i className="fa fa-close" /> Remove
        </span>
      </div>`

window.BlockInputImage = BlockInputImage
