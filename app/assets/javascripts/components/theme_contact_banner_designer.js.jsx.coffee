ThemeContactBannerDesigner = React.createClass
  render: ->
    mapSrc = 'https://www.google.com/maps/embed/v1/place?q=195+Blue+Ravine+Road+%23100+Folsom%2C+CA+95630%0A&key=AIzaSyCA09Ziec6NhT3FboPtVnHEfCaLBzqk298'

    `<div>
      <div style={{marginBottom: 50}}>
        <iframe width="100%" height="450" frameBorder="0" style={{border: 0}} src={mapSrc} />
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
            <p>hours...</p>
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

  mailTo: (email) ->
    "mailto:#{email}"

window.ThemeContactBannerDesigner = ThemeContactBannerDesigner
