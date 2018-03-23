class Businesses::RemindersController < Businesses::BaseController
  before_action -> { confirm_module_activated(0) }
  def index
    @active_reminders = active_missions + completed_scheduled_missions
    @completed_reminders = completed_one_time_missions + deactivated_scheduled_missions

    instances = @business.mission_instances.includes(:assigned_user).where(
      mission_id: (
        @active_reminders.map(&:id) +
        @completed_reminders.map(&:id)
      )
    )

    @mission_instances = instances.group_by(&:mission_id)
    @histories = MissionHistory
      .includes(:note, mission_instance: [:mission])
      .for_business(@business)
      .order('happened_at DESC')
      .first(5)
  end

  private

  def statuses
    @statuses ||= MissionInstance.last_statuses
  end

  def active_missions
    Mission
      .reminders_for_business(@business)
      .joins(:mission_instances)
      .where(mission_instances: { business_id: @business.id, last_status: [statuses[:created], statuses[:active], statuses[:skipped]] })
      .distinct
  end

  def completed_scheduled_missions
    Mission
      .reminders_for_business(@business)
      .joins(:mission_instances)
      .where(mission_instances: { business_id: @business.id, last_status: statuses[:completed] })
      .where.not(mission_instances: { repetition: nil})
      .distinct
  end

  def completed_one_time_missions
    Mission
      .reminders_for_business(@business)
      .joins(:mission_instances)
      .where(mission_instances: { business_id: @business.id, last_status: statuses[:completed], repetition: nil })
      .distinct
  end

  def deactivated_scheduled_missions
    Mission
      .reminders_for_business(@business)
      .joins(:mission_instances)
      .where(mission_instances: { business_id: @business.id, last_status: statuses[:deactivated] })
      .where.not(mission_instances: { repetition: nil})
      .distinct
  end
end
