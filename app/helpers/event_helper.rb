module EventHelper
  MAP_KEY = 'AIzaSyCA09Ziec6NhT3FboPtVnHEfCaLBzqk298'

  def map_params_for_location(location, zoom: 15, q: nil, try_center: true)
    query = q || full_query_address(location)
    result = { key: MAP_KEY, q: query, zoom: zoom }
    if try_center && (location.latitude && location.longitude)
      result[:center] = [location.latitude, location.longitude].reject(&:blank?).join(',')
    end
    result.to_param
  end

  def map_params_for_full_address(location)
    map_params_for_location(location, q: full_query_address(location), zoom: 15, try_center: true)
  end

  def map_params_for_city_and_state(location)
    map_params_for_location(location, q: location.city_and_state, zoom: 10, try_center: false)
  end

  def full_query_address(location)
    [location.address_line_one, location.address_line_two].reject(&:blank?).join(' ')
  end
end
