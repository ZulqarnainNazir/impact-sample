ThemeReviewsDesignerTypes = ['basicCarousel', 'columnsCarousel']

ThemeReviewsDesigner = React.createClass
  propTypes:
    type: React.PropTypes.oneOf ThemeReviewsDesignerTypes
    visible: React.PropTypes.bool
    inputPrefix: React.PropTypes.string

  getDefaultProps: ->
    type: ThemeReviewsDesignerTypes[0]

  getInitialState: ->
    index = ThemeReviewsDesignerTypes.indexOf(this.props.type)
    type: if index is -1 then ThemeReviewsDesignerTypes[0] else this.props.type
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
    inputTypeName     = "#{this.props.inputPrefix}[reviews_theme]"
    inputVisibleName  = "#{this.props.inputPrefix}[reviews_visible]"

    `<div>
      <input type="hidden" name={inputTypeName} value={this.state.type} />
      <input type="hidden" name={inputVisibleName} value={this.state.visible} />
      <div className="container">
        <div className="row theme-banner">
          <div className="col-sm-6">
            <h2 className="h4">
              Reviews
              <span className="small" style={{marginLeft: 8}}>
                <em>Option {ThemeReviewsDesignerTypes.indexOf(this.state.type) + 1} of {ThemeReviewsDesignerTypes.length}</em> – {this.renderLabel()}
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
      {this.renderElement()}
    </div>`

  renderElement: ->
    `<div ref="element">
      {this.renderElementContent()}
    </div>`

  renderElementContent: ->
    if this.state.visible
      switch this.state.type
        when 'basicCarousel'    then `<ThemeReviewsBasicCarouselDesigner    {...this.props} />`
        when 'columnsCarousel'  then `<ThemeReviewsColumnsCarouselDesigner  {...this.props} />`

  renderLabel: ->
    switch this.state.type
      when 'basicCarousel'    then 'Basic Carousel'
      when 'columnsCarousel'  then 'Columns Carousel'

  toggleVisible: ->
    this.setState visible: !this.state.visible

  prev: ->
    index = ThemeReviewsDesignerTypes.indexOf(this.state.type)
    if index is -1 or index is 0
      this.setState type: ThemeReviewsDesignerTypes[ThemeReviewsDesignerTypes.length - 1]
    else
      this.setState type: ThemeReviewsDesignerTypes[index - 1]

  next: ->
    index = ThemeReviewsDesignerTypes.indexOf(this.state.type)
    if index is -1 or index is ThemeReviewsDesignerTypes.length - 1
      this.setState type: ThemeReviewsDesignerTypes[0]
    else
      this.setState type: ThemeReviewsDesignerTypes[index + 1]

window.ThemeReviewsDesigner = ThemeReviewsDesigner
