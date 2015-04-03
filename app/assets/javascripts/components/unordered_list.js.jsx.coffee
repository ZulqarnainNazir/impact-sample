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
