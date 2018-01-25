class MissionInstance < ActiveRecord::Base
  DEFAULT_END_DAYS = 178 # Half year
  ACTIVE_STATUS_INDEXES = [0, 1, 2]

  belongs_to :mission
  belongs_to :business

  has_many :comments, as: :commentable, dependent: :destroy
  has_many :mission_histories, dependent: :destroy
  has_many :notes, as: :notable, dependent: :destroy

  has_many :mission_instance_events, dependent: :destroy

  belongs_to :creating_user, class_name: 'User'
  belongs_to :assigned_user, class_name: 'User'

  belongs_to :to_do_list

  enum last_status: [:created, :active, :completed, :skipped, :snoozed, :deactivated]

  scope :active, -> { where(last_status: ACTIVE_STATUS_INDEXES) }
  scope :created_or_active, -> { where(last_status: [0, 1]) }
  scope :scheduled, -> { where.not(end_date: nil) }
  scope :one_time, -> { where(repetition: [nil, '']) }
  scope :recurring, -> { where.not(repetition: nil) }
  scope :for_today, -> { where('start_date = ?', Time.zone.now) }

  scope :completed_between, -> (s_date, e_date) { where('last_completed_at > ? AND last_completed_at < ?', s_date, e_date) }
  scope :due_between, -> (s_date, e_date) {
    joins('LEFT JOIN mission_instance_events mie ON mie.mission_instance_id = mission_instances.id')
      .where('(repetition IS NULL AND start_date >= ? AND start_date <= ?) OR (repetition IS NOT NULL AND mie.occurs_on >= ? AND mie.occurs_on <= ?)', s_date, e_date, s_date, e_date)
  }

  validates :business, presence: true
  validates :mission, presence: true
  validates :start_date, presence: true, on: :update
  validates :end_date, presence: true, if: :repetition?, on: :update

  before_validation :ensure_end_date
  before_save :sanitize_repetition

  after_create :ensure_correct_status
  after_save :ensure_events_cleanup

  delegate :title, to: :mission

  attr_accessor :start

  def start_date=(*args)
    super DatepickerParser.parse(*args)
  end

  def end_date=(*args)
    super DatepickerParser.parse(*args)
  end

  def active?
    if scheduled?
      ['created', 'active', 'completed', 'skipped'].include?(last_status)
    else
      ['created', 'active', 'skipped'].include?(last_status)
    end
  end

  def activated?
    ['active', 'completed', 'skipped'].include?(last_status)
  end

  def recurring?
    repetition.present?
  end

  def activated_by_name
    case last_status
    when 'active'
      event = mission_histories.activations.order('created_at DESC').first
      event&.actor&.name
    when 'created'
      creating_user&.name
    end
  end

  def save_with_mission(mission)
    transaction do
      mission.save
      update(mission_id: mission.id)
    end
  end

  def associated_list
    return nil if excluded_from_list

    to_do_list_id? ? to_do_list : mission.to_do_list
  end

  def completion_rate
    return 0 if completion_times.zero?

    rate = (completion_times.to_f / total_times.to_f).round(2)
    percentage = rate * 100
    percentage.to_i
  end

  def mark_complete
    update(last_completed_at: Time.zone.now,
           last_status: 'completed',
           total_times: (total_times + 1),
           completion_times: (completion_times + 1))
  end

  def mark_skipped
    update(last_completed_at: Time.zone.now,
           last_status: 'skipped',
           total_times: (total_times + 1),
           incompletion_times: (incompletion_times + 1))
  end

  def mark_snoozed
    update(last_snoozed_at: Time.zone.now,
           last_status: 'snoozed',
           total_times: (total_times + 1),
           incompletion_times: (incompletion_times + 1))
  end

  def deactivate
    update(last_status: 'deactivated')
  end

  def activate
    update(last_status: 'active', activated_at: Time.zone.now)
  end

  def schedule
    if repetition?
      IceCube::Schedule.new(schedule_starts_at).tap do |s|
        s.add_recurrence_rule RecurringSelect.dirty_hash_to_rule(repetition)
      end
    end
  end

  def scheduled?
    repetition? && end_date?
  end

  def one_time?
    !scheduled?
  end

  def next_due_at
    if scheduled?
      mission_instance_events.incomplete.next_due_event&.first&.occurs_on
    else
      start_date
    end
  end

  def schedule_starts_at
    if start_time&.seconds_since_midnight&.seconds
      start_date.to_time + start_time&.seconds_since_midnight&.seconds
    else
      start_date.to_time
    end
  end

  def schedule_ends_at
    end_date.to_time + (end_time.try(:seconds_since_midnight) || (1.day - 1.second)).seconds
  end

  def reschedule_events!
    transaction do
      existing_events = mission_instance_events.order(occurs_on: :asc)
      new_occurrences = repetition? ? schedule.occurrences(schedule_ends_at) : []

      if new_occurrences.length > existing_events.length
        occurrence_event_pairs = new_occurrences.zip(existing_events)
      else
        occurrence_event_pairs = existing_events.zip(new_occurrences).map(&:reverse)
      end

      occurrence_event_pairs.each do |occurrence, event|
        if occurrence && event
          event.update(occurs_on: occurrence) unless event.occurs_on == occurrence
        elsif occurrence
          MissionInstanceEvent.create(business: business, occurs_on: occurrence, mission_instance: self)
        elsif event
          event.destroy
        end
      end
    end
  end

  def schedule_in_words
    scheduled? ? schedule.to_s : 'One time'
  end

  def self.dashboard_prompts(business, return_count = 3, created_or_active = false)
    one_time_missions = if created_or_active
      one_time_missions_for_today(business).created_or_active
    else
      one_time_missions_for_today(business)
    end

    recurring_missions = if created_or_active
      recurring_missions_for_today(business, [0, 1])
    else
      recurring_missions_for_today(business)
    end

    missions_for_today = one_time_missions.concat(recurring_missions).uniq(&:id)
    return missions_for_today.first(return_count) if missions_for_today.size > return_count

    quickstart = missions_for_today.concat(quickstart_missions(business)).uniq(&:id)
    return quickstart.first(return_count) if quickstart.size > return_count

    setup = quickstart.concat(setup_missions(business)).uniq(&:id)
    return setup.first(return_count) if setup.size > return_count

    foundational = setup.concat(foundational_missions(business)).uniq(&:id)
    return foundational.first(return_count) if foundational.size > return_count

    presence = foundational.concat(presence_missions(business)).uniq(&:id)
    return presence.first(return_count)
  end

  def due_in_future?
    next_due = next_due_at
    next_due && next_due >= Time.now
  end

  def self.quickstart_missions(business)
    includes(:mission_instance_events)
      .where(business: business)
      .joins(:mission).where(missions: { group: 'quickstart' })
      .select(&:due_in_future?)
  end

  def self.setup_missions(business)
    includes(:mission_instance_events)
      .where(business: business)
      .joins(:mission).where(missions: { tier: 'setup' })
      .select(&:due_in_future?)
  end

  def self.foundational_missions(business)
    includes(:mission_instance_events)
      .where(business: business)
      .joins(:mission).where(missions: { tier: 'foundational' })
      .select(&:due_in_future?)
  end

  def self.presence_missions(business)
    includes(:mission_instance_events)
    .where(business: business)
      .joins(:mission).where(missions: { tier: 'presence' })
      .select(&:due_in_future?)
  end

  def self.one_time_missions_for_today(business)
    MissionInstance.joins(:mission)
                   .where(business: business)
                   .for_today
                   .active
                   .one_time
  end

  def self.recurring_missions_for_today(business, statuses = nil)
    MissionInstanceEvent.joins(mission_instance: :mission)
                        .where(business: business)
                        .for_today
                        .where(mission_instances: { last_status: (statuses || ACTIVE_STATUS_INDEXES) })
                        .map(&:mission_instance)
  end

  def self.recurring_missions_due_on(date)
    scheduled
      .joins(:mission_instance_events)
      .where(mission_instance_events: { occurs_on: date})
  end

  def self.one_time_missions_due_on(date)
    one_time.where(start_date: date)
  end

  # def self.one_time_missions_due_today(business)
  #   business
  #     .mission_instances
  #     .includes(business: :users)
  #     .one_time
  #     .where(start_date: Date.today)
  # end

  # def self.scheduled_missions_due_today(business)
  #   business
  #     .mission_instances
  #     .includes(business: :users)
  #     .scheduled
  #     .joins(:mission_instance_events)
  #     .where(mission_instance_events: { occurs_on: Date.today })
  # end

  def self.missions_due_today(business)
    business
      .mission_instances
      .includes(business: :users)
      .due_between(Time.now.beginning_of_day, Time.now.end_of_day)
  end

  def self.missions_due_this_week(business)
    business
      .mission_instances
      .includes(business: :users)
      .due_between(Time.now.beginning_of_week, Time.now.end_of_week)
  end

  private

  def ensure_correct_status
    self.activate if start_date? || repetition?
  end

  def ensure_events_cleanup
    mission_instance_events.destroy_all if repetition.blank?
  end

  def ensure_end_date
    if self.repetition?
      self.end_date = Time.now + DEFAULT_END_DAYS.days
    end
  end

  def sanitize_repetition
    self.repetition = nil if repetition == 'null' || repetition == ''
  end
end
