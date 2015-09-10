class EventDefinition < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  include PlacedImageConcern

  belongs_to :business, touch: true

  has_many :content_categories, through: :content_categorizations
  has_many :content_categorizations, as: :content_item
  has_many :content_taggings, as: :content_item
  has_many :content_tags, through: :content_taggings
  has_many :events, dependent: :destroy
  has_one :event_definition_location, dependent: :destroy
  has_one :location, through: :event_definition_location

  has_placed_image :event_image
  has_placed_image :main_image

  accepts_nested_attributes_for :event_definition_location, allow_destroy: true, reject_if: :all_blank

  validates :business, presence: true
  validates :event_definition_location, presence: true
  validates :title, presence: true
  validates :start_date, presence: true
  validates :start_time, presence: true
  validates :end_date, presence: true, if: :repetition?

  before_validation do
    event_definition_location.event_definition = self if event_definition_location && !event_definition_location.event_definition
  end

  after_save do
    EventsExportJob.perform_later(business)
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
          events.create(business: business, occurs_on: occurrence)
        elsif event
          event.destroy
        end
      end
    end
  end
end
