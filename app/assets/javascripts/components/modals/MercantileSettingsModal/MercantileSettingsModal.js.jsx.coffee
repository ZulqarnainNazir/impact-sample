MercantileSettingsModal = React.createClass
  renderOptions: ->
    if !this.props.mercantileEmbeds
      return

    return this.props.mercantileEmbeds.map (item) ->
      return `<option key={item.id} value={item.id}>{item.name}</option>`

  render: ->
    `<div id="mercantile_settings_modal" className="modal fade">
      <input id="mercantile_settings_group_uuid" type="hidden" />
      <input id="mercantile_settings_block_uuid" type="hidden" />
      <div className="modal-dialog">
        <div className="modal-content">
          <div className="modal-header">
            <span className="close" data-dismiss="modal">&times;</span>
            <p className="h4 modal-title">Select Mercantile Embed or Add New</p>
          </div>
          <div className="modal-body">
            <div className="form-group">
              <label htmlFor="mercantile_embed_id" className="control-label">Embed</label>
              <div>
                <select id="mercantile_embed_id" className="form-control" defaultValue="default">
                  {this.renderOptions()}
                </select>
              </div>

              <div className="m-t-1">
                <a href={this.props.newMercantilePath} target="_blank">
                  <i className="fa fa-plus-circle m-r-half"></i>
                  Add New
                </a>
              </div>
            </div>
            <hr />
          </div>
          <div className="modal-footer">
            <span className="btn btn-default" data-dismiss="modal">Cancel</span>
            <span className="btn btn-primary" data-dismiss="modal" onClick={this.props.updateMercantileSettings}>Save</span>
          </div>
        </div>
      </div>
    </div>;`


window.MercantileSettingsModal = MercantileSettingsModal
