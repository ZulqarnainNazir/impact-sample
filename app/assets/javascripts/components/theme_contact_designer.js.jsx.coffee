ThemeContactDesignerTypes = ['right', 'banner', 'inline']

ThemeContactDesigner = React.createClass
  propTypes:
    type: React.PropTypes.oneOf ThemeContactDesignerTypes
    inputPrefix: React.PropTypes.string

  getInitialState: ->
    typeIndex = ThemeContactDesignerTypes.indexOf(this.props.type)
    type: if typeIndex is -1 then ThemeContactDesignerTypes[0] else this.props.type
    text: if this.props.text and this.props.text.length > 0 then this.props.text else 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas condimentum tellus sed nim dapibus.'

  componentDidMount: ->
    if this.refs.element
      $(this.refs.element.getDOMNode()).click '*', (e) -> e.preventDefault()

  render: ->
    if this.props.inputPrefix
      this.renderWithOptions()
    else
      this.renderElement()

  renderWithOptions: ->
    inputTypeName = "#{this.props.inputPrefix}[contact_theme]"
    inputTextName = "#{this.props.inputPrefix}[text]"

    `<div>
      <input type="hidden" name={inputTypeName} value={this.state.type} />
      <input type="hidden" name={inputTextName} value={this.state.text} />
      <div className="container">
        <div className="page-header">
          <h1>Contact</h1>
        </div>
        <div className="row theme-banner">
          <div className="col-sm-6">
            <h2 className="h4">
              Contact Information
              <span className="small" style={{marginLeft: 8}}>
                <em>Option {ThemeContactDesignerTypes.indexOf(this.state.type) + 1} of {ThemeContactDesignerTypes.length}</em> – {this.renderLabel()}
              </span>
            </h2>
          </div>
          <div className="col-sm-6">
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
    switch this.state.type
      when 'right'  then `<ThemeContactRightDesigner  {...this.props} />`
      when 'banner' then `<ThemeContactBannerDesigner {...this.props} />`
      when 'inline' then `<ThemeContactInlineDesigner {...this.props} text={this.state.text} changeText={this.changeText} />`

  renderLabel: ->
    switch this.state.type
      when 'right'  then 'Right-Aligned Map'
      when 'banner' then 'Map Across Top'
      when 'inline' then 'Inline Map'

  changeText: (e) ->
    this.setState text: if e.target.value then e.target.value else e.target.innerHTML

  prev: ->
    index = ThemeContactDesignerTypes.indexOf(this.state.type)
    if index is -1 or index is 0
      this.setState type: ThemeContactDesignerTypes[ThemeContactDesignerTypes.length - 1]
    else
      this.setState type: ThemeContactDesignerTypes[index - 1]

  next: ->
    index = ThemeContactDesignerTypes.indexOf(this.state.type)
    if index is -1 or index is ThemeContactDesignerTypes.length - 1
      this.setState type: ThemeContactDesignerTypes[0]
    else
      this.setState type: ThemeContactDesignerTypes[index + 1]

window.ThemeContactDesigner = ThemeContactDesigner
