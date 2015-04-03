SpecialtyBlockContent = React.createClass
  mixins: [BackgroundImageCSS]

  render: ->
    className = 'col-sm-7 col-md-6'
    className += ' pull-right' if this.props.theme is 'right'

    `<div>
      <p className="lead text-center">{this.props.heading}</p>
      <hr />
      <div className="row">
        <div className={className}>
          {this.renderImage()}
        </div>
        <div className="col-sm-5 col-md-6">
          <p dangerouslySetInnerHTML={{__html: this.props.text}} />
        </div>
      </div>
    </div>`

  renderImage: ->
    if this.props.image_url and this.props.image_url.length > 0
      `<img className="img-responsive" src={this.props.image_url} alt={this.props.image_alt} title={this.props.image_title} style={{width: '100%'}}/>`
    else if this.props.editing
      `<div>
        <ImageEmpty />
      </div>`

window.SpecialtyBlockContent = SpecialtyBlockContent
