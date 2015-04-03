BlockInputColor = React.createClass
  mixins: [React.addons.PureRenderMixin]

  propTypes:
    label: React.PropTypes.string.isRequired
    name: React.PropTypes.string.isRequired
    id: React.PropTypes.string.isRequired
    value: React.PropTypes.string

  componentDidMount: ->
    this.setupMinicolors(this.props.value or '')
    $(this.refs.close.getDOMNode()).click this.clearMinicolors

  setupMinicolors: (defaultValue) ->
    $(this.refs.minicolors.getDOMNode()).minicolors
      control: 'wheel'
      opacity: true
      defaultValue: defaultValue
      theme: 'block'

  clearMinicolors: ->
    $(this.refs.minicolors.getDOMNode()).minicolors 'destroy'
    $(this.refs.minicolors.getDOMNode()).val ''
    this.setupMinicolors('')

  render: ->
    `<div className="form-group">
      <label htmlFor={this.props.id} className="control-label">{this.props.label}</label>
      <div>
        <i ref="close" className="fa fa-times-circle-o pull-right" style={{cursor: 'pointer', position: 'relative', top: 7, right: 10, fontSize: 20, zIndex: 1}} />
        <input ref="minicolors" id={this.props.id} name={this.props.name} type="text" className="form-control" defaultValue={this.props.value} />
      </div>
    </div>`

window.BlockInputColor = BlockInputColor
