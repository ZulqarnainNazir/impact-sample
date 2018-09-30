EditLinkOptions = React.createClass
  renderBlankOp: ->
    if this.props.includeBlank
      return `<option key="-1" value=""></option>`

  render: ->
    sorted = this.props.internalWebpages.sort((a, b) ->
      if a.name > b.name
        return 1
      else if a.name < b.name
        return -1
      0
    )

    return (
      `<select id={this.props.id || 'link_id'} defaultValue={this.props.defaultValue} className="form-control" name={this.props.name}>
        {this.renderBlankOp()}
        {
          sorted.map(webpage =>
            <option key={webpage.id} value={webpage.id}>{webpage.name}</option>,
          )
        }
      </select>`
    );

EditLinkOptions.propTypes = {
  internalWebpages: React.PropTypes.arrayOf(React.PropTypes.object),
}
EditLinkOptions.defaultProps = {
  internalWebpages: [],
}

window.EditLinkOptions = EditLinkOptions
