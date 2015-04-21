TeamBlockHandlers =
  propTypes:
    initialTeamBlock: React.PropTypes.object
    defaultTeamBlockAttributes: React.PropTypes.object

  getInitialState: ->
    teamBlock: this.teamBlockInitial()

  teamBlockInputs: ->
    if this.props.initialTeamBlock and this.state.teamBlock
      `<input key={this.teamBlockName('id')} type="hidden" name={this.teamBlockName('id')} value={this.props.initialTeamBlock.id} />`
    else if this.props.initialTeamBlock
      `<div>
        <input key={this.teamBlockName('id')} type="hidden" name={this.teamBlockName('id')} value={this.props.initialTeamBlock.id} />
        <input key={this.teamBlockName('_destroy')} type="hidden" name={this.teamBlockName('_destroy')} value="1" />
      </div>`
    else
      `<div />`

  teamBlockProps: ->
    if this.state.teamBlock
      block: $.extend({}, this.state.teamBlock, { editing: this.state.editing, dropZoneClassName: this.teamBlockDropZoneClassName() })
      blockOptions: this.teamBlockOptionsProps()
      editing: this.state.editing
      name: this.teamBlockName
    else
      blockAdd: this.teamBlockAddProps()
      editing: this.state.editing
      teamMembers: this.props.teamMembers
      teamMembersPath: this.props.teamMembersPath

  # PRIVATE LEVEL 1

  teamBlockInitial: ->
    if this.props.initialTeamBlock
      $.extend {}, this.teamBlockDefaultProps(), this.props.initialTeamBlock

  teamBlockID: (name) ->
    "team-block-attributes-#{name}"

  teamBlockName: (name) ->
    "team_block_attributes[#{name}]"

  teamBlockDropZoneClassName: ->
    'team-block-drop-zone'

  teamBlockAddProps: ->
    visible: !this.state.teamBlock
    onClick: this.teamBlockAdd
    content: 'Add a Team Members Block'

  teamBlockOptionsProps: ->
    visible: this.state.editing
    prev: this.teamBlockPrevTheme
    next: this.teamBlockNextTheme
    removeLabel: 'Remove About Block'
    onRemove: this.aboutBlockRemove
  # PRIVATE LEVEL 2

  teamBlockDefaultProps: ->
    teamMembers: this.props.teamMembers
    theme: 'vertical'

  teamBlockAdd: (event, callback) ->
    event.preventDefault() if event
    this.teamBlockSave $set: $.extend({}, this.teamBlockDefaultProps(), (this.props.defaultTeamBlockAttributes or {})), callback, callback

  teamBlockUpdate: (attributes, event, callback) ->
    event.preventDefault() if event
    this.teamBlockSave $merge: attributes, callback

  teamBlockRemove: (event, callback) ->
    event.preventDefault() if event
    this.teamBlockSave $set: null, callback

  teamBlockPrevTheme: ->
    this.teamBlockUpdate theme: this.prevItem(this.teamBlockThemes, this.state.teamBlock.theme)

  teamBlockNextTheme: ->
    this.teamBlockUpdate theme: this.nextItem(this.teamBlockThemes, this.state.teamBlock.theme)

  # PRIVATE LEVEL 3

  teamBlockSave: (changes, callback) ->
    updated = React.addons.update(this.state, teamBlock: changes)
    if typeof(callback) is 'function'
      this.setState updated, callback
    else
      this.setState updated

  teamBlockThemes: ['vertical', 'horizontal']

window.TeamBlockHandlers = TeamBlockHandlers
