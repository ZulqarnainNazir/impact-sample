$ = jQuery

$.fn.showWhenClicked = ->
  this.each (index, clickable) ->
    clickable = $(clickable)
    toggler = $(clickable.data('show-when-clicked'))

    clickable.on 'click', ->
      toggler.toggle()

$(document).ready ->

  if $('#content_feed_widget_link_version_link_internal').prop('checked')
    $('#internal-link, #link-options, #view-more-button').show()
  else if $('#content_feed_widget_link_version_link_external').prop('checked')
    $('#external-link, #link-options, #view-more-button').show()

  $('.link-versions').on 'click', ->
    if $('#content_feed_widget_link_version_link_none').prop('checked') or $('#content_feed_widget_link_version_link_paginate').prop('checked')
      $('#internal-link, #external-link, #link-options, #view-more-button').hide()

    if $('#content_feed_widget_link_version_link_internal').prop('checked')
      $('#internal-link, #link-options, #view-more-button').show()
      $('#external-link').hide()

    if $('#content_feed_widget_link_version_link_external').prop('checked')
      $('#external-link, #link-options, #view-more-button').show()
      $('#internal-link').hide()


    return
  return
