ThemeFooterDesignerTypes = ['simple', 'simpleFullWidth', 'columns', 'layers']

ThemeFooterDesigner = React.createClass
  propTypes:
    type: React.PropTypes.oneOf ThemeFooterDesignerTypes
    inputPrefix: React.PropTypes.string

  getDefaultProps: ->
    type: ThemeFooterDesignerTypes[0]
    pages: [
      { id: 'about', content: 'About' },
      { id: 'contacts', content: 'Contact' },
      { id: 'events', content: 'Events' },
    ]

  getInitialState: ->
    index = ThemeFooterDesignerTypes.indexOf(this.props.type)
    type: if index is -1 then ThemeFooterDesignerTypes[0] else this.props.type

  componentDidMount: ->
    if this.refs.element
      $(this.refs.element.getDOMNode()).click '*', (e) -> e.preventDefault()

  render: ->
    if this.props.inputPrefix
      this.renderWithOptions()
    else
      this.renderElement()

  renderWithOptions: ->
    inputTypeName = "#{this.props.inputPrefix}[footer]"

    `<div>
      <input type="hidden" name={inputTypeName} value={this.state.type} />
      <div className="container">
        <div className="row theme-banner">
          <div className="col-sm-6">
            <h2 className="h4">
              Footer
              <span className="small" style={{marginLeft: 8}}>
                <em>Option {ThemeFooterDesignerTypes.indexOf(this.state.type) + 1} of {ThemeFooterDesignerTypes.length}</em> – {this.renderLabel()}
              </span>
            </h2>
          </div>
          <div className="col-sm-6">
            <span className="btn-group btn-group-sm" style={{marginLeft: 20}}>
              <span className="btn btn-default" onClick={this.prev}><i className="fa fa-caret-left"></i></span>
              <span className="btn btn-default" onClick={this.next}><i className="fa fa-caret-right"></i></span>
            </span>
          </div>
        </div>
      </div>
      <div ref="element">
        {this.renderElement()}
      </div>
    </div>`

  renderElement: ->
    switch this.state.type
      when 'simple'           then `<ThemeFooterSimpleDesigner          {...this.props} />`
      when 'simpleFullWidth'  then `<ThemeFooterSimpleFullWidthDesigner {...this.props} />`
      when 'columns'          then `<ThemeFooterColumnsDesigner         {...this.props} />`
      when 'layers'           then `<ThemeFooterLayersDesigner          {...this.props} />`

  renderLabel: ->
    switch this.state.type
      when 'simple'           then 'Simple'
      when 'simpleFullWidth'  then 'Simple Full-Width'
      when 'columns'          then 'Columns'
      when 'layers'           then 'Layers'

  prev: ->
    index = ThemeFooterDesignerTypes.indexOf(this.state.type)
    if index is -1 or index is 0
      this.setState type: ThemeFooterDesignerTypes[ThemeFooterDesignerTypes.length - 1]
    else
      this.setState type: ThemeFooterDesignerTypes[index - 1]

  next: ->
    index = ThemeFooterDesignerTypes.indexOf(this.state.type)
    if index is -1 or index is ThemeFooterDesignerTypes.length - 1
      this.setState type: ThemeFooterDesignerTypes[0]
    else
      this.setState type: ThemeFooterDesignerTypes[index + 1]

window.ThemeFooterDesigner = ThemeFooterDesigner
