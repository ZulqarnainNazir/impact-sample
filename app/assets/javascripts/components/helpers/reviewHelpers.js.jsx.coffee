reviewHelpers = {
  editReviewsSettings: (groupId, block) ->
    $('#reviews_settings_group_uuid').val groupId
    $('#reviews_settings_block_uuid').val block.uuid
    $('#reviews_settings_style').val if ['default', 'columns'].indexOf(block.style) > 0 then block.style else 'default'
    $('#reviews_settings_modal').modal('show')

  updateReviewsSettings: (component) ->
    component.updateBlock $('#reviews_settings_group_uuid').val(), $('#reviews_settings_block_uuid').val(),
      style: $('#reviews_settings_style').val()

  resetReviewsSettings: ->
    $('#reviews_settings_style').val 'default'
}

window.reviewHelpers = reviewHelpers
