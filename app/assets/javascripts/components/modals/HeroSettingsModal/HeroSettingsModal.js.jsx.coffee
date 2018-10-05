HeroSettingsModal = React.createClass
  propTypes:
    updateHeroSettings: React.PropTypes.func.isRequired

  render: ->
    `<div id="hero_settings_modal" className="modal fade">
      <input id="hero_settings_group_uuid" type="hidden" />
      <input id="hero_settings_block_uuid" type="hidden" />
      <div className="modal-dialog">
        <div className="modal-content">
          <div className="modal-header">
            <span className="close" data-dismiss="modal">&times;</span>
            <p className="h4 modal-title">Change Slide Layout and Settings</p>
          </div>
          <div className="modal-body">
            <div className="form-group">
              <label htmlFor="hero_settings_well_style" className="control-label">Background Shade</label>
              <div>
                <select ref="selectpicker" id="hero_settings_well_style" className="form-control" defaultValue="transparent">
                  <option key="transparent" value="transparent">Transparent</option>
                  <option key="light" value="light">Light</option>
                  <option key="dark" value="dark">Dark</option>
                </select>
              </div>
            </div>
            <input id="hero_settings_fake_to_receive_focus" type="text" className="hide" />
            <div className="form-group">
              <label htmlFor="hero_settings_background_color" className="control-label">Custom Background Color</label>
              <input id="hero_settings_background_color" type="text" className="form-control" />
            </div>
            <div className="form-group">
              <label htmlFor="hero_settings_foreground_color" className="control-label">Custom Font Color</label>
              <input id="hero_settings_foreground_color" type="text" className="form-control" />
            </div>
            <hr />
            <p className="text-muted small">ADVANCED</p>
            <div className="form-group">
              <label htmlFor="hero_settings_custom_class" className="control-label">
                Set a Custom Class
              </label>
              <input type="text" id="hero_settings_custom_class" className="form-control" />
            </div>
            <div className="form-group">
              <label htmlFor="hero_settings_custom_anchor_id" className="control-label">
                Set an ID for a Custom Anchor link (Advanced)
              </label>
              <input type="text" id="hero_settings_custom_anchor_id" className="form-control" />
            </div>
          </div>
          <div className="modal-footer">
            <span className="btn btn-link m-r-xl" data-dismiss="modal" onClick={this.props.resetHeroSettings}>Cancel</span>
            <span className="btn btn-primary col-xs-6" data-dismiss="modal" onClick={this.props.updateHeroSettings}>Save</span>
          </div>
        </div>
      </div>
    </div>`

window.HeroSettingsModal = HeroSettingsModal
