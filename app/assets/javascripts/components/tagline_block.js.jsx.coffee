TaglineBlock = React.createClass
  propTypes:
    block: React.PropTypes.object
    blockAdd: React.PropTypes.object
    blockEditor: React.PropTypes.object
    blockInputLink: React.PropTypes.object
    blockInputText: React.PropTypes.object
    blockOptions: React.PropTypes.object
    blockInputsClassName: React.PropTypes.string
    editing: React.PropTypes.bool

  shouldComponentUpdate: (nextProps, nextState) ->
    # this.props.block is nextProps.block and this.props.editing is nextProps.editing
    true

  render: ->
    if this.props.block
      `<div className="webpage-block webpage-tagline">
        <BlockOptions {...this.props.blockOptions} />
        <TaglineBlockContent {...this.props.block} />
        <BlockEditor {...this.props.blockEditor}>
          <input type="hidden" name={this.props.name('theme')} value={this.props.block.theme} />
          <div className={this.props.blockInputsClassName}>
            <BlockInputText {...this.props.blockInputText} />
            <hr />
            <BlockInputLink {...this.props.blockInputLink} />
          </div>
        </BlockEditor>
      </div>`
    else if this.props.editing
      `<BlockAdd {...this.props.blockAdd} />`
    else `<div />`

window.TaglineBlock = TaglineBlock
