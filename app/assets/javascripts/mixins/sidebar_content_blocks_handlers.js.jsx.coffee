SidebarContentBlocksHandlers =
  propTypes:
    initialSidebarContentBlocks: React.PropTypes.array
    defaultSidebarContentBlockAttributes: React.PropTypes.object

  getInitialState: ->
    sidebarContentBlocks: this.props.initialSidebarContentBlocks.map(this.sidebarContentBlockInitial)

  sidebarContentBlocksInputs: ->
    this.props.initialSidebarContentBlocks.map this.sidebarContentBlockInputs

  sidebarContentBlockInputs: (block) ->
    if block.id
      blockFilter = (b) -> b.key == block.key
      foundBlock = this.state.sidebarContentBlocks.filter(blockFilter)[0]
      if foundBlock
        `<input key={this.sidebarContentBlockName(block, 'id')} type="hidden" name={this.sidebarContentBlockName(block, 'id')} value={block.id} />`
      else
        `<div>
          <input key={this.sidebarContentBlockName(block, 'id')} type="hidden" name={this.sidebarContentBlockName(block, 'id')} value={block.id} />
          <input key={this.sidebarContentBlockName(block, '_destroy')} type="hidden" name={this.sidebarContentBlockName(block, '_destroy')} value="1" />
        </div>`
    else
      `<div />`

  sidebarContentBlocksProps: ->
    blockProps: this.state.sidebarContentBlocks.map(this.sidebarContentBlockProps)
    blockAdd: this.sidebarContentBlockAddProps()

  sidebarContentBlockProps: (block) ->
    block: $.extend({}, block, { editing: this.state.editing, dropZoneClassName: this.sidebarContentBlockDropZoneClassName(block) })
    blockEditor: this.sidebarContentBlockEditorProps(block)
    blockImageLibrary: this.sidebarContentBlockImageLibraryProps(block)
    blockInputImage: this.sidebarContentBlockInputImageProps(block)
    blockInputHeading: this.sidebarContentBlockInputHeadingProps(block)
    blockInputText: this.sidebarContentBlockInputTextProps(block)
    blockOptions: this.sidebarContentBlockOptionsProps(block)
    blockInputsClassName: if block and block.displayImageLibrary then 'hide' else ''
    editing: this.state.editing
    name: this.sidebarContentBlockName.bind(null, block)

  # PRIVATE LEVEL 1

  sidebarContentBlockInitial: (block) ->
    $.extend {}, this.sidebarContentBlockDefaultProps(), block

  sidebarContentBlockID: (block, name) ->
    "sidebar-content-blocks-#{block.key}-attributes-#{name}"

  sidebarContentBlockPlacementID: (block, name) ->
    "sidebar-content-blocks-#{block.key}-sidebar-content-block-image-placement-attributes-#{name}"

  sidebarContentBlockName: (block, name) ->
    "sidebar_content_blocks_attributes[#{block.key}][#{name}]"

  sidebarContentBlockPlacementName: (block, name) ->
    "sidebar_content_blocks_attributes[#{block.key}][sidebar_content_block_image_placement_attributes][#{name}]"

  sidebarContentBlockDropZoneClassName: (block) ->
    "sidebar-content-blocks-#{block.key}-drop-zone"

  sidebarContentBlockAddProps: ->
    visible: this.state.editing and this.state.sidebarContentBlocks.length < 100
    onClick: this.sidebarContentBlockAdd
    content: 'Add a Sidebar Block'

  sidebarContentBlockEditorProps: (block) ->
    id: "sidebar-content-block-#{block.key}-editor"
    title: 'Edit Sidebar Block Details'
    swapForm: this.sidebarContentBlockSwapForm.bind(null, block)
    resetForm: this.sidebarContentBlockResetForm.bind(null, block)

  sidebarContentBlockImageLibraryProps: (block) ->
    visible: block and block.displayImageLibrary
    loaded: block and block.imageLibraryLoaded
    more: block and !block.imageLibraryLoadedAll
    loadMore: this.sidebarContentBlockImageLibraryMore.bind(null, block)
    hide: this.sidebarContentBlockUpdate.bind(null, block, displayImageLibrary: false)
    add: this.sidebarContentBlockImageLibraryAdd.bind(null, block)
    images: block.images

  sidebarContentBlockInputImageProps: (block) ->
    init: this.sidebarContentBlockImageInit.bind(null, block)
    id: this.sidebarContentBlockPlacementID.bind(null, block)
    name: this.sidebarContentBlockPlacementName.bind(null, block)
    showImageLibrary: this.sidebarContentBlockShowImageLibrary.bind(null, block)
    removeImage: this.sidebarContentBlockRemoveImage.bind(null, block)
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
    dropZoneClassName: this.sidebarContentBlockDropZoneClassName(block)
    bulkUploadPath: this.props.bulkUploadPath
    allowEmbed: true

  sidebarContentBlockInputHeadingProps: (block) ->
    id: this.sidebarContentBlockID(block, 'heading')
    name: this.sidebarContentBlockName(block, 'heading')
    value: block.heading
    label: 'Heading'

  sidebarContentBlockInputTextProps: (block) ->
    id: this.sidebarContentBlockID(block, 'text')
    name: this.sidebarContentBlockName(block, 'text')
    value: block.text
    label: 'Text'
    rows: 4
    wysiwyg: true

  sidebarContentBlockOptionsProps: (block) ->
    visible: this.state.editing
    editorTarget: "#sidebar-content-block-#{block.key}-editor"
    editLabel: 'Edit Details'
    removeLabel: 'Remove Sidebar Block'
    onRemove: this.sidebarContentBlockRemove.bind(null, block)
    onEdit: this.sidebarContentBlockEdit.bind(null, block)
    sortable: true

  # PRIVATE LEVEL 2

  sidebarContentBlockDefaultProps: ->
    key: Math.floor(Math.random() * Math.pow(10, 10))
    image_placement_kind: 'images'
    image_progress: 0
    image_state: 'empty'
    displayImageLibrary: false
    imageLibraryLoaded: false
    imageLibraryPage: 1
    images: []
    heading: 'Lorem Ipsum'
    text: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.
      Aenean ultricies ultrices mi eu maximus. Curabitur dignissim libero
      quis sem suscipit tristique. Nunc convallis lorem ut sagittis faucibus.'

  sidebarContentBlockAdd: (event, callback) ->
    event.preventDefault() if event
    this.sidebarContentBlocksSave $push: [$.extend({}, this.sidebarContentBlockDefaultProps(), (this.props.defaultSidebarContentBlockAttributes or {}))], callback

  sidebarContentBlockEdit: (block) ->

  sidebarContentBlockUpdate: (block, attributes, event, callback) ->
    event.preventDefault() if event
    blockFilter = (b) -> b.key == block.key
    foundBlock = this.state.sidebarContentBlocks.filter(blockFilter)[0]
    this.sidebarContentBlocksSave $splice: [[this.state.sidebarContentBlocks.indexOf(foundBlock), 1, $.extend({}, foundBlock, attributes)]], callback

  sidebarContentBlockShowImageLibrary: (block, event) ->
    event.preventDefault() if event
    blockFilter = (b) -> b.key == block.key
    foundBlock = this.state.sidebarContentBlocks.filter(blockFilter)[0]
    this.sidebarContentBlockUpdate block, displayImageLibrary: true, null, this.sidebarContentBlockImageLibraryStart.bind(null, block)

  sidebarContentBlockRemove: (block, event, callback) ->
    event.preventDefault() if event
    blockFilter = (b) -> b.key == block.key
    foundBlock = this.state.sidebarContentBlocks.filter(blockFilter)[0]
    if foundBlock.upload_xhr
      $(foundBlock.upload_xhr.getDOMNode()).fileupload('destroy')
    this.sidebarContentBlocksSave $splice: [[this.state.sidebarContentBlocks.indexOf(foundBlock), 1]], callback

  sidebarContentBlockRemoveImage: (block, event) ->
    event.preventDefault() if event
    this.sidebarContentBlockUpdate block,
      image_state: 'empty'
      image_temp_id: null
      image_temp_placement_destroy: '1'
      image_temp_cache_url: null
      image_temp_file_name: null
      image_temp_file_size: null
      image_temp_content_type: null
    this.sidebarContentBlockPlacementInputSetVal block, 'image_alt', ''
    this.sidebarContentBlockPlacementInputSetVal block, 'image_title', ''

  sidebarContentBlockSwapForm: (block) ->
    attributes =
      image_placement_kind: if $('#' + this.sidebarContentBlockPlacementID(block, 'tab_embed')).is(':visible') then 'embeds' else 'images'
      image_placement_embed: this.sidebarContentBlockPlacementInputGetVal(block, 'image_placement_embed')
      image_alt: this.sidebarContentBlockPlacementInputGetVal(block, 'image_alt')
      image_title: this.sidebarContentBlockPlacementInputGetVal(block, 'image_title')
      text: this.sidebarContentBlockInputGetVal(block, 'text')
      text: $('#' + this.sidebarContentBlockID(block, 'text')).code()
      heading: this.sidebarContentBlockInputGetVal(block, 'heading')
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
    this.sidebarContentBlockUpdate block, attributes

  sidebarContentBlockResetForm: (block) ->
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
      callback = this.sidebarContentBlockImageInit.bind(null, block, block.upload_xhr)
    if (block.image_url and block.image_url.length > 0) or (block.image_cache_url and block.image_cache_url.length > 0)
      attributes.image_state = 'attached'
    else
      attributes.image_state = 'empty'
    this.sidebarContentBlockUpdate block, attributes, null, callback
    this.sidebarContentBlockPlacementInputSetVal block, 'image_alt', block.image_alt
    this.sidebarContentBlockPlacementInputSetVal block, 'image_title', block.image_title
    this.sidebarContentBlockPlacementInputSetVal block, 'image_placement_embed', block.image_placement_embed
    this.sidebarContentBlockPlacementInputSetVal block, 'heading', block.heading
    $('#' + this.sidebarContentBlockID(block, 'text')).code(block.text)

  sidebarContentBlockImageInit: (block, component) ->
    unless block.upload_xhr
      $(component.getDOMNode()).fileupload
        dataType: 'XML'
        url: this.props.presignedPost.url
        formData: this.props.presignedPost.fields
        paramName: 'file'
        dropZone: ".#{this.sidebarContentBlockDropZoneClassName(block)}"
        add: this.sidebarContentBlockImageAdd.bind(null, block)
        start: this.sidebarContentBlockImageStart.bind(null, block)
        progress: this.sidebarContentBlockImageProgress.bind(null, block)
        done: this.sidebarContentBlockImageDone.bind(null, block)
        fail: this.sidebarContentBlockImageFail.bind(null, block)
      this.sidebarContentBlockUpdate block, upload_xhr: component

  # PRIVATE LEVEL 3

  sidebarContentBlocksSave: (changes, callback) ->
    updated = React.addons.update(this.state, sidebarContentBlocks: changes)
    if typeof(callback) is 'function'
      this.setState updated, callback
    else
      this.setState updated

  sidebarContentBlockImageLibraryStart: (block) ->
    unless block.imageLibraryLoaded
      $.get "#{this.props.imagesPath}?page=#{block.imageLibraryPage}", this.sidebarContentBlockImageLibraryLoad.bind(null, block)

  sidebarContentBlockImageLibraryMore: (block) ->
    unless block.imageLibraryLoadedAll
      $.get "#{this.props.imagesPath}?page=#{block.imageLibraryPage}", this.sidebarContentBlockImageLibraryLoad.bind(null, block)

  sidebarContentBlockImageLibraryLoad: (block, data) ->
    this.sidebarContentBlockUpdate block,
      imageLibraryLoaded: true
      imageLibraryLoadedAll: data.images.length < 48
      imageLibraryPage: block.imageLibraryPage + 1
      images: block.images.concat data.images

  sidebarContentBlockImageLibraryAdd: (block, image) ->
    this.sidebarContentBlockUpdate block,
      displayImageLibrary: false
      image_state: 'attached'
      image_temp_id: image.id
      image_temp_placement_destroy: null
      image_temp_cache_url: image.attachment_url
      image_temp_file_name: image.attachment_file_name
      image_temp_file_size: image.attachment_file_size
      image_temp_content_type: image.attachment_content_type
    this.sidebarContentBlockPlacementInputSetVal block, 'image_alt', image.alt
    this.sidebarContentBlockPlacementInputSetVal block, 'image_title', image.title

  sidebarContentBlockInputGetVal: (block, name) ->
    $('#' + this.sidebarContentBlockID(block, name)).val()

  sidebarContentBlockInputSetVal: (block, name, value) ->
    $('#' + this.sidebarContentBlockID(block, name)).val(value)

  sidebarContentBlockPlacementInputGetVal: (block, name) ->
    $('#' + this.sidebarContentBlockPlacementID(block, name)).val()

  sidebarContentBlockPlacementInputSetVal: (block, name, value) ->
    $('#' + this.sidebarContentBlockPlacementID(block, name)).val(value)

  sidebarContentBlockImageAdd: (block, event, data) ->
    blockFilter = (b) -> b.key == block.key
    foundBlock = this.state.sidebarContentBlocks.filter(blockFilter)[0]
    file = data.files[0]
    reader = new FileReader()
    reader.onload = this.sidebarContentBlockImageRead.bind(null, foundBlock, file)
    reader.readAsDataURL file
    formData = this.props.presignedPost.fields
    formData['Content-Type'] = file.type
    data.formData = formData
    data.submit()

  sidebarContentBlockImageStart: (block, event) ->
    blockFilter = (b) -> b.key == block.key
    foundBlock = this.state.sidebarContentBlocks.filter(blockFilter)[0]
    this.sidebarContentBlockUpdate foundBlock, image_state: 'uploading'

  sidebarContentBlockImageProgress: (block, event, data) ->
    blockFilter = (b) -> b.key == block.key
    foundBlock = this.state.sidebarContentBlocks.filter(blockFilter)[0]
    if foundBlock and foundBlock.image_state is 'uploading'
      this.sidebarContentBlockUpdate foundBlock,
        image_progress: parseInt(data.loaded / data.total * 100, 10)

  sidebarContentBlockImageDone: (block, event, data) ->
    blockFilter = (b) -> b.key == block.key
    foundBlock = this.state.sidebarContentBlocks.filter(blockFilter)[0]
    if foundBlock and foundBlock.image_state is 'uploading'
      key = $(data.jqXHR.responseXML).find('Key').text()
      url = "//#{this.props.presignedPost.host}/#{key}"
      this.sidebarContentBlockUpdate foundBlock,
        image_temp_cache_url: url
        image_state: 'finishing'
      setTimeout this.sidebarContentBlockImageFinish.bind(null, foundBlock), 500

  sidebarContentBlockImageFinish: (block) ->
    blockFilter = (b) -> b.key == block.key
    foundBlock = this.state.sidebarContentBlocks.filter(blockFilter)[0]
    if foundBlock and foundBlock.image_state is 'finishing'
      $(foundBlock.upload_xhr.getDOMNode()).fileupload('destroy')
      this.sidebarContentBlockUpdate foundBlock, image_state: 'attached', upload_xhr: null, null, this.sidebarContentBlockImageInit.bind(null, foundBlock, foundBlock.upload_xhr)

  sidebarContentBlockImageFail: (block, event, data) ->
    blockFilter = (b) -> b.key == block.key
    foundBlock = this.state.sidebarContentBlocks.filter(blockFilter)[0]
    if foundBlock and foundBlock.image_state is 'uploading'
      this.sidebarContentBlockUpdate foundBlock, image_state: 'failed'

  # PRIVATE LEVEL 4

  sidebarContentBlockImageRead: (block, file, event) ->
    blockFilter = (b) -> b.key == block.key
    foundBlock = this.state.sidebarContentBlocks.filter(blockFilter)[0]
    this.sidebarContentBlockUpdate foundBlock,
      image_temp_id: null
      image_temp_placement_destroy: null
      image_temp_cache_url: event.target.result
      image_temp_file_name: file.name
      image_temp_file_size: file.size
      image_temp_content_type: file.type
    this.sidebarContentBlockPlacementInputSetVal foundBlock, 'image_alt', ''
    this.sidebarContentBlockPlacementInputSetVal foundBlock, 'image_title', ''

window.SidebarContentBlocksHandlers = SidebarContentBlocksHandlers
