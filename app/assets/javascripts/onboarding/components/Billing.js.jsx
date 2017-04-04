class Billing extends React.Component {
  constructor() {
    super();
    this.state = {
      form: '<div />'
    }
    this.yearRange = [];
    for (let i = new Date().getFullYear(); i <= new Date().getFullYear() + 10; i++) {
      this.yearRange.push(i);
    }

    this._onSuccess = this._onSuccess.bind(this);
    store.set('creditCard', store.get('creditCard') || {});
  }

  update(field) {
    return e => {
      store.set(
        'creditCard',
        _.merge({}, store.get('creditCard'), { [field]: e.target.value }),
      );
    }
  }

  _onSuccess(data) {
    // console.log(data);
    this.setState({ form: data });
  }

  _onSubmit(e) {
    e.preventDefault();
    console.log('form submission');
    store.set('creditCardCompleted', true);
    hashHistory.push('wizard/confirm');
  }

  render() {
    return (
      <div>
        <h2>Enter Your Payment Details Below</h2>
        <form className="form-horizontal m-t-5px" onSubmit={this._onSubmit}>
          <fieldset>
            <div className="form-group">
              <label className="col-sm-2 control-label">Name on Card</label>
              <div className="col-sm-10">
                <div className="col-xs-6 col-sm-5">
                  <input
                    type="creditcard"
                    name="creditcard[first_name]"
                    placeholder='First Name'
                    value={store.get('creditCard').first_name}
                    onChange={this.update('first_name')}
                    className='form-control'
                    required
                  /></div>
                <div className="col-xs-6 col-sm-5">
                  <input
                    type="creditcard"
                    name="creditcard[last_name]"
                    placeholder='Last Name'
                    value={store.get('creditCard').last_name}
                    onChange={this.update('last_name')}
                    className='form-control'
                    required
                  /></div>
              </div>
            </div>

            <div className="form-group">
              <label className="col-sm-2 control-label">Card Number</label>
              <div className="col-sm-10">
                <div className="col-xs-12 col-sm-5">
                  <input
                    type="text"
                    placeholder='Card Number'
                    value={store.get('creditCard').number}
                    onChange={this.update('number')}
                    className='form-control'
                    required
                  /></div>
                <div className="col-xs-8 col-sm-5">
                  <select
                    className="form-control"
                    value={store.get('creditCard').brand}
                    onChange={this.update('brand')}
                    required
                  >
                    <option value="visa">Visa</option>
                    <option value="master">MasterCard</option>
                    <option value="american_express">American Express</option>
                  </select>
                </div>
              </div>
            </div>

            <div className="form-group">
              <label className="col-sm-2 control-label">Expiration</label>
              <div className="col-sm-10">
                <div className="col-xs-4 col-sm-3">
                  <select
                    className="form-control"
                    value={store.get('creditCard').month}
                    onChange={this.update('month')}
                    required
                  >
                    <option>Month</option>
                    <option value="1">Jan (01)</option>
                    <option value="2">Feb (02)</option>
                    <option value="3">Mar (03)</option>
                    <option value="4">Apr (04)</option>
                    <option value="5">May (05)</option>
                    <option value="6">June (06)</option>
                    <option value="7">July (07)</option>
                    <option value="8">Aug (08)</option>
                    <option value="9">Sep (09)</option>
                    <option value="10">Oct (10)</option>
                    <option value="11">Nov (11)</option>
                    <option value="12">Dec (12)</option>
                  </select>

                </div>
                <div className="col-xs-5 col-sm-2">
                  <select
                    className="form-control"
                    value={store.get('creditCard').year}
                    onChange={this.update('year')}
                    required
                  >
                    <option>Year</option>
                    {this.yearRange.map(year => (
                      <option key={year} value={year}>{year}</option>
                    ))}
                  </select>
                </div>
              </div>
            </div>

            <div className="form-group">
              <label className="col-sm-2 control-label">CVC</label>
              <div className="col-sm-10">
                <div className="col-xs-4 col-sm-2">
                  <input
                    type="text"
                    placeholder='CVC'
                    value={store.get('creditCard').verification_value}
                    onChange={this.update('verification_value')}
                    className='form-control text-center'
                    required
                  />
                </div>
                <span className="help-block m-b-none">3 or 4 digit security code on back of card.</span>
              </div>
            </div>

            <div className="form-group">
              <label className="col-sm-2 control-label">Zip</label>
              <div className="col-sm-10">
                <div className="col-xs-5">
                  <input
                    type="text"
                    name="creditcard[]"
                    className='form-control text-center'
                    value={store.get('creditCard').zip_code}
                    onChange={this.update('zip_code')}
                    required
                  />
                </div>
              </div>
            </div>

          </fieldset>
          <div className="btn-group pull-right col-md-12 m-t-5px">
            <Link to="wizard/account" className="btn btn-default">Previous Step</Link>
            <button type="submit" className="btn btn-primary">Submit Form</button>
          </div>
        </form>
      </div>
    );
  }
}
