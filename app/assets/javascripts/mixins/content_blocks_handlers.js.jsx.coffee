ContentBlocksHandlers =
  propTypes:
    initialContentBlocks: React.PropTypes.array
    defaultContentBlockAttributes: React.PropTypes.object

  getInitialState: ->
    contentBlocks: this.props.initialContentBlocks.map(this.contentBlockInitial)

  contentBlocksInputs: ->
    this.props.initialContentBlocks.map this.contentBlockInputs

  contentBlockInputs: (block) ->
    if block.id
      blockFilter = (b) -> b.key == block.key
      foundBlock = this.state.contentBlocks.filter(blockFilter)[0]
      if foundBlock
        `<input key={this.contentBlockName(block, 'id')} type="hidden" name={this.contentBlockName(block, 'id')} value={block.id} />`
      else
        `<div>
          <input key={this.contentBlockName(block, 'id')} type="hidden" name={this.contentBlockName(block, 'id')} value={block.id} />
          <input key={this.contentBlockName(block, '_destroy')} type="hidden" name={this.contentBlockName(block, '_destroy')} value="1" />
        </div>`
    else
      `<div />`

  contentBlocksProps: ->
    blockProps: this.state.contentBlocks.map(this.contentBlockProps)
    blockAdd: this.contentBlockAddProps()

  contentBlockProps: (block) ->
    block: $.extend({}, block, { editing: this.state.editing, dropZoneClassName: this.contentBlockDropZoneClassName(block) })
    blockEditor: this.contentBlockEditorProps(block)
    blockImageLibrary: this.contentBlockImageLibraryProps(block)
    blockInputImage: this.contentBlockInputImageProps(block)
    blockInputText: this.contentBlockInputTextProps(block)
    blockOptions: this.contentBlockOptionsProps(block)
    blockInputsClassName: if block and block.displayImageLibrary then 'hide' else ''
    editing: this.state.editing
    name: this.contentBlockName.bind(null, block)

  # PRIVATE LEVEL 1

  contentBlockInitial: (block) ->
    $.extend {}, this.contentBlockDefaultProps(), block

  contentBlockID: (block, name) ->
    "content-blocks-#{block.key}-attributes-#{name}"

  contentBlockPlacementID: (block, name) ->
    "content-blocks-#{block.key}-content-block-image-placement-attributes-#{name}"

  contentBlockName: (block, name) ->
    "content_blocks_attributes[#{block.key}][#{name}]"

  contentBlockPlacementName: (block, name) ->
    "content_blocks_attributes[#{block.key}][content_block_image_placement_attributes][#{name}]"

  contentBlockDropZoneClassName: (block) ->
    "content-blocks-#{block.key}-drop-zone"

  contentBlockAddProps: ->
    visible: this.state.editing and this.state.contentBlocks.length < 100
    onClick: this.contentBlockAdd
    content: 'Add a Content Block'

  contentBlockEditorProps: (block) ->
    id: "content-block-#{block.key}-editor"
    title: 'Edit Content Block Details'
    swapForm: this.contentBlockSwapForm.bind(null, block)
    resetForm: this.contentBlockResetForm.bind(null, block)

  contentBlockImageLibraryProps: (block) ->
    visible: block and block.displayImageLibrary
    loaded: block and block.imageLibraryLoaded
    more: block and !block.imageLibraryLoadedAll
    loadMore: this.contentBlockImageLibraryMore.bind(null, block)
    hide: this.contentBlockUpdate.bind(null, block, displayImageLibrary: false)
    add: this.contentBlockImageLibraryAdd.bind(null, block)
    images: block.images

  contentBlockInputImageProps: (block) ->
    init: this.contentBlockImageInit.bind(null, block)
    id: this.contentBlockPlacementID.bind(null, block)
    name: this.contentBlockPlacementName.bind(null, block)
    showImageLibrary: this.contentBlockShowImageLibrary.bind(null, block)
    removeImage: this.contentBlockRemoveImage.bind(null, block)
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
    dropZoneClassName: this.contentBlockDropZoneClassName(block)
    bulkUploadPath: this.props.bulkUploadPath
    allowEmbed: true

  contentBlockInputTextProps: (block) ->
    id: this.contentBlockID(block, 'text')
    name: this.contentBlockName(block, 'text')
    value: block.text
    label: 'Text'
    rows: 4
    wysiwyg: true

  contentBlockOptionsProps: (block) ->
    visible: this.state.editing
    prev: this.contentBlockPrevTheme.bind(null, block)
    next: this.contentBlockNextTheme.bind(null, block)
    editorTarget: "#content-block-#{block.key}-editor"
    editLabel: 'Edit Details'
    removeLabel: 'Remove Content Block'
    onRemove: this.contentBlockRemove.bind(null, block)
    onEdit: this.contentBlockEdit.bind(null, block)

  # PRIVATE LEVEL 2

  contentBlockDefaultProps: ->
    key: Math.floor(Math.random() * Math.pow(10, 10))
    theme: 'left'
    image_placement_kind: 'images'
    image_progress: 0
    image_state: 'empty'
    displayImageLibrary: false
    imageLibraryLoaded: false
    imageLibraryPage: 1
    images: []
    text: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.
      Aenean ultricies ultrices mi eu maximus. Curabitur dignissim libero
      quis sem suscipit tristique. Nunc convallis lorem ut sagittis faucibus.'

  contentBlockAdd: (event, callback) ->
    event.preventDefault() if event
    this.contentBlocksSave $push: [$.extend({}, this.contentBlockDefaultProps(), (this.props.defaultContentBlockAttributes or {}))], callback

  contentBlockEdit: (block) ->

  contentBlockUpdate: (block, attributes, event, callback) ->
    event.preventDefault() if event
    blockFilter = (b) -> b.key == block.key
    foundBlock = this.state.contentBlocks.filter(blockFilter)[0]
    this.contentBlocksSave $splice: [[this.state.contentBlocks.indexOf(foundBlock), 1, $.extend({}, foundBlock, attributes)]], callback

  contentBlockShowImageLibrary: (block, event) ->
    event.preventDefault() if event
    blockFilter = (b) -> b.key == block.key
    foundBlock = this.state.contentBlocks.filter(blockFilter)[0]
    this.contentBlockUpdate block, displayImageLibrary: true, null, this.contentBlockImageLibraryStart.bind(null, block)

  contentBlockRemove: (block, event, callback) ->
    event.preventDefault() if event
    blockFilter = (b) -> b.key == block.key
    foundBlock = this.state.contentBlocks.filter(blockFilter)[0]
    if foundBlock.upload_xhr
      $(foundBlock.upload_xhr.getDOMNode()).fileupload('destroy')
    this.contentBlocksSave $splice: [[this.state.contentBlocks.indexOf(foundBlock), 1]], callback

  contentBlockRemoveImage: (block, event) ->
    event.preventDefault() if event
    this.contentBlockUpdate block,
      image_state: 'empty'
      image_temp_id: null
      image_temp_placement_destroy: '1'
      image_temp_cache_url: null
      image_temp_file_name: null
      image_temp_file_size: null
      image_temp_content_type: null
    this.contentBlockPlacementInputSetVal block, 'image_alt', ''
    this.contentBlockPlacementInputSetVal block, 'image_title', ''

  contentBlockSwapForm: (block) ->
    attributes =
      image_placement_kind: if $('#' + this.contentBlockPlacementID(block, 'tab_embed')).is(':visible') then 'embeds' else 'images'
      image_placement_embed: this.contentBlockPlacementInputGetVal(block, 'image_placement_embed')
      image_alt: this.contentBlockPlacementInputGetVal(block, 'image_alt')
      image_title: this.contentBlockPlacementInputGetVal(block, 'image_title')
      text: this.contentBlockInputGetVal(block, 'text')
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
    this.contentBlockUpdate block, attributes

  contentBlockResetForm: (block) ->
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
      callback = this.contentBlockImageInit.bind(null, block, block.upload_xhr)
    if (block.image_url and block.image_url.length > 0) or (block.image_cache_url and block.image_cache_url.length > 0)
      attributes.image_state = 'attached'
    else
      attributes.image_state = 'empty'
    this.contentBlockUpdate block, attributes, null, callback
    this.contentBlockPlacementInputSetVal block, 'image_alt', block.image_alt
    this.contentBlockPlacementInputSetVal block, 'image_title', block.image_title
    this.contentBlockPlacementInputSetVal block, 'image_placement_embed', block.image_placement_embed
    if $('#' + this.contentBlockID(block, 'text')).data('wysihtml5')
      $('#' + this.contentBlockID(block, 'text')).data('wysihtml5').editor.setValue(block.text)

  contentBlockImageInit: (block, component) ->
    unless block.upload_xhr
      $(component.getDOMNode()).fileupload
        dataType: 'XML'
        url: this.props.presignedPost.url
        formData: this.props.presignedPost.fields
        paramName: 'file'
        dropZone: ".#{this.contentBlockDropZoneClassName(block)}"
        add: this.contentBlockImageAdd.bind(null, block)
        start: this.contentBlockImageStart.bind(null, block)
        progress: this.contentBlockImageProgress.bind(null, block)
        done: this.contentBlockImageDone.bind(null, block)
        fail: this.contentBlockImageFail.bind(null, block)
      this.contentBlockUpdate block, upload_xhr: component

  contentBlockPrevTheme: (block) ->
    this.contentBlockUpdate block, theme: this.prevItem(this.contentBlockThemes, block.theme)

  contentBlockNextTheme: (block) ->
    this.contentBlockUpdate block, theme: this.nextItem(this.contentBlockThemes, block.theme)

  # PRIVATE LEVEL 3

  contentBlocksSave: (changes, callback) ->
    updated = React.addons.update(this.state, contentBlocks: changes)
    if typeof(callback) is 'function'
      this.setState updated, callback
    else
      this.setState updated

  contentBlockImageLibraryStart: (block) ->
    unless block.imageLibraryLoaded
      $.get "#{this.props.imagesPath}?page=#{block.imageLibraryPage}", this.contentBlockImageLibraryLoad.bind(null, block)

  contentBlockImageLibraryMore: (block) ->
    unless block.imageLibraryLoadedAll
      $.get "#{this.props.imagesPath}?page=#{block.imageLibraryPage}", this.contentBlockImageLibraryLoad.bind(null, block)

  contentBlockImageLibraryLoad: (block, data) ->
    this.contentBlockUpdate block,
      imageLibraryLoaded: true
      imageLibraryLoadedAll: data.images.length < 48
      imageLibraryPage: block.imageLibraryPage + 1
      images: block.images.concat data.images

  contentBlockImageLibraryAdd: (block, image) ->
    this.contentBlockUpdate block,
      displayImageLibrary: false
      image_state: 'attached'
      image_temp_id: image.id
      image_temp_placement_destroy: null
      image_temp_cache_url: image.attachment_url
      image_temp_file_name: image.attachment_file_name
      image_temp_file_size: image.attachment_file_size
      image_temp_content_type: image.attachment_content_type
    this.contentBlockPlacementInputSetVal block, 'image_alt', image.alt
    this.contentBlockPlacementInputSetVal block, 'image_title', image.title

  contentBlockThemes: ['left', 'right', 'full', 'fullImage']

  contentBlockInputGetVal: (block, name) ->
    $('#' + this.contentBlockID(block, name)).val()

  contentBlockInputSetVal: (block, name, value) ->
    $('#' + this.contentBlockID(block, name)).val(value)

  contentBlockPlacementInputGetVal: (block, name) ->
    $('#' + this.contentBlockPlacementID(block, name)).val()

  contentBlockPlacementInputSetVal: (block, name, value) ->
    $('#' + this.contentBlockPlacementID(block, name)).val(value)

  contentBlockImageAdd: (block, event, data) ->
    blockFilter = (b) -> b.key == block.key
    foundBlock = this.state.contentBlocks.filter(blockFilter)[0]
    file = data.files[0]
    reader = new FileReader()
    reader.onload = this.contentBlockImageRead.bind(null, foundBlock, file)
    reader.readAsDataURL file
    formData = this.props.presignedPost.fields
    formData['Content-Type'] = file.type
    data.formData = formData
    data.submit()

  contentBlockImageStart: (block, event) ->
    blockFilter = (b) -> b.key == block.key
    foundBlock = this.state.contentBlocks.filter(blockFilter)[0]
    this.contentBlockUpdate foundBlock, image_state: 'uploading'

  contentBlockImageProgress: (block, event, data) ->
    blockFilter = (b) -> b.key == block.key
    foundBlock = this.state.contentBlocks.filter(blockFilter)[0]
    if foundBlock and foundBlock.image_state is 'uploading'
      this.contentBlockUpdate foundBlock,
        image_progress: parseInt(data.loaded / data.total * 100, 10)

  contentBlockImageDone: (block, event, data) ->
    blockFilter = (b) -> b.key == block.key
    foundBlock = this.state.contentBlocks.filter(blockFilter)[0]
    if foundBlock and foundBlock.image_state is 'uploading'
      key = $(data.jqXHR.responseXML).find('Key').text()
      url = "//#{this.props.presignedPost.host}/#{key}"
      this.contentBlockUpdate foundBlock,
        image_temp_cache_url: url
        image_state: 'finishing'
      setTimeout this.contentBlockImageFinish.bind(null, foundBlock), 500

  contentBlockImageFinish: (block) ->
    blockFilter = (b) -> b.key == block.key
    foundBlock = this.state.contentBlocks.filter(blockFilter)[0]
    if foundBlock and foundBlock.image_state is 'finishing'
      $(foundBlock.upload_xhr.getDOMNode()).fileupload('destroy')
      this.contentBlockUpdate foundBlock, image_state: 'attached', upload_xhr: null, null, this.contentBlockImageInit.bind(null, foundBlock, foundBlock.upload_xhr)

  contentBlockImageFail: (block, event, data) ->
    blockFilter = (b) -> b.key == block.key
    foundBlock = this.state.contentBlocks.filter(blockFilter)[0]
    if foundBlock and foundBlock.image_state is 'uploading'
      this.contentBlockUpdate foundBlock, image_state: 'failed'

  # PRIVATE LEVEL 4

  contentBlockImageRead: (block, file, event) ->
    blockFilter = (b) -> b.key == block.key
    foundBlock = this.state.contentBlocks.filter(blockFilter)[0]
    this.contentBlockUpdate foundBlock,
      image_temp_id: null
      image_temp_placement_destroy: null
      image_temp_cache_url: event.target.result
      image_temp_file_name: file.name
      image_temp_file_size: file.size
      image_temp_content_type: file.type
    this.contentBlockPlacementInputSetVal foundBlock, 'image_alt', ''
    this.contentBlockPlacementInputSetVal foundBlock, 'image_title', ''

window.ContentBlocksHandlers = ContentBlocksHandlers
