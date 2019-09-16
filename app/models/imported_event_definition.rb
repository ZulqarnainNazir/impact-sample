class ImportedEventDefinition < EventDefinition
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  include ContentSlugConcern
  before_save :generate_slug, unless: :slug?
  index_name :event_definitions
  document_type :event_definition

  after_save :reschedule_events!
  after_save :ensure_default_image_if_none_present

  scope :pending, -> { where(import_pending: true) }
  scope :published, -> { where(import_pending: false)  }
  scope :include_archived, -> { where archived: [true, false, nil]}
  scope :published_events_for_feed, lambda { |feed|
      includes(:business, :event_definition_location)
      .where(event_feed: feed)
      .published }
  scope :unpublished_events_for_feed, lambda { |feed|
      includes(:business, :event_definition_location)
      .where(event_feed: feed)
      .pending }

  accepts_nested_attributes_for :event_definition_location, allow_destroy: true, reject_if: :all_blank

  belongs_to :event_feed

  validates :imported_event_id, presence: true

  # These are the validations which are used to determine whether an imported
  # event definition is considered filled out enough to be published and imported.
  # Otherwise its created without being published, and is considered to be pending import.
  with_options on: :feed_overview do
    validate :venue_attached
    validates_presence_of :description
    validates_presence_of :title
    validates_presence_of :start_date
    validates_presence_of :start_time
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

  def ensure_default_image_if_none_present
    return unless event_feed && event_feed.default_event_image.present?

    unless self.main_image.present?
      self.main_image = event_feed.default_event_image
    end
    unless self.event_image.present?
      self.event_image = event_feed.default_event_image
    end
  end

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
