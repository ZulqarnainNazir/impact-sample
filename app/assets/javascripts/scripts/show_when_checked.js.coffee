$ = jQuery

$.fn.showWhenChecked = ->
  this.each (index, checkable) ->
    checkable = $(checkable)
    toggler = $(checkable.data('show-when-checked'))

    if checkable.is(':checked')
      toggler.show()
    else
      toggler.hide()

    checkable.on 'change', ->
      toggler.toggle(200)
