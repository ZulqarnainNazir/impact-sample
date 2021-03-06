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
      @mission_instance.reschedule_events!
      # flash[:appcues_event] = "Appcues.track('created marketing mission')"
      intercom_event 'created-marketing-mission'
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
      # flash[:appcues_event] = "Appcues.track('completed mission')"
      intercom_event 'completed-mission'
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
    mission_instance = @business.mission_instances.find_or_create_by(mission_id: params[:mission_id])
    mission = mission_instance.mission

    if mission_params[:mission]
      mission.assign_attributes(mission_params[:mission])
    end

    mission_instance.assign_attributes(mission_instance_params.merge(business: @business))

    # Activate missions module and send intercom event
    intercom_message = ""
    # appcues_message = ""

    if !@business.module_present?(0)
      @module = AccountModule.new(:kind => 0, :active => true)
      @module.business = @business

      # appcues_message = "Appcues.track('module activated: marketing_missions ')"
      intercom_message = "marketing-missions-activated"

      if @module.save
        # flash[:appcues_event] = appcues_message
        intercom_event intercom_message
      end
    end

    # Finish saving mission instance and then redirect
    respond_to do |format|
      if mission_instance.save && mission.save
        mission = Mission.find(params[:mission_id])
        service = MissionActioner.new(mission, @business, current_user)

        if service.activate
          format.html { redirect_to [@business, mission_instance], notice: 'Mission activated' }
          format.json { render json: mission_instance }

        else
          format.html { redirect_to :back, error: 'Failed to activate mission' }
          format.json { render json: mission_instance.errors, status: :unprocessable_entity }
        end
      else
        format.html { redirect_to :back, error: 'Failed to update mission' }
        format.json { render json: mission_instance.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_list
    mission = Mission.find(params[:mission_id])
    mission_instance = MissionInstance.find_or_initialize_by(mission_id: mission.id, business_id: @business.id)

    if mission_instance_params[:to_do_list_id].blank?
      mission_instance.excluded_from_list = true
    else
      mission_instance.excluded_from_list = false
    end

    if mission_instance.update(mission_instance_params)
      redirect_to [@business, mission], notice: 'Mission added to list'
    else
      redirect_to :back, error: 'Failed to update list'
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
      :end_time,
      :to_do_list_id
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
