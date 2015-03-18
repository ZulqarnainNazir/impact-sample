ThemeLayoutDesignerTypes = ['sidebar', 'split', 'fullWidth']

ThemeLayoutDesigner = React.createClass
  propTypes:
    type: React.PropTypes.oneOf ThemeLayoutDesignerTypes
    visible: React.PropTypes.bool
    inputPrefix: React.PropTypes.string

  getDefaultProps: ->
    type: ThemeLayoutDesignerTypes[0]

  getInitialState: ->
    index = ThemeLayoutDesignerTypes.indexOf(this.props.type)
    type: if index is -1 then ThemeLayoutDesignerTypes[0] else this.props.type
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
    inputTypeName     = "#{this.props.inputPrefix}[layout_theme]"
    inputVisibleName  = "#{this.props.inputPrefix}[layout_visible]"

    `<div>
      <input type="hidden" name={inputTypeName} value={this.state.type} />
      <input type="hidden" name={inputVisibleName} value={this.state.visible} />
      <div className="container">
        <div className="row theme-banner">
          <div className="col-sm-6">
            <h2 className="h4">
              Posts &amp; Events
              <span className="small" style={{marginLeft: 8}}>
                <em>Option {ThemeLayoutDesignerTypes.indexOf(this.state.type) + 1} of {ThemeLayoutDesignerTypes.length}</em> – {this.renderLabel()}
              </span>
            </h2>
          </div>
          <div className="col-sm-6">
            <div className="checkbox">
              <label><input type="checkbox" checked={!this.state.visible} onChange={this.toggleVisible} /> Hide Element</label>
            </div>
            <span className="btn-group btn-group-sm">
              <span className="btn btn-default" onClick={this.prev}><i className="fa fa-caret-left"></i></span>
              <span className="btn btn-default" onClick={this.next}><i className="fa fa-caret-right"></i></span>
            </span>
          </div>
        </div>
      </div>
      <br />
      {this.renderElement()}
      <br />
    </div>`

  renderElement: ->
    `<div ref="element" className="container">
      {this.renderElementContent()}
    </div>`

  renderElementContent: ->
    if this.state.visible
      switch this.state.type
        when 'fullWidth'  then `<ThemeLayoutFullWidthDesigner {...this.props} />`
        when 'sidebar'    then `<ThemeLayoutSidebarDesigner   {...this.props} />`
        when 'split'      then `<ThemeLayoutSplitDesigner     {...this.props} />`

  renderLabel: ->
    switch this.state.type
      when 'fullWidth'  then 'Full Width'
      when 'sidebar'    then 'Sidebar'
      when 'split'      then 'Split 50-50'

  toggleVisible: ->
    this.setState visible: !this.state.visible

  prev: ->
    index = ThemeLayoutDesignerTypes.indexOf(this.state.type)
    if index is -1 or index is 0
      this.setState type: ThemeLayoutDesignerTypes[ThemeLayoutDesignerTypes.length - 1]
    else
      this.setState type: ThemeLayoutDesignerTypes[index - 1]

  next: ->
    index = ThemeLayoutDesignerTypes.indexOf(this.state.type)
    if index is -1 or index is ThemeLayoutDesignerTypes.length - 1
      this.setState type: ThemeLayoutDesignerTypes[0]
    else
      this.setState type: ThemeLayoutDesignerTypes[index + 1]

window.ThemeLayoutDesigner = ThemeLayoutDesigner
