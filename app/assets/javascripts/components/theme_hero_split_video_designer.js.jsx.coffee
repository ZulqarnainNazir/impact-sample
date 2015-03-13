ThemeHeroSplitVideoDesigner = React.createClass
  mixins: [BackgroundImageCSS]

  render: ->
    className = "jumbotron hero-split"
    className += " hero-dark" if this.props.style is 'dark'

    `<div className={className}>
      <div className="row">
        <div className="col-sm-6 col-md-7">
          <iframe width="560" height="315" src="https://www.youtube.com/embed/wyFat0rZTKg" frameBorder="0" allowFullScreen></iframe>
        </div>
        <div className="col-sm-6 col-md-5">
          <h1><ContentEditable html={this.props.title} onChange={this.props.changeTitle} /></h1>
          <p><ContentEditable html={this.props.text} onChange={this.props.changeText} /></p>
          <p><a className="btn btn-primary btn-lg" href="#" role="button">
            <ContentEditable html={this.props.button} onChange={this.props.changeButton} />
          </a></p>
        </div>
      </div>
    </div>`

window.ThemeHeroSplitVideoDesigner = ThemeHeroSplitVideoDesigner
