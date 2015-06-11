Block = React.createClass
  propTypes:
    editing: React.PropTypes.bool
    groupInputName: React.PropTypes.string
    removeBlock: React.PropTypes.func
    type: React.PropTypes.string

  render: ->
    `<div className="webpage-block">
      <div className="webpage-fields">
        <input type="hidden" name={this.inputName('id')} value={this.props.id} />
        <input type="hidden" name={this.inputName('type')} value={this.props.type} />
        <input type="hidden" name={this.inputName('theme')} value={this.props.theme} />
        <input type="hidden" name={this.inputName('style')} value={this.props.style} />
        <input type="hidden" name={this.inputName('layout')} value={this.props.layout} />
        <input type="hidden" name={this.inputName('position')} value={this.props.position} />
        <input type="hidden" name={this.inputName('heading')} value={this.props.heading} />
        <input type="hidden" name={this.inputName('subheading')} value={this.props.subheading} />
        <input type="hidden" name={this.inputName('text')} value={this.props.text} />
        <input type="hidden" name={this.inputName('link_id')} value={this.props.link_id} />
        <input type="hidden" name={this.inputName('link_type')} value="Webpage" />
        <input type="hidden" name={this.inputName('link_version')} value={this.props.link_version} />
        <input type="hidden" name={this.inputName('link_label')} value={this.props.link_label} />
        <input type="hidden" name={this.inputName('link_external_url')} value={this.props.link_external_url} />
        <input type="hidden" name={this.inputName('link_no_follow')} value={this.props.link_no_follow} />
        <input type="hidden" name={this.inputName('link_target_blank')} value={this.props.link_target_blank} />
        <input type="hidden" name={this.inputName('background_color')} value={this.props.background_color} />
        <input type="hidden" name={this.inputName('foreground_color')} value={this.props.foreground_color} />
        <input type="hidden" name={this.inputName('link_color')} value={this.props.link_color} />
        {this.renderBlockImagePlacementInputs()}
      </div>
      {this.renderBlockOptions()}
      <div className="webpage-block-content">
        {this.renderBlock()}
      </div>
    </div>`

  renderBlockImagePlacementInputs: ->
    placement = this.props.block_image_placement
    if placement
      `<div>
        <input type="hidden" name={this.blockImageInputName('_destroy')} value={placement.destroy} />
        <input type="hidden" name={this.blockImageInputName('id')} value={placement.id} />
        <input type="hidden" name={this.blockImageInputName('kind')} value={placement.kind} />
        <input type="hidden" name={this.blockImageInputName('embed')} value={placement.embed} />
        <input type="hidden" name={this.blockImageInputName('image_id')} value={placement.image_id} />
        <input type="hidden" name={this.blockImageInputName('image_alt')} value={placement.image_alt} />
        <input type="hidden" name={this.blockImageInputName('image_title')} value={placement.image_title} />
        <input type="hidden" name={this.blockImageInputName('image_attachment_cache_url')} value={placement.image_attachment_cache_url} />
        <input type="hidden" name={this.blockImageInputName('image_attachment_content_type')} value={placement.image_content_type} />
        <input type="hidden" name={this.blockImageInputName('image_attachment_file_name')} value={placement.image_file_name} />
        <input type="hidden" name={this.blockImageInputName('image_attachment_file_size')} value={placement.image_file_size} />
      </div>`

  inputName: (name) ->
    "#{this.props.groupInputName}[#{this.props.uuid}][#{name}]"

  blockImageInputName: (name) ->
    this.inputName('block_image_placement_attributes') + "[#{name}]"

  renderBlockOptions: ->
    if this.props.editing
      `<div className="webpage-options btn-group btn-group-sm" style={{opacity: 0.8}}>
        {this.renderPrevThemeOption()}
        {this.renderEditTextOption()}
        {this.renderEditMediaOption()}
        {this.renderEditLinkOption()}
        {this.renderEditCustomOption()}
        {this.renderRemoveBlockOption()}
        {this.renderNextThemeOption()}
      </div>`

  renderPrevThemeOption: ->
    if this.props.prevTheme
      `<a href="#" onClick={this.props.prevTheme} className="btn btn-warning"><i className="fa fa-caret-left" /></a>`

  renderEditTextOption: ->
    if this.props.editText
      `<a href="#" onClick={this.props.editText} className="btn btn-warning"><i className="fa fa-pencil" /></a>`

  renderEditMediaOption: ->
    if this.props.editMedia
      `<a href="#" onClick={this.props.editMedia} className="btn btn-warning"><i className="fa fa-photo" /></a>`

  renderEditLinkOption: ->
    if this.props.editLink
      `<a href="#" onClick={this.props.editLink} className="btn btn-warning"><i className="fa fa-link" /></a>`

  renderEditCustomOption: ->
    if this.props.editCustom
      `<a href="#" onClick={this.props.editCustom} className="btn btn-warning"><i className="fa fa-cog" /></a>`

  renderRemoveBlockOption: ->
    if this.props.removeBlock
      `<a href="#" onClick={this.props.removeBlock} className="btn btn-warning"><i className="fa fa-trash" /></a>`

  renderNextThemeOption: ->
    if this.props.nextTheme
      `<a href="#" onClick={this.props.nextTheme} className="btn btn-warning"><i className="fa fa-caret-right" /></a>`

  renderBlock: ->
    switch this.props.type
      when 'HeroBlock'
        `<HeroBlockContent {...this.props} />`
      when 'TaglineBlock'
        `<TaglineBlockContent {...this.props} />`
      when 'CallToActionBlock'
        `<CallToActionBlockContent {...this.props} />`
      when 'SpecialtyBlock'
        `<SpecialtyBlockContent {...this.props} />`
      when 'ContentBlock'
        `<ContentBlockContent {...this.props} />`
      when 'BlogFeedBlock'
        `<BlogFeedBlockContent {...this.props} />`
      when 'SidebarContentBlock'
        `<SidebarContentBlockContent {...this.props} />`
      when 'SidebarBlogFeedBlock'
        `<SidebarBlogFeedBlockContent {...this.props} />`
      when 'SidebarEventsFeedBlock'
        `<SidebarEventsFeedBlockContent {...this.props} />`
      when 'AboutBlock'
        `<AboutBlockContent {...this.props} />`
      when 'TeamBlock'
        `<TeamBlockContent {...this.props} />`
      when 'ContactBlock'
        `<ContactBlockContent {...this.props} />`

window.Block = Block
