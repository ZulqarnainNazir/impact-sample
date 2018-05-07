groupHelpers = {
  editCustomGroup: (group, event) ->
    event.preventDefault()
    minicolorOptions =
      control: 'wheel'
      theme: 'block'
    $('#custom_group_background_color').prop('value', group.background_color)
    $('#custom_group_foreground_color').prop('value', group.foreground_color)
    $('#custom_group_background_color').minicolors minicolorOptions
    $('#custom_group_foreground_color').minicolors minicolorOptions
    $('#custom_group_uuid').val group.uuid
    $('#custom_group_uuid').change()
    $('#custom_group_custom_class').val group.custom_class
    if group.type is 'HeroGroup'
      $('#custom_group_height_fields').show()
      $('#custom_group_height').val if parseInt(group.height) > 0 then parseInt(group.height) else ''

      $('#hero_position_fields').show()
      $('#hero_position').val if ['below', 'behind'].indexOf(group.hero_position) > 0 then group.hero_position else 'below'
    else
      $('#custom_group_height_fields').hide()
      $('#custom_group_height').val('')
      $('#hero_position_fields').hide()
    $('#custom_group_modal').modal('show')

  updateCustomGroup: (component) ->
    group = component.state.groups[$('#custom_group_uuid').val()]
    if group.type is 'HeroGroup'
      changes = switch $('#custom_group_height_option').val()
        when 'fitContent'
          background_color: $('#custom_group_background_color').val()
          foreground_color: $('#custom_group_foreground_color').val()
          custom_class: $('#custom_group_custom_class').val()
          height: ''
          hero_position: $('#hero_position').val()
          aspect_ratio:
            height: ''
            width: ''
        when 'fixedHeight'
          background_color: $('#custom_group_background_color').val()
          foreground_color: $('#custom_group_foreground_color').val()
          custom_class: $('#custom_group_custom_class').val()
          height: $('#custom_group_height').val()
          hero_position: $('#hero_position').val()
          aspect_ratio:
            height: ''
            width: ''
        when 'maintainAspectRatio'
          background_color: $('#custom_group_background_color').val()
          foreground_color: $('#custom_group_foreground_color').val()
          custom_class: $('#custom_group_custom_class').val()
          height: ''
          hero_position: $('#hero_position').val()
          aspect_ratio:
            height: $('#custom_group_aspect_ratio_height').val()
            width: $('#custom_group_aspect_ratio_width').val()
      component.updateGroup $('#custom_group_uuid').val(), changes
    else
      component.updateGroup $('#custom_group_uuid').val(),
        background_color: $('#custom_group_background_color').val()
        foreground_color: $('#custom_group_foreground_color').val()
        custom_class: $('#custom_group_custom_class').val()
        height: undefined

  resetCustomGroup: ->
    $('#custom_group_uuid').val ''
    $('#custom_group_custom_class').val ''
    $('#custom_group_height').val ''
    $('#custom_group_aspect_ratio').val ''
    $('#custom_group_aspect_ratio_height').val ''
    $('#custom_group_aspect_ratio_width').val ''
    $('#hero_position').val 'below'
    $('#custom_group_background_color').val('').minicolors('destroy')
    $('#custom_group_foreground_color').val('').minicolors('destroy')
}

window.groupHelpers = groupHelpers
