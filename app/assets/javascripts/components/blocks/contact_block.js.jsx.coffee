ContactBlock = React.createClass
  propTypes: ->
    openings: React.PropTypes.array

  getDefaultProps: ->
    openings: []

  render: ->
    `<div className="webpage-contact">
      {this.renderInterior()}
    </div>`

  renderInterior: ->
    switch this.props.theme
      when 'banner'
        this.renderBanner()
      when 'inline'
        this.renderInline()
      when 'content'
        this.renderContent()
      else
        this.renderRight()

  renderRight: ->
    `<div key="right">
      <div className="row">
        <div className="col-sm-4">
          <ul className="list-inline">
            <li><a href="#"><i className="fa fa-facebook-square fa-2x"></i></a></li>
            <li><a href="#"><i className="fa fa-twitter-square fa-2x"></i></a></li>
            <li><a href="#"><i className="fa fa-google-plus-square fa-2x"></i></a></li>
            <li><a href="#"><i className="fa fa-youtube-square fa-2x"></i></a></li>
            <li><a href="#"><i className="fa fa-linkedin-square fa-2x"></i></a></li>
            <li><a href="#"><i className="fa fa-envelope-square fa-2x"></i></a></li>
          </ul>
          <div className="vcard">
            <h3 className="fn org">{this.props.name}</h3>
            <p className="tel">{this.props.phone_number}</p>
            <p className="adr">
              {this.props.address_line_one}
              <br />
              {this.props.address_line_two}
            </p>
            <p><a className="email" href={this.mailTo(this.props.email)}>{this.props.email}</a></p>
            {this.renderOpenings()}
          </div>
          <hr />
          <div className="form-group">
            <label className="control-label sr-only" htmlFor="name">
              <abbr title="required">*</abbr> Name</label>
            <input className="form-control" name="name" id="name" placeholder="Name" type="text" />
          </div>
          <div className="form-group">
            <label className="control-label sr-only" htmlFor="email">
              <abbr title="required">*</abbr> Email</label>
            <input className="form-control" name="email" id="email" placeholder="Email" type="email" />
          </div>
          <div className="form-group">
            <label className="control-label sr-only" htmlFor="message">
              <abbr title="required">*</abbr> Message</label>
            <textarea className="form-control" cols="50" rows="5" name="message" id="message" placeholder="Message"></textarea>
          </div>
          <div className="form-group">
            <button className="btn btn-primary" type="submit">Send Message</button>
          </div>
        </div>
        <div className="col-sm-8">
          <iframe width="100%" height="450" frameBorder="0" style={{border: 0}} src={this.mapSrc()} />
        </div>
      </div>
    </div>`

  renderContent: ->
    `<div key="content">
      <div className="row">
        <div className="col-sm-4">
          <ul className="list-inline">
            <li><a href="#"><i className="fa fa-facebook-square fa-2x"></i></a></li>
            <li><a href="#"><i className="fa fa-twitter-square fa-2x"></i></a></li>
            <li><a href="#"><i className="fa fa-google-plus-square fa-2x"></i></a></li>
            <li><a href="#"><i className="fa fa-youtube-square fa-2x"></i></a></li>
            <li><a href="#"><i className="fa fa-linkedin-square fa-2x"></i></a></li>
            <li><a href="#"><i className="fa fa-envelope-square fa-2x"></i></a></li>
          </ul>
          <div className="vcard">
            <h3 className="fn org">{this.props.name}</h3>
            <p className="tel">{this.props.phone_number}</p>
            <p className="adr">
              {this.props.address_line_one}
              <br />
              {this.props.address_line_two}
            </p>
            <p><a className="email" href={this.mailTo(this.props.email)}>{this.props.email}</a></p>
            {this.renderOpenings()}
          </div>
          <hr />
          <div className="form-group">
            <label className="control-label sr-only" htmlFor="name">
              <abbr title="required">*</abbr> Name</label>
            <input className="form-control" name="name" id="name" placeholder="Name" type="text" />
          </div>
          <div className="form-group">
            <label className="control-label sr-only" htmlFor="email">
              <abbr title="required">*</abbr> Email</label>
            <input className="form-control" name="email" id="email" placeholder="Email" type="email" />
          </div>
          <div className="form-group">
            <label className="control-label sr-only" htmlFor="message">
              <abbr title="required">*</abbr> Message</label>
            <textarea className="form-control" cols="50" rows="5" name="message" id="message" placeholder="Message"></textarea>
          </div>
          <div className="form-group">
            <button className="btn btn-primary" type="submit">Send Message</button>
          </div>
        </div>
        <div className="col-sm-8">
          {this.renderText()}
        </div>
      </div>
    </div>`

  renderInline: ->
    `<div key="inline">
      <div className="row">
        <div className="col-sm-6">
          <ul className="list-inline">
            <li><a href="#"><i className="fa fa-facebook-square fa-2x"></i></a></li>
            <li><a href="#"><i className="fa fa-twitter-square fa-2x"></i></a></li>
            <li><a href="#"><i className="fa fa-google-plus-square fa-2x"></i></a></li>
            <li><a href="#"><i className="fa fa-youtube-square fa-2x"></i></a></li>
            <li><a href="#"><i className="fa fa-linkedin-square fa-2x"></i></a></li>
            <li><a href="#"><i className="fa fa-envelope-square fa-2x"></i></a></li>
          </ul>
          {this.renderText()}
          <hr />
          <div className="form-group">
            <label className="control-label sr-only" htmlFor="name">
              <abbr title="required">*</abbr> Name</label>
            <input className="form-control" name="name" id="name" placeholder="Name" type="text" />
          </div>
          <div className="form-group">
            <label className="control-label sr-only" htmlFor="email">
              <abbr title="required">*</abbr> Email</label>
            <input className="form-control" name="email" id="email" placeholder="Email" type="email" />
          </div>
          <div className="form-group">
            <label className="control-label sr-only" htmlFor="message">
              <abbr title="required">*</abbr> Message</label>
            <textarea className="form-control" cols="50" rows="5" name="message" id="message" placeholder="Message"></textarea>
          </div>
          <div className="form-group">
            <button className="btn btn-primary" type="submit">Send Message</button>
          </div>
        </div>
        <div className="col-sm-6">
          <div className="vcard">
            <h5 className="fn org">{this.props.name}</h5>
            <p className="tel">{this.props.phone_number}</p>
            <p className="adr">
              {this.props.address_line_one}
              <br />
              {this.props.address_line_two}
            </p>
            <p><a className="email" href={this.mailTo(this.props.email)}>{this.props.email}</a></p>
            {this.renderOpenings()}
          </div>
          <div style={{marginTop: 20, marginBottom: 50}}>
            <iframe width="100%" height="200" frameBorder="0" style={{border: 0}} src={this.mapSrc()} />
          </div>
        </div>
      </div>
    </div>`

  renderBanner: ->
    `<div key="banner">
      <div style={{marginBottom: 50}}>
        <iframe width="100%" height="450" frameBorder="0" style={{border: 0}} src={this.mapSrc()} />
      </div>
      <div className="row">
        <div className="col-sm-4">
          <ul className="list-inline">
            <li><a href="#"><i className="fa fa-facebook-square fa-2x"></i></a></li>
            <li><a href="#"><i className="fa fa-twitter-square fa-2x"></i></a></li>
            <li><a href="#"><i className="fa fa-google-plus-square fa-2x"></i></a></li>
            <li><a href="#"><i className="fa fa-youtube-square fa-2x"></i></a></li>
            <li><a href="#"><i className="fa fa-linkedin-square fa-2x"></i></a></li>
            <li><a href="#"><i className="fa fa-envelope-square fa-2x"></i></a></li>
          </ul>
          <div className="vcard">
            <h3 className="fn org">{this.props.name}</h3>
            <p className="tel">{this.props.phone_number}</p>
            <p className="adr">
              {this.props.address_line_one}
              <br />
              {this.props.address_line_two}
            </p>
            <p><a className="email" href={this.mailTo(this.props.email)}>{this.props.email}</a></p>
            {this.renderOpenings()}
          </div>
        </div>
        <div className="col-sm-8">
          <div className="form-group">
            <label className="control-label sr-only" htmlFor="name">
              <abbr title="required">*</abbr> Name</label>
            <input className="form-control" name="name" id="name" placeholder="Name" type="text" />
          </div>
          <div className="form-group">
            <label className="control-label sr-only" htmlFor="email">
              <abbr title="required">*</abbr> Email</label>
            <input className="form-control" name="email" id="email" placeholder="Email" type="email" />
          </div>
          <div className="form-group">
            <label className="control-label sr-only" htmlFor="message">
              <abbr title="required">*</abbr> Message</label>
            <textarea className="form-control" cols="50" rows="5" name="message" id="message" placeholder="Message"></textarea>
          </div>
          <div className="form-group">
            <button className="btn btn-primary" type="submit">Send Message</button>
          </div>
        </div>
      </div>
    </div>`

  renderText: ->
    `<RichTextEditor enabled={this.props.editing && this.props.richText} html={this.props.text} update={this.props.updateText} />`

  renderOpenings: ->
    for opening in this.props.openings
      `<div key={opening.id}>{opening.days} <span className="pull-right">{opening.hours}</span></div>`

  mailTo: (email) ->
    "mailto:#{email}"

  mapSrc: ->
    if this.props.address_line_two and this.props.address_line_two.length > 0
      mapAddress = this.props.address_line_one + ' ' + this.props.address_line_two
    else
      mapAddress = this.props.address_line_one + ''
    mapBase = 'https://www.google.com/maps/embed/v1/place'
    mapKey = 'AIzaSyCA09Ziec6NhT3FboPtVnHEfCaLBzqk298'
    "#{mapBase}?#{$.param(q: mapAddress, key: mapKey)}"

window.ContactBlock = ContactBlock