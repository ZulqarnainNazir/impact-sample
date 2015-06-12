SidebarEventsFeedBlock = React.createClass
  render: ->
    `<div className="webpage-block-representer">
      <p style={{fontSize: 20}}>Top <strong>{this.props.items_limit}</strong> Events</p>
    </div>`

window.SidebarEventsFeedBlock = SidebarEventsFeedBlock
