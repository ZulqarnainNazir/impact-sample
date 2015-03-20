ThemeHeaderLogoCenterDesigner = React.createClass
  mixins: [BackgroundImageCSS]

  getDefaultProps: ->
    collapse = "collapse-#{parseInt(Math.random() * 1000000)}"
    collapseID: collapse
    collapseTarget: '#' + collapse

  navLists: ->
    result = []
    if this.props.pages.length > 0
      i = Math.ceil(this.props.pages.length / 2)
      leftPages = this.props.pages.slice(0, i)
      rightPages = this.props.pages.slice(i, this.props.pages.length)
      if leftPages.length > 0
        result.push `<UnorderedList key="left" items={leftPages} className="nav navbar-nav navbar-left" />`
      if rightPages.length > 0
        result.push `<UnorderedList key="right" items={rightPages} className="nav navbar-nav navbar-right" />`
    result

  render: ->
    className = "navbar navbar-static-top header-centered-logo"
    className += " navbar-inverse" if this.props.style is 'dark'
    className += " navbar-default" if this.props.style is 'light'

    `<nav className={className} role="navigation">
      <div className="container">
        <div className="navbar-header">
          <button type="button" className="navbar-toggle collapsed" data-toggle="collapse" data-target={this.props.collapseTarget}>
            <span className="sr-only">Toggle Navigation</span>
            <span className="icon-bar"></span>
            <span className="icon-bar"></span>
            <span className="icon-bar"></span>
          </button>
          {this.renderNavbarBrand()}
        </div>
        <div className="collapse navbar-collapse" id={this.props.collapseID}>
          {this.navLists()}
        </div>
      </div>
    </nav>`

  renderNavbarBrand: ->
    backgroundUrl = this.props.background or this.props.logoSmall
    if backgroundUrl
      `<a className="navbar-brand navbar-brand-image" href="#" style={{backgroundImage: this.backgroundImageCSS(backgroundUrl)}}>
        {this.props.name}
      </a>`
    else
      `<a className="navbar-brand" href="#">
        {this.props.name}
      </a>`

window.ThemeHeaderLogoCenterDesigner = ThemeHeaderLogoCenterDesigner
