class EventDefinition < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  include PlacedImageConcern
  include ContentSlugConcern

  # enum kind: { event: 0, is_aclass: 1, deadline: 2 }

  belongs_to :business, touch: true

  has_many :content_categories, through: :content_categorizations
  has_many :content_categorizations, as: :content_item
  has_many :content_taggings, as: :content_item
  has_many :content_tags, through: :content_taggings
  has_many :events, dependent: :destroy
  has_one :event_definition_location, dependent: :destroy
  has_one :location, through: :event_definition_location
  has_many :shares, as: :shareable, dependent: :destroy

  has_placed_image :event_image
  has_placed_image :main_image

  accepts_nested_attributes_for :event_definition_location, allow_destroy: true, reject_if: :all_blank

  validates_presence_of :business, if: :not_draft?
  # validates :event_definition_location, presence: true, unless: :is_virtual_event?
  validates_presence_of :title
  validates_presence_of :description, if: :not_draft?
  validates_presence_of :start_date, if: :not_draft?
  validates_presence_of :start_time, if: :not_draft?
  validates_presence_of :end_date, if: :repetition? and :not_draft?
  validate :end_date_cannot_before_start_date

  scope :not_pending, -> { where(import_pending: false, archived: false) }

  before_validation do
    unless self.virtual_event?
      event_definition_location.event_definition = self if event_definition_location && !event_definition_location.event_definition
    end
  end

  after_save do
    LocableEventsExportJob.perform_later(business)
  end

  def end_date_cannot_before_start_date
    if ( !end_time.blank? || !end_time.nil? ) && ( !end_date.blank? || !end_date.nil? )
      time_comparison = if !end_time.blank? || !end_time.nil?
                          (end_date.to_time.to_i + end_time.to_i) < (start_date.to_time.to_i + start_time.to_i)
                        else
                          end_date.to_time.to_i < start_date.to_time.to_i
                        end
      if !end_time.blank? || !end_time.nil?
        puts end_date.to_time.to_i + end_time.to_i
      end
      if !start_time.blank? || !start_time.nil?
        puts start_date.to_time.to_i + start_time.to_i
      end
      errors.add(:end_date, "can't be before start date") if
        ( !end_date.blank? || !end_time.nil? ) and time_comparison
    end
  end

  if ENV['REDUCE_ELASTICSEARCH_REPLICAS'].present?
    settings index: { number_of_shards: 1, number_of_replicas: 0 }
  end

  def share_callback_url
    self.events.first.share_callback_url
  end

  def share_image_url
    self.events.first.share_image_url
  end

  def is_virtual_event?
    if self.virtual_event == true
      return true
    else
      return false
    end
  end

  def readable_kind
    if kind == 0
      "Event"
    elsif kind == 1
      "Class"
    elsif kind == 2
      "Deadline"
    end
  end

  def not_draft?
    published_status?
  end

  def start_date=(*args)
    super DatepickerParser.parse(*args)
  end

  def end_date=(*args)
    super DatepickerParser.parse(*args)
  end

  def as_indexed_json(options = {})
    as_json(methods: %i[content_category_ids content_tag_ids sorting_date])
  end

  def sorting_date
    created_at
  end

  def published_at
    #published_at is used in content_feed_search.rb and content_blog_search.rb to
    #as the method an each loop leverages to sort content types before displaying them.
    #published_at also exists in other content type models, because
    # there exists the attribute "published_on" in those models.
    #published_on does not exist in Event or EventDefinition.
    #published_on was added to content type models (excluding Event/EventDefinitions)
    # after many content type records had been already been created
    #(e.g., in QuickPost, Post, BeforeAfter, etc.). This wasn't done just right,
    #resulting in a situation where sometimes published_on was nil for old
    #content types. #published_at was a method added to content types that would
    #pull published_on for sorting purposes in content_feed_search and content_
    #blog_search.rb; if published_on was nil, it will pull created_at.
    #in order to sort the payload from ES consistently, published_at
    #is added here, too, so we can sort all content types by the same method.
    #see content_feed_search.rb and content_blog_search.rb.
    created_at
  end

  def description_html
    Sanitize.fragment(description.to_s, Sanitize::Config::RELAXED).html_safe
  end

  def schedule
    if repetition?
      IceCube::Schedule.new(schedule_starts_at).tap do |s|
        s.add_recurrence_rule RecurringSelect.dirty_hash_to_rule(repetition)
      end
    end
  end

  def schedule_starts_at
    start_date.to_time + start_time.seconds_since_midnight.seconds
  end

  def schedule_ends_at
    end_date.to_time + (end_time.try(:seconds_since_midnight) || (1.day - 1.second)).seconds
  end

  def reschedule_events!
    transaction do
      existing_events = events.order(occurs_on: :asc)
      new_occurrences = repetition? ? schedule.occurrences(schedule_ends_at) : [start_date]

      if new_occurrences.length > existing_events.length
        occurrence_event_pairs = new_occurrences.zip(existing_events)
      else
        occurrence_event_pairs = existing_events.zip(new_occurrences).map(&:reverse)
      end

      occurrence_event_pairs.each do |occurrence, event|
        if occurrence && event
          event.update(occurs_on: occurrence) unless event.occurs_on == occurrence
        elsif occurrence
          events.create(business: business, occurs_on: occurrence, event_definition: self)
        elsif event
          event.destroy
        end
      end
    end
  end
end
