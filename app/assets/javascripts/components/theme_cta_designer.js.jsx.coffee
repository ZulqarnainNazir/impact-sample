ThemeCtaDesignerTypes = ['simple']

ThemeCtaDesigner = React.createClass
  propTypes:
    visible: React.PropTypes.bool
    type: React.PropTypes.oneOf ThemeCtaDesignerTypes
    inputPrefix: React.PropTypes.string

  getInitialState: ->
    typeIndex = ThemeCtaDesignerTypes.indexOf(this.props.type)
    type: if typeIndex is -1 then ThemeCtaDesignerTypes[0] else this.props.type
    visible: this.props.visible
    background_01: this.props.background_01
    background_02: this.props.background_02
    background_03: this.props.background_03
    button_01: if this.props.button_01 and this.props.button_01.length > 0 then this.props.button_01 else 'Button'
    text_01: if this.props.text_01 and this.props.text_01.length > 0 then this.props.text_01 else 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas condimentum tellus sed enim.'
    title_01: if this.props.title_01 and this.props.title_01.length > 0 then this.props.title_01 else 'Title'
    button_02: if this.props.button_02 and this.props.button_02.length > 0 then this.props.button_02 else 'Button'
    text_02: if this.props.text_02 and this.props.text_02.length > 0 then this.props.text_02 else 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas condimentum tellus sed enim.'
    title_02: if this.props.title_02 and this.props.title_02.length > 0 then this.props.title_02 else 'Title'
    button_03: if this.props.button_03 and this.props.button_03.length > 0 then this.props.button_03 else 'Button'
    text_03: if this.props.text_03 and this.props.text_03.length > 0 then this.props.text_03 else 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas condimentum tellus sed enim.'
    title_03: if this.props.title_03 and this.props.title_03.length > 0 then this.props.title_03 else 'Title'
    backgroundPickerVisible01: false
    backgroundPickerVisible02: false
    backgroundPickerVisible03: false

  componentDidMount: ->
    if this.refs.element
      $(this.refs.element.getDOMNode()).click '*', (e) -> e.preventDefault()

  render: ->
    if this.props.inputPrefix
      this.renderWithOptions()
    else
      this.renderElement()

  renderWithOptions: ->
    inputTypeName       = "#{this.props.inputPrefix}[cta_theme]"
    inputVisibleName    = "#{this.props.inputPrefix}[cta_visible]"
    inputTitle01Name    = "#{this.props.inputPrefix}[cta_title_01]"
    inputText01Name     = "#{this.props.inputPrefix}[cta_text_01]"
    inputButton01Name   = "#{this.props.inputPrefix}[cta_button_01]"
    inputTitle02Name    = "#{this.props.inputPrefix}[cta_title_02]"
    inputText02Name     = "#{this.props.inputPrefix}[cta_text_02]"
    inputButton02Name   = "#{this.props.inputPrefix}[cta_button_02]"
    inputTitle03Name    = "#{this.props.inputPrefix}[cta_title_03]"
    inputText03Name     = "#{this.props.inputPrefix}[cta_text_03]"
    inputButton03Name   = "#{this.props.inputPrefix}[cta_button_03]"

    `<div>
      <input type="hidden" name={inputTypeName} value={this.state.type} />
      <input type="hidden" name={inputVisibleName} value={this.state.visible} />
      <input type="hidden" name={inputTitle01Name} value={this.state.title_01} />
      <input type="hidden" name={inputText01Name} value={this.state.text_01} />
      <input type="hidden" name={inputButton01Name} value={this.state.button_01} />
      <input type="hidden" name={inputTitle02Name} value={this.state.title_02} />
      <input type="hidden" name={inputText02Name} value={this.state.text_02} />
      <input type="hidden" name={inputButton02Name} value={this.state.button_02} />
      <input type="hidden" name={inputTitle03Name} value={this.state.title_03} />
      <input type="hidden" name={inputText03Name} value={this.state.text_03} />
      <input type="hidden" name={inputButton03Name} value={this.state.button_03} />
      <div className="container">
        <div className="row theme-banner">
          <div className="col-sm-6">
            <h2 className="h4">
              Call To Action
              <span className="small" style={{marginLeft: 8}}>
                <em>Option {ThemeCtaDesignerTypes.indexOf(this.state.type) + 1} of {ThemeCtaDesignerTypes.length}</em> – {this.renderLabel()}
              </span>
            </h2>
          </div>
          <div className="col-sm-6">
            <div className="checkbox">
              <label><input type="checkbox" checked={!this.state.visible} onChange={this.toggleVisible} /> Hide Element</label>
            </div>
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
        when 'simple' then `<ThemeCtaSimpleDesigner {...this.state} changeTitle01={this.changeTitle01} changeText01={this.changeText01} changeButton01={this.changeButton01} changeTitle02={this.changeTitle02} changeText02={this.changeText02} changeButton02={this.changeButton02} changeTitle03={this.changeTitle03} changeText03={this.changeText03} changeButton03={this.changeButton03} />`

  renderLabel: ->
    switch this.state.type
      when 'simple' then 'Basic'

  renderBackgroundPicker01: ->
    if this.state.backgroundPickerVisible01
      `<div ref="backgroundPopover01" className="popover theme-popover top fade in" style={{display: 'block', maxWidth: 500}}>
        <div className="arrow" style={{left: '50%'}}></div>
        <div className="popover-title">Select Background #1</div>
        <div className="popover-content">
          {this.renderImagePlacementFields01()}
        </div>
      </div>`

  renderBackgroundPicker02: ->
    if this.state.backgroundPickerVisible02
      `<div ref="backgroundPopover02" className="popover theme-popover top fade in" style={{display: 'block', maxWidth: 500}}>
        <div className="arrow" style={{left: '50%'}}></div>
        <div className="popover-title">Select Background #2</div>
        <div className="popover-content">
          {this.renderImagePlacementFields02()}
        </div>
      </div>`

  renderBackgroundPicker03: ->
    if this.state.backgroundPickerVisible03
      `<div ref="backgroundPopover03" className="popover theme-popover top fade in" style={{display: 'block', maxWidth: 500}}>
        <div className="arrow" style={{left: '50%'}}></div>
        <div className="popover-title">Select Background #3</div>
        <div className="popover-content">
          {this.renderImagePlacementFields03()}
        </div>
      </div>`

  renderImagePlacementFields01: ->
    `<ImagePlacementFields {...this.props.background_01_image_fields} imageReceivers={[this.changeBackground01]} />`

  renderImagePlacementFields02: ->
    `<ImagePlacementFields {...this.props.background_02_image_fields} imageReceivers={[this.changeBackground02]} />`

  renderImagePlacementFields03: ->
    `<ImagePlacementFields {...this.props.background_03_image_fields} imageReceivers={[this.changeBackground03]} />`

  repositionBackgroundPopover: (pickerRef, popoverRef) ->
    if pickerRef and popoverRef
      frame = $(pickerRef.getDOMNode()).closest('.page-frame')
      picker = $(pickerRef.getDOMNode())
      popover = $(popoverRef.getDOMNode())

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

  changeTitle01: (e) ->
    this.setState title_01: if e.target.value then e.target.value else e.target.innerHTML

  changeText01: (e) ->
    this.setState text_01: if e.target.value then e.target.value else e.target.innerHTML

  changeBackground01: (url) ->
    this.setState background_01: url

  changeButton01: (e) ->
    this.setState button_01: if e.target.value then e.target.value else e.target.innerHTML

  changeTitle02: (e) ->
    this.setState title_02: if e.target.value then e.target.value else e.target.innerHTML

  changeText02: (e) ->
    this.setState text_02: if e.target.value then e.target.value else e.target.innerHTML

  changeBackground02: (url) ->
    this.setState background_02: url

  changeButton02: (e) ->
    this.setState button_02: if e.target.value then e.target.value else e.target.innerHTML

  changeTitle03: (e) ->
    this.setState title_03: if e.target.value then e.target.value else e.target.innerHTML

  changeText03: (e) ->
    this.setState text_03: if e.target.value then e.target.value else e.target.innerHTML

  changeBackground03: (url) ->
    this.setState background_03: url

  changeButton03: (e) ->
    this.setState button_03: if e.target.value then e.target.value else e.target.innerHTML

  toggleBackgroundPicker01: ->
    if this.state.backgroundPickerVisible01
      this.setState backgroundPickerVisible01: false
    else
      this.setState backgroundPickerVisible01: true, this.repositionBackgroundPopover(this.refs.backgroundPicker01, this.refs.backgroundPopover01)

  toggleBackgroundPicker02: ->
    if this.state.backgroundPickerVisible02
      this.setState backgroundPickerVisible02: false
    else
      this.setState backgroundPickerVisible02: true, this.repositionBackgroundPopover(this.refs.backgroundPicker02, this.refs.backgroundPopover02)

  toggleBackgroundPicker03: ->
    if this.state.backgroundPickerVisible03
      this.setState backgroundPickerVisible03: false
    else
      this.setState backgroundPickerVisible03: true, this.repositionBackgroundPopover(this.refs.backgroundPicker03, this.refs.backgroundPopover03)

  toggleVisible: ->
    this.setState visible: !this.state.visible

  prev: ->
    index = ThemeCtaDesignerTypes.indexOf(this.state.type)
    if index is -1 or index is 0
      this.setState type: ThemeCtaDesignerTypes[ThemeCtaDesignerTypes.length - 1]
    else
      this.setState type: ThemeCtaDesignerTypes[index - 1]

  next: ->
    index = ThemeCtaDesignerTypes.indexOf(this.state.type)
    if index is -1 or index is ThemeCtaDesignerTypes.length - 1
      this.setState type: ThemeCtaDesignerTypes[0]
    else
      this.setState type: ThemeCtaDesignerTypes[index + 1]

window.ThemeCtaDesigner = ThemeCtaDesigner
