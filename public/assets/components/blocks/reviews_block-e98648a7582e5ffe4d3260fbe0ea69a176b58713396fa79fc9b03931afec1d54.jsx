(function() {
  var ReviewsBlock;

  ReviewsBlock = React.createClass({
    render: function() {
      return <div className="webpage-block-representer">
      <p style={{fontSize: 30}}>Most Recent Reviews</p>
      <p style={{fontSize: 16}}><a href={this.props.reviews_path} target="_blank" style={{color: '#337AB7', textDecoration: 'underline'}}>View Recent Reviews</a></p>
    </div>;
    }
  });

  window.ReviewsBlock = ReviewsBlock;

}).call(this);
