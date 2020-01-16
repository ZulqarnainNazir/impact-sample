module MultiGeocodable
  extend ActiveSupport::Concern

  included do
    after_validation :multi_geocode, if: :requires_geocode?
  end

  def multi_geocode
    if multi_geocode_result
      self.latitude = multi_geocode_result.latitude
      self.longitude = multi_geocode_result.longitude
    end
  end

  def multi_geocode_result
    @multi_geocode_result ||= MultiGeocoderService.search(full_address)
  end

  def full_address
    address = [address_line_one, address_line_two].reject(&:blank?).join(', ')
    address.blank? ? nil : address
  end

  def requires_geocode?
    geocode_missing? ||
      street1_changed? ||
      street2_changed? ||
      city_changed? ||
      state_changed? ||
      zip_code_changed?
  end

  def geocode_missing?
    latitude.blank? || longitude.blank?
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
