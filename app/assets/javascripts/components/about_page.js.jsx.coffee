AboutPage = React.createClass
  propTypes:
    browserButtonsSrc: React.PropTypes.string.isRequired

  mixins: [
    PrevNext,
    AboutBlockHandlers,
    TeamBlockHandlers,
  ]

  getInitialState: ->
    editing: true

  toggleEditing: ->
    this.setState editing: !this.state.editing

  render: ->
    `<div>
      <BrowserPanel browserButtonsSrc={this.props.browserButtonsSrc} toggleEditing={this.toggleEditing} editing={this.state.editing}>
        <div className="panel-body">
          <AboutBlock {...this.aboutBlockProps()} />
          <TeamBlock {...this.teamBlockProps()} />
          <div className="webpage-fields">
            {this.aboutBlockInputs()}
            {this.teamBlockInputs()}
          </div>
        </div>
      </BrowserPanel>
    </div>`

window.AboutPage = AboutPage
