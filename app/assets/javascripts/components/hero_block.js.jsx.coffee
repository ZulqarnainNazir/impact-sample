HeroBlock = React.createClass
  propTypes:
    block: React.PropTypes.object
    blockAdd: React.PropTypes.object
    blockEditor: React.PropTypes.object
    blockImageLibrary: React.PropTypes.object
    blockInputHeading: React.PropTypes.object
    blockInputColor: React.PropTypes.object
    blockInputStyle: React.PropTypes.object
    blockInputImage: React.PropTypes.object
    blockInputLink: React.PropTypes.object
    blockInputText: React.PropTypes.object
    blockOptions: React.PropTypes.object
    blockInputsClassName: React.PropTypes.string
    editing: React.PropTypes.bool

  shouldComponentUpdate: (nextProps, nextState) ->
    # this.props.block is nextProps.block and this.props.editing is nextProps.editing
    true

  render: ->
    `<div className="webpage-container" data-type="hero">
      <i className="fa fa-reorder webpage-container-handle" />
      {this.renderInterior()}
    </div>`

  renderInterior: ->
    if this.props.block
      `<div className="webpage-block">
        <BlockOptions {...this.props.blockOptions} />
        <div className="webpage-hero">
          <HeroBlockContent {...this.props.block} />
        </div>
        <BlockEditor {...this.props.blockEditor}>
          <input type="hidden" name={this.props.name('theme')} value={this.props.block.theme} />
          <div className={this.props.blockInputsClassName}>
            <div className="row">
              <div className="col-sm-4">
                <BlockInputStyle {...this.props.blockInputStyle} />
              </div>
              <div className="col-sm-4">
                <BlockInputColor {...this.props.blockInputBackgroundColor} />
              </div>
              <div className="col-sm-4">
                <BlockInputColor {...this.props.blockInputForegroundColor} />
              </div>
            </div>
            <hr />
            <BlockInputImage {...this.props.blockInputImage} />
            <hr />
            {this.renderLayoutOptions()}
            <hr />
            <BlockInputText {...this.props.blockInputHeading} />
            <BlockInputText {...this.props.blockInputText} />
            <hr />
            <BlockInputLink {...this.props.blockInputLink} />
          </div>
          <BlockImageLibrary {...this.props.blockImageLibrary} />
        </BlockEditor>
      </div>`
    else if this.props.editing
      `<BlockAdd {...this.props.blockAdd} />`

  renderLayoutOptions: ->
    if this.props.block
      `<div>
        <label>Hero Layout Options</label>
        <div className="row">
          <div className="col-sm-12">
            <div className="radio">
              <label>
                <input type="radio" name={this.props.name('layout')} value="default" defaultChecked={!this.props.block.layout || this.props.block.layout === 'default'} />
                Default layout
              </label>
            </div>
            <div className="radio">
              <label>
                <input type="radio" name={this.props.name('layout')} value="top" defaultChecked={this.props.block.layout === 'top'} />
                Align to top (no space between header nav and hero)
              </label>
            </div>
            <div className="radio">
              <label>
                <input type="radio" name={this.props.name('layout')} value="fullbleed" defaultChecked={this.props.block.layout === 'fullbleed'} />
                Full-bleed (Align to top and fill viewport width)
              </label>
            </div>
          </div>
        </div>
      </div>`


window.HeroBlock = HeroBlock
