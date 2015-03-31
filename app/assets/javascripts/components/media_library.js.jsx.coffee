MediaLibrary = React.createClass
  render: ->
    `<div>
      <ol className="breadcrumb">
        <li><a onClick={this.props.hide} href="#">Edit Details</a></li>
        <li className="active">Media Library</li>
      </ol>
      <p className="bg-warning">TODO</p>
    </div>`
