ContactFormBlock = React.createClass
  items: ->
    args = {}

    this.props.contactForms.map (item) ->
      args[item.id] = item

    return args

  render: ->
    settings = this.props.settings
    widgetName = null

    if settings
      widgetId = settings.contact_form_widget_id
    if widgetId && this.items()[widgetId]
      widgetName = this.items()[widgetId].name

    `<div className="webpage-block-representer">
      <p style={{fontSize: 30}}>Contact Form</p>
      <p style={{fontSize: 16}}>{widgetName}</p>
    </div>`

window.ContactFormBlock = ContactFormBlock
