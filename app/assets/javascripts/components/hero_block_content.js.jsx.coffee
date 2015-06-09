HeroBlockContent = React.createClass
  mixins: [BackgroundImageCSS]

  render: ->
    `<div className="webpage-hero">
      {this.renderInterior()}
    </div>`

  renderInterior: ->
    switch this.props.theme
      when 'right'
        this.renderRight()
      when 'well'
        this.renderWell()
      when 'well_dark'
        this.renderWellDark()
      when 'form'
        this.renderForm()
      when 'split_image'
        this.renderSplitImage()
      else
        this.renderFull()

  renderWellDark: ->
    className = "jumbotron hero-full"
    className += " hero-dark" if this.props.style is 'dark'

    `<div className={className} style={{backgroundColor: this.props.background_color, backgroundColor: this.props.background_color, backgroundImage: this.backgroundImageCSS(this.props.image_url)}}>
      <div>
        <div className="webpage-block-col-6-offset webpage-block-col-6">
          <div className="well well-dark">
            {this.renderHeading()}
            {this.renderText()}
            {this.renderButton()}
          </div>
        </div>
      </div>
    </div>`

  renderWell: ->
    className = "jumbotron hero-full"
    className += " hero-dark" if this.props.style is 'dark'

    `<div className={className} style={{backgroundColor: this.props.background_color, backgroundColor: this.props.background_color, backgroundImage: this.backgroundImageCSS(this.props.image_url)}}>
      <div>
        <div className="webpage-block-col-6-offset webpage-block-col-6">
          <div className="well">
            {this.renderHeading()}
            {this.renderText()}
            {this.renderButton()}
          </div>
        </div>
      </div>
    </div>`

  renderSplitImage: ->
    className = "jumbotron hero-split"
    className += " hero-dark" if this.props.style is 'dark'

    `<div className={className} style={{backgroundColor: this.props.background_color}}>
      <div>
        <div className="webpage-block-col-6">
          {this.renderImage()}
        </div>
        <div className="webpage-block-col-6">
          {this.renderHeading()}
          {this.renderText()}
          {this.renderButton()}
        </div>
      </div>
    </div>`

  renderRight: ->
    className = "jumbotron hero-full"
    className += " hero-dark" if this.props.style is 'dark'

    `<div className={className} style={{backgroundColor: this.props.background_color, backgroundColor: this.props.background_color, backgroundImage: this.backgroundImageCSS(this.props.image_url)}}>
      <div>
        <div className="webpage-block-col-6-offset webpage-block-col-6">
          {this.renderHeading()}
          {this.renderText()}
          {this.renderButton()}
        </div>
      </div>
    </div>`

  renderFull: ->
    className = "jumbotron hero-full"
    className += " hero-dark" if this.props.style is 'dark'

    `<div className={className} style={{backgroundColor: this.props.background_color, backgroundColor: this.props.background_color, backgroundImage: this.backgroundImageCSS(this.props.image_url)}}>
      {this.renderHeading()}
      {this.renderText()}
      {this.renderButton()}
    </div>`

  renderForm: ->
    className = "jumbotron hero-full"
    className += " hero-dark" if this.props.style is 'dark'

    `<div className={className} style={{backgroundColor: this.props.background_color, backgroundColor: this.props.background_color, backgroundImage: this.backgroundImageCSS(this.props.image_url)}}>
      <div>
        <div className="webpage-block-col-6-offset webpage-block-col-6">
          <div className="well">
            {this.renderHeading()}
            <div className="form-group">
              <label className="control-label">Name</label>
              <input type="text" className="form-control" />
            </div>
            <div className="form-group">
              <label className="control-label">Email</label>
              <input type="email" className="form-control" />
            </div>
            {this.renderButton()}
          </div>
        </div>
      </div>
    </div>`

  renderHeading: ->
    `<h1 style={{color: this.props.foreground_color}}>
      <RichTextEditor enabled={this.props.editing && this.props.richText} html={this.props.heading} inline={true} update={this.props.updateHeading} />
    </h1>`

  renderImage: ->
    if this.props.image_url and this.props.image_url.length > 0
      `<img className="img-responsive" src={this.props.image_url} alt={this.props.image_alt} title={this.props.image_title} />`
    else if this.props.editing
      `<div>
        <ImageEmpty />
      </div>`

  renderText: ->
    `<div style={{color: this.props.foreground_color}}>
      <RichTextEditor enabled={this.props.editing && this.props.richText} html={this.props.text} update={this.props.updateText} />
    </div>`

  renderButton: ->
    if this.props.link_version != 'link_none' and this.props.link_label and this.props.link_label.length > 0
      `<p><a className="btn btn-primary btn-lg" href="#" role="button">{this.props.link_label}</a></p>`

window.HeroBlockContent = HeroBlockContent
