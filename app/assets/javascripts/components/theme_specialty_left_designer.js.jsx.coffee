ThemeSpecialtyLeftDesigner = React.createClass
  render: ->
    `<div>
      <p className="lead text-center"><ContentEditable html={this.props.heading} onChange={this.props.changeHeading} /></p>
      <p className="specialty-description"><ContentEditable html={this.props.subheading} onChange={this.props.changeSubheading} /></p>
      <hr />
      <div className="row">
        <div className="col-sm-7 col-md-6">
          <p><img className="img-responsive" src={this.props.background} /></p>
        </div>
        <div className="col-sm-5 col-md-6">
          <ContentEditable html={this.props.text} onChange={this.props.changeText} />
        </div>
      </div>
    </div>`

window.ThemeSpecialtyLeftDesigner = ThemeSpecialtyLeftDesigner
