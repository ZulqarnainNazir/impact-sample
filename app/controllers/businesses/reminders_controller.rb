class Businesses::RemindersController < Businesses::BaseController
  def index
    @reminders = Mission
      .reminders_for_business(@business)
      .joins(:mission_instances)
      .where(mission_instances: { last_status: [0, 1, 2] })
      .distinct
      .page(params[:page])

    @mission_instances = @business.mission_instances
                                  .where(mission_id: @reminders.map(&:id))
                                  .group_by(&:mission_id)
  end
end
