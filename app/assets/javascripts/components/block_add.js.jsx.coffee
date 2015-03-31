BlockAdd = React.createClass
  mixins: [React.addons.PureRenderMixin]

  propTypes:
    visible: React.PropTypes.bool
    onClick: React.PropTypes.func.isRequired
    content: React.PropTypes.string.isRequired

  getDefaultProps: ->
    visible: false

  render: ->
    if this.props.visible
      `<div onClick={this.props.onClick} className="webpage-add">
        {this.props.content}
      </div>`
    else
      `<div />`

window.BlockAdd = BlockAdd
