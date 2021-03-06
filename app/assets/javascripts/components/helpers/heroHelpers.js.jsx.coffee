
heroHelpers = {
  editHeroSettings: (groupId, block) ->
    minicolorOptions =
      control: 'wheel'
      theme: 'block'
    $('#hero_settings_background_color').prop('value', block.background_color)
    $('#hero_settings_foreground_color').prop('value', block.foreground_color)
    $('#hero_settings_background_color').minicolors minicolorOptions
    $('#hero_settings_foreground_color').minicolors minicolorOptions
    $('#hero_settings_group_uuid').val groupId
    $('#hero_settings_block_uuid').val block.uuid
    $('#hero_settings_custom_class').val block.custom_class
    $('#hero_settings_custom_anchor_id').val block.custom_anchor_id
    $('#hero_settings_well_style').val if ['transparent', 'dark', 'light'].indexOf(block.well_style) > 0 then block.well_style else 'transparent'
    $('#hero_settings_modal').modal('show')

  updateHeroSettings: (component) ->
    component.updateBlock $('#hero_settings_group_uuid').val(), $('#hero_settings_block_uuid').val(),
      custom_class: $('#hero_settings_custom_class').val()
      background_color: $('#hero_settings_background_color').val()
      foreground_color: $('#hero_settings_foreground_color').val()
      well_style: $('#hero_settings_well_style').val()
      custom_anchor_id: $('#hero_settings_custom_anchor_id').val()

  resetHeroSettings: ->
    $('#hero_settings_background_color').val('').minicolors('destroy')
    $('#hero_settings_foreground_color').val('').minicolors('destroy')
    $('#hero_settings_custom_class').val ''
    $('#hero_settings_well_style').val 'transparent'

  expandHero: (component, event) ->
    event.preventDefault()
    $(event.target).popover('hide')
    # sortHelpers.disableSortable()
    component.updateGroup kind: 'full_width', sortHelpers.enableSortables.bind(null, component)

  compressHero: (component, event) ->
    event.preventDefault()
    $(event.target).popover('hide')
    # sortHelpers.disableSortable()
    component.updateGroup kind: 'container', sortHelpers.enableSortables.bind(null, component)
}

window.heroHelpers = heroHelpers
