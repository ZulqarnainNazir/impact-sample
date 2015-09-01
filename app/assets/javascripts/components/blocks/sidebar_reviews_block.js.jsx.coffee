SidebarReviewsBlock = React.createClass
  render: ->
    `<div className="webpage-block-representer">
      <p style={{fontSize: 20}}>Most Recent Reviews</p>
      <p style={{fontSize: 14}}><a href={this.props.reviews_path} target="_blank" style={{color: '#337AB7', textDecoration: 'underline'}}>View Recent Reviews</a></p>
    </div>`

window.SidebarReviewsBlock = SidebarReviewsBlock
