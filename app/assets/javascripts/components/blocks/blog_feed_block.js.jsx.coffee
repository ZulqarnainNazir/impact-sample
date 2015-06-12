BlogFeedBlock = React.createClass
  render: ->
    `<div className="webpage-block-representer">
      <p style={{fontSize: 30}}>Top <strong>{this.props.items_limit}</strong> Blog Feed Items</p>
    </div>`

window.BlogFeedBlock = BlogFeedBlock
