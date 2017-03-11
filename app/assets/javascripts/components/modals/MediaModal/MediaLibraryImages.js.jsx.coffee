MediaLibraryImages = React.createClass
  render: ->
    if (this.props.mediaLibraryImages.length > 0)
      return (
        `<div>
          {
            Array.from(this.props.mediaLibraryImages).map(image =>
              <div key={image.id || image.attachment_cache_url} className="col-xs-4 col-sm-3">
                <img
                  onClick={this.props.selectMediaLibraryImage.bind(null, image)}
                  src={image.attachment_thumbnail_url}
                  alt={image.alt}
                  title={image.title}
                  className="thumbnail"
                  style={{ maxWidth: '100%', cursor: 'pointer' }}
                />
              </div>,
            )
          }
        </div>`
      )
    return `<div className="col-sm-12"><p>Looks like you don’t have any images, go ahead and upload a few.</p></div>`;

window.MediaLibraryImages = MediaLibraryImages
