module ReactHelper
  def react_unmounted_component(react_class, react_props)
    content_tag :div, '', data: { react_unmounted_class: react_class, react_props: react_props.to_json }
  end
end
