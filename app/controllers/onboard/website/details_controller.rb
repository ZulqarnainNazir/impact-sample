class Onboard::Website::DetailsController < Onboard::Website::BaseController
  before_action do
    @business = current_user.authorized_businesses.find(params[:business_id])

    unless @business.location && @business.website
      redirect_to [@business, :dashboard], alert: 'No Location or Website Found'
    end
  end

  def update
    update_resource @business, details_params, context: :onboard_website_continuation, location: [:edit_onboard_website, @business, :website]
  end

  private

  def details_params
    params.require(:business).permit(
      :values,
      :history,
      :vision,
      :community_involvement,
    )
  end
end
