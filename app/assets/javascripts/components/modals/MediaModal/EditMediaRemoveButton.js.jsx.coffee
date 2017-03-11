EditMediaRemoveButton = React.createClass
  render: ->
    if (['failed', 'attached'].indexOf(this.props.mediaImageStatus) >= 0)
      return (
        `<span onClick={this.props.removeMediaImage} className="btn btn-sm btn-danger pull-right">
          <i className="fa fa-close" /> Remove
        </span>`
      )

    return `<div />`

window.EditMediaRemoveButton = EditMediaRemoveButton
