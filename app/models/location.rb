class Location < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  belongs_to :business, touch: true

  with_options dependent: :destroy do
    has_many :event_definition_locations
    has_many :openings
  end

  has_many :event_definitions, through: :event_definition_locations

  accepts_nested_attributes_for :business
  accepts_nested_attributes_for :openings, allow_destroy: true, reject_if: proc { |a| a['id'].nil? && %w[opens_at closes_at sunday monday tuesday wendesday thursday friday saturday].all? { |at| a[at].blank? }}

  validates :name, presence: true
  validates :state, inclusion: { in: UsStates.abbreviations }, allow_blank: true

  with_options on: :business_setup do
    validates :business, presence: true
    validates :street1, presence: true
    validates :city, presence: true
    validates :state, presence: true
    validates :zip_code, presence: true
  end
  Geocoder.configure(:timeout => 30)
  geocoded_by :full_address


  after_validation :geocode, if: :requires_geocode?

  after_commit do
    event_definitions.each(&:touch)
  end

  if ENV['REDUCE_ELASTICSEARCH_REPLICAS'].present?
    settings index: { number_of_shards: 1, number_of_replicas: 0 }
  end

  def as_indexed_json(options = {})
    as_json(methods: %i[full_address])
  end

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
    address = [address_line_one, address_line_two].reject(&:blank?).join(', ')
    address.blank? ? nil : address
  end

  def requires_geocode?
    !(latitude && longitude) || street1_changed? || street2_changed? || city_changed? || state_changed? || zip_code_changed?
  end
end
