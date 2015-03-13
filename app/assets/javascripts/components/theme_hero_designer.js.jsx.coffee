ThemeHeroDesignerTypes = ['fullImage', 'fullImageRight', 'fullImageRightWell', 'fullImageRightWellDark', 'fullImageRightForm', 'splitImage', 'splitVideo']
ThemeHeroDesignerStyles = ['light', 'dark']

ThemeHeroDesigner = React.createClass
  propTypes:
    visible: React.PropTypes.bool
    type: React.PropTypes.oneOf ThemeHeroDesignerTypes
    inputPrefix: React.PropTypes.string

  getInitialState: ->
    typeIndex = ThemeHeroDesignerTypes.indexOf(this.props.type)
    styleIndex = ThemeHeroDesignerStyles.indexOf(this.props.style)
    type: if typeIndex is -1 then ThemeHeroDesignerTypes[0] else this.props.type
    style: if styleIndex is -1 then ThemeHeroDesignerStyles[0] else this.props.style
    visible: this.props.visible
    title: if this.props.title and this.props.title.length > 0 then this.props.title else 'Title'
    text: if this.props.text and this.props.text.length > 0 then this.props.text else 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas condimentum tellus sed enim.'
    background: this.props.background
    button: if this.props.button and this.props.button.length > 0 then this.props.button else 'Button'
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
    inputTypeName     = "#{this.props.inputPrefix}[hero_theme]"
    inputVisibleName  = "#{this.props.inputPrefix}[hero_visible]"
    inputTitleName    = "#{this.props.inputPrefix}[hero_title]"
    inputTextName     = "#{this.props.inputPrefix}[hero_text]"
    inputButtonName   = "#{this.props.inputPrefix}[hero_button]"
    stylePickerColor = switch this.state.style
      when 'dark' then '#222'
      else '#EEE'

    `<div>
      <input type="hidden" name={inputTypeName} value={this.state.type} />
      <input type="hidden" name={inputVisibleName} value={this.state.visible} />
      <input type="hidden" name={inputTitleName} value={this.state.title} />
      <input type="hidden" name={inputTextName} value={this.state.text} />
      <input type="hidden" name={inputButtonName} value={this.state.button} />
      <div className="container">
        <div className="row theme-banner">
          <div className="col-sm-6">
            <h2 className="h4">
              Hero
              <span className="small" style={{marginLeft: 8}}>
                <em>Option {ThemeHeroDesignerTypes.indexOf(this.state.type) + 1} of {ThemeHeroDesignerTypes.length}</em> – {this.renderLabel()}
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
            <span ref="stylePicker" className="btn-group btn-group-sm theme-picker" title="Select a Hero Theme" data-toggle="popover" data-content={this.renderStylePicker()}>
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
        when 'fullImage'              then `<ThemeHeroFullImageDesigner               {...this.state} changeTitle={this.changeTitle} changeText={this.changeText} changeButton={this.changeButton} />`
        when 'fullImageRight'         then `<ThemeHeroFullImageRightDesigner          {...this.state} changeTitle={this.changeTitle} changeText={this.changeText} changeButton={this.changeButton} />`
        when 'fullImageRightWell'     then `<ThemeHeroFullImageRightWellDesigner      {...this.state} changeTitle={this.changeTitle} changeText={this.changeText} changeButton={this.changeButton} />`
        when 'fullImageRightWellDark' then `<ThemeHeroFullImageRightWellDarkDesigner  {...this.state} changeTitle={this.changeTitle} changeText={this.changeText} changeButton={this.changeButton} />`
        when 'fullImageRightForm'     then `<ThemeHeroFullImageRightFormDesigner      {...this.state} changeTitle={this.changeTitle} changeText={this.changeText} changeButton={this.changeButton} />`
        when 'splitImage'             then `<ThemeHeroSplitImageDesigner              {...this.state} changeTitle={this.changeTitle} changeText={this.changeText} changeButton={this.changeButton} />`
        when 'splitVideo'             then `<ThemeHeroSplitVideoDesigner              {...this.state} changeTitle={this.changeTitle} changeText={this.changeText} changeButton={this.changeButton} />`

  renderLabel: ->
    switch this.state.type
      when 'fullImage'              then 'Full Image'
      when 'fullImageRight'         then 'Full Image Right-Aligned'
      when 'fullImageRightWell'     then 'Full Image Right-Aligned Well'
      when 'fullImageRightWellDark' then 'Full Image Right-Aligned Dark Well'
      when 'fullImageRightForm'     then 'Full Image Right-Aligned Form'
      when 'splitImage'             then 'Split Image'
      when 'splitVideo'             then 'Split Video'

  renderStylePicker: ->
    switch this.state.style
      when 'dark'
        '<select class="form-control"><option value="dark selected">Dark</option><option value="light">Light</option></select>'
      else
        '<select class="form-control"><option value="dark">Dark</option><option value="light" selected>Light</option></select>'

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

  changeTitle: (e) ->
    this.setState title: if e.target.value then e.target.value else e.target.innerHTML

  changeText: (e) ->
    this.setState text: if e.target.value then e.target.value else e.target.innerHTML

  changeBackground: (url) ->
    this.setState background: url

  changeButton: (e) ->
    this.setState button: if e.target.value then e.target.value else e.target.innerHTML

  toggleBackgroundPicker: ->
    if this.state.backgroundPickerVisible
      this.setState backgroundPickerVisible: false
    else
      this.setState backgroundPickerVisible: true, this.repositionBackgroundPopover

  toggleVisible: ->
    this.setState visible: !this.state.visible

  prev: ->
    index = ThemeHeroDesignerTypes.indexOf(this.state.type)
    if index is -1 or index is 0
      this.setState type: ThemeHeroDesignerTypes[ThemeHeroDesignerTypes.length - 1]
    else
      this.setState type: ThemeHeroDesignerTypes[index - 1]

  next: ->
    index = ThemeHeroDesignerTypes.indexOf(this.state.type)
    if index is -1 or index is ThemeHeroDesignerTypes.length - 1
      this.setState type: ThemeHeroDesignerTypes[0]
    else
      this.setState type: ThemeHeroDesignerTypes[index + 1]

window.ThemeHeroDesigner = ThemeHeroDesigner
