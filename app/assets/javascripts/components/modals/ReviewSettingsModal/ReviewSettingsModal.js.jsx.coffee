ReviewSettingsModal = React.createClass
  resetReviewsSettings: ->
    reviewHelpers.resetReviewsSettings()

  render: ->
    `<div id="reviews_settings_modal" className="modal fade">
      <input id="reviews_settings_group_uuid" type="hidden" />
      <input id="reviews_settings_block_uuid" type="hidden" />
      <div className="modal-dialog">
        <div className="modal-content">
          <div className="modal-header">
            <span className="close" data-dismiss="modal">&times;</span>
            <p className="h4 modal-title">Change Reviews Layout and Settings</p>
          </div>
          <div className="modal-body">
            <div className="form-group">
              <label htmlFor="reviews_settings_style" className="control-label">Background Shade</label>
              <div>
                <select ref="selectpicker" id="reviews_settings_style" className="form-control" defaultValue="default">
                  <option key="default" value="default">Default</option>
                  <option key="columns" value="columns">Columns</option>
                </select>
              </div>
            </div>
            <hr />
          </div>
          <div className="modal-footer">
            <span className="btn btn-default" data-dismiss="modal" onClick={this.resetReviewsSettings}>Cancel</span>
            <span className="btn btn-primary" data-dismiss="modal" onClick={this.props.updateReviewsSettings}>Save</span>
          </div>
        </div>
      </div>
    </div>;`


window.ReviewSettingsModal = ReviewSettingsModal
