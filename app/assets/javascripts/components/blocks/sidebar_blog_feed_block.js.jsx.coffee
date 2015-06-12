SidebarBlogFeedBlock = React.createClass
  render: ->
    `<div className="webpage-block-representer">
      <p style={{fontSize: 20}}>Top <strong>{this.props.items_limit}</strong> Blog Feed Items</p>
    </div>`

window.SidebarBlogFeedBlock = SidebarBlogFeedBlock
