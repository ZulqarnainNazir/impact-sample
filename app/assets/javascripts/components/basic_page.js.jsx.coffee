BasicPage = React.createClass
  propTypes:
    backgroundColor: React.PropTypes.string
    browserButtonsSrc: React.PropTypes.string
    bulkUploadPath: React.PropTypes.string
    foregroundColor: React.PropTypes.string
    hasMultipleBusinesses: React.PropTypes.bool
    imagesPath: React.PropTypes.string
    initialGroups: React.PropTypes.array
    internalWebpages: React.PropTypes.array
    linkColor: React.PropTypes.string
    presignedPost: React.PropTypes.object
    sidebarPosition: React.PropTypes.string

  getInitialState: ->
    editing: true
    groups: {}
    sidebarPosition: if this.props.sidebarPosition is 'left' then 'left' else 'right'
    mediaImageStatus: 'empty'
    mediaImageProgress: 0

  componentDidMount: ->
    $(this.refs.linkModal.getDOMNode()).on 'change', 'input[type="radio"]', this.toggleLinkOptions
    this.toggleLinkOptions()
    this.enableSortableGroups()

  toggleLinkOptions: ->
    if $(this.refs.noneLink.getDOMNode()).prop('checked')
      $(this.refs.defaultLinkInputs.getDOMNode()).hide()
      $(this.refs.internalLinkInputs.getDOMNode()).hide()
      $(this.refs.externalLinkInputs.getDOMNode()).hide()
    else if $(this.refs.internalLink.getDOMNode()).prop('checked')
      $(this.refs.defaultLinkInputs.getDOMNode()).show()
      $(this.refs.internalLinkInputs.getDOMNode()).show()
      $(this.refs.externalLinkInputs.getDOMNode()).hide()
    else
      $(this.refs.defaultLinkInputs.getDOMNode()).show()
      $(this.refs.internalLinkInputs.getDOMNode()).hide()
      $(this.refs.externalLinkInputs.getDOMNode()).show()


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

  toggleEditing: ->
    this.setState editing: !this.state.editing

  defaultBlockAttributes: (group_uuid, block_uuid, block_type) ->
    basicAttributes =
      removeBlock: this.removeBlock.bind(null, group_uuid, block_uuid)
      type: block_type
      uuid: block_uuid
    additionalAttributes = switch block_type
      when 'hero'
        editText: this.editText.bind(null, group_uuid, block_uuid)
        editMedia: this.editMedia.bind(null, group_uuid, block_uuid)
        editLink: this.editLink.bind(null, group_uuid, block_uuid)
        prevTheme: this.prevTheme.bind(null, group_uuid, block_uuid)
        nextTheme: this.nextTheme.bind(null, group_uuid, block_uuid)
        theme: 'full'
        themes: ['full', 'right', 'well', 'well_dark', 'form', 'split_image', 'split_video']
      when 'tagline'
        editText: this.editText.bind(null, group_uuid, block_uuid)
        editLink: this.editLink.bind(null, group_uuid, block_uuid)
        prevTheme: this.prevTheme.bind(null, group_uuid, block_uuid)
        nextTheme: this.nextTheme.bind(null, group_uuid, block_uuid)
        theme: 'left'
        themes: ['left', 'center', 'contain']
      when 'call_to_action'
        editText: this.editText.bind(null, group_uuid, block_uuid)
        editMedia: this.editMedia.bind(null, group_uuid, block_uuid)
        editLink: this.editLink.bind(null, group_uuid, block_uuid)
      when 'specialty'
        editText: this.editText.bind(null, group_uuid, block_uuid)
        editMedia: this.editMedia.bind(null, group_uuid, block_uuid)
        prevTheme: this.prevTheme.bind(null, group_uuid, block_uuid)
        nextTheme: this.nextTheme.bind(null, group_uuid, block_uuid)
        theme: 'left'
        themes: ['left', 'right']
      when 'content'
        editText: this.editText.bind(null, group_uuid, block_uuid)
        editMedia: this.editMedia.bind(null, group_uuid, block_uuid)
        prevTheme: this.prevTheme.bind(null, group_uuid, block_uuid)
        nextTheme: this.nextTheme.bind(null, group_uuid, block_uuid)
        theme: 'left'
        themes: ['left', 'right', 'full', 'full_image']
      when 'blog_feed'
        {}
      when 'sidebar_content'
        editText: this.editText.bind(null, group_uuid, block_uuid)
        editMedia: this.editMedia.bind(null, group_uuid, block_uuid)
        editLink: this.editLink.bind(null, group_uuid, block_uuid)
      when 'sidebar_blog_feed'
        {}
      when 'sidebar_events_feed'
        {}
    $.extend {}, basicAttributes, additionalAttributes

  insertGroup: (group_type, block_type) ->
    group_uuid = Math.floor(Math.random() * Math.pow(10, 10))
    block_uuid = Math.floor(Math.random() * Math.pow(10, 10))
    changes =
      $merge:
        "#{group_uuid}":
          type: group_type
          uuid: group_uuid
          maxBlocks: if group_type is 'call_to_action' then 3 else undefined
          blocks:
            "#{block_uuid}": this.defaultBlockAttributes(group_uuid, block_uuid, block_type)
    this.setState groups: React.addons.update(this.state.groups, changes)

  insertBlock: (group_uuid, block_type) ->
    block_uuid = Math.floor(Math.random() * Math.pow(10, 10))
    changes =
      "#{group_uuid}":
        blocks:
          $merge:
            "#{block_uuid}": this.defaultBlockAttributes(group_uuid, block_uuid, block_type)
    this.setState groups: React.addons.update(this.state.groups, changes)

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

  editMedia: (group_uuid, block_uuid, event) ->
    event.preventDefault()
    $('#edit-media-options').modal('show')
    console.log this.state.groups[group_uuid]

  editLink: (group_uuid, block_uuid, event) ->
    event.preventDefault()
    $('#edit-link-options').modal('show')

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
                    <li className="list-group-item" onClick={this.insertGroup.bind(null, 'hero', 'hero')} data-dismiss="modal">Hero Block</li>
                    <li className="list-group-item" onClick={this.insertGroup.bind(null, 'tagline', 'tagline')} data-dismiss="modal">Tagline Block</li>
                    <li className="list-group-item" onClick={this.insertGroup.bind(null, 'call_to_action', 'call_to_action')} data-dismiss="modal">Columns</li>
                    <li className="list-group-item" onClick={this.insertGroup.bind(null, 'specialty', 'specialty')} data-dismiss="modal">Half-page Image &amp; Content</li>
                    <li className="list-group-item" onClick={this.insertGroup.bind(null, 'content', 'content')} data-dismiss="modal">Small Image &amp; Content</li>
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
      <div ref="linkModal" id="edit-link-options" className="modal fade">
        <div className="modal-dialog">
          <div className="modal-content">
            <div className="modal-header">
              <span className="close" data-dismiss="modal">&times;</span>
              <p className="h4 modal-title">Add a Link</p>
            </div>
            <div className="modal-body">
              <div className="radio">
                <label>
                  <input ref="noneLink" type="radio" name="link_version" value="link_none" defaultChecked="true"/>
                  Don‘t include a linked button
                </label>
              </div>
              <div className="radio">
                <label>
                  <input ref="internalLink" type="radio" name="link_version" value="link_internal" />
                  Link to an internal webpage on your site
                </label>
              </div>
              <div className="radio">
                <label>
                  <input ref="externalLink" type="radio" name="link_version" value="link_external" />
                  Link to an external webpage
                </label>
              </div>
              <div ref="internalLinkInputs">
                <hr />
                <div className="form-group">
                  <label htmlFor="link_id" className="control-label">IMPACT Webpage</label>
                  <select id="link_id" className="form-control">
                    {this.renderEditLinkOptions()}
                  </select>
                </div>
              </div>
              <div ref="externalLinkInputs">
                <hr />
                <div className="form-group">
                  <label htmlFor="link_external_url" className="control-label">External URL</label>
                  <input id="link_external_url" type="text" className="form-control" />
                </div>
              </div>
              <div ref="defaultLinkInputs">
                <div className="form-group">
                  <label htmlFor="link_label" className="control-label">Button Label</label>
                  <input id="link_label" type="text" className="form-control" />
                </div>
                <div className="checkbox">
                  <label>
                    <input type="checkbox" value="1" />
                    Open link in a new window?
                  </label>
                </div>
                <div className="checkbox">
                  <label>
                    <input type="checkbox" value="1" />
                    Add "no-follow" to the link?
                  </label>
                </div>
              </div>
            </div>
            <div className="modal-footer">
              <span className="btn btn-default" data-dismiss="modal">Cancel</span>
              <span className="btn btn-primary" data-dismiss="modal">Save</span>
            </div>
          </div>
        </div>
      </div>
      <div id="edit-media-options" className="modal fade">
        <div className="modal-dialog">
          <div className="modal-content">
            <div className="modal-header">
              <span className="close" data-dismiss="modal">&times;</span>
              <p className="h4 modal-title">Add an Image or Video</p>
            </div>
            <div className="modal-body">
              <ul className="nav nav-tabs">
                <li clasName="active"><a href="#edit-media-options-tab-image" data-toggle="tab">Image</a></li>
                <li><a href="#edit-media-options-tab-embed" data-toggle="tab">Embed</a></li>
              </ul>
              <div className="tab-content">
                <div id="edit-media-options-tab-image" className="tab-pane fade in active">
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
                <div id="edit-media-options-tab-image" className="tab-pane">
                  <div className="form-group">
                    <textarea rows="6" className="form-control" />
                  </div>
                </div>
              </div>
            </div>
            <div className="modal-footer">
              <span className="btn btn-default" data-dismiss="modal">Cancel</span>
              <span className="btn btn-primary" data-dismiss="modal">Save</span>
            </div>
          </div>
        </div>
      </div>
    </div>`

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
        <span onClick={this.removeImage} className="btn btn-sm btn-danger pull-right">
          <i className="fa fa-close" /> Remove
        </span>
        <p className="small" style={{marginTop: 10}}>Have a lot of images to add? <a href={this.props.bulkUploadPath} target="_blank">Try Bulk Upload</a></p>
      </div>`

  triggerFileInput: ->
    $(this.refs.fileInput.getDOMNode()).click()

  renderEditLinkOptions: ->
    `<option key={webpage.id} value={webpage.id}>{webpage.name}</option>` for webpage in this.props.internalWebpages

  renderGroups: ->
    _.map this.state.groups, this.renderGroup

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
    unless _.find(this.state.groups, (group) -> group and group.type is 'blog_feed')
      `<li className="list-group-item" onClick={this.insertGroup.bind(null, 'blog_feed', 'blog_feed')} data-dismiss="modal">Blog Feed</li>`

  renderInsertSidebarContentItem: ->
    group = _.find(this.state.groups, (group) -> group and group.type is 'sidebar')
    if group
      `<li className="list-group-item" onClick={this.insertBlock.bind(null, group.uuid, 'sidebar_content')} data-dismiss="modal">Small Image &amp; Content</li>`
    else
      `<li className="list-group-item" onClick={this.insertGroup.bind(null, 'sidebar', 'sidebar_content')} data-dismiss="modal">Small Image &amp; Content</li>`

  renderInsertSidebarBlogFeedItem: ->
    group = _.find(this.state.groups, (group) -> group and group.type is 'sidebar')
    if group and not _.find(group.blocks, (block) -> block and block.type is 'sidebar_blog_feed')
      `<li className="list-group-item" onClick={this.insertBlock.bind(null, group.uuid, 'sidebar_blog_feed')} data-dismiss="modal">Blog Feed</li>`
    else if not group
      `<li className="list-group-item" onClick={this.insertGroup.bind(null, 'sidebar', 'sidebar_blog_feed')} data-dismiss="modal">Blog Feed</li>`

  renderInsertSidebarEventsFeedItem: ->
    group = _.find(this.state.groups, (group) -> group and group.type is 'sidebar')
    if group and not _.find(group.blocks, (block) -> block and block.type is 'sidebar_events_feed')
      `<li className="list-group-item" onClick={this.insertBlock.bind(null, group.uuid, 'sidebar_events_feed')} data-dismiss="modal">Events Feed</li>`
    else if not group
      `<li className="list-group-item" onClick={this.insertGroup.bind(null, 'sidebar', 'sidebar_events_feed')} data-dismiss="modal">Events Feed</li>`

  switchSidebarPosition: ->
    if this.state.sidebarPosition is 'right'
      this.setState sidebarPosition: 'left'
    else
      this.setState sidebarPosition: 'right'

window.BasicPage = BasicPage
