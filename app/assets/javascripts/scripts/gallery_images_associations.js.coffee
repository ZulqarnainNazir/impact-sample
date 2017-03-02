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
        unmountedReactComponents = galleryImage.find('[data-react-unmounted-class]')
        unmountedReactComponents.attr 'data-react-class', unmountedReactComponents.data().reactUnmountedClass
        window.ReactRailsUJS.mountComponents "##{galleryImageID}"

      # Trigger the append page function when the add page element is clicked.
      addGalleryImage.on 'click', (e) ->
        e.preventDefault()
        appendGalleryImage()

      # Ensure there are six gallery images.
      if associations.find('.gallery-image-fields').length < 8
        appendGalleryImage() for [1..(8 - associations.find('.gallery-image-fields').length)]

    # Mount all existing gallery images.
    unmountedExistingReactComponents = associations.find('.gallery-image-fields:not(.is-appended) [data-react-unmounted-class]')
    if unmountedExistingReactComponents.length > 0
      unmountedExistingReactComponents.attr 'data-react-class', unmountedExistingReactComponents.data().reactUnmountedClass
      window.ReactRailsUJS.mountComponents '.gallery-image-fields:not(.is-appended)'
