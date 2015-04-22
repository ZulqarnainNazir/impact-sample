$ = jQuery

$.fn.projectImagesAssociations = ->
  this.each (index, associations) ->
    associations = $(associations)

    # Add "will-destroy" class to all checked destroy inputs.
    associations.find('input[name*="_destroy"]:checked').closest('.project-image-fields').addClass('will-destroy')

    # Toggle "will-destroy" class on every change of destroy inputs.
    associations.on 'change', 'input[name*="_destroy"]', ->
      $(this).closest('.project-image-fields').toggleClass('will-destroy')

    # Remove all newly appended project images, retaining the last.
    appendedProjectImage = associations.find('.project-image-fields.is-appended').remove().last()

    # Proceed only if an appended project image was found.
    if appendedProjectImage.length is 1

      # Define an add project image element.
      addProjectImage = $('<a href="#" class="btn btn-sm btn-default"><i class="fa fa-plus-circle"></i> Add Project Image</a>')

      # Append the add project image element in a paragraph after the associations.
      $('<p>').append(addProjectImage).insertAfter associations

      # Define a function to append a new project image to the container.
      appendProjectImage = ->
        projectImageKey = 100000 + Math.floor(Math.random() * 100000000)
        projectImageID = "project-image-#{projectImageKey}"
        projectImage = $(appendedProjectImage.clone()[0].outerHTML.replace(/98765432101/g, projectImageKey))
        projectImage.attr 'id', projectImageID
        associations.append projectImage
        projectImageID

      # Trigger the append page function when the add page element is clicked.
      addProjectImage.on 'click', (e) ->
        e.preventDefault()
        projectImageID = appendProjectImage()
        window.ReactRailsUJS.mountComponents()

      # Trigger the append page function immediately if there are no exsting rows.
      if associations.find('.project-image-fields').length is 0
        appendProjectImage()
