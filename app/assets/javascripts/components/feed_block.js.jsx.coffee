FeedBlock = React.createClass
  propTypes:
    block: React.PropTypes.object
    blockAdd: React.PropTypes.object
    blockEditor: React.PropTypes.object
    blockInputItemsLimit: React.PropTypes.object
    blockOptions: React.PropTypes.object
    editing: React.PropTypes.bool

  shouldComponentUpdate: (nextProps, nextState) ->
    # this.props.block is nextProps.block and this.props.editing is nextProps.editing
    true

  componentDidMount: ->
    $(this).on 'change', 'input[type="radio"]', this.toggleRadios

  componentDidUpdate: ->
    this.toggleRadios()

  toggleRadios: ->
    $(this).find('input[type="radio"]:checked').closest('label').removeClass('btn-default').addClass('btn-primary')
    $(this).find('input[type="radio"]:not(:checked)').closest('label').removeClass('btn-primary').addClass('btn-default')

  render: ->
    `<div className="webpage-container" data-type="feed">
      <i className="fa fa-reorder webpage-container-handle" />
      {this.renderInterior()}
    </div>`

  renderInterior: ->
    if this.props.block
      if this.props.block.width is 'full'
        sidebarWidthDefaultChecked = false
        fullWidthDefaultChecked = true
      else
        sidebarWidthDefaultChecked = true
        fullWidthDefaultChecked = false

      `<div className="webpage-block">
        <BlockOptions {...this.props.blockOptions} />
        <div className="webpage-feed">
          <FeedBlockContent {...this.props.block} />
        </div>
        <BlockEditor {...this.props.blockEditor}>
          <div className="text-center">
            <div className="center-block">
              <div className="btn-group">
                <label className="btn btn-default">
                  <input id={this.props.id('width_sidebar')} name={this.props.name('width')} value="sidebar" type="radio" style={{marginRight: 5}} defaultChecked={sidebarWidthDefaultChecked} /> Two-Thirds Width
                </label>
                <label className="btn btn-default">
                  <input id={this.props.id('width_full')} name={this.props.name('width')} value="full" type="radio" style={{marginRight: 5}} defaultChecked={fullWidthDefaultChecked} /> Full Width
                </label>
              </div>
            </div>
          </div>
          <BlockInputNumber {...this.props.blockInputItemsLimit} />
        </BlockEditor>
      </div>`
    else if this.props.editing and !this.props.blog
      `<div className="webpage-add">
        <a href={this.props.blogPath} target="_blank">Add a Blog Page to Embed a Feed Block</a>
      </div>`
    else if this.props.editing
      `<BlockAdd {...this.props.blockAdd} />`
    else
      `<div />`

window.FeedBlock = FeedBlock
