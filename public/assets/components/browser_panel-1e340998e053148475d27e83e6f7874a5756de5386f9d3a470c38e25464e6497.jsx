(function() {
  var BrowserPanel;

  BrowserPanel = React.createClass({
    propTypes: {
      browserButtonsSrc: React.PropTypes.string.isRequired,
      editing: React.PropTypes.bool,
      toggleEditing: React.PropTypes.func
    },
    render: function() {
      return <div className="panel panel-default" style={{marginLeft: -1, marginRight: -1, boxShadow: '0 0 1em rgba(0,0,0,0.1), 0 0 0.2em rgba(0,0,0,0.2)'}}>
      <div className="panel-heading">
        <img src={this.props.browserButtonsSrc} alt="" />
      </div>
      {this.props.children}
    </div>;
    }
  });

  window.BrowserPanel = BrowserPanel;

}).call(this);
