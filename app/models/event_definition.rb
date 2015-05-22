class EventDefinition < ActiveRecord::Base
  include PlacedImageConcern

  belongs_to :business

  has_many :events, dependent: :destroy

  has_placed_image :event_image

  validates :business, presence: true
  validates :title, presence: true
  validates :start_date, presence: true
  validates :start_time, presence: true
  validates :end_date, presence: true, if: :repetition?

  after_save do
    if repetition? && schedule_changed? && errors.empty?
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

      schedule.occurrences(schedule_ends_at).each do |date|
        events.create(business: business, occurs_on: date)
      end
    end
  end

  private

  def schedule_changed?
    repetition_changed? || start_date_changed? || end_date_changed?
  end
end
