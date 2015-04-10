$ = jQuery

$.fn.wysihtmlEditor = ->
  this.each (index, editor) ->
    editor = $(editor)

    wysihtmlEditorTemplates =
      editorHeadings: ->
        """
        <li class="dropdown">
          <a aria-expanded="true" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
            <span class="fa fa-font"></span>
            <span class="current-font">Normal text</span>
            <b class="caret"></b>
          </a>
          <ul class="dropdown-menu">
            <li><a unselectable="on" href="javascript:;" data-wysihtml5-command="formatBlock" data-wysihtml5-command-value="p" tabindex="-1">Normal text</a></li>
            <li><a unselectable="on" href="javascript:;" data-wysihtml5-command="formatBlock" data-wysihtml5-command-value="h2" tabindex="-1">Heading 2</a></li>
            <li><a unselectable="on" href="javascript:;" data-wysihtml5-command="formatBlock" data-wysihtml5-command-value="h3" tabindex="-1">Heading 3</a></li>
            <li><a unselectable="on" href="javascript:;" data-wysihtml5-command="formatBlock" data-wysihtml5-command-value="h4" tabindex="-1">Heading 4</a></li>
          </ul>
        </li>
        """

      editorEmphasis: ->
        """
        <li>
          <div class="btn-group">
            <a unselectable="on" href="javascript:;" class="btn btn-default" data-wysihtml5-command="bold" title="Bold – CTRL+B" tabindex="-1"><span class="fa fa-bold"></span></a>
            <a unselectable="on" href="javascript:;" class="btn btn-default" data-wysihtml5-command="italic" title="Italic – CTRL+I" tabindex="-1"><span class="fa fa-italic"></span></a>
            <a unselectable="on" href="javascript:;" class="btn btn-default" data-wysihtml5-command="underline" title="Underline – CTRL+U" tabindex="-1"><span class="fa fa-underline"></span></a>
            <a unselectable="on" href="javascript:;" class="btn btn-default" data-wysihtml5-command="small" title="Small – CTRL+S" tabindex="-1"><span class="fa fa-text-height"></span></a>
            <a unselectable="on" href="javascript:;" class="btn btn-default" data-wysihtml5-command="superscript" title="Superscript" tabindex="-1"><span class="fa fa-superscript"></span></a>
          </div>
        </li>
        """

      editorBlockquote: ->
        """
        <li>
          <a unselectable="on" href="javascript:;" class="btn btn-default" data-wysihtml5-command="formatBlock" data-wysihtml5-command-value="blockquote" data-wysihtml5-display-format-name="false" tabindex="-1"><span class="fa fa-quote-left"></span></a>
        </li>
        """

      editorLists: ->
        """
        <li>
          <div class="btn-group">
            <a unselectable="on" href="javascript:;" class="btn btn-default" data-wysihtml5-command="insertUnorderedList" title="Unordered List" tabindex="-1"><span class="fa fa-list-ul"></span></a>
            <a unselectable="on" href="javascript:;" class="btn btn-default" data-wysihtml5-command="insertOrderedList" title="Ordered List" tabindex="-1"><span class="fa fa-list-ol"></span></a>
          </div>
        </li>
        """

      editorAlignment: ->
        """
        <li>
          <div class="btn-group">
            <a unselectable="on" href="javascript:;" class="btn btn-default" data-wysihtml5-command="justifyLeft" title="Align Left" tabindex="-1"><span class="fa fa-align-left"></span></a>
            <a unselectable="on" href="javascript:;" class="btn btn-default" data-wysihtml5-command="justifyCenter" title="Align Center" tabindex="-1"><span class="fa fa-align-center"></span></a>
            <a unselectable="on" href="javascript:;" class="btn btn-default" data-wysihtml5-command="justifyRight" title="Align Right" tabindex="-1"><span class="fa fa-align-right"></span></a>
          </div>
        </li>
        """

    editor.wysihtml5 'deepExtend',
      customTemplates: wysihtmlEditorTemplates
      parserRules:
        classes:
          'wysiwyg-text-align-left': 1
          'wysiwyg-text-align-center': 1
          'wysiwyg-text-align-right': 1
      toolbar:
        fa: true
        emphasis: false
        lists: false
        html: false
        color: false
        blockquote: false
        link: false
        image: false
        'font-styles': false
        editorHeadings: true
        editorEmphasis: true
        editorBlockquote: true
        editorLists: true
        editorAlignment: true
      stylesheets: ['/wysihtml5.css']
