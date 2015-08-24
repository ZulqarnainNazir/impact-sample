class LocationsController < ApplicationController
  before_action :authenticate_user!
  layout false

  before_action only: new_actions do
    @location = Location.new
  end

  def index
    @locations = LocationSearch.new(params[:query], params[:location_id]).search.page(1).per(10).records
  end

  def create
    @location.assign_attributes(location_params)
    @location.build_business unless @location.business
    @location.business.location = @location
    @location.business.name = @location.name
    @location.business.build_website unless @location.business.website
    @location.business.website.header_block_attributes = {}
    @location.business.website.footer_block_attributes = {}
    @location.business.website.subdomain = Subdomain.available(@location.business.name)

    if @location.save(context: :business_setup)
      render :show, formats: [:json]
    else
      flash.now.alert = 'There was a problem saving the venue.'
      render :new, status: 422
    end
  end

  private

  def location_params
    params.require(:location).permit(
      :name,
      :street1,
      :street2,
      :city,
      :state,
      :zip_code,
      business_attributes: [
        category_ids: [],
      ],
    )
  end
end
