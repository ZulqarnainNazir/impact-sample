$ = jQuery

$.fn.webhostsAssociations = ->
  this.each (index, table) ->
    table = $(table)

    # Add "will-destroy" class to all checked destroy inputs.
    table.find('input[name*="_destroy"]:checked').closest('tr').addClass('will-destroy')

    # Toggle "will-destroy" class on every change of destroy inputs.
    table.on 'change', 'input[name*="_destroy"]', ->
      $(this).closest('tr').toggleClass('will-destroy')

    # Remove all newly appended webhosts, retaining the last.
    appendedWebhost = table.find('tr.is-appended').remove().last()

    # Proceed only if an appended webhost was found.
    if appendedWebhost.length is 1

      # Define an add webhost element.
      addWebhost = $('<a href="#" class="btn btn-link"><i class="fa fa-plus-circle"></i> Add Domain</a>')

      # Append the add webhost element in a paragraph after the table.
      $('<p>').append(addWebhost).insertAfter table

      # Define a function to append a new webhost to the table.
      appendWebhost = ->
        table.append appendedWebhost.clone()[0].outerHTML.replace(/98765432101/g, 100000 + Math.floor(Math.random() * 100000000))

      # Trigger the append webhost function when the add webhost element is clicked.
      addWebhost.on 'click', (e) ->
        e.preventDefault()
        appendWebhost()

      # Trigger the append webhost function immediately if there are no exsting rows.
      if table.find('tbody tr').length is 0
        appendWebhost()
