$(document).on 'change', '.checkbox-toggle input', ->
  $(this).closest('.checkbox-toggle').toggleClass('checkbox-toggle-active')
