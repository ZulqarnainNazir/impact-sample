class Event < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  belongs_to :business
  belongs_to :event_definition

  validates :business, presence: true
  validates :event_definition, presence: true
  validates :occurs_on, presence: true

  if ENV['REDUCE_ELASTICSEARCH_REPLICAS'].present?
    settings index: { number_of_replicas: 1 }
  end

  def as_indexed_json(options = {})
    as_json(methods: %i[content_category_ids content_tag_ids sorting_date])
  end

  def content_category_ids
    event_definition.try(:content_category_ids) || []
  end

  def content_tag_ids
    event_definition.try(:content_tag_ids) || []
  end

  def sorting_date
    occurs_on
  end

  def to_param
    "#{id}-#{event_definition.title}".parameterize
  end
end
