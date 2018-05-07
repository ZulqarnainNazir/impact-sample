defaultSettingsHelpers = {
  editDefaultSettings: (group_uuid, block, isCallToAction) ->
    console.log(group_uuid)
    console.log(block)
    console.log(isCallToAction)
    minicolorOptions =
      control: 'wheel'
      theme: 'block'
    $('#default_settings_background_color').prop('value', block.background_color)
    $('#default_settings_foreground_color').prop('value', block.foreground_color)
    $('#default_settings_background_color').minicolors minicolorOptions
    $('#default_settings_foreground_color').minicolors minicolorOptions
    $('#default_settings_group_uuid').val group_uuid
    $('#default_settings_block_uuid').val block.uuid
    $('#default_settings_custom_class').val block.custom_class
    $('#default_settings_custom_anchor_id').val block.custom_anchor_id
    $('#default_settings_well_style').val if ['transparent', 'dark', 'light'].indexOf(block.well_style) > 0 then block.well_style else 'transparent'
    $('#default_settings_background_group').addClass('hide') unless isCallToAction
    $('#default_settings_modal').modal('show')

  updateDefaultSettings: (component) ->
    component.updateBlock $('#default_settings_group_uuid').val(), $('#default_settings_block_uuid').val(),
      background_color: $('#default_settings_background_color').val()
      foreground_color: $('#default_settings_foreground_color').val()
      custom_class: $('#default_settings_custom_class').val()
      well_style: $('#default_settings_well_style').val()
      custom_anchor_id: $('#default_settings_custom_anchor_id').val()

  resetDefaultSettings: ->
    $('#default_settings_background_color').val('').minicolors('destroy')
    $('#default_settings_foreground_color').val('').minicolors('destroy')
    $('#default_settings_custom_class').val ''
    $('#default_settings_well_style').val 'transparent'
}

window.defaultSettingsHelpers = defaultSettingsHelpers
