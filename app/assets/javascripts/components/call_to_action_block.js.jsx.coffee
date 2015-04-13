CallToActionBlock = React.createClass
  propTypes:
    block: React.PropTypes.object
    blockEditor: React.PropTypes.object
    blockImageLibrary: React.PropTypes.object
    blockInputHeading: React.PropTypes.object
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
    `<div key={this.props.block.key} className="col-sm-4">
      <div className="webpage-block">
        <BlockOptions {...this.props.blockOptions} />
        <div className="webpage-call-to-action">
          <CallToActionBlockContent {...this.props.block} />
        </div>
        <BlockEditor {...this.props.blockEditor}>
          <input type="hidden" name={this.props.name('theme')} value={this.props.block.theme} />
          <input type="hidden" name={this.props.name('spoof')} value={Math.random()} />
          <div className={this.props.blockInputsClassName}>
            <BlockInputImage {...this.props.blockInputImage} />
            <hr />
            <BlockInputText {...this.props.blockInputHeading} />
            <BlockInputText {...this.props.blockInputText} />
            <hr />
            <BlockInputLink {...this.props.blockInputLink} />
          </div>
          <BlockImageLibrary {...this.props.blockImageLibrary} />
        </BlockEditor>
      </div>
    </div>`

window.CallToActionBlock = CallToActionBlock
