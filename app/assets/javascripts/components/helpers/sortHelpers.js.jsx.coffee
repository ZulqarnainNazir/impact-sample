sortHelpers = {
  disableSortable: ->
    $('.webpage-container').sortable('destroy')

  enableSortables: (component) ->
    $('.webpage-container').sortable
      axis: 'y'
      container: '.webpage-container'
      expandOnHover: 400
      forceHelperSize: true
      forcePlaceholderSize: true
      handle: '.webpage-group-sort-handle'
      helper: 'clone'
      items: '> .webpage-group'
      opacity: 0.5
      placeholder: 'webpage-group-placeholder'
      revert: 100
      startCollapsed: false
      tabSize: 20
      tolerance: 'pointer'
      start: sortHelpers.startWebpageGroupsSorting.bind(null, component)
      stop: sortHelpers.stopWebpageGroupsSorting.bind(null, component)
    $('.webpage-group-horizontal-container').sortable
      axis: 'x'
      container: '.webpage-group-horizontal-container'
      expandOnHover: 400
      forceHelperSize: true
      forcePlaceholderSize: true
      handle: '.webpage-block-sort-handle'
      helper: 'clone'
      items: '> .webpage-block'
      opacity: 0.5
      placeholder: 'webpage-block-placeholder'
      revert: 100
      startCollapsed: false
      tabSize: 20
      tolerance: 'pointer'
      stop: sortHelpers.stopWebpageBlocksSorting.bind(null, component)
    $('.webpage-group-vertical-container').sortable
      axis: 'y'
      container: '.webpage-group-vertical-container'
      expandOnHover: 400
      forceHelperSize: true
      forcePlaceholderSize: true
      handle: '.webpage-block-sort-handle'
      helper: 'clone'
      items: '> .webpage-block'
      opacity: 0.5
      placeholder: 'webpage-block-placeholder'
      revert: 100
      startCollapsed: false
      tabSize: 20
      tolerance: 'pointer'
      stop: sortHelpers.stopWebpageBlocksSorting.bind(null, component)
    $('.sortable-hero-handles').sortable
      axis: 'y'
      item: '> .webpage-group-hero-switch-handle'
      tolerance: "pointer"
      placeholder: 'hero-handle-placeholder'
      helper: 'clone'
      stop: sortHelpers.stopHeroBlockSorting.bind(null, component)

  stopHeroBlockSorting: (component, event, ui) ->
    container = $('.sortable-hero-handles')
    groupUUID = container.data('group-uuid')
    blockUUIDs = container.sortable('toArray', attribute: 'data-uuid')
    container.sortable('cancel')
    sortHelpers.sortHeroBlocks(component, groupUUID, blockUUIDs)

  sortHeroBlocks: (component, groupUUID, blockUUIDs) ->
    _.each _.reject(blockUUIDs, (uuid) -> uuid == ''), (uuid, i) ->
      component.updateBlock(groupUUID, uuid, { position: i })

  startWebpageGroupsSorting: (component, event, ui) ->
    group = component.state.groups[ui.item.data('uuid')]
    if group and group.type is 'SidebarGroup'
      ui.placeholder.addClass('webpage-group-sidebar-placeholder-' + component.state.sidebarPosition)

  stopWebpageGroupsSorting: (component) ->
    container = $('.webpage-container')
    groupUUIDs = container.sortable('toArray', attribute: 'data-uuid')
    container.sortable('cancel')
    sortHelpers.sortWebpageGroups(component, groupUUIDs)

  stopWebpageBlocksSorting: (component, event, ui) ->
    container = ui.item.closest('.webpage-group-horizontal-container, .webpage-group-vertical-container')
    group = container.closest('.webpage-group')
    blockUUIDs = container.sortable('toArray', attribute: 'data-uuid')
    container.sortable('cancel')
    sortHelpers.sortWebpageBlocks(component, group.data('uuid'), blockUUIDs)

  sortWebpageGroups: (component, groupUUIDs) ->
    changes = {}
    _.each groupUUIDs, (uuid, i) ->
      component.updateGroup(uuid, { position: i })

  sortWebpageBlocks: (component, groupUUID, blockUUIDs) ->
    blocks = {}
    _.each blockUUIDs, (blockId, i) ->
      component.updateBlock(groupUUID, blockId, {position: i})
}

window.sortHelpers = sortHelpers
