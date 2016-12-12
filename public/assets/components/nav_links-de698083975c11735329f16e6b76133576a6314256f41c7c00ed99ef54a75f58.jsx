(function() {
  var NavLinks;

  NavLinks = React.createClass({
    propTypes: {
      lineHeight: React.PropTypes.number,
      items: React.PropTypes.arrayOf(React.PropTypes.shape({
        id: React.PropTypes.number.isRequired,
        label: React.PropTypes.string.isRequired,
        cached_children: React.PropTypes.array
      }))
    },
    getDefaultProps: function() {
      return {
        items: []
      };
    },
    render: function() {
      return <ul className={this.props.className}>
      {this.renderItems()}
    </ul>;
    },
    renderItems: function() {
      return this.props.items.map(this.renderItem);
    },
    renderItem: function(item) {
      if (item.kind === 'dropdown') {
        return <li key={item.id} className="dropdown">
        <a href="#" className="dropdown-toggle" data-toggle="dropdown" style={this.style()}>
          {item.label} <span className="caret"> </span>
        </a>
        <ul className="dropdown-menu">
          {this.renderChildren(item.cached_children)}
        </ul>
      </li>;
      } else {
        return <li key={item.id}>
        <a href="#" onClick={this.preventDefault} style={this.style({color: this.props.color})}>
          {item.label}
        </a>
      </li>;
      }
    },
    renderChildren: function(children) {
      return children.map(this.renderChild);
    },
    renderChild: function(child) {
      return <li key={child.id}>
      <a href="#" onClick={this.preventDefault}>
        {child.label}
      </a>
    </li>;
    },
    style: function(defaults) {
      if (this.props.lineHeight && this.props.lineHeight > 20) {
        return $.extend({}, defaults, {
          lineHeight: this.props.lineHeight + "px"
        });
      } else {
        return defaults;
      }
    },
    preventDefault: function(e) {
      return e.preventDefault();
    }
  });

  window.NavLinks = NavLinks;

}).call(this);
