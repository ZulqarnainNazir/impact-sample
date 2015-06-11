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
    if this.props.update
      setTimeout this.update, 100

  update: ->
    this.props.update this.html()

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
    if this.props.update
      $.extend {}, defaults, onChange: this.props.update
    else defaults

  summernoteToolbar: ->
    if this.props.inline
      [
        ['style', ['bold', 'italic', 'underline', 'superscript']],
        ['clear', ['clear']],
      ]
    else
      [
        ['display', ['style']],
        ['style', ['bold', 'italic', 'underline', 'superscript']],
        ['insert', ['link']],
        ['lists', ['ul', 'ol']],
        ['align', ['paragraph']],
        ['blocks', ['hr', 'table']],
        ['clear', ['clear']],
        ['misc', ['codeview']],
      ]

  html: ->
    if this.props.html and this.props.html.length > 0
      this.props.html
    else if this.props.inline
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit'
    else
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum finibus ut tortor quis mattis. Donec sit amet hendrerit risus. Maecenas sed orci metus. Nulla viverra bibendum quam, eu ullamcorper felis dignissim sit amet. Pellentesque quis urna nec arcu malesuada accumsan. Nunc eu lacinia est. Vestibulum cursus consequat interdum.'

  render: ->
    `<div dangerouslySetInnerHTML={{__html: this.html()}} style={{marginTop: '1em', marginBottom: '1em'}}/>`

window.RichTextEditor = RichTextEditor
