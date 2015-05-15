CallToActionBlocks = React.createClass
  propTypes:
    blockProps: React.PropTypes.array
    blockAdd: React.PropTypes.object
    editing: React.PropTypes.bool
    maximum: React.PropTypes.number
    updateMaximum: React.PropTypes.func

  shouldComponentUpdate: (nextProps, nextState) ->
    # this.props.block is nextProps.block and this.props.editing is nextProps.editing
    true

  render: ->
    `<div className="webpage-container" data-type="call_to_action" data-column-class={this.columnClass()}>
      <i className="fa fa-reorder webpage-container-handle" />
      <span onClick={this.props.updateMaximum} className="webpage-container-option">{this.props.maximum}x</span>
      <div className="row">
        <div className="block-sortable">
          {this.renderBlocks()}
        </div>
        {this.renderBlockAdd()}
      </div>
    </div>`

  renderBlocks: ->
    this.props.blockProps.map this.renderBlock

  renderBlock: (blockProps) ->
    `<CallToActionBlock key={blockProps.block.key} {...blockProps} />`

  renderBlockAdd: ->
    if this.props.blockAdd.visible
      clear = 'none'
      clear = 'left' if this.props.blockProps and this.props.maximum and this.props.blockProps.length % this.props.maximum is 0
      `<div key="add" className={this.columnClass()} style={{clear: clear}}>
        <BlockAdd {...this.props.blockAdd} />
      </div>`

  columnClass: ->
    if this.props.maximum is 4
      'col-sm-3'
    else if this.props.maximum is 2
      'col-sm-6'
    else
      'col-sm-4'

window.CallToActionBlocks = CallToActionBlocks
