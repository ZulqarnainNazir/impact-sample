AboutBlockContent = React.createClass
  mixins: [BackgroundImageCSS]

  render: ->
    switch this.props.theme
      when 'left'
        this.renderLeft()
      else
        this.renderBanner()

  renderLeft: ->
    `<div>
      <div className="container">
        <article>
          <header className="page-header">
            <h1>About</h1>
          </header>
        </article>
      </div>
      <div className="container">
        <article>
          <div className="row">
            <section className="col-sm-4" style={{marginTop: 40}}>
              {this.renderImage()}
              <img className="img-responsive" style={{width: '100%'}} src={this.props.background} />
            </section>
            <section className="col-sm-8">
              <header className="page-header">
                {this.renderHeading()}
                {this.renderSubheading()}
              </header>
              {this.renderText()}
            </section>
          </div>
        </article>
      </div>
    </div>`

  renderBanner: ->
    `<div>
      <div className="container">
        <article>
          <header className="page-header">
            <h1>About</h1>
          </header>
        </article>
      </div>
      {this.renderImage()}
      <div className="container">
        <article>
          <header className="page-header">
            {this.renderHeading()}
            {this.renderSubheading()}
          </header>
          {this.renderText()}
        </article>
      </div>
    </div>`

  renderHeading: ->
    if this.props.heading and this.props.heading.length > 0
      `<h2>{this.props.heading}</h2>`

  renderSubheading: ->
    if this.props.subheading and this.props.subheading.length > 0
      `<p>{this.props.subheading}</p>`

  renderText: ->
    if this.props.text and this.props.text.length > 0
      `<p>{this.props.text}</p>`

  renderImage: ->
    if this.props.image_url and this.props.image_url.length > 0
      `<img className="img-responsive" src={this.props.image_url} alt={this.props.image_alt} title={this.props.image_title} />`
    else if this.props.editing
      `<div>
        <ImageEmpty />
      </div>`

window.AboutBlockContent = AboutBlockContent
