// import React from 'react';
// import { browserHistory } from 'react-router';
// import { render } from 'react-dom';

class BusInfo extends React.Component {

  constructor() {
    // console.log(store.get('business'));
    super();
    this.state = {
      progress: '0%'
    }
    this.completeStep = this.completeStep.bind(this);
    this.changeIndustry = this.changeIndustry.bind(this);
    this.changeState = this.changeState.bind(this);
  }

  completeStep(event) {
    event.preventDefault();
    const business = {
      name: this.businessName.value,
      website_url: this.website.value,
      membership_org: this.membershipOrg.checked,
      location: {
        phone_number: this.phone.value,
        street1: this.streetAddress.value,
        street2: this.street2.value,
        city: this.city.value,
        zip_code: this.zip.value,
        hide_address: this.hideAddress.checked,
        hide_phone: this.hidePhone.checked,
      },
    };
    store.set('business', _.merge({}, store.get('business'), business));

    if (
      store.get('business').name &&
      store.get('business').categories.length > 0 &&
      store.get('business').location.street1 &&
      store.get('business').location.phone_number &&
      store.get('business').location.city &&
      store.get('business').location.zip_code &&
      store.get('business').location.state
    ) {
      store.set('busInfoComplete', true);
      hashHistory.push("confirm");
    } else {
      swal('Incomplete Form', 'Please fill out all of the required fields', 'error')
    }
  }

  changeIndustry(value) {
    store.set(
      'business',
      _.merge({}, store.get('business'), { categories: [{id: value}] }),
    );
  }

  changeState(value) {
    store.set(
      'business',
      _.merge({}, store.get('business'), { location: { state: value } }),
    );
    this.forceUpdate();
  }

  render() {
    return (
      <div className="row">
        <h1 className="col-xs-12"> Confirm the details below </h1>
        <form className="col-md-12 p-t-30px" onSubmit={this.completeStep}>
          <div className="group">
            <input className="form-control" type="text" ref={(input) => this.businessName = input} defaultValue={store.get('business').name} required />
            <span className="bar"></span>
            <span className="highlight"></span>
            <label className="control-label">Organization / Business Name <small>(required)</small></label>
          </div>
          <div className="checkbox text-muted text-right">
            <label>
              <input type="checkbox" ref={(input) => this.membershipOrg = input} defaultChecked={store.get('business').membership_org} />
              {" We're a membership organization (we have members)"}
            </label>
          </div>

          <div className="group">
            <input className="form-control" type="text" ref={(input) => this.phone = input} defaultValue={store.get('business').location.phone_number} required />
            <span className="bar"></span>
            <span className="highlight"></span>
            <label className="control-label">Business Phone number <small>(required)</small></label>
          </div>
          <div className="checkbox text-muted text-right">
            <label>
              <input type="checkbox" ref={(input) => this.hidePhone = input} defaultChecked={store.get('business').location.hide_phone} />
              {" Hide Phone Number from Public?"}
            </label>
          </div>

          <div className="group">
            <input className="form-control" type="text" ref={(input) => this.streetAddress = input} defaultValue={ store.get('business').location.street1 } required />
            <span className="bar"></span>
            <span className="highlight"></span>
            <label className="control-label">Business Street Address <small>(required)</small></label>
          </div>
          <div className="group">
            <input className="form-control" type="text" ref={(input) => this.street2 = input} defaultValue={ store.get('business').location.street2 } />
            <span className="bar"></span>
            <span className="highlight"></span>
            <label>address line 2 <small>(optional)</small></label>
          </div>

          <div className="group">
            <input className="form-control" type="text" ref={(input) => this.city = input} defaultValue={ store.get('business').location.city } required />
            <span className="bar"></span>
            <span className="highlight"></span>
            <label className="control-label">City <small>(required)</small></label>
          </div>

          <div className="row">
            <div className="group col-sm-8">
              <USStatesSelect
                className="form-control"
                value={store.get('business').location.state}
                onChange={(event) => { this.changeState(event.target.value) }}
                required
              />
            <label className="m-l-15px">State <small>(required)</small></label>
            </div>
            <div className="group col-sm-4">
              <input className="form-control" type="number" ref={(input) => this.zip = input} defaultValue={ store.get('business').location.zip_code } required />
              <span className="bar"></span>
              <span className="highlight"></span>
              <label className="m-l-15px">Zip Code <small>(required)</small></label>
            </div>
          </div>

          <div className="checkbox text-muted text-right">
            <label>
              <input type="checkbox" ref={(input) => this.hideAddress = input} defaultChecked={store.get('business').location.hide_address} />
              {" Hide Street Address from Public?"}
            </label>
          </div>

          <div className="group">
            <input className="form-control" type="text" ref={(input) => this.website = input} defaultValue={ store.get('business').website_url } />
            <span className="bar"></span>
            <span className="highlight"></span>
            <label className="control-label" style={{paddingBottom: 10}}>
              <span>Website URL </span>
              <span><small>(optional</small></span>
              <span className="hidden-xs">
                <small>. only include if you already have one</small>
              </span>
              <span><small>)</small></span>
            </label>
          </div>

          <div className="group">
            <select
              style={{ height: '12em' }}
              multiple="multiple"
              className="form-control"
              defaultValue={store.get('business').categories[0] ? [store.get('business').categories[0].id] : []}
              onChange={event => this.changeIndustry(event.target.value)}
              required
            >
              {
                store.get('categories').map(cat => (
                  <option key={cat.id} value={cat.id}>{cat.name}</option>
                ))
              }
            </select>
            <span className="bar"></span>
            <span className="highlight"></span>
            <label className="control-label">Business Category <small>(required)</small></label>
          </div>
          <div className="btn-group pull-right m-t-5px">
            <Link to="wizard/lookup" className="btn btn-default">Previous Step</Link>
            <button type="submit" className="btn btn-primary">Next Step</button>
          </div>
        </form>

      </div>
    );
  }
}

// export default BusInfo;
