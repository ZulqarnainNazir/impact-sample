FeedBlock = React.createClass
  propTypes:
    block: React.PropTypes.object
    blockAdd: React.PropTypes.object
    blockEditor: React.PropTypes.object
    blockInputItemsLimit: React.PropTypes.object
    blockOptions: React.PropTypes.object
    editing: React.PropTypes.bool

  shouldComponentUpdate: (nextProps, nextState) ->
    # this.props.block is nextProps.block and this.props.editing is nextProps.editing
    true

  render: ->
    `<div className="webpage-container" data-type="feed">
      <i className="fa fa-reorder webpage-container-handle" />
      {this.renderInterior()}
    </div>`

  renderInterior: ->
    if this.props.block
      `<div className="webpage-block">
        <BlockOptions {...this.props.blockOptions} />
        <div className="webpage-feed">
          <FeedBlockContent {...this.props.block} />
        </div>
        <BlockEditor {...this.props.blockEditor}>
          <BlockInputNumber {...this.props.blockInputItemsLimit} />
        </BlockEditor>
      </div>`
    else if this.props.editing
      `<BlockAdd {...this.props.blockAdd} />`

window.FeedBlock = FeedBlock
