ThemeHeaderCenterDesigner = React.createClass
  mixins: [BackgroundImageCSS]

  getDefaultProps: ->
    collapse = "collapse-#{parseInt(Math.random() * 1000000)}"
    collapseID: collapse
    collapseTarget: '#' + collapse

  render: ->
    className = "navbar navbar-static-top header-centered"
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
          <a className="navbar-brand" href="#" style={{backgroundImage: this.backgroundImageCSS(this.props.logoSmall)}}>
            {this.props.name}
          </a>
        </div>
        <div className="collapse navbar-collapse" id={this.props.collapseID}>
          <UnorderedList items={this.props.pages} className="nav navbar-nav navbar-centered" />
        </div>
      </div>
    </nav>`

window.ThemeHeaderCenterDesigner = ThemeHeaderCenterDesigner
