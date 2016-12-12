(function() {
  var AboutBlock;

  AboutBlock = React.createClass({
    render: function() {
      return <div className="webpage-about">
      <article>
        <header className="page-header">
          <h1>About</h1>
        </header>
      </article>
      {this.renderInterior()}
    </div>;
    },
    renderInterior: function() {
      switch (this.props.theme) {
        case 'left':
          return this.renderLeft();
        default:
          return this.renderBanner();
      }
    },
    renderLeft: function() {
      return <div className="row">
      <section className="col-sm-4" style={{marginTop: 40}}>
        <BlockImagePlacement {...this.props.block_image_placement} editing={this.props.editing} version="medium" />
      </section>
      <section className="col-sm-8">
        <div className="page-header">
          <h2>
            <RichTextEditor enabled={this.props.editing && this.props.richText} html={this.props.heading} inline={true} update={this.props.updateHeading} />
          </h2>
          <RichTextEditor enabled={this.props.editing && this.props.richText} html={this.props.subheading} inline={true} update={this.props.updateSubheading} />
        </div>
        <RichTextEditor enabled={this.props.editing && this.props.richText} html={this.props.text} update={this.props.updateText} />
      </section>
    </div>;
    },
    renderBanner: function() {
      return <div>
      {this.renderBackgroundImage()}
      <div className="page-header">
        <h2>
          <RichTextEditor enabled={this.props.editing && this.props.richText} html={this.props.heading} inline={true} update={this.props.updateHeading} />
        </h2>
        <RichTextEditor enabled={this.props.editing && this.props.richText} html={this.props.subheading} inline={true} update={this.props.updateSubheading} />
      </div>
      <RichTextEditor enabled={this.props.editing && this.props.richText} html={this.props.text} update={this.props.updateText} />
    </div>;
    },
    renderBackgroundImage: function() {
      if (this.props.block_background_placement && this.props.block_background_placement.image_attachment_url.length > 0) {
        return <img src={this.props.block_background_placement.image_attachment_url} alt={this.props.block_background_placement.image_alt} title={this.props.block_background_placement.image_title} style={{width: '100%'}}/>;
      }
    }
  });

  window.AboutBlock = AboutBlock;

}).call(this);
