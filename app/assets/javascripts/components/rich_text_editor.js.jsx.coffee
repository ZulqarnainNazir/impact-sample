RichTextEditor = React.createClass
  propTypes:
    enabled: React.PropTypes.bool
    html: React.PropTypes.string
    inline: React.PropTypes.bool
    update: React.PropTypes.func
    name: React.PropTypes.string
    placeholder: React.PropTypes.string
    rows: React.PropTypes.number

  getInitialState: ->
    content: this.props.html

  getDefaultProps: ->
    inline: false
    enabled: true
    placeholder: ''

  componentDidMount: ->
    onfocus = this.handleFocus.bind(this)
    onblur = this.handleBlur.bind(this)

    this.editor = $(React.findDOMNode(this))

    # Enable Summernote
    this.editor.find('.raw').summernote this.summernoteOptions()
    this.editor.find('.note-editor').find('.btn-group').addClass('exclude-custom-css')

    # Highlight the active style in the style dropdown
    dropdownItems = this.editor.find('.note-display .note-dropdown-item')
    this.editor.find('.note-display button').click(() =>
      currentStyle = this.editor.find('.raw').summernote 'editor.currentStyle'
      ancestors = currentStyle.ancestors.map((e) => (e.tagName || '').toLowerCase())
      dropdownItems.removeClass('active')
      ancestors
        .filter((tag) => !['p', 'blockquote', 'pre'].includes(tag))
        .forEach((ancestor) =>
          this.editor.find('.note-display .note-dropdown-item[data-value=' + ancestor + ']').addClass('active')
      )
    )

    # Add focusin and focusout events (they bubble from children)
    this.editor[0].addEventListener('focusin', onfocus)
    this.editor[0].addEventListener('focusout', onblur)

    # Hide the editor at first. Await focus.
    this.editor.find('.note-toolbar').hide()

  _onChange: (content, context) ->
    this.setState
      content: content

  summernoteOptions: ->
    defaults =
      placeholder: this.props.placeholder
      toolbar: this._toolbarOptions()
      onCreateLink: (link) -> if link.indexOf('/') != 0 and link.indexOf('://') == -1 then 'http://' + link else link
      cleaner: this._cleanerOptions(),
      styleTags: ['p', 'blockquote', 'pre', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6']

    if this.props.rows
      defaults = $.extend {}, defaults, height: this.props.rows * 12.5

    if this.props.update
      $.extend {}, defaults, callbacks: onChange: this._onChange

    else defaults

  handleBlur: (event) ->
    # Blurring the editor. Begin hiding the toolbar
    this.editor.find('.note-toolbar').stop(true).slideUp()
    this.editor.toggleClass('focus', false)
    this.editor.toggleClass('empty', this.editor.find('.raw').summernote('isEmpty'));

    if this.props.update
      this.props.update(this.state.content)

  handleFocus: (event) ->
    # Focusing somewhere in the area.
    # Stop hiding toolbar, in case there was just a blur event (changing focus within editor)
    # Then show the toolbar
    this.editor.find('.note-toolbar').stop(true).slideDown()
    this.editor.toggleClass('focus', true)
    this.editor.toggleClass('empty', this.editor.find('.raw').summernote('isEmpty'));

  _toolbarOptions: ->
    if this.props.inline
      [
        ['style', ['bold', 'italic', 'underline', 'superscript', 'strikethrough']],
        ['align', ['paragraph']],
        ['clear', ['clear', 'cleaner', 'codeview']],
      ]
    else
      [
        ['display', ['style']],
        ['style', ['bold', 'italic', 'underline', 'superscript', 'strikethrough']],
        ['insert', ['link']],
        ['lists', ['ul', 'ol']],
        ['align', ['paragraph']],
        ['blocks', ['hr', 'table']],
        ['clear', ['clear', 'cleaner', 'codeview']],
      ]

  _keepTags: ->
    if this.props.inline
      ['<a>']
    else
      [
        '<p>',
        '<br>',
        '<ul>', '<ol>', '<li>',
        '<b>', '<strong>', '<i>', '<em>',
        '<a>',
        '<h1>', '<h2>', '<h3>', '<h4>', '<h5>', '<h6>'
      ]

  _cleanerOptions: ->

    $.extend {}, $.summernote.options.cleaner,
      {
        action: 'both',
        keepHtml: true,
        keepOnlyTags: this._keepTags(),
        keepClasses: false,
        badTags: ['style', 'script', 'applet', 'embed', 'noframes', 'noscript', 'id'],
        badAttributes: ['style', 'start', 'class'],
        limitChars: 0,
        limitDisplay: 'none',
      }

  render: ->
    html = if this.props.html == "<br>" or this.props.html == "<p><br></p>" then '' else this.props.html

    # tabindex is important here to catch 'focuses' that are within editor but not in the text
    # area nor a toolbar button. e.g., blank space within editor area.

    if (this.props.name)
      `<div className="summernote-editor" tabIndex="0">
        <i className="fa fa-plus-circle empty-plus"></i>
        <textarea className="raw" name={this.props.name} defaultValue={html}></textarea>
      </div>`
    else
      `<div className="summernote-editor" tabIndex="0">
        <i className="fa fa-plus-circle empty-plus"></i>
        <div className="raw" dangerouslySetInnerHTML={{__html: html}} />
      </div>`

window.RichTextEditor = RichTextEditor
