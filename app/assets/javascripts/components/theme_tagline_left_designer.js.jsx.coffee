ThemeTaglineLeftDesigner = React.createClass
  render: ->
    `<nav className="page-header tagline tagline-left">
      <p><a className="btn btn-primary btn-lg" href="#">
        <ContentEditable html={this.props.button} onChange={this.props.changeButton} />
      </a></p>
      <p className="lead"><ContentEditable html={this.props.text} onChange={this.props.changeText} /></p>
    </nav>`

window.ThemeTaglineLeftDesigner = ThemeTaglineLeftDesigner
