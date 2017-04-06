$ = jQuery

$.fn.CompanyListCategoriesAssociations = ->
  this.each (index, associations) ->
    associations = $(associations)

    # Add "will-destroy" class to all checked destroy inputs.
    associations.find('input[name*="_destroy"]:checked').closest('.company-list-category-fields').addClass('will-destroy')

    # Toggle "will-destroy" class on every change of destroy inputs.
    associations.on 'change', 'input[name*="_destroy"]', ->
      $(this).closest('.company-list-category-fields').toggleClass('will-destroy')

    # Remove all newly appended post sections, retaining the last.
    appendedCompanyListCategory = associations.find('.company-list-category-fields.is-appended').remove().last()

    updateAssociations = ->
      associations.find('> li').each (i, item) ->
        updateAssociationsFields(i, item, null)

    updateAssociationsFields = (i, item) ->
      item = $(item)
      item.find('> .company-list-category-tolerance .company-list-category-hidden-fields > input[name*="position"]').val(i)

    # Proceed only if an appended post section was found.
    if appendedCompanyListCategory.length is 1

      # Define an add post section element.
      addCompanyListCategory = $('<a href="#" class="btn btn-default add-category"><i class="fa fa-plus-circle"></i> Add Another Category/Label</a>')

      # Append the add post section element in a paragraph after the associations.
      $('<p>').append(addCompanyListCategory).insertAfter associations

      # Define a function to append a new post section to the container.
      appendCompanyListCategory = (first = false) ->
        companyListCategoryItemKey = 100000 + Math.floor(Math.random() * 100000000)
        companyListCategoryItemID = "post-section-#{companyListCategoryItemKey}"
        companyListCategoryItem = $(appendedCompanyListCategory.clone()[0].outerHTML.replace(/98765432101/g, companyListCategoryItemKey))
        companyListCategoryItem.attr 'id', companyListCategoryItemID
        associations.append companyListCategoryItem
        unmountedReactComponents = companyListCategoryItem.find('[data-react-unmounted-class]')
        if unmountedReactComponents.length > 0
          unmountedReactComponents.attr 'data-react-class', unmountedReactComponents.data().reactUnmountedClass
          window.ReactRailsUJS.mountComponents "##{companyListCategoryItemID}"
        if first is false
          $(".company-list-categories-associations input, .company-list-categories-associations select").prop('disabled', false);
          $(".company_ids:enabled").chosen();
        updateAssociations()

      # Trigger the append page function when the add page element is clicked.
      addCompanyListCategory.on 'click', (e) ->
        e.preventDefault()
        appendCompanyListCategory()

      # Add the first post section if none are present.
      if associations.find('.company-list-category-fields').length is 0
        appendCompanyListCategory(true)

    # Mount all existing post sections.
    unmountedExistingReactComponents = associations.find('.company-list-category-fields:not(.is-appended) [data-react-unmounted-class]')
    if unmountedExistingReactComponents.length > 0
      unmountedExistingReactComponents.attr 'data-react-class', unmountedExistingReactComponents.data().reactUnmountedClass
      window.ReactRailsUJS.mountComponents '.company-list-category-fields:not(.is-appended)'


    # Enable nested sortable
    associations.nestedSortable
      expandOnHover: 400
      forcePlaceholderSize: true
      handle: '> .company-list-category-tolerance > .company-list-category-handle'
      helper: 'clone'
      items: '.company-list-category-fields'
      maxLevels: 1
      opacity: 0.5
      placeholder: 'placeholder'
      revert: 100
      startCollapsed: false
      tabSize: 20
      protectRoot: true
      tolerance: 'pointer'
      toleranceElement: '> .company-list-category-tolerance'
      update: updateAssociations
