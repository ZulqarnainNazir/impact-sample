# // import React, { PropTypes } from 'react';

# // returns a JSX collection of hidden inputs with the values from props.fields
WebpageFields = React.createClass
  inputName: (name) ->
    "#{this.props.inputPrefix}[#{this.props.uuid}][#{name}]"

  render: ->
    return (
      `<div className="webpage-fields">
        { Object.keys(this.props.fields).map(name => (
          <input
            key={name}
            type="hidden"
            name={this.inputName(name)}
            value={this.props.fields[name]}
          />
        ))}
        {this.props.removedBlocks}
      </div>`
    )

WebpageFields.propTypes = {
  fields: React.PropTypes.object,
  inputPrefix: React.PropTypes.string,
}

WebpageFields.defaultProps = {
  fields: {},
  inputPrefix: "",
}

# // export default WebpageFields;

window.WebpageFields = WebpageFields
