$(document).on 'page:change', ->
  if window.ga != undefined
    ga('send', 'pageview', window.location.pathname)
    ga('rollup.send', 'pageview', window.location.pathname)
