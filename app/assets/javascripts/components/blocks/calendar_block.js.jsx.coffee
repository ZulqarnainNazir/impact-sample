CalendarBlock = React.createClass
  items: ->
    args = {}

    this.props.calendarWidgets.map (item) ->
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
      widgetPath = this.props.calendarWidgetsPath + widgetId + "/edit"

    `<div className="webpage-block-representer">
      <p style={{fontSize: 30}}>Calendar Event Feed</p>
      <p style={{fontSize: 16}}><a href={widgetPath} target="_blank" style={{color: '#337AB7', textDecoration: 'underline'}}>{widgetName}</a></p>
    </div>`

window.CalendarBlock = CalendarBlock
