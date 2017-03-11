MediaLibraryInterior = React.createClass
  render: ->
    if (this.props.mediaLibraryLoaded)
      return (`<div>
        <div className="row row-narrow">
          <MediaLibraryImages
            mediaLibraryImages={this.props.mediaLibraryImages}
            selectMediaLibraryImage={this.props.selectMediaLibraryImage}
          />
        </div>
        <MediaLibraryMoreButton mediaLibraryLoadedAll={this.props.mediaLibraryLoadedAll} loadMediaLibraryImages={this.props.loadMediaLibraryImages} />
      </div>`)
    return (`<div className="text-center" style={{ marginTop: 50, marginBottom: 50 }}>
      <i className="fa fa-spinner fa-spin fa-4x" />
    </div>`);

# // MediaLibraryInterior.propTypes = {
# //   mediaLibraryLoaded: React.PropTypes.bool,
# //   mediaLibraryImages: React.PropTypes.bool,
# //   selectMediaLibraryImage: React.PropTypes.bool,
# //   mediaLibraryLoadedAll: React.PropTypes.bool,
# //   loadMediaLibraryImages: React.PropTypes.bool,
# // };

window.MediaLibraryInterior = MediaLibraryInterior
