Business = ({ name, location, onClick, owners }) => (
  <div className="col-sm-3 col-md-6">
    <div className="contact-box center-version">
      <a className="business-card" disabled={owners.length > 0}>
        <h3>{name}</h3>
        <address>
          <p className="m-b-none">{location.street1}</p>
          <p className="m-b-none">{location.street2}</p>
          <p className="m-b-none">{location.city && location.state ? `${location.city}, ${location.state} ${location.zip_code}` : ''}</p>
          <p className="m-b-none">{location.phone_number}</p>
        </address>
      </a>
      <div className="contact-box-footer">
        <button onClick={onClick} className="btn btn-primary btn-block" disabled={owners.length > 0}>This is it</button>
        <label className="label-sm label-warning" />
      </div>
    </div>
  </div>
);

Business.defaultProps = {
  location: {}
};
