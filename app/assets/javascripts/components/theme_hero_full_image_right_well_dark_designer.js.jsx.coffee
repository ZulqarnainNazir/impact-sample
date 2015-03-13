ThemeHeroFullImageRightWellDarkDesigner = React.createClass
  mixins: [BackgroundImageCSS]

  render: ->
    className = "jumbotron hero-full"
    className += " hero-dark" if this.props.style is 'dark'

    `<div className={className} style={{backgroundImage: this.backgroundImageCSS(this.props.background)}}>
      <div className="row">
        <div className="col-sm-6 col-sm-offset-6 col-md-5 col-md-offset-7">
          <div className="well well-dark">
            <h1><ContentEditable html={this.props.title} onChange={this.props.changeTitle} /></h1>
            <p><ContentEditable html={this.props.text} onChange={this.props.changeText} /></p>
            <p><a className="btn btn-primary btn-lg" href="#" role="button">
              <ContentEditable html={this.props.button} onChange={this.props.changeButton} />
            </a></p>
          </div>
        </div>
      </div>
    </div>`

window.ThemeHeroFullImageRightWellDarkDesigner = ThemeHeroFullImageRightWellDarkDesigner
