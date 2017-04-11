class Businesses::ToDoListsController < Businesses::BaseController
  def show
    @to_do_list = ToDoList.find(params[:id])

    if !@to_do_list.authorized_for?(@business)
      redirect_to :back
    end

    @unassigned_missions = Mission.unassigned_to_list(@business).order('mission_instances.last_status')
    @missions = Mission.assigned_to_list(@business, @to_do_list)
                       .page(params[:page])
                       .per(15)

    @mission_instances = @business.mission_instances
                                  .where(mission_id: @missions.map(&:id))
                                  .group_by(&:mission_id)
    @unassigned_mission_instances = @business.mission_instances
                                             .where(mission_id: @unassigned_missions.map(&:id))
                                             .group_by(&:mission_id)
  end

  def create
    @to_do_list = ToDoList.new(to_do_list_params)
    @to_do_list.business_id = @business.id

    if @to_do_list.save
      redirect_to business_marketing_assistant_index_path, notice: 'ToDoList Added'
    else
      render :new
    end
  end

  def edit
    @to_do_list = ToDoList.find(params[:id])
    unless @to_do_list.owned_by?(@business)
      redirect_to :back
    end
  end

  def update
    @to_do_list = ToDoList.find(params[:id])
    authorized = @to_do_list.owned_by?(@business)

    if !authorized
      redirect_to business_to_do_list_path(@business, @to_do_list), notice: 'Unauthorized'
    elsif @to_do_list.update(to_do_list_params)
      redirect_to business_to_do_list_path(@business, @to_do_list), notice: 'ToDoList Updated'
    else
      render :edit
    end
  end

  def destroy
    @to_do_list = ToDoList.find(params[:id])
    if @to_do_list.owned_by?(@business)
      @to_do_list.destroy
    end

    render json: { redirect: business_marketing_assistant_index_path }
  end

  def add_mission
    todolist = ToDoList.find(params[:id])
    mission = Mission.find(params[:mission_id])
    mission_instance = MissionInstance.where(mission: mission, business: @business).first_or_create
    mission_instance.to_do_list_id = todolist.id
    mission_instance.excluded_from_list = false
    mission_instance.save(validate: false)

    redirect_to business_to_do_list_path(@business, todolist), notice: 'Mission Added'
  end

  def remove_mission
    todolist = ToDoList.find(params[:id])
    mission = Mission.find(params[:mission_id])
    mission_instance = MissionInstance.where(mission: mission, business: @business).first_or_create
    mission_instance.to_do_list_id = nil
    mission_instance.excluded_from_list = true
    mission_instance.save(validate: false)

    redirect_to business_to_do_list_path(@business, todolist), notice: 'Mission Removed'
  end

  private

  def to_do_list_params
    params.require(:to_do_list).permit(:name, :description)
  end
end
