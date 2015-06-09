BasicPage = React.createClass
  propTypes:
    backgroundColor: React.PropTypes.string
    browserButtonsSrc: React.PropTypes.string
    bulkUploadPath: React.PropTypes.string
    foregroundColor: React.PropTypes.string
    groups: React.PropTypes.array
    hasMultipleBusinesses: React.PropTypes.bool
    imagesPath: React.PropTypes.string
    internalWebpages: React.PropTypes.array
    linkColor: React.PropTypes.string
    presignedPost: React.PropTypes.object
    sidebarPosition: React.PropTypes.string

  getInitialState: ->
    editing: true
    groups: this.getInitialGroupsState()
    sidebarPosition: if this.props.sidebarPosition is 'left' then 'left' else 'right'
    mediaImageStatus: 'empty'
    mediaImageProgress: 0

  getInitialGroupsState: ->
    groups = {}
    for group, i in this.props.groups
      group.uuid = i
      groups[i] = group
      blocks = group.blocks
      group.blocks = {}
      for block, j in blocks
        block.uuid = j
        group.blocks[j] = this.defaultBlockAttributes i, j, block.type, block
    groups

  componentDidMount: ->
    $('#link_modal').on 'change', 'input[type="radio"]', this.toggleLinkOptions
    this.enableSortableGroups()
    this.sortWebpageGroups()
    this.resetLink()
    this.toggleLinkOptions()
    this.resetMedia()

  enableSortableGroups: ->
    $('.webpage-groups').sortable
      axis: 'y'
      container: '.webpage-groups'
      expandOnHover: 400
      forceHelperSize: true
      forcePlaceholderSize: true
      handle: '.webpage-group-handle'
      helper: 'clone'
      items: '> .webpage-group'
      opacity: 0.5
      placeholder: 'webpage-group-placeholder'
      revert: 100
      startCollapsed: false
      tabSize: 20
      tolerance: 'pointer'
      update: this.sortWebpageGroups

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
        editMedia: this.editMedia.bind(null, group_uuid, block_uuid)
        editLink: this.editLink.bind(null, group_uuid, block_uuid)
        editCustom: this.editHeroStyles.bind(null, group_uuid, block_uuid)
        prevTheme: this.prevTheme.bind(null, group_uuid, block_uuid)
        nextTheme: this.nextTheme.bind(null, group_uuid, block_uuid)
        theme: 'full'
        themes: ['full', 'right', 'well', 'well_dark', 'form', 'split_image']
        updateHeading: this.updateHeading.bind(null, group_uuid, block_uuid)
        updateText: this.updateText.bind(null, group_uuid, block_uuid)
      when 'TaglineBlock'
        editText: this.editText.bind(null, group_uuid, block_uuid)
        editLink: this.editLink.bind(null, group_uuid, block_uuid)
        prevTheme: this.prevTheme.bind(null, group_uuid, block_uuid)
        nextTheme: this.nextTheme.bind(null, group_uuid, block_uuid)
        theme: 'left'
        themes: ['left', 'center', 'contain']
        updateText: this.updateText.bind(null, group_uuid, block_uuid)
      when 'CallToActionBlock'
        editText: this.editText.bind(null, group_uuid, block_uuid)
        editMedia: this.editMedia.bind(null, group_uuid, block_uuid)
        editLink: this.editLink.bind(null, group_uuid, block_uuid)
        updateHeading: this.updateHeading.bind(null, group_uuid, block_uuid)
        updateText: this.updateText.bind(null, group_uuid, block_uuid)
      when 'SpecialtyBlock'
        editText: this.editText.bind(null, group_uuid, block_uuid)
        editMedia: this.editMedia.bind(null, group_uuid, block_uuid)
        prevTheme: this.prevTheme.bind(null, group_uuid, block_uuid)
        nextTheme: this.nextTheme.bind(null, group_uuid, block_uuid)
        theme: 'left'
        themes: ['left', 'right']
        updateHeading: this.updateHeading.bind(null, group_uuid, block_uuid)
        updateText: this.updateText.bind(null, group_uuid, block_uuid)
      when 'ContentBlock'
        editText: this.editText.bind(null, group_uuid, block_uuid)
        editMedia: this.editMedia.bind(null, group_uuid, block_uuid)
        prevTheme: this.prevTheme.bind(null, group_uuid, block_uuid)
        nextTheme: this.nextTheme.bind(null, group_uuid, block_uuid)
        theme: 'left'
        themes: ['left', 'right', 'full', 'full_image']
        updateText: this.updateText.bind(null, group_uuid, block_uuid)
      when 'BlogFeedBlock'
        {}
      when 'SidebarContentBlock'
        editText: this.editText.bind(null, group_uuid, block_uuid)
        editMedia: this.editMedia.bind(null, group_uuid, block_uuid)
        editLink: this.editLink.bind(null, group_uuid, block_uuid)
        updateHeading: this.updateHeading.bind(null, group_uuid, block_uuid)
        updateText: this.updateText.bind(null, group_uuid, block_uuid)
      when 'SidebarBlogFeedBlock'
        {}
      when 'SidebarEventsFeedBlock'
        {}
      when 'AboutBlock'
        editText: this.editText.bind(null, group_uuid, block_uuid)
        editMedia: this.editMedia.bind(null, group_uuid, block_uuid)
        prevTheme: this.prevTheme.bind(null, group_uuid, block_uuid)
        nextTheme: this.nextTheme.bind(null, group_uuid, block_uuid)
        theme: 'left'
        themes: ['banner', 'left']
        updateHeading: this.updateHeading.bind(null, group_uuid, block_uuid)
        updateSubheading: this.updateSubheading.bind(null, group_uuid, block_uuid)
        updateText: this.updateText.bind(null, group_uuid, block_uuid)
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
          max_blocks: if group_type is 'CallToActionGroup' then 3 else undefined
          blocks:
            "#{block_uuid}": this.defaultBlockAttributes(group_uuid, block_uuid, block_type)
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
    if _.reject(this.state.groups[group_uuid].blocks, (block) -> block is undefined).length > 1
      changes =
        "#{group_uuid}":
          blocks:
            "#{block_uuid}":
              $set: undefined
    else
      changes =
        "#{group_uuid}":
          $set: undefined
    this.setState groups: React.addons.update(this.state.groups, changes)

  updateGroup: (group_uuid, attributes) ->
    changes =
      "#{group_uuid}":
        $merge: attributes
    this.setState groups: React.addons.update(this.state.groups, changes)

  updateBlock: (group_uuid, block_uuid, attributes) ->
    changes =
      "#{group_uuid}":
        blocks:
          "#{block_uuid}":
            $merge: attributes
    this.setState groups: React.addons.update(this.state.groups, changes)

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

  editMedia: (group_uuid, block_uuid, event) ->
    event.preventDefault()
    $('#media_group_uuid').val group_uuid
    $('#media_block_uuid').val block_uuid
    $('#media_modal').modal('show')

  updateMedia: (group_uuid, block_uuid) ->
    this.updateBlock $('#media_group_uuid').val(), $('#media_block_uuid').val(),
      media: asdf
    this.resetMedia()

  resetMedia: ->
    $('a[href="#media_tab_image"]').tab('show')

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
    $('#hero_styles_layout_default').prop 'checked', if ['top', 'fullBleed'].indexOf(block.layout) >= 0 then false else true
    $('#hero_styles_layout_top').prop 'checked', block.layout is 'top'
    $('#hero_styles_layout_full_bleed').prop 'checked', block.layout is 'fullBleed'
    $('#hero_styles_modal').modal('show')

  updateHeroStyles: (group_uuid, block_uuid) ->
    this.updateBlock $('#hero_styles_group_uuid').val(), $('#hero_styles_block_uuid').val(),
      layout: $('input[name="hero_styles_layout"]:checked').val()
    this.resetHeroStyles()

  resetHeroStyles: ->
    $('#hero_styles_layout_default').prop 'checked', true
    $('#hero_styles_layout_top').prop 'checked', false
    $('#hero_styles_layout_full_bleed').prop 'checked', false

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

  styles: ->
    """
    .webpage-background,
    .webpage-add,
    .webpage-block-content {
      background-color: #{this.props.backgroundColor};
      color: #{this.props.foregroundColor};
    }
    .webpage-add {
      border-color: #{this.props.foregroundColor};
    }
    .webpage-background a,
    .webpage-block-content a {
      color: #{this.props.linkColor};
    }
    .webpage-group-placeholder {
      border: dashed 1px #{this.props.foregroundColor};
    }
    """

  render: ->
    `<div>
      <style dangerouslySetInnerHTML={{__html: this.styles()}} />
      <div className="webpage-fields">
        <input type="hidden" name="sidebar_position" value={this.state.sidebarPosition} />
      </div>
      <BrowserPanel browserButtonsSrc={this.props.browserButtonsSrc} toggleEditing={this.toggleEditing} editing={this.state.editing}>
        <div className="panel-body" style={{position: 'relative', paddingTop: 0, paddingBottom: 0}}>
          <div style={{marginBottom: '2em'}} />
          <div className="webpage-background" style={{position: 'absolute', top: 0, right: 0, bottom: 0, left: 0, zIndex: 0}} />
          <div className="webpage-groups clearfix">
            {this.renderGroups()}
          </div>
          {this.renderGroupAdd()}
        </div>
        <div className="panel-footer clearfix">
          <div className="checkbox pull-right" style={{margin: 0}}>
            <label>
              <input type="checkbox" checked={this.state.editing} onChange={this.toggleEditing} />
              Display Editing Dialogs?
            </label>
          </div>
        </div>
      </BrowserPanel>
      <div id="group-add-options" className="modal fade">
        <div className="modal-dialog">
          <div className="modal-content">
            <div className="modal-header">
              <span className="close" data-dismiss="modal">&times;</span>
              <p className="h4 modal-title">Add a Page Element</p>
            </div>
            <div className="modal-body">
              <div className="row">
                <div className="col-sm-6">
                  <p><strong>Main Content</strong></p>
                  <ul className="list-group webpage-inserts">
                    <li className="list-group-item" onClick={this.insertGroup.bind(null, 'HeroGroup', 'HeroBlock')} data-dismiss="modal">Hero Block</li>
                    <li className="list-group-item" onClick={this.insertGroup.bind(null, 'TaglineGroup', 'TaglineBlock')} data-dismiss="modal">Tagline Block</li>
                    <li className="list-group-item" onClick={this.insertGroup.bind(null, 'CallToActionGroup', 'CallToActionBlock')} data-dismiss="modal">Columns</li>
                    <li className="list-group-item" onClick={this.insertGroup.bind(null, 'SpecialtyGroup', 'SpecialtyBlock')} data-dismiss="modal">Half-page Image &amp; Content</li>
                    <li className="list-group-item" onClick={this.insertGroup.bind(null, 'ContentGroup', 'ContentBlock')} data-dismiss="modal">Small Image &amp; Content</li>
                    {this.renderInsertBlogFeedGroupItem()}
                  </ul>
                </div>
                <div className="col-sm-6">
                  <p><strong>Sidebar Content</strong></p>
                  <ul className="list-group webpage-inserts">
                    {this.renderInsertSidebarContentItem()}
                    {this.renderInsertSidebarBlogFeedItem()}
                    {this.renderInsertSidebarEventsFeedItem()}
                  </ul>
                </div>
              </div>
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
        <input id="media_group_uuid" type="hidden" />
        <input id="media_block_uuid" type="hidden" />
        <div className="modal-dialog">
          <div className="modal-content">
            <div className="modal-header">
              <span className="close" data-dismiss="modal">&times;</span>
              <p className="h4 modal-title">Add an Image or Video</p>
            </div>
            <div className="modal-body">
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
                    <textarea rows="6" className="form-control" />
                  </div>
                </div>
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
              <div className="row">
                <div className="col-sm-12">
                  <div className="radio">
                    <label>
                      <input type="radio" id="hero_styles_layout_default" name="hero_styles_layout" value="default" defaultChecked="true" />
                      Default layout
                    </label>
                  </div>
                  <div className="radio">
                    <label>
                      <input type="radio" id="hero_styles_layout_top" name="hero_styles_layout" value="top" />
                      Align to top (no space between header nav and hero)
                    </label>
                  </div>
                  <div className="radio">
                    <label>
                      <input type="radio" id="hero_styles_layout_full_bleed" name="hero_styles_layout" value="fullbleed" />
                      Full-bleed (Align to top and fill viewport width)
                    </label>
                  </div>
                </div>
              </div>
            </div>
            <div className="modal-footer">
              <span className="btn btn-default" data-dismiss="modal" onClick={this.resetHeroStyles}>Cancel</span>
              <span className="btn btn-primary" data-dismiss="modal" onClick={this.updateHeroStyles}>Save</span>
            </div>
          </div>
        </div>
      </div>
    </div>`

  renderEditLinkOptions: ->
    `<option key={webpage.id} value={webpage.id}>{webpage.name}</option>` for webpage in this.props.internalWebpages

  renderEditMediaThumbnail: ->
    if this.state.mediaImageURL
      `<div className="webpage-dropzone">
        <div className="small">
          <div className="thumbnail"><img style={{width: '100%'}} src={this.state.mediaImageURL} /></div>
          <div style={{overflow: 'hidden', whiteSpace: 'nowrap'}}><strong>{this.state.mediaImageFileName}</strong></div>
          <div>{this.state.mediaImageFileType()} – {this.state.mediaImageFileSize()}</div>
        </div>
      </div>`
    else
      `<div className="webpage-dropzone">
        <ImageEmpty padding="20" dropzone={true} />
      </div>`

  renderEditMediaProgress: ->
    if this.state.mediaImageStatus is 'uploading'
      `<div>
        <i className="fa fa-close pull-right" />
        <div className="progress" style={{marginRight: 20}}>
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

  mediaImageUploadProgressWidthCSS: ->
    "#{this.state.mediaImageProgress}%"

  renderEditMediaInputs: ->
    if ['uploading', 'finishing', 'attached'].indexOf(this.state.mediaImageStatus) >= 0
      `<div>
        <div className="form-group">
          <label htmlFor="media-image-alt" className="control-label"><code>ALT</code> Attribute</label>
          <input id="media-image-alt" type="text" className="form-control" />
        </div>
        <div className="form-group">
          <label htmlFor="media-image-title" className="control-label"><code>Title</code> Attribute</label>
          <input id="media-image-title" type="text" className="form-control" />
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
          <span onClick={this.showImageLibrary} className="btn btn-default">
            <i className="fa fa-th" /> Browse Library
          </span>
        </span>
        {this.renderEditMediaRemoveButton()}
        <p className="small" style={{marginTop: 10}}>Have a lot of images to add? <a href={this.props.bulkUploadPath} target="_blank">Try Bulk Upload</a></p>
      </div>`

  renderEditMediaRemoveButton: ->
    if ['failed', 'attached'].indexOf(this.state.mediaImageState) >= 0
      `<span onClick={this.removeImage} className="btn btn-sm btn-danger pull-right">
        <i className="fa fa-close" /> Remove
      </span>`

  triggerFileInput: ->
    $(this.refs.fileInput.getDOMNode()).click()

  renderGroups: ->
    _.map _.sortBy(this.state.groups, 'position'), this.renderGroup

  renderGroup: (group, uuid) ->
    if group
      `<Group key={group.uuid} editing={this.state.editing} updateGroup={this.updateGroup} insertBlock={this.insertBlock} sidebarPosition={this.state.sidebarPosition} switchSidebarPosition={this.switchSidebarPosition} {...group} />`

  renderGroupAdd: ->
    marginTop = if this.state.groups.length is 0 then '0' else '2em'
    if this.state.editing
      `<div className="webpage-add" data-toggle="modal" data-target="#group-add-options" style={{marginTop: marginTop, marginBottom: '2em'}}>
        <span className="lead">Add a Page Element</span>
      </div>`

  renderInsertBlogFeedGroupItem: ->
    unless _.find(this.state.groups, (group) -> group and group.type is 'BlogFeedGroup')
      `<li className="list-group-item" onClick={this.insertGroup.bind(null, 'BlogFeedGroup', 'BlogFeedBlock')} data-dismiss="modal">Blog Feed</li>`

  renderInsertSidebarContentItem: ->
    group = _.find(this.state.groups, (group) -> group and group.type is 'SidebarGroup')
    if group
      `<li className="list-group-item" onClick={this.insertBlock.bind(null, group.uuid, 'SidebarContentBlock')} data-dismiss="modal">Small Image &amp; Content</li>`
    else
      `<li className="list-group-item" onClick={this.insertGroup.bind(null, 'SidebarGroup', 'SidebarContentBlock')} data-dismiss="modal">Small Image &amp; Content</li>`

  renderInsertSidebarBlogFeedItem: ->
    group = _.find(this.state.groups, (group) -> group and group.type is 'SidebarGroup')
    if group and not _.find(group.blocks, (block) -> block and block.type is 'SidebarBlogFeedBlock')
      `<li className="list-group-item" onClick={this.insertBlock.bind(null, group.uuid, 'SidebarBlogFeedBlock')} data-dismiss="modal">Blog Feed</li>`
    else if not group
      `<li className="list-group-item" onClick={this.insertGroup.bind(null, 'SidebarGroup', 'SidebarBlogFeedBlock')} data-dismiss="modal">Blog Feed</li>`

  renderInsertSidebarEventsFeedItem: ->
    group = _.find(this.state.groups, (group) -> group and group.type is 'SidebarGroup')
    if group and not _.find(group.blocks, (block) -> block and block.type is 'SidebarEventsBlock')
      `<li className="list-group-item" onClick={this.insertBlock.bind(null, group.uuid, 'SidebarEventsFeedBlock')} data-dismiss="modal">Events Feed</li>`
    else if not group
      `<li className="list-group-item" onClick={this.insertGroup.bind(null, 'SidebarGroup', 'SidebarEventsFeedBlock')} data-dismiss="modal">Events Feed</li>`

  switchSidebarPosition: ->
    if this.state.sidebarPosition is 'right'
      this.setState sidebarPosition: 'left'
    else
      this.setState sidebarPosition: 'right'

window.BasicPage = BasicPage
