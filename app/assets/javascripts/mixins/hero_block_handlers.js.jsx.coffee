HeroBlockHandlers =
  propTypes:
    initialHeroBlock: React.PropTypes.object
    defaultHeroBlockAttributes: React.PropTypes.object

  getInitialState: ->
    heroBlock: this.heroBlockInitial()
    heroBlockImages: []

  heroBlockInputs: ->
    if this.props.initialHeroBlock and this.state.heroBlock
      `<input key={this.heroBlockName('id')} type="hidden" name={this.heroBlockName('id')} value={this.props.initialHeroBlock.id} />`
    else if this.props.initialHeroBlock
      `<div>
        <input key={this.heroBlockName('id')} type="hidden" name={this.heroBlockName('id')} value={this.props.initialHeroBlock.id} />
        <input key={this.heroBlockName('_destroy')} type="hidden" name={this.heroBlockName('_destroy')} value="1" />
      </div>`
    else
      `<div />`

  heroBlockProps: ->
    if this.state.heroBlock
      block: $.extend({}, this.state.heroBlock, { editing: this.state.editing, dropZoneClassName: this.heroBlockDropZoneClassName() })
      blockEditor: this.heroBlockEditorProps()
      blockImageLibrary: this.heroBlockImageLibraryProps()
      blockInputHeading: this.heroBlockInputHeadingProps()
      blockInputBackgroundColor: this.heroBlockInputBackgroundColorProps()
      blockInputForegroundColor: this.heroBlockInputForegroundColorProps()
      blockInputStyle: this.heroBlockInputStyleProps()
      blockInputImage: this.heroBlockInputImageProps()
      blockInputLink: this.heroBlockInputLinkProps()
      blockInputText: this.heroBlockInputTextProps()
      blockOptions: this.heroBlockOptionsProps()
      blockInputsClassName: if this.state.heroBlock and this.state.heroBlock.displayImageLibrary then 'hide' else ''
      editing: this.state.editing
      name: this.heroBlockName
    else
      blockAdd: this.heroBlockAddProps()
      editing: this.state.editing

  # PRIVATE LEVEL 1

  heroBlockInitial: ->
    if this.props.initialHeroBlock
      $.extend {}, this.heroBlockDefaultProps(), this.props.initialHeroBlock

  heroBlockID: (name) ->
    "hero-block-attributes-#{name}"

  heroBlockPlacementID: (name) ->
    "hero-block-attributes-hero-block-image-placement-attributes-#{name}"

  heroBlockName: (name) ->
    "hero_block_attributes[#{name}]"

  heroBlockPlacementName: (name) ->
    "hero_block_attributes[hero_block_image_placement_attributes][#{name}]"

  heroBlockDropZoneClassName: ->
    'hero-block-drop-zone'

  heroBlockAddProps: ->
    visible: !this.state.heroBlock
    onClick: this.heroBlockAdd
    content: 'Add a Hero Block'

  heroBlockEditorProps: ->
    id: 'hero-block-editor'
    title: 'Edit Hero Block Details'
    swapForm: this.heroBlockSwapForm
    resetForm: this.heroBlockResetForm

  heroBlockImageLibraryProps: ->
    visible: this.state.heroBlock and this.state.heroBlock.displayImageLibrary
    loaded: this.state.heroBlock and this.state.heroBlock.imageLibraryLoaded
    more: this.state.heroBlock and !this.state.heroBlock.imageLibraryLoadedAll
    loadMore: this.heroBlockImageLibraryMore
    hide: this.heroBlockUpdate.bind(null, displayImageLibrary: false)
    add: this.heroBlockImageLibraryAdd
    images: this.state.heroBlockImages

  heroBlockInputHeadingProps: ->
    id: this.heroBlockID('heading')
    name: this.heroBlockName('heading')
    value: this.state.heroBlock.heading
    label: 'Heading'

  heroBlockInputForegroundColorProps: ->
    id: this.heroBlockID('foreground_color')
    name: this.heroBlockName('foreground_color')
    value: this.state.heroBlock.foreground_color
    label: 'Foreground Color'

  heroBlockInputBackgroundColorProps: ->
    id: this.heroBlockID('background_color')
    name: this.heroBlockName('background_color')
    value: this.state.heroBlock.background_color
    label: 'Background Color'

  heroBlockInputStyleProps: ->
    id: this.heroBlockID('style')
    name: this.heroBlockName('style')
    value: this.state.heroBlock.style
    label: 'Background Style'
    options: [
      { value: 'light', label: 'Light', },
      { value: 'dark', label: 'Dark', },
    ]

  heroBlockInputImageProps: ->
    init: this.heroBlockImageInit
    id: this.heroBlockID
    name: this.heroBlockPlacementName
    showImageLibrary: this.heroBlockShowImageLibrary
    removeImage: this.heroBlockRemoveImage
    alt: this.state.heroBlock.image_alt
    image_id: this.state.heroBlock.image_id
    image_placement_id: this.state.heroBlock.image_placement_id
    image_placement_destroy: this.state.heroBlock.image_placement_destroy
    image_temp_placement_destroy: this.state.heroBlock.image_temp_placement_destroy
    attached_url: this.state.heroBlock.image_url
    cache_url: this.state.heroBlock.image_cache_url
    temp_cache_url: this.state.heroBlock.image_temp_cache_url
    progress: this.state.heroBlock.image_progress
    title: this.state.heroBlock.image_title
    state: this.state.heroBlock.image_state
    file_name: this.state.heroBlock.image_file_name
    file_size: parseInt(this.state.heroBlock.image_file_size)
    content_type: this.state.heroBlock.image_content_type
    temp_file_name: this.state.heroBlock.image_temp_file_name
    temp_file_size: parseInt(this.state.heroBlock.image_temp_file_size)
    temp_content_type: this.state.heroBlock.image_temp_content_type
    dropZoneClassName: this.heroBlockDropZoneClassName()
    bulkUploadPath: this.props.bulkUploadPath

  heroBlockInputLinkProps: ->
    id: this.heroBlockID
    name: this.heroBlockName
    label: this.state.heroBlock.link_label
    version: this.state.heroBlock.link_version
    target_blank: this.state.heroBlock.link_target_blank
    no_follow: this.state.heroBlock.link_no_follow
    link_id: this.state.heroBlock.link_id
    link_type: this.state.heroBlock.link_type
    external_url: this.state.heroBlock.link_external_url
    checkedNone: this.state.heroBlock.link_version is 'link_none'
    checkedInternal: this.state.heroBlock.link_version is 'link_internal'
    checkedExternal: this.state.heroBlock.link_version is 'link_external'
    internalWebpages: this.props.internalWebpages

  heroBlockInputTextProps: ->
    id: this.heroBlockID('text')
    name: this.heroBlockName('text')
    value: this.state.heroBlock.text
    label: 'Text'
    rows: 4
    wysiwyg: true

  heroBlockOptionsProps: ->
    visible: this.state.editing
    prev: this.heroBlockPrevTheme
    next: this.heroBlockNextTheme
    editorTarget: '#hero-block-editor'
    editLabel: 'Edit Details'
    removeLabel: 'Remove Hero Block'
    onRemove: this.heroBlockRemove
    onEdit: this.heroBlockEdit

  # PRIVATE LEVEL 2

  heroBlockDefaultProps: ->
    image_progress: 0
    image_state: 'empty'
    style: 'light'
    link_target_blank: false
    link_no_follow: false
    displayImageLibrary: false
    imageLibraryLoaded: false
    imageLibraryPage: 1
    layout: 'default'
    heading: 'Heading'
    text: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.
      Aenean ultricies ultrices mi eu maximus. Curabitur dignissim libero
      quis sem suscipit tristique. Nunc convallis lorem ut sagittis faucibus.'

  heroBlockAdd: (event, callback) ->
    event.preventDefault() if event
    this.heroBlockSave $set: $.extend({}, this.heroBlockDefaultProps(), (this.props.defaultHeroBlockAttributes or {})), callback

  heroBlockEdit: ->

  heroBlockUpdate: (attributes, event, callback) ->
    event.preventDefault() if event
    this.heroBlockSave $merge: attributes, callback

  heroBlockShowImageLibrary: (event) ->
    event.preventDefault() if event
    this.heroBlockUpdate displayImageLibrary: true, null, this.heroBlockImageLibraryStart

  heroBlockRemove: (event, callback) ->
    event.preventDefault() if event
    if this.state.heroBlock.upload_xhr
      $(this.state.heroBlock.upload_xhr.getDOMNode()).fileupload('destroy')
    this.heroBlockSave $set: null, callback

  heroBlockRemoveImage: (event) ->
    event.preventDefault() if event
    this.heroBlockUpdate
      image_state: 'empty'
      image_temp_id: null
      image_temp_placement_destroy: '1'
      image_temp_cache_url: null
      image_temp_file_name: null
      image_temp_file_size: null
      image_temp_content_type: null
    this.heroBlockPlacementInputSetVal 'image_alt', ''
    this.heroBlockPlacementInputSetVal 'image_title', ''

  heroBlockSwapForm: () ->
    if (this.state.heroBlock.image_temp_placement_destroy and this.state.heroBlock.image_temp_placement_destroy is '1') or (this.state.heroBlock.image_temp_cache_url and this.state.heroBlock.image_temp_cache_url.length > 0)
      this.heroBlockUpdate
        image_id: this.state.heroBlock.image_temp_id
        image_temp_id: null
        image_placement_destroy: this.state.heroBlock.image_temp_placement_destroy
        image_temp_placement_destroy: null
        image_url: this.state.heroBlock.image_temp_cache_url
        image_cache_url: this.state.heroBlock.image_temp_cache_url
        image_temp_cache_url: null
        image_file_name: this.state.heroBlock.image_temp_file_name
        image_temp_file_name: null
        image_file_size: this.state.heroBlock.image_temp_file_size
        image_temp_file_size: null
        image_content_type: this.state.heroBlock.image_temp_content_type
        image_temp_content_type: null
        image_alt: this.heroBlockPlacementInputGetVal('image_alt')
        image_title: this.heroBlockPlacementInputGetVal('image_title')
        link_version: $("input[name=\"#{this.heroBlockName('link_version')}\"]:checked").val()
        link_label: this.heroBlockInputGetVal('link_label')
        link_id: this.heroBlockInputGetVal('link_id')
        link_type: this.heroBlockInputGetVal('link_type')
        link_external_url: this.heroBlockInputGetVal('link_external_url')
        link_target_blank: this.heroBlockInputGetVal('link_target_blank')
        link_no_follow: this.heroBlockInputGetVal('link_no_follow')
        heading: this.heroBlockInputGetVal('heading')
        background_color: this.heroBlockInputGetVal('background_color')
        foreground_color: this.heroBlockInputGetVal('foreground_color')
        style: this.heroBlockInputGetVal('style')
        text: this.heroBlockInputGetVal('text')
        layout: this.heroBlockInputGetVal('layout')
    else
      this.heroBlockUpdate
        image_alt: this.heroBlockPlacementInputGetVal('image_alt')
        image_title: this.heroBlockPlacementInputGetVal('image_title')
        link_version: $("input[name=\"#{this.heroBlockName('link_version')}\"]:checked").val()
        link_label: this.heroBlockInputGetVal('link_label')
        link_id: parseInt(this.heroBlockInputGetVal('link_id'))
        link_type: this.heroBlockInputGetVal('link_type')
        link_external_url: this.heroBlockInputGetVal('link_external_url')
        link_target_blank: this.heroBlockInputGetVal('link_target_blank')
        link_no_follow: this.heroBlockInputGetVal('link_no_follow')
        heading: this.heroBlockInputGetVal('heading')
        background_color: this.heroBlockInputGetVal('background_color')
        foreground_color: this.heroBlockInputGetVal('foreground_color')
        style: this.heroBlockInputGetVal('style')
        text: this.heroBlockInputGetVal('text')
        layout: this.heroBlockInputGetVal('layout')

  heroBlockResetForm: () ->
    attributes =
      image_temp_id: null
      image_temp_placement_destroy: null
      image_temp_cache_url: null
      image_temp_file_name: null
      image_temp_file_size: null
      image_temp_content_type: null
    callback = null
    if this.state.heroBlock.upload_xhr
      $(this.state.heroBlock.upload_xhr.getDOMNode()).fileupload('destroy')
      attributes.upload_xhr = null
      callback = this.heroBlockImageInit.bind(null, this.state.heroBlock.upload_xhr)
    if (this.state.heroBlock.image_url and this.state.heroBlock.image_url.length > 0) or (this.state.heroBlock.image_cache_url and this.state.heroBlock.image_cache_url.length > 0)
      attributes.image_state = 'attached'
    else
      attributes.image_state = 'empty'
    this.heroBlockUpdate attributes, null, callback
    this.heroBlockPlacementInputSetVal 'image_alt', this.state.heroBlock.image_alt
    this.heroBlockPlacementInputSetVal 'image_title', this.state.heroBlock.image_title
    this.heroBlockInputSetVal 'link_version', this.state.heroBlock.link_version
    this.heroBlockInputSetVal 'link_label', this.state.heroBlock.link_label
    this.heroBlockInputSetVal 'link_id', this.state.heroBlock.link_id
    this.heroBlockInputSetVal 'link_type', this.state.heroBlock.link_type
    this.heroBlockInputSetVal 'link_external_url', this.state.heroBlock.link_external_url
    this.heroBlockInputSetVal 'link_target_blank', this.state.heroBlock.link_target_blank
    this.heroBlockInputSetVal 'link_no_follow', this.state.heroBlock.link_no_follow
    this.heroBlockInputSetVal 'heading', this.state.heroBlock.heading
    this.heroBlockInputSetVal 'background_color', this.state.heroBlock.background_color
    this.heroBlockInputSetVal 'foreground_color', this.state.heroBlock.foreground_color
    this.heroBlockInputSetVal 'style', this.state.heroBlock.style
    this.heroBlockInputSetVal 'layout', this.state.heroBlock.layout
    if $('#' + this.heroBlockID('text')).data('wysihtml5')
      $('#' + this.heroBlockID('text')).data('wysihtml5').editor.setValue(this.state.heroBlock.text)

  heroBlockImageInit: (component) ->
    unless this.state.heroBlock.upload_xhr
      $(component.getDOMNode()).fileupload
        dataType: 'XML'
        url: this.props.presignedPost.url
        formData: this.props.presignedPost.fields
        paramName: 'file'
        dropZone: ".#{this.heroBlockDropZoneClassName()}"
        add: this.heroBlockImageAdd
        start: this.heroBlockImageStart
        progress: this.heroBlockImageProgress
        done: this.heroBlockImageDone
        fail: this.heroBlockImageFail
      this.heroBlockUpdate upload_xhr: component

  heroBlockPrevTheme: ->
    this.heroBlockUpdate theme: this.prevItem(this.heroBlockThemes, this.state.heroBlock.theme)

  heroBlockNextTheme: ->
    this.heroBlockUpdate theme: this.nextItem(this.heroBlockThemes, this.state.heroBlock.theme)

  # PRIVATE LEVEL 3

  heroBlockSave: (changes, callback) ->
    updated = React.addons.update(this.state, heroBlock: changes)
    if typeof(callback) is 'function'
      this.setState updated, callback
    else
      this.setState updated

  heroBlockImageLibraryStart: ->
    unless this.state.heroBlock.imageLibraryLoaded
      $.get "#{this.props.imagesPath}?page=#{this.state.heroBlock.imageLibraryPage}", this.heroBlockImageLibraryLoad

  heroBlockImageLibraryMore: ->
    unless this.state.heroBlock.imageLibraryLoadedAll
      $.get "#{this.props.imagesPath}?page=#{this.state.heroBlock.imageLibraryPage}", this.heroBlockImageLibraryLoad

  heroBlockImageLibraryLoad: (data) ->
    changes =
      heroBlock:
        $merge:
          imageLibraryLoaded: true
          imageLibraryPage: this.state.heroBlock.imageLibraryPage + 1
          imageLibraryLoadedAll: data.images.length < 48
      heroBlockImages:
        $push: data.images
    this.setState React.addons.update(this.state, changes)

  heroBlockImageLibraryAdd: (image) ->
    this.heroBlockUpdate
      displayImageLibrary: false
      image_state: 'attached'
      image_temp_id: image.id
      image_temp_placement_destroy: ''
      image_temp_cache_url: image.attachment_url
      image_temp_file_name: image.attachment_file_name
      image_temp_file_size: image.attachment_file_size
      image_temp_content_type: image.attachment_content_type
    this.heroBlockPlacementInputSetVal 'image_alt', image.alt
    this.heroBlockPlacementInputSetVal 'image_title', image.title

  heroBlockInputGetVal: (name) ->
    $('#' + this.heroBlockID(name)).val()

  heroBlockInputSetVal: (name, value) ->
    $('#' + this.heroBlockID(name)).val(value)

  heroBlockPlacementInputGetVal: (name) ->
    $('#' + this.heroBlockPlacementID(name)).val()

  heroBlockPlacementInputSetVal: (name, value) ->
    $('#' + this.heroBlockPlacementID(name)).val(value)

  heroBlockThemes: ['left', 'right', 'well', 'well_dark', 'form', 'split_image', 'split_video']

  heroBlockImageAdd: (event, data) ->
    file = data.files[0]
    reader = new FileReader()
    reader.onload = this.heroBlockImageRead.bind(null, file)
    reader.readAsDataURL file
    formData = this.props.presignedPost.fields
    formData['Content-Type'] = file.type
    data.formData = formData
    data.submit()

  heroBlockImageStart: (event) ->
    this.heroBlockUpdate image_state: 'uploading'

  heroBlockImageProgress: (event, data) ->
    if this.state.heroBlock and this.state.heroBlock.image_state is 'uploading'
      this.heroBlockUpdate
        image_progress: parseInt(data.loaded / data.total * 100, 10)

  heroBlockImageDone: (event, data) ->
    if this.state.heroBlock and this.state.heroBlock.image_state is 'uploading'
      key = $(data.jqXHR.responseXML).find('Key').text()
      url = "//#{this.props.presignedPost.host}/#{key}"
      this.heroBlockUpdate
        image_temp_cache_url: url
        image_state: 'finishing'
      setTimeout this.heroBlockImageFinish, 500

  heroBlockImageFinish: ->
    if this.state.heroBlock and this.state.heroBlock.image_state is 'finishing'
      $(this.state.heroBlock.upload_xhr.getDOMNode()).fileupload('destroy')
      this.heroBlockUpdate image_state: 'attached', upload_xhr: null, null, this.heroBlockImageInit.bind(null, this.state.heroBlock.upload_xhr)

  heroBlockImageFail: (event, data) ->
    if this.state.heroBlock and this.state.heroBlock.image_state is 'uploading'
      this.heroBlockUpdate image_state: 'failed'

  # PRIVATE LEVEL 4

  heroBlockImageRead: (file, event) ->
    this.heroBlockUpdate
      image_temp_id: null
      image_temp_placement_destroy: null
      image_temp_cache_url: event.target.result
      image_temp_file_name: file.name
      image_temp_file_size: file.size
      image_temp_content_type: file.type
    this.heroBlockPlacementInputSetVal 'image_alt', ''
    this.heroBlockPlacementInputSetVal 'image_title', ''

window.HeroBlockHandlers = HeroBlockHandlers
