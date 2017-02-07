class Businesses::SuperSettingsController < Businesses::BaseController
  before_action do
    unless current_user.super_user?
      redirect_to [@business, :dashboard], alert: 'You are not permitted there.'
    end
  end

  def update
    update_resource @business, business_params, location: [:edit, @business, :super_settings]
  end

  def add_legacy_plan
    if params[:add_legacy] == "true"
      @subscription = Subscription.new
      @subscription.plan = SubscriptionPlan.legacy_plan
      @subscription.subscriber = @business
      if @subscription.save
        flash[:notice] = "Legacy Plan Added."
      else
        flash[:notice] = "Legacy Plan Add Failed. Try Again."
      end
    else
      flash[:notice] = "Something went wrong the the app is not able to 
      create the plan at this time."
    end
    redirect_to edit_business_super_settings_path(@business)
  end

  def delete_legacy_plan
    if params[:add_legacy] == "false"
      @subscription = @business.subscription
      if @subscription.plan == SubscriptionPlan.legacy_plan
        if @subscription.delete
          flash[:notice] = "Legacy Plan has been deleted for this business. This account has
          no subscription anymore. A subscription roadblock will now appear for the end user,
          requesting that they subscribe to a plan, before they can access their account."
        else
          flash[:notice] = "Something went wrong. Please try again."
        end
      else
        flash[:notice] = "This business' plan is not a Legacy plan, and cannot be deleted here."
      end
    end
    redirect_to edit_business_super_settings_path(@business)
  end

  private

  def business_params
    params.require(:business).permit(
      :plan, 
      :to_dos_enabled, 
      :bill_online, 
      :subscription_billing_roadblock
      )
  end
end
