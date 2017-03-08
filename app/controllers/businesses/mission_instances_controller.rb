class Businesses::MissionInstancesController < Businesses::BaseController
  before_action only: %i[create update] do
    if params[:mission_instance]
      if params[:mission_instance][:repetition] == 'null'
        params[:mission_instance][:repetition] = ''
      end

      if params[:mission_instance][:'start_time(4i)'].blank? && params[:mission_instance][:'start_time(5i)'].blank?
        params[:mission_instance][:'start_time(1i)'] = ''
        params[:mission_instance][:'start_time(2i)'] = ''
        params[:mission_instance][:'start_time(3i)'] = ''
      end

      if params[:mission_instance][:'end_time(4i)'].blank? && params[:mission_instance][:'end_time(5i)'].blank?
        params[:mission_instance][:'end_time(1i)'] = ''
        params[:mission_instance][:'end_time(2i)'] = ''
        params[:mission_instance][:'end_time(3i)'] = ''
      end
    end
  end

  def new
    @mission_instance = MissionInstance.new(business: @business)
    @mission = Mission.new(business: @business)
  end

  def create
    @mission_instance = MissionInstance.new(mission_instance_params.merge(business: @business, creating_user: current_user))
    @mission = Mission.new((mission_params[:mission] || {}).merge(business: @business))

    if @mission_instance.save_with_mission(@mission)
      redirect_to custom_business_missions_path, notice: 'Mission Added'
    else
      render :new
    end
  end

  def edit
    @mission_instance = @business.mission_instances.find(params[:id])
    @mission = @mission_instance.mission
  end

  def update
    @mission_instance = @business.mission_instances.find(params[:id])
    @mission = @mission_instance.mission
    if mission_params[:mission]
      @mission.assign_attributes(mission_params[:mission])
    end
    @mission_instance.assign_attributes(mission_instance_params)

    if @mission_instance.save && @mission.save
      @mission_instance.reschedule_events!
      redirect_to [@business, @mission], notice: 'Mission Updated'
    else
      @mission_instance.repetition = nil
      render :edit
    end
  end

  def complete
    mission = Mission.find(params[:mission_id])
    service = MissionActioner.new(mission, @business, current_user, params[:note])

    if service.complete
      redirect_to :back, notice: 'Mission completed'
    else
      redirect_to :back, error: 'Failed to mark mission completed'
    end
  end

  def skip
    mission = Mission.find(params[:mission_id])
    service = MissionActioner.new(mission, @business, current_user, params[:note])

    if service.skip
      redirect_to :back, notice: 'Mission skipped'
    else
      redirect_to :back, error: 'Failed to skip mission'
    end
  end

  def snooze
    mission = Mission.find(params[:mission_id])
    service = MissionActioner.new(mission, @business, current_user)

    if service.snooze
      redirect_to :back, notice: 'Mission snoozed'
    else
      redirect_to :back, error: 'Failed to snooze mission'
    end
  end

  def deactivate
    mission = Mission.find(params[:mission_id])
    service = MissionActioner.new(mission, @business, current_user)

    if service.deactivate
      redirect_to :back, notice: 'Mission deactivated'
    else
      redirect_to :back, error: 'Failed to deactivate mission'
    end
  end

  def activate
    mission = Mission.find(params[:mission_id])
    service = MissionActioner.new(mission, @business, current_user)

    if service.activate
      redirect_to [@business, mission], notice: 'Mission activated'
    else
      redirect_to :back, error: 'Failed to activate mission'
    end
  end

  private

  def mission_instance_params
    params.require(:mission_instance).permit(
      :assigned_user_id,
      :repetition,
      :start_date,
      :end_date,
      :start_time,
      :end_time
    )
  end

  def mission_params
    params.require(:mission_instance).permit(
      mission: [
        :title,
        :description,
        :benefits,
        :time_to_complete,
        :assigned_user_id,
        :difficulty,
        :group
      ]
    )
  end
end
