// import React from 'react';
// import ImagePlacement from '../../components/ImagePlacement'
// import { hashHistory } from 'react-router';

class DetailInfo extends React.Component {

  constructor() {
    super();
    this.completeStep = this.completeStep.bind(this);
  }

  completeStep(event) {
    event.preventDefault();
    let prefix = store.get('imageSetup').inputPrefix
    let elements = event.target.elements
    let imageAttr = {
      id:       elements[prefix + '[id]'].value,
      kind:     elements[prefix + '[kind]'].value,
      _destroy: elements[prefix + '[_destroy]'].value,
      image_id: elements[prefix + '[image_id]'].value
    }

    if ( elements[prefix + '[image_attachment_cache_url]'] ) {
      imageAttr['image_attachment_cache_url']    = elements[prefix + '[image_attachment_cache_url]'].value
      imageAttr['image_attachment_content_type'] = elements[prefix + '[image_attachment_content_type]'].value
      imageAttr['image_attachment_file_name']    = elements[prefix + '[image_attachment_file_name]'].value
      imageAttr['image_attachment_file_size']    = elements[prefix + '[image_attachment_file_size]'].value
    }

    console.log(imageAttr)

    store.set('completeRedirect', true);
    console.log('completeRedirect')
    console.log(this.description)
    console.log(store.get('completeRedirect'))
    const business = {
      logo_placement_attributes: imageAttr,
      membership_org: this.membershipOrg.checked,
      facebook_id: this.facebookId ? this.facebookId.value : null,
      twitter_id: this.twitterId ? this.twitterId.value : null,
      description: this.description ? this.description.value : ''
    };
    console.log(business)
    store.set('business', _.merge({}, store.get('business'), business));
    hashHistory.push("wizard/confirm");
  }

  render() {
    let imageSetup = store.get('imageSetup')
    let business = store.get('business')
    return (
      <div className="row">
        <div className="col-md-12">
          <h2>Successfully Created Your Account!</h2>
          {/* <p>Proceed to the next step to finish signing up.</p> */}
        </div>

        <form className="col-md-12 p-t-30px" onSubmit={this.completeStep}>

          <div style={{maxWidth: 350}}>
            <ImagePlacement
              imagesPath={`/businesses/${business.id}/images`}
              inputPrefix={imageSetup.inputPrefix}
              label={imageSetup.label}
              placement={{ image: {} }}
              presignedPost={imageSetup.presignedPost}
              bulkUploadPath={`/businesses/${business.id}/content/images_upload/new`}
              showLocalOnlyOption={imageSetup.showLocalOnlyOption}
            />
          </div>
          
          <div className="checkbox text-muted">
            <label>
              <input type="checkbox" ref={(input) => this.membershipOrg = input} defaultChecked={store.get('business').membership_org} />
              {" We're a membership organization (i.e. Chamber, Downtown or Mechants Association, etc)"}
            </label>
          </div>

          <div className="group">
            <label className="control-label">Description</label>
            <br style={{ lineHeight: 3 }}/>
            <textarea
              className="form-control"
              ref={(input) => this.description = input}
              placeholder={'Summarize your business and purpose in 3-6 sentences - this may be displayed publicly when other organizations promote you.'}
            />
            <span className="bar"></span>
            <span className="highlight"></span>
          </div>

          <div className="group">
            <label for="facebook_id" className="control-label">
              <i className="fa fa-facebook-square" />
              { " Facebook ID" }
            </label>
            <br style={{ lineHeight: 2 }}/>
            <input
              type='text'
              id='facebook_id'
              autoComplete='off'
              ref={(input) => this.facebookId = input}
              className='form-control js-facebook-input'
              placeholder={'Add page ID - everything after facebook.com/ i.e. locable'}
            />
          </div>

          <div className="group">
            <label for="twitter_id" className="control-label">
              <i className="fa fa-twitter-square" />
              { " Twitter ID" }
            </label>
            <br style={{ lineHeight: 2 }}/>
            <input
              type='text'
              id='twitter_id'
              autoComplete='off'
              ref={(input) => this.twitterId = input}
              className='form-control js-twitter-input'
              placeholder={'Add account ID - everything after twitter.com/ i.e. getlocable'}
            />
          </div>

          <div className="btn-group pull-right m-t-5px">
            <Link to="wizard/businfo" className="btn btn-default">Previous Step</Link>
            <button type="submit" className="btn btn-primary">Next Step</button>
          </div>
        </form>
      </div>
    );
  }
}

// export default DetailInfo;
