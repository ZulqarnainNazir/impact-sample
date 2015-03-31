TeamBlock = React.createClass
  propTypes:
    block: React.PropTypes.object
    blockAdd: React.PropTypes.object
    blockOptions: React.PropTypes.object
    editing: React.PropTypes.bool
    name: React.PropTypes.func
    teamMembersPath: React.PropTypes.string

  shouldComponentUpdate: (nextProps, nextState) ->
    # this.props.block is nextProps.block
    true

  render: ->
    if this.props.block
      `<div className="webpage-block webpage-team">
        <BlockOptions {...this.props.blockOptions} />
        <div className="webpage-fields">
          <input type="hidden" name={this.props.name('theme')} value={this.props.block.theme} />
        </div>
        <TeamBlockContent {...this.props.block} />
      </div>`
    else if this.props.editing and this.props.teamMembers and this.props.teamMembers.length > 0
      `<BlockAdd {...this.props.blockAdd} />`
    else if this.props.editing
      `<div className="webpage-add">
        <a href={this.props.teamMembersPath} target="_blank">Add Team Members to your Business to Add a Team Block</a>
      </div>`
    else `<div />`

window.TeamBlock = TeamBlock
