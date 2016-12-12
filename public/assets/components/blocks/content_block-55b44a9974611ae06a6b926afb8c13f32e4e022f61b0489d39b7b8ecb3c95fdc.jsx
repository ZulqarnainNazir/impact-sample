(function() {
  var ContentBlock;

  ContentBlock = React.createClass({
    render: function() {
      return <div className="webpage-content">
      {this.renderHeading()}
      {this.renderInterior()}
    </div>;
    },
    renderHeading: function() {
      if ((this.props.heading && this.props.heading.length > 0 && this.props.heading !== '<br>') || this.props.richText) {
        return <div>
        <div className="lead text-center">
          <RichTextEditor enabled={this.props.editing && this.props.richText} html={this.props.heading} inline={true} update={this.props.updateHeading} />
        </div>
        <hr />
      </div>;
      }
    },
    renderInterior: function() {
      switch (this.props.theme) {
        case 'text':
          return <RichTextEditor enabled={this.props.editing && this.props.richText} html={this.props.text} update={this.props.updateText} />;
        case 'image':
          return <BlockImagePlacement {...this.props.block_image_placement} editing={this.props.editing} version="jumbo" />;
        case 'left':
          return <div className="row">
          <div className="col-sm-8">
            <RichTextEditor enabled={this.props.editing && this.props.richText} html={this.props.text} update={this.props.updateText} />
          </div>
          <div className="col-sm-4">
            <BlockImagePlacement {...this.props.block_image_placement} editing={this.props.editing} version="small" />
          </div>
        </div>;
        case 'right':
          return <div className="row">
          <div className="col-sm-4">
            <BlockImagePlacement {...this.props.block_image_placement} editing={this.props.editing} version="small" />
          </div>
          <div className="col-sm-8">
            <RichTextEditor enabled={this.props.editing && this.props.richText} html={this.props.text} update={this.props.updateText} />
          </div>
        </div>;
        case 'left_half':
          return <div className="row">
          <div className="col-sm-6">
            <RichTextEditor enabled={this.props.editing && this.props.richText} html={this.props.text} update={this.props.updateText} />
          </div>
          <div className="col-sm-6">
            <BlockImagePlacement {...this.props.block_image_placement} editing={this.props.editing} version="small" />
          </div>
        </div>;
        case 'right_half':
          return <div className="row">
          <div className="col-sm-6">
            <BlockImagePlacement {...this.props.block_image_placement} editing={this.props.editing} version="small" />
          </div>
          <div className="col-sm-6">
            <RichTextEditor enabled={this.props.editing && this.props.richText} html={this.props.text} update={this.props.updateText} />
          </div>
        </div>;
      }
    }
  });

  window.ContentBlock = ContentBlock;

}).call(this);
