class MissionNotificationSetting < ActiveRecord::Base
  belongs_to :business
  belongs_to :user

  enum daily_due_notification_preference: [:all_daily, :mine_daily, :none_daily]
  enum weekly_due_notification_preference: [:all_weekly, :mine_weekly, :none_weekly]

  after_initialize :check_schedule_presence

  def summary_schedule
    return unless summary_frequency?

    IceCube::Schedule.new(business.created_at).tap do |s|
      s.add_recurrence_rule RecurringSelect.dirty_hash_to_rule(summary_frequency)
    end
  end

  def missions_due_next_summary_recurrence
    return Mission.none unless summary_frequency?

    MissionInstance.due_between(Time.now, summary_schedule.next_occurrence.to_date)
  end

  def missions_completed_this_summary_recurrence
    MissionInstance.completed_between(Time.now, summary_schedule.previous_occurrence(Time.now).to_date)
  end

  def suggestions_schedule
    return unless suggestions_frequency?

    IceCube::Schedule.new(business.created_at).tap do |s|
      s.add_recurrence_rule RecurringSelect.dirty_hash_to_rule(suggestions_frequency)
    end
  end

  def first_three_recommendations
    MissionInstance.dashboard_prompts(business, 3)
  end

  private

  def check_schedule_presence
    self.suggestions_notification = false unless suggestions_frequency.present?
    self.summary_notification = false unless summary_frequency.present?
  end
end
