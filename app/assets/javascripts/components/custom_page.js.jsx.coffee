CustomPage = React.createClass
  propTypes:
    browserButtonsSrc: React.PropTypes.string.isRequired

  mixins: [
    PrevNext,
    HeroBlockHandlers,
    TaglineBlocksHandlers,
    CallToActionBlocksHandlers,
    SpecialtyBlocksHandlers,
    ContentBlocksHandlers,
  ]

  getInitialState: ->
    editing: true

   componentDidMount: ->
    $('.webpage-sortable').sortable
      axis: 'y'
      container: '.webpage-sortable'
      expandOnHover: 400
      forceHelperSize: true
      forcePlaceholderSize: true
      handle: '.webpage-container-handle'
      helper: 'clone'
      items: '.webpage-container'
      opacity: 0.5
      placeholder: 'placeholder'
      revert: 100
      startCollapsed: false
      tabSize: 20
      tolerance: 'pointer'
      update: this.sortBlockTypes

  sortBlockTypes: (event, ui) ->
    $('#block_type_order').val this.blockTypeOrder().get().join(',')

  blockTypeOrder: ->
    $('.webpage-sortable .webpage-container').map ->
      $(this).data().type

  toggleEditing: ->
    this.setState editing: !this.state.editing

  styles: ->
    """
    .webpage-background,
    .webpage-hero,
    .webpage-tagline,
    .webpage-call-to-action,
    .webpage-specialty,
    .webpage-content {
      background-color: #{this.props.defaultBackgroundColor};
      color: #{this.props.defaultForegroundColor};
    }
    .webpage-hero,
    .webpage-call-to-action {
      color: #000;
    }
    .webpage-add {
      background-color: #{this.props.defaultBackgroundColor};
      border-color: #{this.props.defaultForegroundColor};
      color: #{this.props.defaultForegroundColor};
    }
    .webpage-background a,
    .webpage-hero a,
    .webpage-tagline a,
    .webpage-call-to-action a,
    .webpage-specialty a,
    .webpage-content a {
      color: #{this.props.defaultLinkColor};
    }
    """

  render: ->
    `<div>
      <style dangerouslySetInnerHTML={{__html: this.styles()}} />
      <BrowserPanel browserButtonsSrc={this.props.browserButtonsSrc} toggleEditing={this.toggleEditing} editing={this.state.editing}>
        <div className="panel-body" style={{position: 'relative'}}>
          <div className="webpage-background" style={{position: 'absolute', top: 0, right: 0, bottom: 0, left: 0, zIndex: 0}} />
          <div className="webpage-sortable">
            {this.renderBlocks()}
          </div>
          <div className="webpage-fields">
            <input type="hidden" id="block_type_order" name="block_type_order" defaultValue={this.props.blockTypeOrder} />
            <input type="hidden" id="call_to_action_blocks_per_row" name="call_to_action_blocks_per_row" value={this.state.callToActionBlocksPerRow} />
            {this.heroBlockInputs()}
            {this.taglineBlocksInputs()}
            {this.callToActionBlocksInputs()}
            {this.specialtyBlocksInputs()}
            {this.contentBlocksInputs()}
          </div>
        </div>
      </BrowserPanel>
    </div>`

  renderBlocks: ->
    this.props.blockTypeOrder.split(',').map this.renderBlock

  renderBlock: (type) ->
    switch type
      when 'hero'
        `<HeroBlock key="hero" {...this.heroBlockProps()} />`
      when 'tagline'
        `<TaglineBlocks key="tagline" {...this.taglineBlocksProps()} />`
      when 'call_to_action'
        `<CallToActionBlocks key="call_to_action" {...this.callToActionBlocksProps()} />`
      when 'specialty'
        `<SpecialtyBlocks key="specialty" {...this.specialtyBlocksProps()} />`
      when 'content'
        `<ContentBlocks key="content" {...this.contentBlocksProps()} />`

window.CustomPage = CustomPage
