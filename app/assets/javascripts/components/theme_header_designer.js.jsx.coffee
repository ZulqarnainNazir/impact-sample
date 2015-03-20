ThemeHeaderDesignerTypes = ['inline', 'center', 'justify', 'logoAbove', 'logoAboveFullWidth', 'logoBelow', 'logoCenter']
ThemeHeaderDesignerStyles = ['dark', 'light', 'transparent']

ThemeHeaderDesigner = React.createClass
  propTypes:
    type: React.PropTypes.oneOf ThemeHeaderDesignerTypes
    inputPrefix: React.PropTypes.string

  getDefaultProps: ->
    type: ThemeHeaderDesignerTypes[0]
    pages: [
      { id: 'about', content: 'About' },
      { id: 'contacts', content: 'Contact' },
      { id: 'events', content: 'Events' },
    ]

  getInitialState: ->
    typeIndex = ThemeHeaderDesignerTypes.indexOf(this.props.type)
    styleIndex = ThemeHeaderDesignerStyles.indexOf(this.props.style)
    type: if typeIndex is -1 then ThemeHeaderDesignerTypes[0] else this.props.type
    style: if styleIndex is -1 then ThemeHeaderDesignerStyles[0] else this.props.style
    backgroundPickerVisible: false

  componentDidMount: ->
    if this.refs.element
      $(this.refs.element.getDOMNode()).click '*', (e) -> e.preventDefault()
    if this.refs.stylePicker
      $(this.refs.stylePicker.getDOMNode()).popover
        html: true
        placement: 'top'
      $(this.refs.stylePicker.getDOMNode()).parent().on 'change', 'select', this.changeStylePicker

  changeStylePicker: (e) ->
    this.setState style: $(e.target).val()

  render: ->
    if this.props.inputPrefix
      this.renderWithOptions()
    else
      this.renderElement()

  renderWithOptions: ->
    inputTypeName = "#{this.props.inputPrefix}[header]"
    inputStyleName = "#{this.props.inputPrefix}[header_style]"
    stylePickerColor = switch this.state.style
      when 'dark' then '#222'
      when 'light' then '#F5F5F5'
      else '#FFF'

    `<div>
      <input type="hidden" name={inputTypeName} value={this.state.type} />
      <input type="hidden" name={inputStyleName} value={this.state.style} />
      <div className="container">
        <div className="row theme-banner">
          <div className="col-sm-6">
            <h2 className="h4">
              Header
              <span className="small" style={{marginLeft: 8}}>
                <em>Option {ThemeHeaderDesignerTypes.indexOf(this.state.type) + 1} of {ThemeHeaderDesignerTypes.length}</em> – {this.renderLabel()}
              </span>
            </h2>
          </div>
          <div className="col-sm-6">
            <span ref="backgroundPicker" className="btn-group btn-group-sm theme-picker" onClick={this.toggleBackgroundPicker}>
              <span className="btn btn-default" style={{backgroundColor: 'white', borderColor: 'rgba(0,0,0,0.2)', height: 30}}>
                <i className="fa fa-photo" style={{fontSize: 18}}></i>
              </span>
              <span className="btn btn-default" style={{paddingLeft: 4, paddingRight: 4}}><span className="caret"></span></span>
            </span>
            {this.renderBackgroundPicker()}
            <span ref="stylePicker" className="btn-group btn-group-sm theme-picker" title="Select a Header Theme" data-toggle="popover" data-content={this.renderStylePicker()}>
              <span className="btn" style={{backgroundColor: stylePickerColor, borderColor: 'rgba(0,0,0,0.2)', width: 30, height: 30}}></span>
              <span className="btn btn-default" style={{paddingLeft: 4, paddingRight: 4}}><span className="caret"></span></span>
            </span>
            <span className="btn-group btn-group-sm">
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
      when 'inline'             then `<ThemeHeaderInlineDesigner              {...this.props} {...this.state} />`
      when 'center'             then `<ThemeHeaderCenterDesigner              {...this.props} {...this.state} />`
      when 'justify'            then `<ThemeHeaderJustifyDesigner             {...this.props} {...this.state} />`
      when 'logoAbove'          then `<ThemeHeaderLogoAboveDesigner           {...this.props} {...this.state} />`
      when 'logoAboveFullWidth' then `<ThemeHeaderLogoAboveFullWidthDesigner  {...this.props} {...this.state} />`
      when 'logoBelow'          then `<ThemeHeaderLogoBelowDesigner           {...this.props} {...this.state} />`
      when 'logoCenter'         then `<ThemeHeaderLogoCenterDesigner          {...this.props} {...this.state} />`

  renderLabel: ->
    switch this.state.type
      when 'inline'             then 'Inline'
      when 'center'             then 'Center'
      when 'justify'            then 'Justify'
      when 'logoAbove'          then 'Logo Above'
      when 'logoAboveFullWidth' then 'Logo Above, Full-Width'
      when 'logoBelow'          then 'Logo Below'
      when 'logoCenter'         then 'Logo Center'

  renderStylePicker: ->
    switch this.state.style
      when 'transparent'
        '<select class="form-control"><option value="dark">Dark</option><option value="light">Light</option><option value="transparent" selected>Transparent</option></select>'
      when 'light'
        '<select class="form-control"><option value="dark">Dark</option><option value="light" selected>Light</option><option value="transparent">Transparent</option></select>'
      else
        '<select class="form-control"><option value="dark" selected>Dark</option><option value="light">Light</option><option value="transparent">Transparent</option></select>'

  renderBackgroundPicker: ->
    if this.state.backgroundPickerVisible
      `<div ref="backgroundPopover" className="popover theme-popover top fade in" style={{display: 'block', maxWidth: 500}}>
        <div className="arrow" style={{left: '50%'}}></div>
        <div className="popover-title">Select a Hero Background</div>
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

  changeBackground: (url) ->
    this.setState background: url

  toggleBackgroundPicker: ->
    if this.state.backgroundPickerVisible
      this.setState backgroundPickerVisible: false
    else
      this.setState backgroundPickerVisible: true, this.repositionBackgroundPopover

  prev: ->
    index = ThemeHeaderDesignerTypes.indexOf(this.state.type)
    if index is -1 or index is 0
      this.setState type: ThemeHeaderDesignerTypes[ThemeHeaderDesignerTypes.length - 1]
    else
      this.setState type: ThemeHeaderDesignerTypes[index - 1]

  next: ->
    index = ThemeHeaderDesignerTypes.indexOf(this.state.type)
    if index is -1 or index is ThemeHeaderDesignerTypes.length - 1
      this.setState type: ThemeHeaderDesignerTypes[0]
    else
      this.setState type: ThemeHeaderDesignerTypes[index + 1]

window.ThemeHeaderDesigner = ThemeHeaderDesigner
