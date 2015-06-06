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
      when 'split_video'
        this.renderSplitVideo()
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

  renderSplitVideo: ->
    className = "jumbotron hero-split"
    className += " hero-dark" if this.props.style is 'dark'

    `<div className={className} style={{backgroundColor: this.props.background_color}}>
      <div>
        <div className="webpage-block-col-6">
          <iframe width="560" height="315" src="https://www.youtube.com/embed/wyFat0rZTKg" frameBorder="0" allowFullScreen></iframe>
        </div>
        <div className="webpage-block-col-6">
          {this.renderHeading()}
          {this.renderText()}
          {this.renderButton()}
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
    `<h1 style={{color: this.props.foreground_color}}>{this.heading(this.props.heading)}</h1>`

  renderImage: ->
    if this.props.image_url and this.props.image_url.length > 0
      `<img className="img-responsive" src={this.props.image_url} alt={this.props.image_alt} title={this.props.image_title} />`
    else if this.props.editing
      `<div>
        <ImageEmpty />
      </div>`

  renderText: ->
    `<div style={{color: this.props.foreground_color}} dangerouslySetInnerHTML={{__html: this.text(this.props.text)}} />`

  renderButton: ->
    if this.props.link_version != 'link_none' and this.props.link_label and this.props.link_label.length > 0
      `<p><a className="btn btn-primary btn-lg" href="#" role="button">{this.props.link_label}</a></p>`

  heading: (value) ->
    if value and value.length > 0
      value
    else
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit'

  text: (value) ->
    if value and value.length > 0
      value
    else
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum finibus ut tortor quis mattis. Donec sit amet hendrerit risus. Maecenas sed orci metus. Nulla viverra bibendum quam, eu ullamcorper felis dignissim sit amet. Pellentesque quis urna nec arcu malesuada accumsan. Nunc eu lacinia est. Vestibulum cursus consequat interdum.'

window.HeroBlockContent = HeroBlockContent
