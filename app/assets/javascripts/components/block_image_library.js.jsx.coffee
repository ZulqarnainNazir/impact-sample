BlockImageLibrary = React.createClass
  mixins: [React.addons.PureRenderMixin]

  propTypes:
    hide: React.PropTypes.func.isRequired
    visible: React.PropTypes.bool
    images: React.PropTypes.array

  getDefaultProps: ->
    visible: false
    images: []

  render: ->
    if this.props.visible
      `<div>
        <ol className="breadcrumb">
          <li><a onClick={this.props.hide} href="#">Edit Details</a></li>
          <li className="active">Media Library</li>
        </ol>
        {this.renderInterior()}
      </div>`
    else
      `<div />`

  renderInterior: ->
    if this.props.loaded
      `<div className="row row-narrow">
        {this.renderImages()}
        {this.renderMoreButton()}
      </div>`
    else
      `<div className="text-center" style={{marginTop: 50, marginBottom: 50}}>
        <i className="fa fa-spinner fa-spin fa-4x" />
      </div>`

  renderImages: ->
    this.props.images.map this.renderImage

  renderImage: (image) ->
    `<div key={image.id} className="col-xs-2">
      <img onClick={this.props.add.bind(null, image)} src={image.attachment_thumbnail_url} alt={image.alt} title={image.title} className="thumbnail" style={{width: 90, height: 90, cursor: 'pointer'}} />
    </div>`

  renderMoreButton: ->
    if this.props.more
      `<div className="row text-center">
        <div className="col-sm-4 col-sm-offset-4">
          <div onClick={this.props.loadMore} className="btn btn-block btn-default">Load More</div>
        </div>
      </div>`

window.BlockImageLibrary = BlockImageLibrary
