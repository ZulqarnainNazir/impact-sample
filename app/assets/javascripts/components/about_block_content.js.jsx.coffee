AboutBlockContent = React.createClass
  render: ->
    `<div style={{marginLeft: -15, marginRight: -15}}>
      <div className="container">
        <article>
          <header className="page-header">
            <h1>About</h1>
          </header>
        </article>
      </div>
      {this.renderInterior()}
    </div>`

  renderInterior: ->
    switch this.props.theme
      when 'left'
        this.renderLeft()
      else
        this.renderBanner()

  renderLeft: ->
    `<div className="container">
      <article>
        <div className="row">
          <section className="col-sm-4" style={{marginTop: 40}}>
            <BlockImagePlacement {...this.props.block_image_placement} editing={this.props.editing} />
          </section>
          <section className="col-sm-8">
            <header className="page-header">
              <h2>
                <RichTextEditor enabled={this.props.editing && this.props.richText} html={this.props.heading} inline={true} update={this.props.updateHeading} />
              </h2>
              <RichTextEditor enabled={this.props.editing && this.props.richText} html={this.props.subheading} inline={true} update={this.props.updateSubheading} />
            </header>
            <RichTextEditor enabled={this.props.editing && this.props.richText} html={this.props.text} update={this.props.updateText} />
          </section>
        </div>
      </article>
    </div>`

  renderBanner: ->
    `<div>
      {this.renderBackgroundImage()}
      <div className="container">
        <article>
          <header className="page-header">
            <h2>
              <RichTextEditor enabled={this.props.editing && this.props.richText} html={this.props.heading} inline={true} update={this.props.updateHeading} />
            </h2>
            <RichTextEditor enabled={this.props.editing && this.props.richText} html={this.props.subheading} inline={true} update={this.props.updateSubheading} />
          </header>
          <RichTextEditor enabled={this.props.editing && this.props.richText} html={this.props.text} update={this.props.updateText} />
        </article>
      </div>
    </div>`

  renderBackgroundImage: ->
    if this.props.block_background_placement and this.props.block_background_placement and this.props.block_background_placement.image_url > 0
      `<img src={this.props.image_url} alt={this.props.image_alt} title={this.props.image_title} style={{width: '100%'}}/>`

window.AboutBlockContent = AboutBlockContent
