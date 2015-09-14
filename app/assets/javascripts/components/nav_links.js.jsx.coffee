NavLinks = React.createClass
  propTypes:
    lineHeight: React.PropTypes.number
    items: React.PropTypes.arrayOf(
      React.PropTypes.shape
        id: React.PropTypes.number.isRequired
        label: React.PropTypes.string.isRequired
        cached_children: React.PropTypes.array)

  getDefaultProps: ->
    items: []

  render: ->
    `<ul className={this.props.className}>
      {this.renderItems()}
    </ul>`

  renderItems: ->
    this.props.items.map this.renderItem
    
  renderItem: (item) ->
    if item.kind is 'dropdown'
      `<li key={item.id} className="dropdown">
        <a href="#" className="dropdown-toggle" data-toggle="dropdown" style={this.style()}>
          {item.label} <span className="caret"> </span>
        </a>
        <ul className="dropdown-menu">
          {this.renderChildren(item.cached_children)}
        </ul>
      </li>`
    else
      `<li key={item.id}>
        <a href="#" onClick={this.preventDefault} style={this.style({color: this.props.color})}>
          {item.label}
        </a>
      </li>`

  renderChildren: (children) ->
    children.map this.renderChild

  renderChild: (child) ->
    `<li key={child.id}>
      <a href="#" onClick={this.preventDefault}>
        {child.label}
      </a>
    </li>`

  style: (defaults) ->
    if this.props.lineHeight and this.props.lineHeight > 20
      $.extend {}, defaults, lineHeight: "#{this.props.lineHeight}px"
    else
      defaults

  preventDefault: (e) ->
    e.preventDefault()

window.NavLinks = NavLinks
