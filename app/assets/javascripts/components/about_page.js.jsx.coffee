AboutPage = React.createClass
  render: ->
    `<div className="page-designer">
      <BrowserPanel {...this.props.browserPanel}>
        <div className="panel-body">
        </div>
      </BrowserPanel>
    </div>`

window.AboutPage = AboutPage
