feedHelpers = {
  updateFooterFeedColumnSettings: (component) ->
    console.log 'updateFooterFeedColumnSettings'

  resetFooterFeedColumnSettings: ->
    console.log 'resetFooterFeedColumnSettings'

  editFeedSettings: (groupId, block) ->
    $('#feed_settings_group_uuid').val groupId
    $('#feed_settings_block_uuid').val block.uuid

    $('#feed_settings_custom_class').val block.custom_class
    $('#feed_settings_custom_anchor_id').val block.custom_anchor_id
    $('#feed_settings_modal').modal('show')


  updateFeedSettings: (component) ->
    selected = $('#content_feed_embed_id').children('option:selected')

    component.updateBlock $('#feed_settings_group_uuid').val(), $('#feed_settings_block_uuid').val(),
      widget_id:            $('#content_feed_embed_id').val()
      custom_class:         $('#feed_settings_custom_class').val()
      custom_anchor_id:     $('#feed_settings_custom_anchor_id').val()
      items_limit:          selected.attr('data-items-limit')
      link_version:         selected.attr('data-link-version')
      link_id:              selected.attr('data-link-id')
      link_external_url:    selected.attr('data-link-external')
      link_label:           selected.attr('data-link-label')
      link_no_follow:       (selected.attr('data-link-no-follow') == 'true')
      include_search:       (selected.attr('data-enable-search') == 'true')
      link_target_blank:    (selected.attr('data-link-target') == 'true')
      show_our_content:     (selected.attr('data-our-content') == 'true')
      company_list_ids:     (selected.attr('data-company-list') || "")
      content_tag_ids:      (selected.attr('data-content-tag') || "")
      content_types:        (selected.attr('data-content-types') || "")
      content_category_ids: (selected.attr('data-content-category') || "")
}

window.feedHelpers = feedHelpers
