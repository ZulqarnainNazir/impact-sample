class Businesses::BaseController < ApplicationController
  before_action :authenticate_user!
  layout 'business'

  before_action do
    @business = current_user.authorized_businesses.find(params[:business_id])
  end
  before_action :confirm_subscription_present
  before_action :confirm_billing_information_present
  before_action :raise_initial_billing_and_subscription_roadblock
end
