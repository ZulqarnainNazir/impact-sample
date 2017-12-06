class Businesses::Website::AddWebsitesController < Businesses::Website::BaseController
  before_action :load_billing, :only => [ :upgrade_to_new_plan ]
  def new_website
    @plans = SubscriptionPlan.get_build_plans_with_setup_fees
  end

  def upgrade_to_new_plan
    @subscription_plan = SubscriptionPlan.find(params[:subscription][:subscription_plan_id])
    @subscription = @business.subscription
    if params[:subscription][:annual].present? && params[:subscription][:annual] = 'true'
      @annual = true
    else
      @annual = false
    end

    if request.post?

      @subscription.plan = @subscription_plan
      @subscription.annual = @annual
      @subscription.upgrade_to = @subscription_plan.id

      if @annual == true
        @subscription.amount = @subscription_plan.amount_annual
      end

      if @subscription.save
        @subscription.reload
        result = if params[:stripeToken].present?
          @subscription.store_card(params[:stripeToken])
        else
          @address.first_name = @creditcard.first_name
          @address.last_name = @creditcard.last_name

          (@creditcard.valid? & @address.valid?) && @subscription.store_card(@creditcard, :billing_address => @address.to_activemerchant, :ip => request.remote_ip)
        end

        if result
          if @subscription_plan.setup_amount > 0
            if StripeChargeNowJob.perform_now(@subscription.id) == true
              activate_web_module
              flash[:notice] = "Congratulations! Your subscription is now
              upgraded, and your billing information has been added."
              redirect_to subscription_dashboard_business_subscriptions_path and return
            else
              flash[:notice] = "Something went wrong with the setup payment. Please try again."
            end
          elsif @subscription.setup_amount == 0
            if StripeChargeNowJobTwo.perform_now(@subscription.id)
              activate_web_module
              flash[:notice] = "Congratulations! Your subscription is now
              upgraded, and your billing information has been added."
              redirect_to subscription_dashboard_business_subscriptions_path and return
            else
              flash[:notice] = "Something went wrong with the subscription payment. Please try again."
            end
          else
            flash[:notice] = "There is a problem signing-up for that plan. Please try again."
          end
        end
      else
        flash[:notice] = "Something went wrong when we tried to process your billing information. Please try again."
      end

    end

    render action: "upgrade_to_new_plan"
  end

  protected

    def activate_web_module
      if @business.module_present?(5)
        @business.get_account_module(5).update(active: true)
      else
        AccountModule.create(kind: 5, active: true, business_id: @business.id )
      end
    end

    def load_billing
      #if you're getting weird errors related to this method, or I18n::InvalidLocaleData,
      #check to make sure that indentation/spacing in your editor is done with tabs, not spaces.
      #yml flips-out if indentation/spacing not done with tabs.
      #http://stackoverflow.com/questions/15331873/error-i18ninvalidlocaledata
      @creditcard = ActiveMerchant::Billing::CreditCard.new(params[:creditcard] || {})
      @address = SubscriptionAddress.new(params[:address])
    end
end
