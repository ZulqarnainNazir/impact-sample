ContactBlock = React.createClass
  propTypes:
    block: React.PropTypes.object
    blockEditor: React.PropTypes.object
    blockInputText: React.PropTypes.object
    blockOptions: React.PropTypes.object
    name: React.PropTypes.func

  shouldComponentUpdate: (nextProps, nextState) ->
    # this.props.block is nextProps.block and this.props.editing is nextProps.editing
    true

  render: ->
    `<div className="webpage-block webpage-contact">
      <BlockOptions {...this.props.blockOptions} />
      <ContactBlockContent {...this.props.block} />
      <BlockEditor {...this.props.blockEditor}>
        <input type="hidden" name={this.props.name('theme')} value={this.props.block.theme} />
        <BlockInputText {...this.props.blockInputText} />
      </BlockEditor>
    </div>`

window.ContactBlock = ContactBlock
