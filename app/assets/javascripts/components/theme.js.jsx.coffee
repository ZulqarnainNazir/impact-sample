Theme = React.createClass
  propTypes:
    browserButtonsSrc: React.PropTypes.string.isRequired
    initialHeaderBlock: React.PropTypes.object.isRequired
    initialFooterBlock: React.PropTypes.object.isRequired
    defaultWrapContainer: React.PropTypes.string
    defaultBackgroundColor: React.PropTypes.string
    defaultForegroundColor: React.PropTypes.string
    defaultLinkColor: React.PropTypes.string

  getInitialState: ->
    wrapContainer: if this.props.defaultWrapContainer is 'true' then true else false
    background_color: this.props.defaultBackgroundColor || ''
    foreground_color: this.props.defaultForegroundColor || ''
    link_color: this.props.defaultLinkColor || ''
    headerBlock: this.props.initialHeaderBlock
    footerBlock: this.props.initialFooterBlock
    editing: true
    logo: !!this.props.initialHeaderBlock.logoSmall

  componentDidMount: ->
    this.setupMinicolors()
    $(document).on 'click', '.logo-size-picker', (e) ->
      e.preventDefault()
      $(e.target).closest('.logo-size').find('input[type="radio"]').prop('checked', true)

  setupMinicolors: ->
    minicolorOptions =
      change: this.setColorStates
      control: 'wheel'
      theme: 'block'
    $('#background_color').minicolors $.extend(minicolorOptions, defaultValue: this.state.background_color)
    $('#foreground_color').minicolors $.extend(minicolorOptions, defaultValue: this.state.foreground_color)
    $('#link_color').minicolors $.extend(minicolorOptions, defaultValue: this.state.link_color)
    $('#header_block_attributes_background_color').minicolors $.extend(minicolorOptions, defaultValue: this.state.headerBlock && this.state.headerBlock.background_color || '')
    $('#header_block_attributes_foreground_color').minicolors $.extend(minicolorOptions, defaultValue: this.state.headerBlock && this.state.headerBlock.foreground_color || '')
    $('#header_block_attributes_link_color').minicolors $.extend(minicolorOptions, defaultValue: this.state.headerBlock && this.state.headerBlock.link_color || '')
    $('#footer_block_attributes_background_color').minicolors $.extend(minicolorOptions, defaultValue: this.state.footerBlock && this.state.footerBlock.background_color || '')
    $('#footer_block_attributes_foreground_color').minicolors $.extend(minicolorOptions, defaultValue: this.state.footerBlock && this.state.footerBlock.foreground_color || '')
    $('#footer_block_attributes_link_color').minicolors $.extend(minicolorOptions, defaultValue: this.state.footerBlock && this.state.footerBlock.link_color || '')

  resetColors: ->
    $('#background_color').val(this.props.defaultBackgroundColor || '').minicolors('destroy')
    $('#foreground_color').val(this.props.defaultForegroundColor || '').minicolors('destroy')
    $('#link_color').val(this.props.defaultLinkColor || '').minicolors('destroy')
    $('#header_block_attributes_background_color').val(this.props.initialHeaderBlock && this.props.initialHeaderBlock.background_color || '').minicolors('destroy')
    $('#header_block_attributes_foreground_color').val(this.props.initialHeaderBlock && this.props.initialHeaderBlock.foreground_color || '').minicolors('destroy')
    $('#header_block_attributes_link_color').val(this.props.initialHeaderBlock && this.props.initialHeaderBlock.link_color || '').minicolors('destroy')
    $('#footer_block_attributes_background_color').val(this.props.initialFooterBlock && this.props.initialFooterBlock.background_color || '').minicolors('destroy')
    $('#footer_block_attributes_foreground_color').val(this.props.initialFooterBlock && this.props.initialFooterBlock.foreground_color || '').minicolors('destroy')
    $('#footer_block_attributes_link_color').val(this.props.initialFooterBlock && this.props.initialFooterBlock.link_color || '').minicolors('destroy')
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
          background_color: $('#header_block_attributes_background_color').val()
          foreground_color: $('#header_block_attributes_foreground_color').val()
          link_color: $('#header_block_attributes_link_color').val()
      footerBlock:
        $merge:
          background_color: $('#footer_block_attributes_background_color').val()
          foreground_color: $('#footer_block_attributes_foreground_color').val()
          link_color: $('#footer_block_attributes_link_color').val()

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
    $('#header_block_attributes_background_color').val(colors[2]).minicolors('destroy')
    $('#header_block_attributes_foreground_color').val(colors[3]).minicolors('destroy')
    $('#header_block_attributes_link_color').val(colors[3]).minicolors('destroy')
    $('#footer_block_attributes_background_color').val(colors[2]).minicolors('destroy')
    $('#footer_block_attributes_foreground_color').val(colors[3]).minicolors('destroy')
    $('#footer_block_attributes_link_color').val(colors[3]).minicolors('destroy')
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
    this.setState wrapContainer: !this.state.wrapContainer

  webpageContainerClass: ->
    if this.state.wrapContainer then 'webpage-container webpage-container-wrapper' else 'webpage-container'

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
     .webpage-header .nav a,
     .webpage-header .nav a:hover {
       color: #{this.state.link_color} !important;
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
        <input name="wrap_container" type="hidden" value={this.state.wrapContainer} />
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
                  <label htmlFor="header_block_attributes_background_color" className="contor-label small">Background</label>
                  <input name="header_block_attributes[background_color]" id="header_block_attributes_background_color"ype="text" defaultValue={this.state.headerBlock.background_color} className="form-control" />
                </div>
              </div>
              <div className="col-sm-4">
                <div className="form-group">
                  <label htmlFor="header_block_attributes_foreground_color" className="contor-label small">Font</label>
                  <input name="header_block_attributes[foreground_color]" id="header_block_attributes_foreground_color" type="text" defaultValue={this.state.headerBlock.foreground_color} className="form-control" />
                </div>
              </div>
              <div className="col-sm-4">
                <div className="form-group">
                  <label htmlFor="header_block_attributes_link_color" className="contor-label small">Link</label>
                  <input name="header_block_attributes[link_color]" id="header_block_attributes_link_color" type="text" defaultValue={this.state.headerBlock.link_color} className="form-control" />
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
                  <label htmlFor="footer_block_attributes_background_color" className="contor-label small">Background</label>
                  <input name="footer_block_attributes[background_color]" id="footer_block_attributes_background_color" type="text" defaultValue={this.state.footerBlock.background_color} className="form-control" />
                </div>
              </div>
              <div className="col-sm-4">
                <div className="form-group">
                  <label htmlFor="footer_block_attributes_foreground_color" className="contor-label small">Font</label>
                  <input name="footer_block_attributes[foreground_color]" id="footer_block_attributes_foreground_color" type="text" defaultValue={this.state.footerBlock.foreground_color} className="form-control" />
                </div>
              </div>
              <div className="col-sm-4">
                <div className="form-group">
                  <label htmlFor="footer_block_attributes_link_color" className="contor-label small">Link</label>
                  <input name="footer_block_attributes[link_color]" id="footer_block_attributes_link_color" type="text" defaultValue={this.state.footerBlock.link_color} className="form-control" />
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
          <div className="webpage-group webpage-group-basic-left">
            <Block {...this.state.headerBlock} kind="full_width" groupInputName="header_block_attributes" editing={this.state.editing} editCustom={this.editHeader} editLogo={this.editLogo} />
          </div>
          <div className="text-center" style={{backgroundColor: 'rgba(0,0,0,0.1)', padding: '4em 2em', position: 'relative'}}>
            <span style={{fontSize: 30}}>Full-width Content</span>
          </div>
          <div className="webpage-wrapper">
            <div className="container">
              <div className={this.webpageContainerClass()}>
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
          </div>
          <div className="webpage-group webpage-group-basic-left">
            <Block {...this.state.footerBlock} kind="full_width" groupInputName="footer_block_attributes" editing={this.state.editing} prevTheme={this.prevFooterTheme} nextTheme={this.nextFooterTheme} />
          </div>
        </div>
        <div className="panel-footer clearfix">
          <p className="checkbox pull-right" style={{margin: 0}}>
            <label>
              <input type="checkbox" checked={this.state.wrapContainer} onChange={this.toggleContainerWrapper} />
              Wrap Interior Contents?
            </label>
          </p>
        </div>
      </BrowserPanel>
      <div id="header_modal" className="modal fade">
        <div className="modal-dialog">
          <div className="modal-content">
            <div className="modal-header">
              <span className="close" data-dismiss="modal">&times;</span>
              <p className="h4 modal-title">Header Options</p>
            </div>
            <div className="modal-body">
              <div className="form-group">
                <label htmlFor="header_block_attributes_style" className="control-label">Background Style</label>
                <select id="header_block_attributes_style" name="header_block_attributes[style]" className="form-control" defaultValue={this.state.headerBlock.style}>
                  <option value="light">Light Nav Bar</option>
                  <option value="dark">Dark Nav Bar</option>
                </select>
              </div>
              <hr />
              <div className="form-group">
                <label htmlFor="header_block_attributes_logo_horizontal_position" className="control-label">Logo Horizontal Position</label>
                <select id="header_block_attributes_logo_horizontal_position" name="header_block_attributes[logo_horizontal_position]" className="form-control" defaultValue={this.state.headerBlock.logo_horizontal_position}>
                  <option value="left">Left</option>
                  <option value="center">Center</option>
                  <option value="right">Right</option>
                </select>
              </div>
              <div className="form-group">
                <label htmlFor="header_block_attributes_logo_vertical_position" className="control-label">Logo Vertical Position</label>
                <select id="header_block_attributes_logo_vertical_position" name="header_block_attributes[logo_vertical_position]" className="form-control" defaultValue={this.state.headerBlock.logo_vertical_position}>
                  <option value="above">Above</option>
                  <option value="inside">Inside</option>
                  <option value="below">Below</option>
                </select>
              </div>
              <div className="form-group">
                <label htmlFor="header_block_attributes_navigation_horizontal_position" className="control-label">Navigation Horizontal Position</label>
                <select id="header_block_attributes_navigation_horizontal_position" name="header_block_attributes[navigation_horizontal_position]" className="form-control" defaultValue={this.state.headerBlock.navigation_horizontal_position}>
                  <option value="left">Left</option>
                  <option value="center">Center</option>
                  <option value="right">Right</option>
                </select>
              </div>
              <hr />
              <div className="form-group">
                <label htmlFor="header_block_attributes_contact_position" className="control-label">Contact Information Position</label>
                <select id="header_block_attributes_contact_position" name="header_block_attributes[contact_position]" className="form-control" defaultValue={this.state.headerBlock.contact_position}>
                  <option value="none">Hidden</option>
                  <option value="left">Top Left</option>
                  <option value="right">Top Right</option>
                  <option value="full">Full Width</option>
                </select>
              </div>
              <hr />
              <div className="form-group">
                <label htmlFor="header_block_attributes_navbar_location" className="control-label">Navbar Location</label>
                <select id="header_block_attributes_navbar_location" name="header_block_attributes[navbar_location]" className="form-control" defaultValue={this.state.headerBlock.navbar_location}>
                  <option value="default">Fixed Width</option>
                  <option value="static">Static Top (Full Width)</option>
                  <option value="fixed">Fixed Top (Full Width)</option>
                </select>
              </div>
            </div>
            <div className="modal-footer">
              <span className="btn btn-default" data-dismiss="modal" onClick={this.resetHeader}>Cancel</span>
              <span className="btn btn-primary" data-dismiss="modal" onClick={this.updateHeader}>Save</span>
            </div>
          </div>
        </div>
      </div>
      <div id="logo_modal" className="modal fade">
        <div className="modal-dialog modal-lg">
          <div className="modal-content">
            <div className="modal-header">
              <span className="close" data-dismiss="modal">&times;</span>
              <p className="h4 modal-title">Specify Logo Height</p>
            </div>
            <div className="modal-body text-center">
              <input id="header_block_attributes_logo_height" name="header_block_attributes[logo_height]" type="hidden" value={this.state.headerBlock.logo_height} />
              <div className="row">
                <div className="col-sm-2 logo-size">
                  <div style={{height: 200}}>
                    <div className="logo-size-picker" style={{display: 'inline-block', width: 40, height: 40, backgroundColor: '#ccc', verticalAlign: -185}} />
                  </div>
                  <label className="radio" style={{marginLeft: 20}}>
                    <input id="logo_size_40" name="logo_size" type="radio" value="40" /> 40px
                  </label>
                </div>
                <div className="col-sm-2 logo-size">
                  <div style={{height: 200}}>
                    <div className="logo-size-picker" style={{display: 'inline-block', width: 60, height: 60, backgroundColor: '#ccc', verticalAlign: -185}} />
                  </div>
                  <label className="radio" style={{marginLeft: 20}}>
                    <input id="logo_size_60" name="logo_size" type="radio" value="60" /> 60px
                  </label>
                </div>
                <div className="col-sm-2 logo-size">
                  <div style={{height: 200}}>
                    <div className="logo-size-picker" style={{display: 'inline-block', width: 125, height: 125, backgroundColor: '#ccc', verticalAlign: -185}} />
                  </div>
                  <label className="radio" style={{marginLeft: 20}}>
                    <input id="logo_size_125" name="logo_size" type="radio" value="125" /> 125px
                  </label>
                </div>
                <div className="col-sm-3 logo-size">
                  <div style={{height: 200}}>
                    <div className="logo-size-picker" style={{display: 'inline-block', width: 200, height: 200, backgroundColor: '#ccc'}} />
                  </div>
                  <label className="radio" style={{marginLeft: 20}}>
                    <input id="logo_size_200" name="logo_size" type="radio" value="200" /> 200px
                  </label>
                </div>
                <div className="col-sm-3 logo-size">
                  <div style={{height: 200}}>
                    <div className="logo-size-picker" style={{display: 'inline-block', verticalAlign: -135}}>
                      <div style={{display: 'inline-block', width: 125, height: 125, border: 'dashed 1px #999'}} />
                      <input id="logo_size_custom_value" type="number" className="center-block form-control" defaultValue={this.state.headerBlock.logo_height} style={{width: '50%', marginTop: 10}} />
                    </div>
                  </div>
                  <label className="radio" style={{marginLeft: 20}}>
                    <input id="logo_size_custom" name="logo_size" type="radio" value="custom" /> Custom Height
                  </label>
                </div>
              </div>
            </div>
            <div className="modal-footer">
              <span className="btn btn-default" data-dismiss="modal" onClick={this.resetLogo}>Cancel</span>
              <span className="btn btn-primary" data-dismiss="modal" onClick={this.updateLogo}>Save</span>
            </div>
          </div>
        </div>
      </div>
    </div>`

  renderLoadColorsButton: ->
    if this.state.logo
      `<span onClick={this.loadColors} className="btn btn-default">Load Colors from Logo Image</span>`

  editHeader: (event) ->
    event.preventDefault()
    $('#header_modal').modal('show')
    $('#header_block_attributes_style').val this.state.headerBlock.style or 'light'
    $('#header_block_attributes_logo_horizontal_position').val this.state.headerBlock.logo_horizontal_position or 'left'
    $('#header_block_attributes_logo_vertical_position').val this.state.headerBlock.logo_vertical_position or 'inside'
    $('#header_block_attributes_navigation_horizontal_position').val this.state.headerBlock.navigation_horizontal_position or 'left'
    $('#header_block_attributes_contact_position').val this.state.headerBlock.contact_position or 'none'
    $('#header_block_attributes_navbar_location').val this.state.headerBlock.navbar_location or 'default'

  resetHeader: ->
    $('#header_block_attributes_style').val 'light'
    $('#header_block_attributes_logo_horizontal_position').val 'left'
    $('#header_block_attributes_logo_vertical_position').val 'inside'
    $('#header_block_attributes_navigation_horizontal_position').val 'left'
    $('#header_block_attributes_contact_position').val ''
    $('#header_block_attributes_navbar_location').val ''

  updateHeader: ->
    changes =
      $merge:
        style: $('#header_block_attributes_style').val()
        logo_horizontal_position: $('#header_block_attributes_logo_horizontal_position').val()
        logo_vertical_position: $('#header_block_attributes_logo_vertical_position').val()
        navigation_horizontal_position: $('#header_block_attributes_navigation_horizontal_position').val()
        contact_position: $('#header_block_attributes_contact_position').val()
        navbar_location: $('#header_block_attributes_navbar_location').val()
    this.setState headerBlock: React.addons.update(this.state.headerBlock, changes)

  editLogo: (event) ->
    event.preventDefault()
    $('#logo_modal').modal('show')
    $('#header_block_attributes_logo_height').val this.state.headerBlock.logo_height
    $('#logo_size_custom_value').val ''
    switch parseInt(this.state.headerBlock.logo_height)
      when 40
        $('#logo_size_40').prop('checked', true)
      when 60
        $('#logo_size_60').prop('checked', true)
      when 125
        $('#logo_size_125').prop('checked', true)
      when 200
        $('#logo_size_200').prop('checked', true)
      else
        $('#logo_size_custom').prop('checked', true)
        $('#logo_size_custom_value').val this.state.headerBlock.logo_height

  resetLogo: ->
    $('#header_block_attributes_logo_height').val ''
    $('#logo_size_custom_value').val ''
    $('input[name="logo_size"]').val ''

  updateLogo: ->
    logo_height = if $('#logo_size_custom').is(':checked') then $('#logo_size_custom_value').val() else $('input[name="logo_size"]:checked').val()
    changes =
      $merge:
        logo_height: parseInt(logo_height)
    this.setState headerBlock: React.addons.update(this.state.headerBlock, changes)

  prevFooterTheme: (event) ->
    event.preventDefault()
    availableThemes = ['simple', 'simple_full_width', 'columns', 'layers']
    currentTheme = this.state.footerBlock.theme
    currentThemeIndex = availableThemes.indexOf(currentTheme)
    theme = availableThemes[currentThemeIndex - 1] or availableThemes[-1]
    this.setState footerBlock: React.addons.update(this.state.footerBlock, $merge: { theme: theme })

  nextFooterTheme: (event) ->
    event.preventDefault()
    availableThemes = ['simple', 'simple_full_width', 'columns', 'layers']
    currentTheme = this.state.footerBlock.theme
    currentThemeIndex = availableThemes.indexOf(currentTheme)
    theme = availableThemes[currentThemeIndex + 1] or availableThemes[0]
    this.setState footerBlock: React.addons.update(this.state.footerBlock, $merge: { theme: theme })

window.Theme = Theme
