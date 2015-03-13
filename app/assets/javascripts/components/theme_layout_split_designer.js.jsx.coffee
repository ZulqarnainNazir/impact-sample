ThemeLayoutSplitDesigner = React.createClass
  render: ->
    `<div className="row">
      <div className="col-sm-6">
        <ExamplePosts />
      </div>
      <div className="col-sm-6">
        <ExampleEvents />
      </div>
    </div>`

window.ThemeLayoutSplitDesigner = ThemeLayoutSplitDesigner
