$ = jQuery

$.fn.wysihtmlEditor = ->
  editor = this

  editor.summernote
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
      editorText = $('<div>').html(editor.code()).get(0)
      clipboardData = (event.originalEvent || event).clipboardData
      if clipboardData == undefined || clipboardData == null
        # IE does not expose the clipboard data via the event.
        clipboardText = window.clipboardData.getData('Text')
      else
        if /text\/html/.test(clipboardData.types)
          clipboardText = clipboardData.getData('text/html')
        else
          clipboardText = clipboardData.getData('text/plain')
      clipboardText = $('<div>').html(clipboardText).get(0)
      sanitizer = new Sanitize(Sanitize.Config.BASIC)
      $(editorText).append(sanitizer.clean_node(clipboardText).children)
      editor.code(editorText)
