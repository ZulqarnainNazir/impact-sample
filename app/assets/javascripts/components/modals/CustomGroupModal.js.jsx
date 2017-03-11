// const React = '';

const CustomGroupModal = React.createClass({
  getInitialState() {
    // console.log($('#custom_group_uuid').val(), this.props.groups);
    const group = this.props.groups[$('#custom_group_uuid').val];
    return {
      heightOption: 'fitContent',
      width: 1440,
      height: 500,
    };
  },

  componentDidMount() {
    $('#custom_group_uuid').on('change', this.handleGroupChange);
    // $('#hero_position').change(this.handleSelectionChange);
  },

  componentWillUnmount() {
    $('#custom_group_uuid').off('change');
  },

  handleSelectionChange(event) {
    switch (event.target.value) {
      case 'below':
        this.setState({ warning: '' });
        break;
      case 'behind':
        this.setState({
          warning: (
            <div className="alert alert-warning alert-dismissable">
              <button
                aria-hidden="true"
                data-dismiss="alert"
                className="close"
                type="button"
              >×</button>
            <strong>Caution:</strong> This option has trouble with some header theme settings
            </div>
          ),
        });
        break;
      default:
        break;
    }
  },

  handleGroupChange(event) {
    const group = this.props.groups[event.target.value]
    if (group) {
      if (parseInt(group.height) > 0) {
        this.setState({
          heightOption: 'fixedHeight',
          width: '',
          height: parseInt(group.height),
        });
      } else if (group.aspect_ratio) {
        if (parseInt(group.aspect_ratio.height) > 0 &&
            parseInt(group.aspect_ratio.width) > 0) {
          this.setState({
            heightOption: 'maintainAspectRatio',
            width: parseInt(group.aspect_ratio.width),
            height: parseInt(group.aspect_ratio.height),
          });
        }
      }
    } else {
      this.setState({
        heightOption: '',
        width: '',
        height: '',
      });
    }
  },

  toggleHeightOption(event) {
    if (event.target.value === 'maintainAspectRatio') {
      this.setState({
        heightOption: event.target.value,
        width: this.state.width || 1140,
        height: this.state.height || 500,
      });
    } else {
      this.setState({ heightOption: event.target.value });
    }
  },

  handleWidthChange(event) {
    this.setState({ width: event.target.value });
  },

  handleHeightChange(event) {
    this.setState({ height: event.target.value });
  },

  resetCustomGroup(event) {
    this.setState({
      heightOption: '',
      width: '',
      height: '',
      warning: '',
    });
    groupHelpers.resetCustomGroup(event);
  },

  renderHeightOptions() {
    switch (this.state.heightOption) {
      case 'fitContent':
        return '';
      case 'fixedHeight':
        return (
          <div className="form-group">
            <label htmlFor="custom_group_height" className="control-label">
              Height <small>in Pixels</small>
            </label>
            <input type="text" id="custom_group_height" className="form-control" value={this.state.height} onChange={this.handleHeightChange} />
          </div>
        );
      case 'maintainAspectRatio':
        return (
          <div className="form-group row">
            <label className="col-sm-4" htmlFor="custom_group_aspect_ratio_width">
              Image Width <small>In pixels</small>
              <input
                id="custom_group_aspect_ratio_width"
                type="number"
                className="form-control"
                placeholder="1140px Min"
                value={this.state.width}
                onChange={this.handleWidthChange}
              />
            </label>
            <label className="col-sm-4" htmlFor="custom_group_aspect_ratio_height">
              Image Height <small>In pixels</small>
              <input
                id="custom_group_aspect_ratio_height"
                type="number"
                className="form-control"
                value={this.state.height}
                onChange={this.handleHeightChange}
              />
            </label>
            <label htmlFor="custom_group_aspect_ratio" className="control-label col-sm-4">
              Aspect Ratio
              <input
                type="number"
                id="custom_group_aspect_ratio"
                className="form-control"
                disabled
                value={this.state.height / this.state.width}
              />
            </label>
          </div>
        );
      default:
        return <div />;
    }
  },

  render() {
    return (
      <div id="custom_group_modal" className="modal fade">
        <input id="custom_group_uuid" type="hidden" />
        <div className="modal-dialog">
          <div className="modal-content">
            <div className="modal-header">
              <span className="close" data-dismiss="modal">&times;</span>
              <p className="h4 modal-title">Custom Group Settings</p>
            </div>
            <div className="modal-body">
              <div className="form-group">
                <label htmlFor="custom_group_custom_class" className="control-label">
                  Set a Custom Class
                </label>
                <input type="text" id="custom_group_custom_class" className="form-control" />
              </div>

              <div id="custom_group_height_fields">
                <input type="hidden" id="custom_group_height_option" value={this.state.heightOption} />
                <div className="form-group">
                  <div className="radio">
                    <label className="control-label">
                      <input
                        id="fit-content-radio"
                        type="radio"
                        value="fitContent"
                        onChange={this.toggleHeightOption}
                        checked={this.state.heightOption === 'fitContent'}
                      />Fit Content <small>(Warning: When used with Carousels this may cause page to jump)</small>
                    </label>
                  </div>
                  <div className="radio">
                    <label className="control-label">
                      <input
                        id="fixed-height-radio"
                        type="radio"
                        value="fixedHeight"
                        onChange={this.toggleHeightOption}
                        checked={this.state.heightOption === 'fixedHeight'}
                      />Set Fixed Hero Height in Pixels
                    </label>
                  </div>
                  <div className="radio">
                    <label className="control-label">
                      <input
                        id="aspect-ratio-radio"
                        type="radio"
                        value="maintainAspectRatio"
                        onChange={this.toggleHeightOption}
                        checked={this.state.heightOption === 'maintainAspectRatio'}
                      />Maintain aspect ratio on mobile <small>(Be careful that text content doesn't overflow image).</small>
                    </label>
                  </div>
                </div>
                {this.renderHeightOptions()}
              </div>

              <div className="form-group" id="hero_position_fields">
                <label
                  htmlFor="hero_position"
                  className="control-label"
                >Position With Header</label>
                <div>
                  <select
                    ref="selectpicker"
                    id="hero_position"
                    className="form-control"
                    defaultValue="false"
                    onChange={this.handleSelectionChange}
                  >
                    <option key="below" value="below">Below Header</option>
                    <option key="behind" value="behind">Behind Header</option>
                  </select>
                </div>
                {this.state.warning}
              </div>
            </div>
            <div className="modal-footer">
              <button
                className="btn btn-default"
                data-dismiss="modal"
                onClick={this.resetCustomGroup}
              >Cancel</button>
              <button
                className="btn btn-primary"
                data-dismiss="modal" onClick={this.props.updateCustomGroup}
              >Save</button>
            </div>
          </div>
        </div>
      </div>
    );
  },
});

CustomGroupModal.propTypes = {
  updateCustomGroup: React.PropTypes.func.isRequired,
};

// window.CustomGroupModal = CustomGroupModal
