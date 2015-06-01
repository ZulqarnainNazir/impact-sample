$ = jQuery

$.fn.requiresPlanUpgrade = ->
  this.tooltip
    container: 'body'
    title: 'Upgrade to Enjoy All Features'

  this.children().css
    'pointer-events': 'none'
    opacity: 0.4
