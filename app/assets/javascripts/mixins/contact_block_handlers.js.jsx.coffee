ContactBlockHandlers =
  propTypes:
    initialContactBlock: React.PropTypes.object.isRequired
    defaultContactBlockAttributes: React.PropTypes.object

  getInitialState: ->
    contactBlock: this.contactBlockInitial()

  contactBlockInputs: ->
    if this.props.initialContactBlock and this.state.contactBlock
      `<input key={this.contactBlockName('id')} type="hidden" name={this.contactBlockName('id')} value={this.props.initialContactBlock.id} />`
    else if this.props.initialContactBlock
      `<div>
        <input key={this.contactBlockName('id')} type="hidden" name={this.contactBlockName('id')} value={this.props.initialContactBlock.id} />
        <input key={this.contactBlockName('_destroy')} type="hidden" name={this.contactBlockName('_destroy')} value="1" />
      </div>`
    else
      `<div />`

  contactBlockProps: ->
    block: $.extend({}, this.state.contactBlock, { editing: this.state.editing, dropZoneClassName: this.contactBlockDropZoneClassName() })
    blockEditor: this.contactBlockEditorProps()
    blockInputText: this.contactBlockInputTextProps()
    blockOptions: this.contactBlockOptionsProps()
    name: this.contactBlockName

  # PRIVATE LEVEL 1

  contactBlockInitial: ->
    if this.props.initialContactBlock
      $.extend {}, this.contactBlockDefaultProps(), this.props.initialContactBlock

  contactBlockID: (name) ->
    "contact-block-attributes-#{name}"

  contactBlockName: (name) ->
    "contact_block_attributes[#{name}]"

  contactBlockDropZoneClassName: ->
    'contact-block-drop-zone'

  contactBlockEditorProps: ->
    id: 'contact-block-editor'
    title: 'Edit Contact Block Details'
    swapForm: this.contactBlockSwapForm
    resetForm: this.contactBlockResetForm

  contactBlockInputTextProps: ->
    id: this.contactBlockID('text')
    name: this.contactBlockName('text')
    value: this.state.contactBlock.text
    label: 'Text'
    rows: 4
    wysiwyg: true

  contactBlockOptionsProps: ->
    visible: this.state.editing
    prev: this.contactBlockPrevTheme
    next: this.contactBlockNextTheme
    editorTarget: '#contact-block-editor'
    editLabel: 'Edit Details'
    onEdit: this.contactBlockEdit

  # PRIVATE LEVEL 2

  contactBlockDefaultProps: ->
    text: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.
      Aenean ultricies ultrices mi eu maximus. Curabitur dignissim libero
      quis sem suscipit tristique. Nunc convallis lorem ut sagittis faucibus.'
    name: this.props.business.name
    address_line_one: this.props.location.address_line_one
    address_line_two: this.props.location.address_line_two
    phone_number: this.props.location.phone_number
    email: this.props.location.email
    openings: this.props.openings

  contactBlockEdit: ->

  contactBlockUpdate: (attributes, event, callback) ->
    event.preventDefault() if event
    this.contactBlockSave $merge: attributes, callback

  contactBlockRemove: (event, callback) ->
    event.preventDefault() if event
    this.contactBlockSave $set: null, callback

  contactBlockSwapForm: () ->
    this.contactBlockUpdate
      text: this.contactBlockInputGetVal('text')

  contactBlockResetForm: () ->
    this.contactBlockInputSetVal 'heading', this.state.contactBlock.heading
    if $('#' + this.contactBlockID('text')).data('wysihtml5')
      $('#' + this.contactBlockID('text')).data('wysihtml5').editor.setValue(this.state.contactBlock.text)

  contactBlockPrevTheme: ->
    this.contactBlockUpdate theme: this.prevItem(this.contactBlockThemes, this.state.contactBlock.theme)

  contactBlockNextTheme: ->
    this.contactBlockUpdate theme: this.nextItem(this.contactBlockThemes, this.state.contactBlock.theme)

  # PRIVATE LEVEL 3

  contactBlockSave: (changes, callback) ->
    updated = React.addons.update(this.state, contactBlock: changes)
    if typeof(callback) is 'function'
      this.setState updated, callback
    else
      this.setState updated

  contactBlockInputGetVal: (name) ->
    $('#' + this.contactBlockID(name)).val()

  contactBlockInputSetVal: (name, value) ->
    $('#' + this.contactBlockID(name)).val(value)

  contactBlockThemes: ['right', 'banner', 'inline']

window.ContactBlockHandlers = ContactBlockHandlers
