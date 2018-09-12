class ImportedEventDefinition < EventDefinition
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  include ContentSlugConcern
  before_save :generate_slug, unless: :slug?
  index_name :event_definitions
  document_type :event_definition

  after_save :reschedule_events!

  scope :pending, -> { where import_pending: true }
  scope :include_archived, -> { where archived: [true, false, nil]}

  accepts_nested_attributes_for :event_definition_location, allow_destroy: true, reject_if: :all_blank

  belongs_to :event_feed

  validates :imported_event_id, presence: true

  with_options on: :feed_overview do
    validate :venue_attached
    validates_presence_of :description
    validates_presence_of :title
    validates_presence_of :start_date
    validates_presence_of :start_time
  end

  def self.all_events_for_feed(feed)
    includes(:business, :event_definition_location)
      .where(event_feed: feed)
      .include_archived
  end

  def self.model_name
    EventDefinition.model_name
  end

  def archive!
    self.archived = true
    save validate: false
  end

  def validate_presence_of_slug?
    false
  end

  def imported_event
    event_feed.events_in_feed.find do |event|
      event.event_id == imported_event_id
    end
  end

  private

  def venue_attached
    unless location.present? &&
           location.name? &&
           location.city? &&
           location.state? &&
           location.zip_code?

      errors.add :venue, 'is required'
    end
  end
end
