(function() {
  var WebsiteMenus;

  WebsiteMenus = React.createClass({
    propTypes: {
      header_links: React.PropTypes.array,
      footer_links: React.PropTypes.array,
      webpages: React.PropTypes.array,
      webpaths: React.PropTypes.array
    },
    componentDidMount: function() {
      $(document).on('click', '.nav-link-remove', this.removeLink);
      $(this.refs.header.getDOMNode()).nestedSortable({
        expandOnHover: 400,
        forcePlaceholderSize: true,
        handle: 'div',
        helper: 'clone',
        items: 'li',
        maxLevels: 2,
        opacity: 0.5,
        placeholder: 'placeholder',
        revert: 100,
        startCollapsed: false,
        tabSize: 20,
        tolerance: 'pointer',
        toleranceElement: '> div',
        update: this.updateLinks,
        isAllowed: function(placeholder, placeholderParent, currentItem) {
          return placeholderParent === void 0 || ($(placeholderParent).hasClass('dropdown') && !$(currentItem).hasClass('dropdown'));
        }
      });
      return $(this.refs.footer.getDOMNode()).sortable({
        expandOnHover: 400,
        forcePlaceholderSize: true,
        handle: 'div',
        helper: 'clone',
        items: 'li',
        maxLevels: 2,
        opacity: 0.5,
        placeholder: 'placeholder',
        revert: 100,
        startCollapsed: false,
        tabSize: 20,
        tolerance: 'pointer',
        update: this.updateLinks
      });
    },
    removeLink: function(e) {
      $(e.target).closest('li').remove();
      if ($(this.refs.header.getDOMNode()).children('li').length === 0) {
        $(this.refs.header.getDOMNode()).siblings('p').show();
      }
      if ($(this.refs.footer.getDOMNode()).children('li').length === 0) {
        return $(this.refs.footer.getDOMNode()).siblings('p').show();
      }
    },
    updateLinks: function() {
      return $(this.getDOMNode()).find('ol').each(function(i, ol) {
        return $(ol).children('li').each(function(j, li) {
          $(li).children('div').find('input[name*="position"]').val(j);
          return $(li).children('div').find('input[name*="parent_key"]').val($(ol).closest('li').children('div').find('input[name*="key"]').val());
        });
      });
    },
    render: function() {
      return <div>
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
    </div>;
    },
    renderEmptyNotice: function(linksLength) {
      var display;
      display = linksLength === 0 ? 'block' : 'none';
      return <p style={{display: display, margin: 0}}>No Navigation Links found.</p>;
    },
    renderLinks: function(links) {
      if (links) {
        return links.map(this.renderLink);
      }
    },
    renderLink: function(link) {
      var iconClass, inputContent, labelContent, labelPlaceholder, options;
      iconClass = (function() {
        switch (link.kind) {
          case 'internal':
            return 'fa fa-2x fa-file';
          case 'external':
            return 'fa fa-2x fa-external-link';
          case 'dropdown':
            return 'fa fa-2x fa-toggle-down';
        }
      })();
      labelContent = link.kind === 'internal' ? <small>Defaults to Webpage Name</small> : '';
      labelPlaceholder = link.kind === 'dropdown' ? '' : 'Leave Blank Except to Create Custom Label';
      inputContent = (function() {
        switch (link.kind) {
          case 'internal':
            options = this.renderWebpageOptions().concat(this.renderWebpathOptions());
            return <div className="form-group">
          <label className="control-label">
            Webpage
            <select className="form-control" name={this.inputName(link.index, 'internal_value')} defaultValue={link.internal_value}>{options}</select>
          </label>
        </div>;
          case 'external':
            return <div className="form-group">
          <label className="control-label">
            External URL
            <input type="text" className="form-control" name={this.inputName(link.index, 'url')} defaultValue={link.url} placeholder="Enter Full URL" />
          </label>
        </div>;
          case 'dropdown':
            return '';
        }
      }).call(this);
      return <li key={link.key} className={link.kind}>
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
              <input type="text" className="form-control" name={this.inputName(link.index, 'label')} defaultValue={link.label} placeholder={labelPlaceholder} />
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
    </li>;
    },
    renderWebpageOptions: function() {
      return this.props.webpages.map(this.renderWebpageOption);
    },
    renderWebpageOption: function(webpage) {
      return <option value={webpage.id}>{webpage.name}</option>;
    },
    renderWebpathOptions: function() {
      return this.props.webpaths.map(this.renderWebpathOption);
    },
    renderWebpathOption: function(webpath) {
      return <option value={webpath.path}>{webpath.name}</option>;
    },
    addInternal: function(location) {
      var container, index, key, link, linkContents;
      this.hideEmptyList(location);
      container = $(this.refs[location].getDOMNode());
      index = parseInt(Math.random() * Math.pow(10, 10));
      key = this.uuid();
      linkContents = $('<div class="row"></div>');
      linkContents.append($('<input type="hidden" name="' + this.inputName(index, 'key') + '" value="' + key + '" />'));
      linkContents.append($('<input type="hidden" name="' + this.inputName(index, 'parent_key') + '" value="" />'));
      linkContents.append($('<input type="hidden" name="' + this.inputName(index, 'position') + '" value="' + (container.children('li').length + 1) + '" />'));
      linkContents.append($('<input type="hidden" name="' + this.inputName(index, 'kind') + '" value="internal" />'));
      linkContents.append($('<input type="hidden" name="' + this.inputName(index, 'location') + '" value="' + location + '" />'));
      linkContents.append($('<div key="icon" class="col-sm-1 text-right"><i class="fa fa-2x fa-file" /></div>'));
      linkContents.append($('<div key="label" class="col-sm-5"><div class="form-group"><label class="control-label">Label <small>Defaults to Webpage Name</small> <input type="text" class="form-control" name="' + this.inputName(index, 'label') + '" placeholder="Leave Blank Except to Create Custom Label" /></label></div></div>'));
      linkContents.append($('<div key="input" class="col-sm-5"><div class="form-group"><label class="control-label">Webpage <select class="form-control" name="' + this.inputName(index, 'internal_value') + '"></select></label></div></div>'));
      $.each(this.props.webpages, function(index, webpage) {
        return linkContents.find('select').append($('<option value="' + webpage.id + '">' + webpage.name + '</option>'));
      });
      $.each(this.props.webpaths, function(index, webpath) {
        return linkContents.find('select').append($('<option value="' + webpath.path + '">' + webpath.name + '</option>'));
      });
      linkContents.append($('<div key="remove" class="col-sm-1 text-right"><span class="fa fa-close nav-link-remove" /></div>'));
      link = $('<li key="' + key + '" class="internal"></li>');
      link.append(linkContents);
      return container.append(link);
    },
    addExternal: function(location) {
      var container, index, key, link, linkContents;
      this.hideEmptyList(location);
      container = $(this.refs[location].getDOMNode());
      index = parseInt(Math.random() * Math.pow(10, 10));
      key = this.uuid();
      linkContents = $('<div class="row"></div>');
      linkContents.append($('<input type="hidden" name="' + this.inputName(index, 'key') + '" value="' + key + '" />'));
      linkContents.append($('<input type="hidden" name="' + this.inputName(index, 'parent_key') + '" value="" />'));
      linkContents.append($('<input type="hidden" name="' + this.inputName(index, 'position') + '" value="' + (container.children('li').length + 1) + '" />'));
      linkContents.append($('<input type="hidden" name="' + this.inputName(index, 'kind') + '" value="external" />'));
      linkContents.append($('<input type="hidden" name="' + this.inputName(index, 'location') + '" value="' + location + '" />'));
      linkContents.append($('<div key="icon" class="col-sm-1 text-right"><i class="fa fa-2x fa-external-link" /></div>'));
      linkContents.append($('<div key="label" class="col-sm-5"><div class="form-group"><label class="control-label">Label <input type="text" class="form-control" name="' + this.inputName(index, 'label') + '" placeholder="Leave Blank Except to Create Custom Label" /></label></div></div>'));
      linkContents.append($('<div key="input" class="col-sm-5"><div class="form-group"><label class="control-label">URL <input type="text" class="form-control" name="' + this.inputName(index, 'url') + '" placeholder="Enter Full URL" /></label></div></div>'));
      linkContents.append($('<div key="remove" class="col-sm-1 text-right"><span class="fa fa-close nav-link-remove" /></div>'));
      link = $('<li key="' + key + '" class="external"></li>');
      link.append(linkContents);
      return container.append(link);
    },
    addDropdown: function(location) {
      var container, index, key, link, linkContents;
      this.hideEmptyList(location);
      container = $(this.refs[location].getDOMNode());
      index = parseInt(Math.random() * Math.pow(10, 10));
      key = this.uuid();
      linkContents = $('<div class="row"></div>');
      linkContents.append($('<input type="hidden" name="' + this.inputName(index, 'key') + '" value="' + key + '" />'));
      linkContents.append($('<input type="hidden" name="' + this.inputName(index, 'parent_key') + '" value="" />'));
      linkContents.append($('<input type="hidden" name="' + this.inputName(index, 'position') + '" value="' + (container.children('li').length + 1) + '" />'));
      linkContents.append($('<input type="hidden" name="' + this.inputName(index, 'kind') + '" value="dropdown" />'));
      linkContents.append($('<input type="hidden" name="' + this.inputName(index, 'location') + '" value="' + location + '" />'));
      linkContents.append($('<div key="icon" class="col-sm-1 text-right"><i class="fa fa-2x fa-toggle-down" /></div>'));
      linkContents.append($('<div key="label" class="col-sm-5"><div class="form-group"><label class="control-label">Label <input type="text" class="form-control" name="' + this.inputName(index, 'label') + '" /></label></div></div>'));
      linkContents.append($('<div key="remove" class="col-sm-1 col-sm-offset-5 text-right"><span class="fa fa-close nav-link-remove" /></div>'));
      link = $('<li key="' + key + '" class="dropdown"></li>');
      link.append(linkContents);
      return container.append(link);
    },
    hideEmptyList: function(ref) {
      return $(this.refs[ref].getDOMNode()).siblings('p').hide();
    },
    inputName: function(index, name) {
      return "website[nav_links_attributes][" + index + "][" + name + "]";
    },
    uuid: function() {
      return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
        var r, v;
        r = Math.random() * 16 | 0;
        v = c === 'x' ? r : r & 0x3 | 0x8;
        return v.toString(16);
      });
    }
  });

  window.WebsiteMenus = WebsiteMenus;

}).call(this);
