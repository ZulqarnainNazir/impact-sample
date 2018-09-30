FooterBlock = React.createClass
  render: ->
    `<div className="webpage-footer">
      {this.renderInterior()}
    </div>`

  renderInterior: ->
    switch this.props.theme
      when 'simple_full_width'
        this.renderSimpleFullWidth()
      when 'columns'
        this.renderColumns()
      when 'columns_with_feeds'
        this.renderColumnsWithFeeds()
      when 'layers'
        this.renderLayers()
      else
        this.renderSimple()

  renderSimpleFullWidth: ->
    `<footer className="site-footer site-footer-simple">
      <div className="container">
        <p className="copyright">© 2018 {this.props.name}</p>
        <ul className="list-inline footer-social">
          <li><a href="#"><i className="fa fa-facebook-square fa-2x"></i></a></li>
          <li><a href="#"><i className="fa fa-twitter-square fa-2x"></i></a></li>
          <li><a href="#"><i className="fa fa-google-plus-square fa-2x"></i></a></li>
          <li><a href="#"><i className="fa fa-youtube-square fa-2x"></i></a></li>
          <li><a href="#"><i className="fa fa-linkedin-square fa-2x"></i></a></li>
          <li><a href="#"><i className="fa fa-envelope-square fa-2x"></i></a></li>
        </ul>
        <NavLinks items={this.props.pages} className="list-inline footer-links" />
      </div>
    </footer>`

  renderSimple: ->
    `<footer className="site-footer site-footer-simple">
      <div className="container">
        <hr />
        <p className="copyright">© 2018 {this.props.name}</p>
        <ul className="list-inline footer-social">
          <li><a href="#"><i className="fa fa-facebook-square fa-2x"></i></a></li>
          <li><a href="#"><i className="fa fa-twitter-square fa-2x"></i></a></li>
          <li><a href="#"><i className="fa fa-google-plus-square fa-2x"></i></a></li>
          <li><a href="#"><i className="fa fa-youtube-square fa-2x"></i></a></li>
          <li><a href="#"><i className="fa fa-linkedin-square fa-2x"></i></a></li>
          <li><a href="#"><i className="fa fa-envelope-square fa-2x"></i></a></li>
        </ul>
        <NavLinks items={this.props.pages} className="list-inline footer-links" />
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
          <NavLinks items={this.props.pages} className="list-inline footer-links" />
        </div>
      </div>
      <div className="site-footer-bottom">
        <div className="container">
          <div className="row vcard">
            <div className="col-sm-4">
              <p className="h4 fn org">{this.props.name}</p>
              <p className="copyright">© 2018 {this.props.name}</p>
            </div>
            <div className="col-sm-4 footer-center">
              {this.renderPhone()} <br />
              {this.renderEmail()}
            </div>
            <div className="col-sm-4 footer-right">
              {this.renderAddress()}
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
              <NavLinks items={this.props.pages} className="list-unstyled footer-links" />
            </div>
            <div className="site-footer-column col-sm-4 col-md-3 vcard">
              <p className="h3 fn org">{this.props.name}</p>
              <p>{this.renderPhone()}</p>
              {this.renderAddress()}
              <p>{this.renderEmail()}</p>
            </div>
          </div>
        </div>
      </div>
      <div className="container text-center">
        <p className="copyright">© 2018 {this.props.name}</p>
      </div>
    </footer>`

  renderColumnsWithFeeds: ->
    `<footer className="site-footer site-footer-columns">
      <LeftFeedSettingsModal footerBlock={this.props} contentCategories={this.props.contentCategories} reset={function(){}} update={function(){}} />
      <RightFeedSettingsModal footerBlock={this.props} contentCategories={this.props.contentCategories} reset={function(){}} update={function(){}} />
      <LeftColumnLabelConfigModal footerBlock={this.props} internalWebpages={this.props.internalWebpages} reset={function(){}} update={function(){}} />
      <RightColumnLabelConfigModal footerBlock={this.props} internalWebpages={this.props.internalWebpages} reset={function(){}} update={function(){}} />
      <div className="site-footer-upper">
        <div className="container">
          <div className="row">
            <div className="site-footer-columns-with-feed col-sm-3 m-b-xl">
              <ul className="list-inline footer-social">
                <li><a href="#"><i className="fa fa-facebook-square fa-2x"></i></a></li>
                <li><a href="#"><i className="fa fa-twitter-square fa-2x"></i></a></li>
                <li><a href="#"><i className="fa fa-google-plus-square fa-2x"></i></a></li>
                <li><a href="#"><i className="fa fa-youtube-square fa-2x"></i></a></li>
                <li><a href="#"><i className="fa fa-linkedin-square fa-2x"></i></a></li>
                <li><a href="#"><i className="fa fa-envelope-square fa-2x"></i></a></li>
              </ul>
              <NavLinks items={this.props.pages} className="list-unstyled footer-links" />
            </div>
            <div className="site-footer-column col-sm-8">
              <div className="row">
                <div className="col-sm-6">
                  <div><a href="#" className="h3 action-link" onClick={this.renderLeftFeedColumnConfigLabelModal}>Label (<u>edit</u>)</a></div>
                  <hr></hr>
                  <div><a href="#" className="action-link btn btn-white btn-xs" onClick={this.renderLeftFeedColumnConfigModal}>Configure Feed</a></div>
                </div>
                <div className="col-sm-6">
                  <div><a href="#" className="h3 action-link" onClick={this.renderRightFeedColumnConfigLabelModal}>Label (<u>edit</u>)</a></div>
                  <hr></hr>
                  <div><a href="#" className="action-link btn btn-white btn-xs" onClick={this.renderRightFeedColumnConfigModal}>Configure Feed</a></div>
                </div>
              </div>
            </div>
            {/*<div className="site-footer-column col-sm-4 col-md-4 vcard">
              <p className="h3 fn org">{this.props.name}</p>
              <p>{this.renderPhone()}</p>
              {this.renderAddress()}
              <p>{this.renderEmail()}</p>
            </div>*/}
          </div>
        </div>
      </div>
      <div className="container text-center">
        <p className="copyright">© 2018 {this.props.name}</p>
      </div>
    </footer>`

  renderLeftFeedColumnConfigModal: (event) ->
    event.preventDefault()
    $('body').addClass('modal-open')
    $('#left_feed_settings_modal').modal('show')

  renderLeftFeedColumnConfigLabelModal: (event) ->
    event.preventDefault()
    $('body').addClass('modal-open')
    $('#left_label_config_modal').modal('show')

  renderRightFeedColumnConfigModal: (event) ->
    event.preventDefault()
    $('body').addClass('modal-open')
    $('#right_feed_settings_modal').modal('show')

  renderRightFeedColumnConfigLabelModal: (event) ->
    event.preventDefault()
    $('body').addClass('modal-open')
    $('#right_label_config_modal').modal('show')

  renderAddress: ->
    unless this.props.hideAddress
      `<p className="adr">{this.props.address_line_one} <br /> {this.props.address_line_two}</p>`

  renderEmail: ->
    unless this.props.hideEmail
      `<a href="#">{this.props.email}</a>`

  renderPhone: ->
    unless this.props.hidePhone
      `<span className="tel">{this.props.phone}</span>`

window.FooterBlock = FooterBlock
