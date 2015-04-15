$ = jQuery

$.fn.webpageDesigner = ->
  this.each (index, designer) ->
    designer = $(designer)
    inputPrefix = designer.data().inputPrefix

    designer.on 'submit', 'form', ->
      buttonHTML = '<i class="fa fa-spinner fa-spin" style="margin-right:5px"></i> Saving Page...'
      $('.webpage-submit button').removeClass('btn-primary').addClass('btn-default disabled').html(buttonHTML)

      if inputPrefix
        $('.webpage-fields *[name]').each ->
          name = $(this).prop('name')
          if name.match(/\[/)
            nameParts = name.split('[')
            nameParts[0] = nameParts[0] + '['
            nameParts.unshift(inputPrefix)
            $(this).prop 'name', nameParts.join('[')
          else
            $(this).prop 'name', "#{inputPrefix}[#{name}]"
