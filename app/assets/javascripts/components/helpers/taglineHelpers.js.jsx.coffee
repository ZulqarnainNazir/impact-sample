taglineHelpers = {
    editTaglineSettings: (group_uuid, block) ->
      # group = this.state.groups[group_uuid]
      # block = group.blocks[block_uuid]
      $('#tagline_settings_group_uuid').val group_uuid
      $('#tagline_settings_block_uuid').val block.uuid
      $('#tagline_settings_custom_class').val block.custom_class
      $('#tagline_settings_well_style').val if ['light', 'dark', 'transparent'].indexOf(block.well_style) > 0 then block.well_style else 'light'
      $('#tagline_settings_modal').modal('show')

    updateTaglineSettings: (component) ->
      component.updateBlock $('#tagline_settings_group_uuid').val(), $('#tagline_settings_block_uuid').val(),
        custom_class: $('#tagline_settings_custom_class').val()
        well_style: $('#tagline_settings_well_style').val()

    resetTaglineSettings: ->
      $('#tagline_settings_custom_class').val ''
      $('#tagline_settings_well_style').val 'light'
}

window.taglineHelpers = taglineHelpers
