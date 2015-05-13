WebsiteMenus = React.createClass
  propTypes:
    header_links: React.PropTypes.array
    footer_links: React.PropTypes.array
    webpages: React.PropTypes.array

  componentDidMount: ->
    $(document).on 'click', '.nav-link-remove', this.removeLink

    $(this.refs.header.getDOMNode()).nestedSortable
      expandOnHover: 400
      forcePlaceholderSize: true
      handle: 'div'
      helper: 'clone'
      items: 'li'
      maxLevels: 2
      opacity: 0.5
      placeholder: 'placeholder'
      revert: 100
      startCollapsed: false
      tabSize: 20
      tolerance: 'pointer'
      toleranceElement: '> div'
      update: this.updateLinks
      isAllowed: (placeholder, placeholderParent, currentItem) ->
        placeholderParent is undefined or ($(placeholderParent).hasClass('dropdown') and not $(currentItem).hasClass('dropdown'))

    $(this.refs.footer.getDOMNode()).sortable
      expandOnHover: 400
      forcePlaceholderSize: true
      handle: 'div'
      helper: 'clone'
      items: 'li'
      maxLevels: 2
      opacity: 0.5
      placeholder: 'placeholder'
      revert: 100
      startCollapsed: false
      tabSize: 20
      tolerance: 'pointer'
      update: this.updateLinks

  removeLink: (e) ->
    $(e.target).closest('li').remove()
    $(this.refs.header.getDOMNode()).siblings('p').show() if $(this.refs.header.getDOMNode()).children('li').length is 0
    $(this.refs.footer.getDOMNode()).siblings('p').show() if $(this.refs.footer.getDOMNode()).children('li').length is 0

  updateLinks: ->
    $(this.getDOMNode()).find('ol').each (i, ol) ->
      $(ol).children('li').each (j, li) ->
        $(li).children('div').find('input[name*="position"]').val j
        $(li).children('div').find('input[name*="parent_key"]').val $(ol).closest('li').children('div').find('input[name*="key"]').val()

  render: ->
    `<div>
      <h2 className="h4">Header Menu</h2>
      <div className="well">
        <ol ref="header" className="website-menu-sortable">
          {this.renderLinks(this.props.header_links)}
        </ol>
        {this.renderEmptyNotice(this.props.header_links.length)}
      </div>
      <div className="btn-group btn-group-sm" style={{marginBottom: 60}}>
        <span className="btn btn-default" onClick={this.addInternal.bind(null, 'header')}>
          <i className="fa fa-file" style={{marginRight: 8}} />
          Add Internal Link
        </span>
        <span className="btn btn-default" onClick={this.addExternal.bind(null, 'header')}>
          <i className="fa fa-external-link" style={{marginRight: 8}} />
          Add External Link
        </span>
        <span className="btn btn-default" onClick={this.addDropdown.bind(null, 'header')}>
          <i className="fa fa-toggle-down" style={{marginRight: 8}} />
          Add Dropdown Label
        </span>
      </div>
      <h2 className="h4">Footer Menu</h2>
      <div className="well">
        <ol ref="footer" className="website-menu-sortable">
          {this.renderLinks(this.props.footer_links)}
        </ol>
        {this.renderEmptyNotice(this.props.footer_links.length)}
      </div>
      <div className="btn-group btn-group-sm" style={{marginBottom: 60}}>
        <span className="btn btn-default" onClick={this.addInternal.bind(null, 'footer')}>
          <i className="fa fa-file" style={{marginRight: 8}} />
          Add Internal Link
        </span>
        <span className="btn btn-default" onClick={this.addExternal.bind(null, 'footer')}>
          <i className="fa fa-external-link" style={{marginRight: 8}} />
          Add External Link
        </span>
      </div>
    </div>`

  renderEmptyNotice: (linksLength) ->
    display = if linksLength is 0 then 'block' else 'none'
    `<p style={{display: display, margin: 0}}>No Navigation Links found.</p>`

  renderLinks: (links) ->
    links.map this.renderLink if links

  renderLink: (link) ->
    iconClass = switch link.kind
      when 'internal' then 'fa fa-2x fa-file'
      when 'external' then 'fa fa-2x fa-external-link'
      when 'dropdown' then 'fa fa-2x fa-toggle-down'
    labelContent = if link.kind is 'internal' then `<small>Defaults to Webpage Name</small>` else ''
    inputContent = switch link.kind
      when 'internal'
        options = this.renderWebpageOptions()
        `<div className="form-group">
          <label className="control-label">
            Webpage
            <select className="form-control" name={this.inputName(link.index, 'webpage_id')} defaultValue={link.webpage_id}>{options}</select>
          </label>
        </div>`
      when 'external'
        `<div className="form-group">
          <label className="control-label">
            External URL
            <input type="text" className="form-control" name={this.inputName(link.index, 'url')} defaultValue={link.url} />
          </label>
        </div>`
      when 'dropdown'
        ''
    `<li key={link.key} className={link.kind}>
      <div className="row">
        <input type="hidden" name={this.inputName(link.index, 'id')} defaultValue={link.id} />
        <input type="hidden" name={this.inputName(link.index, 'key')} defaultValue={link.key} />
        <input type="hidden" name={this.inputName(link.index, 'parent_key')} defaultValue={link.parent_key} />
        <input type="hidden" name={this.inputName(link.index, 'position')} defaultValue={link.position} />
        <input type="hidden" name={this.inputName(link.index, 'kind')} defaultValue={link.kind} />
        <input type="hidden" name={this.inputName(link.index, 'location')} defaultValue={link.location} />
        <div key="icon" className="col-sm-1 text-right"><i className={iconClass} /></div>
        <div key="label" className="col-sm-5">
          <div className="form-group">
            <label className="control-label">
              Label {labelContent}
              <input type="text" className="form-control" name={this.inputName(link.index, 'label')} defaultValue={link.label} />
            </label>
          </div>
        </div>
        <div key="input" className="col-sm-5">
          {inputContent}
        </div>
        <div key="remove" className="col-sm-1 text-right">
          <span className="fa fa-close nav-link-remove" />
        </div>
      </div>
      <ol>{this.renderLinks(link.cached_children)}</ol>
    </li>`

  renderWebpageOptions: ->
    this.props.webpages.map this.renderWebpageOption

  renderWebpageOption: (webpage) ->
    `<option value={webpage.id}>{webpage.name}</option>`

  addInternal: (location) ->
    this.hideEmptyList(location)
    container = $(this.refs[location].getDOMNode())
    index = parseInt(Math.random() * Math.pow(10, 10))
    key = this.uuid()
    linkContents = $('<div class="row"></div>')
    linkContents.append $('<input type="hidden" name="' + this.inputName(index, 'key') + '" value="' + key + '" />')
    linkContents.append $('<input type="hidden" name="' + this.inputName(index, 'parent_key') + '" value="" />')
    linkContents.append $('<input type="hidden" name="' + this.inputName(index, 'position') + '" value="' + (container.children('li').length + 1) + '" />')
    linkContents.append $('<input type="hidden" name="' + this.inputName(index, 'kind') + '" value="internal" />')
    linkContents.append $('<input type="hidden" name="' + this.inputName(index, 'location') + '" value="' + location + '" />')
    linkContents.append $('<div key="icon" class="col-sm-1 text-right"><i class="fa fa-2x fa-file" /></div>')
    linkContents.append $('<div key="label" class="col-sm-5"><div class="form-group"><label class="control-label">Label <small>Defaults to Webpage Name</small> <input type="text" class="form-control" name="' + this.inputName(index, 'label') + '" /></label></div></div>')
    linkContents.append $('<div key="input" class="col-sm-5"><div class="form-group"><label class="control-label">Webpage <select class="form-control" name="' + this.inputName(index, 'webpage_id') + '"></select></label></div></div>')
    $.each this.props.webpages, (index, webpage) ->
      linkContents.find('select').append $('<option value="' + webpage.id + '">' + webpage.name + '</option>')
    linkContents.append $('<div key="remove" class="col-sm-1 text-right"><span class="fa fa-close nav-link-remove" /></div>')
    link = $('<li key="' + key + '" class="internal"></li>')
    link.append(linkContents)
    container.append(link)

  addExternal: (location) ->
    this.hideEmptyList(location)
    container = $(this.refs[location].getDOMNode())
    index = parseInt(Math.random() * Math.pow(10, 10))
    key = this.uuid()
    linkContents = $('<div class="row"></div>')
    linkContents.append $('<input type="hidden" name="' + this.inputName(index, 'key') + '" value="' + key + '" />')
    linkContents.append $('<input type="hidden" name="' + this.inputName(index, 'parent_key') + '" value="" />')
    linkContents.append $('<input type="hidden" name="' + this.inputName(index, 'position') + '" value="' + (container.children('li').length + 1) + '" />')
    linkContents.append $('<input type="hidden" name="' + this.inputName(index, 'kind') + '" value="external" />')
    linkContents.append $('<input type="hidden" name="' + this.inputName(index, 'location') + '" value="' + location + '" />')
    linkContents.append $('<div key="icon" class="col-sm-1 text-right"><i class="fa fa-2x fa-external-link" /></div>')
    linkContents.append $('<div key="label" class="col-sm-5"><div class="form-group"><label class="control-label">Label <input type="text" class="form-control" name="' + this.inputName(index, 'label') + '" /></label></div></div>')
    linkContents.append $('<div key="input" class="col-sm-5"><div class="form-group"><label class="control-label">URL <input type="text" class="form-control" name="' + this.inputName(index, 'url') + '" /></label></div></div>')
    linkContents.append $('<div key="remove" class="col-sm-1 text-right"><span class="fa fa-close nav-link-remove" /></div>')
    link = $('<li key="' + key + '" class="external"></li>')
    link.append(linkContents)
    container.append(link)

  addDropdown: (location) ->
    this.hideEmptyList(location)
    container = $(this.refs[location].getDOMNode())
    index = parseInt(Math.random() * Math.pow(10, 10))
    key = this.uuid()
    linkContents = $('<div class="row"></div>')
    linkContents.append $('<input type="hidden" name="' + this.inputName(index, 'key') + '" value="' + key + '" />')
    linkContents.append $('<input type="hidden" name="' + this.inputName(index, 'parent_key') + '" value="" />')
    linkContents.append $('<input type="hidden" name="' + this.inputName(index, 'position') + '" value="' + (container.children('li').length + 1) + '" />')
    linkContents.append $('<input type="hidden" name="' + this.inputName(index, 'kind') + '" value="dropdown" />')
    linkContents.append $('<input type="hidden" name="' + this.inputName(index, 'location') + '" value="' + location + '" />')
    linkContents.append $('<div key="icon" class="col-sm-1 text-right"><i class="fa fa-2x fa-toggle-down" /></div>')
    linkContents.append $('<div key="label" class="col-sm-5"><div class="form-group"><label class="control-label">Label <input type="text" class="form-control" name="' + this.inputName(index, 'label') + '" /></label></div></div>')
    linkContents.append $('<div key="remove" class="col-sm-1 col-sm-offset-5 text-right"><span class="fa fa-close nav-link-remove" /></div>')
    link = $('<li key="' + key + '" class="dropdown"></li>')
    link.append(linkContents)
    container.append(link)

  hideEmptyList: (ref) ->
    $(this.refs[ref].getDOMNode()).siblings('p').hide()

  inputName: (index, name) ->
    "website[nav_links_attributes][#{index}][#{name}]"

  uuid: ->
    'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace /[xy]/g, (c) ->
      r = Math.random() * 16 | 0
      v = if c is 'x' then r else (r & 0x3|0x8)
      v.toString(16)

window.WebsiteMenus = WebsiteMenus
