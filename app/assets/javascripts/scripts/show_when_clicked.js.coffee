$ = jQuery

$.fn.showWhenClicked = ->
  this.each (index, clickable) ->
    clickable = $(clickable)
    toggler = $(clickable.data('show-when-clicked'))

    clickable.on 'click', ->
      toggler.toggle(200)
