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
    groups

  componentDidMount: ->
    $('#link_modal').on 'change', 'input[type="radio"]', this.toggleLinkOptions
    $('.webpage-save-toggle-on').on 'click', -> $('.webpage-save').addClass('webpage-save-visible'); $('.webpage-save-toggle-on').hide(); $('.webpage-save-toggle-off').show()
    $('.webpage-save-toggle-off').hide().on 'click', -> $('.webpage-save').removeClass('webpage-save-visible'); $('.webpage-save-toggle-off').hide(); $('.webpage-save-toggle-on').show()
    this.enableSortableGroups()
    this.sortWebpageGroups()
    this.resetLink()
    this.toggleLinkOptions()
    this.resetMedia()

  componentDidUpdate: ->
    if $('#add_main_block_options > *').length is 0
      $('#add_main_block_label').hide()
    else
      $('#add_main_block_label').show()
    if $('#add_sidebar_block_options > *').length is 0
      $('#add_sidebar_block_label').hide()
    else
      $('#add_sidebar_block_label').show()

  disableSortableGroups: ->
    $('.webpage-container').sortable('destroy')

  enableSortableGroups: ->
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
      update: this.sortWebpageGroups

  startWebpageGroupsSorting: (event, ui) ->
    group = this.state.groups[ui.item.data('uuid')]
    if group and group.type is 'SidebarGroup'
      ui.placeholder.css('width', ui.item.css('width'))
      ui.placeholder.css('float', this.state.sidebarPosition)

  sortWebpageGroups: ->
    $('.webpage-group').each this.sortWebpageGroup

  sortWebpageGroup: (index, group) ->
    this.updateGroup $(group).data('uuid'), position: index

  toggleEditing: ->
    this.setState editing: !this.state.editing

  defaultBlockAttributes: (group_uuid, block_uuid, block_type, argumentAttributes) ->
    commonAttributes =
      removeBlock: this.removeBlock.bind(null, group_uuid, block_uuid)
      type: block_type
      uuid: block_uuid
    blockSpecificAttributes = switch block_type
      when 'HeroBlock'
        editText: this.editText.bind(null, group_uuid, block_uuid)
        editBackground: this.editMedia.bind(null, group_uuid, block_uuid, 'background')
        editImage: this.editMedia.bind(null, group_uuid, block_uuid, 'image')
        editLink: this.editLink.bind(null, group_uuid, block_uuid)
        editCustom: this.editHeroStyles.bind(null, group_uuid, block_uuid)
        prevTheme: this.prevTheme.bind(null, group_uuid, block_uuid)
        nextTheme: this.nextTheme.bind(null, group_uuid, block_uuid)
        compress: this.compressHero.bind(null, group_uuid)
        expand: this.expandHero.bind(null, group_uuid)
        theme: 'full'
        themes: ['full', 'right', 'left']
        well_style: 'light'
        updateHeading: this.updateHeading.bind(null, group_uuid, block_uuid)
        updateText: this.updateText.bind(null, group_uuid, block_uuid)
      when 'TaglineBlock'
        editText: this.editText.bind(null, group_uuid, block_uuid)
        editLink: this.editLink.bind(null, group_uuid, block_uuid)
        editCustom: this.editTaglineStyles.bind(null, group_uuid, block_uuid)
        prevTheme: this.prevTheme.bind(null, group_uuid, block_uuid)
        nextTheme: this.nextTheme.bind(null, group_uuid, block_uuid)
        theme: 'left'
        themes: ['left', 'center', 'right']
        well_style: 'light'
        updateText: this.updateText.bind(null, group_uuid, block_uuid)
      when 'CallToActionBlock'
        editText: this.editText.bind(null, group_uuid, block_uuid)
        editImage: this.editMedia.bind(null, group_uuid, block_uuid, 'image')
        editLink: this.editLink.bind(null, group_uuid, block_uuid)
        updateHeading: this.updateHeading.bind(null, group_uuid, block_uuid)
        updateText: this.updateText.bind(null, group_uuid, block_uuid)
      when 'SpecialtyBlock'
        editText: this.editText.bind(null, group_uuid, block_uuid)
        editImage: this.editMedia.bind(null, group_uuid, block_uuid, 'image')
        prevTheme: this.prevTheme.bind(null, group_uuid, block_uuid)
        nextTheme: this.nextTheme.bind(null, group_uuid, block_uuid)
        theme: 'left'
        themes: ['left', 'right']
        updateHeading: this.updateHeading.bind(null, group_uuid, block_uuid)
        updateText: this.updateText.bind(null, group_uuid, block_uuid)
      when 'ContentBlock'
        editText: this.editText.bind(null, group_uuid, block_uuid)
        editImage: this.editMedia.bind(null, group_uuid, block_uuid, 'image')
        prevTheme: this.prevTheme.bind(null, group_uuid, block_uuid)
        nextTheme: this.nextTheme.bind(null, group_uuid, block_uuid)
        theme: 'left'
        themes: ['left', 'right', 'text', 'image']
        updateText: this.updateText.bind(null, group_uuid, block_uuid)
      when 'BlogFeedBlock'
        {}
      when 'SidebarContentBlock'
        editText: this.editText.bind(null, group_uuid, block_uuid)
        editImage: this.editMedia.bind(null, group_uuid, block_uuid, 'image')
        editLink: this.editLink.bind(null, group_uuid, block_uuid)
        updateHeading: this.updateHeading.bind(null, group_uuid, block_uuid)
        updateText: this.updateText.bind(null, group_uuid, block_uuid)
      when 'SidebarBlogFeedBlock'
        {}
      when 'SidebarEventsFeedBlock'
        {}
      when 'AboutBlock'
        editText: this.editText.bind(null, group_uuid, block_uuid)
        editBackground: this.editMedia.bind(null, group_uuid, block_uuid, 'background')
        editImage: this.editMedia.bind(null, group_uuid, block_uuid, 'image')
        prevTheme: this.prevTheme.bind(null, group_uuid, block_uuid)
        nextTheme: this.nextTheme.bind(null, group_uuid, block_uuid)
        theme: 'left'
        themes: ['banner', 'left']
        updateHeading: this.updateHeading.bind(null, group_uuid, block_uuid)
        updateSubheading: this.updateSubheading.bind(null, group_uuid, block_uuid)
        updateText: this.updateText.bind(null, group_uuid, block_uuid)
      when 'TeamBlock'
        prevTheme: this.prevTheme.bind(null, group_uuid, block_uuid)
        nextTheme: this.nextTheme.bind(null, group_uuid, block_uuid)
        teamMembers: this.props.teamMembers
        theme: 'left'
        themes: ['vertical', 'horizontal']
      when 'ContactBlock'
        editText: this.editText.bind(null, group_uuid, block_uuid)
        prevTheme: this.prevTheme.bind(null, group_uuid, block_uuid)
        nextTheme: this.nextTheme.bind(null, group_uuid, block_uuid)
        theme: 'left'
        themes: ['right', 'banner', 'inline', 'content']
        updateText: this.updateText.bind(null, group_uuid, block_uuid)
    $.extend {}, commonAttributes, blockSpecificAttributes, argumentAttributes

  insertGroup: (group_type, block_type) ->
    group_uuid = Math.floor(Math.random() * Math.pow(10, 10))
    block_uuid = Math.floor(Math.random() * Math.pow(10, 10))
    changes =
      $merge:
        "#{group_uuid}":
          type: group_type
          uuid: group_uuid
          kind: 'container'
          max_blocks: if group_type is 'CallToActionGroup' then 3 else undefined
          blocks:
            "#{block_uuid}": this.defaultBlockAttributes(group_uuid, block_uuid, block_type)
          removedBlocks: []
    this.setState groups: React.addons.update(this.state.groups, changes), this.sortWebpageGroups

  insertBlock: (group_uuid, block_type) ->
    block_uuid = Math.floor(Math.random() * Math.pow(10, 10))
    changes =
      "#{group_uuid}":
        blocks:
          $merge:
            "#{block_uuid}": this.defaultBlockAttributes(group_uuid, block_uuid, block_type)
    this.setState groups: React.addons.update(this.state.groups, changes), this.sortWebpageGroups

  removeBlock: (group_uuid, block_uuid, event) ->
    event.preventDefault()
    group = this.state.groups[group_uuid]
    if _.reject(group.blocks, (block) -> block is undefined).length > 1
      block = group.blocks[block_uuid]
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
    changes =
      "#{group_uuid}":
        $merge: attributes
    this.setState groups: React.addons.update(this.state.groups, changes), callback

  updateBlock: (group_uuid, block_uuid, attributes, callback) ->
    changes =
      "#{group_uuid}":
        blocks:
          "#{block_uuid}":
            $merge: attributes
    this.setState groups: React.addons.update(this.state.groups, changes), callback

  editText: (group_uuid, block_uuid, event) ->
    event.preventDefault()
    group = this.state.groups[group_uuid]
    block = group.blocks[block_uuid]
    this.updateBlock group_uuid, block_uuid,
      richText: if block.richText then false else true

  updateHeading: (group_uuid, block_uuid, richText) ->
    this.updateBlock group_uuid, block_uuid, heading: richText

  updateSubheading: (group_uuid, block_uuid, richText) ->
    this.updateBlock group_uuid, block_uuid, subheading: richText

  updateText: (group_uuid, block_uuid, richText) ->
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
    this.setState
      mediaDestroy: null
      mediaImageAttachmentCacheURL: event.target.result
      mediaImageAttachmentContentType: file.type
      mediaImageAttachmentFileName: file.name
      mediaImageAttachmentFileSize: file.size
      mediaImageAttachmentURL: event.target.result
      mediaImageID: null
      mediaImageStatus: 'uploading'
      mediaImageTitle: ''

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
        kind: if $('#media_tab_image').is(':visible') then 'images' else 'embeds'
        image_alt: $('#media_image_alt').val()
        image_attachment_cache_url: this.state.mediaImageAttachmentCacheURL
        image_attachment_content_type: this.state.mediaImageAttachmentContentType
        image_attachment_file_name: this.state.mediaImageAttachmentFileName
        image_attachment_file_size: this.state.mediaImageAttachmentFileSize
        image_attachment_url: this.state.mediaImageAttachmentURL
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
      $('#media_image_alt').val ''
      $('#media_image_title').val ''
      $('a[href="#media_tab_image"]').tab('show')
      $('#media_tabs').css('display', 'block')
      $('#media_library').css('display', 'none')

  editLink: (group_uuid, block_uuid, event) ->
    event.preventDefault()
    group = this.state.groups[group_uuid]
    block = group.blocks[block_uuid]
    $('#link_group_uuid').val group_uuid
    $('#link_block_uuid').val block_uuid
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

  editHeroStyles: (group_uuid, block_uuid, event) ->
    event.preventDefault()
    group = this.state.groups[group_uuid]
    block = group.blocks[block_uuid]
    $('#hero_styles_group_uuid').val group_uuid
    $('#hero_styles_block_uuid').val block_uuid
    $('#hero_styles_height').val if parseInt(block.height) > 0 then parseInt(block.height) else ''
    $('#hero_styles_well_style').val if ['light', 'dark', 'transparent'].indexOf(block.well_style) > 0 then block.well_style else 'light'
    $('#hero_styles_modal').modal('show')

  updateHeroStyles: (group_uuid, block_uuid) ->
    this.updateBlock $('#hero_styles_group_uuid').val(), $('#hero_styles_block_uuid').val(),
      height: $('#hero_styles_height').val()
      well_style: $('#hero_styles_well_style').val()

  resetHeroStyles: ->
    $('#hero_styles_height').val ''
    $('#hero_styles_well_style').val 'light'

  expandHero: (group_uuid, event) ->
    event.preventDefault()
    this.disableSortableGroups()
    this.updateGroup group_uuid, kind: 'full_width', this.enableSortableGroups

  compressHero: (group_uuid, event) ->
    event.preventDefault()
    this.disableSortableGroups()
    this.updateGroup group_uuid, kind: 'container', this.enableSortableGroups

  editTaglineStyles: (group_uuid, block_uuid, event) ->
    event.preventDefault()
    group = this.state.groups[group_uuid]
    block = group.blocks[block_uuid]
    $('#tagline_styles_group_uuid').val group_uuid
    $('#tagline_styles_block_uuid').val block_uuid
    $('#tagline_styles_well_style').val if ['light', 'dark', 'transparent'].indexOf(block.well_style) > 0 then block.well_style else 'light'
    $('#tagline_styles_modal').modal('show')

  updateTaglineStyles: (group_uuid, block_uuid) ->
    this.updateBlock $('#tagline_styles_group_uuid').val(), $('#tagline_styles_block_uuid').val(),
      well_style: $('#tagline_styles_well_style').val()

  resetTaglineStyles: ->
    $('#tagline_styles_well_style').val 'light'

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
      <style dangerouslySetInnerHTML={{__html: '.webpage-block a { color: ' + this.props.linkColor + '; }'}} />
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
              <span className="btn btn-primary" data-dismiss="modal" onClick={this.updateMedia}>Save</span>
            </div>
          </div>
        </div>
      </div>
      <div id="hero_styles_modal" className="modal fade">
        <input id="hero_styles_group_uuid" type="hidden" />
        <input id="hero_styles_block_uuid" type="hidden" />
        <div className="modal-dialog">
          <div className="modal-content">
            <div className="modal-header">
              <span className="close" data-dismiss="modal">&times;</span>
              <p className="h4 modal-title">Change Hero Layout and Style</p>
            </div>
            <div className="modal-body">
              <div className="form-group">
                <label htmlFor="hero_styles_well_style" className="control-label">Background Shade</label>
                <div>
                  <select ref="selectpicker" id="hero_styles_well_style" className="form-control" defaultValue="light">
                    <option key="light" value="light">Light</option>
                    <option key="dark" value="dark">Dark</option>
                    <option key="transparent" value="transparent">Transparent</option>
                  </select>
                </div>
              </div>
              <hr />
              <div className="form-group">
                <label htmlFor="hero_styles_height" className="control-label">
                  Set Fixed Hero Height in Pixels (Advanced)
                </label>
                <input type="text" id="hero_styles_height" className="form-control" />
              </div>
            </div>
            <div className="modal-footer">
              <span className="btn btn-default" data-dismiss="modal" onClick={this.resetHeroStyles}>Cancel</span>
              <span className="btn btn-primary" data-dismiss="modal" onClick={this.updateHeroStyles}>Save</span>
            </div>
          </div>
        </div>
      </div>
      <div id="tagline_styles_modal" className="modal fade">
        <input id="tagline_styles_group_uuid" type="hidden" />
        <input id="tagline_styles_block_uuid" type="hidden" />
        <div className="modal-dialog">
          <div className="modal-content">
            <div className="modal-header">
              <span className="close" data-dismiss="modal">&times;</span>
              <p className="h4 modal-title">Change Tagline Layout and Style</p>
            </div>
            <div className="modal-body">
              <div className="form-group">
                <label htmlFor="tagline_styles_well_style" className="control-label">Background Shade</label>
                <div>
                  <select ref="selectpicker" id="tagline_styles_well_style" className="form-control" defaultValue="light">
                    <option key="light" value="light">Light</option>
                    <option key="dark" value="dark">Dark</option>
                    <option key="transparent" value="transparent">Transparent</option>
                  </select>
                </div>
              </div>
            </div>
            <div className="modal-footer">
              <span className="btn btn-default" data-dismiss="modal" onClick={this.resetTaglineStyles}>Cancel</span>
              <span className="btn btn-primary" data-dismiss="modal" onClick={this.updateTaglineStyles}>Save</span>
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
              <p id="add_main_block_label" style={{marginBottom: 5}}><strong>Add Main Block</strong></p>
              <div id="add_main_block_options">
                {this.renderInsertHeroGroup()}
                {this.renderInsertTaglineGroup()}
                {this.renderInsertCallToActionGroup()}
                {this.renderInsertSpecialtyGroup()}
                {this.renderInsertContentGroup()}
                {this.renderInsertBlogFeedGroup()}
                {this.renderInsertAboutGroup()}
                {this.renderInsertTeamGroup()}
                {this.renderInsertContactGroup()}
              </div>
            </div>
            <div className="col-sm-4">
              <p id="add_sidebar_block_label" style={{marginBottom: 5}}><strong>Add Sidebar Block</strong></p>
              <div id="add_sidebar_block_options">
                {this.renderInsertSidebarContent()}
                {this.renderInsertSidebarBlogFeed()}
                {this.renderInsertSidebarEventsFeed()}
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
    if $('#media_type') is 'image'
      'Add an Image or Video'
    else
      'Add Background Image'

  renderRemovedGroupsInputs: ->
    for group in this.state.removedGroups
      destroyName = "groups_attributes[#{group.index}][_destroy]"
      idName = "groups_attributes[#{group.index}][id]"
      `<div key={group.index}>
        <input type="hidden" name={destroyName} value="1" />
        <input type="hidden" name={idName} value={group.id} />
      </div>`

  renderEditLinkOptions: ->
    `<option key={webpage.id} value={webpage.id}>{webpage.name}</option>` for webpage in this.props.internalWebpages

  renderEditMediaThumbnail: ->
    if this.state.mediaImageAttachmentURL
      `<div className="media_dropzone">
        <div className="small">
          <div className="thumbnail"><img style={{width: '100%'}} src={this.state.mediaImageAttachmentURL} /></div>
          <div style={{overflow: 'hidden', whiteSpace: 'nowrap'}}><strong>{this.state.mediaImageAttachmentFileName}</strong></div>
          <div>{this.state.mediaImageAttachmentContentType} – {this.state.mediaImageAttachmentFileSize / 1000}KB</div>
        </div>
      </div>`
    else
      `<div className="media_dropzone">
        <ImageEmpty padding={20} dropzone={true} />
      </div>`

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
          <label htmlFor="media_image_alt" className="control-label"><code>ALT</code> Attribute</label>
          <input id="media_image_alt" type="text" className="form-control" />
        </div>
        <div className="form-group">
          <label htmlFor="media_image_title" className="control-label"><code>Title</code> Attribute</label>
          <input id="media_image_title" type="text" className="form-control" />
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
        <p className="small" style={{marginTop: 10}}>Have a lot of images to add? <a href={this.props.bulkUploadPath} target="_blank">Try Bulk Upload</a></p>
      </div>`

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
      `<div className="row row-narrow">
        {this.renderMediaLibraryImages()}
        {this.renderMediaLibraryMoreButton()}
      </div>`
    else
      `<div className="text-center" style={{marginTop: 50, marginBottom: 50}}>
        <i className="fa fa-spinner fa-spin fa-4x" />
      </div>`

  renderMediaLibraryImages: ->
    if this.state.mediaLibraryImages.length > 0
      for image in this.state.mediaLibraryImages
        `<div key={image.id} className="col-xs-2">
          <img onClick={this.selectMediaLibraryImage.bind(null, image)} src={image.attachment_thumbnail_url} alt={image.alt} title={image.title} className="thumbnail" style={{width: 90, height: 90, cursor: 'pointer'}} />
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
      `<Group key={group.uuid} editing={this.state.editing} updateGroup={this.updateGroup} insertBlock={this.insertBlock} sidebarPosition={this.state.sidebarPosition} switchSidebarPosition={this.switchSidebarPosition} {...group} />`

  renderInsertHeroGroup: ->
    unless this.props.groupTypes.indexOf('HeroGroup') is -1 or _.find(this.state.groups, (group) -> group and group.type is 'HeroGroup')
      `<span className="btn btn-sm btn-default" onClick={this.insertGroup.bind(null, 'HeroGroup', 'HeroBlock')} style={{marginRight: '0.3em', marginBottom: '0.3em'}}>Hero</span>`

  renderInsertTaglineGroup: ->
    unless this.props.groupTypes.indexOf('TaglineGroup') is -1
      `<span className="btn btn-sm btn-default" onClick={this.insertGroup.bind(null, 'TaglineGroup', 'TaglineBlock')} style={{marginRight: '0.3em', marginBottom: '0.3em'}}>Tagline</span>`

  renderInsertCallToActionGroup: ->
    unless this.props.groupTypes.indexOf('CallToActionGroup') is -1
      `<span className="btn btn-sm btn-default" onClick={this.insertGroup.bind(null, 'CallToActionGroup', 'CallToActionBlock')} style={{marginRight: '0.3em', marginBottom: '0.3em'}}>Columns</span>`

  renderInsertSpecialtyGroup: ->
    unless this.props.groupTypes.indexOf('SpecialtyGroup') is -1
      `<span className="btn btn-sm btn-default" onClick={this.insertGroup.bind(null, 'SpecialtyGroup', 'SpecialtyBlock')} style={{marginRight: '0.3em', marginBottom: '0.3em'}}>50/50 Content</span>`

  renderInsertContentGroup: ->
    unless this.props.groupTypes.indexOf('ContentGroup') is -1
      `<span className="btn btn-sm btn-default" onClick={this.insertGroup.bind(null, 'ContentGroup', 'ContentBlock')} style={{marginRight: '0.3em', marginBottom: '0.3em'}}>Small Content</span>`

  renderInsertBlogFeedGroup: ->
    unless this.props.groupTypes.indexOf('BlogFeedGroup') is -1 or _.find(this.state.groups, (group) -> group and group.type is 'BlogFeedGroup')
      `<span className="btn btn-sm btn-default" onClick={this.insertGroup.bind(null, 'BlogFeedGroup', 'BlogFeedBlock')} style={{marginRight: '0.3em', marginBottom: '0.3em'}}>Blog Feed</span>`

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
        `<span className="btn btn-sm btn-default" onClick={this.insertBlock.bind(null, group.uuid, 'SidebarContentBlock')} style={{marginRight: '0.3em', marginBottom: '0.3em'}}>Content Block</span>`
      else
        `<span className="btn btn-sm btn-default" onClick={this.insertGroup.bind(null, 'SidebarGroup', 'SidebarContentBlock')} style={{marginRight: '0.3em', marginBottom: '0.3em'}}>Content Block</span>`

  renderInsertSidebarBlogFeed: ->
    unless this.props.groupTypes.indexOf('SidebarBlogFeedGroup') is -1
      group = _.find(this.state.groups, (group) -> group and group.type is 'SidebarGroup')
      if group and not _.find(group.blocks, (block) -> block and block.type is 'SidebarBlogFeedBlock')
        `<span className="btn btn-sm btn-default" onClick={this.insertBlock.bind(null, group.uuid, 'SidebarBlogFeedBlock')} style={{marginRight: '0.3em', marginBottom: '0.3em'}}>Blog Feed</span>`
      else if not group
        `<span className="btn btn-sm btn-default" onClick={this.insertGroup.bind(null, 'SidebarGroup', 'SidebarBlogFeedBlock')} style={{marginRight: '0.3em', marginBottom: '0.3em'}}>Blog Feed</span>`

  renderInsertSidebarEventsFeed: ->
    unless this.props.groupTypes.indexOf('SidebarEventsFeedGroup') is -1
      group = _.find(this.state.groups, (group) -> group and group.type is 'SidebarGroup')
      if group and not _.find(group.blocks, (block) -> block and block.type is 'SidebarEventsFeedBlock')
        `<span className="btn btn-sm btn-default" onClick={this.insertBlock.bind(null, group.uuid, 'SidebarEventsFeedBlock')} style={{marginRight: '0.3em', marginBottom: '0.3em'}}>Events Feed</span>`
      else if not group
        `<span className="btn btn-sm btn-default" onClick={this.insertGroup.bind(null, 'SidebarGroup', 'SidebarEventsFeedBlock')} style={{marginRight: '0.3em', marginBottom: '0.3em'}}>Events Feed</span>`

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
