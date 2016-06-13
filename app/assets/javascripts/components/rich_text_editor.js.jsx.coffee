RichTextEditor = React.createClass
  propTypes:
    enabled: React.PropTypes.bool
    html: React.PropTypes.string
    inline: React.PropTypes.bool
    update: React.PropTypes.func

  getDefaultProps: ->
    inline: false

  componentDidMount: ->
    if this.props.enabled
      this.enableRichText()

  componentWillUpdate: (nextProps) ->
    if !this.props.enabled and nextProps.enabled
      this.enableRichText()
    else if this.props.enabled and !nextProps.enabled
      this.disableRichText()

  componentWillUnmount: ->
    if this.props.enabled
      this.disableRichText()

  enableRichText: ->
    $(this.getDOMNode()).summernote this.summernoteOptions()

  disableRichText: ->
    $(this.getDOMNode()).destroy()

  summernoteOptions: ->
    defaults =
      toolbar: this.summernoteToolbar()
      onCreateLink: (link) -> if link.indexOf('/') != 0 and link.indexOf('://') == -1 then 'http://' + link else link
      onPaste: this.onPaste
    if this.props.update
      $.extend {}, defaults, onChange: this.props.update
    else defaults

  summernoteToolbar: ->
    if this.props.inline
      [
        ['style', ['bold', 'italic', 'underline', 'superscript', 'strikethrough']],
        ['align', ['paragraph']],
        ['clear', ['clear']],
        ['misc', ['codeview']],
      ]
    else
      [
        ['display', ['style']],
        ['style', ['bold', 'italic', 'underline', 'superscript', 'strikethrough']],
        ['insert', ['link']],
        ['lists', ['ul', 'ol']],
        ['align', ['paragraph']],
        ['blocks', ['hr', 'table']],
        ['clear', ['clear']],
        ['misc', ['codeview']],
      ]

  onPaste: (event) ->
    # TODO: get the pasted text from the clipboard and preserve the formatting
    # of the original text.
    #
    # clipboardData = (event.originalEvent || event).clipboardData
    # if clipboardData == undefined || clipboardData == null
    #   # IE does not expose the clipboard data via the event.
    #   clipboardText = window.clipboardData.getData('Text')
    # else
    #   if /text\/html/.test(clipboardData.types)
    #     clipboardText = clipboardData.getData('text/html')
    #   else
    #     clipboardText = clipboardData.getData('text/plain')
    event.preventDefault
    self = this
    editor = $(self.getDOMNode())
    setTimeout( ->
      editorText = editor.code()
      container = $('<div>').html(editorText).get(0)
      if self.props.inline
        sanitizer = new Sanitize(Sanitize.Config.RESTRICTED)
      else
        sanitizer = new Sanitize(Sanitize.Config.BASIC)
      editor.code sanitizer.clean_node(container)
    , 10)

  render: ->
    `<div dangerouslySetInnerHTML={{__html: this.props.html}} />`

window.RichTextEditor = RichTextEditor
