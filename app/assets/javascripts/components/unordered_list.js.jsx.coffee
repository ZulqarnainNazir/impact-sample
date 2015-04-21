UnorderedList = React.createClass
  mixins: [PreventDefault]

  propTypes:
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
        <a href="#" className="dropdown-toggle" data-toggle="dropdown">
          {item.name} <span className="caret"> </span>
        </a>
        <ul className="dropdown-menu">
          {this.renderSubItem(item)}
        </ul>
      </li>`
    else
      `<li key={item.id}>
        <a href="#" onClick={this.preventDefault} style={{color: this.props.color}}>
          {item.name}
        </a>
      </li>`

  renderSubItem: (item) ->
    `<li key={item.id}>
      <a href="#" onClick={this.preventDefault} style={{color: this.props.color}}>
        {item.name}
      </a>
    </li>`

  render: ->
    `<ul className={this.props.className}>
      {this.items()}
    </ul>`

window.UnorderedList = UnorderedList
