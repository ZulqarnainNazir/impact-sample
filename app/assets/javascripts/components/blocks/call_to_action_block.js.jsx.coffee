CallToActionBlock = React.createClass

  wellClass: ->
    switch this.props.well_style
      when 'light'
        'well well-light'
      when 'dark'
        'well well-dark'
      else
        'well well-transparent'

  render: ->
    `<div className="webpage-call-to-action">
      <div className="panel panel-default" style={{backgroundColor: this.props.background_color}} >
        <div className={this.wellClass() + ' panel-body'} style={{color: this.props.foreground_color}}>
          <h4 className="text-center">
            <RichTextEditor enabled={this.props.editing && this.props.richText} html={this.props.heading} inline={true} update={this.props.updateHeading} />
          </h4>
          <BlockImagePlacement {...this.props.block_image_placement} editing={this.props.editing} version="medium" />
          <RichTextEditor enabled={this.props.editing && this.props.richText} html={this.props.text} update={this.props.updateText} />
          <div className="text-center">
            <BlockLinkButton {...this.props} />
          </div>
        </div>
      </div>
    </div>`

window.CallToActionBlock = CallToActionBlock
