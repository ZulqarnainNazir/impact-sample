$ = jQuery

$.fn.openingsAssociations = ->
  this.each (index, table) ->
    table = $(table)

    # Add "will-destroy" class to all checked destroy inputs.
    table.find('input[name*="_destroy"]:checked').closest('tr').addClass('will-destroy')

    # Toggle "will-destroy" class on every change of destroy inputs.
    table.on 'change', 'input[name*="_destroy"]', ->
      $(this).closest('tr').toggleClass('will-destroy')

    # Remove all newly appended openings, retaining the last.
    appendedOpening = table.find('tr.is-appended').remove().last()

    # Proceed only if an appended opening was found.
    if appendedOpening.length is 1

      # Define an add opening element.
      addOpening = $('<a href="#" class="btn btn-link"><i class="fa fa-plus-circle"></i> Add Opening</a>')

      # Append the add opening element in a paragraph after the table.
      $('<p>').append(addOpening).insertAfter table

      # Define a function to append a new opening to the table.
      appendOpening = ->
        table.append appendedOpening.clone()[0].outerHTML.replace(/98765432101/g, 100000 + Math.floor(Math.random() * 100000000))

      # Trigger the append opening function when the add opening element is clicked.
      addOpening.on 'click', (e) ->
        e.preventDefault()
        appendOpening()

      # Trigger the append opening function immediately if there are no exsting rows.
      if table.find('tbody tr').length is 0
        appendOpening()
