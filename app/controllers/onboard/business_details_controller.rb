class Onboard::BusinessDetailsController < ApplicationController
  include PlacementAttributesConcern

  before_action only: %i[edit] do
    @business = Business.find(params[:id])
    flash[:notice] = "Successfully added your business"
  end

  def update
    @business = Business.find(params[:id])
    @business.update!(business_params)
    redirect_to [@business, :dashboard]
  end

  private

  def initial_business_params
    params.require(:business).permit(
      :name,
    )
  end

  def business_params
    params.require(:business).permit(
      :description,
      :kind,
      :name,
      :tagline,
      :membership_org,
      :website_url,
      :year_founded,
      :cce_url,
      :citysearch_id,
      :facebook_id,
      :foursquare_id,
      :google_plus_id,
      :houzz_id,
      :instagram_id,
      :linkedin_id,
      :opentable_id,
      :pinterest_id,
      :realtor_id,
      :tripadvisor_id,
      :trulia_id,
      :twitter_id,
      :yelp_id,
      :youtube_id,
      :zillow_id,
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
