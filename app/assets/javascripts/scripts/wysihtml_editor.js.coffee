$ = jQuery

$.fn.wysihtmlEditor = ->
  this.summernote
    height: 200
    toolbar: [
      ['display', ['style']],
      ['style', ['bold', 'italic', 'underline', 'superscript']],
      ['insert', ['link']],
      ['lists', ['ul', 'ol']],
      ['align', ['paragraph']],
      ['blocks', ['hr', 'table']],
      ['clear', ['clear']],
      ['misc', ['codeview']],
    ]
    onCreateLink: (link) ->
      if link.indexOf('/') is not 0 and link.indexOf('://') is -1
        'http://' + link
      else
        link
