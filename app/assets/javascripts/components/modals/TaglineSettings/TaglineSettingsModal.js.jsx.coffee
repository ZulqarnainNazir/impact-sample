TaglineSettingsModal = React.createClass
  resetTaglineSettings: ->
    taglineHelpers.resetTaglineSettings();
  render: ->
    `<div id="tagline_settings_modal" className="modal fade">
      <input id="tagline_settings_group_uuid" type="hidden" />
      <input id="tagline_settings_block_uuid" type="hidden" />
      <div className="modal-dialog">
        <div className="modal-content">
          <div className="modal-header">
            <span className="close" data-dismiss="modal">&times;</span>
            <p className="h4 modal-title">Change Tagline Layout and Settings</p>
          </div>
          <div className="modal-body">
            <div className="form-group">
              <label htmlFor="tagline_settings_well_style" className="control-label">Background Shade</label>
              <div>
                <select ref="selectpicker" id="tagline_settings_well_style" className="form-control" defaultValue="transparent">
                  <option key="transparent" value="transparent">Transparent</option>
                  <option key="light" value="light">Light</option>
                  <option key="dark" value="dark">Dark</option>
                </select>
              </div>
            </div>
            <hr />
            <div className="form-group">
              <label htmlFor="tagline_settings_custom_class" className="control-label">
                Set a Custom Class (Advanced)
              </label>
              <input type="text" id="tagline_settings_custom_class" className="form-control" />
            </div>
          </div>
          <div className="modal-footer">
            <span className="btn btn-default" data-dismiss="modal" onClick={this.resetTaglineSettings}>Cancel</span>
            <span className="btn btn-primary" data-dismiss="modal" onClick={this.props.updateTaglineSettings}>Save</span>
          </div>
        </div>
      </div>
    </div>;`

window.TaglineSettingsModal = TaglineSettingsModal
