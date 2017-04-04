// import React from 'react';
// import { Link } from 'react-router';
const { Link } = ReactRouter

class SelectPlan extends React.Component {
  constructor() {
    super();
    this.state = {
      payments: 'monthly'
    }
    this.selectBuild = this.selectBuild.bind(this);
    this.selectEngage = this.selectEngage.bind(this);

    store.set('plan', store.get('plan') || {} );
  }

  componentDidMount() {
    if (matchMedia('(max-width: 768px)').matches) {
      $('.engage-includes').click();
      $('.build-includes').click();
    }
  }

  selectBuild() {
    store.set('plan', { name: 'build', payments: this.state.payments });
    hashHistory.push('wizard/lookup');
  }

  selectEngage() {
    store.set('plan', { name: 'engage' });
    hashHistory.push('wizard/lookup');
  }

  renderPricing() {
    switch (this.state.payments) {
      case 'monthly':
        return (
          <li className="pricing-price no-borders">
              <span className="h2">
                $29.99 / month
              </span>
              <br />
              <small className="text-muted">
                Paid Monthly (annual option saves ~17%)
              </small>
          </li>
        );
      case 'annually':
        return (
          <li className="pricing-price no-borders">
              <span className="h2">
                $24.99 / month
              </span>
              <br />
              <small className="text-muted">
                Paid Annually
              </small>
          </li>
        );
      default:
        <div />
    }

  }

  render() {
    return (
      <div id="page-top" className="landing-page" style={{ backgroundColor: '#fff' }}>
        <section id="pricing" className="pricing">
            <div className="container">
              <div className="row m-b-lg">
                <div className="col-lg-12 text-center">
                  <div className="navy-line"></div>
                  <h1>Pick a plan that's right for you</h1>
                  <div className="col-sm-8 col-sm-offset-2">
                    <h3>IMPACT empowers your marketing with a built-in local marketing assistant that guides your efforts, tools specially built for local, unlimited users and content, and more from a smartphone or PC.</h3>
                  </div>
                  <div className="col-xs-12 text-center">
                    <label
                      className="btn btn-primary btn-sm btn-rounded"
                      onClick={() => this.setState({ payments: 'monthly' })}
                    ><input type="radio" checked={this.state.payments === 'monthly'}/> Monthly</label>
                    <label
                      className="btn btn-primary btn-sm btn-rounded m-l-5px"
                      onClick={() => this.setState({ payments: 'annually' })}
                    >
                      <input
                        type="radio"
                        checked={this.state.payments === 'annually'}
                      />
                    <span> Annually <small className="visible-xs-block">(Save ~ 17%)</small><small className="hidden-xs">(Save ~ 17%)</small></span>
                    </label>
                  </div>
                </div>
              </div>
            </div>
        </section>

        <div className="row">
          <div className="col-lg-4 wow zoomIn col-lg-offset-1 m-t-10px">
            <ul className="pricing-plan list-unstyled panel" >
              <li className="pricing-title no-borders btn btn-block" onClick={this.selectEngage}>
                Engage
              </li>
              <li className="no-borders">
                Local Marketing Assistant provides recommendations and reminders while built-in tools make marketing fast, easy and even fun
              </li>
              <li className="no-borders">
                <span className="h2" style={{ color: '#1ab394' }}>Free - Seriously!</span>
              </li>
              <div className="text-center p-h-sm">
                <p className="text-muted text-center">
                  <a data-toggle="collapse" href="#engage-collapse" aria-expanded="true" className="engage-includes text-muted"><strong>Includes <i className="fa fa-chevron-down"></i></strong></a>
                </p>
              </div>
              <div id="engage-collapse" className="panel-collapse in" aria-expanded="true">
                <li>
                  Virtual Local Marketing Assistant
                </li>
                <li>
                  Customer Reviews Generation <br /><small>Up to 5 Requests / mo</small>
                </li>
                <li>
                  Simple Content Engine <br /><small>Events, Offers, Reviews, Quick Posts</small>
                </li>
                <li>
                  Contacts Database <br /><small>Unlimited Companies, Up to 100 People</small>
                </li>
                <li>
                  Distribution <br /><small>Facebook, Local Publisher Network</small>
                </li>
                <li>
                  Embeddable Tools & Basic Form Builder <span className="badge">coming soon</span>
                </li>
              </div>

              <li>
                <Link
                  to="wizard/lookup"
                  onClick={this.selectEngage}
                  className="btn btn-primary btn-sm btn-rounded"
                >
                  Select
                </Link>
              </li>
            </ul>
          </div>
          <div className="col-lg-6 wow zoomIn m-t-30px">
              <ul className="pricing-plan list-unstyled selected" >
                  <li className="pricing-title btn btn-block" onClick={this.selectBuild}>
                      Build
                  </li>
                  <li className="no-borders">
                    Build your business with expanded local marketing tools and automation at a price you can afford
                  </li>
                  {this.renderPricing()}

                  <div className="text-center p-h-sm">
                    <p className="text-muted">
                      <a data-toggle="collapse" href="#build-collapse" aria-expanded="true" className="build-includes text-muted"><strong>Includes <i className="fa fa-chevron-down"></i></strong></a>
                    </p>
                  </div>

                  <div id="build-collapse" className="panel-collapse in" aria-expanded="true">
                    <li className="font-italic">
                        -- Everything in Engage Plus --
                    </li>

                    <li>
                        Customer Reviews Generation <br />
                          <small>Unlimited Monthly Requests</small>
                    </li>
                    <li>
                        Expanded Content Engine<br />
                          <small>Adds "Before & After" Posts and Galleries</small>
                    </li>
                    <li>
                        Expanded Contacts Database<br />
                          <small>Organize Unlimited Companies and Up to 500 People with Lists & Segments and Assignable To-Do's with Reminders</small>
                    </li>

                    <li>
                        Social Scheduling with Instagram, Twitter <span className="badge">coming soon</span>
                    </li>
                    <li>
                        Advanced Forms & Landing Pages <span className="badge">coming soon</span>
                    </li>
                  </div>

                  <li>
                    <Link
                      to="wizard/lookup"
                      onClick={this.selectBuild}
                      className="btn btn-primary btn-sm btn-rounded"
                    >Select
                    </Link>
                  </li>

              </ul>
          </div>
        </div>
        <div className="row m-t-lg">
            <div className="col-lg-8 col-lg-offset-2 text-center m-t-lg">
                <p>Upgrade, downgrade or cancel at any time. Add an always-modern, mobile, search and social media optimized website starting at just $375 for guided setup - only available with paid Build plan.</p>
            </div>
        </div>
      </div>
    );
  }
}

// export default SelectPlan;
