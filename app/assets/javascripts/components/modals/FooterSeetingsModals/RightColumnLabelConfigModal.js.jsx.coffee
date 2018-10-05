RightColumnLabelConfigModal = React.createClass
  render: ->
    `<div id="right_label_config_modal" className="modal fade">
      <input id="feed_settings_group_uuid" type="hidden" />
      <input id="feed_settings_block_uuid" type="hidden" />
      <div className="modal-dialog">
        <div className="modal-content">
          <div className="modal-header">
            <span className="close" data-dismiss="modal">&times;</span>
            <p className="h4 modal-title">Change Right Feed Label</p>
          </div>
          <div className="modal-body">
            <div id="link_inputs_internal">
              <div className="form-group">
                <label htmlFor="link_id" className="control-label">Locable's Marketing Suite Webpage</label>
                <EditLinkOptions includeBlank={true} defaultValue={this.props.footerBlock.right_label_internal_target} name="website[footer_block_attributes[right_label_internal_target]]" internalWebpages={this.props.internalWebpages} />
              </div>
            </div>
            <div id="link_inputs_default">
              <div className="form-group">
                <label htmlFor="label_text" className="control-label">Label Text</label>
                <input id="label_text" type="text" className="form-control" defaultValue={this.props.footerBlock.right_label_text} name="website[footer_block_attributes[right_label_text]]" />
              </div>
            </div>
          </div>
          <div className="modal-footer">
            <span className="btn btn-link m-r-xl" data-dismiss="modal" onClick={this.props.reset}>Cancel</span>
            <span className="btn btn-primary col-xs-6" data-dismiss="modal" onClick={this.props.update}>Save</span>
          </div>
        </div>
      </div>
    </div>;`

window.RightColumnLabelConfigModal = RightColumnLabelConfigModal
