Theme = React.createClass
  propTypes:
    browserButtonsSrc: React.PropTypes.string.isRequired

  mixins: [
    PrevNext,
    HeaderBlockHandlers,
    FooterBlockHandlers,
  ]

  getInitialState: ->
    editing: true

  toggleEditing: ->
    this.setState editing: !this.state.editing

  render: ->
    `<div>
      <BrowserPanel browserButtonsSrc={this.props.browserButtonsSrc} toggleEditing={this.toggleEditing} editing={this.state.editing}>
        <HeaderBlock {...this.headerBlockProps()} />
        <div className="panel-body">
          <div style={{backgroundColor: '#eee', borderRadius: 5, padding: '10em 5em', margin: '2em 0'}} />
        </div>
        <FooterBlock {...this.footerBlockProps()} />
        <div className="webpage-fields">
          {this.headerBlockInputs()}
          {this.footerBlockInputs()}
        </div>
      </BrowserPanel>
    </div>`

window.Theme = Theme
