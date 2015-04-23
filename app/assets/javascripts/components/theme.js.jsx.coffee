Theme = React.createClass
  propTypes:
    browserButtonsSrc: React.PropTypes.string.isRequired

  mixins: [
    PrevNext,
    HeaderBlockHandlers,
    FooterBlockHandlers,
  ]

  getInitialState: ->
    background_color: this.props.defaultBackgroundColor || ''
    foreground_color: this.props.defaultForegroundColor || ''
    link_color: this.props.defaultLinkColor || ''
    editing: true
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

  styles: ->
    """
    .webpage-background {
      background-color: #{this.state.background_color};
      color: #{this.state.foreground_color};
    }
    .webpage-background a {
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
        <div style={{position: 'relative'}}>
          <div className="webpage-background" style={{position: 'absolute', top: 0, right: 0, bottom: 0, left: 0, zIndex: 0}} />
          <HeaderBlock {...this.headerBlockProps()} />
          <div className="panel-body webpage-background">
            <div className="text-center" style={{backgroundColor: 'rgba(0,0,0,0.1)', borderRadius: 5, padding: '10em 5em', margin: '2em 0', position: 'relative', zIndex: 1}}>
              <span style={{fontSize: 30}}>Main Content Goes Here – <a href="#">Example Link</a></span>
            </div>
          </div>
          <FooterBlock {...this.footerBlockProps()} />
          <div className="webpage-fields">
            {this.headerBlockInputs()}
            {this.footerBlockInputs()}
          </div>
        </div>
      </BrowserPanel>
    </div>`

  renderLoadColorsButton: ->
    if this.state.logo
      `<span onClick={this.loadColors} className="btn btn-default">Load Colors from Logo Image</span>`

window.Theme = Theme
