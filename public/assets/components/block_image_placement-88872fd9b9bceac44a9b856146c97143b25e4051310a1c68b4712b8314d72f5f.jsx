(function() {
  var BlockImagePlacement;

  BlockImagePlacement = React.createClass({
    render: function() {
      if (this.props.kind === 'embeds') {
        return <div key="imageEmbed" style={{marginBottom: 15, overflow: 'hidden'}} dangerouslySetInnerHTML={{__html: this.props.embed}} />;
      } else if (this.imageURL().length > 0) {
        return <img className="center-block img-responsive thumbnail" src={this.imageURL()} alt={this.props.image_alt} title={this.props.image_title} style={{marginBottom: 15, maxWidth: '100%'}}/>;
      } else if (this.props.editing) {
        return <div style={{marginBottom: 15}}>
        <ImageEmpty copy={this.props.copy} />
      </div>;
      } else {
        return <div />;
      }
    },
    imageURL: function() {
      var imageVersionURL;
      imageVersionURL = (function() {
        switch (this.props.version) {
          case 'jumbo':
            if (this.props.full_width) {
              return this.props.image_attachment_jumbo_fixed_url;
            } else {
              return this.props.image_attachment_jumbo_url;
            }
            break;
          case 'large':
            if (this.props.full_width) {
              return this.props.image_attachment_large_fixed_url;
            } else {
              return this.props.image_attachment_large_url;
            }
            break;
          case 'medium':
            if (this.props.full_width) {
              return this.props.image_attachment_medium_fixed_url;
            } else {
              return this.props.image_attachment_medium_url;
            }
            break;
          case 'small':
            if (this.props.full_width) {
              return this.props.image_attachment_small_fixed_url;
            } else {
              return this.props.image_attachment_small_url;
            }
            break;
          case 'thumbnail':
            if (this.props.full_width) {
              return this.props.image_attachment_thumbnail_fixed_url;
            } else {
              return this.props.image_attachment_thumbnail_url;
            }
        }
      }).call(this);
      if (imageVersionURL && imageVersionURL.length > 0) {
        return imageVersionURL;
      } else {
        return this.props.image_attachment_url || '';
      }
    }
  });

  window.BlockImagePlacement = BlockImagePlacement;

}).call(this);
