class Users::RegistrationsController < Devise::RegistrationsController
  before_action :set_affiliate_cookie, :only => [:new]
  before_action only: %i[update] do
    %i[app_marketing_reminders email_marketing_reminders].each do |attribute|
      devise_parameter_sanitizer.for(:account_update) << attribute
    end
  end

  respond_to :json

  def new
  	super
  end

  # POST /resource
  def create
    build_resource(sign_up_params)
    if params[:confirm].present? && params[:confirm] == 'false'
      resource.skip_confirmation!
    end
    resource.save
    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  private

   def set_affiliate_cookie
    @affiliate_token = SubscriptionAffiliate.find_by(token: params[:r]).token rescue nil
    unless @affiliate_token.nil?
      cookies[:affiliate_token] = { value: @affiliate_token, expires: 1.month.from_now }
    end
  end

end
