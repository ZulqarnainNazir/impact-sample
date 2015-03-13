ThemeLayoutSidebarDesigner = React.createClass
  render: ->
    `<div className="row">
      <div className="col-md-8">
        <ExamplePosts />
      </div>
      <div className="col-md-4">
        <div className="col-sm-6 col-md-12">
          <ExampleEvents />
        </div>
      </div>
    </div>`

window.ThemeLayoutSidebarDesigner = ThemeLayoutSidebarDesigner
