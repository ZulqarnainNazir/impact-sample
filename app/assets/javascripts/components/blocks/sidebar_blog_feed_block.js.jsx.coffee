SidebarBlogFeedBlock = React.createClass
  render: ->
    `<div className="webpage-background">
      <div className="text-center" style={{backgroundColor: 'rgba(0,0,0,0.1)', borderRadius: 5, padding: '5em 2em', margin: '0 0 2em', position: 'relative', zIndex: 1}}>
        <span style={{fontSize: 20}}>Top <strong>{this.props.items_limit}</strong> Blog Feed Items</span>
      </div>
    </div>`

window.SidebarBlogFeedBlock = SidebarBlogFeedBlock
