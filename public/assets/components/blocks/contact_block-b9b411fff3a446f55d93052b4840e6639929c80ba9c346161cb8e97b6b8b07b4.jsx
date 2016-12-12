(function() {
  var ContactBlock;

  ContactBlock = React.createClass({
    propTypes: function() {
      return {
        location: React.PropTypes.object,
        openings: React.PropTypes.array
      };
    },
    getDefaultProps: function() {
      return {
        openings: []
      };
    },
    render: function() {
      return <div className="webpage-contact">
      {this.renderInterior()}
    </div>;
    },
    renderInterior: function() {
      switch (this.props.theme) {
        case 'banner':
          return this.renderBanner();
        case 'inline':
          return this.renderInline();
        case 'content':
          return this.renderContent();
        default:
          return this.renderRight();
      }
    },
    renderRight: function() {
      return <div key="right">
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
            <h3 className="fn org">{this.props.location.name}</h3>
            <p className="tel">{this.props.location.phone_number}</p>
            <p className="adr">
              {this.props.location.address_line_one}
              <br />
              {this.props.location.address_line_two}
            </p>
            <p><a className="email" href={this.mailTo(this.props.location.email)}>{this.props.location.email}</a></p>
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
    </div>;
    },
    renderContent: function() {
      return <div key="content">
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
            <h3 className="fn org">{this.props.location.name}</h3>
            <p className="tel">{this.props.location.phone_number}</p>
            <p className="adr">
              {this.props.location.address_line_one}
              <br />
              {this.props.location.address_line_two}
            </p>
            <p><a className="email" href={this.mailTo(this.props.location.email)}>{this.props.location.email}</a></p>
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
    </div>;
    },
    renderInline: function() {
      return <div key="inline">
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
            <h5 className="fn org">{this.props.location.name}</h5>
            <p className="tel">{this.props.location.phone_number}</p>
            <p className="adr">
              {this.props.location.address_line_one}
              <br />
              {this.props.location.address_line_two}
            </p>
            <p><a className="email" href={this.mailTo(this.props.location.email)}>{this.props.location.email}</a></p>
            {this.renderOpenings()}
          </div>
          <div style={{marginTop: 20, marginBottom: 50}}>
            <iframe width="100%" height="200" frameBorder="0" style={{border: 0}} src={this.mapSrc()} />
          </div>
        </div>
      </div>
    </div>;
    },
    renderBanner: function() {
      return <div key="banner">
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
            <h3 className="fn org">{this.props.location.name}</h3>
            <p className="tel">{this.props.location.phone_number}</p>
            <p className="adr">
              {this.props.location.address_line_one}
              <br />
              {this.props.location.address_line_two}
            </p>
            <p><a className="email" href={this.mailTo(this.props.location.email)}>{this.props.location.email}</a></p>
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
    </div>;
    },
    renderText: function() {
      return <RichTextEditor enabled={this.props.editing && this.props.richText} html={this.props.text} update={this.props.updateText} />;
    },
    renderOpenings: function() {
      var i, len, opening, ref, results;
      ref = this.props.openings;
      results = [];
      for (i = 0, len = ref.length; i < len; i++) {
        opening = ref[i];
        results.push(<div key={opening.id}>{opening.days} <span className="pull-right">{opening.hours}</span></div>);
      }
      return results;
    },
    mailTo: function(email) {
      return "mailto:" + email;
    },
    mapSrc: function() {
      var mapBase, mapKey;
      mapBase = 'https://www.google.com/maps/embed/v1/place';
      mapKey = 'AIzaSyCA09Ziec6NhT3FboPtVnHEfCaLBzqk298';
      return mapBase + "?" + ($.param({
        center: this.props.location.latitude + "," + this.props.location.longitude,
        q: this.props.location.address_line_one + "," + this.props.location.address_line_two,
        key: mapKey,
        zoom: 18
      }));
    }
  });

  window.ContactBlock = ContactBlock;

}).call(this);
