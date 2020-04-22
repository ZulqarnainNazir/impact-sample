mercantileHelpers = {
  editMercantileSettings: (groupId, block) ->
    $('#mercantile_settings_group_uuid').val groupId
    $('#mercantile_settings_block_uuid').val block.uuid

    if block.settings && block.settings.widget_id
      $('#mercantile_embed_id').val(block.settings.widget_id)

    $('#mercantile_settings_modal .btn.btn-primary').trigger('click')
    $('#mercantile_settings_modal').modal('show')

  updateMercantileSettings: (component) ->
    component.updateBlock $('#mercantile_settings_group_uuid').val(), $('#mercantile_settings_block_uuid').val(),
      widget_id: $('#mercantile_embed_id').val()
}

window.mercantileHelpers = mercantileHelpers
