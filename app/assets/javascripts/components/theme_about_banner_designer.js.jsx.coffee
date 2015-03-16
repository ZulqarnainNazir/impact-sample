ThemeAboutBannerDesigner = React.createClass
  render: ->
    `<div>
      <div className="container">
        <article>
          <header className="page-header">
            <h1>About</h1>
          </header>
        </article>
      </div>
      <img className="img-responsive" style={{width: '100%'}} src={this.props.background} />
      <div className="container">
        <article>
          <header className="page-header">
            <h2><ContentEditable html={this.props.heading} onChange={this.props.changeHeading} /></h2>
            <p><ContentEditable html={this.props.subheading} onChange={this.props.changeSubheading} /></p>
          </header>
          <p><ContentEditable html={this.props.text} onChange={this.props.changeText} /></p>
        </article>
      </div>
    </div>`

window.ThemeAboutBannerDesigner = ThemeAboutBannerDesigner
