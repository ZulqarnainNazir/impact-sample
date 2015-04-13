HeroBlock = React.createClass
  propTypes:
    block: React.PropTypes.object
    blockAdd: React.PropTypes.object
    blockEditor: React.PropTypes.object
    blockImageLibrary: React.PropTypes.object
    blockInputHeading: React.PropTypes.object
    blockInputColor: React.PropTypes.object
    blockInputStyle: React.PropTypes.object
    blockInputImage: React.PropTypes.object
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
      `<div className="webpage-block">
        <BlockOptions {...this.props.blockOptions} />
        <div className="webpage-hero">
          <HeroBlockContent {...this.props.block} />
        </div>
        <BlockEditor {...this.props.blockEditor}>
          <input type="hidden" name={this.props.name('theme')} value={this.props.block.theme} />
          <div className={this.props.blockInputsClassName}>
            <div className="row">
              <div className="col-sm-4">
                <BlockInputStyle {...this.props.blockInputStyle} />
              </div>
              <div className="col-sm-4">
                <BlockInputColor {...this.props.blockInputBackgroundColor} />
              </div>
              <div className="col-sm-4">
                <BlockInputColor {...this.props.blockInputForegroundColor} />
              </div>
            </div>
            <hr />
            <BlockInputImage {...this.props.blockInputImage} />
            <hr />
            <BlockInputText {...this.props.blockInputHeading} />
            <BlockInputText {...this.props.blockInputText} />
            <hr />
            <BlockInputLink {...this.props.blockInputLink} />
          </div>
          <BlockImageLibrary {...this.props.blockImageLibrary} />
        </BlockEditor>
      </div>`
    else if this.props.editing
      `<BlockAdd {...this.props.blockAdd} />`
    else `<div />`

window.HeroBlock = HeroBlock
