// import React from 'react';
// import { hashHistory } from 'react-router';

class Extended extends React.Component {

  constructor() {
    super();
    this.completeStep = this.completeStep.bind(this);
  }

  completeStep(event) {
    event.preventDefault();

    store.set('facebook', this.facebook.value)
    store.set('twitter', this.twitter.value)
    store.set('yelp', this.yelp.value),

    // this.props.saveValues(data)
    store.set('extendedComplete', true)
    hashHistory.push("wizard/confirm")
    // this.props.nextStep()
  }

  update(field) {
    return e => {
      store.set(
        'business',
        _.merge({}, store.get('business'), { [field]: e.currentTarget.value })
      );
    }
  }

  render() {
    return (
      <div>
        <h1> {store.get('user').first_name}, could you tell us more about {store.get('business').name || "your business"}?</h1>
        <p> All fields are optional.  If you do not have a given page, feel free to skip it </p>

          <form ref={(input) => this.questions = input}>

            <div className="group">
              <input type="text" ref={(input) => this.facebook = input} defaultValue={ store.get('business').facebook_id } required />
              <span className="highlight"></span>
              <span className="bar"></span>
              <label> <i className="fa fa-facebook" aria-hidden="true"></i> Facebook page</label>
            </div>

            <div className="group">

              <input type="text" ref={(input) => this.twitter = input} defaultValue={ store.twitter } required />
              <span className="highlight"></span>
              <span className="bar"></span>
              <label> <i className="fa fa-twitter" aria-hidden="true"></i> Twitter page</label>
            </div>

            <div className="group">

              <input type="text" ref={(input) => this.yelp = input} defaultValue={ store.yelp  } required />
              <span className="highlight"></span>
              <span className="bar"></span>
              <label> <i className="fa fa-yelp" aria-hidden="true"></i> Yelp page</label>
            </div>

            <div className="group">
              <input type="text" ref={(input) => this.hours = input} defaultValue={ store.hours } required />
              <span className="highlight"></span>
              <span className="bar"></span>
              <label>this will be a table of store hours</label>
            </div>

              <ul className='form-fields'>
                <li className="form-footer">
                  <Link to="wizard/account" className="btn btn-default">Back</Link>
                  <button className="btn -primary pull-right" onClick={this.completeStep}>Next Step</button>
                </li>
              </ul>
          </form>
      </div>
    );
  }
}

// export default Extended;
