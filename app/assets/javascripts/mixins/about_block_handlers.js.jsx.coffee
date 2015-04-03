AboutBlockHandlers =
  propTypes:
    initialAboutBlock: React.PropTypes.object
    defaultAboutBlockAttributes: React.PropTypes.object

  getInitialState: ->
    aboutBlock: this.aboutBlockInitial()
    aboutBlockImages: []

  aboutBlockInputs: ->
    if this.props.initialAboutBlock and this.state.aboutBlock
      `<input key={this.aboutBlockName('id')} type="hidden" name={this.aboutBlockName('id')} value={this.props.initialAboutBlock.id} />`
    else if this.props.initialAboutBlock
      `<div>
        <input key={this.aboutBlockName('id')} type="hidden" name={this.aboutBlockName('id')} value={this.props.initialAboutBlock.id} />
        <input key={this.aboutBlockName('_destroy')} type="hidden" name={this.aboutBlockName('_destroy')} value="1" />
      </div>`
    else
      `<div />`

  aboutBlockProps: ->
    if this.state.aboutBlock
      block: $.extend({}, this.state.aboutBlock, { editing: this.state.editing, dropZoneClassName: this.aboutBlockDropZoneClassName() })
      blockEditor: this.aboutBlockEditorProps()
      blockImageLibrary: this.aboutBlockImageLibraryProps()
      blockInputHeading: this.aboutBlockInputHeadingProps()
      blockInputSubheading: this.aboutBlockInputSubheadingProps()
      blockInputImage: this.aboutBlockInputImageProps()
      blockInputText: this.aboutBlockInputTextProps()
      blockOptions: this.aboutBlockOptionsProps()
      blockInputsClassName: if this.state.aboutBlock and this.state.aboutBlock.displayImageLibrary then 'hide' else ''
      editing: this.state.editing
      name: this.aboutBlockName
    else
      blockAdd: this.aboutBlockAddProps()
      editing: this.state.editing

  # PRIVATE LEVEL 1

  aboutBlockInitial: ->
    if this.props.initialAboutBlock
      $.extend {}, this.aboutBlockDefaultProps(), this.props.initialAboutBlock

  aboutBlockID: (name) ->
    "about-block-attributes-#{name}"

  aboutBlockName: (name) ->
    "about_block_attributes[#{name}]"

  aboutBlockDropZoneClassName: ->
    'about-block-drop-zone'

  aboutBlockAddProps: ->
    visible: !this.state.aboutBlock
    onClick: this.aboutBlockAdd
    content: 'Add an About Block'

  aboutBlockEditorProps: ->
    id: 'about-block-editor'
    title: 'Edit About Block Details'
    swapForm: this.aboutBlockSwapForm
    resetForm: this.aboutBlockResetForm

  aboutBlockImageLibraryProps: ->
    visible: this.state.aboutBlock and this.state.aboutBlock.displayImageLibrary
    loaded: this.state.aboutBlock and this.state.aboutBlock.imageLibraryLoaded
    more: this.state.aboutBlock and !this.state.aboutBlock.imageLibraryLoadedAll
    loadMore: this.aboutBlockImageLibraryMore
    hide: this.aboutBlockUpdate.bind(null, displayImageLibrary: false)
    add: this.aboutBlockImageLibraryAdd
    images: this.state.aboutBlockImages

  aboutBlockInputHeadingProps: ->
    id: this.aboutBlockID('heading')
    name: this.aboutBlockName('heading')
    value: this.state.aboutBlock.heading
    label: 'Heading'

  aboutBlockInputSubheadingProps: ->
    id: this.aboutBlockID('subheading')
    name: this.aboutBlockName('subheading')
    value: this.state.aboutBlock.subheading
    label: 'Subheading'

  aboutBlockInputImageProps: ->
    init: this.aboutBlockImageInit
    id: this.aboutBlockID
    name: this.aboutBlockName
    showImageLibrary: this.aboutBlockShowImageLibrary
    removeImage: this.aboutBlockRemoveImage
    alt: this.state.aboutBlock.image_alt
    image_id: this.state.aboutBlock.image_id
    image_placement_id: this.state.aboutBlock.image_placement_id
    image_placement_destroy: this.state.aboutBlock.image_placement_destroy
    image_temp_placement_destroy: this.state.aboutBlock.image_temp_placement_destroy
    attached_url: this.state.aboutBlock.image_url
    cache_url: this.state.aboutBlock.image_cache_url
    temp_cache_url: this.state.aboutBlock.image_temp_cache_url
    progress: this.state.aboutBlock.image_progress
    title: this.state.aboutBlock.image_title
    state: this.state.aboutBlock.image_state
    file_name: this.state.aboutBlock.image_file_name
    file_size: parseInt(this.state.aboutBlock.image_file_size)
    file_type: this.state.aboutBlock.image_file_type
    temp_file_name: this.state.aboutBlock.image_temp_file_name
    temp_file_size: parseInt(this.state.aboutBlock.image_temp_file_size)
    temp_file_type: this.state.aboutBlock.image_temp_file_type
    label: 'Background Image'
    dropZoneClassName: this.aboutBlockDropZoneClassName()

  aboutBlockInputTextProps: ->
    id: this.aboutBlockID('text')
    name: this.aboutBlockName('text')
    value: this.state.aboutBlock.text
    label: 'Text'
    rows: 4
    wysiwyg: true

  aboutBlockOptionsProps: ->
    visible: this.state.editing
    prev: this.aboutBlockPrevTheme
    next: this.aboutBlockNextTheme
    editorTarget: '#about-block-editor'
    editLabel: 'Edit Details'
    removeLabel: 'Remove About Block'
    onRemove: this.aboutBlockRemove
    onEdit: this.aboutBlockEdit

  # PRIVATE LEVEL 2

  aboutBlockDefaultProps: ->
    image_progress: 0
    image_state: 'empty'
    displayImageLibrary: false
    imageLibraryLoaded: false
    imageLibraryPage: 1
    heading: 'Heading'
    subheading: 'Subheading'
    text: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.
      Aenean ultricies ultrices mi eu maximus. Curabitur dignissim libero
      quis sem suscipit tristique. Nunc convallis lorem ut sagittis faucibus.'

  aboutBlockAdd: (event, callback) ->
    event.preventDefault() if event
    this.aboutBlockSave $set: $.extend({}, this.aboutBlockDefaultProps(), (this.props.defaultAboutBlockAttributes or {})), callback

  aboutBlockEdit: ->

  aboutBlockUpdate: (attributes, event, callback) ->
    event.preventDefault() if event
    this.aboutBlockSave $merge: attributes, callback

  aboutBlockRemove: (event, callback) ->
    event.preventDefault() if event
    if this.state.aboutBlock.upload_xhr
      $(this.state.aboutBlock.upload_xhr.getDOMNode()).fileupload('destroy')
    this.aboutBlockSave $set: null, callback

  aboutBlockShowImageLibrary: (event) ->
    event.preventDefault() if event
    this.aboutBlockUpdate displayImageLibrary: true, null, this.aboutBlockImageLibraryStart

  aboutBlockRemoveImage: (event) ->
    event.preventDefault() if event
    this.aboutBlockUpdate
      image_state: 'empty'
      image_temp_id: null
      image_temp_placement_destroy: '1'
      image_temp_cache_url: null
      image_temp_file_name: null
      image_temp_file_size: null
      image_temp_file_type: null
    this.aboutBlockInputSetVal 'image_alt', ''
    this.aboutBlockInputSetVal 'image_title', ''

  aboutBlockSwapForm: () ->
    if (this.state.aboutBlock.image_temp_placement_destroy and this.state.aboutBlock.image_temp_placement_destroy is '1') or (this.state.aboutBlock.image_temp_cache_url and this.state.aboutBlock.image_temp_cache_url.length > 0)
      this.aboutBlockUpdate
        image_id: this.state.aboutBlock.image_temp_id
        image_temp_id: null
        image_placement_destroy: this.state.aboutBlock.image_temp_placement_destroy
        image_temp_placement_destroy: null
        image_url: this.state.aboutBlock.image_temp_cache_url
        image_cache_url: this.state.aboutBlock.image_temp_cache_url
        image_temp_cache_url: null
        image_file_name: this.state.aboutBlock.image_temp_file_name
        image_temp_file_name: null
        image_file_size: this.state.aboutBlock.image_temp_file_size
        image_temp_file_size: null
        image_file_type: this.state.aboutBlock.image_temp_file_type
        image_temp_file_type: null
        image_alt: this.aboutBlockInputGetVal('image_alt')
        image_title: this.aboutBlockInputGetVal('image_title')
        heading: this.aboutBlockInputGetVal('heading')
        subheading: this.aboutBlockInputGetVal('subheading')
        text: this.aboutBlockInputGetVal('text')
    else
      this.aboutBlockUpdate
        image_alt: this.aboutBlockInputGetVal('image_alt')
        image_title: this.aboutBlockInputGetVal('image_title')
        heading: this.aboutBlockInputGetVal('heading')
        subheading: this.aboutBlockInputGetVal('subheading')
        text: this.aboutBlockInputGetVal('text')

  aboutBlockResetForm: () ->
    attributes =
      image_temp_id: null
      image_temp_placement_destroy: null
      image_temp_cache_url: null
      image_temp_file_name: null
      image_temp_file_size: null
      image_temp_file_type: null
    callback = null
    if this.state.aboutBlock.upload_xhr
      $(this.state.aboutBlock.upload_xhr.getDOMNode()).fileupload('destroy')
      attributes.upload_xhr = null
      callback = this.aboutBlockImageInit.bind(null, this.state.aboutBlock.upload_xhr)
    if (this.state.aboutBlock.image_url and this.state.aboutBlock.image_url.length > 0) or (this.state.aboutBlock.image_cache_url and this.state.aboutBlock.image_cache_url.length > 0)
      attributes.image_state = 'attached'
    else
      attributes.image_state = 'empty'
    this.aboutBlockUpdate attributes, null, callback
    this.aboutBlockInputSetVal 'image_alt', this.state.aboutBlock.image_alt
    this.aboutBlockInputSetVal 'image_title', this.state.aboutBlock.image_title
    this.aboutBlockInputSetVal 'heading', this.state.aboutBlock.heading
    this.aboutBlockInputSetVal 'subheading', this.state.aboutBlock.subheading
    if $('#' + this.aboutBlockID('text')).data('wysihtml5')
      $('#' + this.aboutBlockID('text')).data('wysihtml5').editor.setValue(this.state.aboutBlock.text)

  aboutBlockImageInit: (component) ->
    unless this.state.aboutBlock.upload_xhr
      $(component.getDOMNode()).fileupload
        dataType: 'XML'
        url: this.props.presignedPostURL
        formData: this.props.presignedPostFields
        paramName: 'file'
        dropZone: ".#{this.aboutBlockDropZoneClassName()}"
        add: this.aboutBlockImageAdd
        start: this.aboutBlockImageStart
        progress: this.aboutBlockImageProgress
        done: this.aboutBlockImageDone
        fail: this.aboutBlockImageFail
      this.aboutBlockUpdate upload_xhr: component

  aboutBlockPrevTheme: ->
    this.aboutBlockUpdate theme: this.prevItem(this.aboutBlockThemes, this.state.aboutBlock.theme)

  aboutBlockNextTheme: ->
    this.aboutBlockUpdate theme: this.nextItem(this.aboutBlockThemes, this.state.aboutBlock.theme)

  # PRIVATE LEVEL 3

  aboutBlockSave: (changes, callback) ->
    updated = React.addons.update(this.state, aboutBlock: changes)
    if typeof(callback) is 'function'
      this.setState updated, callback
    else
      this.setState updated

  aboutBlockImageLibraryStart: ->
    unless this.state.aboutBlock.imageLibraryLoaded
      $.get "#{this.props.imagesPath}?page=#{this.state.aboutBlock.imageLibraryPage}", this.aboutBlockImageLibraryLoad

  aboutBlockImageLibraryMore: ->
    unless this.state.aboutBlock.imageLibraryLoadedAll
      $.get "#{this.props.imagesPath}?page=#{this.state.aboutBlock.imageLibraryPage}", this.aboutBlockImageLibraryLoad

  aboutBlockImageLibraryLoad: (data) ->
    changes =
      aboutBlock:
        $merge:
          imageLibraryLoaded: true
          imageLibraryPage: this.state.aboutBlock.imageLibraryPage + 1
          imageLibraryLoadedAll: data.images.length < 48
      aboutBlockImages:
        $push: data.images
    this.setState React.addons.update(this.state, changes)

  aboutBlockImageLibraryAdd: (image) ->
    this.aboutBlockUpdate
      displayImageLibrary: false
      image_state: 'attached'
      image_temp_id: image.image_id
      image_temp_placement_destroy: ''
      image_temp_cache_url: image.image_url
      image_temp_file_name: image.image_file_name
      image_temp_file_size: image.image_file_size
      image_temp_file_type: image.image_file_type
    this.aboutBlockInputSetVal 'image_alt', image.image_alt
    this.aboutBlockInputSetVal 'image_title', image.image_title

  aboutBlockInputGetVal: (name) ->
    $('#' + this.aboutBlockID(name)).val()

  aboutBlockInputSetVal: (name, value) ->
    $('#' + this.aboutBlockID(name)).val(value)

  aboutBlockThemes: ['banner', 'left']

  aboutBlockImageAdd: (event, data) ->
    file = data.files[0]
    reader = new FileReader()
    reader.onload = this.aboutBlockImageRead.bind(null, file)
    reader.readAsDataURL file
    formData = this.props.presignedPostFields
    formData['Content-Type'] = file.type
    data.formData = formData
    data.submit()

  aboutBlockImageStart: (event) ->
    this.aboutBlockUpdate image_state: 'uploading'

  aboutBlockImageProgress: (event, data) ->
    if this.state.aboutBlock and this.state.aboutBlock.image_state is 'uploading'
      this.aboutBlockUpdate
        image_progress: parseInt(data.loaded / data.total * 100, 10)

  aboutBlockImageDone: (event, data) ->
    if this.state.aboutBlock and this.state.aboutBlock.image_state is 'uploading'
      key = $(data.jqXHR.responseXML).find('Key').text()
      url = "//#{this.props.presignedPostHost}/#{key}"
      this.aboutBlockUpdate
        image_temp_cache_url: url
        image_state: 'finishing'
      setTimeout this.aboutBlockImageFinish, 500

  aboutBlockImageFinish: ->
    if this.state.aboutBlock and this.state.aboutBlock.image_state is 'finishing'
      $(this.state.aboutBlock.upload_xhr.getDOMNode()).fileupload('destroy')
      this.aboutBlockUpdate image_state: 'attached', upload_xhr: null, null, this.aboutBlockImageInit.bind(null, this.state.aboutBlock.upload_xhr)

  aboutBlockImageFail: (event, data) ->
    if this.state.aboutBlock and this.state.aboutBlock.image_state is 'uploading'
      this.aboutBlockUpdate image_state: 'failed'

  # PRIVATE LEVEL 4

  aboutBlockImageRead: (file, event) ->
    this.aboutBlockUpdate
      image_temp_id: null
      image_temp_placement_destroy: null
      image_temp_cache_url: event.target.result
      image_temp_file_name: file.name
      image_temp_file_size: file.size
      image_temp_file_type: file.type
    this.aboutBlockInputSetVal 'image_alt', image.image_alt
    this.aboutBlockInputSetVal 'image_title', image.image_title

window.AboutBlockHandlers = AboutBlockHandlers
