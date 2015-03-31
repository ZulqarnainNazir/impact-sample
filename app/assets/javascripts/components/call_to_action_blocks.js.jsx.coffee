CallToActionBlocks = React.createClass
  propTypes:
    blockProps: React.PropTypes.array
    blockAdd: React.PropTypes.object
    editing: React.PropTypes.bool

  shouldComponentUpdate: (nextProps, nextState) ->
    # this.props.block is nextProps.block and this.props.editing is nextProps.editing
    true

  render: ->
    `<div className="row">
      {this.renderBlocks()}
      {this.renderBlockAdd()}
    </div>`

  renderBlocks: ->
    this.props.blockProps.map this.renderBlock

  renderBlock: (blockProps) ->
    `<CallToActionBlock key={blockProps.block.key} {...blockProps} />`

  renderBlockAdd: ->
    if this.props.blockAdd.visible
      `<div key="add" className="col-sm-4">
        <BlockAdd {...this.props.blockAdd} />
      </div>`

window.CallToActionBlocks = CallToActionBlocks
