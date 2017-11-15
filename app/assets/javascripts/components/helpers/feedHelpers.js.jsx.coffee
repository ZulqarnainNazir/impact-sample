feedHelpers = {
  editFeedSettings: (groupId, block) ->
    $('#feed_settings_group_uuid').val groupId
    $('#feed_settings_block_uuid').val block.uuid
    $('#feed_settings_items_limit').val if parseInt(block.items_limit) > 0 then parseInt(block.items_limit) else 4
    $('.feed_settings_content_type').prop 'checked', false
    $('#feed_settings_content_type_quick_post').prop 'checked', (block.content_types || '').indexOf('QuickPost') >= 0
    $('#feed_settings_content_type_event').prop 'checked', (block.content_types || '').indexOf('Event') >= 0
    $('#feed_settings_content_type_gallery').prop 'checked', (block.content_types || '').indexOf('Gallery') >= 0
    $('#feed_settings_content_type_before_after').prop 'checked', (block.content_types || '').indexOf('BeforeAfter') >= 0
    $('#feed_settings_content_type_offer').prop 'checked', (block.content_types || '').indexOf('Offer') >= 0
    $('#feed_settings_content_type_post').prop 'checked', (block.content_types || '').indexOf('CustomPost') >= 0
    $('#feed_settings_content_type_job').prop 'checked', (block.content_types || '').indexOf('Job') >= 0
    $('.feed_settings_content_type').prop('checked', true) if $('.feed_settings_content_type:checked').length == 0
    $('#feed_settings_content_category_ids').val (block.content_category_ids || '').split(' ')
    $('#feed_settings_company_list_ids').val (block.company_list_ids || '').split(' ')

    $('#feed_settings_show_our_content').prop 'checked', if block && block.show_our_content == false then false else true
    $('.i-checks').iCheck({checkboxClass: 'icheckbox_square-green', radioClass: 'iradio_square-green'});

    $('#feed_settings_content_tag_ids').val (block.content_tag_ids || '').split(' ')
    $('#feed_settings_custom_class').val block.custom_class
    $('#feed_settings_link_id').val block.link_id
    $('#feed_settings_link_external_url').val if block.link_external_url and block.link_external_url.length > 0 then block.link_external_url else 'http://'
    $('#feed_settings_link_label').val if block.link_label and block.link_label.length > 0 then block.link_label else 'View More'
    $('#feed_settings_link_no_follow').prop 'checked', if block.link_no_follow then true else false
    $('#feed_settings_link_target_blank').prop 'checked', if block.link_target_blank then true else false
    $('#feed_settings_link_version_none').prop 'checked', if ['link_paginate', 'link_internal', 'link_external'].indexOf(block.link_version) >= 0 then false else true
    $('#feed_settings_link_version_paginate').prop 'checked', block.link_version is 'link_paginate'
    $('#feed_settings_link_version_internal').prop 'checked', block.link_version is 'link_internal'
    $('#feed_settings_link_version_external').prop 'checked', block.link_version is 'link_external'
    if block.settings && block.settings.include_search == 'true' && block.include_search == undefined
      block.include_search = true
    $('#feed_settings_include_search').prop 'checked', if block.include_search then true else false
    $('#feed_settings_custom_anchor_id').val block.custom_anchor_id
    feedHelpers.toggleFeedLinkOptions()
    $('#feed_settings_modal').modal('show')

    categorySelect = $('#feed_settings_content_category_ids')
    tagSelect = $('#feed_settings_content_tag_ids')
    listSelect = $('#feed_settings_company_list_ids')

    checkListSelect = ->
      if listSelect.val() and listSelect.val().length > 0
        categorySelect.prop('disabled', true)
        tagSelect.prop('disabled', true)
      else
        categorySelect.prop('disabled', false)
        tagSelect.prop('disabled', false)

    listSelect.change ->
      checkListSelect()

    checkListSelect()


  updateFeedSettings: (component) ->
    component.updateBlock $('#feed_settings_group_uuid').val(), $('#feed_settings_block_uuid').val(),
      content_types: _.map($('.feed_settings_content_type:checked'), (input) -> return $(input).data().type).join(' ')
      content_category_ids: ($('#feed_settings_content_category_ids').val() || []).join(' ')
      show_our_content: $('#feed_settings_show_our_content').prop('checked')
      company_list_ids: ($('#feed_settings_company_list_ids').val() || []).join(' ')
      content_tag_ids: ($('#feed_settings_content_tag_ids').val() || []).join(' ')
      custom_class: $('#feed_settings_custom_class').val()
      items_limit: $('#feed_settings_items_limit').val()
      link_external_url: $('#feed_settings_link_external_url').val()
      link_id: $('#feed_settings_link_id').val()
      link_label: $('#feed_settings_link_label').val()
      link_no_follow: $('#feed_settings_link_no_follow').prop('checked')
      link_target_blank: $('#feed_settings_link_target_blank').prop('checked')
      link_version: $('input[name="link_version"]:checked').val()
      include_search: $('#feed_settings_include_search').prop('checked')
      custom_anchor_id: $('#feed_settings_custom_anchor_id').val()
    this.resetFeedSettings()

  resetFeedSettings: ->
    $('.feed_settings_content_type').prop 'checked', false
    $('#feed_settings_content_category_ids').val null
    $('#feed_settings_company_list_ids').val null
    $('#feed_settings_show_our_content').prop 'checked', false
    $('#feed_settings_content_tag_ids').val null
    $('#feed_settings_custom_class').val ''
    $('#feed_settings_items_limit').val 3
    $('#feed_settings_link_id').val ''
    $('#feed_settings_link_external_url').val 'http://'
    $('#feed_settings_link_label').val 'View More'
    $('#feed_settings_link_no_follow').prop 'checked', false
    $('#feed_settings_link_target_blank').prop 'checked', false
    $('#feed_settings_link_version_none').prop 'checked', true
    $('#feed_settings_include_search').prop 'checked', false
    this.toggleFeedLinkOptions()

  toggleFeedLinkOptions: ->
    if $('#feed_settings_link_version_internal').prop('checked')
      $('#feed_settings_link_inputs_default').show()
      $('#feed_settings_link_inputs_internal').show()
      $('#feed_settings_link_inputs_external').hide()
    else if $('#feed_settings_link_version_external').prop('checked')
      $('#feed_settings_link_inputs_default').show()
      $('#feed_settings_link_inputs_internal').hide()
      $('#feed_settings_link_inputs_external').show()
    else
      $('#feed_settings_link_inputs_default').hide()
      $('#feed_settings_link_inputs_internal').hide()
      $('#feed_settings_link_inputs_external').hide()
}

window.feedHelpers = feedHelpers
