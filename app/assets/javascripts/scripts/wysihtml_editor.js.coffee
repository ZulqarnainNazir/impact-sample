$ = jQuery

$.fn.wysihtmlEditor = ->
  editor = this

  editor.summernote
    height: 100
    toolbar: [
      ['cleaner', ['cleaner']],
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
    onFocus: () ->
      $('.note-toolbar').fadeIn(500)
      $('.note-editable').height(200)
    cleaner: {
          action:'both',
          keepHtml: true,
          keepOnlyTags: ['<p>', '<br>', '<ul>', '<li>', '<b>', '<strong>','<i>', '<a>', '<h1>', '<h2>', '<h3>', '<h4>', '<h5>', '<h6>'],
          keepClasses: false,
          badTags: ['style', 'script', 'applet', 'embed', 'noframes', 'noscript', 'html'],
          badAttributes: ['style', 'start', 'table', 'tbody', 'tr', 'td'],
          notStyle:'position:absolute;bottom:0;left:2px;',
          icon:'<i class="note-icon">CL</i>'
        }
