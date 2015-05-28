$ = jQuery

$.fn.wysihtmlEditor = ->
  this.summernote
    minHeight: 400
    toolbar: [
      ['display', ['style']],
      ['style', ['bold', 'italic', 'underline', 'superscript']],
      ['insert', ['link']],
      ['lists', ['ul', 'ol']],
      ['align', ['paragraph']],
      ['misc', ['codeview']],
    ]
