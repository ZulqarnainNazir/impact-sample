Webpage = React.createClass
  propTypes:
    backgroundColor: React.PropTypes.string
    browserButtonsSrc: React.PropTypes.string
    bulkUploadPath: React.PropTypes.string
    foregroundColor: React.PropTypes.string
    groupTypes: React.PropTypes.array
    groups: React.PropTypes.array
    hasMultipleBusinesses: React.PropTypes.bool
    imagesPath: React.PropTypes.string
    internalWebpages: React.PropTypes.array
    linkColor: React.PropTypes.string
    presignedPost: React.PropTypes.object
    showOnlyLocalMediaLibraryOption: React.PropTypes.bool
    sidebarPosition: React.PropTypes.string

  getInitialState: ->
    editing: true
    groups: this.getInitialGroupsState()
    mediaImageProgress: 0
    mediaImageStatus: 'empty'
    mediaKind: 'images'
    mediaLibraryHasMoreImages: true
    mediaLibraryImages: []
    mediaLibraryLoaded: false
    mediaLibraryLoadedAll: false
    mediaLibraryLocalOnly: true
    mediaLibraryPage: 1
    removedGroups: []
    sidebarPosition: if this.props.sidebarPosition is 'left' then 'left' else 'right'

  getInitialGroupsState: ->
    groups = {}
    for group, i in this.props.groups
      group.uuid = i
      group.removedBlocks = []
      groups[i] = group
      blocks = group.blocks
      group.blocks = {}
      for block, j in blocks
        block.uuid = j
        group.blocks[j] = this.defaultBlockAttributes i, j, block.type, block
      if group.type is 'HeroGroup'
        if Object.keys(group.blocks).length > 0
          group.current_block = 0
        else
          group.current_block = undefined
    groups

  componentDidMount: ->
    $('#link_modal').on 'change', 'input[type="radio"]', this.toggleLinkOptions
    $('#feed_settings_modal').on 'change', 'input[type="radio"]', this.toggleFeedLinkOptions
    $('.webpage-save-toggle-on').on 'click', -> $('.webpage-save').addClass('webpage-save-visible'); $('.webpage-save-toggle-on').hide(); $('.webpage-save-toggle-off').show()
    $('.webpage-save-toggle-off').hide().on 'click', -> $('.webpage-save').removeClass('webpage-save-visible'); $('.webpage-save-toggle-off').hide(); $('.webpage-save-toggle-on').show()
    this.enableSortables()
    this.resetLink()
    this.toggleLinkOptions()
    this.resetFeedSettings()
    this.toggleFeedLinkOptions()
    this.resetMedia()
    $('.webpage-save span.btn-default').popover
      container: 'body'
      placement: 'top'
      trigger: 'hover'
      delay:
        show: 500
        hide: 0

  componentDidUpdate: ->
    if $('#add_main_block_options > *').length is 0
      $('#add_main_block_label').hide()
    else
      $('#add_main_block_label').show()
    if $('#add_sidebar_block_options > *').length is 0
      $('#add_sidebar_block_label').hide()
    else
      $('#add_sidebar_block_label').show()

  disableSortable: ->
    $('.webpage-container').sortable('destroy')

  enableSortables: ->
    $('.webpage-container').sortable
      axis: 'y'
      container: '.webpage-container'
      expandOnHover: 400
      forceHelperSize: true
      forcePlaceholderSize: true
      handle: '.webpage-group-sort-handle'
      helper: 'clone'
      items: '> .webpage-group'
      opacity: 0.5
      placeholder: 'webpage-group-placeholder'
      revert: 100
      startCollapsed: false
      tabSize: 20
      tolerance: 'pointer'
      start: this.startWebpageGroupsSorting
      stop: this.stopWebpageGroupsSorting
    $('.webpage-group-horizontal-container').sortable
      axis: 'x'
      container: '.webpage-group-horizontal-container'
      expandOnHover: 400
      forceHelperSize: true
      forcePlaceholderSize: true
      handle: '.webpage-block-sort-handle'
      helper: 'clone'
      items: '> .webpage-block'
      opacity: 0.5
      placeholder: 'webpage-block-placeholder'
      revert: 100
      startCollapsed: false
      tabSize: 20
      tolerance: 'pointer'
      stop: this.stopWebpageBlocksSorting
    $('.webpage-group-vertical-container').sortable
      axis: 'y'
      container: '.webpage-group-vertical-container'
      expandOnHover: 400
      forceHelperSize: true
      forcePlaceholderSize: true
      handle: '.webpage-block-sort-handle'
      helper: 'clone'
      items: '> .webpage-block'
      opacity: 0.5
      placeholder: 'webpage-block-placeholder'
      revert: 100
      startCollapsed: false
      tabSize: 20
      tolerance: 'pointer'
      stop: this.stopWebpageBlocksSorting

  startWebpageGroupsSorting: (event, ui) ->
    group = this.state.groups[ui.item.data('uuid')]
    if group and group.type is 'SidebarGroup'
      ui.placeholder.addClass('webpage-group-sidebar-placeholder-' + this.state.sidebarPosition)

  stopWebpageGroupsSorting: ->
    container = $('.webpage-container')
    groupUUIDs = container.sortable('toArray', attribute: 'data-uuid')
    container.sortable('cancel')
    this.sortWebpageGroups(groupUUIDs)

  stopWebpageBlocksSorting: (event, ui) ->
    container = ui.item.closest('.webpage-group-horizontal-container, .webpage-group-vertical-container')
    group = container.closest('.webpage-group')
    blockUUIDs = container.sortable('toArray', attribute: 'data-uuid')
    container.sortable('cancel')
    this.sortWebpageBlocks(group.data('uuid'), blockUUIDs)

  sortWebpageGroups: (groupUUIDs) ->
    changes = {}
    _.each groupUUIDs, (uuid, i) ->
      $.extend changes,
        "#{uuid}":
          $merge:
            position: i
    this.setState groups: React.addons.update(this.state.groups, changes)

  sortWebpageBlocks: (groupUUID, blockUUIDs) ->
    changes =
      "#{groupUUID}":
        blocks: {}
    _.each blockUUIDs, (uuid, i) ->
      $.extend changes[groupUUID].blocks,
        "#{uuid}":
          $merge:
            position: i
    this.setState groups: React.addons.update(this.state.groups, changes)

  toggleEditing: ->
    this.setState editing: !this.state.editing

  defaultBlockAttributes: (group_uuid, block_uuid, block_type, argumentAttributes) ->
    commonAttributes =
      removeBlock: this.removeBlock.bind(null, group_uuid, block_uuid)
      type: block_type
      uuid: block_uuid
      position: $('.webpage-group[data-uuid="' + group_uuid + '"] .webpage-block').length
    blockSpecificAttributes = switch block_type
      when 'HeroBlock'
        editText: this.editText.bind(null, group_uuid, block_uuid)
        editBackground: this.editMedia.bind(null, group_uuid, block_uuid, 'background')
        editImage: this.editMedia.bind(null, group_uuid, block_uuid, 'image')
        editLink: this.editLink.bind(null, group_uuid, block_uuid)
        editCustom: this.editHeroSettings.bind(null, group_uuid, block_uuid)
        prevTheme: this.prevTheme.bind(null, group_uuid, block_uuid)
        nextTheme: this.nextTheme.bind(null, group_uuid, block_uuid)
        compress: this.compressHero.bind(null, group_uuid)
        expand: this.expandHero.bind(null, group_uuid)
        heading: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit'
        text: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum finibus ut tortor quis mattis. Donec sit amet hendrerit risus. Maecenas sed orci metus. Nulla viverra bibendum quam, eu ullamcorper felis dignissim sit amet. Pellentesque quis urna nec arcu malesuada accumsan. Nunc eu lacinia est. Vestibulum cursus consequat interdum.'
        theme: 'full'
        themes: ['full', 'right', 'left']
        well_style: 'light'
        postion_header: 'below'
        updateHeading: this.updateHeading.bind(null, group_uuid, block_uuid)
        updateText: this.updateText.bind(null, group_uuid, block_uuid)
      when 'TaglineBlock'
        editText: this.editText.bind(null, group_uuid, block_uuid)
        editLink: this.editLink.bind(null, group_uuid, block_uuid)
        editCustom: this.editTaglineSettings.bind(null, group_uuid, block_uuid)
        prevTheme: this.prevTheme.bind(null, group_uuid, block_uuid)
        nextTheme: this.nextTheme.bind(null, group_uuid, block_uuid)
        text: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum finibus ut tortor quis mattis. Donec sit amet hendrerit risus. Maecenas sed orci metus. Nulla viverra bibendum quam, eu ullamcorper felis dignissim sit amet. Pellentesque quis urna nec arcu malesuada accumsan. Nunc eu lacinia est. Vestibulum cursus consequat interdum.'
        theme: 'left'
        themes: ['left', 'center', 'right']
        well_style: 'light'
        updateText: this.updateText.bind(null, group_uuid, block_uuid)
      when 'CallToActionBlock'
        editText: this.editText.bind(null, group_uuid, block_uuid)
        editImage: this.editMedia.bind(null, group_uuid, block_uuid, 'image')
        editLink: this.editLink.bind(null, group_uuid, block_uuid)
        editCustom: this.editDefaultSettings.bind(null, group_uuid, block_uuid)
        heading: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit'
        text: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum finibus ut tortor quis mattis. Donec sit amet hendrerit risus. Maecenas sed orci metus. Nulla viverra bibendum quam, eu ullamcorper felis dignissim sit amet. Pellentesque quis urna nec arcu malesuada accumsan. Nunc eu lacinia est. Vestibulum cursus consequat interdum.'
        sort: (e) -> e.preventDefault()
        updateHeading: this.updateHeading.bind(null, group_uuid, block_uuid)
        updateText: this.updateText.bind(null, group_uuid, block_uuid)
      when 'ContentBlock'
        editText: this.editText.bind(null, group_uuid, block_uuid)
        editImage: this.editMedia.bind(null, group_uuid, block_uuid, 'image')
        editCustom: this.editDefaultSettings.bind(null, group_uuid, block_uuid)
        prevTheme: this.prevTheme.bind(null, group_uuid, block_uuid)
        nextTheme: this.nextTheme.bind(null, group_uuid, block_uuid)
        heading: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit'
        text: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum finibus ut tortor quis mattis. Donec sit amet hendrerit risus. Maecenas sed orci metus. Nulla viverra bibendum quam, eu ullamcorper felis dignissim sit amet. Pellentesque quis urna nec arcu malesuada accumsan. Nunc eu lacinia est. Vestibulum cursus consequat interdum.'
        theme: 'left'
        themes: ['left', 'left_half', 'right_half', 'right', 'text', 'image']
        updateHeading: this.updateHeading.bind(null, group_uuid, block_uuid)
        updateText: this.updateText.bind(null, group_uuid, block_uuid)
      when 'BlogFeedBlock'
        editCustom: this.editFeedSettings.bind(null, group_uuid, block_uuid)
        items_limit: 4
      when 'ReviewsBlock'
        editCustom: this.editReviewsSettings.bind(null, group_uuid, block_uuid)
        theme: 'default'
        style: 'default'
      when 'SidebarContentBlock'
        editText: this.editText.bind(null, group_uuid, block_uuid)
        editImage: this.editMedia.bind(null, group_uuid, block_uuid, 'image')
        editLink: this.editLink.bind(null, group_uuid, block_uuid)
        editCustom: this.editDefaultSettings.bind(null, group_uuid, block_uuid)
        heading: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit'
        text: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum finibus ut tortor quis mattis. Donec sit amet hendrerit risus. Maecenas sed orci metus. Nulla viverra bibendum quam, eu ullamcorper felis dignissim sit amet. Pellentesque quis urna nec arcu malesuada accumsan. Nunc eu lacinia est. Vestibulum cursus consequat interdum.'
        sort: (e) -> e.preventDefault()
        updateHeading: this.updateHeading.bind(null, group_uuid, block_uuid)
        updateText: this.updateText.bind(null, group_uuid, block_uuid)
      when 'SidebarBlogFeedBlock'
        editCustom: this.editFeedSettings.bind(null, group_uuid, block_uuid)
        sort: (e) -> e.preventDefault()
        items_limit: 4
      when 'SidebarEventsFeedBlock'
        editCustom: this.editFeedSettings.bind(null, group_uuid, block_uuid)
        sort: (e) -> e.preventDefault()
        items_limit: 4
      when 'AboutBlock'
        editText: this.editText.bind(null, group_uuid, block_uuid)
        editBackground: this.editMedia.bind(null, group_uuid, block_uuid, 'background')
        editImage: this.editMedia.bind(null, group_uuid, block_uuid, 'image')
        prevTheme: this.prevTheme.bind(null, group_uuid, block_uuid)
        nextTheme: this.nextTheme.bind(null, group_uuid, block_uuid)
        heading: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit'
        subheading: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit'
        text: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum finibus ut tortor quis mattis. Donec sit amet hendrerit risus. Maecenas sed orci metus. Nulla viverra bibendum quam, eu ullamcorper felis dignissim sit amet. Pellentesque quis urna nec arcu malesuada accumsan. Nunc eu lacinia est. Vestibulum cursus consequat interdum.'
        theme: 'banner'
        themes: ['banner', 'left']
        updateHeading: this.updateHeading.bind(null, group_uuid, block_uuid)
        updateSubheading: this.updateSubheading.bind(null, group_uuid, block_uuid)
        updateText: this.updateText.bind(null, group_uuid, block_uuid)
      when 'TeamBlock'
        prevTheme: this.prevTheme.bind(null, group_uuid, block_uuid)
        nextTheme: this.nextTheme.bind(null, group_uuid, block_uuid)
        teamMembers: this.props.teamMembers
        theme: 'vertical'
        themes: ['vertical', 'horizontal']
      when 'ContactBlock'
        editText: this.editText.bind(null, group_uuid, block_uuid)
        prevTheme: this.prevTheme.bind(null, group_uuid, block_uuid)
        nextTheme: this.nextTheme.bind(null, group_uuid, block_uuid)
        text: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum finibus ut tortor quis mattis. Donec sit amet hendrerit risus. Maecenas sed orci metus. Nulla viverra bibendum quam, eu ullamcorper felis dignissim sit amet. Pellentesque quis urna nec arcu malesuada accumsan. Nunc eu lacinia est. Vestibulum cursus consequat interdum.'
        theme: 'right'
        themes: ['right', 'banner', 'inline', 'content']
        updateText: this.updateText.bind(null, group_uuid, block_uuid)
        location: this.props.location
        openings: this.props.openings
    $.extend {}, commonAttributes, blockSpecificAttributes, argumentAttributes

  insertGroup: (group_type, block_type) ->
    this.disableSortable()
    $('.webpage-save span.btn-default').popover('hide')
    group_uuid = Math.floor(Math.random() * Math.pow(10, 10))
    messageKey = if /Sidebar/.exec(block_type) then 'insertSidebarSuccessMessage' else 'insertMainSuccessMessage'
    if group_type is 'CallToActionGroup'
      block_uuid_1 = Math.floor(Math.random() * Math.pow(10, 10))
      block_uuid_2 = Math.floor(Math.random() * Math.pow(10, 10))
      block_uuid_3 = Math.floor(Math.random() * Math.pow(10, 10))
      blocks =
        "#{block_uuid_1}": this.defaultBlockAttributes(group_uuid, block_uuid_1, block_type)
        "#{block_uuid_2}": this.defaultBlockAttributes(group_uuid, block_uuid_2, block_type)
        "#{block_uuid_3}": this.defaultBlockAttributes(group_uuid, block_uuid_3, block_type)
    else
      block_uuid = Math.floor(Math.random() * Math.pow(10, 10))
      blocks =
        "#{block_uuid}": this.defaultBlockAttributes(group_uuid, block_uuid, block_type)
    changes =
      "#{messageKey}":
        $set: 'Success, block appended to page.'
      groups:
        $merge:
          "#{group_uuid}":
            type: group_type
            uuid: group_uuid
            kind: 'container'
            max_blocks: if group_type is 'CallToActionGroup' then 3 else undefined
            current_block: if group_type is'HeroGroup' then block_uuid else undefined
            position: $('.webpage-group').length
            blocks: blocks
            removedBlocks: []
    this.setState React.addons.update(this.state, changes), this.finishInsert.bind(null, messageKey)

  insertBlock: (group_uuid, block_type) ->
    this.disableSortable()
    $('.webpage-save span.btn-default').popover('hide')
    group = this.state.groups[group_uuid]
    block_uuid = Math.floor(Math.random() * Math.pow(10, 10))
    messageKey = if /Sidebar/.exec(block_type) then 'insertSidebarSuccessMessage' else 'insertMainSuccessMessage'
    changes =
      "#{messageKey}":
        $set: 'Success, block appended to page.'
      groups:
        "#{group_uuid}":
          blocks:
            $merge:
              "#{block_uuid}": this.defaultBlockAttributes(group_uuid, block_uuid, block_type)
          current_block:
            $set: if group.type is 'HeroGroup' then block_uuid else undefined
    this.setState React.addons.update(this.state, changes), this.finishInsert.bind(null, messageKey)

  finishInsert: (messageKey) ->
    this.enableSortables()
    setTimeout this.clearSuccessMessage.bind(null, messageKey), 1500

  clearSuccessMessage: (messageKey) ->
    this.setState "#{messageKey}": null

  removeBlock: (group_uuid, block_uuid, event) ->
    event.preventDefault()
    group = this.state.groups[group_uuid]
    if _.reject(group.blocks, (block) -> block is undefined).length > 1
      block = group.blocks[block_uuid]
      if group.type is 'HeroGroup'
        current_block = _.reject(group.blocks, (b) -> b is undefined or b.uuid is block_uuid)[0].uuid
      else
        current_block = undefined
      changes =
        groups:
          "#{group_uuid}":
            blocks:
              "#{block_uuid}":
                $set: undefined
            removedBlocks:
              $push: [
                index: block_uuid
                id: block.id
              ]
            current_block:
              $set: current_block
    else
      changes =
        groups:
          "#{group_uuid}":
            $set: undefined
        removedGroups:
          $push: [
            index: group_uuid
            id: group.id
          ]
    this.setState React.addons.update(this.state, changes)

  updateGroup: (group_uuid, attributes, callback) ->
    group = this.state.groups[group_uuid]
    blocks_count = _.size(_.reject(this.props.blocks, (block) -> block is undefined))
    if group.type is 'CallToActionGroup' and blocks_count < attributes.max_blocks
      blocks = $.extend {}, group.blocks
      for n in [1..(attributes.max_blocks - blocks_count)]
        block_uuid = Math.floor(Math.random() * Math.pow(10, 10))
        blocks[block_uuid] = this.defaultBlockAttributes(group_uuid, block_uuid, 'CallToActionBlock')
      attributes['blocks'] = blocks
    changes =
      "#{group_uuid}":
        $merge: attributes
    if callback and !callback.target
      this.setState groups: React.addons.update(this.state.groups, changes), callback
    else
      this.setState groups: React.addons.update(this.state.groups, changes)

  updateBlock: (group_uuid, block_uuid, attributes, callback) ->
    changes =
      "#{group_uuid}":
        blocks:
          "#{block_uuid}":
            $merge: attributes
    if callback
      this.setState groups: React.addons.update(this.state.groups, changes), callback
    else
      this.setState groups: React.addons.update(this.state.groups, changes)

  editText: (group_uuid, block_uuid, event) ->
    event.preventDefault()
    group = this.state.groups[group_uuid]
    block = group.blocks[block_uuid]
    this.updateBlock group_uuid, block_uuid,
      richText: if block.richText then false else true

  updateHeading: (group_uuid, block_uuid, richText) ->
    richText = '' if richText is '<br>'
    this.updateBlock group_uuid, block_uuid, heading: richText

  updateSubheading: (group_uuid, block_uuid, richText) ->
    richText = '' if richText is '<br>'
    this.updateBlock group_uuid, block_uuid, subheading: richText

  updateText: (group_uuid, block_uuid, richText) ->
    richText = '' if richText is '<br>'
    this.updateBlock group_uuid, block_uuid, text: richText

  editMedia: (group_uuid, block_uuid, type, event) ->
    event.preventDefault()
    $('#media_type').val type
    $('#media_group_uuid').val group_uuid
    $('#media_block_uuid').val block_uuid
    group = this.state.groups[group_uuid]
    block = group.blocks[block_uuid]
    placement = (if type is 'image' then block.block_image_placement else block.block_background_placement) or {}
    stateChanges =
      mediaID: placement.id
      mediaDestroy: undefined
      mediaImageAttachmentContentType: placement.image_attachment_content_type
      mediaImageAttachmentFileName: placement.image_attachment_file_name
      mediaImageAttachmentFileSize: placement.image_attachment_file_size
      mediaImageProgress: 0
      mediaImageStatus: if Object.keys(placement).length > 0 then 'attached' else 'empty'
      mediaImageAttachmentURL: placement.image_attachment_url
      mediaImageAttachmentCacheURL: undefined
      mediaImageAttachmentThumbnailURL: placement.image_attachment_thumbnail_url
      mediaImageAttachmentSmallURL: placement.image_attachment_small_url
      mediaImageAttachmentSmallFixedURL: placement.image_attachment_small_fixed_url
      mediaImageAttachmentMediumURL: placement.image_attachment_medium_url
      mediaImageAttachmentMediumFixedURL: placement.image_attachment_medium_fixed_url
      mediaImageAttachmentLargeURL: placement.image_attachment_large_url
      mediaImageAttachmentLargeFixedURL: placement.image_attachment_large_fixed_url
      mediaImageAttachmentJumboURL: placement.image_attachment_jumbo_url
      mediaImageAttachmentJumboFixedURL: placement.image_attachment_jumbo_fixed_url
      mediaLibraryImages: []
      mediaLibraryLoaded: false
      mediaLibraryLoadedAll: false
      mediaLibraryPage: 1
    this.setState stateChanges, ->
      if type is 'image'
        $('a[href="#media_tab_embed"]').show()
      else
        $('a[href="#media_tab_embed"]').hide()
      if placement.kind is 'embeds'
        $('a[href="#media_tab_embed"]').tab('show')
      else
        $('a[href="#media_tab_image"]').tab('show')
      $('#media_embed').val placement.embed
      $('#media_full_width').prop('checked', placement.full_width or false)
      $('#media_image_alt').val placement.image_alt
      $('#media_image_title').val placement.image_title
      $('#media_tabs').css('display', 'block')
      $('#media_library').css('display', 'none')
      $('#media_modal').modal('show')
    this.initializeMediaUpload()

  initializeMediaUpload: ->
    $('#media_modal').fileupload
      dataType: 'XML'
      url: this.props.presignedPost.url
      formData: this.props.presignedPost.fields
      paramName: 'file'
      dropZone: '.media_dropzone'
      add: this.mediaUploadAdd
      progress: this.mediaUploadProgress
      done: this.mediaUploadDone
      fail: this.mediaUploadFail

  mediaUploadAdd: (event, data) ->
    file = data.files[0]
    reader = new FileReader()
    reader.onload = this.mediaUploadRead.bind(null, file)
    reader.readAsDataURL file
    formData = this.props.presignedPost.fields
    formData['Content-Type'] = file.type
    data.formData = formData
    data.submit()

  mediaUploadRead: (file, event) ->
    group = this.state.groups[$('#media_group_uuid').val()]
    block = group.blocks[$('#media_block_uuid')]
    if file.type.match(/^image/)
      this.setState
        mediaDestroy: undefined
        mediaImageAttachmentCacheURL: event.target.result
        mediaImageAttachmentContentType: file.type
        mediaImageAttachmentFileName: file.name
        mediaImageAttachmentFileSize: file.size
        mediaImageAttachmentJumboURL: undefined
        mediaImageAttachmentJumboFixedURL: undefined
        mediaImageAttachmentLargeURL: undefined
        mediaImageAttachmentLargeFixedURL: undefined
        mediaImageAttachmentMediumURL: undefined
        mediaImageAttachmentMediumFixedURL: undefined
        mediaImageAttachmentSmallURL: undefined
        mediaImageAttachmentSmallFixedURL: undefined
        mediaImageAttachmentThumbnailURL: undefined
        mediaImageAttachmentURL: event.target.result
        mediaImageID: undefined
        mediaImageStatus: 'uploading'
        mediaImageTitle: ''
    else
      this.setState
        mediaImageStatus: if ((this.state.mediaImageAttachmentURL and this.state.mediaImageAttachmentURL.length > 0) or (this.state.mediaImageAttachmentURL and this.state.mediaImageAttachmentURL.length > 0)) then 'attached' else 'empty'
      alert 'Only PNG, JPG and GIF images are allowed.'

  mediaUploadProgress: (event, data) ->
    if this.state.mediaImageStatus is 'uploading'
      this.setState
        mediaImageProgress: parseInt(data.loaded / data.total * 100, 10)

  mediaUploadDone: (event, data) ->
    if this.state.mediaImageStatus is 'uploading'
      this.setState
        mediaImageAttachmentCacheURL: "//#{this.props.presignedPost.host}/#{$(data.jqXHR.responseXML).find('Key').text()}"
        mediaImageStatus: 'finishing'
      setTimeout this.mediaUploadFinish, 500

  mediaUploadFinish: ->
    $('#media_modal').fileupload('destroy')
    attributes =
      mediaImageProgress: 0
      mediaImageStatus: 'attached',
    this.setState attributes, this.initializeFileUpload

  mediaUploadFail: (event, data) ->
    if this.state.mediaImageStatus is 'uploading'
      this.setState
        mediaImageStatus: 'failed'

  updateMedia: () ->
    placement_type = if $('#media_type').val() is 'image' then 'block_image_placement' else 'block_background_placement'
    changes =
      "#{placement_type}":
        id: this.state.mediaID
        destroy: this.state.mediaDestroy
        embed: $('#media_embed').val()
        full_width: $('#media_full_width').is(':checked')
        kind: if $('#media_tab_image').is(':visible') then 'images' else 'embeds'
        image_alt: $('#media_image_alt').val()
        image_attachment_cache_url: this.state.mediaImageAttachmentCacheURL
        image_attachment_content_type: this.state.mediaImageAttachmentContentType
        image_attachment_file_name: this.state.mediaImageAttachmentFileName
        image_attachment_file_size: this.state.mediaImageAttachmentFileSize
        image_attachment_url: this.state.mediaImageAttachmentURL
        image_attachment_thumbnail_url: this.state.mediaImageAttachmentURL
        image_attachment_small_url: this.state.mediaImageAttachmentSmallURL
        image_attachment_small_fixed_url: this.state.mediaImageAttachmentSmallFixedURL
        image_attachment_medium_url: this.state.mediaImageAttachmentMediumURL
        image_attachment_medium_fixed_url: this.state.mediaImageAttachmentMediumFixedURL
        image_attachment_large_url: this.state.mediaImageAttachmentLargeURL
        image_attachment_large_fixed_url: this.state.mediaImageAttachmentLargeFixedURL
        image_attachment_jumbo_url: this.state.mediaImageAttachmentJumboURL
        image_attachment_jumbo_fixed_url: this.state.mediaImageAttachmentJumboFixedURL
        image_id: this.state.mediaImageID
        image_title: $('#media_image_title').val()
    this.updateBlock $('#media_group_uuid').val(), $('#media_block_uuid').val(), changes

  removeMediaImage: ->
    this.setState
      mediaDestroy: '1'
      mediaImageAttachmentCacheURL: undefined
      mediaImageAttachmentContentType: undefined
      mediaImageAttachmentFileName: undefined
      mediaImageAttachmentFileSize: undefined
      mediaImageAttachmentURL: undefined
      mediaImageID: undefined
      mediaImageStatus: 'empty'
      mediaImageTitle: undefined

  showMediaLibrary: ->
    $('#media_tabs').css('display', 'none')
    $('#media_library').css('display', 'block')
    this.loadMediaLibraryImages()

  loadMediaLibraryImages: ->
    $.get "#{this.props.imagesPath}?page=#{this.state.mediaLibraryPage}&local=#{this.state.mediaLibraryLocalOnly}", this.setMediaLibraryImages

  setMediaLibraryImages: (data) ->
    this.setState
      mediaLibraryImages: this.state.mediaLibraryImages.concat data.images
      mediaLibraryLoaded: true
      mediaLibraryLoadedAll: data.images.length < 48
      mediaLibraryPage: this.state.mediaLibraryPage + 1

  selectMediaLibraryImage: (image) ->
    changes =
      mediaImageAttachmentCacheURL: undefined
      mediaImageAttachmentContentType: image.attachment_content_type
      mediaImageAttachmentFileName: image.attachment_file_name
      mediaImageAttachmentFileSize: image.attachment_file_size
      mediaImageAttachmentURL: image.attachment_url
      mediaImageAttachmentThumbnailURL: image.attachment_thumbnail_url
      mediaImageAttachmentSmallURL: image.attachment_small_url
      mediaImageAttachmentSmallFixedURL: image.attachment_small_fixed_url
      mediaImageAttachmentMediumURL: image.attachment_medium_url
      mediaImageAttachmentMediumFixedURL: image.attachment_medium_fixed_url
      mediaImageAttachmentLargeURL: image.attachment_large_url
      mediaImageAttachmentLargeFixedURL: image.attachment_large_fixed_url
      mediaImageAttachmentJumboURL: image.attachment_jumbo_url
      mediaImageAttachmentJumboFixedURL: image.attachment_jumbo_fixed_url
      mediaImageID: image.id
      mediaImageStatus: 'attached'
    this.setState changes, this.hideMediaLibrary, ->
      $('#media_image_alt').val image.alt
      $('#media_image_title').val image.title

  toggleMediaLibraryLocalOnly: ->
    changes =
      mediaLibraryImages: []
      mediaLibraryLoaded: false
      mediaLibraryLoadedAll: false
      mediaLibraryLocalOnly: !this.state.mediaLibraryLocalOnly
      mediaLibraryPage: 1
    this.setState changes, this.loadMediaLibraryImages

  hideMediaLibrary: (event) ->
    event.preventDefault() if event
    $('#media_tabs').css('display', 'block')
    $('#media_library').css('display', 'none')

  resetMedia: ->
    stateChanges =
      mediaDestroy: undefined
      mediaImageAttachmentContentType: undefined
      mediaImageAttachmentFileName: undefined
      mediaImageAttachmentFileSize: undefined
      mediaImageAttachmentURL: undefined
      mediaImageProgress: 0
      mediaImageStatus: 'empty'
      mediaImageTitle: undefined
      mediaKind: 'images'
      mediaLibraryImages: []
      mediaLibraryLoaded: false
      mediaLibraryLoadedAll: false
      mediaLibraryPage: 1
    this.setState stateChanges, ->
      $('#media_embed').val ''
      $('#media_full_width').prop('checked', false)
      $('#media_image_alt').val ''
      $('#media_image_title').val ''
      $('a[href="#media_tab_image"]').tab('show')
      $('#media_tabs').css('display', 'block')
      $('#media_library').css('display', 'none')

  editCustomGroup: (group_uuid, event) ->
    event.preventDefault()
    group = this.state.groups[group_uuid]
    $('#custom_group_uuid').val group_uuid
    $('#custom_group_custom_class').val group.custom_class
    if group.type is 'HeroGroup'
      $('#custom_group_height_fields').show()
      $('#custom_group_height').val if parseInt(group.height) > 0 then parseInt(group.height) else ''
      $('#hero_position_fields').show()
      $('#hero_position').val if ['below', 'behind'].indexOf(group.hero_position) > 0 then group.hero_position else 'below'
    else
      $('#custom_group_height_fields').hide()
      $('#custom_group_height').val('')
      $('#hero_position_fields').hide()
    $('#custom_group_modal').modal('show')

  updateCustomGroup: ->
    group = this.state.groups[$('#custom_group_uuid').val()]
    if group.type is 'HeroGroup'
      this.updateGroup $('#custom_group_uuid').val(),
        custom_class: $('#custom_group_custom_class').val()
        height: $('#custom_group_height').val()
        hero_position: $('#hero_position').val()
    else
      this.updateGroup $('#custom_group_uuid').val(),
        custom_class: $('#custom_group_custom_class').val()
        height: undefined

  resetCustomGroup: ->
    $('#custom_group_uuid').val ''
    $('#custom_group_custom_class').val ''
    $('#custom_group_height').val ''
    $('#hero_position').val 'below' 

  editLink: (group_uuid, block_uuid, event) ->
    event.preventDefault()
    group = this.state.groups[group_uuid]
    block = group.blocks[block_uuid]
    $('#link_group_uuid').val group_uuid
    $('#link_block_uuid').val block_uuid
    $('#link_id').val block.link_id
    $('#link_external_url').val if block.link_external_url and block.link_external_url.length > 0 then block.link_external_url else 'http://'
    $('#link_label').val if block.link_label and block.link_label.length > 0 then block.link_label else 'Learn More'
    $('#link_no_follow').prop 'checked', if block.link_no_follow then true else false
    $('#link_target_blank').prop 'checked', if block.link_target_blank then true else false
    $('#link_version_none').prop 'checked', if ['link_internal', 'link_external'].indexOf(block.link_version) >= 0 then false else true
    $('#link_version_internal').prop 'checked', block.link_version is 'link_internal'
    $('#link_version_external').prop 'checked', block.link_version is 'link_external'
    this.toggleLinkOptions()
    $('#link_modal').modal('show')

  updateLink: (group_uuid, block_uuid) ->
    this.updateBlock $('#link_group_uuid').val(), $('#link_block_uuid').val(),
      link_external_url: $('#link_external_url').val()
      link_id: $('#link_id').val()
      link_label: $('#link_label').val()
      link_no_follow: $('#link_no_follow').prop('checked')
      link_target_blank: $('#link_target_blank').prop('checked')
      link_version: $('input[name="link_version"]:checked').val()
    this.resetLink()

  resetLink: ->
    $('#link_group_uuid').val ''
    $('#link_block_uuid').val ''
    $('#link_id').val ''
    $('#link_external_url').val 'http://'
    $('#link_label').val 'Learn More'
    $('#link_no_follow').prop 'checked', false
    $('#link_target_blank').prop 'checked', false
    $('#link_version_none').prop 'checked', true
    this.toggleLinkOptions()

  toggleLinkOptions: ->
    if $('#link_version_internal').prop('checked')
      $('#link_inputs_default').show()
      $('#link_inputs_internal').show()
      $('#link_inputs_external').hide()
    else if $('#link_version_external').prop('checked')
      $('#link_inputs_default').show()
      $('#link_inputs_internal').hide()
      $('#link_inputs_external').show()
    else
      $('#link_inputs_default').hide()
      $('#link_inputs_internal').hide()
      $('#link_inputs_external').hide()

  editHeroSettings: (group_uuid, block_uuid, event) ->
    event.preventDefault()
    group = this.state.groups[group_uuid]
    block = group.blocks[block_uuid]
    minicolorOptions =
      control: 'wheel'
      theme: 'block'
    $('#hero_settings_background_color').minicolors $.extend(minicolorOptions, defaultValue: block.background_color or '')
    $('#hero_settings_foreground_color').minicolors $.extend(minicolorOptions, defaultValue: block.foreground_color or '')
    $('#hero_settings_group_uuid').val group_uuid
    $('#hero_settings_block_uuid').val block_uuid
    $('#hero_settings_custom_class').val block.custom_class
    $('#hero_settings_well_style').val if ['light', 'dark', 'transparent'].indexOf(block.well_style) > 0 then block.well_style else 'light'
    $('#hero_settings_modal').modal('show')

  updateHeroSettings: (group_uuid, block_uuid) ->
    this.updateBlock $('#hero_settings_group_uuid').val(), $('#hero_settings_block_uuid').val(),
      custom_class: $('#hero_settings_custom_class').val()
      background_color: $('#hero_settings_background_color').val()
      foreground_color: $('#hero_settings_foreground_color').val()
      well_style: $('#hero_settings_well_style').val()

  resetHeroSettings: ->
    $('#hero_settings_background_color').val('').minicolors('destroy')
    $('#hero_settings_foreground_color').val('').minicolors('destroy')
    $('#hero_settings_custom_class').val ''
    $('#hero_settings_well_style').val 'light'

  expandHero: (group_uuid, event) ->
    event.preventDefault()
    $(event.target).popover('hide')
    this.disableSortable()
    this.updateGroup group_uuid, kind: 'full_width', this.enableSortables

  compressHero: (group_uuid, event) ->
    event.preventDefault()
    $(event.target).popover('hide')
    this.disableSortable()
    this.updateGroup group_uuid, kind: 'container', this.enableSortables

  editTaglineSettings: (group_uuid, block_uuid, event) ->
    event.preventDefault()
    group = this.state.groups[group_uuid]
    block = group.blocks[block_uuid]
    $('#tagline_settings_group_uuid').val group_uuid
    $('#tagline_settings_block_uuid').val block_uuid
    $('#tagline_settings_custom_class').val block.custom_class
    $('#tagline_settings_well_style').val if ['light', 'dark', 'transparent'].indexOf(block.well_style) > 0 then block.well_style else 'light'
    $('#tagline_settings_modal').modal('show')

  updateTaglineSettings: (group_uuid, block_uuid) ->
    this.updateBlock $('#tagline_settings_group_uuid').val(), $('#tagline_settings_block_uuid').val(),
      custom_class: $('#tagline_settings_custom_class').val()
      well_style: $('#tagline_settings_well_style').val()

  resetTaglineSettings: ->
    $('#tagline_settings_custom_class').val ''
    $('#tagline_settings_well_style').val 'light'

  editFeedSettings: (group_uuid, block_uuid, event) ->
    event.preventDefault()
    group = this.state.groups[group_uuid]
    block = group.blocks[block_uuid]
    $('#feed_settings_group_uuid').val group_uuid
    $('#feed_settings_block_uuid').val block_uuid
    $('#feed_settings_items_limit').val if parseInt(block.items_limit) > 0 then parseInt(block.items_limit) else 4
    $('.feed_settings_content_type').prop 'checked', false
    $('#feed_settings_content_type_quick_post').prop 'checked', (block.content_types || '').indexOf('QuickPost') >= 0
    $('#feed_settings_content_type_event').prop 'checked', (block.content_types || '').indexOf('Event') >= 0
    $('#feed_settings_content_type_gallery').prop 'checked', (block.content_types || '').indexOf('Gallery') >= 0
    $('#feed_settings_content_type_before_after').prop 'checked', (block.content_types || '').indexOf('BeforeAfter') >= 0
    $('#feed_settings_content_type_offer').prop 'checked', (block.content_types || '').indexOf('Offer') >= 0
    $('#feed_settings_content_type_post').prop 'checked', (block.content_types || '').indexOf('CustomPost') >= 0
    $('.feed_settings_content_type').prop('checked', true) if $('.feed_settings_content_type:checked').length == 0
    $('#feed_settings_content_category_ids').val (block.content_category_ids || '').split(' ')
    $('#feed_settings_content_tag_ids').val (block.content_tag_ids || '').split(' ')
    $('#feed_settings_custom_class').val block.custom_class
    $('#feed_settings_link_id').val block.link_id
    $('#feed_settings_link_external_url').val if block.link_external_url and block.link_external_url.length > 0 then block.link_external_url else 'http://'
    $('#feed_settings_link_label').val if block.link_label and block.link_label.length > 0 then block.link_label else 'View More'
    $('#feed_settings_link_no_follow').prop 'checked', if block.link_no_follow then true else false
    $('#feed_settings_link_target_blank').prop 'checked', if block.link_target_blank then true else false
    $('#feed_settings_link_version_none').prop 'checked', if ['link_paginate', 'link_internal', 'link_external'].indexOf(block.link_version) >= 0 then false else true
    $('#feed_settings_link_version_paginate').prop 'checked', block.link_version is 'link_paginate'
    $('#feed_settings_link_version_internal').prop 'checked', block.link_version is 'link_internal'
    $('#feed_settings_link_version_external').prop 'checked', block.link_version is 'link_external'
    this.toggleFeedLinkOptions()
    $('#feed_settings_modal').modal('show')

  updateFeedSettings: (group_uuid, block_uuid) ->
    this.updateBlock $('#feed_settings_group_uuid').val(), $('#feed_settings_block_uuid').val(),
      content_types: _.map($('.feed_settings_content_type:checked'), (input) -> return $(input).data().type).join(' ')
      content_category_ids: ($('#feed_settings_content_category_ids').val() || []).join(' ')
      content_tag_ids: ($('#feed_settings_content_tag_ids').val() || []).join(' ')
      custom_class: $('#feed_settings_custom_class').val()
      items_limit: $('#feed_settings_items_limit').val()
      link_external_url: $('#feed_settings_link_external_url').val()
      link_id: $('#feed_settings_link_id').val()
      link_label: $('#feed_settings_link_label').val()
      link_no_follow: $('#feed_settings_link_no_follow').prop('checked')
      link_target_blank: $('#feed_settings_link_target_blank').prop('checked')
      link_version: $('input[name="link_version"]:checked').val()
    this.resetFeedSettings()

  resetFeedSettings: ->
    $('.feed_settings_content_type').prop 'checked', false
    $('#feed_settings_content_category_ids').val null
    $('#feed_settings_content_tag_ids').val null
    $('#feed_settings_custom_class').val ''
    $('#feed_settings_items_limit').val 4
    $('#feed_settings_link_id').val ''
    $('#feed_settings_link_external_url').val 'http://'
    $('#feed_settings_link_label').val 'View More'
    $('#feed_settings_link_no_follow').prop 'checked', false
    $('#feed_settings_link_target_blank').prop 'checked', false
    $('#feed_settings_link_version_none').prop 'checked', true
    this.toggleFeedLinkOptions()

  toggleFeedLinkOptions: ->
    if $('#feed_settings_link_version_internal').prop('checked')
      $('#feed_settings_link_inputs_default').show()
      $('#feed_settings_link_inputs_internal').show()
      $('#feed_settings_link_inputs_external').hide()
    else if $('#feed_settings_link_version_external').prop('checked')
      $('#feed_settings_link_inputs_default').show()
      $('#feed_settings_link_inputs_internal').hide()
      $('#feed_settings_link_inputs_external').show()
    else
      $('#feed_settings_link_inputs_default').hide()
      $('#feed_settings_link_inputs_internal').hide()
      $('#feed_settings_link_inputs_external').hide()

  editReviewsSettings: (group_uuid, block_uuid, event) ->
    event.preventDefault()
    group = this.state.groups[group_uuid]
    block = group.blocks[block_uuid]
    $('#reviews_settings_group_uuid').val group_uuid
    $('#reviews_settings_block_uuid').val block_uuid
    $('#reviews_settings_style').val if ['default', 'columns'].indexOf(block.style) > 0 then block.style else 'default'
    $('#reviews_settings_modal').modal('show')

  updateReviewsSettings: (group_uuid, block_uuid) ->
    this.updateBlock $('#reviews_settings_group_uuid').val(), $('#reviews_settings_block_uuid').val(),
      style: $('#reviews_settings_style').val()

  resetReviewsSettings: ->
    $('#reviews_settings_style').val 'default'

  editDefaultSettings: (group_uuid, block_uuid, event) ->
    event.preventDefault()
    group = this.state.groups[group_uuid]
    block = group.blocks[block_uuid]
    $('#default_settings_group_uuid').val group_uuid
    $('#default_settings_block_uuid').val block_uuid
    $('#default_settings_custom_class').val block.custom_class
    $('#default_settings_modal').modal('show')

  updateDefaultSettings: (group_uuid, block_uuid) ->
    this.updateBlock $('#default_settings_group_uuid').val(), $('#default_settings_block_uuid').val(),
      custom_class: $('#default_settings_custom_class').val()

  resetDefaultSettings: ->
    $('#default_settings_custom_class').val ''

  prevTheme: (group_uuid, block_uuid, event) ->
    event.preventDefault()
    availableThemes = this.state.groups[group_uuid].blocks[block_uuid].themes
    currentTheme = this.state.groups[group_uuid].blocks[block_uuid].theme
    currentThemeIndex = availableThemes.indexOf(currentTheme)
    theme = availableThemes[currentThemeIndex - 1] or availableThemes[-1]
    this.updateBlock group_uuid, block_uuid, theme: theme

  nextTheme: (group_uuid, block_uuid, event) ->
    event.preventDefault()
    availableThemes = this.state.groups[group_uuid].blocks[block_uuid].themes
    currentTheme = this.state.groups[group_uuid].blocks[block_uuid].theme
    currentThemeIndex = availableThemes.indexOf(currentTheme)
    theme = availableThemes[currentThemeIndex + 1] or availableThemes[0]
    this.updateBlock group_uuid, block_uuid, theme: theme

  render: ->
    `<div>
      <style dangerouslySetInnerHTML={{__html: '.webpage-block-content a { color: ' + this.props.linkColor + '; }'}} />
      <div className="webpage-fields">
        <input type="hidden" name="sidebar_position" value={this.state.sidebarPosition} />
        {this.renderRemovedGroupsInputs()}
      </div>
      <BrowserPanel browserButtonsSrc={this.props.browserButtonsSrc} toggleEditing={this.toggleEditing} editing={this.state.editing}>
        <div style={{position: 'relative', paddingTop: 1, paddingBottom: 1, backgroundColor: this.props.backgroundColor, color: this.props.foregroundColor}}>
          {this.renderFullWidthGroups()}
          <div className="webpage-wrapper">
            <div className="container">
              <div className={this.webpageContainerClassName()}>
                {this.renderContainerGroups()}
              </div>
            </div>
          </div>
        </div>
        <div className="panel-footer clearfix">
          <p className="checkbox pull-right" style={{margin: 0}}>
            <label>
              <input type="checkbox" checked={this.state.editing} onChange={this.toggleEditing} />
              Display Editing Dialogs?
            </label>
          </p>
        </div>
      </BrowserPanel>
      <div id="custom_group_modal" className="modal fade">
        <input id="custom_group_uuid" type="hidden" />
        <div className="modal-dialog">
          <div className="modal-content">
            <div className="modal-header">
              <span className="close" data-dismiss="modal">&times;</span>
              <p className="h4 modal-title">Custom Group Settings</p>
            </div>
            <div className="modal-body">
              <div className="form-group">
                <label htmlFor="custom_group_custom_class" className="control-label">
                  Set a Custom Class
                </label>
                <input type="text" id="custom_group_custom_class" className="form-control" />
              </div>
	      <div className="form-group" id="custom_group_height_fields">
		<label htmlFor="custom_group_height" className="control-label">
		  Set Fixed Hero Height in Pixels
		</label>
		<input type="text" id="custom_group_height" className="form-control" />
	      </div>
              <div className="form-group" id="hero_position_fields">
                <label htmlFor="hero_position" className="control-label">Position With Header</label>
                <div>
                  <select ref="selectpicker" id="hero_position" className="form-control" defaultValue="false">
                    <option key="below" value="below">Below Header</option>
                    <option key="behind" value="behind">Behind Header</option>
                  </select>
                </div>
              </div>
            </div>
            <div className="modal-footer">
              <span className="btn btn-default" data-dismiss="modal" onClick={this.resetCustomGroup}>Cancel</span>
              <span className="btn btn-primary" data-dismiss="modal" onClick={this.updateCustomGroup}>Save</span>
            </div>
          </div>
        </div>
      </div>
      <div id="link_modal" className="modal fade">
        <input id="link_group_uuid" type="hidden" />
        <input id="link_block_uuid" type="hidden" />
        <div className="modal-dialog">
          <div className="modal-content">
            <div className="modal-header">
              <span className="close" data-dismiss="modal">&times;</span>
              <p className="h4 modal-title">Add a Link</p>
            </div>
            <div className="modal-body">
              <div className="radio">
                <label>
                  <input id="link_version_none" type="radio" name="link_version" value="link_none" defaultChecked="true"/>
                  Don‘t include a linked button
                </label>
              </div>
              <div className="radio">
                <label>
                  <input id="link_version_internal" type="radio" name="link_version" value="link_internal" />
                  Link to an internal webpage on your site
                </label>
              </div>
              <div className="radio">
                <label>
                  <input id="link_version_external" type="radio" name="link_version" value="link_external" />
                  Link to an external webpage
                </label>
              </div>
              <div id="link_inputs_internal">
                <hr />
                <div className="form-group">
                  <label htmlFor="link_id" className="control-label">IMPACT Webpage</label>
                  <select id="link_id" className="form-control">
                    {this.renderEditLinkOptions()}
                  </select>
                </div>
              </div>
              <div id="link_inputs_external">
                <hr />
                <div className="form-group">
                  <label htmlFor="link_external_url" className="control-label">External URL</label>
                  <input id="link_external_url" type="text" className="form-control" />
                </div>
              </div>
              <div id="link_inputs_default">
                <div className="form-group">
                  <label htmlFor="link_label" className="control-label">Button Label</label>
                  <input id="link_label" type="text" className="form-control" />
                </div>
                <div className="checkbox">
                  <label>
                    <input id="link_target_blank" type="checkbox" value="1" />
                    Open link in a new window?
                  </label>
                </div>
                <div className="checkbox">
                  <label>
                    <input id="link_no_follow" type="checkbox" value="1" />
                    Add "no-follow" to the link?
                  </label>
                </div>
              </div>
            </div>
            <div className="modal-footer">
              <span className="btn btn-default" data-dismiss="modal" onClick={this.resetLink}>Cancel</span>
              <span className="btn btn-primary" data-dismiss="modal" onClick={this.updateLink}>Save</span>
            </div>
          </div>
        </div>
      </div>
      <div id="media_modal" className="modal fade">
        <input id="media_type" type="hidden" />
        <input id="media_group_uuid" type="hidden" />
        <input id="media_block_uuid" type="hidden" />
        <div className="modal-dialog">
          <div className="modal-content">
            <div className="modal-header">
              <span className="close" data-dismiss="modal">&times;</span>
              <p className="h4 modal-title">{this.mediaModalTitle()}</p>
            </div>
            <div className="modal-body">
              <div id="media_tabs">
                <ul className="nav nav-tabs">
                  <li clasName="active"><a href="#media_tab_image" data-toggle="tab">Image</a></li>
                  <li><a href="#media_tab_embed" data-toggle="tab">Embed</a></li>
                </ul>
                <div className="tab-content">
                  <div id="media_tab_image" className="tab-pane fade in active">
                    <div className="form-group">
                      <div className="row">
                        <div className="col-sm-4">
                          {this.renderEditMediaThumbnail()}
                        </div>
                        <div className="col-sm-8">
                          {this.renderEditMediaProgress()}
                          {this.renderEditMediaInputs()}
                          {this.renderEditMediaButtons()}
                        </div>
                      </div>
                    </div>
                  </div>
                  <div id="media_tab_embed" className="tab-pane">
                    <div className="form-group">
                      <textarea id="media_embed" rows="6" className="form-control" />
                    </div>
                  </div>
                </div>
              </div>
              <div id="media_library">
                {this.renderMediaLibraryOnlyLocalCheckbox()}
                <ol className="breadcrumb">
                  <li><a onClick={this.hideMediaLibrary} href="#">Edit Details</a></li>
                  <li className="active">Media Library</li>
                </ol>
                {this.renderMediaLibraryInterior()}
              </div>
            </div>
            <div className="modal-footer">
              <span className="btn btn-default" data-dismiss="modal" onClick={this.resetMedia}>Cancel</span>
              {this.renderMediaLibrarySaveButton()}
            </div>
          </div>
        </div>
      </div>
      <div id="hero_settings_modal" className="modal fade">
        <input id="hero_settings_group_uuid" type="hidden" />
        <input id="hero_settings_block_uuid" type="hidden" />
        <div className="modal-dialog">
          <div className="modal-content">
            <div className="modal-header">
              <span className="close" data-dismiss="modal">&times;</span>
              <p className="h4 modal-title">Change Hero Layout and Settings</p>
            </div>
            <div className="modal-body">
              <div className="form-group">
                <label htmlFor="hero_settings_well_style" className="control-label">Background Shade</label>
                <div>
                  <select ref="selectpicker" id="hero_settings_well_style" className="form-control" defaultValue="light">
                    <option key="light" value="light">Light</option>
                    <option key="dark" value="dark">Dark</option>
                    <option key="transparent" value="transparent">Transparent</option>
                  </select>
                </div>
              </div>
              <input id="hero_settings_fake_to_receive_focus" type="text" className="hide" />
              <div className="form-group">
                <label htmlFor="hero_settings_background_color" className="control-label">Custom Background Color</label>
                <input id="hero_settings_background_color" type="text" className="form-control" />
              </div>
              <div className="form-group">
                <label htmlFor="hero_settings_foreground_color" className="control-label">Custom Font Color</label>
                <input id="hero_settings_foreground_color" type="text" className="form-control" />
              </div>
              <hr />
              <p className="text-muted small">ADVANCED</p>
              <div className="form-group">
                <label htmlFor="hero_settings_custom_class" className="control-label">
                  Set a Custom Class
                </label>
                <input type="text" id="hero_settings_custom_class" className="form-control" />
              </div>
            </div>
            <div className="modal-footer">
              <span className="btn btn-default" data-dismiss="modal" onClick={this.resetHeroSettings}>Cancel</span>
              <span className="btn btn-primary" data-dismiss="modal" onClick={this.updateHeroSettings}>Save</span>
            </div>
          </div>
        </div>
      </div>
      <div id="tagline_settings_modal" className="modal fade">
        <input id="tagline_settings_group_uuid" type="hidden" />
        <input id="tagline_settings_block_uuid" type="hidden" />
        <div className="modal-dialog">
          <div className="modal-content">
            <div className="modal-header">
              <span className="close" data-dismiss="modal">&times;</span>
              <p className="h4 modal-title">Change Tagline Layout and Settings</p>
            </div>
            <div className="modal-body">
              <div className="form-group">
                <label htmlFor="tagline_settings_well_style" className="control-label">Background Shade</label>
                <div>
                  <select ref="selectpicker" id="tagline_settings_well_style" className="form-control" defaultValue="light">
                    <option key="light" value="light">Light</option>
                    <option key="dark" value="dark">Dark</option>
                    <option key="transparent" value="transparent">Transparent</option>
                  </select>
                </div>
              </div>
              <hr />
              <div className="form-group">
                <label htmlFor="tagline_settings_custom_class" className="control-label">
                  Set a Custom Class (Advanced)
                </label>
                <input type="text" id="tagline_settings_custom_class" className="form-control" />
              </div>
            </div>
            <div className="modal-footer">
              <span className="btn btn-default" data-dismiss="modal" onClick={this.resetTaglineSettings}>Cancel</span>
              <span className="btn btn-primary" data-dismiss="modal" onClick={this.updateTaglineSettings}>Save</span>
            </div>
          </div>
        </div>
      </div>
      <div id="feed_settings_modal" className="modal fade">
        <input id="feed_settings_group_uuid" type="hidden" />
        <input id="feed_settings_block_uuid" type="hidden" />
        <div className="modal-dialog">
          <div className="modal-content">
            <div className="modal-header">
              <span className="close" data-dismiss="modal">&times;</span>
              <p className="h4 modal-title">Change Feed Settings</p>
            </div>
            <div className="modal-body">
              <div className="form-group">
                <label htmlFor="feed_settings_items_limit" className="control-label">
                  Maximum Number of Feed Items to Display
                </label>
                <input type="number" id="feed_settings_items_limit" className="form-control" step="1" />
              </div>
              <div className="radio">
                <label>
                  <input id="feed_settings_link_version_none" type="radio" name="link_version" value="link_none" defaultChecked="true"/>
                  Don‘t include a linked button
                </label>
              </div>
              <div className="radio">
                <label>
                  <input id="feed_settings_link_version_paginate" type="radio" name="link_version" value="link_paginate" defaultChecked="true"/>
                  Paginate the current page
                </label>
              </div>
              <div className="radio">
                <label>
                  <input id="feed_settings_link_version_internal" type="radio" name="link_version" value="link_internal" />
                  Link to an internal webpage on your site
                </label>
              </div>
              <div className="radio">
                <label>
                  <input id="feed_settings_link_version_external" type="radio" name="link_version" value="link_external" />
                  Link to an external webpage
                </label>
              </div>
              <div id="feed_settings_link_inputs_internal">
                <div className="form-group">
                  <label htmlFor="feed_settings_link_id" className="control-label">IMPACT Webpage</label>
                  <select id="feed_settings_link_id" className="form-control">
                    {this.renderEditLinkOptions()}
                  </select>
                </div>
              </div>
              <div id="feed_settings_link_inputs_external">
                <div className="form-group">
                  <label htmlFor="feed_settings_link_external_url" className="control-label">External URL</label>
                  <input id="feed_settings_link_external_url" type="text" className="form-control" />
                </div>
              </div>
              <div id="feed_settings_link_inputs_default">
                <div className="form-group">
                  <label htmlFor="feed_settings_link_label" className="control-label">Button Label</label>
                  <input id="feed_settings_link_label" type="text" className="form-control" />
                </div>
                <div className="checkbox">
                  <label>
                    <input id="feed_settings_link_target_blank" type="checkbox" value="1" />
                    Open link in a new window?
                  </label>
                </div>
                <div className="checkbox">
                  <label>
                    <input id="feed_settings_link_no_follow" type="checkbox" value="1" />
                    Add "no-follow" to the link?
                  </label>
                </div>
              </div>
              <p><strong>What Types of Content Do You Want to Include?</strong></p>
              <div className="row" style={{marginBottom: 5}}>
                <div className="col-xs-4">
                  <div className="checkbox" style={{margin: 0}}>
                    <label><input className="feed_settings_content_type" id="feed_settings_content_type_quick_post" type="checkbox" data-type="QuickPost" defaultChecked="true" /> Quick Posts</label>
                  </div>
                </div>
                <div className="col-xs-4">
                  <div className="checkbox" style={{margin: 0}}>
                    <label><input className="feed_settings_content_type" id="feed_settings_content_type_event" type="checkbox" data-type="Event" defaultChecked="true" /> Events</label>
                  </div>
                </div>
                <div className="col-xs-4">
                  <div className="checkbox" style={{margin: 0}}>
                    <label><input className="feed_settings_content_type" id="feed_settings_content_type_gallery" type="checkbox" data-type="Gallery" defaultChecked="true" /> Galleries</label>
                  </div>
                </div>
              </div>
              <div className="row" style={{marginTop: 5}}>
                <div className="col-xs-4">
                  <div className="checkbox" style={{margin: 0}}>
                    <label><input className="feed_settings_content_type" id="feed_settings_content_type_before_after" type="checkbox" data-type="BeforeAfter" defaultChecked="true" /> Before &amp; Afters</label>
                  </div>
                </div>
                <div className="col-xs-4">
                  <div className="checkbox" style={{margin: 0}}>
                    <label><input className="feed_settings_content_type" id="feed_settings_content_type_offer" type="checkbox" data-type="Offer" defaultChecked="true" /> Offers</label>
                  </div>
                </div>
                <div className="col-xs-4">
                  <div className="checkbox" style={{margin: 0}}>
                    <label><input className="feed_settings_content_type" id="feed_settings_content_type_post" type="checkbox" data-type="CustomPost" defaultChecked="true" /> Custom Posts</label>
                  </div>
                </div>
              </div>
              <hr />
              <div className="form-group">
                <label htmlFor="feed_settings_content_category_ids" className="control-label">
                  Only Include Content for Categories <small>Leave blank to include all</small>
                </label>
                <select type="text" id="feed_settings_content_category_ids" className="form-control" multiple>
                  {this.renderFeedSettingsCategories()}
                </select>
              </div>
              <div className="form-group">
                <label htmlFor="feed_settings_content_tag_ids" className="control-label">
                  Only Include Content for Tags <small>Leave blank to include all</small>
                </label>
                <select type="text" id="feed_settings_content_tag_ids" className="form-control" multiple>
                  {this.renderFeedSettingsTags()}
                </select>
              </div>
              <hr />
              <div className="form-group">
                <label htmlFor="feed_settings_custom_class" className="control-label">
                  Set a Custom Class (Advanced)
                </label>
                <input type="text" id="feed_settings_custom_class" className="form-control" />
              </div>
            </div>
            <div className="modal-footer">
              <span className="btn btn-default" data-dismiss="modal" onClick={this.resetFeedSettings}>Cancel</span>
              <span className="btn btn-primary" data-dismiss="modal" onClick={this.updateFeedSettings}>Save</span>
            </div>
          </div>
        </div>
      </div>
      <div id="reviews_settings_modal" className="modal fade">
        <input id="reviews_settings_group_uuid" type="hidden" />
        <input id="reviews_settings_block_uuid" type="hidden" />
        <div className="modal-dialog">
          <div className="modal-content">
            <div className="modal-header">
              <span className="close" data-dismiss="modal">&times;</span>
              <p className="h4 modal-title">Change Reviews Layout and Settings</p>
            </div>
            <div className="modal-body">
              <div className="form-group">
                <label htmlFor="reviews_settings_style" className="control-label">Background Shade</label>
                <div>
                  <select ref="selectpicker" id="reviews_settings_style" className="form-control" defaultValue="default">
                    <option key="default" value="default">Default</option>
                    <option key="columns" value="columns">Columns</option>
                  </select>
                </div>
              </div>
              <hr />
            </div>
            <div className="modal-footer">
              <span className="btn btn-default" data-dismiss="modal" onClick={this.resetReviewsSettings}>Cancel</span>
              <span className="btn btn-primary" data-dismiss="modal" onClick={this.updateReviewsSettings}>Save</span>
            </div>
          </div>
        </div>
      </div>

      <div id="default_settings_modal" className="modal fade">
        <input id="default_settings_group_uuid" type="hidden" />
        <input id="default_settings_block_uuid" type="hidden" />
        <div className="modal-dialog">
          <div className="modal-content">
            <div className="modal-header">
              <span className="close" data-dismiss="modal">&times;</span>
              <p className="h4 modal-title">Change Default Settings</p>
            </div>
            <div className="modal-body">
              <div className="form-group">
                <label htmlFor="default_settings_custom_class" className="control-label">
                  Set a Custom Class (Advanced)
                </label>
                <input type="text" id="default_settings_custom_class" className="form-control" />
              </div>
            </div>
            <div className="modal-footer">
              <span className="btn btn-default" data-dismiss="modal" onClick={this.resetDefaultSettings}>Cancel</span>
              <span className="btn btn-primary" data-dismiss="modal" onClick={this.updateDefaultSettings}>Save</span>
            </div>
          </div>
        </div>
      </div>
      <div className="webpage-save">
        <div className="container">
          <p className="webpage-save-toggle-on text-right"><i className="fa fa-arrow-circle-up" /> Add Page Elements</p>
          <p className="webpage-save-toggle-off pull-right" style={{position: 'relative', zIndex: 1}}><i className="fa fa-arrow-circle-down" /> Hide Page Options</p>
          <div className="row">
            <div className="col-sm-6">
              <p id="add_main_block_label" style={{marginBottom: 5}}><strong>Add Main Block</strong> <span className="text-success">{this.state.insertMainSuccessMessage}</span></p>
              <div id="add_main_block_options">
                {this.renderInsertHeroGroup()}
                {this.renderInsertTaglineGroup()}
                {this.renderInsertCallToActionGroup()}
                {this.renderInsertContentGroup()}
                {this.renderInsertBlogFeedGroup()}
                {this.renderInsertReviewsGroup()}
                {this.renderInsertAboutGroup()}
                {this.renderInsertTeamGroup()}
                {this.renderInsertContactGroup()}
              </div>
            </div>
            <div className="col-sm-4">
              <p id="add_sidebar_block_label" style={{marginBottom: 5}}><strong>Add Sidebar Block</strong> <span className="text-success">{this.state.insertSidebarSuccessMessage}</span></p>
              <div id="add_sidebar_block_options">
                {this.renderInsertSidebarContent()}
                {this.renderInsertSidebarBlogFeed()}
                {this.renderInsertSidebarEventsFeed()}
                {this.renderInsertSidebarReviews()}
              </div>
            </div>
            <div className="col-sm-2">
              <p style={{marginTop: 5}}><button type="submit" className="btn btn-block btn-success">Save Changes</button></p>
            </div>
          </div>
        </div>
      </div>
    </div>`

  mediaModalTitle: ->
    if $('#media_type').val() is 'background'
      'Add Background Image'
    else
      'Add an Image or Video'

  renderRemovedGroupsInputs: ->
    for group in this.state.removedGroups
      destroyName = "groups_attributes[#{group.index}][_destroy]"
      idName = "groups_attributes[#{group.index}][id]"
      `<div key={group.index}>
        <input type="hidden" name={destroyName} value="1" />
        <input type="hidden" name={idName} value={group.id} />
      </div>`

  renderEditLinkOptions: ->
    sorted = this.props.internalWebpages.sort (a,b) ->
      if a.name > b.name
        return 1
      else if a.name < b.name
        return -1
      else
        return 0

    `<option key={webpage.id} value={webpage.id}>{webpage.name}</option>` for webpage in sorted


  renderEditMediaThumbnail: ->
    if this.state.mediaImageAttachmentURL
      `<div className="media_dropzone">
        <div className="small">
          <div className="thumbnail"><img style={{width: '100%'}} src={this.mediaImageAttachmentURL()} /></div>
          <div style={{overflow: 'hidden', whiteSpace: 'nowrap'}}><strong>{this.state.mediaImageAttachmentFileName}</strong></div>
          <div>{this.state.mediaImageAttachmentContentType} – {this.state.mediaImageAttachmentFileSize / 1000}KB</div>
        </div>
      </div>`
    else
      `<div className="media_dropzone">
        <ImageEmpty padding={20} dropzone={true} />
      </div>`

  mediaImageAttachmentURL: ->
    if this.state.mediaImageAttachmentThumbnailURL and this.state.mediaImageAttachmentThumbnailURL.length > 0
      this.state.mediaImageAttachmentThumbnailURL
    else
      this.state.mediaImageAttachmentURL

  renderEditMediaProgress: ->
    if this.state.mediaImageStatus is 'uploading'
      `<div>
        <div className="progress">
          <div className="progress-bar progress-bar-striped active" style={{width: this.mediaImageUploadProgressWidthCSS()}} />
        </div>
      </div>`
    else if this.state.mediaImageStatus is 'finishing'
      `<div className="progress">
        <div className="progress-bar progress-bar-success" style={{width: '100%'}} />
      </div>`
    else if this.state.mediaImageStatus is 'failed'
      `<div className="progress">
        <div className="progress-bar progress-bar-danger" style={{width: '100%'}} />
      </div>`

  renderEditMediaInputs: ->
    if ['uploading', 'finishing', 'attached'].indexOf(this.state.mediaImageStatus) >= 0
      `<div>
        <div className="form-group">
          <label htmlFor="media_image_alt" className="control-label"><code>ALT</code> HTML Attribute</label>
          <input id="media_image_alt" type="text" className="form-control" />
        </div>
        <div className="form-group">
          <label htmlFor="media_image_title" className="control-label"><code>Title</code> HTML Attribute</label>
          <input id="media_image_title" type="text" className="form-control" placeholder="Add a description of the image. Can be more than 1 sentence." />
        </div>
      </div>`

  renderEditMediaButtons: ->
    if ['empty', 'failed', 'attached'].indexOf(this.state.mediaImageStatus) >= 0
      `<div>
        <input type="file" className="hidden" ref="fileInput" />
        <span className="btn-group btn-group-sm">
          <span onClick={this.triggerFileInput} className="btn btn-default">
            <i className="fa fa-cloud-upload" /> Upload Image
          </span>
          <span onClick={this.showMediaLibrary} className="btn btn-default">
            <i className="fa fa-th" /> Browse Library
          </span>
        </span>
        {this.renderEditMediaRemoveButton()}
        <hr />
        {this.renderEditMediaUpscaleCheckbox()}
        <hr />
        <p className="small" style={{marginTop: 10}}>Have a lot of images to add? <a href={this.props.bulkUploadPath} target="_blank">Try Bulk Upload</a></p>
      </div>`

  renderEditMediaUpscaleCheckbox: ->
    unless $('#media_type').val() is 'background'
      `<p className="small checkbox" style={{marginTop: 10}}>
        <label>
          <input id="media_full_width" type="checkbox" style={{marginTop: 3}} /> Stretch smaller images to fit full width.
        </label>
      </p>`

  renderEditMediaRemoveButton: ->
    if ['failed', 'attached'].indexOf(this.state.mediaImageStatus) >= 0
      `<span onClick={this.removeMediaImage} className="btn btn-sm btn-danger pull-right">
        <i className="fa fa-close" /> Remove
      </span>`

  renderMediaLibraryOnlyLocalCheckbox: ->
    if this.props.showOnlyLocalMediaLibraryOption
      `<div className="checkbox pull-right small" style={{marginRight: 10}}>
        <label>
          <input type="checkbox" onChange={this.toggleMediaLibraryLocalOnly} defaultChecked={this.props.showOnlyLocalMediaLibraryOption} style={{marginTop: 2}} />
          Current Site Only
        </label>
      </div>`

  renderMediaLibraryInterior: ->
    if this.state.mediaLibraryLoaded
      `<div>
        <div className="row row-narrow">
          {this.renderMediaLibraryImages()}
        </div>
        {this.renderMediaLibraryMoreButton()}
      </div>`
    else
      `<div className="text-center" style={{marginTop: 50, marginBottom: 50}}>
        <i className="fa fa-spinner fa-spin fa-4x" />
      </div>`

  renderMediaLibraryImages: ->
    if this.state.mediaLibraryImages.length > 0
      for image in this.state.mediaLibraryImages
        `<div key={image.id} className="col-xs-3 col-sm-2">
          <img onClick={this.selectMediaLibraryImage.bind(null, image)} src={image.attachment_thumbnail_url} alt={image.alt} title={image.title} className="thumbnail" style={{maxWidth: '100%', cursor: 'pointer'}} />
        </div>`
    else
      `<div className="col-sm-12"><p>Looks like you don’t have any images, go ahead and upload a few.</p></div>`

  renderMediaLibraryMoreButton: ->
    unless this.state.mediaLibraryLoadedAll
      `<div className="row text-center">
        <div className="col-sm-4 col-sm-offset-4">
          <div onClick={this.loadMediaLibraryImages} className="btn btn-block btn-default">Load More</div>
        </div>
      </div>`

  renderMediaLibrarySaveButton: ->
    if ['uploading', 'finishing'].indexOf(this.state.mediaImageStatus) >= 0
      `<span className="btn btn-primary disabled" data-dismiss="modal" onClick={this.updateMedia}>Save</span>`
    else
      `<span className="btn btn-primary" data-dismiss="modal" onClick={this.updateMedia}>Save</span>`

  mediaImageUploadProgressWidthCSS: ->
    "#{this.state.mediaImageProgress}%"

  triggerFileInput: ->
    $(this.refs.fileInput.getDOMNode()).click()

  renderFullWidthGroups: ->
    _.map _.sortBy(_.filter(this.state.groups, (group) -> group and group.kind is 'full_width'), 'position'), this.renderGroup

  renderContainerGroups: ->
    _.map _.sortBy(_.filter(this.state.groups, (group) -> group and group.kind is 'container'), 'position'), this.renderGroup

  renderGroup: (group, uuid) ->
    if group
      `<Group key={group.uuid} editing={this.state.editing} updateGroup={this.updateGroup} insertBlock={this.insertBlock} editCustomGroup={this.editCustomGroup} sidebarPosition={this.state.sidebarPosition} switchSidebarPosition={this.switchSidebarPosition} contents_path={this.props.contentsPath} reviews_path={this.props.reviewsPath} {...group} />`

  renderInsertHeroGroup: ->
    unless this.props.groupTypes.indexOf('HeroGroup') is -1 or _.find(this.state.groups, (group) -> group and group.type is 'HeroGroup')
      `<span className="btn btn-sm btn-default" onClick={this.insertGroup.bind(null, 'HeroGroup', 'HeroBlock')} style={{marginRight: '0.3em', marginBottom: '0.3em'}} title="Add a page header" data-content="A Hero is a great way to highlight something - add a large background image for a great visual.">Hero</span>`

  renderInsertTaglineGroup: ->
    unless this.props.groupTypes.indexOf('TaglineGroup') is -1
      `<span className="btn btn-sm btn-default" onClick={this.insertGroup.bind(null, 'TaglineGroup', 'TaglineBlock')} style={{marginRight: '0.3em', marginBottom: '0.3em'}} title="Add a simple text row" data-content="Great for adding a tagline or call-to-action with optional linkable button.">Simple Text</span>`

  renderInsertCallToActionGroup: ->
    unless this.props.groupTypes.indexOf('CallToActionGroup') is -1
      `<span className="btn btn-sm btn-default" onClick={this.insertGroup.bind(null, 'CallToActionGroup', 'CallToActionBlock')} style={{marginRight: '0.3em', marginBottom: '0.3em'}} title="Add 2 to 4 columns" data-content="Highlight services or product lines with text, linkable buttons and images.">Columns</span>`

  renderInsertContentGroup: ->
    unless this.props.groupTypes.indexOf('ContentGroup') is -1
      `<span className="btn btn-sm btn-default" onClick={this.insertGroup.bind(null, 'ContentGroup', 'ContentBlock')} style={{marginRight: '0.3em', marginBottom: '0.3em'}} title="Flexible content options" data-content="Can use a small image or embedded media, all text, or a larger image or embedded media.">Content Block</span>`

  renderInsertBlogFeedGroup: ->
    unless this.props.groupTypes.indexOf('BlogFeedGroup') is -1
      `<span className="btn btn-sm btn-default" onClick={this.insertGroup.bind(null, 'BlogFeedGroup', 'BlogFeedBlock')} style={{marginRight: '0.3em', marginBottom: '0.3em'}} title="Add a content feed" data-content="Keep your site fresh with a large content feed (content posted separately).">Content Feed</span>`

  renderInsertReviewsGroup: ->
    unless this.props.groupTypes.indexOf('ReviewsGroup') is -1 or _.find(this.state.groups, (group) -> group and group.type is 'ReviewsGroup')
      `<span className="btn btn-sm btn-default" onClick={this.insertGroup.bind(null, 'ReviewsGroup', 'ReviewsBlock')} style={{marginRight: '0.3em', marginBottom: '0.3em'}} title="Add a reviews widget" data-content="Keep your site fresh with a rotating reviews widget (content posted separately).">Reviews</span>`

  renderInsertAboutGroup: ->
    unless this.props.groupTypes.indexOf('AboutGroup') is -1 or _.find(this.state.groups, (group) -> group and group.type is 'AboutGroup')
      `<span className="btn btn-sm btn-default" onClick={this.insertGroup.bind(null, 'AboutGroup', 'AboutBlock')} style={{marginRight: '0.3em', marginBottom: '0.3em'}}>About Content</span>`

  renderInsertTeamGroup: ->
    unless this.props.groupTypes.indexOf('TeamGroup') is -1 or _.find(this.state.groups, (group) -> group and group.type is 'TeamGroup')
      `<span className="btn btn-sm btn-default" onClick={this.insertGroup.bind(null, 'TeamGroup', 'TeamBlock')} style={{marginRight: '0.3em', marginBottom: '0.3em'}}>Team Members</span>`

  renderInsertContactGroup: ->
    unless this.props.groupTypes.indexOf('ContactGroup') is -1 or _.find(this.state.groups, (group) -> group and group.type is 'ContactGroup')
      `<span className="btn btn-sm btn-default" onClick={this.insertGroup.bind(null, 'ContactGroup', 'ContactBlock')} style={{marginRight: '0.3em', marginBottom: '0.3em'}}>Contact Information</span>`

  renderInsertSidebarContent: ->
    unless this.props.groupTypes.indexOf('SidebarContentGroup') is -1
      group = _.find(this.state.groups, (group) -> group and group.type is 'SidebarGroup')
      if group
        `<span className="btn btn-sm btn-default" onClick={this.insertBlock.bind(null, group.uuid, 'SidebarContentBlock')} style={{marginRight: '0.3em', marginBottom: '0.3em'}} title="Flexible content options" data-content="Can use a small image or embedded media and text in the sidebar.">Content Block</span>`
      else
        `<span className="btn btn-sm btn-default" onClick={this.insertGroup.bind(null, 'SidebarGroup', 'SidebarContentBlock')} style={{marginRight: '0.3em', marginBottom: '0.3em'}} title="Flexible content options" data-content="Can use a small image or embedded media and text in the sidebar.">Content Block</span>`

  renderInsertSidebarBlogFeed: ->
    unless this.props.groupTypes.indexOf('SidebarBlogFeedGroup') is -1
      group = _.find(this.state.groups, (group) -> group and group.type is 'SidebarGroup')
      if group
        `<span className="btn btn-sm btn-default" onClick={this.insertBlock.bind(null, group.uuid, 'SidebarBlogFeedBlock')} style={{marginRight: '0.3em', marginBottom: '0.3em'}} title="Add a smaller feed of content" data-content="Keep your site fresh with a small content feed (content posted separately).">Content Feed</span>`
      else
        `<span className="btn btn-sm btn-default" onClick={this.insertGroup.bind(null, 'SidebarGroup', 'SidebarBlogFeedBlock')} style={{marginRight: '0.3em', marginBottom: '0.3em'}} title="Add a smaller feed of content" data-content="Keep your site fresh with a small content feed (content posted separately).">Content Feed</span>`

  renderInsertSidebarEventsFeed: ->
    unless this.props.groupTypes.indexOf('SidebarEventsFeedGroup') is -1
      group = _.find(this.state.groups, (group) -> group and group.type is 'SidebarGroup')
      if group and not _.find(group.blocks, (block) -> block and block.type is 'SidebarEventsFeedBlock')
        `<span className="btn btn-sm btn-default" onClick={this.insertBlock.bind(null, group.uuid, 'SidebarEventsFeedBlock')} style={{marginRight: '0.3em', marginBottom: '0.3em'}} title="Add an event-specific feed" data-content="Highlight upcoming events automatically showing nearest events first (content posted separately).">Event Feed</span>`
      else if not group
        `<span className="btn btn-sm btn-default" onClick={this.insertGroup.bind(null, 'SidebarGroup', 'SidebarEventsFeedBlock')} style={{marginRight: '0.3em', marginBottom: '0.3em'}} title="Add an event-specific feed" data-content="Highlight upcoming events automatically showing nearest events first (content posted separately).">Event Feed</span>`

  renderInsertSidebarReviews: ->
    unless this.props.groupTypes.indexOf('SidebarReviewsGroup') is -1
      group = _.find(this.state.groups, (group) -> group and group.type is 'SidebarGroup')
      if group and not _.find(group.blocks, (block) -> block and block.type is 'SidebarReviewsBlock')
        `<span className="btn btn-sm btn-default" onClick={this.insertBlock.bind(null, group.uuid, 'SidebarReviewsBlock')} style={{marginRight: '0.3em', marginBottom: '0.3em'}} title="Add a reviews widget" data-content="Keep your site fresh with a rotating reviews widget (content posted separately).">Reviews</span>`
      else if not group
        `<span className="btn btn-sm btn-default" onClick={this.insertGroup.bind(null, 'SidebarGroup', 'SidebarReviewsBlock')} style={{marginRight: '0.3em', marginBottom: '0.3em'}} title="Add a reviews widget" data-content="Keep your site fresh with a rotating reviews widget (content posted separately).">Reviews</span>`

  renderFeedSettingsCategories: ->
    for category in this.props.contentCategories
      `<option value={category.id}>{category.name}</option>`

  renderFeedSettingsTags: ->
    for tag in this.props.contentTags
      `<option value={tag.id}>{tag.name}</option>`

  switchSidebarPosition: ->
    if this.state.sidebarPosition is 'right'
      this.setState sidebarPosition: 'left'
    else
      this.setState sidebarPosition: 'right'

  webpageContainerClassName: ->
    if this.props.wrapContainer is 'true'
      'webpage-container webpage-container-wrapper'
    else
      'webpage-container'

window.Webpage = Webpage
