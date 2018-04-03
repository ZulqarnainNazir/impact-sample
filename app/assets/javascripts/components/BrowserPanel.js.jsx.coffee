BrowserPanel = React.createClass
  render: ->

    heading = if !this.props.browserButtonsSrc then "" else
      `<div className="panel-heading">
        <img src={this.props.browserButtonsSrc} alt="" />
      </div>`

    headingClass = if this.props.browserButtonsSrc then 'has-heading' else 'no-heading'

    `<div className={'panel panel-default browser-panel ' + headingClass}>
      {heading}
      {this.props.children}
    </div>`

BrowserPanel.propTypes = {
  browserButtonsSrc: React.PropTypes.string.isRequired,
  editing: React.PropTypes.bool,
  toggleEditing: React.PropTypes.func,
}
window.BrowserPanel = BrowserPanel
