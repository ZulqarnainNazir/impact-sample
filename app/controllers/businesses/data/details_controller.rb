class Businesses::Data::DetailsController < Businesses::BaseController
  before_action only: %i[create update] do
    params[:business][:category_ids].reject!(&:blank?) rescue nil
  end

  def update
    update_resource @business, business_params, location: [:edit, @business, :data_details]
  end

  private

  def business_params
    params.require(:business).permit(
      :description,
      :kind,
      :name,
      :tagline,
      :website_url,
      :year_founded,
      category_ids: [],
    )
  end
end
