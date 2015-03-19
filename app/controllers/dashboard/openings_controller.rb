class Dashboard::OpeningsController < Dashboard::BaseController
  before_action do
    @location = @business.location
    redirect_to [:edit, @business, :location] unless @location.try(:persisted?)
  end

  def edit
    @location.openings.build
  end

  def update
    update_resource @location, location_params, location: [:edit, @business, :openings] do |success|
      @location.openings.build unless success
    end
  end

  private

  def location_params
    params.require(:location).permit(
      openings_attributes: [
        :id,
        :opens_at,
        :closes_at,
        :sunday,
        :monday,
        :tuesday,
        :wednesday,
        :thursday,
        :friday,
        :saturday,
        :_destroy,
      ]
    )
  end
end
