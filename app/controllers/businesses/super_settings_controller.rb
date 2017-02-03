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
