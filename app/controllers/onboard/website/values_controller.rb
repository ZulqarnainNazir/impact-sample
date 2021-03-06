class Onboard::Website::ValuesController < Onboard::Website::BaseController
  before_action do
    @business = current_user.authorized_businesses.find(params[:business_id])

    unless @business.location && @business.website
      redirect_to [@business, :dashboard], alert: 'No Location or Website Found'
    end
  end

  def update
    update_resource @business, values_params, context: :related_associations, location: redirect_location do |success|
      flash.notice = 'Great! Your business was successfully setup!'
    end
  end

  private

  def values_params
    params.require(:business).permit(
      :values,
      :history,
      :vision,
      :community_involvement,
    )
  end

  def redirect_location
    if @business.free?
      [@business, :dashboard]
    else
      [:edit_onboard_website, @business, :website]
    end
  end
end
