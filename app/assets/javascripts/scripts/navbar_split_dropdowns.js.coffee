$ = jQuery

$.fn.navbarSplitDropdowns = ->
  this.each (index, navbar) ->
    $(navbar).find('.dropdown-sibling').each (j, sibling) ->
      sibling = $(sibling)
      dropdown = sibling.next('.dropdown')
      toggle = dropdown.children('.dropdown-toggle')
      width = sibling.width()
      dropdown.css 'margin-left', "-#{width}px"
      toggle.css 'padding-left', "#{width}px"
