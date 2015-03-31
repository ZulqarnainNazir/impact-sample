ContentBlock = React.createClass
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
      <div className="webpage-block webpage-content">
        <BlockOptions {...this.props.blockOptions} />
        <ContentBlockContent {...this.props.block} />
        <BlockEditor {...this.props.blockEditor}>
          <input type="hidden" name={this.props.name('theme')} value={this.props.block.theme} />
          <div className={this.props.blockInputsClassName}>
            <BlockInputImage {...this.props.blockInputImage} />
            <hr />
            <BlockInputText {...this.props.blockInputText} />
          </div>
          <BlockImageLibrary {...this.props.blockImageLibrary} />
        </BlockEditor>
      </div>
    </div>`

window.ContentBlock = ContentBlock
