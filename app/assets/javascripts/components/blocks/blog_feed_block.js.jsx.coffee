BlogFeedBlock = React.createClass
  items: ->
    args = {}

    this.props.contentFeedWidgets.map (item) ->
      args[item.id] = item

    return args

  render: ->
    settings = this.props.settings
    widgetName = null
    widgetPath = ""

    if settings
      widgetId = settings.widget_id
    if widgetId && this.items()[widgetId]
      widgetName = this.items()[widgetId].name
      widgetPath = this.props.contentFeedWidgetsPath + widgetId + "/edit"

    `<div className="webpage-block-representer">
      <p style={{fontSize: 30}}>Top <strong>{this.props.items_limit}</strong> Blog Feed Items</p>
      <p style={{fontSize: 16}}><a href={widgetPath} target="_blank" style={{color: '#337AB7', textDecoration: 'underline'}}>{widgetName}</a></p>
      <p style={{fontSize: 16}}><a href={this.props.contentsPath} target="_blank" style={{color: '#337AB7', textDecoration: 'underline'}}>View Recent Content</a></p>
    </div>`

window.BlogFeedBlock = BlogFeedBlock
