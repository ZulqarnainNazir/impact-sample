RightFeedSettingsModal = React.createClass
  renderFeedSettingsCategories: ->
    for category in this.props.contentCategories
      `<option value={category.id}>{category.name}</option>`

  componentDidMount: ->
    $('#right_category_ids_val').val($('#right_feed_settings_content_category_ids').val())
    $('#right_feed_settings_content_category_ids').change (event) ->
      $('#right_category_ids_val').val($('#right_feed_settings_content_category_ids').val())

  render: ->
    `<div id="right_feed_settings_modal" className="modal fade">
      <input id="feed_settings_group_uuid" type="hidden" />
      <input id="feed_settings_block_uuid" type="hidden" />
      <div className="modal-dialog">
        <div className="modal-content">
          <div className="modal-header">
            <span className="close" data-dismiss="modal">&times;</span>
            <p className="h4 modal-title">Change Event Feed Settings</p>
            <p className="text-muted">This feed features Events</p>
          </div>
          <div className="modal-body">
            <div className="form-group">
              <label htmlFor="feed_settings_items_limit" className="control-label">
                Maximum Number of Feed Items to Display
              </label>
              <input type="number" name="website[footer_block_attributes[right_number_of_feed_items]]" defaultValue={this.props.footerBlock.right_number_of_feed_items || 3} id="feed_settings_items_limit" className="form-control" step="1" />
            </div>
            <div className="form-group">
              <label htmlFor="right_feed_settings_content_category_ids" className="control-label">
                Only Include Content for Categories <small>Leave blank to include all</small>
              </label>
              <select defaultValue={this.props.footerBlock.right_category_ids} type="text" id="right_feed_settings_content_category_ids" className="form-control" multiple>
                {this.renderFeedSettingsCategories()}
              </select>
              <input id="right_category_ids_val" name="website[footer_block_attributes[right_category_ids]]" type="hidden" />
            </div>
            <div className="form-group">
              <label htmlFor="feed_settings_custom_class" className="control-label">
                Set a Custom Class (Advanced)
              </label>
              <input type="text" defaultValue={this.props.footerBlock.right_custom_class} name="website[footer_block_attributes[right_custom_class]]" id="feed_settings_custom_class" className="form-control" />
            </div>
          </div>
          <div className="modal-footer">
            <span className="btn btn-default" data-dismiss="modal" onClick={this.props.reset}>Cancel</span>
            <span className="btn btn-primary" data-dismiss="modal" onClick={this.props.update}>Save</span>
          </div>
        </div>
      </div>
    </div>;`

window.RightFeedSettingsModal = RightFeedSettingsModal
