SmartTextField = React.createClass

  componentWillMount: ->
    this.setState
      savedValue: this.props.initialValue
      value: this.props.initialValue
      xhr_state: 'unsent'

  handleChange: (event) ->
    this.setState
      value: event.target.value

  handleKeyPress: (event) ->
    if (event.key is 'Enter')
      this.textInput?.blur()

  handleBlur: (event) ->
    this.save()

  save: () ->
    if this.state.value is this.state.savedValue
      return

    if not this.props.autosubmit
      return

    data = new FormData()

    authToken = this.props.authenticityToken

    data.append(this.props.name, this.state.value)
    data.append('authenticity_token', authToken)
    data.append('_method', 'PATCH')

    xhr = new XMLHttpRequest()
    xhr.addEventListener('load', this.handleXHR)
    xhr.addEventListener('error', this.handleXHRError)
    xhr.open('POST', this.props.api)
    xhr.send(data)

    # Save our attempt on the xhr so we can easily get it if the user types more
    xhr.sentValue = this.state.value

    this.setState
      xhr_state: 'pending'

  handleXHR: (event) ->

    if (event.target.status is 200)
      this.setState
        xhr_state: 'complete'
        savedValue: event.target.sentValue
    else
      this.setState
        xhr_state: 'error'

  handleXHRError: (event) ->

    this.setState
      xhr_state: 'error'

  render: ->

    if this.state.xhr_state is 'unsent'
      className = 'hidden'
    else if this.state.xhr_state is 'pending'
      className = 'fa fa-spinner text-warning'
    else if this.state.xhr_state is 'complete'
      className = 'fa fa-check-circle text-success'
    else
      className = 'fa fa-circle text-danger'

    `<div className="smart-text-field">
      <input
        type="text"
        name={this.props.name}
        id={this.props.name}
        className={'smart-text-field--input ' + this.props.className}
        value={this.state.value}
        onChange={this.handleChange}
        onBlur={this.handleBlur}
        onKeyPress={this.handleKeyPress}
        required={this.props.required}
        placeholder={this.props.placeholder}
        ref={(input) => { this.textInput = input; }}
        />
      <i className={'smart-text-field--icon ' + className} ></i>
    </div>`


SmartTextField.propTypes = {
  name: React.PropTypes.string.isRequired,
  api: React.PropTypes.string.isRequired,
  authenticityToken: React.PropTypes.string.isRequired,
  className: React.PropTypes.string,
  initialValue: React.PropTypes.string,
  required: React.PropTypes.bool,
  placeholder: React.PropTypes.string,
  autosubmit: React.PropTypes.bool,
}

window.SmartTextField = SmartTextField
