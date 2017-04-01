class BusinessesController < ApplicationController
  before_action :authenticate_user!
  before_action :masquerade_user!
  layout 'businesses'

  def index
    @businesses = current_user.authorized_businesses.where(:in_impact => true).alphabetical.search(params[:search]).page(params[:page]).per(24)
  end
end
