CallToActionBlock = React.createClass
  mixins: [BlockIdentifiedTabs],

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
    `<div key={this.props.block.key} className={this.columnClass()}>
      <div className="webpage-block">
        <BlockOptions {...this.props.blockOptions} />
        <div className="webpage-call-to-action">
          <CallToActionBlockContent {...this.props.block} />
        </div>
        <BlockEditor {...this.props.blockEditor}>
          <input type="hidden" name={this.props.name('theme')} value={this.props.block.theme} />
          <input type="hidden" name={this.props.name('spoof')} value={Math.random()} />
          <input type="hidden" name={this.props.name('position')} defaultValue={this.props.block.position} />
          <div className={this.props.blockInputsClassName}>
            {this.renderBlockIdentifiedTabs()}
          </div>
          <BlockImageLibrary {...this.props.blockImageLibrary} />
        </BlockEditor>
      </div>
    </div>`

  columnClass: ->
    if this.props.maximum is 4
      'col-sm-3'
    else if this.props.maximum is 2
      'col-sm-6'
    else
      'col-sm-4'

  renderContentTab: ->
    `<div>
      <BlockInputText {...this.props.blockInputHeading} />
      <BlockInputText {...this.props.blockInputText} />
      <BlockInputLink {...this.props.blockInputLink} />
    </div>`

  renderDesignTab: ->
    `<div>
      <BlockInputImage {...this.props.blockInputImage} />
    </div>`

window.CallToActionBlock = CallToActionBlock
