CallToActionBlocksHandlers =
  propTypes:
    initialCallToActionBlocks: React.PropTypes.array
    defaultCallToActionBlockAttributes: React.PropTypes.object

  getDefaultProps: ->
    initialCallToActionBlocksPerRow: 3

  getInitialState: ->
    callToActionBlocks: this.props.initialCallToActionBlocks.map(this.callToActionBlockInitial)
    callToActionBlocksPerRow: parseInt(this.props.initialCallToActionBlocksPerRow) or 3

  callToActionBlocksInputs: ->
    this.props.initialCallToActionBlocks.map this.callToActionBlockInputs

  callToActionBlockInputs: (block) ->
    if block.id
      blockFilter = (b) -> b.key == block.key
      foundBlock = this.state.callToActionBlocks.filter(blockFilter)[0]
      if foundBlock
        `<input key={this.callToActionBlockName(block, 'id')} type="hidden" name={this.callToActionBlockName(block, 'id')} value={block.id} />`
      else
        `<div>
          <input key={this.callToActionBlockName(block, 'id')} type="hidden" name={this.callToActionBlockName(block, 'id')} value={block.id} />
          <input key={this.callToActionBlockName(block, '_destroy')} type="hidden" name={this.callToActionBlockName(block, '_destroy')} value="1" />
        </div>`
    else
      `<div />`

  callToActionBlocksProps: ->
    blockProps: this.state.callToActionBlocks.map(this.callToActionBlockProps)
    blockAdd: this.callToActionBlockAddProps()
    maximum: this.state.callToActionBlocksPerRow
    updateMaximum: this.updateCallToActionBlocksPerRow

  callToActionBlockProps: (block, index) ->
    block: $.extend({}, block, { editing: this.state.editing, dropZoneClassName: this.callToActionBlockDropZoneClassName(block) })
    blockEditor: this.callToActionBlockEditorProps(block)
    blockImageLibrary: this.callToActionBlockImageLibraryProps(block)
    blockInputHeading: this.callToActionBlockInputHeadingProps(block)
    blockInputImage: this.callToActionBlockInputImageProps(block)
    blockInputLink: this.callToActionBlockInputLinkProps(block)
    blockInputText: this.callToActionBlockInputTextProps(block)
    blockOptions: this.callToActionBlockOptionsProps(block)
    blockInputsClassName: if block and block.displayImageLibrary then 'hide' else ''
    editing: this.state.editing
    maximum: this.state.callToActionBlocksPerRow
    name: this.callToActionBlockName.bind(null, block)
    index: index

  # PRIVATE LEVEL 1

  callToActionBlockInitial: (block) ->
    $.extend {}, this.callToActionBlockDefaultProps(), block

  callToActionBlockPlacementID: (block, name) ->
    "call-to-action-blocks-#{block.key}-call-to-action-block-image-placement-attributes-#{name}"

  callToActionBlockID: (block, name) ->
    "call-to-action-blocks-#{block.key}-attributes-#{name}"

  callToActionBlockName: (block, name) ->
    "call_to_action_blocks_attributes[#{block.key}][#{name}]"

  callToActionBlockPlacementName: (block, name) ->
    "call_to_action_blocks_attributes[#{block.key}][call_to_action_block_image_placement_attributes][#{name}]"

  callToActionBlockDropZoneClassName: (block) ->
    "call-to-action-blocks-#{block.key}-drop-zone"

  updateCallToActionBlocksPerRow: ->
    if this.state.callToActionBlocksPerRow is 3
      this.setState callToActionBlocksPerRow: 4
    else if this.state.callToActionBlocksPerRow is 4
      this.setState callToActionBlocksPerRow: 2
    else
      this.setState callToActionBlocksPerRow: 3

  callToActionBlockAddProps: ->
    visible: this.state.editing
    onClick: this.callToActionBlockAdd
    content: 'Add a Call to Action Block'

  callToActionBlockEditorProps: (block) ->
    id: "call-to-action-block-#{block.key}-editor"
    title: 'Edit Call to Action Block Details'
    swapForm: this.callToActionBlockSwapForm.bind(null, block)
    resetForm: this.callToActionBlockResetForm.bind(null, block)

  callToActionBlockImageLibraryProps: (block) ->
    visible: block and block.displayImageLibrary
    loaded: block and block.imageLibraryLoaded
    more: block and !block.imageLibraryLoadedAll
    loadMore: this.callToActionBlockImageLibraryMore.bind(null, block)
    hide: this.callToActionBlockUpdate.bind(null, block, displayImageLibrary: false)
    add: this.callToActionBlockImageLibraryAdd.bind(null, block)
    images: block.images

  callToActionBlockInputHeadingProps: (block) ->
    id: this.callToActionBlockID(block, 'heading')
    name: this.callToActionBlockName(block, 'heading')
    value: block.heading
    label: 'Heading'

  callToActionBlockInputImageProps: (block) ->
    init: this.callToActionBlockImageInit.bind(null, block)
    id: this.callToActionBlockID.bind(null, block)
    name: this.callToActionBlockPlacementName.bind(null, block)
    showImageLibrary: this.callToActionBlockShowImageLibrary.bind(null, block)
    removeImage: this.callToActionBlockRemoveImage.bind(null, block)
    alt: block.image_alt
    image_id: block.image_id
    image_placement_id: block.image_placement_id
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
    label: 'Background Image'
    dropZoneClassName: this.callToActionBlockDropZoneClassName(block)
    bulkUploadPath: this.props.bulkUploadPath

  callToActionBlockInputLinkProps: (block) ->
    id: this.callToActionBlockID.bind(null, block)
    name: this.callToActionBlockName.bind(null, block)
    label: block.link_label
    version: block.link_version
    target_blank: block.link_target_blank
    no_follow: block.link_no_follow
    link_id: block.link_id
    link_type: block.link_type
    external_url: block.link_external_url
    checkedNone: block.link_version is 'link_none'
    checkedInternal: block.link_version is 'link_internal'
    checkedExternal: block.link_version is 'link_external'
    internalWebpages: this.props.internalWebpages

  callToActionBlockInputTextProps: (block) ->
    id: this.callToActionBlockID(block, 'text')
    name: this.callToActionBlockName(block, 'text')
    value: block.text
    label: 'Text'
    rows: 4
    wysiwyg: true

  callToActionBlockOptionsProps: (block) ->
    visible: this.state.editing
    editorTarget: "#call-to-action-block-#{block.key}-editor"
    editLabel: 'Edit Details'
    removeLabel: 'Remove Call to Action Block'
    onRemove: this.callToActionBlockRemove.bind(null, block)
    onEdit: this.callToActionBlockEdit.bind(null, block)

  # PRIVATE LEVEL 2

  callToActionBlockDefaultProps: ->
    key: Math.floor(Math.random() * Math.pow(10, 10))
    image_progress: 0
    image_state: 'empty'
    link_target_blank: false
    link_no_follow: false
    displayImageLibrary: false
    imageLibraryLoaded: false
    imageLibraryPage: 1
    images: []
    heading: 'Heading'
    text: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.
      Aenean ultricies ultrices mi eu maximus. Curabitur dignissim libero
      quis sem suscipit tristique. Nunc convallis lorem ut sagittis faucibus.'

  callToActionBlockAdd: (event, callback) ->
    event.preventDefault() if event
    this.callToActionBlocksSave $push: [$.extend({}, this.callToActionBlockDefaultProps(), (this.props.defaultCallToActionBlockAttributes or {}))], callback

  callToActionBlockEdit: (block) ->

  callToActionBlockUpdate: (block, attributes, event, callback) ->
    event.preventDefault() if event
    blockFilter = (b) -> b.key == block.key
    foundBlock = this.state.callToActionBlocks.filter(blockFilter)[0]
    this.callToActionBlocksSave $splice: [[this.state.callToActionBlocks.indexOf(foundBlock), 1, $.extend({}, foundBlock, attributes)]], callback

  callToActionBlockShowImageLibrary: (block, event) ->
    event.preventDefault() if event
    blockFilter = (b) -> b.key == block.key
    foundBlock = this.state.callToActionBlocks.filter(blockFilter)[0]
    this.callToActionBlockUpdate block, displayImageLibrary: true, null, this.callToActionBlockImageLibraryStart.bind(null, block)

  callToActionBlockRemove: (block, event, callback) ->
    event.preventDefault() if event
    blockFilter = (b) -> b.key == block.key
    foundBlock = this.state.callToActionBlocks.filter(blockFilter)[0]
    if foundBlock.upload_xhr
      $(foundBlock.upload_xhr.getDOMNode()).fileupload('destroy')
    this.callToActionBlocksSave $splice: [[this.state.callToActionBlocks.indexOf(foundBlock), 1]], callback

  callToActionBlockRemoveImage: (block, event) ->
    event.preventDefault() if event
    this.callToActionBlockUpdate block,
      image_state: 'empty'
      image_temp_id: null
      image_temp_placement_destroy: '1'
      image_temp_cache_url: null
      image_temp_file_name: null
      image_temp_file_size: null
      image_temp_content_type: null
    this.callToActionBlockPlacementInputSetVal block, 'image_alt', ''
    this.callToActionBlockPlacementInputSetVal block, 'image_title', ''

  callToActionBlockSwapForm: (block) ->
    if (block.image_temp_placement_destroy and block.image_temp_placement_destroy is '1') or (block.image_temp_cache_url and block.image_temp_cache_url.length > 0)
      this.callToActionBlockUpdate block,
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
        image_alt: this.callToActionBlockPlacementInputGetVal(block, 'image_alt')
        image_title: this.callToActionBlockPlacementInputGetVal(block, 'image_title')
        link_version: $("input[name=\"#{this.callToActionBlockName(block, 'link_version')}\"]:checked").val()
        link_label: this.callToActionBlockInputGetVal(block, 'link_label')
        link_id: parseInt(this.callToActionBlockInputGetVal(block, 'link_id'))
        link_type: this.callToActionBlockInputGetVal(block, 'link_type')
        link_external_url: this.callToActionBlockInputGetVal(block, 'link_external_url')
        link_target_blank: this.callToActionBlockInputGetVal(block, 'link_target_blank')
        link_no_follow: this.callToActionBlockInputGetVal(block, 'link_no_follow')
        heading: this.callToActionBlockInputGetVal(block, 'heading')
        text: this.callToActionBlockInputGetVal(block, 'text')
    else
      this.callToActionBlockUpdate block,
        image_alt: this.callToActionBlockPlacementInputGetVal(block, 'image_alt')
        image_title: this.callToActionBlockPlacementInputGetVal(block, 'image_title')
        link_version: $("input[name=\"#{this.callToActionBlockName(block, 'link_version')}\"]:checked").val()
        link_label: this.callToActionBlockInputGetVal(block, 'link_label')
        link_id: parseInt(this.callToActionBlockInputGetVal(block, 'link_id'))
        link_type: this.callToActionBlockInputGetVal(block, 'link_type')
        link_external_url: this.callToActionBlockInputGetVal(block, 'link_external_url')
        link_target_blank: this.callToActionBlockInputGetVal(block, 'link_target_blank')
        link_no_follow: this.callToActionBlockInputGetVal(block, 'link_no_follow')
        heading: this.callToActionBlockInputGetVal(block, 'heading')
        text: this.callToActionBlockInputGetVal(block, 'text')

  callToActionBlockResetForm: (block) ->
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
      callback = this.callToActionBlockImageInit.bind(null, block, block.upload_xhr)
    if (block.image_url and block.image_url.length > 0) or (block.image_cache_url and block.image_cache_url.length > 0)
      attributes.image_state = 'attached'
    else
      attributes.image_state = 'empty'
    this.callToActionBlockUpdate block, attributes, null, callback
    this.callToActionBlockPlacementInputSetVal block, 'image_alt', block.image_alt
    this.callToActionBlockPlacementInputSetVal block, 'image_title', block.image_title
    this.callToActionBlockInputSetVal block, 'link_version', block.link_version
    this.callToActionBlockInputSetVal block, 'link_label', block.link_label
    this.callToActionBlockInputSetVal block, 'link_id', block.link_id
    this.callToActionBlockInputSetVal block, 'link_type', block.link_type
    this.callToActionBlockInputSetVal block, 'link_external_url', block.link_external_url
    this.callToActionBlockInputSetVal block, 'link_target_blank', block.link_target_blank
    this.callToActionBlockInputSetVal block, 'link_no_follow', block.link_no_follow
    this.callToActionBlockInputSetVal block, 'heading', block.heading
    if $('#' + this.callToActionBlockID(block, 'text')).data('wysihtml5')
      $('#' + this.callToActionBlockID(block, 'text')).data('wysihtml5').editor.setValue(block.text)

  callToActionBlockImageInit: (block, component) ->
    unless block.upload_xhr
      $(component.getDOMNode()).fileupload
        dataType: 'XML'
        url: this.props.presignedPostURL
        formData: this.props.presignedPostFields
        paramName: 'file'
        dropZone: ".#{this.callToActionBlockDropZoneClassName(block)}"
        add: this.callToActionBlockImageAdd.bind(null, block)
        start: this.callToActionBlockImageStart.bind(null, block)
        progress: this.callToActionBlockImageProgress.bind(null, block)
        done: this.callToActionBlockImageDone.bind(null, block)
        fail: this.callToActionBlockImageFail.bind(null, block)
      this.callToActionBlockUpdate block, upload_xhr: component

  # PRIVATE LEVEL 3

  callToActionBlocksSave: (changes, callback) ->
    updated = React.addons.update(this.state, callToActionBlocks: changes)
    if typeof(callback) is 'function'
      this.setState updated, callback
    else
      this.setState updated

  callToActionBlockImageLibraryStart: (block) ->
    unless block.imageLibraryLoaded
      $.get "#{this.props.imagesPath}?page=#{block.imageLibraryPage}", this.callToActionBlockImageLibraryLoad.bind(null, block)

  callToActionBlockImageLibraryMore: (block) ->
    unless block.imageLibraryLoadedAll
      $.get "#{this.props.imagesPath}?page=#{block.imageLibraryPage}", this.callToActionBlockImageLibraryLoad.bind(null, block)

  callToActionBlockImageLibraryLoad: (block, data) ->
    this.callToActionBlockUpdate block,
      imageLibraryLoaded: true
      imageLibraryLoadedAll: data.images.length < 48
      imageLibraryPage: block.imageLibraryPage + 1
      images: block.images.concat data.images

  callToActionBlockImageLibraryAdd: (block, image) ->
    this.callToActionBlockUpdate block,
      displayImageLibrary: false
      image_state: 'attached'
      image_temp_id: image.id
      image_temp_placement_destroy: null
      image_temp_cache_url: image.attachment_url
      image_temp_file_name: image.attachment_file_name
      image_temp_file_size: image.attachment_file_size
      image_temp_content_type: image.attachment_content_type
    this.callToActionBlockPlacementInputSetVal block, 'image_alt', image.alt
    this.callToActionBlockPlacementInputSetVal block, 'image_title', image.title

  callToActionBlockInputGetVal: (block, name) ->
    $('#' + this.callToActionBlockID(block, name)).val()

  callToActionBlockInputSetVal: (block, name, value) ->
    $('#' + this.callToActionBlockID(block, name)).val(value)

  callToActionBlockPlacementInputGetVal: (block, name) ->
    $('#' + this.callToActionBlockPlacementID(block, name)).val()

  callToActionBlockPlacementInputSetVal: (block, name, value) ->
    $('#' + this.callToActionBlockPlacementID(block, name)).val(value)

  callToActionBlockImageAdd: (block, event, data) ->
    blockFilter = (b) -> b.key == block.key
    foundBlock = this.state.callToActionBlocks.filter(blockFilter)[0]
    file = data.files[0]
    reader = new FileReader()
    reader.onload = this.callToActionBlockImageRead.bind(null, block, file)
    reader.readAsDataURL file
    formData = this.props.presignedPostFields
    formData['Content-Type'] = file.type
    data.formData = formData
    data.submit()

  callToActionBlockImageStart: (block, event) ->
    blockFilter = (b) -> b.key == block.key
    foundBlock = this.state.callToActionBlocks.filter(blockFilter)[0]
    this.callToActionBlockUpdate foundBlock, image_state: 'uploading'

  callToActionBlockImageProgress: (block, event, data) ->
    blockFilter = (b) -> b.key == block.key
    foundBlock = this.state.callToActionBlocks.filter(blockFilter)[0]
    if foundBlock and foundBlock.image_state is 'uploading'
      this.callToActionBlockUpdate foundBlock,
        image_progress: parseInt(data.loaded / data.total * 100, 10)

  callToActionBlockImageDone: (block, event, data) ->
    blockFilter = (b) -> b.key == block.key
    foundBlock = this.state.callToActionBlocks.filter(blockFilter)[0]
    if foundBlock and foundBlock.image_state is 'uploading'
      key = $(data.jqXHR.responseXML).find('Key').text()
      url = "//#{this.props.presignedPostHost}/#{key}"
      this.callToActionBlockUpdate foundBlock,
        image_temp_cache_url: url
        image_state: 'finishing'
      setTimeout this.callToActionBlockImageFinish.bind(null, foundBlock), 500

  callToActionBlockImageFinish: (block) ->
    blockFilter = (b) -> b.key == block.key
    foundBlock = this.state.callToActionBlocks.filter(blockFilter)[0]
    if foundBlock and foundBlock.image_state is 'finishing'
      $(foundBlock.upload_xhr.getDOMNode()).fileupload('destroy')
      this.callToActionBlockUpdate foundBlock, image_state: 'attached', upload_xhr: null, null, this.callToActionBlockImageInit.bind(null, foundBlock, foundBlock.upload_xhr)

  callToActionBlockImageFail: (block, event, data) ->
    blockFilter = (b) -> b.key == block.key
    foundBlock = this.state.callToActionBlocks.filter(blockFilter)[0]
    if foundBlock and foundBlock.image_state is 'uploading'
      this.callToActionBlockUpdate foundBlock, image_state: 'failed'

  # PRIVATE LEVEL 4

  callToActionBlockImageRead: (block, file, event) ->
    blockFilter = (b) -> b.key == block.key
    foundBlock = this.state.callToActionBlocks.filter(blockFilter)[0]
    this.callToActionBlockUpdate foundBlock,
      image_temp_id: null
      image_temp_placement_destroy: null
      image_temp_cache_url: event.target.result
      image_temp_file_name: file.name
      image_temp_file_size: file.size
      image_temp_content_type: file.type
    this.callToActionBlockPlacementInputSetVal block, 'image_alt', ''
    this.callToActionBlockPlacementInputSetVal block, 'image_title', ''

window.CallToActionBlocksHandlers = CallToActionBlocksHandlers
