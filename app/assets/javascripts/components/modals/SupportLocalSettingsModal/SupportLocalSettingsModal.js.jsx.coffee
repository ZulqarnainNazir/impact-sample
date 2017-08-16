SupportLocalSettingsModal = React.createClass
  renderOptions: ->
    if !this.props.directoryWidgets
      return

    return this.props.directoryWidgets.map (item) ->
      return `<option key={item.id} value={item.id}>{item.name}</option>`

  render: ->
    `<div id="support_local_settings_modal" className="modal fade">
      <input id="support_local_settings_group_uuid" type="hidden" />
      <input id="support_local_settings_block_uuid" type="hidden" />
      <div className="modal-dialog">
        <div className="modal-content">
          <div className="modal-header">
            <span className="close" data-dismiss="modal">&times;</span>
            <p className="h4 modal-title">Select SupportLocal Embed or Add New</p>
          </div>
          <div className="modal-body">
            <div className="form-group">
              <label htmlFor="support_local_embed_id" className="control-label">Embed</label>
              <div>
                <select id="support_local_embed_id" className="form-control" defaultValue="default">
                  {this.renderOptions()}
                </select>
              </div>

              <div className="m-t-1">
                <a href={this.props.newSupportLocalPath} target="_blank">
                  <i className="fa fa-plus-circle m-r-half"></i>
                  Add New
                </a>
              </div>
            </div>
            <hr />
          </div>
          <div className="modal-footer">
            <span className="btn btn-default" data-dismiss="modal">Cancel</span>
            <span className="btn btn-primary" data-dismiss="modal" onClick={this.props.updateSupportLocalSettings}>Save</span>
          </div>
        </div>
      </div>
    </div>;`


window.SupportLocalSettingsModal = SupportLocalSettingsModal
