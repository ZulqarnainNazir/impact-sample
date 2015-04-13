class Businesses::BaseController < ApplicationController
  before_action :authenticate_user!
  layout 'business'

  before_action do
    @business = current_user.authorized_businesses.find(params[:business_id])
  end
end
