ThemeFooterSimpleFullWidthDesigner = React.createClass
  render: ->
    `<footer className="site-footer site-footer-simple">
      <hr />
      <div className="container">
        <p className="copyright">© 2015 {this.props.name}</p>
        <ul className="list-inline footer-social">
          <li><a href="#"><i className="fa fa-facebook-square fa-2x"></i></a></li>
          <li><a href="#"><i className="fa fa-twitter-square fa-2x"></i></a></li>
          <li><a href="#"><i className="fa fa-google-plus-square fa-2x"></i></a></li>
          <li><a href="#"><i className="fa fa-youtube-square fa-2x"></i></a></li>
          <li><a href="#"><i className="fa fa-linkedin-square fa-2x"></i></a></li>
          <li><a href="#"><i className="fa fa-envelope-square fa-2x"></i></a></li>
        </ul>
        <UnorderedList items={this.props.pages} className="list-inline footer-links" />
      </div>
    </footer>`

window.ThemeFooterSimpleFullWidthDesigner = ThemeFooterSimpleFullWidthDesigner
