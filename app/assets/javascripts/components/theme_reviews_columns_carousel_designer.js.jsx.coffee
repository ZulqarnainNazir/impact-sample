ThemeReviewsColumnsCarouselDesigner = React.createClass
  getDefaultProps: ->
    carousel = "carousel-#{parseInt(Math.random * 1000000)}"
    carouselID: carousel
    carouselTarget: '#' + carousel

  render: ->
    `<div className="reviews reviews-columns">
      <div className="container">
        <div id={this.props.carouselID} className="carousel slide" data-ride="carousel">
          <ExampleColumnsReviews />
          <a className="left carousel-control" href={this.props.carouselTarget} role="button" data-slide="prev">
            <span className="glyphicon glyphicon-chevron-left"></span>
          </a>
          <a className="right carousel-control" href={this.props.carouselTarget} role="button" data-slide="next">
            <span className="glyphicon glyphicon-chevron-right"></span>
          </a>
        </div>
      </div>
    </div>`

window.ThemeReviewsColumnsCarouselDesigner = ThemeReviewsColumnsCarouselDesigner
