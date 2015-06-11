HeroBlockContent = React.createClass
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

    `<div className={className} style={{backgroundColor: this.props.background_color, backgroundColor: this.props.background_color, backgroundImage: this.backgroundImageCSS()}}>
      <div>
        <div className="webpage-block-col-6-offset webpage-block-col-6">
          <div className="well well-dark">
            {this.renderHeading()}
            {this.renderText()}
            <BlockLinkButton {...this.props} />
          </div>
        </div>
      </div>
    </div>`

  renderWell: ->
    className = "jumbotron hero-full"
    className += " hero-dark" if this.props.style is 'dark'

    `<div className={className} style={{backgroundColor: this.props.background_color, backgroundColor: this.props.background_color, backgroundImage: this.backgroundImageCSS()}}>
      <div>
        <div className="webpage-block-col-6-offset webpage-block-col-6">
          <div className="well">
            {this.renderHeading()}
            {this.renderText()}
            <BlockLinkButton {...this.props} />
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
          <BlockImagePlacement {...this.props.block_image_placement} editing={this.props.editing} />
        </div>
        <div className="webpage-block-col-6">
          {this.renderHeading()}
          {this.renderText()}
          <BlockLinkButton {...this.props} />
        </div>
      </div>
    </div>`

  renderRight: ->
    className = "jumbotron hero-full"
    className += " hero-dark" if this.props.style is 'dark'

    `<div className={className} style={{backgroundColor: this.props.background_color, backgroundColor: this.props.background_color, backgroundImage: this.backgroundImageCSS()}}>
      <div>
        <div className="webpage-block-col-6-offset webpage-block-col-6">
          {this.renderHeading()}
          {this.renderText()}
          <BlockLinkButton {...this.props} />
        </div>
      </div>
    </div>`

  renderFull: ->
    className = "jumbotron hero-full"
    className += " hero-dark" if this.props.style is 'dark'

    `<div className={className} style={{backgroundColor: this.props.background_color, backgroundColor: this.props.background_color, backgroundImage: this.backgroundImageCSS()}}>
      {this.renderHeading()}
      {this.renderText()}
      <BlockLinkButton {...this.props} />
    </div>`

  renderForm: ->
    className = "jumbotron hero-full"
    className += " hero-dark" if this.props.style is 'dark'

    `<div className={className} style={{backgroundColor: this.props.background_color, backgroundColor: this.props.background_color, backgroundImage: this.backgroundImageCSS()}}>
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
            <BlockLinkButton {...this.props} />
          </div>
        </div>
      </div>
    </div>`

  renderHeading: ->
    `<h1 style={{color: this.props.foreground_color}}>
      <RichTextEditor enabled={this.props.editing && this.props.richText} html={this.props.heading} inline={true} update={this.props.updateHeading} />
    </h1>`

  renderText: ->
    `<div style={{color: this.props.foreground_color}}>
      <RichTextEditor enabled={this.props.editing && this.props.richText} html={this.props.text} update={this.props.updateText} />
    </div>`

  backgroundImageCSS: ->
    if this.props.block_background_placement and this.props.block_background_placement.image_url and this.props.block_background_placement.image_url.length > 0
      "url(\"#{url}\")"

window.HeroBlockContent = HeroBlockContent
