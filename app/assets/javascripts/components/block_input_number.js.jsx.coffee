BlockInputNumber = React.createClass
  mixins: [React.addons.PureRenderMixin]

  propTypes:
    label: React.PropTypes.string.isRequired
    name: React.PropTypes.string.isRequired
    id: React.PropTypes.string.isRequired
    value: React.PropTypes.string
    min: React.PropTypes.number
    max: React.PropTypes.number

  render: ->
    `<div className="form-group">
      <label htmlFor={this.props.id} className="control-label">{this.props.label}</label>
      <input id={this.props.id} name={this.props.name} type="number" min={this.pros.min} max={this.props.max} className="form-control" defaultValue={this.props.value} />
    </div>`

window.BlockInputNumber = BlockInputNumber
