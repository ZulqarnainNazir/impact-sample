class Businesses::SuperSettingsController < Businesses::BaseController
  before_action do
    unless current_user.super_user?
      redirect_to [@business, :dashboard], alert: 'You are not permitted there.'
    end
  end

  def edit
    @affiliates = SubscriptionAffiliate.affiliates_in_good_standing
  end

  def update
    update_resource @business, business_params, location: [:edit, @business, :super_settings]
  end

  def associate_with_affiliate
    if SubscriptionAffiliate.find(params[:affiliate][:subscription_affiliate_id]).present? && @business.subscription.present?
      @affiliate = SubscriptionAffiliate.find(params[:affiliate][:subscription_affiliate_id])
      @subscription = @business.subscription

      @subscription = @business.subscription
      @subscription.affiliate = @affiliate

      if @subscription.save
        flash[:notice] = "Referral saved."
      else
        flash[:notice] = "Something went wrong and the referral was not saved. Please try again."
      end
    else
      flash[:notice] = "Error: either the affiliate does not exist or this business
      does not have a subscription. Please resolve these issues before trying again."
    end
    redirect_to edit_business_super_settings_path(@business)
  end

  def create_affiliation
    if !@business.is_affiliate?
      @affiliate = @business.build_subscription_affiliate
      if @affiliate.save
        @business.update_attribute :affiliate_activated, true
        flash[:notice] = "This business now is an affiliate and has affiliate privileges."
      else
        flash[:notice] = "Something went wrong and the app is not able to
        create the affiliation at this time."
      end
    elsif @business.is_affiliate?
      flash[:notice] = "This business already is an affiliate."
    end
    redirect_to edit_business_super_settings_path(@business)
  end

  def delete_affiliation
    if @business.referred? && @business.subscription.present?
      @subscription = @business.subscription
      if @subscription.update_attributes(subscription_affiliate_id: nil)
        flash[:notice] = "This business no longer is linked to an affiliate."
      else
        flash[:notice] = "Something went wrong and the app is not able to
        delete the affiliation at this time."
      end
    else
      flash[:notice] = "This business either was not referred by an
      affiliate or does not have a subscription."
    end
    redirect_to edit_business_super_settings_path(@business)
  end

  def add_legacy_plan
    if params[:add_legacy] == "true"
      
      if !@business.subscription.nil?
        @subscription = @business.subscription
        @subscription.plan = SubscriptionPlan.legacy_plan
      elsif @business.subscription.nil?
        @subscription = Subscription.new
        @subscription.plan = SubscriptionPlan.legacy_plan
        @subscription.subscriber = @business
      end

      if @subscription.save
        flash[:notice] = "This business is now on the Legacy Plan."
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
      :subscription_billing_roadblock,
      :affiliate_activated
      )
  end
end
