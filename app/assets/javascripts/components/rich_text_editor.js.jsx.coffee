RichTextEditor = React.createClass
  propTypes:
    enabled: React.PropTypes.bool
    html: React.PropTypes.string
    inline: React.PropTypes.bool
    update: React.PropTypes.func

  getDefaultProps: ->
    inline: false
    enabled: true

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
    $(ReactDOM.findDOMNode(this)).summernote this.summernoteOptions()

  disableRichText: ->
    $(ReactDOM.findDOMNode(this)).destroy()

  summernoteOptions: ->
    defaults =
      toolbar: this.summernoteToolbar()
      onCreateLink: (link) -> if link.indexOf('/') != 0 and link.indexOf('://') == -1 then 'http://' + link else link
      cleaner: {
            notTime:2400,
            action:'both',
            newline:'<br>',
            notStyle:'position:absolute;bottom:0;left:2px;',
            icon:'<i class="note-icon">[Your Button]</i>'
          }
    if this.props.update
      $.extend {}, defaults, onChange: this.props.update
    else defaults

  summernoteToolbar: ->
    if this.props.inline
      [
        ['cleaner',['cleaner']],
        ['style', ['bold', 'italic', 'underline', 'superscript', 'strikethrough']],
        ['align', ['paragraph']],
        ['clear', ['clear']],
        ['misc', ['codeview']],
      ]
    else
      [
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

  render: ->
    `<div dangerouslySetInnerHTML={{__html: this.props.html}} />`

window.RichTextEditor = RichTextEditor
