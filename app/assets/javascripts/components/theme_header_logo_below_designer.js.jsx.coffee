ThemeHeaderLogoBelowDesigner = React.createClass
  mixins: [BackgroundImageCSS]

  getDefaultProps: ->
    collapse = "collapse-#{parseInt(Math.random() * 1000000)}"
    collapseID: collapse
    collapseTarget: '#' + collapse

  render: ->
    className = "navbar navbar-static-top"
    className += " navbar-inverse" if this.props.style is 'dark'
    className += " navbar-default" if this.props.style is 'light'

    `<div>
      <nav className={className} role="navigation">
        <div className="container">
          <div className="navbar-header">
            <button type="button" className="navbar-toggle collapsed" data-toggle="collapse" data-target={this.props.collapseTarget}>
              <span className="sr-only">Toggle Navigation</span>
              <span className="icon-bar"></span>
              <span className="icon-bar"></span>
              <span className="icon-bar"></span>
            </button>
          </div>
          <div className="collapse navbar-collapse" id={this.props.collapseID}>
            <UnorderedList items={this.props.pages} className="nav navbar-nav" />
          </div>
        </div>
      </nav>
      <div className="container header-logo-below">
        {this.renderNavbarBrand()}
      </div>
    </div>`

  renderNavbarBrand: ->
    backgroundUrl = this.props.background or this.props.logoLarge
    if backgroundUrl
      `<a className="navbar-brand navbar-brand-image" href="#">
        <img src={backgroundUrl} alt={this.props.name} />
      </a>`
    else
      `<a className="navbar-brand" href="#">
        {this.props.name}
      </a>`

window.ThemeHeaderLogoBelowDesigner = ThemeHeaderLogoBelowDesigner
