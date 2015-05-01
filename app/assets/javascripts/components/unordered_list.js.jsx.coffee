UnorderedList = React.createClass
  mixins: [PreventDefault]

  propTypes:
    lineHeight: React.PropTypes.number
    items: React.PropTypes.arrayOf(
      React.PropTypes.shape
        id: React.PropTypes.number.isRequired
        name: React.PropTypes.string.isRequired)

  getDefaultProps: ->
    items: []

  items: ->
    this.props.items.map this.renderItem
    
  renderItem: (item) ->
    if item.cached_webpages_json and item.cached_webpages_json.length > 0
      `<li key={item.id} className="dropdown">
        <a href="#" className="dropdown-toggle" data-toggle="dropdown" style={this.style()}>
          {item.name} <span className="caret"> </span>
        </a>
        <ul className="dropdown-menu">
          {this.renderSubItem(item)}
        </ul>
      </li>`
    else
      `<li key={item.id}>
        <a href="#" onClick={this.preventDefault} style={this.style({color: this.props.color})}>
          {item.name}
        </a>
      </li>`

  renderSubItem: (item) ->
    `<li key={item.id}>
      <a href="#" onClick={this.preventDefault} style={{color: '#000 !important'}}>
        {item.name}
      </a>
    </li>`

  render: ->
    `<ul className={this.props.className}>
      {this.items()}
    </ul>`

  style: (defaults) ->
    if this.props.lineHeight and this.props.lineHeight > 20
      $.extend {}, defaults, lineHeight: "#{this.props.lineHeight}px"
    else
      defaults

window.UnorderedList = UnorderedList
