ContentEditable = React.createClass
  render: ->
    `<span contentEditable onInput={this.emitChange} onBlur={this.emitChange} dangerouslySetInnerHTML={{__html: this.props.html}} />`

  shouldComponentUpdate: (nextProps) ->
    nextProps.html != this.getDOMNode().innerHTML

  emitChange: ->
    html = this.getDOMNode().innerHTML
    if html != this.lastHTML
      this.props.onChange
        target:
          value: if html.length > 0 then html else 'Click Here to Add Text'
    this.lastHTML = html

window.ContentEditable = ContentEditable
