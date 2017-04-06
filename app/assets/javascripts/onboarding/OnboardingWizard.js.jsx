// import React from 'react';
// import { render } from 'react-dom';
// import './index.css';
// import { Router, Route, IndexRoute, browserHistory } from 'react-router';
// import App from './App';
// import Basics from './components/Basics';
// import BusInfo from './components/BusInfo';
// import Extended from './components/Extended';
// import Account from './components/Account';
// import Confirm from './components/Confirm';
// import SelectPlan from './components/SelectPlan';
// import Success from './components/Success';


const { Router, Route, IndexRoute, hashHistory } = ReactRouter;

const OnboardingWizard = (props) => {
  if (window.location.hash === "#reset") {
    store.clear();
    hashHistory.push("/");
  }
  store.set('categories', props.categories);
  if (props.current_user) {
    store.set('user', props.current_user);
    store.set('accountComplete', true);
  }
  return (
    <Router history={hashHistory}>
      <Route path="/" component={SelectPlan}/>
      <Route path="/wizard" component={OnboardingContainer}>
        <IndexRoute component={Lookup} />
        <Route path="lookup" component={Lookup} />
        <Route path="businfo" component={BusInfo} />
        <Route path="account" >
          <IndexRoute component={Account} />
          <Route path="registration" component={Account} />
          <Route path="login" component={Login} />
        </Route>
        {/*<Route path="extended" component={Extended} />*/}
        <Route path="billing" component={Billing} />
        <Route path="confirm" component={Confirm} />
      </Route>
    </Router>
  );
}

// render(router, document.querySelector('#root'));
