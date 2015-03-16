ThemeAboutLeftDesigner = React.createClass
  render: ->
    `<div>
      <div className="container">
        <article>
          <header className="page-header">
            <h1>About</h1>
          </header>
        </article>
      </div>
      <div className="container">
        <article>
          <div className="row">
            <section className="col-sm-4" style={{marginTop: 40}}>
              <img className="img-responsive" style={{width: '100%'}} src={this.props.background} />
            </section>
            <section className="col-sm-8">
              <header className="page-header">
                <h2><ContentEditable html={this.props.heading} onChange={this.props.changeHeading} /></h2>
                <p><ContentEditable html={this.props.subheading} onChange={this.props.changeSubheading} /></p>
              </header>
              <p><ContentEditable html={this.props.text} onChange={this.props.changeText} /></p>
            </section>
          </div>
        </article>
      </div>
    </div>`

window.ThemeAboutLeftDesigner = ThemeAboutLeftDesigner
