$ = jQuery

$.fn.toggleClassWhenClicked = ->
  clickable = this

  clickable.on 'click', ->
    clickable.toggleClass clickable.data('toggle-class-when-clicked')
