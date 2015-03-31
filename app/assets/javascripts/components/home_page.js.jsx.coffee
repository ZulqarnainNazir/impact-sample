HomePage = React.createClass
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

  render: ->
    `<div>
      <BrowserPanel browserButtonsSrc={this.props.browserButtonsSrc} toggleEditing={this.toggleEditing} editing={this.state.editing}>
        <div className="panel-body">
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

window.HomePage = HomePage
