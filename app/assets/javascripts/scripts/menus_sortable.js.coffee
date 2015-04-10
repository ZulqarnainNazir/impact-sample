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
      tabSiza: 20
      toleranc: 'pointer'
      toleranceElement: '> div'

    menus.find('.menus-sortable-header').nestedSortable $.extend({}, sortableOptions, { connectWith: '.menus-sortable-header-excluded' })
    menus.find('.menus-sortable-footer').sortable $.extend({}, sortableOptions, { connectWith: '.menus-sortable-footer-excluded' })
    menus.find('.menus-sortable-header-excluded').sortable $.extend({}, sortableOptions, { connectWith: '.menus-sortable-header' })
    menus.find('.menus-sortable-footer-excluded').sortable $.extend({}, sortableOptions, { connectWith: '.menus-sortable-footer' })
