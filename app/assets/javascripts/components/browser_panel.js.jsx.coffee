BrowserPanel = React.createClass
  propTypes:
    browserButtonsSrc: React.PropTypes.string.isRequired
    editing: React.PropTypes.bool
    toggleEditing: React.PropTypes.func

  render: ->
    `<div className="panel panel-default" style={{boxShadow: '0 0 1em rgba(0,0,0,0.1), 0 0 0.2em rgba(0,0,0,0.2)'}}>
      <div className="panel-heading">
        <img src={this.props.browserButtonsSrc} alt="" />
      </div>
      {this.props.children}
      <div className="panel-footer text-right">
        {this.renderEditingToggle()}
      </div>
    </div>`

  renderEditingToggle: ->
    if this.props.toggleEditing
      `<div className="checkbox" style={{margin: 0}}>
        <label>
          <input type="checkbox" checked={this.props.editing} onChange={this.props.toggleEditing} />
          Display Editing Dialogs?
        </label>
      </div>`

window.BrowserPanel = BrowserPanel
