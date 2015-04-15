FooterBlockHandlers =
  propTypes:
    initialFooterBlock: React.PropTypes.object
    defaultFooterBlockAttributes: React.PropTypes.object

  getInitialState: ->
    footerBlock: this.footerBlockInitial()

  footerBlockInputs: ->
    if this.props.initialFooterBlock and this.state.footerBlock
      `<input key={this.footerBlockName('id')} type="hidden" name={this.footerBlockName('id')} value={this.props.initialFooterBlock.id} />`
    else if this.props.initialFooterBlock
      `<div>
        <input key={this.footerBlockName('id')} type="hidden" name={this.footerBlockName('id')} value={this.props.initialFooterBlock.id} />
        <input key={this.footerBlockName('_destroy')} type="hidden" name={this.footerBlockName('_destroy')} value="1" />
      </div>`
    else
      `<div />`

  footerBlockProps: ->
    if this.state.footerBlock
      block: $.extend({}, this.state.footerBlock, { editing: this.state.editing })
      blockOptions: this.footerBlockOptionsProps()
      name: this.footerBlockName

  # PRIVATE LEVEL 1

  footerBlockInitial: ->
    if this.props.initialFooterBlock
      $.extend {}, this.footerBlockDefaultProps(), this.props.initialFooterBlock

  footerBlockID: (name) ->
    "footer-block-attributes-#{name}"

  footerBlockName: (name) ->
    "footer_block_attributes[#{name}]"

  footerBlockOptionsProps: ->
    visible: this.state.editing
    prev: this.footerBlockPrevTheme
    next: this.footerBlockNextTheme
    editorTarget: '#footer-block-editor'
    editLabel: 'Edit Details'
    removeLabel: 'Remove Footer Block'

  # PRIVATE LEVEL 2

  footerBlockDefaultProps: ->
    {}

  footerBlockUpdate: (attributes, event, callback) ->
    event.preventDefault() if event
    this.footerBlockSave $merge: attributes, callback

  footerBlockPrevTheme: ->
    this.footerBlockUpdate theme: this.prevItem(this.footerBlockThemes, this.state.footerBlock.theme)

  footerBlockNextTheme: ->
    this.footerBlockUpdate theme: this.nextItem(this.footerBlockThemes, this.state.footerBlock.theme)

  # PRIVATE LEVEL 3

  footerBlockSave: (changes, callback) ->
    updated = React.addons.update(this.state, footerBlock: changes)
    if typeof(callback) is 'function'
      this.setState updated, callback
    else
      this.setState updated

  footerBlockThemes: ['simple', 'simple_full_width', 'columns', 'layers']

window.FooterBlockHandlers = FooterBlockHandlers
