class Event < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  belongs_to :business
  belongs_to :event_definition

  delegate *%i[title description], to: :event_definition

  validates :business, presence: true
  validates :event_definition, presence: true
  validates :occurs_on, presence: true

  def as_indexed_json(options = {})
    as_json(methods: %i[title description sorting_date])
  end

  def occurs_at
    occurs_on.to_time + event_definition.start_time.seconds_since_midnight.seconds
  end

  def sorting_date
    occurs_on
  end

  def to_param
    "#{id}-#{title}".parameterize
  end
end
