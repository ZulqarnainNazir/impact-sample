// import React from 'react';
// import { browserHistory } from 'react-router';

class Confirm extends React.Component {
  constructor() {
    super()
    this.onError = this.onError.bind(this);
  }

  completeStep() {
    // store.set('confirmed', true)
    // hashHistory.push('/success')
    // do form submit logic here
    $.ajax({
      method: 'POST',
      url: '/onboard/users',
      dataType: 'html',
      data: {
        plan: store.get('plan'),
        user: store.get('user'),
        business: store.get('business'),
        creditcard: store.get('creditCard'),
      },
      success: this.onSuccess,
      error: this.onError,
    });
  }

  onSuccess(data) {
    // console.log(data);
    const location = JSON.parse(data).location
    // redirects to new page supplied by rails
    if (store.get('plan').name === 'build') {
      $.ajax({
        url: `/businesses/${store.get('business').id}/subscriptions/plan`,
        type: 'POST',
        dataType: 'html',
        data: {
          business_id: store.get('business').id,
          subscription: {
            subscription_plan_id: 2,
            annual: store.get('plan').payments === 'annual',
          },
        },
        success: (resp) => {
          store.clear();
          window.location.href = `/businesses/${store.get('business').id}/subscriptions/setup_billing`
        },
        error: (resp) => console.log(resp),
      });
    } else if (location) {
      store.clear();
      console.log(location);
      window.location.href = location;
    }
  }

  onError(data) {
    console.log(data);
  }

  componentDidMount() {
    this.completeStep();
  }

  render() {
    const c = store.get('business').categories[0];
    let category;
    if (c) {
      category = _.find(store.get('categories'), { id: parseInt(c.id) });
    }

    return (
      <div className="ibox float-e-margins">
        <div className="ibox-header">
          <h2>Submitting your information</h2>
        </div>
        <div className="ibox-content text-center">
          <i className="fa fa-spinner fa-spin fa-5x" />
        </div>
      </div>
    )
  }
}

// export default Confirm;
