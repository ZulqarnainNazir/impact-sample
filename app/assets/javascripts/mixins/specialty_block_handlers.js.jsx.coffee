SpecialtyBlockHandlers =
  propTypes:
    initialSpecialtyBlock: React.PropTypes.object
    defaultSpecialtyBlockAttributes: React.PropTypes.object

  getInitialState: ->
    specialtyBlock: this.specialtyBlockInitial()

  specialtyBlockInputs: ->
    if this.props.initialSpecialtyBlock and this.state.specialtyBlock
      `<input key={this.specialtyBlockName('id')} type="hidden" name={this.specialtyBlockName('id')} value={this.props.initialSpecialtyBlock.id} />`
    else if this.props.initialSpecialtyBlock
      `<div>
        <input key={this.specialtyBlockName('id')} type="hidden" name={this.specialtyBlockName('id')} value={this.props.initialSpecialtyBlock.id} />
        <input key={this.specialtyBlockName('_destroy')} type="hidden" name={this.specialtyBlockName('_destroy')} value="1" />
      </div>`
    else
      `<div />`

  specialtyBlockProps: ->
    if this.state.specialtyBlock
      block: $.extend({}, this.state.specialtyBlock, { editing: this.state.editing, dropZoneClassName: this.specialtyBlockDropZoneClassName() })
      blockEditor: this.specialtyBlockEditorProps()
      blockImageLibrary: this.specialtyBlockImageLibraryProps()
      blockInputHeading: this.specialtyBlockInputHeadingProps()
      blockInputImage: this.specialtyBlockInputImageProps()
      blockInputText: this.specialtyBlockInputTextProps()
      blockOptions: this.specialtyBlockOptionsProps()
      blockInputsClassName: if this.state.specialtyBlock and this.state.specialtyBlock.displayImageLibrary then 'hide' else ''
      editing: this.state.editing
      name: this.specialtyBlockName
    else
      blockAdd: this.specialtyBlockAddProps()
      editing: this.state.editing

  # PRIVATE LEVEL 1

  specialtyBlockInitial: ->
    if this.props.initialSpecialtyBlock
      $.extend {}, this.specialtyBlockDefaultProps(), this.props.initialSpecialtyBlock

  specialtyBlockID: (name) ->
    "specialty-block-attributes-#{name}"

  specialtyBlockName: (name) ->
    "specialty_block_attributes[#{name}]"

  specialtyBlockDropZoneClassName: ->
    'specialty-block-drop-zone'

  specialtyBlockAddProps: ->
    visible: !this.state.specialtyBlock
    onClick: this.specialtyBlockAdd
    content: 'Add a Specialty Block'

  specialtyBlockEditorProps: ->
    id: 'specialty-block-editor'
    title: 'Edit Specialty Block Details'
    swapForm: this.specialtyBlockSwapForm
    resetForm: this.specialtyBlockResetForm

  specialtyBlockImageLibraryProps: ->
    visible: this.state.specialtyBlock and this.state.specialtyBlock.displayImageLibrary
    hide: this.specialtyBlockUpdate.bind(null, displayImageLibrary: false)

  specialtyBlockInputHeadingProps: ->
    id: this.specialtyBlockID('heading')
    name: this.specialtyBlockName('heading')
    value: this.state.specialtyBlock.heading
    label: 'Heading'

  specialtyBlockInputImageProps: ->
    init: this.specialtyBlockImageInit
    id: this.specialtyBlockID
    name: this.specialtyBlockName
    showImageLibrary: this.specialtyBlockUpdate.bind(null, displayImageLibrary: true)
    alt: this.state.specialtyBlock.image_alt
    image_id: this.state.specialtyBlock.image_id
    image_placement_id: this.state.specialtyBlock.image_placement_id
    attached_url: this.state.specialtyBlock.image_url
    cache_url: this.state.specialtyBlock.image_cache_url
    temp_cache_url: this.state.specialtyBlock.image_temp_cache_url
    progress: this.state.specialtyBlock.image_progress
    title: this.state.specialtyBlock.image_title
    state: this.state.specialtyBlock.image_state
    file_name: this.state.specialtyBlock.image_file_name
    file_size: this.state.specialtyBlock.image_file_size
    file_type: this.state.specialtyBlock.image_file_type
    temp_file_name: this.state.specialtyBlock.image_temp_file_name
    temp_file_size: this.state.specialtyBlock.image_temp_file_size
    temp_file_type: this.state.specialtyBlock.image_temp_file_type
    label: 'Background Image'
    dropZoneClassName: this.specialtyBlockDropZoneClassName()

  specialtyBlockInputTextProps: ->
    id: this.specialtyBlockID('text')
    name: this.specialtyBlockName('text')
    value: this.state.specialtyBlock.text
    label: 'Text'
    rows: 4

  specialtyBlockOptionsProps: ->
    visible: this.state.editing
    prev: this.specialtyBlockPrevTheme
    next: this.specialtyBlockNextTheme
    editorTarget: '#specialty-block-editor'
    editLabel: 'Edit Details'
    removeLabel: 'Remove Specialty Block'
    onRemove: this.specialtyBlockRemove
    onEdit: this.specialtyBlockEdit

  # PRIVATE LEVEL 2

  specialtyBlockDefaultProps: ->
    image_progress: 0
    image_state: 'empty'
    displayImageLibrary: false
    heading: 'Heading'
    text: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.
      Aenean ultricies ultrices mi eu maximus. Curabitur dignissim libero
      quis sem suscipit tristique. Nunc convallis lorem ut sagittis faucibus.'

  specialtyBlockAdd: (event, callback) ->
    event.preventDefault() if event
    this.specialtyBlockSave $set: $.extend({}, this.specialtyBlockDefaultProps(), (this.props.defaultSpecialtyBlockAttributes or {})), callback

  specialtyBlockEdit: ->

  specialtyBlockUpdate: (attributes, event, callback) ->
    event.preventDefault() if event
    this.specialtyBlockSave $merge: attributes, callback

  specialtyBlockRemove: (event, callback) ->
    event.preventDefault() if event
    if this.state.specialtyBlock.upload_xhr
      $(this.state.specialtyBlock.upload_xhr.getDOMNode()).fileupload('destroy')
    this.specialtyBlockSave $set: null, callback

  specialtyBlockSwapForm: () ->
    if this.state.specialtyBlock.image_temp_cache_url and this.state.specialtyBlock.image_temp_cache_url.length > 0
      this.specialtyBlockUpdate
        image_url: this.state.specialtyBlock.image_temp_cache_url
        image_cache_url: this.state.specialtyBlock.image_temp_cache_url
        image_temp_cache_url: null
        image_file_name: this.state.specialtyBlock.image_temp_file_name
        image_temp_file_name: null
        image_file_size: this.state.specialtyBlock.image_temp_file_size
        image_temp_file_size: null
        image_file_type: this.state.specialtyBlock.image_temp_file_type
        image_temp_file_type: null
        image_alt: this.specialtyBlockInputGetVal('image_alt')
        image_title: this.specialtyBlockInputGetVal('image_title')
        heading: this.specialtyBlockInputGetVal('heading')
        text: this.specialtyBlockInputGetVal('text')
    else
      this.specialtyBlockUpdate
        image_alt: this.specialtyBlockInputGetVal('image_alt')
        image_title: this.specialtyBlockInputGetVal('image_title')
        heading: this.specialtyBlockInputGetVal('heading')
        text: this.specialtyBlockInputGetVal('text')

  specialtyBlockResetForm: () ->
    attributes =
      image_temp_cache__url: null
      image_temp_file_name: null
      image_temp_file_size: null
      image_temp_file_type: null
    callback = null
    if this.state.specialtyBlock.upload_xhr
      $(this.state.specialtyBlock.upload_xhr.getDOMNode()).fileupload('destroy')
      attributes.upload_xhr = null
      callback = this.specialtyBlockImageInit.bind(null, this.state.specialtyBlock.upload_xhr)
    if (this.state.specialtyBlock.image_url and this.state.specialtyBlock.image_url.length > 0) or (this.state.specialtyBlock.image_cache_url and this.state.specialtyBlock.image_cache_url.length > 0)
      attributes.image_state = 'attached'
    else
      attributes.image_state = 'empty'
    this.specialtyBlockUpdate attributes, null, callback
    this.specialtyBlockInputSetVal 'image_alt', this.state.specialtyBlock.image_alt
    this.specialtyBlockInputSetVal 'image_title', this.state.specialtyBlock.image_title
    this.specialtyBlockInputSetVal 'heading', this.state.specialtyBlock.heading
    this.specialtyBlockInputSetVal 'text', this.state.specialtyBlock.text

  specialtyBlockImageInit: (component) ->
    unless this.state.specialtyBlock.upload_xhr
      $(component.getDOMNode()).fileupload
        dataType: 'XML'
        url: this.props.presignedPostURL
        formData: this.props.presignedPostFields
        paramName: 'file'
        dropZone: ".#{this.specialtyBlockDropZoneClassName()}"
        add: this.specialtyBlockImageAdd
        start: this.specialtyBlockImageStart
        progress: this.specialtyBlockImageProgress
        done: this.specialtyBlockImageDone
        fail: this.specialtyBlockImageFail
      this.specialtyBlockUpdate upload_xhr: component

  specialtyBlockPrevTheme: ->
    this.specialtyBlockUpdate theme: this.prevItem(this.specialtyBlockThemes, this.state.specialtyBlock.theme)

  specialtyBlockNextTheme: ->
    this.specialtyBlockUpdate theme: this.nextItem(this.specialtyBlockThemes, this.state.specialtyBlock.theme)

  # PRIVATE LEVEL 3

  specialtyBlockSave: (changes, callback) ->
    updated = React.addons.update(this.state, specialtyBlock: changes)
    if typeof(callback) is 'function'
      this.setState updated, callback
    else
      this.setState updated

  specialtyBlockInputGetVal: (name) ->
    $('#' + this.specialtyBlockID(name)).val()

  specialtyBlockInputSetVal: (name, value) ->
    $('#' + this.specialtyBlockID(name)).val(value)

  specialtyBlockThemes: ['left', 'right']

  specialtyBlockImageAdd: (event, data) ->
    file = data.files[0]
    reader = new FileReader()
    reader.onload = this.specialtyBlockImageRead.bind(null, file)
    reader.readAsDataURL file
    formData = this.props.presignedPostFields
    formData['Content-Type'] = file.type
    data.formData = formData
    data.submit()

  specialtyBlockImageStart: (event) ->
    this.specialtyBlockUpdate image_state: 'uploading'

  specialtyBlockImageProgress: (event, data) ->
    if this.state.specialtyBlock and this.state.specialtyBlock.image_state is 'uploading'
      this.specialtyBlockUpdate
        image_progress: parseInt(data.loaded / data.total * 100, 10)

  specialtyBlockImageDone: (event, data) ->
    if this.state.specialtyBlock and this.state.specialtyBlock.image_state is 'uploading'
      key = $(data.jqXHR.responseXML).find('Key').text()
      url = "//#{this.props.presignedPostHost}/#{key}"
      this.specialtyBlockUpdate
        image_temp_cache_url: url
        image_state: 'finishing'
      setTimeout this.specialtyBlockImageFinish, 500

  specialtyBlockImageFinish: ->
    if this.state.specialtyBlock and this.state.specialtyBlock.image_state is 'finishing'
      $(this.state.specialtyBlock.upload_xhr.getDOMNode()).fileupload('destroy')
      this.specialtyBlockUpdate image_state: 'attached', upload_xhr: null, null, this.specialtyBlockImageInit.bind(null, this.state.specialtyBlock.upload_xhr)

  specialtyBlockImageFail: (event, data) ->
    if this.state.specialtyBlock and this.state.specialtyBlock.image_state is 'uploading'
      this.specialtyBlockUpdate image_state: 'failed'

  # PRIVATE LEVEL 4

  specialtyBlockImageRead: (file, event) ->
    this.specialtyBlockUpdate
      image_temp_cache_url: event.target.result
      image_temp_file_name: file.name
      image_temp_file_size: file.size
      image_temp_file_type: file.type

window.SpecialtyBlockHandlers = SpecialtyBlockHandlers
