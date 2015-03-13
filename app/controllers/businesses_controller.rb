class BusinessesController < ApplicationController
  before_action :authenticate_user!
  layout 'dashboard', only: :show

  def index
    @businesses = current_user.businesses.alphabetical
  end

  def show
    @business = current_user.businesses.find(params[:id])
  end
end
