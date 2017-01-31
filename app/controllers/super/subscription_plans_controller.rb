class Super::SubscriptionPlansController < SuperController
  layout 'businesses'
  before_action :set_subscription_plan, :only => [ :show, :edit, :update, :delete ]

  def index
    @subscription_plans = SubscriptionPlan.all
  end

  def show

  end

  def new
    @subscription_plan = SubscriptionPlan.new
  end

  def create
    @subscription_plan = SubscriptionPlan.new(subscription_plan_params)
    if @subscription_plan.save
      flash[:notice] = "You have successfully added a new plan."
      redirect_to :action => "index" 
    else
      flash[:alert] = "Something went wrong. Try again."
      render 'new'
    end
  end

  def edit

  end

  def update
    if @subscription_plan.update(subscription_plan_params)
      flash[:notice] = "You've updated the plan."
      redirect_to :action => "index" 
    else
      flash[:alert] = "Update error. Make sure you've filled in all fields correctly."
      render 'edit'
    end
  end

  def destroy
    if @subscription_plan.destroy
      flash[:notice] = "You've deleted the plan."
      redirect_to :action => "index" 
    else
      flash[:alert] = "Deletion error. Make sure you've filled in all fields correctly."
      render 'show'
    end
  end

  private

  def set_subscription_plan
    @subscription_plan = SubscriptionPlan.find_by(name: params[:id])
  end

  def subscription_plan_params
    params.require(:subscription_plan).permit(
      :name,
      :amount,
      :renewal_period,
      :setup_amount,
      :trial_period,
      :trial_interval,
      :setup_name,
      :amount_annual, 
      :description,
      :activated
    )
  end

end