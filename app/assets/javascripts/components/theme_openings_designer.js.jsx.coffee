ThemeOpeningsDesigner = React.createClass
  render: ->
    `<div>
      {this.props.openings.map(this.renderOpening)}
    </div>`

  renderOpening: (opening) ->
    `<div key={opening.id}>{opening.days} <span className="pull-right">{opening.hours}</span></div>`

window.ThemeOpeningsDesigner = ThemeOpeningsDesigner
