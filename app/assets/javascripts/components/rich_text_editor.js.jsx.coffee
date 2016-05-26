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
    setTimeout this.onPasteTimeout.bind(null, event), 10

  onPasteTimeout: (event) ->
    code = $(this.getDOMNode()).code()
    container = $('<div>').html(code).get(0)
    if this.props.inline
      sanitizer = new Sanitize(Sanitize.Config.RESTRICTED)
    else
      sanitizer = new Sanitize(Sanitize.Config.BASIC)

    $(this.getDOMNode()).code divToP(sanitizer.clean_node(container))

  divToP: (content) ->
    return content.replace /<div[^>]*>(.*)<\/div>/, "<p>$1</p>"

  render: ->
    `<div dangerouslySetInnerHTML={{__html: this.props.html}} />`

window.RichTextEditor = RichTextEditor
