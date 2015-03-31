FooterBlock = React.createClass
  propTypes:
    block: React.PropTypes.object
    blockOptions: React.PropTypes.object

  shouldComponentUpdate: (nextProps, nextState) ->
    # this.props.block is nextProps.block
    true

  render: ->
    if this.props.block
      `<div className="webpage-block webpage-footer">
        <BlockOptions {...this.props.blockOptions} />
        <div className="webpage-fields">
          <input type="hidden" name={this.props.name('theme')} value={this.props.block.theme} />
        </div>
        <FooterBlockContent {...this.props.block} />
      </div>`
    else `<div />`

window.FooterBlock = FooterBlock
