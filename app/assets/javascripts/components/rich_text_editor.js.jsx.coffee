RichTextEditor = React.createClass
  propTypes:
    enabled: React.PropTypes.bool
    html: React.PropTypes.string
    inline: React.PropTypes.bool
    update: React.PropTypes.func

  getInitialState: ->
    content: this.props.html


  getDefaultProps: ->
    inline: false
    enabled: true

  componentDidMount: ->
    # this.$node = $(ReactDOM.findDOMNode(this))
    if this.props.enabled
      this.enableRichText()

  componentWillUpdate: (nextProps) ->

    # if this.selectionRange
    # console.log this.selectionRange
    # console.log this.selectionRange.getStartPoint(), this.selectionRange.getEndPoint()
    # range = document.createRange()
    # start = this.selectionRange.getStartPoint()
    # range.setStart(start.node, start.offset)
    # end = this.selectionRange.getEndPoint()
    # range.setEnd(end.node, end.offset)
    # sel = window.getSelection()
    # sel.removeAllRanges()
    # sel.addRange(range)

    # console.log "updating", ReactDOM.findDOMNode(this)
    # if this.$node
    #   this.$node.summernote('restoreRange')

    # if !this.props.enabled and nextProps.enabled
    #   this.enableRichText()
    # else if this.props.enabled and !nextProps.enabled
    #   this.disableRichText()

  componentWillUnmount: ->
    if this.props.enabled
      this.disableRichText()

  enableRichText: ->
    $(ReactDOM.findDOMNode(this)).summernote this.summernoteOptions()
    $(ReactDOM.findDOMNode(this)).siblings('.note-editor').find('.btn-group').addClass('exclude-custom-css')
    $(".note-air-popover a").on('click', (e) -> e.preventDefault())

  disableRichText: ->
    # $(ReactDOM.findDOMNode(this)).destroy()
    # $(ReactDOM.findDOMNode(this)).summernote('disable')

  _onChange: (content, context) ->
    this.setState
      content: content
    # console.log $(context).summernote('createRange')
    # # console.log context
    # # console.log
    # # this.$node = $(context)
    # # if this.$node
    # # this.$node.summernote('saveRange')
    # this.selectionRange = $(context).summernote('createRange')
    # this.props.update(content)

  summernoteOptions: ->
    defaults =
      placeholder: 'placeholder'
      # focus: true
      airMode: true
      # toolbar: this.summernoteToolbar()
      airPopover: this.summernoteToolbar()
      onCreateLink: (link) -> if link.indexOf('/') != 0 and link.indexOf('://') == -1 then 'http://' + link else link
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
    if this.props.update
      $.extend {}, defaults, onChange: this._onChange

    else defaults

  mouseEnter: (event) ->

  handleClick: (event) ->
    $(".note-air-popover").hide()

  handleBlur: (event, c) ->
    console.log "blurring"
    console.log event
    # console.log this.$node.id
    # $(event.target).summernote('disable')
    # this.$node.destroy()
    # this.disableRichText()
    # reg = /note-editor-(\d+)/
    # console.log $(event.target).attr('id').match(reg)
    # id = $(event.target).attr('id').match(reg)[1]
    # $("#note-popover-#{id} .note-air-popover").hide()
    if this.props.update
      this.props.update(this.state.content)

  summernoteToolbar: ->
    if this.props.inline
      [
        # ['cleaner', ['cleaner']],
        ['style', ['bold', 'italic', 'underline', 'superscript', 'strikethrough']],
        ['align', ['paragraph']],
        ['clear', ['clear']],
        # ['misc', ['codeview']],
      ]
    else
      [
        # ['cleaner', ['cleaner']],
        ['display', ['style']],
        ['style', ['bold', 'italic', 'underline', 'superscript', 'strikethrough']],
        ['insert', ['link']],
        ['lists', ['ul', 'ol']],
        ['align', ['paragraph']],
        ['blocks', ['hr', 'table']],
        ['clear', ['clear']],
        # ['misc', ['codeview']],
      ]

  render: ->
    # if this.props.html == "<br>"
    #   `<i className="fa fa-plus-circle" aria-hidden="true" style={{ color: '#1ab394', padding: '5px' }} onClick={() => this.props.update(' ')}></i>`
    html = if this.props.html == "<br>" or this.props.html == "<p><br></p>" then '' else this.props.html
    `<div
      dangerouslySetInnerHTML={{__html: html}}
      onMouseEnter={this.mouseEnter}
      onBlur={this.handleBlur}
      onClick={this.handleClick}
    />`

window.RichTextEditor = RichTextEditor
