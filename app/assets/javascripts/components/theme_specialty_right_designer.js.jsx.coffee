ThemeSpecialtyRightDesigner = React.createClass
  render: ->
    `<div>
      <p className="lead text-center"><ContentEditable html={this.props.heading} onChange={this.props.changeHeading} /></p>
      <hr />
      <div className="row">
        <div className="col-sm-7 col-md-6 pull-right">
          <p><img className="img-responsive" src={this.props.background} /></p>
        </div>
        <div className="col-sm-5 col-md-6">
          <ContentEditable html={this.props.text} onChange={this.props.changeText} />
        </div>
      </div>
    </div>`

window.ThemeSpecialtyRightDesigner = ThemeSpecialtyRightDesigner
