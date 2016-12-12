(function() {
  var HeaderBlock;

  HeaderBlock = React.createClass({
    componentDidMount: function() {
      this.centerLogo();
      setTimeout(this.centerLogo, 5);
      return setTimeout(this.centerLogo, 100);
    },
    componentDidUpdate: function() {
      this.centerLogo();
      setTimeout(this.centerLogo, 5);
      return setTimeout(this.centerLogo, 100);
    },
    centerLogo: function() {
      var offset;
      if ($(window).width() > 768 && ['above', 'below'].indexOf(this.props.logo_vertical_position) === -1 && this.props.logo_horizontal_position === 'center' && this.props.navigation_horizontal_position === 'center') {
        offset = $('.webpage-designer .navbar-brand').width() / 2 + 30;
        if (this.refs.leftNavbar) {
          $(this.refs.leftNavbar.getDOMNode()).css('margin-right', offset + "px");
        }
        if (this.refs.rightNavbar) {
          return $(this.refs.rightNavbar.getDOMNode()).css('margin-left', offset + "px");
        }
      }
    },
    render: function() {
      var lineHeight, navbar, navbarClassName, navbarHeaderClassName, navbarNavClassName, navbarOutsideClassName, navinterior;
      lineHeight = this.props.logo_height && ['above', 'below'].indexOf(this.props.logo_vertical_position) === -1 ? parseInt(this.props.logo_height - 10) : 30;
      navbarClassName = 'navbar';
      if (['static', 'fixed'].indexOf(this.props.navbar_location) === -1) {
        navbarClassName += ' navbar-default-top';
      }
      if (['static', 'fixed'].indexOf(this.props.navbar_location) === -1 && ['above'].indexOf(this.props.logo_vertical_position) === -1 && ['left', 'right', 'full'].indexOf(this.props.contact_position) === -1) {
        navbarClassName += ' navbar-default-top-alone';
      }
      if (['static', 'fixed'].indexOf(this.props.navbar_location) !== -1) {
        navbarClassName += ' navbar-static-top';
      }
      if (this.props.style === 'dark') {
        navbarClassName += ' navbar-inverse';
      }
      if (this.props.style === 'transparent') {
        navbarClassName += ' navbar-transparent';
      }
      if (['dark', 'transparent'].indexOf(this.props.style) === -1) {
        navbarClassName += ' navbar-default';
      }
      navbarHeaderClassName = 'navbar-header';
      navbarNavClassName = 'nav navbar-nav';
      if (['above', 'below'].indexOf(this.props.logo_vertical_position) === -1) {
        if (this.props.logo_horizontal_position === 'center' && this.props.navigation_horizontal_position === 'center') {
          navbarHeaderClassName += ' navbar-center';
        } else if (this.props.logo_horizontal_position === 'center') {
          navbarHeaderClassName += ' navbar-center';
          if (this.props.navigation_horizontal_position === 'right') {
            navbarNavClassName += ' navbar-abs-right';
          }
          if (['right'].indexOf(this.props.navigation_horizontal_position) === -1) {
            navbarNavClassName += ' navbar-abs-left';
          }
        } else if (this.props.navigation_horizontal_position === 'center') {
          navbarNavClassName += ' navbar-center';
          if (this.props.logo_horizontal_position === 'right') {
            navbarHeaderClassName += ' navbar-abs-right';
          }
          if (['right'].indexOf(this.props.logo_horizontal_position) === -1) {
            navbarHeaderClassName += ' navbar-abs-left';
          }
        } else {
          if (this.props.logo_horizontal_position === 'right') {
            navbarHeaderClassName += ' navbar-right';
          }
          if (['right'].indexOf(this.props.logo_horizontal_position) === -1) {
            navbarHeaderClassName += ' navbar-left';
          }
          if (this.props.navigation_horizontal_position === 'right') {
            navbarNavClassName += ' navbar-right';
          }
          if (['right'].indexOf(this.props.navigation_horizontal_position) === -1) {
            navbarNavClassName += ' navbar-left';
          }
        }
      } else {
        if (this.props.logo_horizontal_position === 'right') {
          navbarOutsideClassName = 'navbar-outside-right';
        }
        if (this.props.logo_horizontal_position === 'center') {
          navbarOutsideClassName = 'navbar-outside-center';
        }
        if (['right', 'center'].indexOf(this.props.logo_horizontal_position) === -1) {
          navbarOutsideClassName = 'navbar-outside-left';
        }
        if (this.props.navigation_horizontal_position === 'right') {
          navbarNavClassName += ' navbar-right';
        }
        if (this.props.navigation_horizontal_position === 'center') {
          navbarNavClassName += ' navbar-center';
        }
        if (['right', 'center'].indexOf(this.props.navigation_horizontal_position) === -1) {
          navbarNavClassName += ' navbar-left';
        }
      }
      navinterior = <div>
        <div className={navbarHeaderClassName}>
          <a href="#" type="button" className="navbar-toggle collapsed" data-toggle="collapse" data-target="#header-navar-collapse">
            <span className="sr-only">Toggle Navigation</span>
            <span className="icon-bar"></span>
            <span className="icon-bar"></span>
            <span className="icon-bar"></span>
          </a>
          {this.renderLogoInside()}
        </div>
        <div className="collapse navbar-collapse" id="header-navbar-collapse">
          {this.renderMainNav(navbarNavClassName, lineHeight)}
          {this.renderSplitNavs(lineHeight)}
        </div>
      </div>;
      navbar = ['static', 'fixed'].indexOf(this.props.navbar_location) === -1 ? <div className="container">
          <nav className={navbarClassName} role="navigation">
            {navinterior}
          </nav>
        </div> : <nav className={navbarClassName} role="navigation">
          <div className="container">
            {navinterior}
          </div>
        </nav>;
      return <div className="webpage-header">
      <div className="container">
        {this.renderContact()}
        {this.renderLogoAbove(navbarOutsideClassName)}
      </div>
      {navbar}
      <div className="container">
        {this.renderLogoBelow(navbarOutsideClassName)}
      </div>
    </div>;
    },
    renderLogoAbove: function(className) {
      if (this.props.logo_vertical_position === 'above') {
        return <div className={className}>
        {this.renderLogo()}
      </div>;
      }
    },
    renderLogoBelow: function(className) {
      if (this.props.logo_vertical_position === 'below') {
        return <div className={className}>
        {this.renderLogo()}
      </div>;
      }
    },
    renderLogoInside: function() {
      if (['above', 'below'].indexOf(this.props.logo_vertical_position) === -1) {
        return this.renderLogo();
      }
    },
    renderLogo: function(size) {
      var image;
      if (this.props.logo_height && parseInt(this.props.logo_height) > 0) {
        if (parseInt(this.props.logo_height) > 125) {
          size = 'jumbo';
        } else if (parseInt(this.props.logo_height) > 60) {
          size = 'large';
        } else if (parseInt(this.props.logo_height) > 40) {
          size = 'medium';
        }
      }
      image = size === 'jumbo' && this.props.logoJumbo && this.props.logoJumbo.length > 0 ? <img src={this.props.logoJumbo} alt={this.props.name} style={{height: this.props.logo_height, maxHeight: 200}} /> : size === 'large' && this.props.logoLarge && this.props.logoLarge.length > 0 ? <img src={this.props.logoLarge} alt={this.props.name} style={{height: this.props.logo_height, maxHeight: 125}} /> : size === 'medium' && this.props.logoMedium && this.props.logoMedium.length > 0 ? <img src={this.props.logoMedium} alt={this.props.name} style={{height: this.props.logo_height, maxHeight: 60}} /> : this.props.logoSmall && this.props.logoSmall.length > 0 ? <img src={this.props.logoSmall} alt={this.props.name} style={{height: this.props.logo_height, maxHeight: 40}} /> : void 0;
      if (image) {
        return <a className="navbar-brand navbar-brand-image" href="#">{image}</a>;
      } else {
        return <a className="navbar-brand navbar-brand-text" href="#">{this.props.name.slice(0,44)}</a>;
      }
    },
    renderContact: function() {
      if (this.props.contact_position === 'left') {
        return <div>
        <div className="vcard navbar-vcard pull-right text-right">
          {this.renderSocial()}
        </div>
        <div className="vcard navbar-vcard pull-left text-left">
          {this.renderContactPhone()}
          {this.renderContactAddress()}
        </div>
      </div>;
      } else if (this.props.contact_position === 'right') {
        return <div className="vcard navbar-vcard pull-right text-right">
        {this.renderSocial()}
        {this.renderContactPhone()}
        {this.renderContactAddress()}
      </div>;
      } else if (this.props.contact_position === 'full') {
        return <div className="clearfix" style={{marginLeft: -10}}>
        <ul className="nav navbar-nav vcard text-left">
          {this.renderSocial()}
          {this.renderContactFullAddress()}
          {this.renderContactFullPhone()}
          {this.renderContactFullEmail()}
        </ul>
      </div>;
      }
    },
    renderSocial: function() {
      if (this.props.social_enabled !== 'hidden') {
        return <ul className="list-inline header-social">
        <li><a href="#"><i className="fa fa-facebook-square fa-2x"></i></a></li>
        <li><a href="#"><i className="fa fa-twitter-square fa-2x"></i></a></li>
        <li><a href="#"><i className="fa fa-google-plus-square fa-2x"></i></a></li>
        <li><a href="#"><i className="fa fa-youtube-square fa-2x"></i></a></li>
        <li><a href="#"><i className="fa fa-linkedin-square fa-2x"></i></a></li>
        <li><a href="#"><i className="fa fa-envelope-square fa-2x"></i></a></li>
      </ul>;
      }
    },
    renderContactPhone: function() {
      if (!this.props.hidePhone) {
        return <p className="h4 tel">{this.props.phone}</p>;
      }
    },
    renderContactAddress: function() {
      if (!this.props.hideAddress) {
        return <p className="adr">{this.props.addressLineOne} <br /> {this.props.addressLineTwo}</p>;
      }
    },
    renderContactFullAddress: function() {
      if (!this.props.hideAddress) {
        return <li><p className="navbar-text"><i className="fa fa-map-marker"></i> <span className="adr"><span className="street-address">{this.props.addressLineOne}</span>, <span className="locality">{this.props.addressLineTwo}</span></span></p></li>;
      }
    },
    renderContactFullPhone: function() {
      if (!this.props.hidePhone) {
        return <li><p className="navbar-text"><i className="fa fa-phone"></i> <span className="tel">{this.props.phone}</span></p></li>;
      }
    },
    renderContactFullEmail: function() {
      if (!this.props.hideEmail) {
        return <li><a href="#"><i className="fa fa-envelope"></i> <span className="email">{this.props.email}</span></a></li>;
      }
    },
    renderMainNav: function(navbarNavClassName, lineHeight) {
      if (!(this.props.logo_vertical_position === 'inside' && this.props.logo_horizontal_position === 'center' && this.props.navigation_horizontal_position === 'center')) {
        return <NavLinks items={this.props.pages} className={navbarNavClassName} lineHeight={lineHeight} />;
      }
    },
    renderSplitNavs: function(lineHeight) {
      var i, leftPages, result, rightPages;
      if (this.props.logo_vertical_position === 'inside' && this.props.logo_horizontal_position === 'center' && this.props.navigation_horizontal_position === 'center') {
        result = [];
        if (this.props.pages.length > 0) {
          i = Math.ceil(this.props.pages.length / 2);
          leftPages = this.props.pages.slice(0, i);
          rightPages = this.props.pages.slice(i, this.props.pages.length);
          if (leftPages.length > 0) {
            result.push(<NavLinks key="left" ref="leftNavbar" items={leftPages} className="nav navbar-nav navbar-abs-half-left" lineHeight={lineHeight} />);
          }
          if (rightPages.length > 0) {
            result.push(<NavLinks key="right" ref="rightNavbar" items={rightPages} className="nav navbar-nav navbar-abs-half-right" lineHeight={lineHeight} />);
          }
        }
        return result;
      }
    }
  });

  window.HeaderBlock = HeaderBlock;

}).call(this);
