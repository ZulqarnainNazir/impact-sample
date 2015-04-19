FeedBlockContent = React.createClass
  render: ->
    `<div>
      {this.props.items.slice(0, this.props.items_limit).map(this.renderItem)}
    </div>`

  renderItem: (item) ->
    `<div dangerouslySetInnerHTML={{__html: item}} />`

window.FeedBlockContent = FeedBlockContent
