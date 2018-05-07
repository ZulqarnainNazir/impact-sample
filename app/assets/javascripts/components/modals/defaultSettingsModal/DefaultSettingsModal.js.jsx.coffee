# // import React, { PropTypes } from 'react';

DefaultSettingsModal = React.createClass
  render: ->
    `<div id="default_settings_modal" className="modal fade">
      <input id="default_settings_group_uuid" type="hidden" />
      <input id="default_settings_block_uuid" type="hidden" />
      <div className="modal-dialog">
        <div className="modal-content">
          <div className="modal-header">
            <span className="close" data-dismiss="modal">&times;</span>
            <p className="h4 modal-title">Change Default Settings</p>
          </div>
          <div className="modal-body">
            <div className="form-group">
              <label htmlFor="default_settings_well_style" className="control-label">Background Shade</label>
              <div>
                <select ref="selectpicker" id="default_settings_well_style" className="form-control" defaultValue="transparent">
                  <option key="transparent" value="transparent">Transparent</option>
                  <option key="light" value="light">Light</option>
                  <option key="dark" value="dark">Dark</option>
                </select>
              </div>
            </div>
            <input id="default_settings_fake_to_receive_focus" type="text" className="hide" />
            <div className="form-group" id="default_settings_background_group">
              <label htmlFor="default_settings_background_color" className="control-label">Custom Background Color</label>
              <input id="default_settings_background_color" type="text" className="form-control" />
            </div>
            <div className="form-group">
              <label htmlFor="default_settings_foreground_color" className="control-label">Custom Font Color</label>
              <input id="default_settings_foreground_color" type="text" className="form-control" />
            </div>
            <div className="form-group">
              <label htmlFor="default_settings_custom_class" className="control-label">
                Set a Custom Class (Advanced)
              </label>
              <input type="text" id="default_settings_custom_class" className="form-control" />
            </div>
            <div className="form-group">
              <label htmlFor="default_settings_custom_anchor_id" className="control-label">
                Set an ID for a Custom Anchor link (Advanced)
              </label>
              <input type="text" id="default_settings_custom_anchor_id" className="form-control" />
            </div>
          </div>
          <div className="modal-footer">
            <span
              className="btn btn-default" data-dismiss="modal" onClick={() => $('#default_settings_custom_class').val('')}
            >Cancel</span>
            <span
              className="btn btn-primary" data-dismiss="modal" onClick={this.props.updateDefaultSettings}
            >Save</span>
          </div>
        </div>
      </div>
    </div>`

DefaultSettingsModal.propTypes = {
  updateDefaultSettings: React.PropTypes.func.isRequired,
}
# // export default DefaultSettingsModal;
window.DefaultSettingsModal = DefaultSettingsModal
