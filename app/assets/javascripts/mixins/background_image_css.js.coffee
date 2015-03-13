BackgroundImageCSS =
  backgroundImageCSS: (url) ->
    "url(\"#{url}\")" if url and url.length > 0

window.BackgroundImageCSS = BackgroundImageCSS
