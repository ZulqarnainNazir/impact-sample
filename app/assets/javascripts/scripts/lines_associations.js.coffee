$ = jQuery

$.fn.linesAssociations = ->
  this.each (index, associations) ->
    associations = $(associations)

    # Add "will-destroy" class to all checked destroy inputs.
    associations.find('input[name*="_destroy"]:checked').closest('.line-fields').addClass('will-destroy')

    # Toggle "will-destroy" class on every change of destroy inputs.
    associations.on 'change', 'input[name*="_destroy"]', ->
      $(this).closest('.line-fields').toggleClass('will-destroy')

    # Remove all newly appended lines, retaining the last.
    appendedLine = associations.find('.line-fields.is-appended').remove().last()

    # Proceed only if an appended line was found.
    if appendedLine.length is 1

      # Define an add line element.
      addLine = $('<a href="#" class="btn btn-sm btn-default"><i class="fa fa-plus-circle"></i> Add Product/Service</a>')

      # Append the add line element in a paragraph after the associations.
      $('<p>').append(addLine).insertAfter associations

      # Define a function to append a new line to the container.
      appendLine = ->
        lineKey = 100000 + Math.floor(Math.random() * 100000000)
        lineID = "line-#{lineKey}"
        line = $(appendedLine.clone()[0].outerHTML.replace(/98765432101/g, lineKey))
        line.attr 'id', lineID
        associations.append line
        line.find('textarea').wysihtmlEditor()

      # Trigger the append page function when the add page element is clicked.
      addLine.on 'click', (e) ->
        e.preventDefault()
        appendLine()

      # Add the first line if none are present.
      if associations.find('.line-fields').length is 0
        appendLine()

    # Enable the WYSIHTML Editor on all existing lines.
    associations.find('.line-fields:not(.is-appended) textarea').wysihtmlEditor()
