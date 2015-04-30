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

        # Remove all newly appended line images, retaining the last.
        appendedLineImage = line.find('.line-image-fields.is-appended').remove().last()

        # Proceed only if an appended line image was found.
        if appendedLineImage.length is 1

          # Define an add line image element.
          addLineImage = $('<a href="#" class="btn btn-sm btn-default"><i class="fa fa-plus-circle"></i> Add Image</a>')

          # Append the add line image element in a paragraph after the line.
          $('<p>').append(addLineImage).insertAfter line.find('.line-images-associations')

          # Define a function to append a new line image to the line.
          appendLineImage = ->
            lineImageKey = 100000 + Math.floor(Math.random() * 100000000)
            lineImageID = "line-#{lineImageKey}"
            lineImage = $(appendedLineImage.clone()[0].outerHTML.replace(/98765432102/g, lineImageKey))
            lineImage.attr 'id', lineImageID
            line.find('.line-images-associations').append lineImage
            unmountedReactComponents = lineImage.find('[data-react-unmounted-class]')
            unmountedReactComponents.attr 'data-react-class', unmountedReactComponents.data().reactUnmountedClass
            window.ReactRailsUJS.mountComponents "##{lineImageID}"

          # Trigger the append line image function when the add line element is clicked.
          addLineImage.on 'click', (e) ->
            e.preventDefault()
            appendLineImage()

          # Add the first line image if none are present.
          if line.find('.line-image-fields').length is 0
            appendLineImage()

      # Trigger the append line function when the add line element is clicked.
      addLine.on 'click', (e) ->
        e.preventDefault()
        appendLine()

      # Add the first line if none are present.
      if associations.find('.line-fields').length is 0
        appendLine()

    # For each existing line image.
    associations.find('.line-fields:not(.is-appended)').each (index, line) ->
      line = $(line)

      # Remove all newly appended line images, retaining the last.
      appendedLineImage = line.find('.line-image-fields.is-appended').remove().last()

      # Proceed only if an appended line image was found.
      if appendedLineImage.length is 1

        # Define an add line image element.
        addLineImage = $('<a href="#" class="btn btn-sm btn-default"><i class="fa fa-plus-circle"></i> Add Image</a>')

        # Append the add line image element in a paragraph after the line.
        $('<p>').append(addLineImage).insertAfter line.find('.line-images-associations')

        # Define a function to append a new line image to the line.
        appendLineImage = ->
          lineImageKey = 100000 + Math.floor(Math.random() * 100000000)
          lineImageID = "line-#{lineImageKey}"
          lineImage = $(appendedLineImage.clone()[0].outerHTML.replace(/98765432102/g, lineImageKey))
          lineImage.attr 'id', lineImageID
          line.find('.line-images-associations').append lineImage
          unmountedReactComponents = lineImage.find('[data-react-unmounted-class]')
          unmountedReactComponents.attr 'data-react-class', unmountedReactComponents.data().reactUnmountedClass
          window.ReactRailsUJS.mountComponents "##{lineImageID}"

        # Trigger the append line image function when the add line element is clicked.
        addLineImage.on 'click', (e) ->
          e.preventDefault()
          appendLineImage()

        # Add the first line image if none are present.
        if line.find('.line-image-fields').length is 0
          appendLineImage()

    # Enable the WYSIHTML Editor on all existing lines.
    associations.find('.line-fields:not(.is-appended) textarea').wysihtmlEditor()

    # Mount all existing line images.
    unmountedExistingReactComponents = associations.find('.line-image-fields:not(.is-appended) [data-react-unmounted-class]')
    if unmountedExistingReactComponents.length > 0
      unmountedExistingReactComponents.attr 'data-react-class', unmountedExistingReactComponents.data().reactUnmountedClass
      window.ReactRailsUJS.mountComponents '.line-image-fields:not(.is-appended)'
