ThemeHeaderLogoAboveDesigner = React.createClass
  getDefaultProps: ->
    collapse = "collapse-#{parseInt(Math.random() * 1000000)}"
    collapseID: collapse
    collapseTarget: '#' + collapse

  render: ->
    className = "navbar navbar-logo-above"
    className += " navbar-inverse" if this.props.style is 'dark'
    className += " navbar-default" if this.props.style is 'light'

    `<div>
      <div className="container header-logo-above">
        <div className="navbar-header">
          <button type="button" className="navbar-toggle collapsed" data-toggle="collapse" data-target={this.props.collapseTarget}>
            <span className="sr-only">Toggle Navigation</span>
            <span className="icon-bar"></span>
            <span className="icon-bar"></span>
            <span className="icon-bar"></span>
          </button>
          <a className="navbar-brand" href="#">
            <Image src={this.props.logoMedium} alt={this.props.name} />
          </a>
        </div>
        <div className="navbar-right vcard navbar-vcard">
          <p className="h4 tel">{this.props.phoneNumber}</p>
          <p className="adr">{this.props.addressLineOne} <br /> {this.props.addressLineTwo}</p>
        </div>
      </div>
      <div className="container">
        <nav className={className} role="navigation">
          <div className="collapse navbar-collapse" id={this.props.collapseID}>
            <UnorderedList items={this.props.pages} className="nav navbar-nav" />
          </div>
        </nav>
      </div>
    </div>`

window.ThemeHeaderLogoAboveDesigner = ThemeHeaderLogoAboveDesigner
