$ = jQuery

$.fn.wysihtmlEditor = ->
  editor = this

  editor.summernote
    height: 200
    toolbar: [
      ['cleaner',['cleaner']],
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
    cleaner: {
          notTime:2400,
          action:'both',
          newline:'<br>',
          notStyle:'position:absolute;bottom:0;left:2px',
          icon:'<i class="note-icon">[Your Button]</i>'
        }
