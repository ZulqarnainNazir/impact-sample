ThemeTeamDesignerTypes = ['vertical', 'horizontal']

ThemeTeamDesigner = React.createClass
  propTypes:
    visible: React.PropTypes.bool
    type: React.PropTypes.oneOf ThemeTeamDesignerTypes
    inputPrefix: React.PropTypes.string

  getInitialState: ->
    typeIndex = ThemeTeamDesignerTypes.indexOf(this.props.type)
    type: if typeIndex is -1 then ThemeTeamDesignerTypes[0] else this.props.type
    visible: this.props.visible

  componentDidMount: ->
    if this.refs.element
      $(this.refs.element.getDOMNode()).click '*', (e) -> e.preventDefault()

  render: ->
    if this.props.inputPrefix
      this.renderWithOptions()
    else
      this.renderElement()

  renderWithOptions: ->
    inputTypeName       = "#{this.props.inputPrefix}[team_theme]"
    inputVisibleName    = "#{this.props.inputPrefix}[team_visible]"

    `<div>
      <input type="hidden" name={inputTypeName} value={this.state.type} />
      <input type="hidden" name={inputVisibleName} value={this.state.visible} />
      <div className="container">
        <div className="row theme-banner">
          <div className="col-sm-6">
            <h2 className="h4">
              Team Information
              <span className="small" style={{marginLeft: 8}}>
                <em>Option {ThemeTeamDesignerTypes.indexOf(this.state.type) + 1} of {ThemeTeamDesignerTypes.length}</em> – {this.renderLabel()}
              </span>
            </h2>
          </div>
          <div className="col-sm-6">
            <div className="checkbox">
              <label><input type="checkbox" checked={!this.state.visible} onChange={this.toggleVisible} /> Hide Element</label>
            </div>
            <a href={this.props.teamMembersPath} target="_blank" className="small">Edit Team Members</a>
            <span className="btn-group btn-group-sm">
              <span className="btn btn-default" onClick={this.prev}><i className="fa fa-caret-left"></i></span>
              <span className="btn btn-default" onClick={this.next}><i className="fa fa-caret-right"></i></span>
            </span>
          </div>
        </div>
      </div>
      <br />
      {this.renderElement()}
    </div>`

  renderElement: ->
    `<div ref="element" className="container">
      {this.renderElementContent()}
    </div>`

  renderElementContent: ->
    if this.state.visible
      switch this.state.type
        when 'vertical'   then `<ThemeTeamVerticalDesigner    teamMembers={this.props.teamMembers} />`
        when 'horizontal' then `<ThemeTeamHorizontalDesigner  teamMembers={this.props.teamMembers} />`

  renderLabel: ->
    switch this.state.type
      when 'vertical'   then 'Vertical Profiles'
      when 'horizontal' then 'Horizontal Profiles'

  toggleVisible: ->
    this.setState visible: !this.state.visible

  prev: ->
    index = ThemeTeamDesignerTypes.indexOf(this.state.type)
    if index is -1 or index is 0
      this.setState type: ThemeTeamDesignerTypes[ThemeTeamDesignerTypes.length - 1]
    else
      this.setState type: ThemeTeamDesignerTypes[index - 1]

  next: ->
    index = ThemeTeamDesignerTypes.indexOf(this.state.type)
    if index is -1 or index is ThemeTeamDesignerTypes.length - 1
      this.setState type: ThemeTeamDesignerTypes[0]
    else
      this.setState type: ThemeTeamDesignerTypes[index + 1]

window.ThemeTeamDesigner = ThemeTeamDesigner
