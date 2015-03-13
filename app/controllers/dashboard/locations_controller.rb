class Dashboard::LocationsController < Dashboard::BaseController
  before_action do
    @location = @business.location || @business.build_location
  end

  def update
    update_resource @location, location_params, location: @business
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
      :hide_phone,
    )
  end
end
