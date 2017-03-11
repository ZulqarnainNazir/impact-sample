MediaLibraryOnlyLocalCheckbox = React.createClass
  render: ->
    if (this.props.showOnlyLocalMediaLibraryOption)
      return (
        `<div className="checkbox pull-right small" style={{ marginRight: 10 }}>
          <label>
            <input type="checkbox" onChange={this.props.toggleMediaLibraryLocalOnly} defaultChecked={this.props.showOnlyLocalMediaLibraryOption} style={{ marginTop: 2 }} />
            Current Site Only
          </label>
        </div>`
      )
    return `<div />`

window.MediaLibraryOnlyLocalCheckbox = MediaLibraryOnlyLocalCheckbox
