taglineHelpers = {
    editTaglineSettings: (group_uuid, block) ->
      # group = this.state.groups[group_uuid]
      # block = group.blocks[block_uuid]
      minicolorOptions =
        control: 'wheel'
        theme: 'block'
      $('#tagline_settings_background_color').prop('value', block.background_color)
      $('#tagline_settings_foreground_color').prop('value', block.foreground_color)
      $('#tagline_settings_background_color').minicolors minicolorOptions
      $('#tagline_settings_foreground_color').minicolors minicolorOptions
      $('#tagline_settings_group_uuid').val group_uuid
      $('#tagline_settings_block_uuid').val block.uuid
      $('#tagline_settings_custom_class').val block.custom_class
      $('#tagline_settings_well_style').val if ['transparent', 'dark', 'light'].indexOf(block.well_style) > 0 then block.well_style else 'transparent'
      $('#tagline_settings_modal').modal('show')

    updateTaglineSettings: (component) ->
      component.updateBlock $('#tagline_settings_group_uuid').val(), $('#tagline_settings_block_uuid').val(),
        background_color: $('#tagline_settings_background_color').val()
        foreground_color: $('#tagline_settings_foreground_color').val()
        custom_class: $('#tagline_settings_custom_class').val()
        well_style: $('#tagline_settings_well_style').val()

    resetTaglineSettings: ->
      $('#tagline_settings_background_color').val('').minicolors('destroy')
      $('#tagline_settings_foreground_color').val('').minicolors('destroy')
      $('#tagline_settings_custom_class').val ''
      $('#tagline_settings_well_style').val 'transparent'
}

window.taglineHelpers = taglineHelpers
