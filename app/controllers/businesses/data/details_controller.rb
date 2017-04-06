class Businesses::Data::DetailsController < Businesses::BaseController
  include PlacementAttributesConcern

  before_action only: %i[create update] do
    params[:business][:category_ids].reject!(&:blank?) rescue nil
  end

  def update
    update_resource @business, business_params, context: :requires_categories, location: [:edit, @business, :data_details]
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
      :membership_org,
      category_ids: [],
      logo_placement_attributes: placement_attributes,
    ).deep_merge(
      logo_placement_attributes: {
        image_user: current_user,
        image_business: @business,
      },
    )
  end
end
