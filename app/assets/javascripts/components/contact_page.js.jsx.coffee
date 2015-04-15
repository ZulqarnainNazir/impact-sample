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

  styles: ->
    """
    .webpage-background,
    .webpage-contact {
      background-color: #{this.props.defaultBackgroundColor};
      color: #{this.props.defaultForegroundColor};
    }
    .webpage-add {
      background-color: #{this.props.defaultBackgroundColor};
      border-color: #{this.props.defaultForegroundColor};
      color: #{this.props.defaultForegroundColor};
    }
    .webpage-background a,
    .webpage-contact a {
      color: #{this.props.defaultLinkColor};
    }
    """

  render: ->
    `<div>
      <style dangerouslySetInnerHTML={{__html: this.styles()}} />
      <BrowserPanel browserButtonsSrc={this.props.browserButtonsSrc} toggleEditing={this.toggleEditing} editing={this.state.editing}>
        <div className="panel-body" style={{position: 'relative'}}>
          <div className="webpage-background" style={{position: 'absolute', top: 0, right: 0, bottom: 0, left: 0, zIndex: 0}} />
          <ContactBlock {...this.contactBlockProps()} />
          <div className="webpage-fields">
            {this.contactBlockInputs()}
          </div>
        </div>
      </BrowserPanel>
    </div>`

window.ContactPage = ContactPage
