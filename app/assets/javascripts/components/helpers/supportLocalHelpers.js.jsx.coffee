supportLocalHelpers = {
  editSupportLocalSettings: (groupId, block) ->
    $('#support_local_settings_group_uuid').val groupId
    $('#support_local_settings_block_uuid').val block.uuid

    if block.settings && block.settings.widget_id
      $('#support_local_embed_id').val(block.settings.widget_id)

    $('#support_local_settings_modal .btn.btn-primary').trigger('click')
    $('#support_local_settings_modal').modal('show')

  updateSupportLocalSettings: (component) ->
    component.updateBlock $('#support_local_settings_group_uuid').val(), $('#support_local_settings_block_uuid').val(),
      widget_id: $('#support_local_embed_id').val()
}

window.supportLocalHelpers = supportLocalHelpers
