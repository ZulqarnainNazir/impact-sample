BlogFeedBlock = React.createClass
  render: ->
    `<div className="webpage-block-representer">
      <span style={{fontSize: 30}}>Top <strong>{this.props.items_limit}</strong> Blog Feed Items</span>
    </div>`

window.BlogFeedBlock = BlogFeedBlock
