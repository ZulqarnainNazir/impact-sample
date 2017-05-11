// import React, { PropTypes } from 'react'

class Login extends React.Component {
  constructor() {
    super()
    this.state = {
      submitting: false,
      errors: '',
    };
    this.completeStep = this.completeStep.bind(this);
    this.onSuccess = this.onSuccess.bind(this);
    this.onError = this.onError.bind(this);
    this.nextStep = this.nextStep.bind(this);

    store.set('user', store.get('user') || {});
  }

  componentDidMount() {
    if (this.email) {
      this.email.focus();
    }
  }

  completeStep(event) {
    event.preventDefault();
    this.setState({
      submitting: true,
      errors: ''
    });
    const user = {
      email: this.email.value,
    };
    store.set('user', _.merge({}, user));
    if (this.formIsValid()) {
      $.ajax({
        url: '/users/sign_in',
        type: 'POST',
        dataType: 'json',
        data: { user: {
          email: this.email.value,
          password: this.password.value,
        }},
        success: this.onSuccess,
        error: this.onError,
      });
    } else {
      this.setState({ submitting: false })
    }
  }

  formIsValid() {
    if (!this.email.value) {
      this.setState({ errors: 'Email is required'});
      return false;
    }
    if (!this.password.value) {
      this.setState({ errors: 'Password is required' });
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
    store.set('user', _.merge({}, store.get('user'), userResponse))
    store.set('accountComplete', true);
    this.nextStep();
  }

  onError(resp) {
    console.log(resp);
    this.setState({
      errors: JSON.parse(resp.responseText).error,
      submitting: false,
    });
  }

  render () {
    if (store.get('accountComplete')) {
      return (
        <div className="row">
          <h2>Succesffully Created your account!</h2>
          <p>Proceed to the next step to finish signing up.</p>
          <div className='btn-group pull-right m-t-5px'>
            <Link to="wizard/businfo" className="btn btn-default">Previous Step</Link>
            <button className="btn btn-primary" onClick={this.nextStep} disabled={!store.get('accountComplete')}>
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
            <span className="alert alert-warning">Don't have an Account? <Link to="wizard/account">Sign up here.</Link></span>
          </div>

          <form className="form col-md-8" ref={(input) => this.questions = input}>
            {this.state.errors ? <div className="alert alert-danger m-t-30px">{JSON.stringify(this.state.errors)}</div> : ''}

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
            <div className='btn-group pull-right m-t-5px'>
              <Link to="wizard/businfo" className="btn btn-default">Previous Step</Link>
              <button type="submit" className="btn btn-primary" onClick={this.completeStep} disabled={this.state.submitting || store.get('accountComplete')}>
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

// export default Login;
