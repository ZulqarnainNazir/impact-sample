// import React from 'react';
// import { hashHistory } from 'react-router';

class Lookup extends React.Component {

  constructor(props) {
    super(props);
    this.state = {
      search: store.get("first_search"),
      matches: [],
      loading: false,
      manualSubmit: false
    };
    this.handleSubmit = this.handleSubmit.bind(this);
    this.renderMatches = this.renderMatches.bind(this);
    this.selectBusiness = this.selectBusiness.bind(this);
    store.set('business', store.get('business') || { location: {} });
    store.set('plan', store.get('plan') || { name: 'engage' });
  }

  componentDidMount() {
   this.searchInput.focus();
   if(this.state.search != ""){
     this.initial_search();
   }
  }

  initial_search() {
    console.log("about to perform search");
    const search = this.state.search;
    $.ajax({
      url: `/onboard/users/new/?query=${search}`,
      dataType: 'json',
      success: (matches) => {
        this.setState({
          matches,
          loading: false,
          progress: search.length > 0 ? '50%' : '0%',
          manualSubmit: true,
        });
      }
    });
  }

  update(field) {
    return e => {
      this.setState({
        [field]: e.currentTarget.value,
        loading: true
      });
      if (field === 'search') {
        const search = e.currentTarget.value;
        $.ajax({
          url: `/onboard/users/new/?query=${e.currentTarget.value}`,
          dataType: 'json',
          success: (matches) => {
            this.setState({
              matches,
              loading: false,
              progress: search.length > 0 ? '50%' : '0%',
              manualSubmit: true,
            });
          }
        });
      }
    }
  }

  handleSubmit(e) {
    e.preventDefault();
    this.setState({ progress: '100%' });
    store.set('lookupComplete', true);
    store.set(
      'business',
      { name: this.state.search, location: {}, categories: [] }
    );
    store.set('busInfoComplete', false);
    hashHistory.push("wizard/businfo");
  }

  selectBusiness(business, e) {
    e.preventDefault();
    this.setState({ progress: '100%' });
    store.set('business', business);
    store.set('lookupComplete', true);
    store.set('busInfoComplete', false);
    hashHistory.push("wizard/businfo");
  }

  renderMatches() {
    const search = this.state.search;

    if (this.state.loading) {
      return <div className="text-center">
        <i className="fa fa-spinner fa-5x fa-spin" />
      </div>
    }

    if (this.state.matches) {
      return (
        <div className="row m-b-5px m-t-10px">
          {this.state.matches.map(bus => (
            <Business
              key={bus.id}
              onClick={this.selectBusiness.bind(null, bus)}
              {...bus}
            />
          ))}
        </div>
      )
    }
  }

  render() {

    return (
      <div>
        <h1> Let's start with the name of your business or organization </h1>
        <form className='form-horizontal' onSubmit={this.handleSubmit}>
          <div className="group">
            <input
              ref={(input) => { this.searchInput = input; }}
              className="form-control"
              type="text"
              value={this.state.search}
              onChange={this.update("search")}
              required
            />
            <span className="bar"></span>
            <span className="highlight"></span>
            <label className="">Business / Organization Name <small>(Click to Type)</small></label>
          </div>
        </form>

        {this.renderMatches()}

        {
          this.state.manualSubmit ? (
            <div className="form-horizontal">
              <div className="form-group">
                <label className="col-sm-12 control-label">Can't find your business?</label>
                <div className="col-sm-12">
                  <button className="form-control btn btn-primary" onClick={this.handleSubmit}> Add it now! </button>
                </div>
              </div>
            </div>
          ) : ''
        }

      </div>
    );
  }
}

// export default Lookup;
