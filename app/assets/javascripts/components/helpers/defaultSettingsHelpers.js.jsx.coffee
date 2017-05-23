defaultSettingsHelpers = {
  editDefaultSettings: (group_uuid, block) ->
    $('#default_settings_group_uuid').val group_uuid
    $('#default_settings_block_uuid').val block.uuid
    $('#default_settings_custom_class').val block.custom_class
    $('#default_settings_custom_anchor_id').val block.custom_anchor_id
    $('#default_settings_modal').modal('show')

  updateDefaultSettings: (component) ->
    component.updateBlock $('#default_settings_group_uuid').val(), $('#default_settings_block_uuid').val(),
      custom_class: $('#default_settings_custom_class').val()
      custom_anchor_id: $('#default_settings_custom_anchor_id').val()

  resetDefaultSettings: ->
    $('#default_settings_custom_class').val ''
}

window.defaultSettingsHelpers = defaultSettingsHelpers
