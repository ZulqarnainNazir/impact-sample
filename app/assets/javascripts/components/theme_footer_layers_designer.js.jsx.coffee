ThemeFooterLayersDesigner = React.createClass
  render: ->
    `<footer className="site-footer site-footer-layers">
      <div className="site-footer-upper text-center">
        <div className="container">
          <ul className="list-inline footer-social">
            <li><b>Follow Us:</b></li>
            <li><a href="#"><i className="fa fa-facebook-square fa-2x"></i></a></li>
            <li><a href="#"><i className="fa fa-twitter-square fa-2x"></i></a></li>
            <li><a href="#"><i className="fa fa-google-plus-square fa-2x"></i></a></li>
            <li><a href="#"><i className="fa fa-youtube-square fa-2x"></i></a></li>
            <li><a href="#"><i className="fa fa-linkedin-square fa-2x"></i></a></li>
            <li><a href="#"><i className="fa fa-envelope-square fa-2x"></i></a></li>
          </ul>
        </div>
      </div>
      <div className="site-footer-middle">
        <div className="container">
          <UnorderedList items={this.props.pages} className="list-inline footer-links" />
        </div>
      </div>
      <div className="site-footer-bottom">
        <div className="container">
          <div className="row vcard">
            <div className="col-sm-4">
              <p className="h4 fn org">{this.props.name}</p>
              <p className="copyright">© 2015 {this.props.name}</p>
            </div>
            <div className="col-sm-4 footer-center">
              <span className="tel">{this.props.phoneNumber}</span> <br />
              <a href="#">{this.props.emailAddress}</a>
            </div>
            <div className="col-sm-4 footer-right">
              <p className="adr">{this.props.addressLineOne} <br /> {this.props.addressLineTwo}</p>
            </div>
          </div>
        </div>
      </div>
    </footer>`

window.ThemeFooterLayersDesigner = ThemeFooterLayersDesigner
