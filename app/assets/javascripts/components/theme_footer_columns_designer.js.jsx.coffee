ThemeFooterColumnsDesigner = React.createClass
  render: ->
    `<footer className="site-footer site-footer-columns">
      <div className="site-footer-upper">
        <div className="container">
          <div className="row">
            <div className="site-footer-column col-sm-2 col-md-1">
              <ul className="list-inline footer-social">
                <li><a href="#"><i className="fa fa-facebook-square fa-2x"></i></a></li>
                <li><a href="#"><i className="fa fa-twitter-square fa-2x"></i></a></li>
                <li><a href="#"><i className="fa fa-google-plus-square fa-2x"></i></a></li>
                <li><a href="#"><i className="fa fa-youtube-square fa-2x"></i></a></li>
                <li><a href="#"><i className="fa fa-linkedin-square fa-2x"></i></a></li>
                <li><a href="#"><i className="fa fa-envelope-square fa-2x"></i></a></li>
              </ul>
            </div>
            <div className="site-footer-column col-sm-6 col-md-8">
              <UnorderedList items={this.props.pages} className="list-unstyled footer-links" />
            </div>
            <div className="site-footer-column col-sm-4 col-md-3 vcard">
              <p className="h3 fn org">{this.props.name}</p>
              <p className="tel">{this.props.phoneNumber}</p>
              <p className="adr">{this.props.addressLineOne} <br /> {this.props.addressLineTwo}</p>
              <p><a className="email" href="#">{this.props.emailAddress}</a></p>
            </div>
          </div>
        </div>
      </div>
      <div className="container text-center">
        <p className="copyright">© 2015 {this.props.name}</p>
      </div>
    </footer>`

window.ThemeFooterColumnsDesigner = ThemeFooterColumnsDesigner
