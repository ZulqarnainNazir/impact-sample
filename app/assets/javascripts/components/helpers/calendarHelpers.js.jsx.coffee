calendarHelpers = {
  editCalendarSettings: (groupId, block) ->
    $('#calendar_settings_group_uuid').val groupId
    $('#calendar_settings_block_uuid').val block.uuid

    if block.settings && block.settings.widget_id
      $('#calendar_embed_id').val(block.settings.widget_id)

    $('#calendar_settings_modal .btn.btn-primary').trigger('click')
    $('#calendar_settings_modal').modal('show')

  updateCalendarSettings: (component) ->
    component.updateBlock $('#calendar_settings_group_uuid').val(), $('#calendar_settings_block_uuid').val(),
      widget_id: $('#calendar_embed_id').val()
}

window.calendarHelpers = calendarHelpers
