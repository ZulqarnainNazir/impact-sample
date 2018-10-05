# // import React, { PropTypes } from 'react';

LinkModal = React.createClass
  render: ->
    `<div id="link_modal" className="modal fade">
      <input id="link_group_uuid" type="hidden" />
      <input id="link_block_uuid" type="hidden" />
      <div className="modal-dialog">
        <div className="modal-content">

          <div className="modal-header">
            <span className="close" data-dismiss="modal">&times;</span>
            <p className="h4 modal-title">Add a Link</p>
          </div>

          <div className="modal-body">
            <div className="radio">
              <label>
                <input
                  id="link_version_none"
                  type="radio"
                  name="link_version"
                  value="link_none"
                  defaultChecked="true"
                />
                Don‘t include a linked button
              </label>
            </div>
            <div className="radio">
              <label>
                <input
                  id="link_version_internal"
                  type="radio"
                  name="link_version"
                  value="link_internal"
                />
                Link to an internal webpage on your site
              </label>
            </div>
            <div className="radio">
              <label>
                <input
                  id="link_version_external"
                  type="radio"
                  name="link_version"
                  value="link_external"
                />
                Link to an external webpage
              </label>
            </div>
            <div id="link_inputs_internal">
              <hr />
              <div className="form-group">
                <label htmlFor="link_id" className="control-label">Locable's Marketing Suite Webpage</label>
                <EditLinkOptions internalWebpages={this.props.internalWebpages} />
              </div>
            </div>
            <div id="link_inputs_external">
              <hr />
              <div className="form-group">
                <label htmlFor="link_external_url" className="control-label">External URL</label>
                <input id="link_external_url" type="text" className="form-control" />
              </div>
            </div>
            <div id="link_inputs_default">
              <div className="form-group">
                <label htmlFor="link_label" className="control-label">Button Label</label>
                <input id="link_label" type="text" className="form-control" />
              </div>
              <div className="checkbox">
                <label>
                  <input id="link_target_blank" type="checkbox" value="1" />
                  Open link in a new window?
                </label>
              </div>
              <div className="checkbox">
                <label>
                  <input id="link_no_follow" type="checkbox" value="1" />
                  Add "no-follow" to the link?
                </label>
              </div>
            </div>
          </div>

          <div className="modal-footer">
            <span className="btn btn-link m-r-xl" data-dismiss="modal" onClick={this.props.resetLink}>Cancel</span>
            <span className="btn btn-primary col-xs-6" data-dismiss="modal" onClick={this.props.updateLink}>Save</span>
          </div>
        </div>
      </div>
    </div>`


LinkModal.propTypes = {
  resetLink: React.PropTypes.func.isRequired,
  updateLink: React.PropTypes.func.isRequired,
}

# // export default LinkModal;
window.LinkModal = LinkModal
