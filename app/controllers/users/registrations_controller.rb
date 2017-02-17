class Users::RegistrationsController < Devise::RegistrationsController
  before_action :set_affiliate_cookie, :only => [:new]
  before_action only: %i[update] do
    %i[app_marketing_reminders email_marketing_reminders].each do |attribute|
      devise_parameter_sanitizer.for(:account_update) << attribute
    end
  end

  def new
  	super
  end

  private

   def set_affiliate_cookie
    @affiliate_token = SubscriptionAffiliate.find_by(token: params[:r]).token rescue nil
    unless @affiliate_token.nil?
      cookies[:affiliate_token] = { value: @affiliate_token, expires: 1.month.from_now }
    end
  end

end
