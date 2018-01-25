class Super::MissionsController < SuperController
  before_action only: %i[create update] do
    if params[:mission]
      if params[:mission][:repetition] == 'null'
        params[:mission][:repetition] = ''
      end
    end
  end

  def index
    @missions = Mission.admin_created.page(params[:page]||1).per(20)
  end

  def custom
    @missions = Mission.where.not(business_id: nil).includes(:business).page(params[:page]||1).per(20)
  end

  def new
    @categories = Category.alphabetical
    @mission = Mission.new
  end

  def create
    @categories = Category.alphabetical
    @mission = Mission.new(mission_params)

    if @mission.save
      redirect_to super_missions_path, notice: 'Mission Added'
    else
      render :new
    end
  end

  def edit
    @categories = Category.alphabetical
    @mission = Mission.find(params[:id])
  end

  def update
    @categories = Category.alphabetical
    @mission = Mission.find(params[:id])

    if @mission.update(mission_params)
      redirect_to super_missions_path, notice: 'Mission Updated'
    else
      render :edit
    end
  end

  def destroy
    @mission = Mission.find(params[:id])
    @mission.destroy

    redirect_to super_missions_path, notice: 'Mission Deleted'
  end

  private

  def mission_params
    params.require(:mission).permit(
      :title,
      :description,
      :success_tips,
      :benefits,
      :time_to_complete,
      :to_do_list_id,
      :difficulty,
      :tier,
      :group,
      :repetition,
      :globally_recommended,
      pillars: [],
      category_ids: []
    )
  end
end
