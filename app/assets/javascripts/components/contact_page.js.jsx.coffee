ContactPage = React.createClass
  propTypes:
    browserButtonsSrc: React.PropTypes.string.isRequired

  mixins: [
    PrevNext,
    ContactBlockHandlers,
  ]

  getInitialState: ->
    editing: true

  toggleEditing: ->
    this.setState editing: !this.state.editing

  render: ->
    `<div>
      <BrowserPanel browserButtonsSrc={this.props.browserButtonsSrc} toggleEditing={this.toggleEditing} editing={this.state.editing}>
        <div className="panel-body">
          <ContactBlock {...this.contactBlockProps()} />
          <div className="webpage-fields">
            {this.contactBlockInputs()}
          </div>
        </div>
      </BrowserPanel>
    </div>`

window.ContactPage = ContactPage
