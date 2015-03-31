BlockInputText = React.createClass
  mixins: [React.addons.PureRenderMixin]

  propTypes:
    label: React.PropTypes.string.isRequired
    name: React.PropTypes.string.isRequired
    id: React.PropTypes.string.isRequired
    rows: React.PropTypes.number
    value: React.PropTypes.string

  render: ->
    `<div className="form-group">
      <label htmlFor={this.props.id} className="control-label">{this.props.label}</label>
      {this.renderInput()}
    </div>`

  renderInput: ->
    if this.props.rows
      `<textarea id={this.props.id} name={this.props.name} rows={this.props.rows} className="form-control" defaultValue={this.props.value} />`
    else
      `<input id={this.props.id} name={this.props.name} type="text" className="form-control" defaultValue={this.props.value} />`

window.BlockInputText = BlockInputText
