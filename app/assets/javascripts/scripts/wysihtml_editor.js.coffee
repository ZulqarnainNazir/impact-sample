$ = jQuery

$.fn.wysihtmlEditor = ->
  editor = this

  editor.summernote
    airMode: true
    height: 200
    toolbar: [
      ['display', ['style']],
      ['style', ['bold', 'italic', 'underline', 'superscript', 'strikethrough']],
      ['insert', ['link']],
      ['lists', ['ul', 'ol']],
      ['align', ['paragraph']],
      ['blocks', ['hr', 'table']],
      ['clear', ['clear']],
      ['misc', ['codeview']],
    ]
    onCreateLink: (link) ->
      if link.indexOf('/') != 0 and link.indexOf('://') == -1
        'http://' + link
      else
        link
    onPaste: (event) ->
      event.preventDefault
      setTimeout( ->
        code = editor.code()
        container = $('<div>').html(code).get(0)
        sanitizer = new Sanitize(Sanitize.Config.BASIC)
        editor.code sanitizer.clean_node(container)
      , 10)
