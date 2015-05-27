class EventDefinition < ActiveRecord::Base
  include PlacedImageConcern

  belongs_to :business

  has_one :event_definition_location, dependent: :destroy

  has_one :location, through: :event_definition_location

  has_many :events, dependent: :destroy

  has_placed_image :event_image

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
    if schedule_changed? && errors.empty?
      EventDefinitionSchedulerJob.perform_later(self)
    end
  end

  def start_date=(*args)
    super DatepickerParser.parse(*args)
  end

  def end_date=(*args)
    super DatepickerParser.parse(*args)
  end

  def description_html
    Sanitize.fragment(description.to_s, Sanitize::Config::RELAXED).html_safe
  end

  def schedule
    IceCube::Schedule.new(schedule_starts_at).tap do |s|
      s.add_recurrence_rule RecurringSelect.dirty_hash_to_rule(repetition)
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
      events.destroy_all

      if repetition?
        schedule.occurrences(schedule_ends_at).each do |date|
          events.create(business: business, occurs_on: date)
        end
      else
        events.create(business: business, occurs_on: start_date)
      end
    end
  end

  private

  def schedule_changed?
    repetition_changed? || start_date_changed? || end_date_changed?
  end
end
