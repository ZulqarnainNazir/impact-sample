class SuperController < ApplicationController
  before_action :ensure_admin

  private

  def ensure_admin
    return if current_user && current_user.super_user

    flash[:alert] = "You are not allowed there"
    redirect_to authenticated_root_path
  end
end
