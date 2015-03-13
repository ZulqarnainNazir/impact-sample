class Dashboard::BaseController < ApplicationController
  before_action :authenticate_user!
  layout 'dashboard'

  before_action do
    @business = current_user.businesses.find(params[:business_id])
  end
end
