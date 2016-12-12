(function() {
  var RichTextEditor;

  RichTextEditor = React.createClass({
    propTypes: {
      enabled: React.PropTypes.bool,
      html: React.PropTypes.string,
      inline: React.PropTypes.bool,
      update: React.PropTypes.func
    },
    getDefaultProps: function() {
      return {
        inline: false,
        enabled: true
      };
    },
    componentDidMount: function() {
      if (this.props.enabled) {
        return this.enableRichText();
      }
    },
    componentWillUpdate: function(nextProps) {
      if (!this.props.enabled && nextProps.enabled) {
        return this.enableRichText();
      } else if (this.props.enabled && !nextProps.enabled) {
        return this.disableRichText();
      }
    },
    componentWillUnmount: function() {
      if (this.props.enabled) {
        return this.disableRichText();
      }
    },
    enableRichText: function() {
      return $(this.getDOMNode()).summernote(this.summernoteOptions());
    },
    disableRichText: function() {
      return $(this.getDOMNode()).destroy();
    },
    summernoteOptions: function() {
      var defaults;
      defaults = {
        toolbar: this.summernoteToolbar(),
        onCreateLink: function(link) {
          if (link.indexOf('/') !== 0 && link.indexOf('://') === -1) {
            return 'http://' + link;
          } else {
            return link;
          }
        },
        cleaner: {
          notTime: 2400,
          action: 'both',
          newline: '<br>',
          notStyle: 'position:absolute;bottom:0;left:2px;',
          icon: '<i class="note-icon">[Your Button]</i>'
        }
      };
      if (this.props.update) {
        return $.extend({}, defaults, {
          onChange: this.props.update
        });
      } else {
        return defaults;
      }
    },
    summernoteToolbar: function() {
      if (this.props.inline) {
        return [['cleaner', ['cleaner']], ['style', ['bold', 'italic', 'underline', 'superscript', 'strikethrough']], ['align', ['paragraph']], ['clear', ['clear']], ['misc', ['codeview']]];
      } else {
        return [['cleaner', ['cleaner']], ['display', ['style']], ['style', ['bold', 'italic', 'underline', 'superscript', 'strikethrough']], ['insert', ['link']], ['lists', ['ul', 'ol']], ['align', ['paragraph']], ['blocks', ['hr', 'table']], ['clear', ['clear']], ['misc', ['codeview']]];
      }
    },
    render: function() {
      return <div dangerouslySetInnerHTML={{__html: this.props.html}} />;
    }
  });

  window.RichTextEditor = RichTextEditor;

}).call(this);
