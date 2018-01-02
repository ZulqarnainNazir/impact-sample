CalendarSettingsModal = React.createClass

  componentWillMount: ->

    if !this.props.calendarWidgets
      this.state = { value: null }
      return;

    firstEmbed = this.props.calendarWidgets[0]

    this.state = { value: firstEmbed && firstEmbed.id }

  handleChange: (event) ->
    this.setState({ value: event.target.value });

  renderOptions: ->
    if !this.props.calendarWidgets
      return

    return this.props.calendarWidgets.map (item) ->
      return `<option key={item.id} value={item.id}>{item.name}</option>`

  render: ->
    `<div id="calendar_settings_modal" className="modal fade">
      <input id="calendar_settings_group_uuid" type="hidden" />
      <input id="calendar_settings_block_uuid" type="hidden" />
      <div className="modal-dialog">
        <div className="modal-content">
          <div className="modal-header">
            <span className="close" data-dismiss="modal">&times;</span>
            <p className="h4 modal-title">Select Calendar Embed or Add New</p>
          </div>
          <div className="modal-body">
            <div className="form-group">
              <label htmlFor="calendar_embed_id" className="control-label">Embed</label>
              <div>
                <select id="calendar_embed_id" className="form-control" value={this.state.value} onChange={this.handleChange}>
                  {this.renderOptions()}
                </select>
              </div>

              <div className="m-t-1">
                <a href={this.props.newCalendarPath} target="_blank">
                  <i className="fa fa-plus-circle m-r-half"></i>
                  Add New
                </a>
              </div>
            </div>
            <hr />
          </div>
          <div className="modal-footer">
            <span className="btn btn-default" data-dismiss="modal">Cancel</span>
            <span className="btn btn-primary" data-dismiss="modal" onClick={this.props.updateCalendarSettings}>Save</span>
          </div>
        </div>
      </div>
    </div>;`


window.CalendarSettingsModal = CalendarSettingsModal
