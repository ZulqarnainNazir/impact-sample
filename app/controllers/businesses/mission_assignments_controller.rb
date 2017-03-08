class Businesses::MissionAssignmentsController < Businesses::BaseController
  def create
    @mission = Mission.find(params[:mission_id])
    @mission_instance = MissionInstance.find_or_create_by(
      mission_id: params[:mission_id],
      business_id: @business.id
    )

    if @mission_instance.update(mission_instance_params)
      redirect_to :back, notice: 'Assignment changed'
    else
      redirect_to :back, error: 'Failed to change assignment'
    end
  end

  private

  def mission_instance_params
    params.require(:mission_instance).permit(:assigned_user_id)
  end
end
