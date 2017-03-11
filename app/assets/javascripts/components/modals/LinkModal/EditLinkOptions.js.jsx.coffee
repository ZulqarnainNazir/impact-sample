EditLinkOptions = React.createClass
  render: ->
    sorted = this.props.internalWebpages.sort((a, b) ->
      if a.name > b.name
        return 1
      else if a.name < b.name
        return -1
      0
    )
    return (
      `<select id={this.props.id || 'link_id'} className="form-control">
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
