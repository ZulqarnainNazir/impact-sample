
class OnboardingContainer extends React.Component {
  constructor() {
    super();
    console.log(store.get('plan'));
    const steps = ["wizard/lookup", "wizard/businfo", "wizard/account", "wizard/extended", "wizard/confirm"]
    this.goToCurrentStep();
    this.state = {
      currentStep: steps.indexOf(window.location.hash.slice(2)),
      steps: steps
    }
    this.startOver = this.startOver.bind(this);
    this.prevStep = this.prevStep.bind(this);
    this.nextStep = this.nextStep.bind(this);
  }

  goToCurrentStep() {
    if (store.get('busInfoComplete')) {
      hashHistory.push('wizard/account');
    } else if (store.get('lookupComplete')) {
      hashHistory.push('wizard/businfo');
    } else if (store.get('plan') && store.get('plan').name) {
      hashHistory.push('wizard/lookup');
    }
  }

  startOver(e) {
    e.preventDefault()
    swal({
        title: "Are you sure?",
        text: "You will lose all data already entered and be redirected back to the plan selection page.",
        type: "warning",
        confirmButtonColor: "#ED5565",
        confirmButtonText: 'Start Over',
        showCancelButton: true,
        cancelButtonText: 'Stay Here',
      },
      () => {
        const categories = store.get('categories');
        store.clear();
        store.set('categories', categories);
        hashHistory.push('/');
      }
    );
  }

  prevStep() {
    hashHistory.push(this.state.steps[this.state.currentStep - 1]);
    this.setState({ currentStep: this.state.currentStep - 1 });
  }

  nextStep() {
    hashHistory.push(this.state.steps[this.state.currentStep + 1]);
    this.setState({ currentStep: this.state.currentStep + 1 });
  }

  render() {
    return (
      <div className="ibox float-e-margins">
        <div className="ibox-title">
          <h2 className="text-center">Confirm Your Business Information</h2>
          <p className="text-center">Take just a few minutes to confirm your business and get started</p>
        </div>
        <div className="onboarding-wizard ibox-content">
          <div className="row steps">
            <div className="col-sm-3">
              <Link className={`btn btn-default btn-block ${store.get('lookupComplete') ? 'completed' : ''}`} activeClassName="current-step" to="wizard/lookup">
                1. Lookup
              </Link>
            </div>
            <div className="col-sm-3">
              <Link className={`btn btn-default btn-block ${store.get('busInfoComplete') ? 'completed' : ''}`} to="wizard/businfo" activeClassName="current-step">
                2. Basic Details
              </Link>
            </div>
            <div className="col-sm-3">
              <Link className={`btn btn-default btn-block ${store.get('accountComplete') ? 'completed' : ''}`} to="wizard/account" activeClassName="current-step">
                3. Account Info
              </Link>
            </div>
            {/*<div className="col-sm-3">
              <Link className={`btn btn-default btn-block ${store.get('extendedComplete') ? 'completed' : ''}`} to="wizard/extended" activeClassName="current-step">
                4. Extended
              </Link>
            </div>*/}
            {
              store.get('plan').name === 'build' ? (
                <div className="col-sm-3">
                  <Link className={`btn btn-default btn-block ${store.get('creditCardCompleted') ? 'completed' : ''}`} to="wizard/billing" activeClassName="current-step">
                    4. Payment Details
                  </Link>
                </div>
              ) : <div />
            }
          </div>
          <div className="content ibox-content no-padding">
            {this.props.children}
          </div>
          <div>
            <button
              className="btn btn-danger"
              onClick={this.startOver}
              style={{ display: location.hash === '#/wizard/confirm' ? 'none' : ''}}
            >Cancel</button>
          </div>
        </div>
      </div>
    );
  }
}

// <div className="btn-group pull-right">
//   <button
//     onClick={this.prevStep}
//     className={this.state.currentStep <= 0 ? "btn btn-default disabled" : "btn btn-primary"}
//   >Previous</button>
//   <button
//     onClick={this.nextStep}
//     className={this.state.currentStep >=4 ? "btn btn-default disabled" : "btn btn-primary"}
//   >Next</button>
// </div>
