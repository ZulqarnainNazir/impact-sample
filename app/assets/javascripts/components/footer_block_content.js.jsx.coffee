FooterBlockContent = React.createClass
  render: ->
    switch this.props.theme
      when 'simple_full_width'
        this.renderSimpleFullWidth()
      when 'columns'
        this.renderColumns()
      when 'layers'
        this.renderLayers()
      else
        this.renderSimple()

  renderSimpleFullWidth: ->
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

  renderSimple: ->
    `<footer className="site-footer site-footer-simple">
      <div className="container">
        <hr />
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

  renderLayers: ->
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
              <span className="tel">{this.props.phone}</span> <br />
              <a href="#">{this.props.email}</a>
            </div>
            <div className="col-sm-4 footer-right">
              <p className="adr">{this.props.address_line_one} <br /> {this.props.address_line_two}</p>
            </div>
          </div>
        </div>
      </div>
    </footer>`

  renderColumns: ->
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
              <p className="tel">{this.props.phone}</p>
              <p className="adr">{this.props.address_line_one} <br /> {this.props.address_line_two}</p>
              <p><a className="email" href="#">{this.props.email}</a></p>
            </div>
          </div>
        </div>
      </div>
      <div className="container text-center">
        <p className="copyright">© 2015 {this.props.name}</p>
      </div>
    </footer>`

window.FooterBlockContent = FooterBlockContent
