BlockEditor = React.createClass
  mixins: [React.addons.PureRenderMixin]

  propTypes:
    id: React.PropTypes.string.isRequired
    title: React.PropTypes.string.isRequired
    swapForm: React.PropTypes.func.isRequired
    resetForm: React.PropTypes.func.isRequired

  render: ->
    `<div id={this.props.id} className="modal fade">
      <div className="modal-dialog">
        <div className="modal-content">
          <div className="modal-header">
            <p className="h4 modal-title">{this.props.title}</p>
          </div>
          <div className="modal-body webpage-fields">
            {this.props.children}
          </div>
          <div className="modal-footer">
            <span onClick={this.props.resetForm.bind(null, this.props.boundProps)} className="btn btn-default pull-left">Reset</span>
            <span className="btn btn-default" data-dismiss="modal">Hide</span>
            <span onClick={this.props.swapForm.bind(null, this.props.boundProps)} className="btn btn-primary" data-dismiss="modal">Swap</span>
          </div>
        </div>
      </div>
    </div>`

window.BlockEditor = BlockEditor
