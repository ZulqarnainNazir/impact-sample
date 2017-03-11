MediaLibraryMoreButton = React.createClass
  render: ->
    if (!this.props.mediaLibraryLoadedAll)
      return (`<div className="row text-center">
        <div className="col-sm-4 col-sm-offset-4">
          <div onClick={this.props.loadMediaLibraryImages} className="btn btn-block btn-default">Load More</div>
        </div>
      </div>`)
    return `<div />`

window.MediaLibraryMoreButton = MediaLibraryMoreButton
