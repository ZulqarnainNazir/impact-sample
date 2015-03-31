PrevNext =
  prevItem: (items, currentItem) ->
    index = items.indexOf(currentItem)

    if index <= 0
      items[items.length - 1]
    else
      items[index - 1]

  nextItem: (items, currentItem) ->
    index = items.indexOf(currentItem)

    if index >= items.length - 1
      items[0]
    else if index < 0
      items[1]
    else
      items[index + 1]

window.PrevNext = PrevNext
