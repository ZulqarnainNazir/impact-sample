SidebarBlogFeedBlock = React.createClass
  render: ->
    `<div className="webpage-block-representer">
      <p style={{fontSize: 20}}>Top <strong>{this.props.items_limit}</strong> Blog Feed Items</p>
      <p style={{fontSize: 14}}><a href={this.props.contentsPath} target="_blank" style={{color: '#337AB7', textDecoration: 'underline'}}>View Recent Content</a></p>
    </div>`

window.SidebarBlogFeedBlock = SidebarBlogFeedBlock
