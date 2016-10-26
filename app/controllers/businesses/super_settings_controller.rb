class Businesses::SuperSettingsController < Businesses::BaseController
  before_action do
    unless current_user.super_user?
      redirect_to [@business, :dashboard], alert: 'You are not permitted there.'
    end
  end

  def update
    update_resource @business, business_params, location: [:edit, @business, :super_settings]
  end

  private

  def business_params
    params.require(:business).permit(:plan, :to_dos_enabled)
  end
end
