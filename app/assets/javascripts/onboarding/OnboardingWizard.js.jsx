// import React from 'react';
// import { render } from 'react-dom';
// import './index.css';
// import { Router, Route, IndexRoute, browserHistory } from 'react-router';
// import App from './App';
// import Basics from './components/Basics';
// import BusInfo from './components/BusInfo';
// import Extended from './components/Extended';
// import Confirm from './components/Confirm';
// import SelectPlan from './components/SelectPlan';
// import Success from './components/Success';


const { Router, Route, IndexRoute, hashHistory } = ReactRouter;

const OnboardingWizard = (props) => {
  console.log(props);
  if (window.location.hash === "#reset") {
    store.clear();
    hashHistory.push("/");
  }
  store.set('categories', props.categories);
  if (props.invited_user) {
    store.set('user', props.invited_user);
  }
  if (props.invited_company) {
    // console.log("there was an invited company");
    store.set('business', props.invited_company);
    store.set('lookupComplete', true);
    store.set('plan', { name: 'engage' });
    hashHistory.push('wizard/businfo')
  }
  if (props.current_user) {
    store.set('user', props.current_user);
    store.set('accountComplete', true);
  }
  store.set('build_plan_id', props.build_plan_id);
  if (props.quick_invite) {
    store.set('plan', { name: 'engage' });
    hashHistory.push('wizard/lookup')
  }
  store.set('imageSetup', props.image_setup);

  return (
    <Router history={hashHistory}>
      <Route path="/" component={SelectPlan}/>
      <Route path="/wizard" component={OnboardingContainer}>
        <IndexRoute component={Lookup} />
        <Route path="lookup" component={Lookup} />
        <Route path="businfo" component={BusInfo} />
        {/*<Route path="extended" component={Extended} />*/}
        <Route path="billing" component={Billing} />
      </Route>
      <Route path="/confirm" component={Confirm} />
    </Router>
  );
}

// render(router, document.querySelector('#root'));
