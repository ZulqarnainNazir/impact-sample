class Dashboard::SocialProfilesController < Dashboard::BaseController
  def update
    update_resource @business, social_profile_params, location: @business
  end

  private

  def social_profile_params
    params.require(:business).permit(
      :facebook_id,
      :google_plus_id,
      :linkedin_id,
      :twitter_id,
      :youtube_id,
    )
  end
end
