FeedBlockContent = React.createClass
  render: ->
    if this.props.width is 'full'
      columnClassName = 'col-sm-12'
    else
      columnClassName = 'col-sm-8'

    `<div className="webpage-background">
      <div className="row">
        <div className={columnClassName}>
          <div className="text-center" style={{backgroundColor: 'rgba(0,0,0,0.1)', borderRadius: 5, padding: '5em 5em', margin: '2em 0', position: 'relative', zIndex: 1}}>
            <span style={{fontSize: 30}}>Top <strong>{this.props.items_limit}</strong> Blog Feed Items</span>
          </div>
        </div>
      </div>
    </div>`

window.FeedBlockContent = FeedBlockContent
