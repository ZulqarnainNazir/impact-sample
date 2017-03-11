BrowserPanel = React.createClass
  render: ->
    `<div className="panel panel-default browser-panel">
      <div className="panel-heading">
        <img src={this.props.browserButtonsSrc} alt="" />
      </div>
      {this.props.children}
    </div>`

BrowserPanel.propTypes = {
  browserButtonsSrc: React.PropTypes.string.isRequired,
  editing: React.PropTypes.bool,
  toggleEditing: React.PropTypes.func,
}
window.BrowserPanel = BrowserPanel
