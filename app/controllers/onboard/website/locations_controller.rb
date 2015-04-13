class Onboard::Website::LocationsController < Onboard::Website::BaseController
  before_action do
    @business = current_user.authorized_businesses.find(params[:business_id])

    unless @business.location && @business.website
      redirect_to [@business, :dashboard], alert: 'No Location or Website Found'
    end
  end

  def update
    update_resource @business.location, location_params, location: [:edit_onboard_website, @business, :website]
  end

  private

  def location_params
    params.require(:location).permit(
      :name,
      :email,
      :phone_number,
      :street1,
      :street2,
      :city,
      :state,
      :zip_code,
      :hide_address,
      :hide_email,
      :hide_phone,
      :external_service_area,
      :service_area,
    )
  end
end
