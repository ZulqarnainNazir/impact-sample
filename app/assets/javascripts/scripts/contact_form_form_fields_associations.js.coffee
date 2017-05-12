$ = jQuery

$.fn.ContactFormFormFieldsAssociations = ->
  this.each (index, associations) ->
    associations = $(associations)

    # Add "will-destroy" class to all checked destroy inputs.
    associations.find('input[name*="_destroy"]:checked').closest('.contact-form-form-field-fields').addClass('will-destroy')

    # Toggle "will-destroy" class on every change of destroy inputs.
    associations.on 'change', 'input[name*="_destroy"]', ->
      $(this).closest('.contact-form-form-field-fields').toggleClass('will-destroy')

    # Remove all newly appended post sections, retaining the last.
    appendedContactFormFormField = associations.find('.contact-form-form-field-fields.is-appended').remove().last()

    updateAssociations = ->
      associations.find('> li').each (i, item) ->
        updateAssociationsFields(i, item, null)

    updateAssociationsFields = (i, item) ->
      item = $(item)
      item.find('> .contact-form-form-field-tolerance .contact-form-form-field-hidden-fields > input[name*="position"]').val(i)

    # Proceed only if an appended post section was found.
    if appendedContactFormFormField.length is 1

      # Define an add post section element.
      #addContactFormFormField = $('<a href="#" class="btn btn-default add-category"><i class="fa fa-plus-circle"></i> Add Another Category/Label</a>')

      # Append the add post section element in a paragraph after the associations.
      #$('<p>').append(addContactFormFormField).insertAfter associations

      # Define a function to append a new post section to the container.
      appendContactFormFormField = (first = false) ->
        contactFormFormFieldItemKey = 100000 + Math.floor(Math.random() * 100000000)
        contactFormFormFieldItemID = "post-section-#{contactFormFormFieldItemKey}"
        contactFormFormFieldItem = $(appendedContactFormFormField.clone()[0].outerHTML.replace(/98765432101/g, contactFormFormFieldItemKey))
        contactFormFormFieldItem.attr 'id', contactFormFormFieldItemID
        associations.append contactFormFormFieldItem
        unmountedReactComponents = contactFormFormFieldItem.find('[data-react-unmounted-class]')
        if unmountedReactComponents.length > 0
          unmountedReactComponents.attr 'data-react-class', unmountedReactComponents.data().reactUnmountedClass
          window.ReactRailsUJS.mountComponents "##{contactFormFormFieldItemID}"
        updateAssociations()

      # Trigger the append page function when the add page element is clicked.
      #addContactFormFormField.on 'click', (e) ->
      #  e.preventDefault()
      #  appendContactFormFormField()

      # Add the first post section if none are present.
      if associations.find('.contact-form-form-field-fields').length is 0
        appendContactFormFormField(true)

    # Mount all existing post sections.
    unmountedExistingReactComponents = associations.find('.contact-form-form-field-fields:not(.is-appended) [data-react-unmounted-class]')
    if unmountedExistingReactComponents.length > 0
      unmountedExistingReactComponents.attr 'data-react-class', unmountedExistingReactComponents.data().reactUnmountedClass
      window.ReactRailsUJS.mountComponents '.contact-form-form-field-fields:not(.is-appended)'


    # Enable nested sortable
    associations.nestedSortable
      expandOnHover: 400
      forcePlaceholderSize: true
      handle: '> .contact-form-form-field-tolerance > .contact-form-form-field-handle'
      helper: 'clone'
      items: '.contact-form-form-field-fields'
      maxLevels: 1
      opacity: 0.5
      placeholder: 'placeholder'
      revert: 100
      startCollapsed: false
      tabSize: 20
      protectRoot: true
      tolerance: 'pointer'
      toleranceElement: '> .contact-form-form-field-tolerance'
      update: updateAssociations
