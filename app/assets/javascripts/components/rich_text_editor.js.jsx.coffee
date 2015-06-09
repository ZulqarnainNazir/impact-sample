RichTextEditor = React.createClass
  propTypes:
    inline: React.PropTypes.bool
    enabled: React.PropTypes.bool
    html: React.PropTypes.string

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
    onCreateLink: (link) -> if link.indexOf('/') != 0 and link.indexOf('://') == -1 then 'http://' + link else link
    toolbar: this.summernoteToolbar()

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
    `<div dangerouslySetInnerHTML={{__html: this.html()}} />`

window.RichTextEditor = RichTextEditor
