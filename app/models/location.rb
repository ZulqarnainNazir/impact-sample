class Location < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  include MultiGeocodable

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

  after_commit do
    self.__elasticsearch__.index_document
    event_definitions.each(&:touch)
  end

  after_save :update_business_timezone, if: :requires_geocode?

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

  def update_attributes_only_if_blank(attributes, create = false)
    attributes.each { |k,v| attributes.delete(k) unless read_attribute(k).blank? }
    if create == false
      attributes.delete :email
    end
    update_attributes(attributes)
  end

  private

  def update_business_timezone
    return unless business
    business.record_timezone(refresh: true)
    business.save
  end
end
