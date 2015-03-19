ThemeSpecialtyDesignerTypes = ['left', 'right']

ThemeSpecialtyDesigner = React.createClass
  propTypes:
    visible: React.PropTypes.bool
    type: React.PropTypes.oneOf ThemeSpecialtyDesignerTypes
    inputPrefix: React.PropTypes.string

  getInitialState: ->
    typeIndex = ThemeSpecialtyDesignerTypes.indexOf(this.props.type)
    type: if typeIndex is -1 then ThemeSpecialtyDesignerTypes[0] else this.props.type
    visible: this.props.visible
    heading: if this.props.heading and this.props.heading.length > 0 then this.props.heading else 'Heading'
    subheading: if this.props.subheading and this.props.subheading.length > 0 then this.props.subheading else 'Subeading'
    text: if this.props.text and this.props.text.length > 0 then this.props.text else 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas condimentum tellus sed enim.'
    background: this.props.background
    backgroundPickerVisible: false

  componentDidMount: ->
    if this.refs.element
      $(this.refs.element.getDOMNode()).click '*', (e) -> e.preventDefault()

  render: ->
    if this.props.inputPrefix
      this.renderWithOptions()
    else
      this.renderElement()

  renderWithOptions: ->
    inputTypeName       = "#{this.props.inputPrefix}[specialty_theme]"
    inputVisibleName    = "#{this.props.inputPrefix}[specialty_visible]"
    inputHeadingName    = "#{this.props.inputPrefix}[specialty_heading]"
    inputSubheadingName = "#{this.props.inputPrefix}[specialty_subheading]"
    inputTextName       = "#{this.props.inputPrefix}[specialty_text]"

    `<div>
      <input type="hidden" name={inputTypeName} value={this.state.type} />
      <input type="hidden" name={inputVisibleName} value={this.state.visible} />
      <input type="hidden" name={inputHeadingName} value={this.state.heading} />
      <input type="hidden" name={inputSubheadingName} value={this.state.subheading} />
      <input type="hidden" name={inputTextName} value={this.state.text} />
      <div className="container">
        <div className="row theme-banner">
          <div className="col-sm-6">
            <h2 className="h4">
              Marketing Message
              <span className="small" style={{marginLeft: 8}}>
                <em>Option {ThemeSpecialtyDesignerTypes.indexOf(this.state.type) + 1} of {ThemeSpecialtyDesignerTypes.length}</em> – {this.renderLabel()}
              </span>
            </h2>
          </div>
          <div className="col-sm-6">
            <div className="checkbox">
              <label><input type="checkbox" checked={this.state.visible} onChange={this.toggleVisible} /> Visible?</label>
            </div>
            <span ref="backgroundPicker" className="btn-group btn-group-sm theme-picker" onClick={this.toggleBackgroundPicker}>
              <span className="btn btn-default" style={{backgroundColor: 'white', borderColor: 'rgba(0,0,0,0.2)', height: 30}}>
                <i className="fa fa-photo" style={{fontSize: 18}}></i>
              </span>
              <span className="btn btn-default" style={{paddingLeft: 4, paddingRight: 4}}><span className="caret"></span></span>
            </span>
            {this.renderBackgroundPicker()}
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
        when 'left'   then `<ThemeSpecialtyLeftDesigner  {...this.state} changeHeading={this.changeHeading} changeSubheading={this.changeSubheading} changeText={this.changeText} />`
        when 'right'  then `<ThemeSpecialtyRightDesigner {...this.state} changeHeading={this.changeHeading} changeSubheading={this.changeSubheading} changeText={this.changeText} />`

  renderLabel: ->
    switch this.state.type
      when 'left'   then 'Left'
      when 'right'  then 'Right'

  renderBackgroundPicker: ->
    if this.state.backgroundPickerVisible
      `<div ref="backgroundPopover" className="popover theme-popover top fade in" style={{display: 'block', maxWidth: 500}}>
        <div className="arrow" style={{left: '50%'}}></div>
        <div className="popover-title">Select a Background Image</div>
        <div className="popover-content">
          {this.renderImagePlacementFields()}
        </div>
      </div>`

  renderImagePlacementFields: ->
    `<ImagePlacementFields {...this.props} imageReceivers={[this.changeBackground]} />`

  repositionBackgroundPopover: ->
    if this.refs.backgroundPicker and this.refs.backgroundPopover
      frame = $(this.refs.backgroundPicker.getDOMNode()).closest('.page-frame')
      picker = $(this.refs.backgroundPicker.getDOMNode())
      popover = $(this.refs.backgroundPopover.getDOMNode())

      frameWidth = frame.width()
      frameLeft = frame.offset().left
      pickerWidth = picker.width()
      pickerHeight = picker.height()
      pickerLeft = picker.offset().left
      pickerTop = picker.offset().top
      pickerMidpoint = pickerLeft + pickerWidth / 2

      framedPopoverWidth = frameWidth - 20
      popover.width if framedPopoverWidth > 500 then 500 else framedPopoverWidth

      popoverMidpoint = popover.offset().left + popover.width() / 2
      popover.css marginLeft: pickerMidpoint - popoverMidpoint

      popoverBottom = popover.offset().top + popover.height()
      popover.css marginTop: pickerTop - popoverBottom - 20

      rightOverflow = (popover.offset().left + popover.width()) - (frameLeft + frameWidth - 10)
      if rightOverflow > 0
        popover.css marginLeft: parseInt(popover.css('marginLeft')) - rightOverflow

      leftOverflow = frameLeft + 10 - popover.offset().left
      if leftOverflow > 0
        popover.css marginLeft: parseInt(popover.css('marginLeft')) + leftOverflow

      arrow = popover.find('.arrow')
      arrowMidpoint = arrow.offset().left + arrow.width()
      pickerMidpoint = pickerLeft + pickerWidth / 2
      arrow.css marginLeft: pickerMidpoint - arrowMidpoint - 20

  changeHeading: (e) ->
    this.setState heading: if e.target.value then e.target.value else e.target.innerHTML

  changeSubheading: (e) ->
    this.setState subheading: if e.target.value then e.target.value else e.target.innerHTML

  changeText: (e) ->
    this.setState text: if e.target.value then e.target.value else e.target.innerHTML

  changeBackground: (url) ->
    this.setState background: url

  toggleBackgroundPicker: ->
    if this.state.backgroundPickerVisible
      this.setState backgroundPickerVisible: false
    else
      this.setState backgroundPickerVisible: true, this.repositionBackgroundPopover

  toggleVisible: ->
    this.setState visible: !this.state.visible

  prev: ->
    index = ThemeSpecialtyDesignerTypes.indexOf(this.state.type)
    if index is -1 or index is 0
      this.setState type: ThemeSpecialtyDesignerTypes[ThemeSpecialtyDesignerTypes.length - 1]
    else
      this.setState type: ThemeSpecialtyDesignerTypes[index - 1]

  next: ->
    index = ThemeSpecialtyDesignerTypes.indexOf(this.state.type)
    if index is -1 or index is ThemeSpecialtyDesignerTypes.length - 1
      this.setState type: ThemeSpecialtyDesignerTypes[0]
    else
      this.setState type: ThemeSpecialtyDesignerTypes[index + 1]

window.ThemeSpecialtyDesigner = ThemeSpecialtyDesigner
