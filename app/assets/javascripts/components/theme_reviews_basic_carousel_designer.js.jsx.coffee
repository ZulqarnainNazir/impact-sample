ThemeReviewsBasicCarouselDesigner = React.createClass
  getDefaultProps: ->
    carousel = "carousel-#{parseInt(Math.random * 1000000)}"
    carouselID: carousel
    carouselTarget: '#' + carousel

  render: ->
    `<div className="reviews reviews-full-width">
      <div className="container">
        <div className="row">
          <div className="col-md-offset-2 col-md-8">
            <br />
            <div id={this.props.carouselID} className="carousel slide" data-ride="carousel">
              <ExampleBasicReviews />
              <a className="left carousel-control" href={this.props.carouselTarget} role="button" data-slide="prev">
                <span className="glyphicon glyphicon-chevron-left"></span>
              </a>
              <a className="right carousel-control" href={this.props.carouselTarget} role="button" data-slide="next">
                <span className="glyphicon glyphicon-chevron-right"></span>
              </a>
            </div>
          </div>
        </div>
      </div>
    </div>`

window.ThemeReviewsBasicCarouselDesigner = ThemeReviewsBasicCarouselDesigner
