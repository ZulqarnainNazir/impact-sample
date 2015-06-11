BlockOptions = React.createClass
  mixins: [React.addons.PureRenderMixin]

  propTypes:
    visible: React.PropTypes.bool
    prev: React.PropTypes.func
    next: React.PropTypes.func
    editLabel: React.PropTypes.string
    editorTarget: React.PropTypes.string
    removeLabel: React.PropTypes.string
    onEdit: React.PropTypes.func
    onRemove: React.PropTypes.func
    sortable: React.PropTypes.bool

  getDefaultProps: ->
    visible: false

  render: ->
    if this.props.visible
      `<div className="webpage-block-options btn-group btn-group-sm">
        {this.renderPrevious()}
        {this.renderSortable()}
        {this.renderDropdown()}
        {this.renderNext()}
      </div>`
    else
      `<div />`

  renderDropdown: ->
    if this.props.onEdit or this.props.onRemove
      `<div className="btn-group btn-group-sm">
        <span className="btn btn-warning dropdown-toggle" data-toggle="dropdown">Options <i className="fa fa-caret-down"></i></span>
        <ul className="dropdown-menu dropdown-menu-right">
          {this.renderEdit()}
          {this.renderRemove()}
        </ul>
      </div>`
    else
      `<span className="btn btn-warning">Theme</span>`

  renderEdit: ->
    if this.props.onEdit
      `<li><a href={this.props.editorTarget} onClick={this.props.onEdit} data-toggle="modal" data-target={this.props.editorTarget}><i className="fa fa-edit" /> {this.props.editLabel}</a></li>`

  renderRemove: ->
    if this.props.onRemove
      `<li><a href="#" onClick={this.props.onRemove}><i className="fa fa-trash" /> {this.props.removeLabel}</a></li>`

  renderPrevious: ->
    if this.props.prev
      `<span onClick={this.props.prev} className="btn btn-warning"><i className="fa fa-caret-left"></i></span>`

  renderNext: ->
    if this.props.next
      `<span onClick={this.props.next} className="btn btn-warning"><i className="fa fa-caret-right"></i></span>`

  renderSortable: ->
    if this.props.sortable
      `<span className="btn btn-warning webpage-block-options-handle"><i className="fa fa-reorder"></i></span>`

window.BlockOptions = BlockOptions
