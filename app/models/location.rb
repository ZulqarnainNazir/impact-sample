class Location < ActiveRecord::Base
  belongs_to :business, touch: true

  with_options dependent: :destroy do
    has_many :event_definition_locations
    has_many :openings
  end

  has_many :event_definitions, through: :event_definition_locations

  accepts_nested_attributes_for :openings, allow_destroy: true, reject_if: proc { |a| a['id'].nil? && %w[opens_at closes_at sunday monday tuesday wendesday thursday friday saturday].all? { |at| a[at].blank? } || a['_destroy'].blank? }

  validates :state, inclusion: { in: UsStates.abbreviations }, allow_blank: true

  geocoded_by :full_address

  after_validation :geocode, if: :requires_geocode?

  def attributes_with_address
    attributes.merge(
      address_line_one: address_line_one,
      address_line_two: address_line_two,
    )
  end

  def address_line_one
    [street1, street2].reject(&:blank?).join(', ')
  end

  def address_line_two
    [[city, state].reject(&:blank?).join(', '), zip_code].reject(&:blank?).join(' ')
  end

  def full_address
    [address_line_one, address_line_two].reject(&:blank?).join(', ')
  end

  def requires_geocode?
    !(latitude && longitude) || street1_changed? || street2_changed? || city_changed? || state_changed?
  end
end
