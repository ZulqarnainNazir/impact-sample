// import React from 'react';
// import { hashHistory } from 'react-router';

class CRMLookup extends React.Component {

  constructor(props) {
    super(props);
    this.state = {
      search: "",
      matches: [],
      loading: false,
      manualSubmit: false
    };
    this.handleSubmit = this.handleSubmit.bind(this);
    this.renderMatches = this.renderMatches.bind(this);
    this.selectBusiness = this.selectBusiness.bind(this);
    // store.set('business', store.get('business') || { location: {} });
  }

  componentDidMount() {
   this.searchInput.focus();
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
          },
          error: (m) => { console.log(m) }
        });
      }
    }
  }

  handleSubmit(e) {
    e.preventDefault();
  }

  selectBusiness(business, e) {
    e.preventDefault();
  }

  renderMatches() {
    const search = this.state.search;

    if (this.state.loading) {
      return <div className="text-center">
        <i className="fa fa-spinner fa-5x fa-spin" />
      </div>
    }

    if (this.state.matches) {
      let businesses = [];
      this.state.matches.forEach((bus, i) => {
        let disabled = bus.company && bus.company.user_business_id === this.props.business_id
        // console.log(disabled);
        let href;
        if (disabled) {
          href = `${window.location.href.slice(0, -4)}${bus.company.id}/edit`
        } else {
          href = `${window.location.href.slice(0, -4)}?add=true&new_business_id=${bus.id}`
        }
        businesses.push(
          <CRMBusiness
            href={href}
            key={bus.id}
            onClick={this.selectBusiness.bind(null, bus)}
            disabled={disabled}
            {...bus}
            owners={[]}
          />
        );
        if (i % 3 === 2) {
          businesses.push(<div className="clearfix"/>);
        }
      });
      return (
        <div className="row m-b-5px m-t-10px">
          {businesses}
        </div>
      )
    }
  }

  render() {

    return (
      <div>
        <h1> What is the name the business you'd like to add? </h1>
        <div className='form-horizontal' action={`${window.location.href.slice(0, -4)}?force=true&name=N&search_add=true`}>
          <div className="group">
            <input
              ref={(input) => { this.searchInput = input; }}
              name="name"
              className="form-control"
              type="text"
              value={this.state.search}
              onChange={this.update("search")}
              required
            />
            <span className="bar"></span>
            <span className="highlight"></span>
            <label className="">Business / Organization Name <small>(required)</small></label>
          </div>
        </div>

        {this.renderMatches()}

        {
          this.state.manualSubmit ? (
            <div className="form-horizontal">
              <div className="form-group">
                <label className="col-sm-4 control-label">Can't find it?</label>
                <div className="col-sm-7">
                  <button className="form-control btn btn-primary"> Add it manually </button>
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
