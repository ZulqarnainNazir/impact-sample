(function() {
  var BlogFeedBlock;

  BlogFeedBlock = React.createClass({
    render: function() {
      return <div className="webpage-block-representer">
      <p style={{fontSize: 30}}>Top <strong>{this.props.items_limit}</strong> Blog Feed Items</p>
      <p style={{fontSize: 16}}><a href={this.props.contents_path} target="_blank" style={{color: '#337AB7', textDecoration: 'underline'}}>View Recent Content</a></p>
    </div>;
    }
  });

  window.BlogFeedBlock = BlogFeedBlock;

}).call(this);
