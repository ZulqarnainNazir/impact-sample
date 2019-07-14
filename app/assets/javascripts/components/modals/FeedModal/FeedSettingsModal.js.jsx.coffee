FeedSettingsModal = React.createClass
  resetFeedSettings: ->
    feedHelpers.resetFeedSettings()

  renderFeedSettingsCategories: ->
    for category in this.props.contentCategories
      `<option value={category.id}>{category.name}</option>`

  renderFeedSettingsCompanyLists: ->
    for list in this.props.companyLists
      `<option value={list.id}>{list.name}</option>`

  renderFeedSettingsTags: ->
    for tag in this.props.contentTags
      `<option value={tag.id}>{tag.name}</option>`

  render: ->
    # Not sure why but modal-open is being removed before render
    $('body').addClass('modal-open')

    `<div id="feed_settings_modal" className="modal fade">
      <input id="feed_settings_group_uuid" type="hidden" />
      <input id="feed_settings_block_uuid" type="hidden" />
      <div className="modal-dialog">
        <div className="modal-content">
          <div className="modal-header">
            <span className="close" data-dismiss="modal">&times;</span>
            <p className="h4 modal-title">Change Feed Settings</p>
          </div>
          <div className="modal-body">
            <div className="form-group">
              <label htmlFor="feed_settings_items_limit" className="control-label">
                Maximum Number of Feed Items to Display
              </label>
              <input type="number" id="feed_settings_items_limit" className="form-control" step="1" />
            </div>
            <div className="radio">
              <label>
                <input id="feed_settings_link_version_none" type="radio" name="link_version" value="link_none" defaultChecked="true" />
                Don‘t include a linked button
              </label>
            </div>
            <div className="radio">
              <label>
                <input id="feed_settings_link_version_paginate" type="radio" name="link_version" value="link_paginate" defaultChecked="true" />
                Paginate the current page
              </label>
            </div>
            <div className="radio">
              <label>
                <input id="feed_settings_link_version_internal" type="radio" name="link_version" value="link_internal" />
                Link to an internal webpage on your site
              </label>
            </div>
            <div className="radio">
              <label>
                <input id="feed_settings_link_version_external" type="radio" name="link_version" value="link_external" />
                Link to an external webpage
              </label>
            </div>
            <div id="feed_settings_link_inputs_internal">
              <div className="form-group">
                <label htmlFor="feed_settings_link_id" className="control-label">Locable's Marketing Suite Webpage</label>
                <EditLinkOptions
                  id={"feed_settings_link_id"} internalWebpages={this.props.internalWebpages}/>
              </div>
            </div>
            <div id="feed_settings_link_inputs_external">
              <div className="form-group">
                <label htmlFor="feed_settings_link_external_url" className="control-label">External URL</label>
                <input id="feed_settings_link_external_url" type="text" className="form-control" />
              </div>
            </div>
            <div id="feed_settings_link_inputs_default">
              <div className="form-group">
                <label htmlFor="feed_settings_link_label" className="control-label">Button Label</label>
                <input id="feed_settings_link_label" type="text" className="form-control" />
              </div>
              <div className="checkbox">
                <label>
                  <input id="feed_settings_link_target_blank" type="checkbox" value="1" />
                  Open link in a new window?
                </label>
              </div>
              <div className="checkbox">
                <label>
                  <input id="feed_settings_link_no_follow" type="checkbox" value="1" />
                  Add "no-follow" to the link?
                </label>
              </div>
            </div>
            <div className="checkbox">
              <label>
                <input id="feed_settings_include_search" type="checkbox" name="include_search" />
                Include search bar?
              </label>
            </div>
            <p><strong>What Types of Content Do You Want to Include?</strong></p>
            <div className="row" style={{ marginBottom: 5 }}>
              <div className="col-xs-4">
                <div className="checkbox" style={{ margin: 0 }}>
                  <label><input className="feed_settings_content_type" id="feed_settings_content_type_quick_post" type="checkbox" data-type="QuickPost" defaultChecked="true" /> Quick Posts</label>
                </div>
              </div>
              <div className="col-xs-4">
                <div className="checkbox" style={{ margin: 0 }}>
                  <label><input className="feed_settings_content_type" id="feed_settings_content_type_event" type="checkbox" data-type="Event" defaultChecked="true" /> Events</label>
                </div>
              </div>


              <div className="col-xs-4">
                <div className="checkbox" style={{ margin: 0 }}>
                  <label><input className="feed_settings_content_type" id="feed_settings_content_type_gallery" type="checkbox" data-type="Gallery" defaultChecked="true" /> Galleries</label>
                </div>
              </div>
            </div>
            <div className="row" style={{ marginTop: 5 }}>
              <div className="col-xs-4">
                <div className="checkbox" style={{ margin: 0 }}>
                  <label><input className="feed_settings_content_type" id="feed_settings_content_type_before_after" type="checkbox" data-type="BeforeAfter" defaultChecked="true" /> Before &amp; Afters</label>
                </div>
              </div>
              <div className="col-xs-4">
                <div className="checkbox" style={{ margin: 0 }}>
                  <label><input className="feed_settings_content_type" id="feed_settings_content_type_offer" type="checkbox" data-type="Offer" defaultChecked="true" /> Offers</label>
                </div>
              </div>
              <div className="col-xs-4">
                <div className="checkbox" style={{ margin: 0 }}>
                  <label><input className="feed_settings_content_type" id="feed_settings_content_type_post" type="checkbox" data-type="CustomPost" defaultChecked="true" /> Custom Posts</label>
                </div>
              </div>
              <div className="col-xs-4">
                <div className="checkbox" style={{ margin: 0 }}>
                  <label><input className="feed_settings_content_type" id="feed_settings_content_type_job_paid" type="checkbox" data-type="PaidJob" defaultChecked="true" /> Paid Jobs</label>
                </div>
              </div>
              <div className="col-xs-4">
                <div className="checkbox" style={{ margin: 0 }}>
                  <label><input className="feed_settings_content_type" id="feed_settings_content_type_job_volunteer" type="checkbox" data-type="VolunteerJob" defaultChecked="true" /> Volunteer Jobs</label>
                </div>
              </div>
            </div>
            <hr />
            <div className="form-group">
              <label>Show content from:</label>
              <div className="form-group">
                <label htmlFor="feed_settings_show_our_content" className="i-checks">
                  <input className="feed_settings_show_our_content" id="feed_settings_show_our_content" type="checkbox" defaultChecked="true"/>
                  <i> Our Content</i>
                </label>
                <br/>
                - And / Or -
                <div className="form-group">
                  <label htmlFor="feed_settings_company_list_ids" className="control-label">
                    Companies in these lists
                  </label>
                  <select type="text" id="feed_settings_company_list_ids" className="form-control" multiple>
                    {this.renderFeedSettingsCompanyLists()}
                  </select>
                </div>
              </div>
            </div>
            <hr />
            <div className="form-group">
              <label htmlFor="feed_settings_content_category_ids" className="control-label">
                Only Include Content for Categories <small>Leave blank to include all</small>
              </label>
              <select type="text" id="feed_settings_content_category_ids" className="form-control" multiple>
                {this.renderFeedSettingsCategories()}
              </select>
            </div>
            <div className="form-group">
              <label htmlFor="feed_settings_content_tag_ids" className="control-label">
                Only Include Content for Tags <small>Leave blank to include all</small>
              </label>
              <select type="text" id="feed_settings_content_tag_ids" className="form-control" multiple>
                {this.renderFeedSettingsTags()}
              </select>
            </div>
            <hr />
            <div className="form-group">
              <label htmlFor="feed_settings_custom_class" className="control-label">
                Set a Custom Class (Advanced)
              </label>
              <input type="text" id="feed_settings_custom_class" className="form-control" />
            </div>
            <div className="form-group">
              <label htmlFor="feed_settings_custom_anchor_id" className="control-label">
                Set an ID for a Custom Anchor link (Advanced)
              </label>
              <input type="text" id="feed_settings_custom_anchor_id" className="form-control" />
            </div>
          </div>
          <div className="modal-footer">
            <span className="btn btn-link m-r-xl" data-dismiss="modal" onClick={this.resetFeedSettings}>Cancel</span>
            <span className="btn btn-primary col-xs-6" data-dismiss="modal" onClick={this.props.updateFeedSettings}>Save</span>
          </div>
        </div>
      </div>
    </div>;`

window.FeedSettingsModal = FeedSettingsModal
