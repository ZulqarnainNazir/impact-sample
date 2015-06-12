BlockLinkButton = React.createClass
  render: ->
    if this.props.link_version != 'link_none' and this.props.link_label and this.props.link_label.length > 0
      `<p><a className="btn btn-primary btn-lg" href="#" role="button">{this.props.link_label}</a></p>`
    else
      `<div />`

window.BlockLinkButton = BlockLinkButton
