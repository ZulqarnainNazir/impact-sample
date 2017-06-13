
class OnboardingContainer extends React.Component {
  constructor() {
    super();
    console.log(store.get('plan'));
    const steps = ["wizard/lookup", "wizard/businfo", "wizard/account", "wizard/extended", "wizard/confirm"]
    // this.goToCurrentStep();
    this.state = {
      currentStep: steps.indexOf(window.location.hash.slice(2)),
      steps: steps
    }
    this.startOver = this.startOver.bind(this);
    this.prevStep = this.prevStep.bind(this);
    this.nextStep = this.nextStep.bind(this);
    this.completedSteps = this.completedSteps.bind(this);
    this.totalSteps = store.get('plan').name === 'build' ? 4 : 3;
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

  completedSteps() {
    let steps = 0
    if (store.get('busInfoComplete')) {
      steps += 1;
    }
    if (store.get('lookupComplete')) {
      steps += 1;
    }
    // if (store.get('plan') && store.get('plan').name) {
    //   steps += 1;
    // }
    if (store.get('accountComplete')) {
      steps += 1;
    }
    return steps;
    // console.log("steps!", store.get('busInfoComplete') + store.get('lookupComplete'));
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
          <h2 className="text-center">Grow Your Business with Locable's Marketing Essentials Platform
</h2>
          <h4 className="text-center">For authentic local businesses who want to grow their business without the headache while supporting their community!</h4>
        </div>
        <div className="ibox-content">
          <div className="row">
            <div className="col-md-6">
              <h1 className="text-center">Grow Your Business with Locable's Local Marketing Platform</h1>
              <h3 className="text-center">For authentic local businesses Who Want To Grow Their Business Without the Headache while supporting their community!</h3>
              <img className="center-block img-responsive thumbnail" src="https://assets.locable.com/r/medium/420b6dee-e528-4629-825a-162c6ef46035/Buzz%20Face%20Welcome.png" alt="Suggestions" />
              <p className="lead">A Simple, Stepwise Approach to Better Local Marketing - Even If You're Not Marketing or Tech-savvy. <i> Really</i>!</p>
              <ul className="list-unstyled benefits" style={{lineHeight: 2}}>
                <li>
                  <i className="fa fa-address-card fa-fw"></i> Track &amp; Manage Your Contacts &amp; Relationships
                </li>
                <li>
                  <i className="fa fa-star fa-fw" aria-hidden="true"></i> Grow Your Reputation, Leverage Your Network &amp; Increase Word-of-Mouth Referrals
                </li>
                <li>
                  <i className="fa fa-check-square-o fa-fw"></i> Guided marketing missions to keep you moving forward
                </li>
                <li>
                  <i className="fa fa-bold fa-fw"></i> Quickly and easily create marketing content to improve SEO &amp; Social Media while converting visitors
                </li>
                <li>
                  <span className="fa fa-check text-success"></span><i><a target="_blank" href="http://locable.pgtb.me/qNcV6Q"> #SupportLocal</a></i>
                </li>
              </ul>
              <hr/>
              <p className="features">
                <b>Key Features:</b> Track contacts, create simple forms and an Instant Contact Page™, collect &amp; promote customer reviews with the Main Street CRM™. Complete simple marketing missions suggested by Buzz, our virtual marketing assistant, using built in content and distribution tools.
              </p>
            </div>
            <div className="onboarding-wizard col-md-6">
              <div className="row steps">
                <div className="col-sm-3">
                  <Link className={`btn btn-default btn-block ${store.get('lookupComplete') ? 'completed' : ''}`} activeClassName="current-step" to="wizard/lookup">
                    1. Lookup
                  </Link>
                </div>
                <div className="col-sm-3">
                  <Link className={`btn btn-default btn-block ${store.get('busInfoComplete') ? 'completed' : ''}`} to="wizard/businfo" activeClassName="current-step">
                    2. Details
                  </Link>
                </div>
                <div className="col-sm-3">
                  <Link className={`btn btn-default btn-block ${store.get('accountComplete') ? 'completed' : ''}`} to="wizard/account" activeClassName="current-step">
                    3. Account
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
              <div className="progress progress-striped">
                <div
                  className="progress-bar progress-bar-primary"
                  style={{ width: `${this.completedSteps() / this.totalSteps * 100}%`}}
                >
                  {this.completedSteps()}/{this.totalSteps}
                </div>
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
