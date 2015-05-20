ContentBlock = React.createClass
  mixins: [BlockIdentifiedTabs]
  propTypes:
    block: React.PropTypes.object
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
    `<div key={this.props.block.key}>
      <div className="webpage-block">
        <BlockOptions {...this.props.blockOptions} />
        <div className="webpage-content">
          <ContentBlockContent {...this.props.block} />
        </div>
        <BlockEditor {...this.props.blockEditor}>
          <input type="hidden" name={this.props.name('theme')} value={this.props.block.theme} />
          <input type="hidden" name={this.props.name('spoof')} value={Math.random()} />
          <div className={this.props.blockInputsClassName}>
            {this.renderBlockIdentifiedTabs()}
          </div>
        </BlockEditor>
      </div>
    </div>`

  renderContentTab: ->
    `<div>
      <BlockInputText {...this.props.blockInputText} />
    </div>`

  renderDesignTab: ->
    `<div>
      <BlockInputImage {...this.props.blockInputImage} />
      <BlockImageLibrary {...this.props.blockImageLibrary} />
    </div>`

window.ContentBlock = ContentBlock
