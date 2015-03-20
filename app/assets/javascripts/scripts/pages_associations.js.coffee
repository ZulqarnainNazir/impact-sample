$ = jQuery

$.fn.pagesAssociations = ->
  this.each (index, associations) ->
    associations = $(associations)

    # Add "will-destroy" class to all checked destroy inputs.
    associations.find('input[name*="_destroy"]:checked').closest('.panel').addClass('will-destroy')

    # Toggle "will-destroy" class on every change of destroy inputs.
    associations.on 'change', 'input[name*="_destroy"]', ->
      $(this).closest('.panel').toggleClass('will-destroy')

    # Find the custom pages container.
    container = associations.find('.page-associations-container')

    # Proceed only if the custom pages container was found.
    if container.length is 1
      # Remove all newly appended pages, retaining the last.
      appendedPage = container.find('.panel.is-appended').remove().last()

      # Proceed only if an appended page was found.
      if appendedPage.length is 1

        # Define an add page element.
        addPage = $('<a href="#" class="btn btn-link"><i class="fa fa-plus-circle"></i> Add Custom Page</a>')

        # Append the add page element in a paragraph after the container.
        $('<p>').append(addPage).insertAfter container

        # Define a function to append a new page to the container.
        appendPage = ->
          container.append appendedPage.clone()[0].outerHTML.replace(/98765432101/g, 100000 + Math.floor(Math.random() * 100000000))

        # Trigger the append page function when the add page element is clicked.
        addPage.on 'click', (e) ->
          e.preventDefault()
          appendPage()

        # Trigger the append page function immediately if there are no exsting rows.
        if container.find('tbody tr').length is 0
          appendPage()
