ImagePlacementMetaModal = React.createClass
  propTypes:
    alt: React.PropTypes.string
    title: React.PropTypes.string
    onClick: React.PropTypes.func

  render: ->
    `<div ref="modal" className="modal fade">
      <div className="modal-dialog">
        <div className="modal-content">
          <div className="modal-header">
            <span className="close" data-dismiss="modal">&times;</span>
            <p className="h4 modal-title">Edit Meta Data</p>
          </div>
          <div className="modal-body">
            <div className="form-group">
              <label htmlFor="alt">Alt</label>
              <input type="text" name="alt" id="alt" defaultValue={this.props.alt} className="form-control" />
              <p className="help-block">Sets the <code>alt</code> HTML attribute.</p>
            </div>
            <div className="form-group">
              <label htmlFor="title">Title</label>
              <input type="text" name="title" id="title" defaultValue={this.props.title} className="form-control" />
              <p className="help-block">Sets the <code>title</code> HTML attribute.</p>
            </div>
          </div>
          <div className="modal-footer">
            <span className="btn btn-default" data-dismiss="modal">Close</span>
            <span className="btn btn-primary" onClick={this.props.onClick}>Update</span>
          </div>
        </div>
      </div>
    </div>`

  componentDidMount: ->
    $(this.getDOMNode()).modal(show: false)

window.ImagePlacementMetaModal = ImagePlacementMetaModal
