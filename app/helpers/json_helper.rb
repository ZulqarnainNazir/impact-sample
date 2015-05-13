module JsonHelper
  def as_nested_json(items, *args)
    items.map do |item|
      item.cached_children = as_nested_json(item.cached_children, *args)
      item.as_json(*args)
    end
  end
end
