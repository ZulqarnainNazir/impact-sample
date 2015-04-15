CustomPage = React.createClass
  propTypes:
    browserButtonsSrc: React.PropTypes.string.isRequired

  mixins: [
    PrevNext,
    HeroBlockHandlers,
    TaglineBlockHandlers,
    CallToActionBlocksHandlers,
    SpecialtyBlockHandlers,
    ContentBlocksHandlers,
  ]

  getInitialState: ->
    editing: true

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
          <HeroBlock {...this.heroBlockProps()} />
          <TaglineBlock {...this.taglineBlockProps()} />
          <CallToActionBlocks {...this.callToActionBlocksProps()} />
          <SpecialtyBlock {...this.specialtyBlockProps()} />
          <ContentBlocks {...this.contentBlocksProps()} />
          <div className="webpage-fields">
            {this.heroBlockInputs()}
            {this.taglineBlockInputs()}
            {this.callToActionBlocksInputs()}
            {this.specialtyBlockInputs()}
            {this.contentBlocksInputs()}
          </div>
        </div>
      </BrowserPanel>
    </div>`

window.CustomPage = CustomPage
