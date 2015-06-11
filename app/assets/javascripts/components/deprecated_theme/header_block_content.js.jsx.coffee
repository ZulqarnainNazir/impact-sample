HeaderBlockContent = React.createClass
  render: ->
    switch this.props.theme
      when 'center'
        this.renderCenter()
      when 'justify'
        this.renderJustify()
      when 'logo_above'
        this.renderLogoAbove()
      when 'logo_above_full_width'
        this.renderLogoAboveFullWidth()
      when 'logo_below'
        this.renderLogoBelow()
      when 'logo_center'
        this.renderLogoCenter()
      else
        this.renderInline()

  componentDidMount: ->
    this.centerLogo()
    setTimeout this.centerLogo, 5
    setTimeout this.centerLogo, 100

  componentDidUpdate: ->
    this.centerLogo()
    setTimeout this.centerLogo, 5
    setTimeout this.centerLogo, 100

  centerLogo: ->
    if this.props.theme is 'logo_center' and this.refs.image and this.refs.leftNavbar and this.refs.rightNavbar
      image = $(this.refs.image.getDOMNode()).find('img')
      $(this.refs.leftNavbar.getDOMNode()).css 'margin-right', "#{image.width() / 2 + 20}px"
      $(this.refs.rightNavbar.getDOMNode()).css 'margin-left', "#{image.width() / 2 + 20}px"
      $(this.refs.image.getDOMNode()).find('.navbar-brand').css 'margin-left', "-#{image.width() / 2}px"

  renderLogoCenter: ->
    `<nav className={this.navbarClassName('navbar-static-top header-centered-logo')} role="navigation">
      <div className="container">
        <div className="navbar-header" style={{minHeight: parseInt(this.props.logo_height) + 20}}>
          {this.renderCollapseButton()}
          <div ref="image">
            {this.renderNavbarBrand()}
          </div>
        </div>
        <div className="collapse navbar-collapse" id="header-navbar-collapse">
          {this.renderSplitNavLists()}
        </div>
      </div>
    </nav>`

  renderLogoBelow: ->
    `<div>
      <nav className={this.navbarClassName('navbar-static-top')} role="navigation">
        <div className="container">
          <div className="navbar-header">
            {this.renderCollapseButton()}
          </div>
          <div className="collapse navbar-collapse" id="header-navbar-collapse">
            <NavLinks items={this.props.pages} className="nav navbar-nav" />
          </div>
        </div>
      </nav>
      <div className="container header-logo-below">
        {this.renderNavbarBrand('large')}
      </div>
    </div>`

  renderLogoAboveFullWidth: ->
    `<div>
      <div className="container header-logo-above">
        <div className="navbar-header">
          {this.renderCollapseButton()}
          {this.renderNavbarBrand('medium')}
        </div>
        <div className="navbar-right vcard navbar-vcard">
          <p className="h4 tel">{this.props.phoneNumber}</p>
          <p className="adr">{this.props.addressLineOne} <br /> {this.props.addressLineTwo}</p>
        </div>
      </div>
      <nav className={this.navbarClassName('navbar-static-top navbar-logo-above')} role="navigation">
        <div className="container">
          <div className="collapse navbar-collapse" id="header-navbar-collapse">
            <NavLinks items={this.props.pages} className="nav navbar-nav" />
          </div>
        </div>
      </nav>
    </div>`

  renderLogoAbove: ->
    `<div>
      <div className="container header-logo-above">
        <div className="navbar-header">
          {this.renderCollapseButton()}
          {this.renderNavbarBrand('medium')}
        </div>
        <div className="navbar-right vcard navbar-vcard">
          <p className="h4 tel">{this.props.phoneNumber}</p>
          <p className="adr">{this.props.addressLineOne} <br /> {this.props.addressLineTwo}</p>
        </div>
      </div>
      <div className="container">
        <nav className={this.navbarClassName('navbar-logo-above')} role="navigation">
          <div className="collapse navbar-collapse" id="header-navbar-collapse">
            <NavLinks items={this.props.pages} className="nav navbar-nav" />
          </div>
        </nav>
      </div>
    </div>`

  renderJustify: ->
    `<nav className={this.navbarClassName('navbar-static-top header-justified')} role="navigation">
      <div className="container">
        <div className="navbar-header">
          {this.renderCollapseButton()}
          {this.renderNavbarBrand()}
        </div>
        <div className="collapse navbar-collapse" id="header-navbar-collapse">
          <NavLinks items={this.props.pages} className="nav navbar-nav navbar-justified" lineHeight={parseInt(this.props.logo_height - 10)} />
        </div>
      </div>
    </nav>`

  renderInline: ->
    `<nav className={this.navbarClassName('navbar-static-top')} role="navigation">
      <div className="container">
        <div className="navbar-header">
          {this.renderCollapseButton()}
          {this.renderNavbarBrand()}
        </div>
        <div className="collapse navbar-collapse" id="header-navbar-collapse">
          <NavLinks items={this.props.pages} className="nav navbar-nav navbar-right" lineHeight={parseInt(this.props.logo_height - 10)} />
        </div>
      </div>
    </nav>`

  renderCenter: ->
    `<nav className={this.navbarClassName('navbar-static-top header-centered')} role="navigation">
      <div className="container">
        <div className="navbar-header" style={{minHeight: parseInt(this.props.logo_height) + 20}}>
          {this.renderCollapseButton()}
          {this.renderNavbarBrand()}
        </div>
        <div className="collapse navbar-collapse" id="header-navbar-collapse">
          <NavLinks items={this.props.pages} className="nav navbar-nav navbar-centered" lineHeight={parseInt(this.props.logo_height - 10)} />
        </div>
      </div>
    </nav>`

  navbarClassName: (additionalClasses) ->
    className = 'navbar ' + additionalClasses
    className += ' navbar-inverse' if this.props.style is 'dark'
    className += ' navbar-default' if this.props.style is 'light'
    className

  renderNavbarBrand: (size) ->
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
      `<a className="navbar-brand" href="#">{this.props.name}</a>`

  renderCollapseButton: ->
    `<button type="button" className="navbar-toggle collapsed" data-toggle="collapse" data-target="#header-navbar-collapse">
      <span className="sr-only">Toggle Navigation</span>
      <span className="icon-bar"></span>
      <span className="icon-bar"></span>
      <span className="icon-bar"></span>
    </button>`

  renderSplitNavLists: ->
    result = []
    if this.props.pages.length > 0
      i = Math.ceil(this.props.pages.length / 2)
      leftPages = this.props.pages.slice(0, i)
      rightPages = this.props.pages.slice(i, this.props.pages.length)
      if leftPages.length > 0
        result.push `<NavLinks key="left" ref="leftNavbar" items={leftPages} className="nav navbar-nav navbar-left" lineHeight={parseInt(this.props.logo_height - 10)} />`
      if rightPages.length > 0
        result.push `<NavLinks key="right" ref="rightNavbar" items={rightPages} className="nav navbar-nav navbar-right" lineHeight={parseInt(this.props.logo_height - 10)} />`
    result

window.HeaderBlockContent = HeaderBlockContent
