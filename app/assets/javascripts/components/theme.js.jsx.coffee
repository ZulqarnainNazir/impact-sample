Theme = React.createClass
  propTypes:
    browserButtonsSrc: React.PropTypes.string.isRequired
    defaultFooterBlockAttributes: React.PropTypes.object
    defaultHeaderBlockAttributes: React.PropTypes.object
    initialFooterBlock: React.PropTypes.object
    initialHeaderBlock: React.PropTypes.object

  getInitialState: ->
    background_color: this.props.defaultBackgroundColor || ''
    editing: true
    footerBlock: this.footerBlockInitial()
    foreground_color: this.props.defaultForegroundColor || ''
    headerBlock: this.headerBlockInitial()
    link_color: this.props.defaultLinkColor || ''
    wrap_container: if this.props.defaultWrapContainer is 'true' then true else false
    logo: false

  componentDidMount: ->
    this.setupMinicolors()
    if $(this.getDOMNode()).find('.webpage-header img').length > 0
      this.setState logo: true

  setupMinicolors: ->
    minicolorOptions =
      change: this.setColorStates
      control: 'wheel'
      theme: 'block'
    $('#background_color').minicolors $.extend(minicolorOptions, defaultValue: this.state.background_color)
    $('#foreground_color').minicolors $.extend(minicolorOptions, defaultValue: this.state.foreground_color)
    $('#link_color').minicolors $.extend(minicolorOptions, defaultValue: this.state.link_color)
    $('#' + this.headerBlockID('background_color')).minicolors $.extend(minicolorOptions, defaultValue: this.state.headerBlock && this.state.headerBlock.background_color || '')
    $('#' + this.headerBlockID('foreground_color')).minicolors $.extend(minicolorOptions, defaultValue: this.state.headerBlock && this.state.headerBlock.foreground_color || '')
    $('#' + this.headerBlockID('link_color')).minicolors $.extend(minicolorOptions, defaultValue: this.state.headerBlock && this.state.headerBlock.link_color || '')
    $('#' + this.footerBlockID('background_color')).minicolors $.extend(minicolorOptions, defaultValue: this.state.footerBlock && this.state.footerBlock.background_color || '')
    $('#' + this.footerBlockID('foreground_color')).minicolors $.extend(minicolorOptions, defaultValue: this.state.footerBlock && this.state.footerBlock.foreground_color || '')
    $('#' + this.footerBlockID('link_color')).minicolors $.extend(minicolorOptions, defaultValue: this.state.footerBlock && this.state.footerBlock.link_color || '')

  resetColors: ->
    $('#background_color').val(this.props.defaultBackgroundColor || '').minicolors('destroy')
    $('#foreground_color').val(this.props.defaultForegroundColor || '').minicolors('destroy')
    $('#link_color').val(this.props.defaultLinkColor || '').minicolors('destroy')
    $('#' + this.headerBlockID('background_color')).val(this.props.initialHeaderBlock && this.props.initialHeaderBlock.background_color || '').minicolors('destroy')
    $('#' + this.headerBlockID('foreground_color')).val(this.props.initialHeaderBlock && this.props.initialHeaderBlock.foreground_color || '').minicolors('destroy')
    $('#' + this.headerBlockID('link_color')).val(this.props.initialHeaderBlock && this.props.initialHeaderBlock.link_color || '').minicolors('destroy')
    $('#' + this.footerBlockID('background_color')).val(this.props.initialFooterBlock && this.props.initialFooterBlock.background_color || '').minicolors('destroy')
    $('#' + this.footerBlockID('foreground_color')).val(this.props.initialFooterBlock && this.props.initialFooterBlock.foreground_color || '').minicolors('destroy')
    $('#' + this.footerBlockID('link_color')).val(this.props.initialFooterBlock && this.props.initialFooterBlock.link_color || '').minicolors('destroy')
    changes =
      background_color:
        $set: this.props.defaultBackgroundColor || ''
      foreground_color:
        $set: this.props.defaultForegroundColor || ''
      link_color:
        $set: this.props.defaultLinkColor || ''
      headerBlock:
        $merge:
          background_color: this.props.initialHeaderBlock && this.props.initialHeaderBlock.background_color || ''
          foreground_color: this.props.initialHeaderBlock && this.props.initialHeaderBlock.foreground_color || ''
          link_color: this.props.initialHeaderBlock && this.props.initialHeaderBlock.link_color || ''
      footerBlock:
        $merge:
          background_color: this.props.initialFooterBlock && this.props.initialFooterBlock.background_color || ''
          foreground_color: this.props.initialFooterBlock && this.props.initialFooterBlock.foreground_color || ''
          link_color: this.props.initialFooterBlock && this.props.initialFooterBlock.link_color || ''
    this.setState React.addons.update(this.state, changes), this.setupMinicolors

  setColorStates: ->
    this.setState React.addons.update this.state,
      background_color:
        $set: $('#background_color').val()
      foreground_color:
        $set: $('#foreground_color').val()
      link_color:
        $set: $('#link_color').val()
      headerBlock:
        $merge:
          background_color: $('#' + this.headerBlockID('background_color')).val()
          foreground_color: $('#' + this.headerBlockID('foreground_color')).val()
          link_color: $('#' + this.headerBlockID('link_color')).val()
      footerBlock:
        $merge:
          background_color: $('#' + this.footerBlockID('background_color')).val()
          foreground_color: $('#' + this.footerBlockID('foreground_color')).val()
          link_color: $('#' + this.footerBlockID('link_color')).val()

  loadColors: ->
    image = new Image
    image.crossOrigin = 'Anonymous'
    image.src = $('.webpage-header img').attr('src')
    $(image).load this.loadImageColors.bind(null, image)

  colorToHex: (color) ->
    this.rgbToHex(color[0], color[1], color[2])

  rgbToHex: (r, g, b) ->
    "#" + ((1 << 24) + (r << 16) + (g << 8) + b).toString(16).slice(1)

  loadImageColors: (image) ->
    canvas = document.createElement('canvas')
    canvas.width = image.width
    canvas.height = image.height
    context = canvas.getContext('2d')
    context.drawImage(image, 0, 0)
    thief = new ColorThief()
    colors = thief.getPalette(image, 6).map this.colorToHex
    $('#background_color').val(colors[0]).minicolors('destroy')
    $('#foreground_color').val(colors[1]).minicolors('destroy')
    $('#link_color').val('').minicolors('destroy')
    $('#' + this.headerBlockID('background_color')).val(colors[2]).minicolors('destroy')
    $('#' + this.headerBlockID('foreground_color')).val(colors[3]).minicolors('destroy')
    $('#' + this.headerBlockID('link_color')).val(colors[3]).minicolors('destroy')
    $('#' + this.footerBlockID('background_color')).val(colors[2]).minicolors('destroy')
    $('#' + this.footerBlockID('foreground_color')).val(colors[3]).minicolors('destroy')
    $('#' + this.footerBlockID('link_color')).val(colors[3]).minicolors('destroy')
    changes =
      background_color:
        $set: colors[0]
      foreground_color:
        $set: colors[1]
      link_color:
        $set: ''
      headerBlock:
        $merge:
          background_color: colors[2]
          foreground_color: colors[3]
          link_color: colors[3]
      footerBlock:
        $merge:
          background_color: colors[2]
          foreground_color: colors[3]
          link_color: colors[3]
    this.setState React.addons.update(this.state, changes), this.setupMinicolors

  toggleEditing: ->
    this.setState editing: !this.state.editing

  toggleContainerWrapper: ->
    this.setState wrap_container: !this.state.wrap_container

   styles: ->
     """
     .webpage-container a {
       color: #{this.state.link_color};
     }
     .webpage-footer .site-footer-simple {
       color: #{this.state.foreground_color};
     }
     .webpage-footer .site-footer-simple a {
       color: #{this.state.link_color};
     }
     .webpage-header .navbar {
       background-color: #{this.state.headerBlock.background_color};
       color: #{this.state.headerBlock.foreground_color};
     }
     .webpage-header .navbar a,
     .webpage-header .navbar a:hover {
       color: #{this.state.headerBlock.link_color} !important;
     }
     .webpage-footer .site-footer-columns .site-footer-upper,
     .webpage-footer .site-footer-layers {
       background-color: #{this.state.footerBlock.background_color};
       color: #{this.state.footerBlock.foreground_color};
     }
     .webpage-footer .site-footer-columns .site-footer-upper a,
     .webpage-footer .site-footer-columns .site-footer-upper a:hover,
     .webpage-footer .site-footer-layers a,
     .webpage-footer .site-footer-layers a:hover {
       color: #{this.state.footerBlock.link_color} !important;
     }
     """

  render: ->
    `<div>
      <style dangerouslySetInnerHTML={{__html: this.styles()}} />
      <div className="row webpage-fields">
        <input name="wrap_container" type="hidden" value={this.state.wrap_container} />
        <div className="col-sm-4">
          <p>Body Colors</p>
          <div className="well well-sm">
            <div className="row row-narrow">
              <div className="col-sm-4">
                <div className="form-group">
                  <label htmlFor="background_color" className="contor-label small">Background</label>
                  <input name="background_color" id="background_color" type="text" defaultValue={this.state.background_color} className="form-control" />
                </div>
              </div>
              <div className="col-sm-4">
                <div className="form-group">
                  <label htmlFor="foreground_color" className="contor-label small">Font</label>
                  <input name="foreground_color" id="foreground_color" type="text" defaultValue={this.state.foreground_color} className="form-control" />
                </div>
              </div>
              <div className="col-sm-4">
                <div className="form-group">
                  <label htmlFor="link_color" className="contor-label small">Link</label>
                  <input name="link_color" id="link_color" type="text" defaultValue={this.state.link_color} className="form-control" />
                </div>
              </div>
            </div>
          </div>
        </div>
        <div className="col-sm-4">
          <p>Header Colors</p>
          <div className="well well-sm">
            <div className="row row-narrow">
              <div className="col-sm-4">
                <div className="form-group">
                  <label htmlFor={this.headerBlockName('background_color')} className="contor-label small">Background</label>
                  <input name={this.headerBlockName('background_color')} id={this.headerBlockID('background_color')} type="text" defaultValue={this.state.headerBlock.background_color} className="form-control" />
                </div>
              </div>
              <div className="col-sm-4">
                <div className="form-group">
                  <label htmlFor={this.headerBlockName('foreground_color')} className="contor-label small">Font</label>
                  <input name={this.headerBlockName('foreground_color')} id={this.headerBlockID('foreground_color')} type="text" defaultValue={this.state.headerBlock.foreground_color} className="form-control" />
                </div>
              </div>
              <div className="col-sm-4">
                <div className="form-group">
                  <label htmlFor={this.headerBlockName('link_color')} className="contor-label small">Link</label>
                  <input name={this.headerBlockName('link_color')} id={this.headerBlockID('link_color')} type="text" defaultValue={this.state.headerBlock.link_color} className="form-control" />
                </div>
              </div>
            </div>
          </div>
        </div>
        <div className="col-sm-4">
          <p>Footer Colors</p>
          <div className="well well-sm">
            <div className="row row-narrow">
              <div className="col-sm-4">
                <div className="form-group">
                  <label htmlFor={this.footerBlockName('background_color')} className="contor-label small">Background</label>
                  <input name={this.footerBlockName('background_color')} id={this.footerBlockID('background_color')} type="text" defaultValue={this.state.footerBlock.background_color} className="form-control" />
                </div>
              </div>
              <div className="col-sm-4">
                <div className="form-group">
                  <label htmlFor={this.footerBlockName('foreground_color')} className="contor-label small">Font</label>
                  <input name={this.footerBlockName('foreground_color')} id={this.footerBlockID('foreground_color')} type="text" defaultValue={this.state.footerBlock.foreground_color} className="form-control" />
                </div>
              </div>
              <div className="col-sm-4">
                <div className="form-group">
                  <label htmlFor={this.footerBlockName('link_color')} className="contor-label small">Link</label>
                  <input name={this.footerBlockName('link_color')} id={this.footerBlockID('link_color')} type="text" defaultValue={this.state.footerBlock.link_color} className="form-control" />
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div className="text-center text-muted" style={{marginBottom: 20}}>
        <div className="btn-group btn-group-sm" style={{display: 'inline-block', margin: 0}}>
          {this.renderLoadColorsButton()}
          <span onClick={this.resetColors} className="btn btn-default">Reset</span>
        </div>
        <small style={{marginLeft: 20}}>Note: Footer colors apply only within darker banners; not found on all styles.</small>
      </div>
      <BrowserPanel browserButtonsSrc={this.props.browserButtonsSrc} toggleEditing={this.toggleEditing} editing={this.state.editing}>
        <div style={{position: 'relative', backgroundColor: this.state.background_color, color: this.state.foreground_color}}>
          <HeaderBlock {...this.headerBlockProps()} />
          <div className="text-center" style={{backgroundColor: 'rgba(0,0,0,0.1)', padding: '4em 2em', position: 'relative'}}>
            <span style={{fontSize: 30}}>Full-width Content</span>
          </div>
          <div className="webpage-wrapper">
            <div className={this.webpageContainerClass()} style={{width: '90% !important'}}>
              <div className="webpage-group webpage-group-basic webpage-group-basic-left">
                <div className="webpage-block text-center" style={{backgroundColor: 'rgba(0,0,0,0.1)', borderRadius: 5, padding: '6em 2em'}}>
                  <span style={{fontSize: 30}}>Main Content – <a href="#">Example Link</a></span>
                </div>
              </div>
              <div className="webpage-group webpage-group-sidebar webpage-group-sidebar-right">
                <div className="webpage-block text-center" style={{backgroundColor: 'rgba(0,0,0,0.1)', borderRadius: 5, padding: '4em 2em'}}>
                  <span style={{fontSize: 20}}>Sidebar Content</span>
                </div>
              </div>
              <div className="webpage-group webpage-group-basic webpage-group-basic-left">
                <div className="webpage-block text-center" style={{backgroundColor: 'rgba(0,0,0,0.1)', borderRadius: 5, padding: '6em 2em'}}>
                  <span style={{fontSize: 20}}>Main Content – <a href="#">Example Link</a></span>
                </div>
              </div>
            </div>
          </div>
          <FooterBlock {...this.footerBlockProps()} />
          <div className="webpage-fields">
            {this.headerBlockInputs()}
            {this.footerBlockInputs()}
          </div>
        </div>
        <div className="panel-footer clearfix">
          <p className="checkbox pull-right" style={{margin: 0}}>
            <label>
              <input type="checkbox" checked={this.state.wrap_container} onChange={this.toggleContainerWrapper} />
              Wrap Interior Contents?
            </label>
          </p>
        </div>
      </BrowserPanel>
    </div>`

  webpageContainerClass: ->
    if this.state.wrap_container
      'webpage-container webpage-container-wrapper container'
    else
      'webpage-container container'

  renderLoadColorsButton: ->
    if this.state.logo
      `<span onClick={this.loadColors} className="btn btn-default">Load Colors from Logo Image</span>`

  prevItem: (items, currentItem) ->
    index = items.indexOf(currentItem)

    if index <= 0
      items[items.length - 1]
    else
      items[index - 1]

  nextItem: (items, currentItem) ->
    index = items.indexOf(currentItem)

    if index >= items.length - 1
      items[0]
    else if index < 0
      items[1]
    else
      items[index + 1]

  ## HEADER MIXINS
  headerBlockInputs: ->
    if this.props.initialHeaderBlock and this.state.headerBlock
      `<input key={this.headerBlockName('id')} type="hidden" name={this.headerBlockName('id')} value={this.props.initialHeaderBlock.id} />`
    else if this.props.initialHeaderBlock
      `<div>
        <input key={this.headerBlockName('id')} type="hidden" name={this.headerBlockName('id')} value={this.props.initialHeaderBlock.id} />
        <input key={this.headerBlockName('_destroy')} type="hidden" name={this.headerBlockName('_destroy')} value="1" />
      </div>`
    else
      `<div />`

  headerBlockProps: ->
    if this.state.headerBlock
      block: $.extend({}, this.state.headerBlock, { editing: this.state.editing })
      blockEditor: this.headerBlockEditorProps()
      blockInputStyle: this.headerBlockInputStyleProps()
      blockInputNumber: this.headerBlockInputNumberProps()
      blockOptions: this.headerBlockOptionsProps()
      editing: this.state.editing
      name: this.headerBlockName
      theme: this.headerBlockThemeName(this.state.headerBlock.theme)
    else
      blockAdd: this.headerBlockAddProps()
      editing: this.state.editing

  # PRIVATE LEVEL 1

  headerBlockInitial: ->
    if this.props.initialHeaderBlock
      $.extend {}, this.headerBlockDefaultProps(), this.props.initialHeaderBlock

  headerBlockID: (name) ->
    "header-block-attributes-#{name}"

  headerBlockName: (name) ->
    "header_block_attributes[#{name}]"

  headerBlockThemeName: (theme) ->
    switch theme
      when 'center' then 'Center'
      when 'justify' then 'Justify'
      when 'logo_above' then 'Logo Above'
      when 'logo_above_full_width' then 'Logo Above Full Width'
      when 'logo_below' then 'Logo Below'
      when 'logo_center' then 'Logo Center'
      else 'Inline'

  headerBlockAddProps: ->
    visible: !this.state.headerBlock
    onClick: this.headerBlockAdd
    content: 'Add a Header Block'

  headerBlockEditorProps: ->
    id: 'header-block-editor'
    title: 'Edit Header Block Details'
    swapForm: this.headerBlockSwapForm
    resetForm: this.headerBlockResetForm

  headerBlockInputStyleProps: ->
    id: this.headerBlockID('style')
    name: this.headerBlockName('style')
    value: this.state.headerBlock.style
    label: 'Navbar Style'
    options: [
      { value: 'light', label: 'Light', },
      { value: 'dark', label: 'Dark', },
    ]

  headerBlockInputNumberProps: ->
    id: this.headerBlockID('logo_height')
    name: this.headerBlockName('logo_height')
    value: this.state.headerBlock.logo_height
    label: 'Custom Logo Height (Pixels)'

  headerBlockOptionsProps: ->
    visible: this.state.editing
    prev: this.headerBlockPrevTheme
    next: this.headerBlockNextTheme
    editorTarget: '#header-block-editor'
    editLabel: 'Edit Details'
    onEdit: this.headerBlockEdit

  # PRIVATE LEVEL 2

  headerBlockDefaultProps: ->
    style: 'dark'

  headerBlockAdd: (event, callback) ->
    event.preventDefault() if event
    this.headerBlockSave $set: $.extend({}, this.headerBlockDefaultProps(), (this.props.defaultHeaderBlockAttributes or {})), callback

  headerBlockEdit: ->

  headerBlockUpdate: (attributes, event, callback) ->
    event.preventDefault() if event
    this.headerBlockSave $merge: attributes, callback

  headerBlockSwapForm: () ->
    this.headerBlockUpdate
      style: this.headerBlockInputGetVal('style')
      logo_height: this.headerBlockInputGetVal('logo_height')

  headerBlockResetForm: () ->
    this.headerBlockInputSetVal 'style', this.state.headerBlock.style
    this.headerBlockInputSetVal 'logo_height', this.state.headerBlock.logo_height

  headerBlockPrevTheme: ->
    this.headerBlockUpdate theme: this.prevItem(this.headerBlockThemes, this.state.headerBlock.theme)

  headerBlockNextTheme: ->
    this.headerBlockUpdate theme: this.nextItem(this.headerBlockThemes, this.state.headerBlock.theme)

  # PRIVATE LEVEL 3

  headerBlockSave: (changes, callback) ->
    updated = React.addons.update(this.state, headerBlock: changes)
    if typeof(callback) is 'function'
      this.setState updated, callback
    else
      this.setState updated

  headerBlockInputGetVal: (name) ->
    $('#' + this.headerBlockID(name)).val()

  headerBlockInputSetVal: (name, value) ->
    $('#' + this.headerBlockID(name)).val(value)

  headerBlockThemes: ['inline', 'center', 'justify', 'logo_above', 'logo_above_full_width', 'logo_below', 'logo_center']

  ## FOOTER MIXINS
  footerBlockInputs: ->
    if this.props.initialFooterBlock and this.state.footerBlock
      `<input key={this.footerBlockName('id')} type="hidden" name={this.footerBlockName('id')} value={this.props.initialFooterBlock.id} />`
    else if this.props.initialFooterBlock
      `<div>
        <input key={this.footerBlockName('id')} type="hidden" name={this.footerBlockName('id')} value={this.props.initialFooterBlock.id} />
        <input key={this.footerBlockName('_destroy')} type="hidden" name={this.footerBlockName('_destroy')} value="1" />
      </div>`
    else
      `<div />`

  footerBlockProps: ->
    if this.state.footerBlock
      block: $.extend({}, this.state.footerBlock, { editing: this.state.editing })
      blockOptions: this.footerBlockOptionsProps()
      name: this.footerBlockName

  # PRIVATE LEVEL 1

  footerBlockInitial: ->
    if this.props.initialFooterBlock
      $.extend {}, this.footerBlockDefaultProps(), this.props.initialFooterBlock

  footerBlockID: (name) ->
    "footer-block-attributes-#{name}"

  footerBlockName: (name) ->
    "footer_block_attributes[#{name}]"

  footerBlockOptionsProps: ->
    visible: this.state.editing
    prev: this.footerBlockPrevTheme
    next: this.footerBlockNextTheme
    editorTarget: '#footer-block-editor'
    editLabel: 'Edit Details'
    removeLabel: 'Remove Footer Block'

  # PRIVATE LEVEL 2

  footerBlockDefaultProps: ->
    {}

  footerBlockUpdate: (attributes, event, callback) ->
    event.preventDefault() if event
    this.footerBlockSave $merge: attributes, callback

  footerBlockPrevTheme: ->
    this.footerBlockUpdate theme: this.prevItem(this.footerBlockThemes, this.state.footerBlock.theme)

  footerBlockNextTheme: ->
    this.footerBlockUpdate theme: this.nextItem(this.footerBlockThemes, this.state.footerBlock.theme)

  # PRIVATE LEVEL 3

  footerBlockSave: (changes, callback) ->
    updated = React.addons.update(this.state, footerBlock: changes)
    if typeof(callback) is 'function'
      this.setState updated, callback
    else
      this.setState updated

  footerBlockThemes: ['simple', 'simple_full_width', 'columns', 'layers']

window.Theme = Theme
