$ = jQuery

$.fn.showWhenClicked = ->
  this.each (index, clickable) ->
    clickable = $(clickable)
    toggler = $(clickable.data('show-when-clicked'))

    clickable.on 'click', ->
      toggler.toggle()

$(document).ready ->

  if $('#content_feed_widget_link_version_link_internal').prop('checked')
    $('#internal-link').show()
  else if $('#content_feed_widget_link_version_link_external').prop('checked')
    $('#external-link').show()

  $('.link-versions').on 'click', ->
    if $('#content_feed_widget_link_version_link_internal').prop('checked')
      $('#internal-link').show()
    else
      $('#internal-link').hide()
    if $('#content_feed_widget_link_version_link_external').prop('checked')
      $('#external-link').show()
    else
      $('#external-link').hide()

    return
  return
