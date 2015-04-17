SpecialtyBlocks = React.createClass
  propTypes:
    blockProps: React.PropTypes.array
    blockAdd: React.PropTypes.object
    editing: React.PropTypes.bool

  shouldComponentUpdate: (nextProps, nextState) ->
    # this.props.block is nextProps.block and this.props.editing is nextProps.editing
    true

  render: ->
    `<div className="webpage-container" data-type="specialty">
      <i className="fa fa-reorder webpage-container-handle" />
      {this.renderBlocks()}
      {this.renderBlockAdd()}
    </div>`

  renderBlocks: ->
    this.props.blockProps.map this.renderBlock

  renderBlock: (blockProps) ->
    `<SpecialtyBlock key={blockProps.block.key} {...blockProps} />`

  renderBlockAdd: ->
    if this.props.blockAdd.visible
      `<div key="add">
        <BlockAdd {...this.props.blockAdd} />
      </div>`

window.SpecialtyBlocks = SpecialtyBlocks
