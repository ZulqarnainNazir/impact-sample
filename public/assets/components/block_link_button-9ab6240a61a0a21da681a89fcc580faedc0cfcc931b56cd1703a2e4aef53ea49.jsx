(function() {
  var BlockLinkButton;

  BlockLinkButton = React.createClass({
    render: function() {
      if (this.props.link_version !== 'link_none' && this.props.link_label && this.props.link_label.length > 0) {
        return <p><a className="btn btn-primary btn-lg" href="#" role="button">{this.props.link_label}</a></p>;
      } else {
        return <div />;
      }
    }
  });

  window.BlockLinkButton = BlockLinkButton;

}).call(this);
