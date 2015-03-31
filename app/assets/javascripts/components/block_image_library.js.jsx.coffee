BlockImageLibrary = React.createClass
  mixins: [React.addons.PureRenderMixin]

  propTypes:
    hide: React.PropTypes.func.isRequired
    visible: React.PropTypes.bool

  getDefaultProps: ->
    visible: false

  render: ->
    if this.props.visible
      `<div>
        <ol className="breadcrumb">
          <li><a onClick={this.props.hide} href="#">Edit Details</a></li>
          <li className="active">Media Library</li>
        </ol>
        <div className="text-center" style={{marginTop: 50, marginBottom: 50}}>
          <i className="fa fa-spinner fa-spin fa-4x" />
        </div>
      </div>`
    else
      `<div />`

window.BlockImageLibrary = BlockImageLibrary
