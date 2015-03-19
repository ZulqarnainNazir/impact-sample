ThemeCtaSimpleDesigner = React.createClass
  render: ->
    `<div className="row">
      <div key="1" className="col-sm-4">
        <div className="panel panel-default tagline tagline-columns text-center">
          <div className="panel-body">
            <h4><ContentEditable html={this.props.title_01} onChange={this.props.changeTitle01} /></h4>
            <p><img src={this.props.background_01} className="img-responsive" /></p>
            <p className="tagline-text"><ContentEditable html={this.props.text_01} onChange={this.props.changeText01} /></p>
            <p><a className="btn btn-primary" href="#">
              <ContentEditable html={this.props.button_01} onChange={this.props.changeButton01} />
            </a></p>
          </div>
        </div>
      </div>
      <div key="2" className="col-sm-4">
        <div className="panel panel-default tagline tagline-columns text-center">
          <div className="panel-body">
            <h4><ContentEditable html={this.props.title_02} onChange={this.props.changeTitle02} /></h4>
            <p><img src={this.props.background_02} className="img-responsive" /></p>
            <p className="tagline-text"><ContentEditable html={this.props.text_02} onChange={this.props.changeText02} /></p>
            <p><a className="btn btn-primary" href="#">
              <ContentEditable html={this.props.button_02} onChange={this.props.changeButton02} />
            </a></p>
          </div>
        </div>
      </div>
      <div key="3" className="col-sm-4">
        <div className="panel panel-default tagline tagline-columns text-center">
          <div className="panel-body">
            <h4><ContentEditable html={this.props.title_03} onChange={this.props.changeTitle03} /></h4>
            <p><img src={this.props.background_03} className="img-responsive" /></p>
            <p className="tagline-text"><ContentEditable html={this.props.text_03} onChange={this.props.changeText03} /></p>
            <p><a className="btn btn-primary" href="#">
              <ContentEditable html={this.props.button_03} onChange={this.props.changeButton03} />
            </a></p>
          </div>
        </div>
      </div>
    </div>`

window.ThemeCtaSimpleDesigner = ThemeCtaSimpleDesigner
