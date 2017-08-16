SupportLocalBlock = React.createClass
  items: ->
    args = {}

    this.props.directoryWidgets.map (item) ->
      args[item.id] = item

    return args

  render: ->
    settings = this.props.settings
    widgetName = null

    if settings
      widgetId = settings.widget_id
    if widgetId && this.items()[widgetId]
      widgetName = this.items()[widgetId].name

    `<div className="webpage-block-representer">
      <p style={{fontSize: 30}}>Support Local Feed</p>
      <p style={{fontSize: 16}}>{widgetName}</p>
    </div>`

window.SupportLocalBlock = SupportLocalBlock
