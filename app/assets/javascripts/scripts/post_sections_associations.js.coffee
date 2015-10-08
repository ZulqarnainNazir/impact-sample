$ = jQuery

$.fn.postSectionsAssociations = ->
  this.each (index, associations) ->
    associations = $(associations)

    # Add "will-destroy" class to all checked destroy inputs.
    associations.find('input[name*="_destroy"]:checked').closest('.post-section-fields').addClass('will-destroy')

    # Toggle "will-destroy" class on every change of destroy inputs.
    associations.on 'change', 'input[name*="_destroy"]', ->
      $(this).closest('.post-section-fields').toggleClass('will-destroy')

    # Remove all newly appended post sections, retaining the last.
    appendedPostSection = associations.find('.post-section-fields.is-appended').remove().last()

    # Proceed only if an appended post section was found.
    if appendedPostSection.length is 1

      # Define an add post section element.
      addPostSection = $('<a href="#" class="btn btn-default"><i class="fa fa-plus-circle"></i> Add Another Section</a>')

      # Append the add post section element in a paragraph after the associations.
      $('<p>').append(addPostSection).insertAfter associations

      # Define a function to append a new post section to the container.
      appendPostSection = ->
        postSectionImageKey = 100000 + Math.floor(Math.random() * 100000000)
        postSectionImageID = "post-section-#{postSectionImageKey}"
        postSectionImage = $(appendedPostSection.clone()[0].outerHTML.replace(/98765432101/g, postSectionImageKey))
        postSectionImage.attr 'id', postSectionImageID
        associations.append postSectionImage
        postSectionImage.find('textarea').wysihtmlEditor()
        unmountedReactComponents = postSectionImage.find('[data-react-unmounted-class]')
        unmountedReactComponents.attr 'data-react-class', unmountedReactComponents.data().reactUnmountedClass
        window.ReactRailsUJS.mountComponents "##{postSectionImageID}"

      # Trigger the append page function when the add page element is clicked.
      addPostSection.on 'click', (e) ->
        e.preventDefault()
        appendPostSection()

      # Add the first post section if none are present.
      if associations.find('.post-section-fields').length is 0
        appendPostSection()

    # Enable the WYSIHTML Editor on all existing post sections.
    associations.find('.post-section-fields:not(.is-appended) textarea').wysihtmlEditor()

    # Mount all existing post sections.
    unmountedExistingReactComponents = associations.find('.post-section-fields:not(.is-appended) [data-react-unmounted-class]')
    if unmountedExistingReactComponents.length > 0
      unmountedExistingReactComponents.attr 'data-react-class', unmountedExistingReactComponents.data().reactUnmountedClass
      window.ReactRailsUJS.mountComponents '.post-section-fields:not(.is-appended)'

    updateAssociations = ->
      associations.find('> li').each (i, item) ->
        updateAssociationsFields(i, item, null)

    updateAssociationsFields = (i, item, parent) ->
      item = $(item)
      item.find('> .post-section-tolerance .post-section-hidden-fields > input[name*="position"]').val(i)
      if parent
        item.find('> .post-section-tolerance .post-section-hidden-fields > input[name*="parent_key"]').val(parent.data().key)
      else
        item.find('> .post-section-tolerance .post-section-hidden-fields > input[name*="parent_key"]').val('')
      item.find('> ol > li').each (i, child) ->
        updateAssociationsFields(i, child, item)

    # Enable nested sortable
    associations.nestedSortable
      expandOnHover: 400
      forcePlaceholderSize: true
      handle: '> .post-section-tolerance > .post-section-handle'
      helper: 'clone'
      items: '.post-section-fields'
      maxLevels: 3
      opacity: 0.5
      placeholder: 'placeholder'
      revert: 100
      startCollapsed: false
      tabSize: 20
      tolerance: 'pointer'
      toleranceElement: '> .post-section-tolerance'
      update: updateAssociations

    # Cycle through the previous post section kinds.
    associations.on 'click', '.post-section-fields-prev', (e) ->
      fields = $(e.target).closest('.post-section-fields')
      if fields.hasClass('full_image')
        fields.removeClass('full_image').addClass('full_text')
        fields.find('> .post-section-tolerance iframe').width fields.width() - 60
        fields.find('> .post-section-tolerance .post-section-fields-kind').text 'Full Text'
        fields.find('> .post-section-tolerance .post-section-hidden-fields input[name*="kind"]').val('full_text')
      else if fields.hasClass('full_text')
        fields.removeClass('full_text').addClass('image_left')
        fields.find('> .post-section-tolerance iframe').width fields.find('.col-sm-7').width() - 26
        fields.find('> .post-section-tolerance .post-section-fields-kind').text 'Image Left'
        fields.find('> .post-section-tolerance .post-section-hidden-fields input[name*="kind"]').val('image_left')
      else if fields.hasClass('image_left')
        fields.removeClass('image_left').addClass('image_right')
        fields.find('> .post-section-tolerance iframe').width fields.find('.col-sm-7').width() - 26
        fields.find('> .post-section-tolerance .post-section-fields-kind').text 'Image Right'
        fields.find('> .post-section-tolerance .post-section-hidden-fields input[name*="kind"]').val('image_right')
      else
        fields.removeClass('image_right').addClass('full_image')
        fields.find('> .post-section-tolerance .post-section-fields-kind').text 'Full Image'
        fields.find('> .post-section-tolerance .post-section-hidden-fields input[name*="kind"]').val('full_image')

    # Cycle through the next post section kinds.
    associations.on 'click', '.post-section-fields-next', (e) ->
      fields = $(e.target).closest('.post-section-fields')
      if fields.hasClass('image_right')
        fields.removeClass('image_right').addClass('image_left')
        fields.find('> .post-section-tolerance iframe').width fields.find('.col-sm-7').width() - 26
        fields.find('> .post-section-tolerance .post-section-fields-kind').text 'Image Left'
        fields.find('> .post-section-tolerance .post-section-hidden-fields input[name*="kind"]').val('image_left')
      else if fields.hasClass('image_left')
        fields.removeClass('image_left').addClass('full_text')
        fields.find('> .post-section-tolerance iframe').width fields.width() - 60
        fields.find('> .post-section-tolerance .post-section-fields-kind').text 'Full Text'
        fields.find('> .post-section-tolerance .post-section-hidden-fields input[name*="kind"]').val('full_text')
      else if fields.hasClass('full_text')
        fields.removeClass('full_text').addClass('full_image')
        fields.find('> .post-section-tolerance .post-section-fields-kind').text 'Full Image'
        fields.find('> .post-section-tolerance .post-section-hidden-fields input[name*="kind"]').val('full_image')
      else
        fields.removeClass('full_image').addClass('image_right')
        fields.find('> .post-section-tolerance iframe').width fields.find('.col-sm-7').width() - 26
        fields.find('> .post-section-tolerance .post-section-fields-kind').text 'Image Right'
        fields.find('> .post-section-tolerance .post-section-hidden-fields input[name*="kind"]').val('image_right')
