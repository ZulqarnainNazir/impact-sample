(function() {
  var ImageEmpty;

  ImageEmpty = React.createClass({
    propTypes: {
      padding: React.PropTypes.number,
      copy: React.PropTypes.bool,
      dropzone: React.PropTypes.bool
    },
    getDefaultPropTypes: {
      padding: 50,
      dropzone: false
    },
    render: function() {
      return <div className="webpage-image-empty well text-center text-muted" style={{padding: this.props.padding}}>
      <i className="fa fa-photo fa-3x" />
      {this.renderCopy()}
    </div>;
    },
    renderCopy: function() {
      if (this.props.dropzone === true) {
        return <div>
        <br />
        <span className="small">Drop an image here to begin upload...</span>
      </div>;
      } else if (this.props.copy === true) {
        return <div>
        <span style={{fontSize: 26}}>Add optional main image</span>
      </div>;
      }
    }
  });

  window.ImageEmpty = ImageEmpty;

}).call(this);
