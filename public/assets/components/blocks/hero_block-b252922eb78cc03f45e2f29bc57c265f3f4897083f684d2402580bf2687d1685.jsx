(function() {
  var HeroBlock;

  HeroBlock = React.createClass({
    render: function() {
      var style;
      style = {
        backgroundColor: this.props.background_color,
        color: this.props.foreground_color,
        height: parseInt(this.props.groupHeight) > 0 ? parseInt(this.props.groupHeight) : 'auto'
      };
      if (this.props.block_background_placement && this.props.block_background_placement.image_attachment_jumbo_url && this.props.block_background_placement.image_attachment_jumbo_url.length > 0) {
        style['backgroundImage'] = "url(\"" + this.props.block_background_placement.image_attachment_jumbo_url + "\")";
      } else if (this.props.block_background_placement && this.props.block_background_placement.image_attachment_url && this.props.block_background_placement.image_attachment_url.length > 0) {
        style['backgroundImage'] = "url(\"" + this.props.block_background_placement.image_attachment_url + "\")";
      }
      return <div className="webpage-hero">
      <div className="jumbotron" style={style}>
        <div className={this.containerClass()}>
          {this.renderInterior()}
        </div>
      </div>
    </div>;
    },
    renderInterior: function() {
      switch (this.props.theme) {
        case 'right':
          return <div className="row">
          <div key="content" className="col-sm-6">
            <div className={this.wellClass()} style={{color: this.props.foreground_color}}>
              <h1><RichTextEditor enabled={this.props.editing && this.props.richText} html={this.props.heading} inline={true} update={this.props.updateHeading} /></h1>
              <RichTextEditor enabled={this.props.editing && this.props.richText} html={this.props.text} update={this.props.updateText} />
              <BlockLinkButton {...this.props} />
            </div>
          </div>
          <div key="image" className="col-sm-6">
            <BlockImagePlacement {...this.props.block_image_placement} editing={this.props.editing} version="medium" copy={true} />
          </div>
        </div>;
        case 'left':
          return <div className="row">
          <div key="image" className="col-sm-6">
            <BlockImagePlacement {...this.props.block_image_placement} editing={this.props.editing} version="medium" copy={true} />
          </div>
          <div key="content" className="col-sm-6">
            <div className={this.wellClass()} style={{color: this.props.foreground_color}}>
              <h1><RichTextEditor enabled={this.props.editing && this.props.richText} html={this.props.heading} inline={true} update={this.props.updateHeading} /></h1>
              <RichTextEditor enabled={this.props.editing && this.props.richText} html={this.props.text} update={this.props.updateText} />
              <BlockLinkButton {...this.props} />
            </div>
          </div>
        </div>;
        default:
          return <div className={this.wellClass()} style={{color: this.props.foreground_color}}>
          <h1><RichTextEditor enabled={this.props.editing && this.props.richText} html={this.props.heading} inline={true} update={this.props.updateHeading} /></h1>
          <RichTextEditor enabled={this.props.editing && this.props.richText} html={this.props.text} update={this.props.updateText} />
          <BlockLinkButton {...this.props} />
        </div>;
      }
    },
    containerClass: function() {
      if (this.props.kind === 'full_width') {
        return 'container';
      } else {
        return '';
      }
    },
    wellClass: function() {
      switch (this.props.well_style) {
        case 'transparent':
          return 'well well-transparent';
        case 'dark':
          return 'well well-dark';
        default:
          return 'well well-light';
      }
    }
  });

  window.HeroBlock = HeroBlock;

}).call(this);
