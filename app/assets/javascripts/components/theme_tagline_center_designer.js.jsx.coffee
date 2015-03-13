ThemeTaglineCenterDesigner = React.createClass
  render: ->
    `<nav className="page-header tagline tagline-center text-center">
      <p className="lead"><ContentEditable html={this.props.text} onChange={this.props.changeText} /></p>
      <p><a className="btn btn-primary btn-lg" href="#">
        <ContentEditable html={this.props.button} onChange={this.props.changeButton} />
      </a></p>
    </nav>`

window.ThemeTaglineCenterDesigner = ThemeTaglineCenterDesigner
