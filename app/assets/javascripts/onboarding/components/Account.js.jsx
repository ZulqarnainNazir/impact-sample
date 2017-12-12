// import React from 'react';
// import { hashHistory } from 'react-router';

class Account extends React.Component {

  constructor() {
    super();
    this.state = {
      submitting: false,
      errors: '',
    }
    this.completeStep = this.completeStep.bind(this);
    this.onSuccess = this.onSuccess.bind(this);
    this.onError = this.onError.bind(this);
    this.nextStep = this.nextStep.bind(this);

    store.set('user', store.get('user') || {});
  }

  componentDidMount() {
    if (this.firstName) this.firstName.focus();
  }

  completeStep(event) {
    event.preventDefault();
    this.setState({
      submitting: true,
      errors: ''
    });
    const user = {
      first_name: this.firstName.value,
      last_name: this.lastName.value,
      email: this.email.value,
    };
    store.set('user', _.merge({}, user));
    if (this.formIsValid()) {
      $.ajax({
        url: '/users?confirm=false',
        type: 'POST',
        dataType: 'json',
        data: { user: {
          first_name: this.firstName.value,
          last_name: this.lastName.value,
          email: this.email.value,
          password: this.password.value,
          password_confirmation: this.password_confirmation.value,
        }},
        success: this.onSuccess,
        error: this.onError,
      });
    } else {
      this.setState({ submitting: false })
    }
  }

  formIsValid() {
    if (!this.firstName.value) {
      this.setState({ errors: 'Name is required'});
      return false;
    }
    if (!this.lastName.value) {
      this.setState({ errors: 'Name is required'});
      return false;
    }
    if (!this.email.value) {
      this.setState({ errors: 'Email is required'});
      return false;
    }
    if (!this.password.value || this.password.value.length < 8) {
      this.setState({ errors: 'Password must be 8 or more characters' });
      return false;
    } else if (this.password.value !== this.password_confirmation.value) {
      this.setState({ errors: 'Passwords must match' });
      return false;
    }
    return true
  }

  nextStep(event) {
    if (event) {
      event.preventDefault();
    }
    // if (store.get('plan').name === 'build'){
    //   hashHistory.push('wizard/billing')
    // } else {
      hashHistory.push("wizard/confirm");
    // }
  }

  prevStep(event) {
    if (event) {
      event.preventDefault();
    }
    hashHistory.push("wizard/businfo");
  }

  onSuccess(userResponse) {
    this.setState({
      submitting: false,
    });
    store.set('user', _.merge({}, store.get('user'), userResponse));
    store.set('accountComplete', true);
    this.nextStep();
  }

  onError(resp) {
    this.setState({
      errors: JSON.parse(resp.responseText).errors,
      submitting: false,
    });
  }

  render() {
    if (store.get('accountComplete')) {
      return (
        <div className="row">
          <div className="col-md-12">
            <h2>Successfully Created Your Account!</h2>
            <p>Proceed to the next step to finish signing up.</p>
          </div>
          <div className='btn-group pull-right m-t-5px'>
            <button className="btn btn-default" onClick={this.prevStep}>
              Previous Step
            </button>
            <button className="btn btn-primary" onClick={this.nextStep}>
              Next Step
            </button>
          </div>
        </div>
      );
    } else {
      return (
        <div className="row">
          <div className="col-md-12">
            <h1>Create Your Login</h1>
            <span className="alert alert-warning">Already have an Account? <Link to="wizard/account/login">Log in here</Link> instead.</span>
          </div>

          <form className="form col-md-12" ref={(input) => this.questions = input}>
            {this.state.errors ? <div className="alert alert-danger m-t-30px">{JSON.stringify(this.state.errors)}</div> : ''}
            <div className="row">
              <div className="group col-sm-6">
                <input className="form-control" type="text" ref={(input) => this.firstName = input} defaultValue={ store.get('user').first_name } required />
                <span className="bar"></span>
                <span className="highlight"></span>
                <label className="m-l-15px">First Name</label>
              </div>

              <div className="group col-sm-6">
                <input className="form-control" type="text" ref={(input) => this.lastName = input} defaultValue={ store.get('user').last_name } required />
                <span className="bar"></span>
                <span className="highlight"></span>
                <label className="m-l-15px">Last Name</label>
              </div>
            </div>


            <div className="group">
              <input className="form-control" type="email" ref={(input) => this.email = input} defaultValue={ store.get('user').email }  required />
              <span className="bar"></span>
              <span className="highlight"></span>
              <label className="">Email</label>
            </div>

            <div className="group">
              <input className="form-control" type="password" ref={(input) => this.password = input} defaultValue={ store.get('user').password }  required />
              <span className="bar"></span>
              <span className="highlight"></span>
              <label className="">Password, min 8 characters</label>
            </div>
            <div className="group">
              <input className="form-control" type="password" ref={(input) => this.password_confirmation = input} defaultValue={ store.get('user').password_confirmation }  required />
              <span className="bar"></span>
              <span className="highlight"></span>
              <label className="">Confirm Password</label>
            </div>
            <div className='btn-group pull-right m-t-5px'>
              <a className="btn btn-default" onClick={this.prevStep}>
                Previous Step
              </a>
              <button className="btn btn-primary" onClick={this.completeStep} disabled={this.state.submitting || store.get('accountComplete')}>
                {
                  this.state.submitting ? <i className="fa fa-spinner fa-spin" /> : ''
                }
                {" Submit"}
              </button>
            </div>
          </form>
        </div>
      );
    }
  }
}

// export default Account;
