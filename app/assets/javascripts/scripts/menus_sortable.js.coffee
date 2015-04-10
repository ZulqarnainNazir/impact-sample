$ = jQuery

$.fn.menusSortable = ->
  this.each (index, menus) ->
    menus = $(menus)

    headerMenu = ->
      arrayWithRoot = $('.menus-sortable-header').nestedSortable('toArray', { startDepthCount: 0 })
      array = arrayWithRoot.splice(1, arrayWithRoot.length)
      array.map (object) ->
        id: object.item_id
        parent_id: object.parent_id
        position: object.left

    footerMenu = ->
      array = $('.menus-sortable-footer').sortable('toArray')
      array.map (object, index) ->
        id: object.split('_')[1]
        position: index

    menus.on 'click', '.menus-sortable-header .menus-sortable-remove', ->
      item = $(this).closest('li')
      $('.menus-sortable-header-excluded').prev('p').hide()
      $('.menus-sortable-header-excluded').append(item)
      for child in item.find('li').remove()
        $('.menus-sortable-header-excluded').append(child)

    menus.on 'click', '.menus-sortable-footer .menus-sortable-remove', ->
      item = $(this).closest('li')
      $('.menus-sortable-footer-excluded').prev('p').hide()
      $('.menus-sortable-footer-excluded').append(item)

    menus.on 'submit', 'form', ->
      $('#website_header_menu').val JSON.stringify(headerMenu())
      $('#website_footer_menu').val JSON.stringify(footerMenu())

    sortableOptions =
      expandOnHover: 400
      forcePlaceholderSize: true
      handle: 'div'
      helper: 'clone'
      items: 'li'
      maxLevels: 2
      opacity: 0.5
      placeholder: 'placeholder'
      revert: 100
      startCollapsed: false
      tabSize: 20
      toleranc: 'pointer'
      toleranceElement: '> div'

    menus.find('.menus-sortable-header').nestedSortable sortableOptions
    menus.find('.menus-sortable-footer').sortable sortableOptions
    menus.find('.menus-sortable-header-excluded').sortable $.extend {}, sortableOptions,
      connectWith: '.menus-sortable-header'
      remove: ->
        if $('.menus-sortable-header-excluded li').length > 0
          $('.menus-sortable-header-excluded').prev('p').hide()
        else
          $('.menus-sortable-header-excluded').prev('p').show()
    menus.find('.menus-sortable-footer-excluded').sortable $.extend {}, sortableOptions,
      connectWith: '.menus-sortable-footer'
      remove: ->
        if $('.menus-sortable-header-excluded li').length > 0
          $('.menus-sortable-header-excluded').prev('p').hide()
        else
          $('.menus-sortable-header-excluded').prev('p').show()
