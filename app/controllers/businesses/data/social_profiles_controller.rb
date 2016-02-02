class Businesses::Data::SocialProfilesController < Businesses::BaseController
  def update
    update_resource @business, social_profile_params, location: [:edit, @business, :data_social_profiles]
  end

  private

  def social_profile_params
    params.require(:business).permit(
      :cce_url,
      :citysearch_id,
      :facebook_id,
      :google_plus_id,
      :instagram_id,
      :linkedin_id,
      :pinterest_id,
      :twitter_id,
      :yelp_id,
      :youtube_id,
    )
  end
end
