class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  # Permit additional parameters in Devise registration controllers.
  before_action if: :devise_controller? do
    devise_parameter_sanitizer.for(:sign_up) << %i[first_name last_name]
    devise_parameter_sanitizer.for(:account_update) << %i[first_name last_name]
    set_dashboard_url()
  end

  protected

  def confirm_module_activated(module_kind_number)
    # marketing_missions: 0, 
    # content_engine: 1,
    # local_connections: 2,
    # customer_reviews: 3,
    # form_builder: 4,
    # website: 5
    if !@business.module_active?(module_kind_number)
      redirect_to business_account_modules_path
    end
  end

  def raise_initial_billing_and_subscription_roadblock
    #if super admin sets roadblock to true, the following takes place
    unless current_user.super_user? || @business.is_on_legacy_plan?
      if @business.bill_online == true && @business.subscription_billing_roadblock == true
        @subscription = @business.subscription
        # if params[:action] != 'initial_plan_setup' 
        #   && @subscription.plan.is_engage_plan? && @subscription.missing_any_payment_info? 
        #   || (params[:action] != 'initial_billing_setup' && params[:action] != 'initial_plan_setup') 
        #   && !@subscription.plan.is_engage_plan? && @subscription.needs_payment_info?
        unless params[:action] == 'initial_plan_setup' || params[:action] == 'initial_billing_setup'
          flash[:notice] = "Looks like you don't have a plan set-up for this business. 
          Let's get you started!"
          redirect_to initial_plan_setup_business_subscriptions_path and return
        end
        # elsif params[:action] != 'initial_billing_setup' && !@subscription.plan.is_engage_plan? && @subscription.needs_payment_info? && !params[:back_to_initial].present?
        #   flash[:notice] = "Looks like your plan is set-up for this business 
        #   but we don't have your billing information. Let's take care of that!"
        #   redirect_to(setup_billing_business_subscriptions_path)
      end
    end
  end

  def confirm_subscription_present
    unless current_user.super_user? || @business.is_on_legacy_plan?
      if @business.subscription.nil? && @business.subscription_billing_roadblock == false
        flash[:notice] = "Looks like you don't have a plan set-up for this business.
        Let's get you started!"
        redirect_to(plan_business_subscriptions_path)
      end   
    end
  end

  def confirm_billing_information_present
    unless current_user.super_user? || @business.is_on_legacy_plan?
      if !@business.subscription.nil? && @business.subscription.needs_payment_info? && !@business.subscription.plan.is_engage_plan? && @business.subscription_billing_roadblock == false
        flash[:notice] = "Looks like your plan is set-up for this business but we either don't have your billing information,
        or that information is outdated. Let's take care of that!"
        redirect_to setup_billing_business_subscriptions_path, missing_billing: 'true'
      end
    end
  end

  # Customize redirect location for newly signed-up and signed-in users.
  def after_sign_in_path_for(user)
    if user.authorized_businesses.any?
      :businesses
    else
      new_onboard_user_url(anchor: "/wizard/lookup") #:new_onboard_website_business
    end
  end

  # Sends a custom event to the Intercom service, if credentials are provided.
  def intercom_event(event_name, metadata = {})
    if ENV['INTERCOM_ID'].present? && ENV['INTERCOM_API_KEY'].present?
      begin
        Intercom::Client.new(
          app_id: ENV['INTERCOM_ID'],
          api_key: ENV['INTERCOM_API_KEY']
        ).events.create(
          event_name: event_name,
          email: metadata.delete(:user_email) || current_user.email,
          created_at: metadata.delete(:created_at) || Time.zone.now.to_i,
          metadata: metadata,
        )
      rescue Intercom::ResourceNotFound
      end
    end
  end

  # Find the website‘s custom host or IMPACT subdomain.
  def website_host(website)
    if website.webhost.try(:primary?)
      website.webhost.name
    else
      [website.subdomain, Rails.application.secrets.host].join('.')
    end
  end
  def set_dashboard_url
    if (request.subdomains.first == 'www' || (!request.ssl? && Rails.env.production?)) && request.host.match(Regexp.escape(Rails.application.secrets.host))
      if Rails.env.production?
        redirect_to "https://" + Rails.application.secrets.host + request.original_fullpath
      else
        redirect_to "http://" + Rails.application.secrets.host + request.original_fullpath
      end
    end
  end
end
