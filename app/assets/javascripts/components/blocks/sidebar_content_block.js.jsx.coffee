SidebarContentBlock = React.createClass
  render: ->
    `<div className="webpage-sidebar-content">
      <div className="panel panel-default">
        <div className="panel-body">
          <h4 className="text-center">
            <RichTextEditor enabled={this.props.editing && this.props.richText} html={this.props.heading} inline={true} update={this.props.updateHeading} />
          </h4>
          <BlockImagePlacement {...this.props.block_image_placement} editing={this.props.editing} />
          <RichTextEditor enabled={this.props.editing && this.props.richText} html={this.props.text} update={this.props.updateText} />
          <div className="text-center">
            <BlockLinkButton {...this.props} />
          </div>
        </div>
      </div>
    </div>`

window.SidebarContentBlock = SidebarContentBlock
