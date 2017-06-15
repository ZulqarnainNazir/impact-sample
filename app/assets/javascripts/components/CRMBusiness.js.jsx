CRMBusiness = ({ id, href, name, location, onClick, disabled }) => (
  <div className="col-sm-4 clearfix">
    <div className="contact-box center-version">
      <a className="business-card" disabled={disabled}>
        <h3>{name}</h3>
        <address>
          <p className="m-b-none">{location.street1}</p>
          <p className="m-b-none">{location.street2}</p>
          <p className="m-b-none">{location.city && location.state ? `${location.city}, ${location.state} ${location.zip_code}` : ''}</p>
          <p className="m-b-none">{location.phone_number}</p>
        </address>
      </a>
      <div className="contact-box-footer">
        <a href={href} data-method={disabled ? "get" : "post"} onClick={onClick} className="btn btn-primary btn-block">{ disabled ? "View it now" : "This is it"}</a>
        <label className="label-sm label-warning">{disabled ? "Already a Part of your CRM" : ""}</label>
      </div>
    </div>
  </div>
);

CRMBusiness.defaultProps = {
  location: {}
};
