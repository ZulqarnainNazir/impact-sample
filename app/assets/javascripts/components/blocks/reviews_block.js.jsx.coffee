ReviewsBlock = React.createClass
  render: ->
    `<div className="webpage-block-representer">
      <p style={{fontSize: 30}}>Most Recent Reviews</p>
      <p style={{fontSize: 16}}><a href={this.props.reviewsPath} target="_blank" style={{color: '#337AB7', textDecoration: 'underline'}}>View Recent Reviews</a></p>
    </div>`

window.ReviewsBlock = ReviewsBlock
