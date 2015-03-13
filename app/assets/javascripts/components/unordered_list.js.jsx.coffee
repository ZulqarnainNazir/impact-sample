UnorderedList = React.createClass
  mixins: [PreventDefault]

  propTypes:
    items: React.PropTypes.arrayOf(
      React.PropTypes.shape
        id: React.PropTypes.string.isRequired
        content: React.PropTypes.string.isRequired)

  items: ->
    this.props.items.map (item) ->
      `<li key={item.id}>
        <a href="#" onClick={this.preventDefault}>
          {item.content}
        </a>
      </li>`

  render: ->
    `<ul className={this.props.className}>
      {this.items()}
    </ul>`

window.UnorderedList = UnorderedList
