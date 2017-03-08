class Businesses::MissionsController < Businesses::BaseController
  def index
    @missions = Mission.reminders_for_business(@business)
                       .admin_created
                       .joins("LEFT JOIN mission_instances mi ON mi.mission_id = missions.id AND mi.business_id = #{@business.id}")
                       .order('mi.last_status ASC')
                       .page(params[:page])

    @mission_instances = @business.mission_instances
                                  .where(mission_id: @missions.map(&:id))
                                  .group_by(&:mission_id)
  end

  def custom
    @missions = Mission.where(business: @business)
                       .select('missions.*, mi.last_status as last_status')
                       .joins("LEFT JOIN mission_instances mi ON mi.mission_id = missions.id AND mi.business_id = #{@business.id}")
                       .order('mi.last_status ASC')
                       .page(params[:page])
    @mission_instances = @business.mission_instances
                                  .where(mission_id: @missions.map(&:id))
                                  .group_by(&:mission_id)
  end

  def show
    @mission = Mission.includes(mission_instances: [:comments, :mission_histories]).find(params[:id])
    @mission_instance = @mission.mission_instances.for_business(@business.id)
    @mission_instance ||= @mission.mission_instances.new(business: @business, last_status: nil)
    @comments = @mission_instance ? @mission_instance.comments : Comment.none
  end
end
