class SuperController < ApplicationController
  before_action :ensure_admin
  layout 'businesses'

  def current_business
    Business.find_by(id: params[:business_id])
  end
  helper_method :current_business

  private

  def ensure_admin
    return if current_user && current_user.super_user

    flash[:alert] = "You are not allowed there"
    redirect_to authenticated_root_path
  end
end
