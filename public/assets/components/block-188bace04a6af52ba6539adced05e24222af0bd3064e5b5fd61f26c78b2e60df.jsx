(function() {
  var Block;

  Block = React.createClass({
    propTypes: {
      editing: React.PropTypes.bool,
      groupInputName: React.PropTypes.string,
      kind: React.PropTypes.string,
      max_blocks: React.PropTypes.number,
      removeBlock: React.PropTypes.func,
      type: React.PropTypes.string,
      custom_class: React.PropTypes.string
    },
    componentDidMount: function() {
      return $(this.getDOMNode()).find('.webpage-options a').popover({
        container: 'body',
        placement: 'top',
        trigger: 'hover',
        delay: {
          show: 500,
          hide: 0
        }
      });
    },
    render: function() {
      return <div className={this.webpageClassName()} style={this.blockStyle()} data-uuid={this.props.uuid}>
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
        <input type="hidden" name={this.inputName('height')} value={this.props.height} />
        <input type="hidden" name={this.inputName('items_limit')} value={this.props.items_limit} />
        <input type="hidden" name={this.inputName('well_style')} value={this.props.well_style} />
        <input type="hidden" name={this.inputName('custom_class')} value={this.props.custom_class} />
        <input type="hidden" name={this.inputName('content_types')} value={this.props.content_types} />
        <input type="hidden" name={this.inputName('content_category_ids')} value={this.props.content_category_ids} />
        <input type="hidden" name={this.inputName('content_tag_ids')} value={this.props.content_tag_ids} />
        {this.renderHeaderInputs()}
        {this.renderBlockBackgroundPlacementInputs()}
        {this.renderBlockImagePlacementInputs()}
      </div>
      {this.renderBlockOptions()}
      <div className="webpage-block-content">
        {this.renderBlock()}
      </div>
    </div>;
    },
    webpageClassName: function() {
      if (this.props.type === 'CallToActionBlock') {
        switch (this.props.max_blocks) {
          case 2:
            return 'webpage-block col-sm-6';
          case 4:
            return 'webpage-block col-sm-3';
          default:
            return 'webpage-block col-sm-4';
        }
      } else {
        return 'webpage-block';
      }
    },
    blockStyle: function() {
      if (this.props.type === 'HeroBlock') {
        return {
          display: this.props.current_block === this.props.uuid ? '' : 'none',
          marginTop: 0
        };
      }
    },
    renderHeaderInputs: function() {
      if (this.props.type === 'HeaderBlock') {
        return <div>
        <input type="hidden" name={this.inputName('logo_height')} value={this.props.logo_height} />
        <input type="hidden" name={this.inputName('style')} value={this.props.style} />
        <input type="hidden" name={this.inputName('logo_horizontal_position')} value={this.props.logo_horizontal_position} />
        <input type="hidden" name={this.inputName('logo_vertical_position')} value={this.props.logo_vertical_position} />
        <input type="hidden" name={this.inputName('logo_bar_fixed')} value={this.props.logo_bar_fixed} />
        <input type="hidden" name={this.inputName('social_enabled')} value={this.props.social_enabled} />
        <input type="hidden" name={this.inputName('navigation_horizontal_position')} value={this.props.navigation_horizontal_position} />
        <input type="hidden" name={this.inputName('contact_position')} value={this.props.contact_position} />
        <input type="hidden" name={this.inputName('social_position')} value={this.props.social_position} />
        <input type="hidden" name={this.inputName('navbar_location')} value={this.props.navbar_location} />
      </div>;
      }
    },
    renderBlockBackgroundPlacementInputs: function() {
      var placement;
      placement = this.props.block_background_placement;
      if (placement) {
        return <div>
        <input type="hidden" name={this.blockBackgroundInputName('_destroy')} value={placement.destroy} />
        <input type="hidden" name={this.blockBackgroundInputName('id')} value={placement.id} />
        <input type="hidden" name={this.blockBackgroundInputName('kind')} value={placement.kind} />
        <input type="hidden" name={this.blockBackgroundInputName('embed')} value={placement.embed} />
        <input type="hidden" name={this.blockBackgroundInputName('image_id')} value={placement.image_id} />
        <input type="hidden" name={this.blockBackgroundInputName('image_alt')} value={placement.image_alt} />
        <input type="hidden" name={this.blockBackgroundInputName('image_title')} value={placement.image_title} />
        <input type="hidden" name={this.blockBackgroundInputName('image_attachment_cache_url')} value={placement.image_attachment_cache_url} />
        <input type="hidden" name={this.blockBackgroundInputName('image_attachment_content_type')} value={placement.image_attachment_content_type} />
        <input type="hidden" name={this.blockBackgroundInputName('image_attachment_file_name')} value={placement.image_attachment_file_name} />
        <input type="hidden" name={this.blockBackgroundInputName('image_attachment_file_size')} value={placement.image_attachment_file_size} />
      </div>;
      }
    },
    renderBlockImagePlacementInputs: function() {
      var placement;
      placement = this.props.block_image_placement;
      if (placement) {
        return <div>
        <input type="hidden" name={this.blockImageInputName('_destroy')} value={placement.destroy} />
        <input type="hidden" name={this.blockImageInputName('id')} value={placement.id} />
        <input type="hidden" name={this.blockImageInputName('kind')} value={placement.kind} />
        <input type="hidden" name={this.blockImageInputName('embed')} value={placement.embed} />
        <input type="hidden" name={this.blockImageInputName('full_width')} value={placement.full_width} />
        <input type="hidden" name={this.blockImageInputName('image_id')} value={placement.image_id} />
        <input type="hidden" name={this.blockImageInputName('image_alt')} value={placement.image_alt} />
        <input type="hidden" name={this.blockImageInputName('image_title')} value={placement.image_title} />
        <input type="hidden" name={this.blockImageInputName('image_attachment_cache_url')} value={placement.image_attachment_cache_url} />
        <input type="hidden" name={this.blockImageInputName('image_attachment_content_type')} value={placement.image_attachment_content_type} />
        <input type="hidden" name={this.blockImageInputName('image_attachment_file_name')} value={placement.image_attachment_file_name} />
        <input type="hidden" name={this.blockImageInputName('image_attachment_file_size')} value={placement.image_attachment_file_size} />
      </div>;
      }
    },
    inputName: function(name) {
      if (this.props.uuid === 0 || this.props.uuid) {
        return this.props.groupInputName + "[" + this.props.uuid + "][" + name + "]";
      } else {
        return this.props.groupInputName + "[" + name + "]";
      }
    },
    blockBackgroundInputName: function(name) {
      return this.inputName('block_background_placement_attributes') + ("[" + name + "]");
    },
    blockImageInputName: function(name) {
      return this.inputName('block_image_placement_attributes') + ("[" + name + "]");
    },
    renderBlockOptions: function() {
      if (this.props.editing) {
        return <div className="webpage-options btn-group btn-group-sm">
        {this.renderPrevThemeOption()}
        {this.renderExpandOption()}
        {this.renderCompressOption()}
        {this.renderEditLogoOption()}
        {this.renderEditTextOption()}
        {this.renderEditBackgroundOption()}
        {this.renderEditImageOption()}
        {this.renderEditLinkOption()}
        {this.renderEditCustomOption()}
        {this.renderSortOption()}
        {this.renderRemoveBlockOption()}
        {this.renderFooterEmbed()}
        {this.renderNextThemeOption()}

      </div>;
      }
    },
    renderPrevThemeOption: function() {
      if (this.props.prevTheme) {
        return <a href="#" onClick={this.props.prevTheme} className="btn btn-warning" title="Cycle through layout options" data-content="Pick the layout that's right for you."><i className="fa fa-caret-left" /></a>;
      }
    },
    renderExpandOption: function() {
      if (this.props.expand && this.props.kind === 'container') {
        return <a href="#" onClick={this.props.expand} className="btn btn-warning" title="Click to Expand Hero to full-width" data-content="Makes background image or color the full width of the browser"><i className="fa fa-expand" /></a>;
      }
    },
    renderCompressOption: function() {
      if (this.props.compress && this.props.kind === 'full_width') {
        return <a href="#" onClick={this.props.compress} className="btn btn-warning" data-content="Click to contract Hero to site-width"><i className="fa fa-compress" /></a>;
      }
    },
    renderEditLogoOption: function() {
      if (this.props.editLogo) {
        return <a href="#" onClick={this.props.editLogo} className="btn btn-warning" data-content="Click to change the logo size"><i className="fa fa-image" /></a>;
      }
    },
    renderEditTextOption: function() {
      if (this.props.editText) {
        return <a href="#" onClick={this.props.editText} className="btn btn-warning" data-content="Click to edit and format text"><i className="fa fa-pencil" /></a>;
      }
    },
    renderEditBackgroundOption: function() {
      if (this.props.editBackground) {
        return <a href="#" onClick={this.props.editBackground} className="btn btn-warning" title="Click to add or edit the background image" data-content="High resolution images look best"><i className="fa fa-area-chart" /></a>;
      }
    },
    renderEditImageOption: function() {
      if (this.props.editImage) {
        return <a href="#" onClick={this.props.editImage} className="btn btn-warning" title="Click to add or edit the main image" data-content="Highlight something specific with an image or embedded video"><i className="fa fa-photo" /> / <i className="fa fa-code" /></a>;
      }
    },
    renderEditLinkOption: function() {
      if (this.props.editLink) {
        return <a href="#" onClick={this.props.editLink} className="btn btn-warning" title="Add a linked button" data-content="Great for a primary call-to-action."><i className="fa fa-link" /></a>;
      }
    },
    renderEditCustomOption: function() {
      if (this.props.editCustom) {
        return <a href="#" onClick={this.props.editCustom} className="btn btn-warning" title="Adjust element specific settings" data-content="This gives you great control of certain aspects of the design."><i className="fa fa-cog" /></a>;
      }
    },
    renderSortOption: function() {
      if (this.props.sort) {
        return <a href="#" onClick={this.props.sort} className="btn btn-warning webpage-block-sort-handle" title="Click and drag to reorder the block" data-content="This give you control over how the blocks are sorted"><i className="fa fa-reorder" /></a>;
      }
    },
    renderRemoveBlockOption: function() {
      var warning;
      if (this.props.custom_class) {
        warning = "Are you sure? Hitting save after this change will delete this block and it's custom class(es) forever.";
      } else {
        warning = "Are you sure? Hitting save after this change will delete this block forever.";
      }
      if (this.props.removeBlock) {
        return <a href="#" onClick={this.props.removeBlock} className="btn btn-warning" title="Click to remove element" data-confirm={warning} data-content="Cannot be undone after saving the page"><i className="fa fa-trash" /></a>;
      }
    },
    renderNextThemeOption: function() {
      if (this.props.nextTheme) {
        return <a href="#" onClick={this.props.nextTheme} className="btn btn-warning" title="Cycle through layout options" data-content="Pick the layout that's right for you."><i className="fa fa-caret-right" /></a>;
      }
    },
    renderFooterEmbed: function() {
      if (this.props.footerEmbed) {
        return <a href="#" className="btn btn-warning add-footer-embed" title="Add Custom Site Footer Embed" data-content="Appears immediately above site footer." data-toggle="modal" data-target="#footer-embed-modal"><i className="fa fa-cog" /></a>;
      }
    },
    renderBlock: function() {
      switch (this.props.type) {
        case 'HeroBlock':
          return <HeroBlock {...this.props} />;
        case 'TaglineBlock':
          return <TaglineBlock {...this.props} />;
        case 'CallToActionBlock':
          return <CallToActionBlock {...this.props} />;
        case 'ContentBlock':
          return <ContentBlock {...this.props} />;
        case 'BlogFeedBlock':
          return <BlogFeedBlock {...this.props} />;
        case 'ReviewsBlock':
          return <ReviewsBlock {...this.props} />;
        case 'SidebarContentBlock':
          return <SidebarContentBlock {...this.props} />;
        case 'SidebarBlogFeedBlock':
          return <SidebarBlogFeedBlock {...this.props} />;
        case 'SidebarEventsFeedBlock':
          return <SidebarEventsFeedBlock {...this.props} />;
        case 'SidebarReviewsBlock':
          return <SidebarReviewsBlock {...this.props} />;
        case 'AboutBlock':
          return <AboutBlock {...this.props} />;
        case 'TeamBlock':
          return <TeamBlock {...this.props} />;
        case 'ContactBlock':
          return <ContactBlock {...this.props} />;
        case 'HeaderBlock':
          return <HeaderBlock {...this.props} />;
        case 'FooterBlock':
          return <FooterBlock {...this.props} />;
      }
    }
  });

  window.Block = Block;

}).call(this);
