BlockInputLink = React.createClass
  mixins: [React.addons.PureRenderMixin]

  propTypes:
    id: React.PropTypes.func.isRequired
    name: React.PropTypes.func.isRequired
    version: React.PropTypes.string
    label: React.PropTypes.string
    external_url: React.PropTypes.string
    link_type: React.PropTypes.string
    link_id: React.PropTypes.number
    target_blank: React.PropTypes.bool
    no_follow: React.PropTypes.bool
    checkedNone: React.PropTypes.bool
    checkedInternal: React.PropTypes.bool
    checkedExternal: React.PropTypes.bool
    internalWebpages: React.PropTypes.array

  getDefaultProps: ->
    version: 'link_none'
    target_blank: false
    no_follow: false

  componentDidMount: ->
    if $(this.getDOMNode()).find('input[type="radio"]:checked').length is 0
      $(this.refs.none.getDOMNode()).prop('checked', true)
    $(this.getDOMNode()).on 'change', 'input[type="radio"]', this.displayElements
    this.displayElements()

  displayElements: ->
    if $(this.refs.none.getDOMNode()).prop('checked')
      $(this.refs.defaultInputs.getDOMNode()).hide()
      $(this.refs.internalInputs.getDOMNode()).hide()
      $(this.refs.externalInputs.getDOMNode()).hide()
    else if $(this.refs.internal.getDOMNode()).prop('checked')
      $(this.refs.defaultInputs.getDOMNode()).show()
      $(this.refs.internalInputs.getDOMNode()).show()
      $(this.refs.externalInputs.getDOMNode()).hide()
    else
      $(this.refs.defaultInputs.getDOMNode()).show()
      $(this.refs.internalInputs.getDOMNode()).hide()
      $(this.refs.externalInputs.getDOMNode()).show()

  render: ->
    `<div className="panel panel-default">
      <div className="panel-heading">
        <p className="h4 panel-title">Add a Linked Button</p>
      </div>
      <div className="panel-body">
        <div className="radio">
          <label>
            <input ref="none" type="radio" name={this.props.name('link_version')} value="link_none" defaultChecked={this.props.checkedNone} />
            Don‘t include a linked button
          </label>
        </div>
        <div className="radio">
          <label>
            <input ref="internal" type="radio" name={this.props.name('link_version')} value="link_internal" defaultChecked={this.props.checkedInternal} />
            Link to an internal webpage on your site
          </label>
        </div>
        <div className="radio">
          <label>
            <input ref="external" type="radio" name={this.props.name('link_version')} value="link_external" defaultChecked={this.props.checkedExternal} />
            Link to an external webpage
          </label>
        </div>
        <div ref="internalInputs">
          <hr />
          <div className="form-group">
            <input name={this.props.name('link_type')} type="hidden" value="Webpage" />
            <label htmlFor={this.props.id('link_id')} className="control-label">IMPACT Webpage</label>
            <select id={this.props.id('link_id')} name={this.props.name('link_id')} defaultValue={this.props.link_id} className="form-control">
              {this.renderInternalWebpageOptions()}
            </select>
          </div>
        </div>
        <div ref="externalInputs">
          <hr />
          <div className="form-group">
            <label htmlFor={this.props.id('link_external_url')} className="control-label">External URL</label>
            <input id={this.props.id('link_external_url')} name={this.props.name('link_external_url')} defaultValue={this.props.external_url} type="text" className="form-control" />
          </div>
        </div>
        <div ref="defaultInputs">
          <div className="form-group">
            <label htmlFor={this.props.id('link_label')} className="control-label">Button Label</label>
            <input id={this.props.id('link_label')} name={this.props.name('link_label')} defaultValue={this.props.label} type="text" className="form-control" />
          </div>
          <div className="checkbox">
            <input type="hidden" name={this.props.name('link_target_blank')} value="0" />
            <label>
              <input key="targetBlank" type="checkbox" name={this.props.name('link_target_blank')} value="1" defaultChecked={this.props.target_blank} />
              Open link in a new window?
            </label>
          </div>
          <div key="noFollow" className="checkbox">
            <input type="hidden" name={this.props.name('link_no_follow')} value="0" />
            <label>
              <input type="checkbox" name={this.props.name('link_no_follow')} value="1" defaultChecked={this.props.no_follow} />
              Add "no-follow" to the link?
            </label>
          </div>
        </div>
      </div>
    </div>`

  renderInternalWebpageOptions: ->
    this.props.internalWebpages.map (webpage) ->
      `<option key={webpage.id} value={webpage.id}>{webpage.name}</option>`

window.BlockInputLink = BlockInputLink
