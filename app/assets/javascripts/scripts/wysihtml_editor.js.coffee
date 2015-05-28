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
