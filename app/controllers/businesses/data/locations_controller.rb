class Businesses::Data::LocationsController < Businesses::BaseController
  before_action do
    @location = @business.location || @business.build_location
  end

  def update
    update_resource @location, location_params, location: [:edit, @business, :data_location] do |success|
      if success
        @location.event_definitions.each(&:touch)
      end
    end
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
