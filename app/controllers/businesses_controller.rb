class BusinessesController < ApplicationController
  before_action :authenticate_user!
  layout 'businesses'

  def index
    @businesses = current_user.authorized_businesses.alphabetical.search(params[:search]).page(params[:page]).per(24)
  end
end
