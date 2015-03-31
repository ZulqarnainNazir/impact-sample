SpecialtyBlock = React.createClass
  propTypes:
    block: React.PropTypes.object
    blockAdd: React.PropTypes.object
    blockEditor: React.PropTypes.object
    blockImageLibrary: React.PropTypes.object
    blockInputHeading: React.PropTypes.object
    blockInputImage: React.PropTypes.object
    blockInputText: React.PropTypes.object
    blockOptions: React.PropTypes.object
    blockInputsClassName: React.PropTypes.string
    editing: React.PropTypes.bool

  shouldComponentUpdate: (nextProps, nextState) ->
    # this.props.block is nextProps.block and this.props.editing is nextProps.editing
    true

  render: ->
    if this.props.block
      `<div className="webpage-block webpage-specialty">
        <BlockOptions {...this.props.blockOptions} />
        <SpecialtyBlockContent {...this.props.block} />
        <BlockEditor {...this.props.blockEditor}>
          <input type="hidden" name={this.props.name('theme')} value={this.props.block.theme} />
          <div className={this.props.blockInputsClassName}>
            <BlockInputImage {...this.props.blockInputImage} />
            <hr />
            <BlockInputText {...this.props.blockInputHeading} />
            <BlockInputText {...this.props.blockInputText} />
          </div>
          <BlockImageLibrary {...this.props.blockImageLibrary} />
        </BlockEditor>
      </div>`
    else if this.props.editing
      `<BlockAdd {...this.props.blockAdd} />`
    else `<div />`

window.SpecialtyBlock = SpecialtyBlock
