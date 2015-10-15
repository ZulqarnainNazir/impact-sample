$ = jQuery

$.fn.saveOnce = ->
  this.each (index, form) ->
    form = $(form)
    button = form.find('button[type="submit"]')

    form.on 'submit', (e, options) ->
      button.prop('disabled', true).removeClass('btn-primary').addClass('btn-default').prepend('<i class="fa fa-spinner fa-spin" style="margin-right:0.5em">')
