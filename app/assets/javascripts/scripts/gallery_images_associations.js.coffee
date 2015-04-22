$ = jQuery

$.fn.galleryImagesAssociations = ->
  this.each (index, associations) ->
    associations = $(associations)

    # Add "will-destroy" class to all checked destroy inputs.
    associations.find('input[name*="_destroy"]:checked').closest('.gallery-image-fields').addClass('will-destroy')

    # Toggle "will-destroy" class on every change of destroy inputs.
    associations.on 'change', 'input[name*="_destroy"]', ->
      $(this).closest('.gallery-image-fields').toggleClass('will-destroy')

    # Remove all newly appended gallery images, retaining the last.
    appendedGalleryImage = associations.find('.gallery-image-fields.is-appended').remove().last()

    # Proceed only if an appended gallery image was found.
    if appendedGalleryImage.length is 1

      # Define an add gallery image element.
      addGalleryImage = $('<a href="#" class="btn btn-sm btn-default"><i class="fa fa-plus-circle"></i> Add Gallery Image</a>')

      # Append the add gallery image element in a paragraph after the associations.
      $('<p>').append(addGalleryImage).insertAfter associations

      # Define a function to append a new gallery image to the container.
      appendGalleryImage = ->
        galleryImageKey = 100000 + Math.floor(Math.random() * 100000000)
        galleryImageID = "gallery-image-#{galleryImageKey}"
        galleryImage = $(appendedGalleryImage.clone()[0].outerHTML.replace(/98765432101/g, galleryImageKey))
        galleryImage.attr 'id', galleryImageID
        associations.append galleryImage
        galleryImageID

      # Trigger the append page function when the add page element is clicked.
      addGalleryImage.on 'click', (e) ->
        e.preventDefault()
        galleryImageID = appendGalleryImage()
        window.ReactRailsUJS.mountComponents()

      # Trigger the append page function immediately if there are no exsting rows.
      if associations.find('.gallery-image-fields').length is 0
        appendGalleryImage()
