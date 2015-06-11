BlockInputStyle = React.createClass
  mixins: [React.addons.PureRenderMixin]

  propTypes:
    label: React.PropTypes.string.isRequired
    name: React.PropTypes.string.isRequired
    id: React.PropTypes.string.isRequired
    value: React.PropTypes.string

  componentDidMount: ->
    $(this.refs.selectpicker.getDOMNode()).selectpicker()

  render: ->
    `<div className="form-group">
      <label htmlFor={this.props.id} className="control-label">{this.props.label}</label>
      <div>
        <select ref="selectpicker" id={this.props.id} name={this.props.name} className="form-control" defaultValue={this.props.value}>
          {this.renderOptions()}
        </select>
      </div>
    </div>`

  renderOptions: ->
    this.props.options.map this.renderOption

  renderOption: (option) ->
    `<option key={option.value} value={option.value}>{option.label}</option>`

window.BlockInputStyle = BlockInputStyle
