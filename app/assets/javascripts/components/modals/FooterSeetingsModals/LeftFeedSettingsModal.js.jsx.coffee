LeftFeedSettingsModal = React.createClass
  renderFeedSettingsCategories: ->
    for category in this.props.contentCategories
      `<option value={category.id}>{category.name}</option>`

  componentDidMount: ->
    $('#left_category_ids_val').val($('#left_feed_settings_content_category_ids').val())
    $('#left_feed_settings_content_category_ids').change (event) ->
      $('#left_category_ids_val').val($('#left_feed_settings_content_category_ids').val())

  render: ->
    `<div id="left_feed_settings_modal" className="modal fade">
      <input id="feed_settings_group_uuid" type="hidden" />
      <input id="feed_settings_block_uuid" type="hidden" />
      <div className="modal-dialog">
        <div className="modal-content">
          <div className="modal-header">
            <span className="close" data-dismiss="modal">&times;</span>
            <p className="h4 modal-title">Change Article Feed Settings</p>
            <p className="text-muted">This feed features Quick Posts, Posts, Gallaries, and Before & Afters</p>
          </div>
          <div className="modal-body">
            <div className="form-group">
              <label htmlFor="feed_settings_items_limit" className="control-label">
                Maximum Number of Feed Items to Display
              </label>
              <input type="number" defaultValue={this.props.footerBlock.left_number_of_feed_items || 3} name="website[footer_block_attributes[left_number_of_feed_items]]" id="feed_settings_items_limit" className="form-control" step="1" />
            </div>
            <div className="form-group">
              <label htmlFor="left_feed_settings_content_category_ids" className="control-label">
                Only Include Content for Categories <small>Leave blank to include all</small>
              </label>
              <select defaultValue={this.props.footerBlock.left_category_ids} type="text" id="left_feed_settings_content_category_ids" className="form-control" multiple>
                {this.renderFeedSettingsCategories()}
              </select>
              <input id="left_category_ids_val" name="website[footer_block_attributes[left_category_ids]]" type="hidden" />
            </div>
            <div className="form-group">
              <label htmlFor="feed_settings_custom_class" className="control-label">
                Set a Custom Class (Advanced)
              </label>
              <input type="text" defaultValue={this.props.footerBlock.left_custom_class} name="website[footer_block_attributes[left_custom_class]]" id="feed_settings_custom_class" className="form-control" />
            </div>
          </div>
          <div className="modal-footer">
            <span className="btn btn-link m-r-xl" data-dismiss="modal" onClick={this.props.reset}>Cancel</span>
            <span className="btn btn-primary col-xs-6" data-dismiss="modal" onClick={this.props.update}>Save</span>
          </div>
        </div>
      </div>
    </div>;`

window.LeftFeedSettingsModal = LeftFeedSettingsModal
