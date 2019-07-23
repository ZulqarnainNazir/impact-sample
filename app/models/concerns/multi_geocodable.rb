module MultiGeocodable
  extend ActiveSupport::Concern

  included do
    after_validation :multi_geocode, if: :requires_geocode?
  end

  def multi_geocode
    result = MultiGeocoderService.search(full_address)
    if result
      self.latitude = result.latitude
      self.longitude = result.longitude
    end
  end

  def full_address
    address = [address_line_one, address_line_two].reject(&:blank?).join(', ')
    address.blank? ? nil : address
  end

  def requires_geocode?
    !(latitude && longitude) || street1_changed? || street2_changed? || city_changed? || state_changed? || zip_code_changed?
  end

  def city_and_state
    [[city, state].reject(&:blank?).join(', ')].reject(&:blank?).join(' ')
  end

  def address_line_one
    [street1, street2].reject(&:blank?).join(', ')
  end

  def address_line_two
    [[city, state].reject(&:blank?).join(', '), zip_code].reject(&:blank?).join(' ')
  end
end
