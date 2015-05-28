SpecialtyBlocksHandlers =
  propTypes:
    initialSpecialtyBlocks: React.PropTypes.array
    defaultSpecialtyBlockAttributes: React.PropTypes.object

  getInitialState: ->
    specialtyBlocks: this.props.initialSpecialtyBlocks.map(this.specialtyBlockInitial)

  specialtyBlocksInputs: ->
    this.props.initialSpecialtyBlocks.map this.specialtyBlockInputs

  specialtyBlockInputs: (block) ->
    if block.id
      blockFilter = (b) -> b.key == block.key
      foundBlock = this.state.specialtyBlocks.filter(blockFilter)[0]
      if foundBlock
        `<input key={this.specialtyBlockName(block, 'id')} type="hidden" name={this.specialtyBlockName(block, 'id')} value={block.id} />`
      else
        `<div>
          <input key={this.specialtyBlockName(block, 'id')} type="hidden" name={this.specialtyBlockName(block, 'id')} value={block.id} />
          <input key={this.specialtyBlockName(block, '_destroy')} type="hidden" name={this.specialtyBlockName(block, '_destroy')} value="1" />
        </div>`
    else
      `<div />`

  specialtyBlocksProps: ->
    blockProps: this.state.specialtyBlocks.map(this.specialtyBlockProps)
    blockAdd: this.specialtyBlockAddProps()

  specialtyBlockProps: (block) ->
    block: $.extend({}, block, { editing: this.state.editing, dropZoneClassName: this.specialtyBlockDropZoneClassName(block) })
    blockEditor: this.specialtyBlockEditorProps(block)
    blockImageLibrary: this.specialtyBlockImageLibraryProps(block)
    blockInputHeading: this.specialtyBlockInputHeadingProps(block)
    blockInputImage: this.specialtyBlockInputImageProps(block)
    blockInputText: this.specialtyBlockInputTextProps(block)
    blockOptions: this.specialtyBlockOptionsProps(block)
    blockInputsClassName: if block and block.displayImageLibrary then 'hide' else ''
    editing: this.state.editing
    name: this.specialtyBlockName.bind(null, block)

  # PRIVATE LEVEL 1

  specialtyBlockInitial: (block) ->
    $.extend {}, this.specialtyBlockDefaultProps(), block

  specialtyBlockID: (block, name) ->
    "specialty-blocks-#{block.key}-attributes-#{name}"

  specialtyBlockPlacementID: (block, name) ->
    "specialty-blocks-#{block.key}-specialty-block-image-placement-attributes-#{name}"

  specialtyBlockName: (block, name) ->
    "specialty_blocks_attributes[#{block.key}][#{name}]"

  specialtyBlockPlacementName: (block, name) ->
    "specialty_blocks_attributes[#{block.key}][specialty_block_image_placement_attributes][#{name}]"

  specialtyBlockDropZoneClassName: (block) ->
    "specialty-block-#{block.key}-drop-zone"

  specialtyBlockAddProps: ->
    visible: this.state.editing and this.state.specialtyBlocks.length < 100
    onClick: this.specialtyBlockAdd
    content: 'Add a Specialty Block'

  specialtyBlockEditorProps: (block) ->
    id: "specialty-block-#{block.key}-editor"
    title: 'Edit Specialty Block Details'
    swapForm: this.specialtyBlockSwapForm.bind(null, block)
    resetForm: this.specialtyBlockResetForm.bind(null, block)

  specialtyBlockImageLibraryProps: (block) ->
    visible: block and block.displayImageLibrary
    loaded: block and block.imageLibraryLoaded
    more: block and !block.imageLibraryLoadedAll
    loadMore: this.specialtyBlockImageLibraryMore.bind(null, block)
    hide: this.specialtyBlockUpdate.bind(null, block, displayImageLibrary: false)
    add: this.specialtyBlockImageLibraryAdd.bind(null, block)
    images: block.images

  specialtyBlockInputImageProps: (block) ->
    init: this.specialtyBlockImageInit.bind(null, block)
    id: this.specialtyBlockPlacementID.bind(null, block)
    name: this.specialtyBlockPlacementName.bind(null, block)
    showImageLibrary: this.specialtyBlockShowImageLibrary.bind(null, block)
    removeImage: this.specialtyBlockRemoveImage.bind(null, block)
    alt: block.image_alt
    image_id: block.image_id
    image_placement_id: block.image_placement_id
    image_placement_kind: block.image_placement_kind
    image_placement_embed: block.image_placement_embed
    image_placement_destroy: block.image_placement_destroy
    image_temp_placement_destroy: block.image_temp_placement_destroy
    attached_url: block.image_url
    cache_url: block.image_cache_url
    temp_cache_url: block.image_temp_cache_url
    progress: block.image_progress
    title: block.image_title
    state: block.image_state
    file_name: block.image_file_name
    file_size: block.image_file_size
    content_type: block.image_content_type
    temp_file_name: block.image_temp_file_name
    temp_file_size: block.image_temp_file_size
    temp_content_type: block.image_temp_content_type
    dropZoneClassName: this.specialtyBlockDropZoneClassName(block)
    bulkUploadPath: this.props.bulkUploadPath
    allowEmbed: true

  specialtyBlockInputHeadingProps: (block) ->
    id: this.specialtyBlockID(block, 'heading')
    name: this.specialtyBlockName(block, 'heading')
    value: block.heading
    label: 'Heading'

  specialtyBlockInputTextProps: (block) ->
    id: this.specialtyBlockID(block, 'text')
    name: this.specialtyBlockName(block, 'text')
    value: block.text
    label: 'Text'
    rows: 4
    wysiwyg: true

  specialtyBlockOptionsProps: (block) ->
    visible: this.state.editing
    prev: this.specialtyBlockPrevTheme.bind(null, block)
    next: this.specialtyBlockNextTheme.bind(null, block)
    editorTarget: "#specialty-block-#{block.key}-editor"
    editLabel: 'Edit Details'
    removeLabel: 'Remove Specialty Block'
    onRemove: this.specialtyBlockRemove.bind(null, block)
    onEdit: this.specialtyBlockEdit.bind(null, block)
    sortable: true

  # PRIVATE LEVEL 2

  specialtyBlockDefaultProps: ->
    key: Math.floor(Math.random() * Math.pow(10, 10))
    image_placement_kind: 'images'
    image_progress: 0
    image_state: 'empty'
    displayImageLibrary: false
    imageLibraryLoaded: false
    imageLibraryPage: 1
    images: []
    heading: 'Heading'
    text: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.
      Aenean ultricies ultrices mi eu maximus. Curabitur dignissim libero
      quis sem suscipit tristique. Nunc convallis lorem ut sagittis faucibus.'

  specialtyBlockAdd: (event, callback) ->
    event.preventDefault() if event
    this.specialtyBlockSave $push: [$.extend({}, this.specialtyBlockDefaultProps(), (this.props.defaultSpecialtyBlockAttributes or {}))], callback

  specialtyBlockEdit: ->

  specialtyBlockUpdate: (block, attributes, event, callback) ->
    event.preventDefault() if event
    blockFilter = (b) -> b.key == block.key
    foundBlock = this.state.specialtyBlocks.filter(blockFilter)[0]
    this.specialtyBlockSave $splice: [[this.state.specialtyBlocks.indexOf(foundBlock), 1, $.extend({}, foundBlock, attributes)]], callback

  specialtyBlockRemove: (block, event, callback) ->
    event.preventDefault() if event
    blockFilter = (b) -> b.key == block.key
    foundBlock = this.state.specialtyBlocks.filter(blockFilter)[0]
    if foundBlock.upload_xhr
      $(foundBlock.upload_xhr.getDOMNode()).fileupload('destroy')
    this.specialtyBlockSave $splice: [[this.state.specialtyBlocks.indexOf(foundBlock), 1]], callback

  specialtyBlockRemoveImage: (block, event) ->
    event.preventDefault() if event
    this.specialtyBlockUpdate block,
      image_state: 'empty'
      image_temp_id: null
      image_temp_placement_destroy: '1'
      image_temp_cache_url: null
      image_temp_file_name: null
      image_temp_file_size: null
      image_temp_content_type: null
    this.specialtyBlockPlacementInputSetVal block, 'image_alt', ''
    this.specialtyBlockPlacementInputSetVal block, 'image_title', ''

  specialtyBlockShowImageLibrary: (block, event) ->
    event.preventDefault() if event
    blockFilter = (b) -> b.key == block.key
    foundBlock = this.state.specialtyBlocks.filter(blockFilter)[0]
    this.specialtyBlockUpdate block, displayImageLibrary: true, null, this.specialtyBlockImageLibraryStart.bind(null, block)

  specialtyBlockSwapForm: (block) ->
    attributes =
      image_placement_kind: if $('#' + this.specialtyBlockPlacementID(block, 'tab_embed')).is(':visible') then 'embeds' else 'images'
      image_placement_embed: this.specialtyBlockPlacementInputGetVal(block, 'image_placement_embed')
      image_alt: this.specialtyBlockPlacementInputGetVal(block, 'image_alt')
      image_title: this.specialtyBlockPlacementInputGetVal(block, 'image_title')
      heading: this.specialtyBlockInputGetVal(block, 'heading')
      text: $('#' + this.specialtyBlockID(block, 'text')).code()
    if (block.image_temp_placement_destroy and block.image_temp_placement_destroy is '1') or (block.image_temp_cache_url and block.image_temp_cache_url.length > 0)
      attributes = $.extend {}, attributes,
        image_id: block.image_temp_id
        image_temp_id: null
        image_placement_destroy: block.image_temp_placement_destroy
        image_temp_placement_destroy: null
        image_url: block.image_temp_cache_url
        image_cache_url: block.image_temp_cache_url
        image_temp_cache_url: null
        image_file_name: block.image_temp_file_name
        image_temp_file_name: null
        image_file_size: block.image_temp_file_size
        image_temp_file_size: null
        image_content_type: block.image_temp_content_type
        image_temp_content_type: null
    this.specialtyBlockUpdate block, attributes

  specialtyBlockResetForm: (block) ->
    attributes =
      image_temp_id: null
      image_temp_placement_destroy: null
      image_temp_cache_url: null
      image_temp_file_name: null
      image_temp_file_size: null
      image_temp_content_type: null
    callback = null
    if block.upload_xhr
      $(block.upload_xhr.getDOMNode()).fileupload('destroy')
      attributes.upload_xhr = null
      callback = this.specialtyBlockImageInit.bind(null, block, block.upload_xhr)
    if (block.image_url and block.image_url.length > 0) or (block.image_cache_url and block.image_cache_url.length > 0)
      attributes.image_state = 'attached'
    else
      attributes.image_state = 'empty'
    this.specialtyBlockUpdate block, attributes, null, callback
    this.specialtyBlockPlacementInputSetVal block, 'image_alt', block.image_alt
    this.specialtyBlockPlacementInputSetVal block, 'image_title', block.image_title
    this.specialtyBlockPlacementInputSetVal block, 'image_placement_embed', block.image_placement_embed
    this.specialtyBlockInputSetVal block, 'heading', block.heading
    $('#' + this.specialtyBlockID(block, 'text')).code(block.text)

  specialtyBlockImageInit: (block, component) ->
    unless block.upload_xhr
      $(component.getDOMNode()).fileupload
        dataType: 'XML'
        url: this.props.presignedPost.url
        formData: this.props.presignedPost.fields
        paramName: 'file'
        dropZone: ".#{this.specialtyBlockDropZoneClassName(block)}"
        add: this.specialtyBlockImageAdd.bind(null, block)
        start: this.specialtyBlockImageStart.bind(null, block)
        progress: this.specialtyBlockImageProgress.bind(null, block)
        done: this.specialtyBlockImageDone.bind(null, block)
        fail: this.specialtyBlockImageFail.bind(null, block)
      this.specialtyBlockUpdate block, upload_xhr: component

  specialtyBlockPrevTheme: (block) ->
    this.specialtyBlockUpdate block, theme: this.prevItem(this.specialtyBlockThemes, block.theme)

  specialtyBlockNextTheme: (block) ->
    this.specialtyBlockUpdate block, theme: this.nextItem(this.specialtyBlockThemes, block.theme)

  # PRIVATE LEVEL 3

  specialtyBlockSave: (changes, callback) ->
    updated = React.addons.update(this.state, specialtyBlocks: changes)
    if typeof(callback) is 'function'
      this.setState updated, callback
    else
      this.setState updated

  specialtyBlockImageLibraryStart: (block) ->
    unless block.imageLibraryLoaded
      $.get "#{this.props.imagesPath}?page=#{block.imageLibraryPage}", this.specialtyBlockImageLibraryLoad.bind(null, block)

  specialtyBlockImageLibraryMore: (block) ->
    unless block.imageLibraryLoadedAll
      $.get "#{this.props.imagesPath}?page=#{block.imageLibraryPage}", this.specialtyBlockImageLibraryLoad.bind(null, block)

  specialtyBlockImageLibraryLoad: (block, data) ->
    this.specialtyBlockUpdate block,
      imageLibraryLoaded: true
      imageLibraryLoadedAll: data.images.length < 48
      imageLibraryPage: block.imageLibraryPage + 1
      images: block.images.concat data.images

  specialtyBlockImageLibraryAdd: (block, image) ->
    this.specialtyBlockUpdate block,
      displayImageLibrary: false
      image_state: 'attached'
      image_temp_id: image.id
      image_temp_placement_destroy: null
      image_temp_cache_url: image.attachment_url
      image_temp_file_name: image.attachment_file_name
      image_temp_file_size: image.attachment_file_size
      image_temp_content_type: image.attachment_content_type
    this.specialtyBlockPlacementInputSetVal block, 'image_alt', image.alt
    this.specialtyBlockPlacementInputSetVal block, 'image_title', image.title

  specialtyBlockInputGetVal: (block, name) ->
    $('#' + this.specialtyBlockID(block, name)).val()

  specialtyBlockInputSetVal: (block, name, value) ->
    $('#' + this.specialtyBlockID(block, name)).val(value)

  specialtyBlockPlacementInputGetVal: (block, name) ->
    $('#' + this.specialtyBlockPlacementID(block, name)).val()

  specialtyBlockPlacementInputSetVal: (block, name, value) ->
    $('#' + this.specialtyBlockPlacementID(block, name)).val(value)

  specialtyBlockThemes: ['left', 'right']

  specialtyBlockImageAdd: (block, event, data) ->
    blockFilter = (b) -> b.key == block.key
    foundBlock = this.state.specialtyBlocks.filter(blockFilter)[0]
    file = data.files[0]
    reader = new FileReader()
    reader.onload = this.specialtyBlockImageRead.bind(null, foundBlock, file)
    reader.readAsDataURL file
    formData = this.props.presignedPost.fields
    formData['Content-Type'] = file.type
    data.formData = formData
    data.submit()

  specialtyBlockImageStart: (block, event) ->
    blockFilter = (b) -> b.key == block.key
    foundBlock = this.state.specialtyBlocks.filter(blockFilter)[0]
    this.specialtyBlockUpdate foundBlock, image_state: 'uploading'

  specialtyBlockImageProgress: (block, event, data) ->
    blockFilter = (b) -> b.key == block.key
    foundBlock = this.state.specialtyBlocks.filter(blockFilter)[0]
    if foundBlock and foundBlock.image_state is 'uploading'
      this.specialtyBlockUpdate foundBlock,
        image_progress: parseInt(data.loaded / data.total * 100, 10)

  specialtyBlockImageDone: (block, event, data) ->
    blockFilter = (b) -> b.key == block.key
    foundBlock = this.state.specialtyBlocks.filter(blockFilter)[0]
    if foundBlock and foundBlock.image_state is 'uploading'
      key = $(data.jqXHR.responseXML).find('Key').text()
      url = "//#{this.props.presignedPost.host}/#{key}"
      this.specialtyBlockUpdate foundBlock,
        image_temp_cache_url: url
        image_state: 'finishing'
      setTimeout this.specialtyBlockImageFinish.bind(null, foundBlock), 500

  specialtyBlockImageFinish: (block) ->
    blockFilter = (b) -> b.key == block.key
    foundBlock = this.state.specialtyBlocks.filter(blockFilter)[0]
    if foundBlock and foundBlock.image_state is 'finishing'
      $(foundBlock.upload_xhr.getDOMNode()).fileupload('destroy')
      this.specialtyBlockUpdate foundBlock, image_state: 'attached', upload_xhr: null, null, this.specialtyBlockImageInit.bind(null, foundBlock, foundBlock.upload_xhr)

  specialtyBlockImageFail: (block, event, data) ->
    blockFilter = (b) -> b.key == block.key
    foundBlock = foundBlocks.filter(blockFilter)[0]
    if foundBlock and foundBlock.image_state is 'uploading'
      this.specialtyBlockUpdate foundBlock, image_state: 'failed'

  # PRIVATE LEVEL 4

  specialtyBlockImageRead: (block, file, event) ->
    blockFilter = (b) -> b.key == block.key
    foundBlock = this.state.specialtyBlocks.filter(blockFilter)[0]
    this.specialtyBlockUpdate foundBlock,
      image_temp_id: null
      image_temp_placement_destroy: null
      image_temp_cache_url: event.target.result
      image_temp_file_name: file.name
      image_temp_file_size: file.size
      image_temp_content_type: file.type
    this.specialtyBlockPlacementInputSetVal foundBlock, 'image_alt', ''
    this.specialtyBlockPlacementInputSetVal foundBlock, 'image_title', ''

window.SpecialtyBlocksHandlers = SpecialtyBlocksHandlers
