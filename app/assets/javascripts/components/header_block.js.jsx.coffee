HeaderBlock = React.createClass
  propTypes:
    block: React.PropTypes.object
    blockAdd: React.PropTypes.object
    blockEditor: React.PropTypes.object
    blockInputBackgroundColor: React.PropTypes.object
    blockInputForegroundColor: React.PropTypes.object
    blockInputStyle: React.PropTypes.object
    blockOptions: React.PropTypes.object
    editing: React.PropTypes.bool

  shouldComponentUpdate: (nextProps, nextState) ->
    # this.props.block is nextProps.block and this.props.editing is nextProps.editing
    true

  render: ->
    if this.props.block
      `<div className="webpage-block webpage-header">
        <BlockOptions {...this.props.blockOptions} />
        <HeaderBlockContent {...this.props.block} />
        <BlockEditor {...this.props.blockEditor}>
          <input type="hidden" name={this.props.name('theme')} value={this.props.block.theme} />
          <BlockInputStyle {...this.props.blockInputStyle} />
          <div className="row">
            <div className="col-sm-6">
              <BlockInputColor {...this.props.blockInputBackgroundColor} />
            </div>
            <div className="col-sm-6">
              <BlockInputColor {...this.props.blockInputForegroundColor} />
            </div>
          </div>
        </BlockEditor>
      </div>`
    else if this.props.editing
      `<BlockAdd {...this.props.blockAdd} />`
    else `<div />`

window.HeaderBlock = HeaderBlock
