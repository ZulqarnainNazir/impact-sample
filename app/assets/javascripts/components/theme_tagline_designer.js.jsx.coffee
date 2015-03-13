ThemeTaglineDesignerTypes = ['left', 'center', 'contain']

ThemeTaglineDesigner = React.createClass
  propTypes:
    type: React.PropTypes.oneOf ThemeTaglineDesignerTypes
    visible: React.PropTypes.bool
    inputPrefix: React.PropTypes.string

  getInitialState: ->
    index = ThemeTaglineDesignerTypes.indexOf(this.props.type)
    type: if index is -1 then ThemeTaglineDesignerTypes[0] else this.props.type
    visible: this.props.visible
    text: if this.props.text and this.props.text.length > 0 then this.props.text else 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas condimentum tellus sed nim dapibus.'
    button: if this.props.button and this.props.button.length > 0 then this.props.button else 'Button'

  componentDidMount: ->
    if this.refs.element
      $(this.refs.element.getDOMNode()).click '*', (e) -> e.preventDefault()

  render: ->
    if this.props.inputPrefix
      this.renderWithOptions()
    else
      this.renderElement()

  renderWithOptions: ->
    inputTypeName     = "#{this.props.inputPrefix}[tagline_theme]"
    inputVisibleName  = "#{this.props.inputPrefix}[tagline_visible]"
    inputTextName     = "#{this.props.inputPrefix}[tagline_text]"
    inputButtonName   = "#{this.props.inputPrefix}[tagline_button]"

    `<div>
      <input type="hidden" name={inputTypeName} value={this.state.type} />
      <input type="hidden" name={inputVisibleName} value={this.state.visible} />
      <input type="hidden" name={inputTextName} value={this.state.text} />
      <input type="hidden" name={inputButtonName} value={this.state.button} />
      <div className="container">
        <div className="row theme-banner">
          <div className="col-sm-6">
            <h2 className="h4">
              Tagline
              <span className="small" style={{marginLeft: 8}}>
                <em>Option {ThemeTaglineDesignerTypes.indexOf(this.state.type) + 1} of {ThemeTaglineDesignerTypes.length}</em> – {this.renderLabel()}
              </span>
            </h2>
          </div>
          <div className="col-sm-6">
            <div className="checkbox">
              <label><input type="checkbox" checked={this.state.visible} onChange={this.toggleVisible} /> Visible?</label>
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
    </div>`

  renderElement: ->
    `<div ref="element" className="container">
      {this.renderElementContent()}
    </div>`

  renderElementContent: ->
    if this.state.visible
      switch this.state.type
        when 'left'     then `<ThemeTaglineLeftDesigner     {...this.state} changeText={this.changeText} changeButton={this.changeButton} />`
        when 'center'   then `<ThemeTaglineCenterDesigner   {...this.state} changeText={this.changeText} changeButton={this.changeButton} />`
        when 'contain'  then `<ThemeTaglineContainDesigner  {...this.state} changeText={this.changeText} changeButton={this.changeButton} />`

  renderLabel: ->
    switch this.state.type
      when 'left'     then 'Left'
      when 'center'   then 'Center'
      when 'contain'  then 'Contain'

  changeText: (e) ->
    this.setState text: if e.target.value then e.target.value else e.target.innerHTML

  changeButton: (e) ->
    this.setState button: if e.target.value then e.target.value else e.target.innerHTML

  toggleVisible: ->
    this.setState visible: !this.state.visible

  prev: ->
    if this.state.visible
      index = ThemeTaglineDesignerTypes.indexOf(this.state.type)
      if index is -1 or index is 0
        this.setState type: ThemeTaglineDesignerTypes[ThemeTaglineDesignerTypes.length - 1]
      else
        this.setState type: ThemeTaglineDesignerTypes[index - 1]

  next: ->
    if this.state.visible
      index = ThemeTaglineDesignerTypes.indexOf(this.state.type)
      if index is -1 or index is ThemeTaglineDesignerTypes.length - 1
        this.setState type: ThemeTaglineDesignerTypes[0]
      else
        this.setState type: ThemeTaglineDesignerTypes[index + 1]

window.ThemeTaglineDesigner = ThemeTaglineDesigner
