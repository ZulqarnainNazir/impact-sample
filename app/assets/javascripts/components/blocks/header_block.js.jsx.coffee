HeaderBlock = React.createClass
  componentDidMount: ->
    this.centerLogo()
    setTimeout this.centerLogo, 5
    setTimeout this.centerLogo, 100

  componentDidUpdate: ->
    this.centerLogo()
    setTimeout this.centerLogo, 5
    setTimeout this.centerLogo, 100

  centerLogo: ->
    if $(window).width() > 768 and ['above', 'below'].indexOf(this.props.logo_vertical_position) is -1 and this.props.logo_horizontal_position is 'center' and this.props.navigation_horizontal_position is 'center'
      offset = $('.webpage-designer .navbar-brand').width() / 2 + 30
      if this.refs.leftNavbar
        $(this.refs.leftNavbar.getDOMNode()).css 'margin-right', "#{offset}px"
      if this.refs.rightNavbar
        $(this.refs.rightNavbar.getDOMNode()).css 'margin-left', "#{offset}px"

  render: ->
    lineHeight = if this.props.logo_height and ['above', 'below'].indexOf(this.props.logo_vertical_position) is -1 then parseInt(this.props.logo_height - 10) else 30
    navbarClassName = 'navbar'
    navbarClassName += ' navbar-default-top' if ['static', 'fixed'].indexOf(this.props.navbar_location) is -1
    navbarClassName += ' navbar-default-top-alone' if ['static', 'fixed'].indexOf(this.props.navbar_location) is -1 and ['above'].indexOf(this.props.logo_vertical_position) is -1 and ['left', 'right', 'full'].indexOf(this.props.contact_position) is -1
    navbarClassName += ' navbar-static-top' unless ['static', 'fixed'].indexOf(this.props.navbar_location) is -1
    navbarClassName += ' navbar-inverse' if this.props.style is 'dark'
    navbarClassName += ' navbar-transparent' if this.props.style is 'transparent'
    navbarClassName += ' navbar-default' if ['dark', 'transparent'].indexOf(this.props.style) is -1
    navbarHeaderClassName = 'navbar-header'
    navbarNavClassName = 'nav navbar-nav'

    if ['above', 'below'].indexOf(this.props.logo_vertical_position) is -1
      if this.props.logo_horizontal_position is 'center' and this.props.navigation_horizontal_position is 'center'
        navbarHeaderClassName += ' navbar-center'
      else if this.props.logo_horizontal_position is 'center'
        navbarHeaderClassName += ' navbar-center'
        navbarNavClassName += ' navbar-abs-right' if this.props.navigation_horizontal_position is 'right'
        navbarNavClassName += ' navbar-abs-left' if ['right'].indexOf(this.props.navigation_horizontal_position) is -1
      else if this.props.navigation_horizontal_position is 'center'
        navbarNavClassName += ' navbar-center'
        navbarHeaderClassName += ' navbar-abs-right' if this.props.logo_horizontal_position is 'right'
        navbarHeaderClassName += ' navbar-abs-left' if ['right'].indexOf(this.props.logo_horizontal_position) is -1
      else
        navbarHeaderClassName += ' navbar-right' if this.props.logo_horizontal_position is 'right'
        navbarHeaderClassName += ' navbar-left' if ['right'].indexOf(this.props.logo_horizontal_position) is -1
        navbarNavClassName += ' navbar-right' if this.props.navigation_horizontal_position is 'right'
        navbarNavClassName += ' navbar-left' if ['right'].indexOf(this.props.navigation_horizontal_position) is -1
    else
      navbarOutsideClassName = 'navbar-outside-right' if this.props.logo_horizontal_position is 'right'
      navbarOutsideClassName = 'navbar-outside-center' if this.props.logo_horizontal_position is 'center'
      navbarOutsideClassName = 'navbar-outside-left' if ['right', 'center'].indexOf(this.props.logo_horizontal_position) is -1
      navbarNavClassName += ' navbar-right' if this.props.navigation_horizontal_position is 'right'
      navbarNavClassName += ' navbar-center' if this.props.navigation_horizontal_position is 'center'
      navbarNavClassName += ' navbar-left' if ['right', 'center'].indexOf(this.props.navigation_horizontal_position) is -1

    navinterior =
      `<div>
        <div className={navbarHeaderClassName}>
          <span type="button" className="navbar-toggle collapsed" data-toggle="collapse" data-target="#header-navbar-collapse">
            <span className="sr-only">Toggle Navigation</span>
            <span className="icon-bar"></span>
            <span className="icon-bar"></span>
            <span className="icon-bar"></span>
          </span>
          {this.renderLogoInside()}
        </div>
        <div className="collapse navbar-collapse" id="header-navbar-collapse">
          {this.renderMainNav(navbarNavClassName, lineHeight)}
          {this.renderSplitNavs(lineHeight)}
        </div>
      </div>`

    navbar =
      if ['static', 'fixed'].indexOf(this.props.navbar_location) is -1
        `<div className="container">
          <nav className={navbarClassName} role="navigation">
            {navinterior}
          </nav>
        </div>`
      else
        `<nav className={navbarClassName} role="navigation">
          <div className="container">
            {navinterior}
          </div>
        </nav>`

    `<div className="webpage-header">
      <div className="container">
        {this.renderContact()}
        {this.renderLogoAbove(navbarOutsideClassName)}
      </div>
      {navbar}
      <div className="container">
        {this.renderLogoBelow(navbarOutsideClassName)}
      </div>
    </div>`

  renderLogoAbove: (className) ->
    if this.props.logo_vertical_position is 'above'
      `<div className={className}>
        {this.renderLogo()}
      </div>`

  renderLogoBelow: (className) ->
    if this.props.logo_vertical_position is 'below'
      `<div className={className}>
        {this.renderLogo()}
      </div>`

  renderLogoInside: ->
    this.renderLogo() if ['above', 'below'].indexOf(this.props.logo_vertical_position) is -1

  renderLogo: (size) ->
    if this.props.logo_height and parseInt(this.props.logo_height) > 0
      if parseInt(this.props.logo_height) > 125
        size = 'jumbo'
      else if parseInt(this.props.logo_height) > 60
        size = 'large'
      else if parseInt(this.props.logo_height) > 40
        size = 'medium'

    image = if size is 'jumbo' and this.props.logoJumbo and this.props.logoJumbo.length > 0
      `<img src={this.props.logoJumbo} alt={this.props.name} style={{height: this.props.logo_height, maxHeight: 200}} />`
    else if size is 'large' and this.props.logoLarge and this.props.logoLarge.length > 0
      `<img src={this.props.logoLarge} alt={this.props.name} style={{height: this.props.logo_height, maxHeight: 125}} />`
    else if size is 'medium' and this.props.logoMedium and this.props.logoMedium.length > 0
      `<img src={this.props.logoMedium} alt={this.props.name} style={{height: this.props.logo_height, maxHeight: 60}} />`
    else if this.props.logoSmall and this.props.logoSmall.length > 0
      `<img src={this.props.logoSmall} alt={this.props.name} style={{height: this.props.logo_height, maxHeight: 40}} />`

    if image
      `<a className="navbar-brand navbar-brand-image" href="#">{image}</a>`
    else
      `<a className="navbar-brand navbar-brand-text" href="#">{this.props.name.slice(0,44)}</a>`

  renderContact: ->
    if this.props.contact_position is 'left'
      `<div className="vcard navbar-vcard pull-left text-left">
        {this.renderContactPhone()}
        {this.renderContactAddress()}
      </div>`
    else if this.props.contact_position is 'right'
      `<div className="vcard navbar-vcard pull-right text-right">
        {this.renderContactPhone()}
        {this.renderContactAddress()}
      </div>`
    else if this.props.contact_position is 'full'
      `<div className="clearfix" style={{marginLeft: -10}}>
        <ul className="nav navbar-nav vcard text-left">
          {this.renderContactFullAddress()}
          {this.renderContactFullPhone()}
          {this.renderContactFullEmail()}
        </ul>
      </div>`

  renderContactPhone: ->
    unless this.props.hidePhone
      `<p className="h4 tel">{this.props.phone}</p>`

  renderContactAddress: ->
    unless this.props.hideAddress
      `<p className="adr">{this.props.addressLineOne} <br /> {this.props.addressLineTwo}</p>`

  renderContactFullAddress: ->
    unless this.props.hideAddress
      `<li><p className="navbar-text"><i className="fa fa-map-marker"></i> <span className="adr"><span className="street-address">{this.props.addressLineOne}</span>, <span className="locality">{this.props.addressLineTwo}</span></span></p></li>`

  renderContactFullPhone: ->
    unless this.props.hidePhone
      `<li><p className="navbar-text"><i className="fa fa-phone"></i> <span className="tel">{this.props.phone}</span></p></li>`

  renderContactFullEmail: ->
    unless this.props.hideEmail
      `<li><a href="#"><i className="fa fa-envelope"></i> <span className="email">{this.props.email}</span></a></li>`

  renderMainNav: (navbarNavClassName, lineHeight) ->
    unless this.props.logo_vertical_position is 'inside' and this.props.logo_horizontal_position is 'center' and this.props.navigation_horizontal_position is 'center'
      `<NavLinks items={this.props.pages} className={navbarNavClassName} lineHeight={lineHeight} />`

  renderSplitNavs: (lineHeight) ->
    if this.props.logo_vertical_position is 'inside' and this.props.logo_horizontal_position is 'center' and this.props.navigation_horizontal_position is 'center'
      result = []
      if this.props.pages.length > 0
        i = Math.ceil(this.props.pages.length / 2)
        leftPages = this.props.pages.slice(0, i)
        rightPages = this.props.pages.slice(i, this.props.pages.length)
        if leftPages.length > 0
          result.push `<NavLinks key="left" ref="leftNavbar" items={leftPages} className="nav navbar-nav navbar-abs-half-left" lineHeight={lineHeight} />`
        if rightPages.length > 0
          result.push `<NavLinks key="right" ref="rightNavbar" items={rightPages} className="nav navbar-nav navbar-abs-half-right" lineHeight={lineHeight} />`
      result

window.HeaderBlock = HeaderBlock
