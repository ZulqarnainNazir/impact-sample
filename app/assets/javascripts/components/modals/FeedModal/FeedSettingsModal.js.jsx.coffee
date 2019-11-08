FeedSettingsModal = React.createClass
  renderOptions: ->
    if !this.props.contentFeedWidgets
      return

    return this.props.contentFeedWidgets.map (widget) ->
      return `<option key={widget.id} value={widget.id} data-items-limit={widget.items_limit}
                                                        data-link-version={widget.link_version}
                                                        data-link-id={widget.link_id}
                                                        data-link-external={widget.link_external_url}
                                                        data-link-target={widget.link_target_blank}
                                                        data-link-no-follow={widget.link_no_follow}
                                                        data-link-label={widget.link_label}
                                                        data-enable-search={widget.enable_search}
                                                        data-our-content={widget.show_our_content}
                                                        data-company-list={widget.company_list_ids.join(' ').trim()}
                                                        data-content-types={widget.content_types.join(' ').trim()}
                                                        data-content-category={widget.content_category_ids.join(' ').trim()}
                                                        data-content-tag={widget.content_tag_ids.join(' ').trim()} > {widget.name} </option>`

  render: ->
    # Not sure why but modal-open is being removed before render
    $('body').addClass('modal-open')

    `<div id="feed_settings_modal" className="modal fade">
      <input id="feed_settings_group_uuid" type="hidden" />
      <input id="feed_settings_block_uuid" type="hidden" />
      <div className="modal-dialog">
        <div className="modal-content">
          <div className="modal-header">
            <span className="close" data-dismiss="modal">&times;</span>
            <p className="h4 modal-title">Select Feed Embed or Add New</p>
          </div>
          <div className="modal-body">

            <div className="form-group">
              <label htmlFor="content_feed_embed_id" className="control-label">Embed</label>
              <div>
                <select id="content_feed_embed_id" className="form-control" defaultValue="default">
                  {this.renderOptions()}
                </select>
              </div>

              <div className="m-t-1">
                <a href={this.props.newContentFeedWidgetsPath} target="_blank">
                  <i className="fa fa-plus-circle m-r-half"></i>
                  Add New
                </a>
              </div>

              <div className="form-group m-t-1">
                <label htmlFor="feed_settings_custom_class" className="control-label">
                  Set a Custom Class (Advanced)
                </label>
                <input type="text" id="feed_settings_custom_class" className="form-control" />
              </div>

              <div className="form-group">
                <label htmlFor="feed_settings_custom_anchor_id" className="control-label">
                  Set an ID for a Custom Anchor link (Advanced)
                </label>
                <input type="text" id="feed_settings_custom_anchor_id" className="form-control" />
              </div>
            </div>
          </div>

          <div className="modal-footer">
            <span className="btn btn-link m-r-xl" data-dismiss="modal">Cancel</span>
            <span className="btn btn-primary col-xs-6" data-dismiss="modal" onClick={this.props.updateFeedSettings}>Save</span>
          </div>
        </div>
      </div>
    </div>`

window.FeedSettingsModal = FeedSettingsModal
