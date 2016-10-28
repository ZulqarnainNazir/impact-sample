class Businesses::ToDosController < Businesses::BaseController
  before_action do
    unless @business.to_dos_enabled
      redirect_to [@business, :dashboard], alert: 'You are not permitted there.'
    end
  end

  before_action :set_to_to, except: %w[index create show]

  def index
    @get_started_to_dos = @business.to_dos.getting_started.by_due_date.order(:created_at)
    @prepare_launch_to_dos = @business.to_dos.preparing_to_launch.by_due_date.order(:created_at)
    @after_launch_to_dos = @business.to_dos.after_launch.by_due_date.order(:created_at)
    @custom_to_dos = @business.to_dos.custom.by_due_date.order(:created_at)
  end

  def show
    @to_do = ToDo.includes(comments: :commenter).find(params[:id])
  end

  def create
    @to_do = @business.to_dos.build(to_do_params)
    @to_do.due_date = DatepickerParser.parse(to_do_params[:due_date])

    if @to_do.save
      flash[:notice] = "ToDo created"
      render json: { redirect: business_dashboard_path(@business) }
    else
      flash[:alert] = "Error creating ToDo"
      render json: @to_do.errors, status: :unprocessable_entity
    end
  end

  def update
    @to_do.assign_attributes(to_do_params)
    @to_do.due_date = DatepickerParser.parse(to_do_params[:due_date])

    if @to_do.save
      flash[:notice] = "ToDo updated"
      render json: { redirect: business_to_dos_path(@business) }
    else
      flash[:alert] = "Error updating ToDo"
      render json: @to_do.errors, status: :unprocessable_entity
    end
  end

  def submit_for_review
    @to_do.assign_attributes(submission_status: ToDo.submission_statuses[:submitted])
    @to_do.save

    redirect_to :back, notice: "ToDo submitted for review"
  end

  def mark_as_complete
    @to_do.assign_attributes(submission_status: ToDo.submission_statuses[:accepted])
    @to_do.save

    redirect_to :back, notice: "ToDo marked as completed"
  end

  def remove
    @to_do.assign_attributes(status: ToDo.statuses[:removed])
    @to_do.save

    redirect_to :back, notice: "ToDo removed"
  end

  def reactivate
    @to_do.assign_attributes(status: ToDo.statuses[:active])
    @to_do.save

    redirect_to :back, notice: "ToDo reactivated"
  end

  def destroy
    @to_do.destroy if current_user.super_user?

    redirect_to :back, notice: "ToDo destroyed"
  end

  private

  def to_do_params
    params.require(:to_do).permit(:title, :description, :due_date)
  end

  def set_to_to
    @to_do = @business.to_dos.find(params[:id])
  end
end
