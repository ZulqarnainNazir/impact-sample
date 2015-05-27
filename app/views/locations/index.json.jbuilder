json.array! @locations do |location|
  json.id location.id
  json.name location.name
  json.latitude location.latitude
  json.longitude location.longitude
  json.fullAddress location.full_address
  json.searchResultText [location.name, location.full_address].reject(&:blank?).join(' – ')
end
