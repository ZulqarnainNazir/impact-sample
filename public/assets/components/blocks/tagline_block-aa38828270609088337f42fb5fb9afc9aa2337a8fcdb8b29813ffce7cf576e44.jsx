(function() {
  var TaglineBlock;

  TaglineBlock = React.createClass({
    render: function() {
      return <div className="webpage-tagline">
      <div className={this.wellClass()} style={{textAlign: this.props.theme}}>
        <div className="lead">
          <RichTextEditor enabled={this.props.editing && this.props.richText} html={this.props.text} inline={true} update={this.props.updateText} />
        </div>
        <BlockLinkButton {...this.props} />
      </div>
    </div>;
    },
    wellClass: function() {
      switch (this.props.well_style) {
        case 'transparent':
          return 'well well-transparent';
        case 'dark':
          return 'well well-dark';
        default:
          return 'well well-light';
      }
    }
  });

  window.TaglineBlock = TaglineBlock;

}).call(this);
