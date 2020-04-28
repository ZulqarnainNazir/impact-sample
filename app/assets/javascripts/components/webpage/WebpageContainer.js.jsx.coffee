# // import React, { PropTypes } from 'react';

WebpageContainer = React.createClass
  getInitialState: () ->
    return {
      directoryWidgets: this.props.directoryWidgets,
      mercantileEmbeds: this.props.mercantileEmbeds,
      mercantileEnabled: this.props.mercantileEnabled,
      calendarWidgets: this.props.calendarWidgets,
      contactForms: this.props.contactForms,
      companyLists: this.props.companyLists,
      teamMembers: this.props.teamMembers,
      location: this.props.location,
      openings: this.props.openings,
      presignedPost: this.props.presignedPost,
      backgroundColor: this.props.backgroundColor,
      foregroundColor: this.props.foregroundColor,
      linkColor: this.props.linkColor,
      sidebarPosition: if this.props.sidebarPosition == 'left' then 'left' else 'right',
      wrapContainer: this.props.wrapContainer,

      showOnlyLocalMediaLibraryOption: this.props.showOnlyLocalMediaLibraryOption,
      hasMultipleBusinesses: this.props.hasMultipleBusinesses,

      browserButtonsSrc: this.props.browserButtonsSrc,
      bulkUploadPath: this.props.bulkUploadPath,
      contentsPath: this.props.contentsPath,
      contactFormsPath: this.props.contactFormsPath,
      companyListsPath: this.props.companyListsPath,
      directoryWidgetsPath: this.props.directoryWidgetsPath,
      calendarWidgetsPath: this.props.calendarWidgetsPath,
      imagesPath: this.props.imagesPath,
      reviewsPath: this.props.reviewsPath,
      newSupportLocalPath: this.props.newSupportLocalPath,
      newMercantilePath: this.props.newMercantilePath,
      newCalendarPath: this.props.newCalendarPath,
      newContactFormPath: this.props.newContactFormPath,

      contentFeedWidgets: this.props.contentFeedWidgets,
      contentFeedWidgetsCategories: this.props.contentFeedWidgetsCategories,
      contentFeedWidgetsTags: this.props.contentFeedWidgetsTags,
      contentFeedWidgetsPath: this.props.contentFeedWidgetsPath,
      newContentFeedWidgetsPath: this.props.newContentFeedWidgetsPath,

      contentCategories: this.props.contentCategories,
      contentTags: this.props.contentTags,
      groupTypes: this.props.groupTypes,
      internalWebpages: this.props.internalWebpages,
      groups: this.generateGroups(),

      editing: true,
      removedGroups: [],

      mediaImageProgress: 0,
      mediaImageStatus: 'empty',
      mediaKind: 'images',
      mediaLibraryHasMoreImages: true,
      mediaLibraryImages: [],
      localImages: [],
      mediaLibraryLoaded: false,
      mediaLibraryLoadedAll: false,
      mediaLibraryLocalOnly: true,
      mediaLibraryPage: 1,
    }

    # this.updateBlock = this.updateBlock.bind(this);
    # this.updateGroup = this.updateGroup.bind(this);
    # this.toggleEditing = this.toggleEditing.bind(this);
    #
    # this.editMedia = this.editMedia.bind(this);
    # this.resetMedia = this.resetMedia.bind(this);
    # this.updateMedia = this.updateMedia.bind(this);
    # this.loadMediaLibraryImages = this.loadMediaLibraryImages.bind(this);
    # this.selectMediaLibraryImage = this.selectMediaLibraryImage.bind(this);
    #
    # this.editLink = this.editLink.bind(this);
    # this.updateLink = this.updateLink.bind(this);
    #
    # this.updateHeroSettings = this.updateHeroSettings.bind(this);

  generateGroups: () ->
    groups = {}
    _.filter(this.props.groups, (group) -> group != undefined).forEach (group) ->
      blocks = {}
      if group.blocks && group.blocks.length > 0
        console.log group.blocks
        _.filter(group.blocks, (block) -> block != undefined).forEach (block) ->
          blocks[block.id] = block
          blocks[block.id].uuid = block.id
        groups[group.id] = group
        groups[group.id].blocks = blocks
        groups[group.id].maxBlocks = group.max_blocks
        groups[group.id].uuid = group.id
        groups[group.id].removedBlocks = []
        if group.type == 'HeroGroup' and Object.keys(group.blocks).length > 0
          firstBlock = _.min(_.filter(group.blocks, (block) -> block != undefined), (block) -> block.position)
          groups[group.id].currentBlock = parseInt(if firstBlock != undefined then firstBlock.id)
    groups

  componentDidMount: () ->
    # console.log this.props.groups
    $('#link_modal').on 'change', 'input[type="radio"]', linkHelpers.toggleLinkOptions
    $('.webpage-save-toggle-on').on 'click', ->
      $('.webpage-save').addClass 'webpage-save-visible'
      $('.webpage-save-toggle-on').hide()
      $('.webpage-save-toggle-off').show()
      return
    $('.webpage-save-toggle-off').hide().on 'click', ->
      $('.webpage-save').removeClass 'webpage-save-visible'
      $('.webpage-save-toggle-off').hide()
      $('.webpage-save-toggle-on').show()
      return
    sortHelpers.enableSortables this
    linkHelpers.resetLink()
    linkHelpers.toggleLinkOptions()
    mediaHelpers.resetMedia this
    $('.webpage-save span.btn-default').popover
      container: 'body'
      placement: 'top'
      trigger: 'hover'
      delay:
        show: 500
        hide: 0
    if this.props.newPage
      this.insertDefaultGroups()

  insertDefaultGroups: () ->
    switch this.props.newPage
      when 'CustomPage'
        this.insertGroup('HeroGroup', 'HeroBlock', this.insertGroup.bind(null, 'CallToActionGroup', 'CallToActionBlock', this.insertGroup.bind(null, 'ContentGroup', 'ContentBlock')))

  componentDidUpdate: () ->
    if $('#add_main_block_options > *').length == 0
      $('#add_main_block_label').hide()
    else
      $('#add_main_block_label').show()
    if $('#add_sidebar_block_options > *').length == 0
      $('#add_sidebar_block_label').hide()
    else
      $('#add_sidebar_block_label').show()

  updateGroup: (groupId, attrs, callback) ->
    # console.log 'updating group with:', groupId, attrs
    group = @state.groups[groupId]
    blockCount = _.size(group.blocks)
    blocks = {}
    if attrs.maxBlocks and blockCount < attrs.maxBlocks
      i = 0
      while i < attrs.maxBlocks - blockCount
        uuid = Math.floor(Math.random() * 10 ** 10)
        blocks[uuid] =
          uuid: uuid
          type: 'CallToActionBlock'
          position: blockCount + i
        i++
      attrs.blocks = blocks
    @setState({ groups: _.merge({}, @state.groups, { "#{groupId}": attrs }) }, if _.isFunction(callback) then callback else undefined)

  updateBlock: (groupId, blockId, attrs, callback) ->
    # console.log 'updatingblock:', blockId, attrs
    @setState({ groups: _.merge({}, @state.groups, { "#{groupId}": { blocks: { "#{blockId}": attrs }}}) }, if _.isFunction(callback) then callback else undefined)

  insertGroup: (group_type, block_type, callback) ->
    # console.log 'inserting group', group_type, block_type
    sortHelpers.disableSortable()
    $('.webpage-save span.btn-default').popover('hide')
    group_uuid = Math.floor(Math.random() * Math.pow(10, 10))
    messageKey = if /Sidebar/.exec(block_type) then 'insertSidebarSuccessMessage' else 'insertMainSuccessMessage'
    if group_type is 'CallToActionGroup'
      block_uuid_1 = Math.floor(Math.random() * Math.pow(10, 10))
      block_uuid_2 = Math.floor(Math.random() * Math.pow(10, 10))
      block_uuid_3 = Math.floor(Math.random() * Math.pow(10, 10))
      blocks =
        "#{block_uuid_1}": { uuid: block_uuid_1, type: block_type, position: 0 }
        "#{block_uuid_2}": { uuid: block_uuid_2, type: block_type, position: 1 }
        "#{block_uuid_3}": { uuid: block_uuid_3, type: block_type, position: 2 }
    else
      block_uuid = Math.floor(Math.random() * Math.pow(10, 10))
      blocks =
        "#{block_uuid}": { uuid: block_uuid, type: block_type, position: 0 }

    if group_type is 'CalendarGroup' || group_type is 'SupportLocalGroup' || group_type is 'MercantileGroup'
      message = null;
    else
      message = 'Success, block appended to page'
    changes =
      "#{messageKey}": message
      groups:
        "#{group_uuid}":
          type: group_type
          uuid: group_uuid
          kind: 'container'
          maxBlocks: if group_type is 'CallToActionGroup' then 3 else undefined
          currentBlock: if group_type is'HeroGroup' then block_uuid else undefined
          position: $('.webpage-group').length
          blocks: blocks
          removedBlocks: []
    this.setState(_.merge({}, this.state, changes), this.finishInsert.bind(null, messageKey, callback))

  insertBlock: (group_uuid, block_type) ->
    # console.log 'inserting block', group_uuid, block_type
    sortHelpers.disableSortable()
    $('.webpage-save span.btn-default').popover('hide')
    group = this.state.groups[group_uuid]
    block_uuid = Math.floor(Math.random() * Math.pow(10, 10))
    messageKey = if /Sidebar/.exec(block_type) then 'insertSidebarSuccessMessage' else 'insertMainSuccessMessage'
    changes =
      "#{messageKey}": 'Success, block appended to page.'
      groups:
        "#{group_uuid}":
          blocks:
            "#{block_uuid}":
              uuid: block_uuid
              type: block_type
              position: _.size(group.blocks)
          currentBlock: if group.type is 'HeroGroup' then block_uuid else undefined
    this.setState(_.merge({}, this.state, changes), this.finishInsert.bind(null, messageKey))

  finishInsert: (messageKey, callback) ->
    sortHelpers.enableSortables(this)
    if _.isFunction(callback)
      callback()

    if (this.state[messageKey])
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
            currentBlock:
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

  toggleEditing: ->
    @setState editing: !@state.editing

  switchSidebarPosition: ->
    if @state.sidebarPosition == 'right'
      @setState sidebarPosition: 'left'
    else
      @setState sidebarPosition: 'right'

  resetHeroSettings: ->
    heroHelpers.resetHeroSettings()

  updateHeroSettings: ->
    heroHelpers.updateHeroSettings this

  editMedia: (type, block, group) ->
    mediaHelpers.editMedia this, type, block, group

  loadMediaLibraryImages: ->
    $.get("#{this.props.imagesPath}?page=#{this.state.mediaLibraryPage}&local=#{this.state.mediaLibraryLocalOnly}", this.setMediaLibraryImages);

  setMediaLibraryImages: (data) ->
    images = _.uniqBy(data.images, 'attachment_cache_url')
    @setState {
      mediaLibraryImages: @state.localImages.concat(@state.mediaLibraryImages).concat(images)
      mediaLibraryLoaded: true
      mediaLibraryLoadedAll: data.images.length < 24
      mediaLibraryPage: @state.mediaLibraryPage + 1
    }

  selectMediaLibraryImage: (image) ->
    mediaHelpers.selectMediaLibraryImage this, image

  resetMedia: ->
    mediaHelpers.resetMedia this

  updateMedia: ->
    mediaHelpers.updateMedia this

  editLink: (groupId, block) ->
    linkHelpers.editLink groupId, block

  resetLink: ->
    linkHelpers.resetLink()

  updateLink: ->
    linkHelpers.updateLink this

  updateTaglineSettings: (event) ->
    event.preventDefault()
    taglineHelpers.updateTaglineSettings this

  updateDefaultSettings: (event) ->
    event.preventDefault()
    defaultSettingsHelpers.updateDefaultSettings this

  updateFeedSettings: (event) ->
    event.preventDefault()
    feedHelpers.updateFeedSettings this

  updateSupportLocalSettings: (event) ->
    event.preventDefault()
    supportLocalHelpers.updateSupportLocalSettings this

  updateMercantileSettings: (event) ->
    event.preventDefault()
    mercantileHelpers.updateMercantileSettings this

  updateCalendarSettings: (event) ->
    event.preventDefault()
    calendarHelpers.updateCalendarSettings this

  updateContactFormSettings: (event) ->
    event.preventDefault()
    contactFormHelpers.updateContactFormSettings this

  updateReviewsSettings: (event) ->
    event.preventDefault()
    reviewHelpers.updateReviewsSettings this

  updateCustomGroup: (event) ->
    event.preventDefault()
    groupHelpers.updateCustomGroup(this)

  removeMediaImage: (event) ->
    event.preventDefault()
    mediaHelpers.removeMediaImage(this)

  showFeedContentModal: (event) ->
    event.preventDefault()
    $('#feed_content_modal').modal('show');

  toggleMediaLibraryLocalOnly: ->
    changes =
      mediaLibraryImages: []
      mediaLibraryLoaded: false
      mediaLibraryLoadedAll: false
      mediaLibraryLocalOnly: !this.state.mediaLibraryLocalOnly
      mediaLibraryPage: 1
    console.log changes, this.state
    this.setState changes, this.loadMediaLibraryImages

  render: () ->
    callbacks = {
      editMedia: this.editMedia,
      updateMedia: this.updateMedia,
      resetMedia: this.resetMedia,
      selectMediaLibraryImage: this.selectMediaLibraryImage,
      setMediaLibraryImages: this.setMediaLibraryImages,
      loadMediaLibraryImages: this.loadMediaLibraryImages,

      editLink: this.editLink,
      resetLink: this.resetLink,
      updateLink: this.updateLink,
      removeMediaImage: this.removeMediaImage,
      toggleMediaLibraryLocalOnly: this.toggleMediaLibraryLocalOnly,

      editHeroSettings: this.editHeroSettings,
      resetHeroSettings: this.resetHeroSettings,
      updateHeroSettings: this.updateHeroSettings,
      showFeedContentModal: this.showFeedContentModal,

      updateTaglineSettings: this.updateTaglineSettings,
      updateDefaultSettings: this.updateDefaultSettings,
      updateFeedSettings: this.updateFeedSettings,
      updateReviewsSettings: this.updateReviewsSettings,
      updateSupportLocalSettings: this.updateSupportLocalSettings,
      updateMercantileSettings: this.updateMercantileSettings,
      updateCalendarSettings: this.updateCalendarSettings,
      updateContactFormSettings: this.updateContactFormSettings,
      updateCustomGroup: this.updateCustomGroup,
      updateBlock: this.updateBlock,
      updateGroup: this.updateGroup,
      insertGroup: this.insertGroup,
      insertBlock: this.insertBlock,
      toggleEditing: this.toggleEditing,
      switchSidebarPosition: this.switchSidebarPosition #.bind(this),
      removeBlock: this.removeBlock
    }
    return (
      `<Webpage
        callbacks={callbacks}
        {...callbacks}
        webpageState={this.state}
        {...this.state}
      />`
    )

WebpageContainer.propTypes = {
  backgroundColor: React.PropTypes.string,
  foregroundColor: React.PropTypes.string,
  linkColor: React.PropTypes.string,
  sidebarPosition: React.PropTypes.string,
  wrapContainer: React.PropTypes.string,

  showOnlyLocalMediaLibraryOption: React.PropTypes.bool,
  hasMultipleBusinesses: React.PropTypes.bool,
  mercantileEnabled: React.PropTypes.bool,

  browserButtonsSrc: React.PropTypes.string,
  bulkUploadPath: React.PropTypes.string,
  contentsPath: React.PropTypes.string,
  contactFormsPath: React.PropTypes.string,
  companyListsPath: React.PropTypes.string,
  directoryWidgetsPath: React.PropTypes.string,
  mercantileEmbedPath: React.PropTypes.string,
  calendarWidgetsPath: React.PropTypes.string,
  imagesPath: React.PropTypes.string,
  reviewsPath: React.PropTypes.string,

  contentCategories: React.PropTypes.arrayOf(React.PropTypes.object),
  contentTags: React.PropTypes.arrayOf(React.PropTypes.object),
  groupTypes: React.PropTypes.arrayOf(React.PropTypes.string),
  internalWebpages: React.PropTypes.arrayOf(React.PropTypes.object),
  groups: React.PropTypes.arrayOf(React.PropTypes.object),
}

# // export default WebpageContainer;
window.WebpageContainer = WebpageContainer
