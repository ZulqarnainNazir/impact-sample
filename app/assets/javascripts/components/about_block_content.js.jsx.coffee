AboutBlockContent = React.createClass
  mixins: [BackgroundImageCSS]

  render: ->
    switch this.props.theme
      when 'left'
        this.renderLeft()
      else
        this.renderBanner()

  renderLeft: ->
    `<div style={{marginLeft: -15, marginRight: -15}}>
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
    `<div style={{marginLeft: -15, marginRight: -15}}>
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
    `<h2>
      <RichTextEditor enabled={this.props.editing && this.props.richText} html={this.props.heading} inline={true} update={this.props.updateHeading} />
    </h2>`

  renderSubheading: ->
    `<RichTextEditor enabled={this.props.editing && this.props.richText} html={this.props.subheading} inline={true} update={this.props.updateSubheading} />`

  renderText: ->
    `<RichTextEditor enabled={this.props.editing && this.props.richText} html={this.props.text} update={this.props.updateText} />`

  renderImage: ->
    if this.props.image_placement_kind is 'embeds'
      `<div key="imageEmbed" style={{overflow: 'hidden'}} dangerouslySetInnerHTML={{__html: this.props.image_placement_embed}} />`
    else if this.props.image_url and this.props.image_url.length > 0
      `<img className="img-responsive" src={this.props.image_url} alt={this.props.image_alt} title={this.props.image_title} style={{width: '100%'}}/>`
    else if this.props.editing
      `<div>
        <ImageEmpty />
      </div>`

window.AboutBlockContent = AboutBlockContent
